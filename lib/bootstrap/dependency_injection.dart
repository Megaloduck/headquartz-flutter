import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/config/department_constants.dart';
import '../core/networking/lan/discovery_service.dart';
import '../core/networking/lan/lobby_client.dart';
import '../core/networking/lan/lobby_host.dart';
import '../core/networking/lan/session_browser.dart';
import '../core/simulation/engine/commands.dart';
import '../core/utils/logger.dart';
import '../data/models/simulation/discovered_session.dart';
import '../data/models/simulation/game_session.dart';
import '../data/models/simulation/notification.dart';
import '../data/models/player/player.dart';

// ── Discovery / browser ───────────────────────────────────────────

final discoveryServiceProvider =
    Provider<DiscoveryService>((ref) => DiscoveryService());

final sessionBrowserProvider = Provider<SessionBrowser>((ref) {
  final svc = ref.watch(discoveryServiceProvider);
  final browser = SessionBrowser(svc);
  ref.onDispose(() => svc.dispose());
  return browser;
});

final discoveredSessionsProvider =
    StreamProvider<List<DiscoveredSession>>((ref) {
  final browser = ref.watch(sessionBrowserProvider);
  return browser.sessions;
});

// ── Player identity ───────────────────────────────────────────────

class PlayerIdentity {
  const PlayerIdentity({this.name = 'Player'});
  final String name;
  PlayerIdentity copyWith({String? name}) => PlayerIdentity(name: name ?? this.name);
}

class PlayerIdentityNotifier extends Notifier<PlayerIdentity> {
  @override
  PlayerIdentity build() => const PlayerIdentity();
  void setName(String name) => state = state.copyWith(name: name);
}

final playerIdentityProvider =
    NotifierProvider<PlayerIdentityNotifier, PlayerIdentity>(
        PlayerIdentityNotifier.new);

// ── Networking session: either host or client ────────────────────

class NetworkSession {
  NetworkSession({this.host, this.client});
  final LobbyHost? host;
  final LobbyClient? client;

  bool get isHost => host != null;
  bool get isClient => client != null;
}

class NetworkSessionNotifier extends Notifier<NetworkSession?> {
  @override
  NetworkSession? build() {
    ref.onDispose(_dispose);
    return null;
  }

  Future<NetworkSession> startHost({
    required String hostName,
    required String sessionName,
    required String companyName,
  }) async {
    await endCurrent();
    final host = LobbyHost(
      hostName: hostName,
      sessionName: sessionName,
      companyName: companyName,
    );
    await host.start();
    final ns = NetworkSession(host: host);
    state = ns;
    return ns;
  }

  Future<NetworkSession> joinClient({
    required String playerName,
    required String host,
    required int port,
  }) async {
    await endCurrent();
    final client = LobbyClient(playerName: playerName);
    await client.connect(host, port);
    final ns = NetworkSession(client: client);
    state = ns;
    return ns;
  }

  Future<void> endCurrent() async {
    final s = state;
    if (s == null) return;
    try {
      await s.host?.stop();
    } catch (e, st) {
      logUi.w('Error stopping host', e, st);
    }
    try {
      await s.client?.dispose();
    } catch (e, st) {
      logUi.w('Error disposing client', e, st);
    }
    state = null;
  }

  void _dispose() {
    final s = state;
    s?.host?.stop();
    s?.client?.dispose();
  }
}

final networkSessionProvider =
    NotifierProvider<NetworkSessionNotifier, NetworkSession?>(
        NetworkSessionNotifier.new);

// ── Live game session stream (host-driven or client-mirrored) ────

final gameSessionProvider = StreamProvider<GameSession?>((ref) {
  final ns = ref.watch(networkSessionProvider);
  if (ns == null) return Stream.value(null);
  if (ns.isHost) return ns.host!.state.stream;
  return ns.client!.sessions;
});

final currentSessionProvider = Provider<GameSession?>((ref) {
  return ref.watch(gameSessionProvider).maybeWhen(
        data: (v) => v,
        orElse: () => null,
      );
});

// ── Local player ID ──────────────────────────────────────────────

final localPlayerIdProvider = Provider<String?>((ref) {
  final ns = ref.watch(networkSessionProvider);
  if (ns == null) return null;
  if (ns.isHost) return ns.host!.hostPlayerId;
  return ns.client!.playerId;
});

final localPlayerProvider = Provider<Player?>((ref) {
  final session = ref.watch(currentSessionProvider);
  final id = ref.watch(localPlayerIdProvider);
  if (session == null || id == null) return null;
  for (final p in session.players) {
    if (p.id == id) return p;
  }
  return null;
});

// ── Command dispatch ─────────────────────────────────────────────

final commandDispatcherProvider = Provider<CommandDispatcher>((ref) {
  return CommandDispatcher(ref);
});

class CommandDispatcher {
  CommandDispatcher(this.ref);
  final Ref ref;

  void send(SimulationCommand cmd) {
    final ns = ref.read(networkSessionProvider);
    if (ns == null) return;
    if (ns.isHost) {
      ns.host!.hostSubmitCommand(cmd);
    } else {
      ns.client!.sendCommand(cmd);
    }
  }
}

// ── Lobby actions (role/ready/chat) ──────────────────────────────

final lobbyActionsProvider = Provider<LobbyActions>((ref) {
  return LobbyActions(ref);
});

class LobbyActions {
  LobbyActions(this.ref);
  final Ref ref;

  void selectRole(RoleId? role) {
    final ns = ref.read(networkSessionProvider);
    if (ns == null) return;
    if (ns.isHost) {
      ns.host!.hostSelectRole(role);
    } else {
      ns.client!.selectRole(role);
    }
  }

  void setReady(bool ready) {
    final ns = ref.read(networkSessionProvider);
    if (ns == null) return;
    if (ns.isHost) {
      ns.host!.hostSetReady(ready);
    } else {
      ns.client!.setReady(ready);
    }
  }

  void startGame() {
    final ns = ref.read(networkSessionProvider);
    if (ns == null || !ns.isHost) return;
    ns.host!.startGame();
  }

  void sendChat(String body) {
    final ns = ref.read(networkSessionProvider);
    if (ns == null) return;
    if (ns.isHost) {
      ns.host!.hostSendChat(body);
    } else {
      ns.client!.sendChat(body);
    }
  }

  void sendAnnouncement(String text) {
    final ns = ref.read(networkSessionProvider);
    if (ns == null) return;
    if (ns.isHost) {
      ns.host!.state.appendChairmanAnnouncement(text);
    } else {
      ns.client!.sendAnnouncement(text);
    }
  }
}
