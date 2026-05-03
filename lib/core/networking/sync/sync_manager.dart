import 'dart:async';

import '../../../data/models/simulation/game_session.dart';
import '../../simulation/engine/game_state_manager.dart';
import '../packets/packet_factory.dart';
import '../socket/socket_server.dart';

/// Central place to coordinate state→wire distribution. The current
/// implementation broadcasts full sync packets at every state change.
/// Future: replace with delta calculation via [DeltaSync].
class SyncManager {
  SyncManager(this.state, this.server);

  final GameStateManager state;
  final SocketServer server;

  StreamSubscription<GameSession>? _sub;

  void start() {
    _sub = state.stream.listen((s) {
      server.broadcast(PacketFactory.fullSync(s));
    });
  }

  Future<void> stop() async {
    await _sub?.cancel();
    _sub = null;
  }
}
