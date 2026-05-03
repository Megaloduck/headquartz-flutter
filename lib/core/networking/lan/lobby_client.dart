import 'dart:async';

import '../../../data/models/simulation/game_session.dart';
import '../../../data/models/simulation/notification.dart';
import '../../../data/models/player/player.dart';
import '../../config/department_constants.dart';
import '../../simulation/engine/commands.dart';
import '../../utils/logger.dart';
import '../packets/packet_factory.dart';
import '../packets/packet_router.dart';
import '../packets/packet_types.dart';
import '../socket/socket_client.dart';
import '../socket/socket_events.dart';

/// Client-side mirror of an authoritative session.
///
/// Receives full sync packets from the host and exposes them as a
/// stream that the UI can subscribe to. Sends commands, ready toggles,
/// and chat messages over the wire.
class LobbyClient {
  LobbyClient({required this.playerName});

  final String playerName;
  final SocketClient _socket = SocketClient();

  String? _playerId;
  String? get playerId => _playerId;

  GameSession? _lastSession;
  GameSession? get session => _lastSession;

  final _sessionCtrl = StreamController<GameSession>.broadcast();
  final _eventsCtrl = StreamController<LobbyEvent>.broadcast();

  Stream<GameSession> get sessions => _sessionCtrl.stream;
  Stream<LobbyEvent> get events => _eventsCtrl.stream;
  Stream<SocketState> get socketStates => _socket.states;
  SocketState get socketState => _socket.state;

  Future<void> connect(String host, int port) async {
    final router = PacketRouter()
      ..on(PacketKind.welcome, (p) async {
        _playerId = p.body['playerId'] as String?;
        final s = GameSession.fromJson(
            (p.body['session'] as Map).cast<String, dynamic>());
        _emit(s);
      })
      ..on(PacketKind.reject, (p) async {
        _eventsCtrl.add(LobbyEvent.rejected(
            (p.body['reason'] as String?) ?? 'Rejected'));
        await _socket.disconnect();
      })
      ..on(PacketKind.lobbyState, (p) async {
        // Lobby-only update — keep current session shape, swap players.
        final base = _lastSession;
        if (base == null) return;
        final players = (p.body['players'] as List<dynamic>)
            .map((j) => Player.fromJson((j as Map).cast<String, dynamic>()))
            .toList();
        final name = p.body['sessionName'] as String? ?? base.name;
        _emit(base.copyWith(name: name, players: players));
      })
      ..on(PacketKind.fullSync, (p) async {
        final s = GameSession.fromJson(
            (p.body['session'] as Map).cast<String, dynamic>());
        _emit(s);
      })
      ..on(PacketKind.startGame, (_) async {
        _eventsCtrl.add(const LobbyEvent.gameStarted());
      })
      ..on(PacketKind.notification, (p) async {
        try {
          final n = GameNotification.fromJson(
              (p.body['notification'] as Map).cast<String, dynamic>());
          _eventsCtrl.add(LobbyEvent.notification(n));
        } catch (e, st) {
          logClient.w('Bad notification packet', e, st);
        }
      })
      ..on(PacketKind.ended, (p) async {
        _eventsCtrl.add(LobbyEvent.ended(
            (p.body['reason'] as String?) ?? 'ended'));
      });

    _socket.packets.listen((pkt) async => router.dispatch(pkt));
    await _socket.connect(host, port);
    _socket.send(PacketFactory.hello(playerName));
  }

  void _emit(GameSession s) {
    _lastSession = s;
    _sessionCtrl.add(s);
  }

  // ── Outgoing helpers ────────────────────────────────────────────

  void selectRole(RoleId? role) {
    _socket.send(PacketFactory.selectRole(role));
  }

  void setReady(bool ready) {
    _socket.send(PacketFactory.ready(ready));
  }

  void sendChat(String body) {
    if (body.trim().isEmpty) return;
    _socket.send(PacketFactory.chat(body.trim()));
  }

  void sendCommand(SimulationCommand cmd) {
    _socket.send(PacketFactory.command(cmd.toJson()));
  }

  void sendAnnouncement(String text) {
    _socket.send(PacketFactory.announcement(text));
  }

  Future<void> disconnect() async {
    _socket.send(PacketFactory.bye());
    await _socket.disconnect();
  }

  Future<void> dispose() async {
    await disconnect();
    await _sessionCtrl.close();
    await _eventsCtrl.close();
    await _socket.dispose();
  }
}

/// Out-of-band events surfaced to UI from the client.
sealed class LobbyEvent {
  const LobbyEvent();

  const factory LobbyEvent.rejected(String reason) = LobbyRejected;
  const factory LobbyEvent.gameStarted() = LobbyGameStarted;
  const factory LobbyEvent.ended(String reason) = LobbyEnded;
  const factory LobbyEvent.notification(GameNotification n) =
      LobbyNotification;
}

class LobbyRejected extends LobbyEvent {
  const LobbyRejected(this.reason);
  final String reason;
}

class LobbyGameStarted extends LobbyEvent {
  const LobbyGameStarted();
}

class LobbyEnded extends LobbyEvent {
  const LobbyEnded(this.reason);
  final String reason;
}

class LobbyNotification extends LobbyEvent {
  const LobbyNotification(this.n);
  final GameNotification n;
}
