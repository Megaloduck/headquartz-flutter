import 'dart:async';

import 'package:uuid/uuid.dart';

import '../../../data/models/simulation/game_session.dart';
import '../../../data/models/simulation/notification.dart';
import '../../../data/models/player/player.dart';
import '../../config/department_constants.dart';
import '../../config/game_constants.dart';
import '../../simulation/economy/economy_engine.dart';
import '../../simulation/engine/command_bus.dart';
import '../../simulation/engine/commands.dart';
import '../../simulation/engine/game_state_manager.dart';
import '../../simulation/engine/simulation_clock.dart';
import '../../simulation/engine/simulation_loop.dart';
import '../../simulation/engine/tick_engine.dart';
import '../../simulation/events/random_event_engine.dart';
import '../../simulation/market/demand_engine.dart';
import '../../utils/logger.dart';
import '../packets/packet_factory.dart';
import '../packets/packet_router.dart';
import '../packets/packet_types.dart';
import '../socket/socket_events.dart';
import '../socket/socket_server.dart';
import 'discovery_service.dart';

/// Authoritative LAN host.
///
/// Owns the [GameStateManager], [SimulationLoop], and a [SocketServer].
/// Receives commands from clients, validates via the [CommandBus],
/// then broadcasts the resulting session.
class LobbyHost {
  LobbyHost({
    required this.hostName,
    required this.sessionName,
    required this.companyName,
    DiscoveryService? discovery,
  })  : _discovery = discovery ?? DiscoveryService(),
        _hostId = const Uuid().v4() {
    final session = makeStartingSession(
      id: const Uuid().v4(),
      name: sessionName,
      companyName: companyName,
    ).copyWith(players: [
      Player(
        id: _hostId,
        name: hostName,
        role: null,
        isHost: true,
        isReady: false,
      ),
    ]);
    state = GameStateManager(session);
    commands = CommandBus(state);

    final clock = const SimulationClock();
    engine = TickEngine(
      state: state,
      clock: clock,
      economy: const EconomyEngine(),
      demand: const DemandEngine(),
      events: RandomEventEngine(),
    );
    loop = SimulationLoop(engine: engine);
  }

  final String hostName;
  final String sessionName;
  final String companyName;
  final DiscoveryService _discovery;
  final String _hostId;

  late final GameStateManager state;
  late final CommandBus commands;
  late final TickEngine engine;
  late final SimulationLoop loop;
  final SocketServer _server = SocketServer();

  // sessionId (socket id) → playerId
  final Map<String, String> _sessionToPlayer = {};

  // playerId → SocketSession
  final Map<String, SocketSession> _playerToSocket = {};

  // Subscriptions kept for cleanup.
  final List<StreamSubscription<dynamic>> _subs = [];

  static const _uuid = Uuid();

  String get hostPlayerId => _hostId;
  int get port => _server.port ?? 0;

  // ── Lifecycle ──────────────────────────────────────────────────

  Future<void> start({int? preferredPort}) async {
    final port = await _server.start(preferredPort: preferredPort);
    _wireSocketEvents();

    // Push state changes to all clients with throttling at scale; for
    // LAN we just broadcast every change.
    _subs.add(state.stream.listen((s) {
      _server.broadcast(PacketFactory.fullSync(s));
    }));

    _subs.add(commands.rejected.listen((r) {
      logHost.w('Rejected command ${r.command.type}: ${r.reason}');
    }));

    await _discovery.advertise(
      name: sessionName,
      port: port,
      playerCount: state.session.players.length,
      maxPlayers: GameConstants.maxPlayers,
    );

    logHost.i('LobbyHost ready on port $port');
  }

  Future<void> stop() async {
    loop.stop();
    for (final s in _subs) {
      await s.cancel();
    }
    await _discovery.dispose();
    await _server.stop();
    await commands.dispose();
    await state.dispose();
  }

  void startGame() {
    final s = state.session;
    if (s.players.length < GameConstants.minPlayersToStart) return;
    final allReady = s.players.every((p) => p.isReady);
    if (!allReady) return;
    state.replace(s.copyWith(status: SessionStatus.running));
    loop.start();
    _server.broadcast(PacketFactory.startGame());
  }

  // ── Socket wiring ───────────────────────────────────────────────

  void _wireSocketEvents() {
    final router = PacketRouter();
    router.on(PacketKind.hello, (p) => _onHello(p, _currentSession!));
    router.on(PacketKind.selectRole,
        (p) => _onSelectRole(p, _currentSession!));
    router.on(PacketKind.ready, (p) => _onReady(p, _currentSession!));
    router.on(PacketKind.command, (p) => _onCommand(p, _currentSession!));
    router.on(PacketKind.chat, (p) => _onChat(p, _currentSession!));
    router.on(PacketKind.announcement,
        (p) => _onAnnouncement(p, _currentSession!));
    router.on(PacketKind.bye, (_) async {
      // peer is leaving; cleanup happens on close.
    });
    router.on(PacketKind.ping, (p) {
      final ts = (p.body['ts'] as num?)?.toInt() ?? 0;
      _currentSession?.send(PacketFactory.pong(ts));
    });

    _server.onConnect.listen((session) {
      _activeRouter = router;
      _bindSession(session);
    });

    _server.onDisconnect.listen((ev) => _onDisconnect(ev.session, ev.reason));
  }

  PacketRouter? _activeRouter;
  // Tiny trick: stash the "currently routing" session for handlers.
  SocketSession? _currentSession;

  void _bindSession(SocketSession session) {
    session.bytes.listen((chunk) async {
      try {
        for (final packet in session.decoder.feed(chunk)) {
          _currentSession = session;
          await _activeRouter?.dispatch(packet);
          _currentSession = null;
        }
      } catch (e, st) {
        logHost.w('Decode error from ${session.remote}', e, st);
      }
    });
  }

  // ── Packet handlers ─────────────────────────────────────────────

  Future<void> _onHello(Packet p, SocketSession session) async {
    final s = state.session;
    if (s.players.length >= GameConstants.maxPlayers) {
      session.send(PacketFactory.reject('Session is full'));
      await session.close(DisconnectReason.rejected);
      return;
    }
    if (s.status != SessionStatus.lobby) {
      session.send(PacketFactory.reject('Game already started'));
      await session.close(DisconnectReason.rejected);
      return;
    }

    final name = (p.body['name'] as String?)?.trim();
    if (name == null || name.isEmpty) {
      session.send(PacketFactory.reject('Invalid name'));
      await session.close(DisconnectReason.rejected);
      return;
    }

    final playerId = _uuid.v4();
    _sessionToPlayer[session.id] = playerId;
    _playerToSocket[playerId] = session;

    final newPlayer = Player(
      id: playerId,
      name: name,
      role: null,
      isHost: false,
    );
    state.update((g) => g.copyWith(players: [...g.players, newPlayer]));
    final updated = state.session;

    session.send(PacketFactory.welcome(
      playerId: playerId,
      session: updated,
    ));
    _server.broadcast(PacketFactory.lobbyState(
      players: updated.players,
      sessionName: updated.name,
    ));
    await _refreshAdvertisement();
  }

  Future<void> _onSelectRole(Packet p, SocketSession session) async {
    final pid = _sessionToPlayer[session.id];
    if (pid == null) return;
    final raw = p.body['role'] as String?;
    final role = RoleId.tryParse(raw);

    final s = state.session;
    final taken = s.players.any((pl) => pl.id != pid && pl.role == role);
    if (role != null && taken) {
      session.send(PacketFactory.reject('Role already taken'));
      return;
    }
    state.update((g) => g.copyWith(
          players: [
            for (final pl in g.players)
              if (pl.id == pid)
                pl.copyWith(roleSentinel: role, isReady: false)
              else
                pl,
          ],
        ));
    _broadcastLobby();
  }

  Future<void> _onReady(Packet p, SocketSession session) async {
    final pid = _sessionToPlayer[session.id];
    if (pid == null) return;
    final ready = p.body['ready'] as bool? ?? false;
    state.update((g) => g.copyWith(
          players: [
            for (final pl in g.players)
              if (pl.id == pid) pl.copyWith(isReady: ready) else pl,
          ],
        ));
    _broadcastLobby();
  }

  Future<void> _onCommand(Packet p, SocketSession session) async {
    final raw = p.body['command'];
    if (raw is! Map<String, dynamic>) return;
    try {
      final cmd = SimulationCommand.fromJson(raw);
      commands.submit(cmd);
    } catch (e, st) {
      logHost.w('Bad command', e, st);
    }
  }

  Future<void> _onChat(Packet p, SocketSession session) async {
    final pid = _sessionToPlayer[session.id];
    if (pid == null) return;
    final body = (p.body['body'] as String?)?.trim() ?? '';
    if (body.isEmpty) return;
    final pl = state.session.players.firstWhere((x) => x.id == pid);
    final msg = ChatMessage(
      id: _uuid.v4(),
      fromPlayerId: pid,
      fromName: pl.name,
      body: body,
      timestamp: DateTime.now(),
      fromRole: pl.role,
    );
    state.appendChat(msg);
  }

  Future<void> _onAnnouncement(Packet p, SocketSession session) async {
    final pid = _sessionToPlayer[session.id];
    if (pid == null) return;
    final pl = state.session.players.firstWhere((x) => x.id == pid);
    if (pl.role != RoleId.chairman) return;
    final text = (p.body['text'] as String?)?.trim() ?? '';
    if (text.isEmpty) return;
    state.appendChairmanAnnouncement(text);
  }

  void _onDisconnect(SocketSession session, DisconnectReason reason) {
    final pid = _sessionToPlayer.remove(session.id);
    if (pid == null) return;
    _playerToSocket.remove(pid);
    final s = state.session;
    if (s.status == SessionStatus.lobby) {
      // Drop the player entirely while in lobby.
      state.update((g) => g.copyWith(
            players: g.players.where((p) => p.id != pid).toList(),
          ));
      _broadcastLobby();
      _refreshAdvertisement();
    } else {
      // Mark disconnected while in-game; allow reconnect later.
      state.update((g) => g.copyWith(
            players: [
              for (final pl in g.players)
                if (pl.id == pid) pl.copyWith(isConnected: false) else pl,
            ],
          ));
    }
  }

  void _broadcastLobby() {
    final s = state.session;
    _server.broadcast(PacketFactory.lobbyState(
      players: s.players,
      sessionName: s.name,
    ));
  }

  Future<void> _refreshAdvertisement() async {
    await _discovery.advertise(
      name: state.session.name,
      port: port,
      playerCount: state.session.players.length,
      maxPlayers: GameConstants.maxPlayers,
    );
  }

  // ── Local player APIs (host UI calls these directly) ───────────

  void hostSelectRole(RoleId? role) {
    state.update((g) => g.copyWith(
          players: [
            for (final pl in g.players)
              if (pl.id == _hostId) pl.copyWith(roleSentinel: role, isReady: false) else pl,
          ],
        ));
    _broadcastLobby();
  }

  void hostSetReady(bool ready) {
    state.update((g) => g.copyWith(
          players: [
            for (final pl in g.players)
              if (pl.id == _hostId) pl.copyWith(isReady: ready) else pl,
          ],
        ));
    _broadcastLobby();
  }

  void hostSendChat(String body) {
    final pl = state.session.players.firstWhere((x) => x.id == _hostId);
    state.appendChat(ChatMessage(
      id: _uuid.v4(),
      fromPlayerId: _hostId,
      fromName: pl.name,
      body: body,
      timestamp: DateTime.now(),
      fromRole: pl.role,
    ));
  }

  void hostSubmitCommand(SimulationCommand cmd) {
    commands.submit(cmd);
  }
}
