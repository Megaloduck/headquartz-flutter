import 'dart:async';

import '../../../data/models/simulation/discovered_session.dart';
import 'discovery_service.dart';

/// Thin facade over [DiscoveryService] with a guaranteed broadcast
/// stream and a manual-entry helper. The lobby UI subscribes here.
class SessionBrowser {
  SessionBrowser(this._svc);
  final DiscoveryService _svc;

  Stream<List<DiscoveredSession>> get sessions => _svc.results;

  Future<void> start() => _svc.startDiscovery();
  Future<void> stop() => _svc.stopDiscovery();

  void addManual({
    required String host,
    required int port,
    String name = 'Manual Entry',
  }) {
    _svc.manuallyAdd(DiscoveredSession(
      name: name,
      host: host,
      port: port,
      playerCount: 0,
      maxPlayers: 8,
      discoveredAt: DateTime.now(),
    ));
  }
}
