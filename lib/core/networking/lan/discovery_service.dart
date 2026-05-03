import 'dart:async';

import '../../../data/models/simulation/discovered_session.dart';
import '../../utils/logger.dart';

/// **Stub implementation** — used when the `bonsoir` package isn't
/// available (e.g. Windows native build issues).
///
/// Auto-discovery is disabled: hosts don't advertise and clients see
/// an empty session list. Manual host:port entry on the join screen
/// still works because that path bypasses discovery entirely.
class DiscoveryService {
  final _resultsCtrl = StreamController<List<DiscoveredSession>>.broadcast();
  final Map<String, DiscoveredSession> _seen = {};

  Stream<List<DiscoveredSession>> get results => _resultsCtrl.stream;
  List<DiscoveredSession> get current => _seen.values.toList(growable: false);

  Future<void> advertise({
    required String name,
    required int port,
    required int playerCount,
    required int maxPlayers,
  }) async {
    logNet.i('[stub] advertise skipped — auto-discovery disabled');
  }

  Future<void> stopAdvertising() async {}

  Future<void> startDiscovery() async {
    logNet.i('[stub] discovery skipped — use manual host:port entry');
    _emit();
  }

  Future<void> stopDiscovery() async {}

  void manuallyAdd(DiscoveredSession session) {
    _seen[session.key] = session;
    _emit();
  }

  void _emit() => _resultsCtrl.add(_seen.values.toList(growable: false));

  Future<void> dispose() async {
    await stopAdvertising();
    await stopDiscovery();
    await _resultsCtrl.close();
  }
}