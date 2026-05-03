import 'dart:async';

import 'package:bonsoir/bonsoir.dart';

import '../../../data/models/simulation/discovered_session.dart';
import '../../config/network_constants.dart';
import '../../utils/logger.dart';

/// Wraps Bonsoir to advertise/discover Headquartz sessions on the LAN.
///
/// On platforms / networks where mDNS doesn't propagate, players can
/// still join via direct host:port input. This service is best-effort.
class DiscoveryService {
  BonsoirBroadcast? _broadcast;
  BonsoirDiscovery? _discovery;
  StreamSubscription<BonsoirDiscoveryEvent>? _discoSub;

  final _resultsCtrl = StreamController<List<DiscoveredSession>>.broadcast();
  final Map<String, DiscoveredSession> _seen = {};

  Stream<List<DiscoveredSession>> get results => _resultsCtrl.stream;
  List<DiscoveredSession> get current => _seen.values.toList(growable: false);

  // ── Host advertise ──────────────────────────────────────────────
  Future<void> advertise({
    required String name,
    required int port,
    required int playerCount,
    required int maxPlayers,
  }) async {
    await stopAdvertising();
    final service = BonsoirService(
      name: name,
      type: NetworkConstants.serviceType,
      port: port,
      attributes: {
        'players': '$playerCount',
        'max': '$maxPlayers',
        'v': '${NetworkConstants.protocolVersion}',
      },
    );
    _broadcast = BonsoirBroadcast(service: service);
    try {
      await _broadcast!.ready;
      await _broadcast!.start();
      logNet.i('Advertising "$name" on port $port');
    } catch (e, st) {
      logNet.w('Advertise failed', e, st);
    }
  }

  Future<void> stopAdvertising() async {
    try {
      await _broadcast?.stop();
    } catch (_) {}
    _broadcast = null;
  }

  // ── Client discovery ────────────────────────────────────────────
  Future<void> startDiscovery() async {
    await stopDiscovery();
    _seen.clear();
    _emit();

    _discovery = BonsoirDiscovery(type: NetworkConstants.serviceType);
    try {
      await _discovery!.ready;
      await _discovery!.start();
      _discoSub = _discovery!.eventStream?.listen(_onEvent);
      logNet.i('Discovery started');
    } catch (e, st) {
      logNet.w('Discovery start failed', e, st);
    }
  }

  Future<void> stopDiscovery() async {
    try {
      await _discoSub?.cancel();
      await _discovery?.stop();
    } catch (_) {}
    _discoSub = null;
    _discovery = null;
  }

  void _onEvent(BonsoirDiscoveryEvent ev) {
    final s = ev.service;
    if (s == null) return;
    if (ev.type == BonsoirDiscoveryEventType.discoveryServiceResolved) {
      final attr = s.attributes;
      final players = int.tryParse(attr['players'] ?? '0') ?? 0;
      final max = int.tryParse(attr['max'] ?? '8') ?? 8;
      final v = int.tryParse(attr['v'] ?? '1') ?? 1;
      String? host;
      try {
        host = (s.toJson()['service.host'] as String?) ??
            (s.toJson()['host'] as String?);
      } catch (_) {}
      if (host == null) return;
      final session = DiscoveredSession(
        name: s.name,
        host: host,
        port: s.port,
        playerCount: players,
        maxPlayers: max,
        protocolVersion: v,
        discoveredAt: DateTime.now(),
      );
      _seen[session.key] = session;
      _emit();
    } else if (ev.type == BonsoirDiscoveryEventType.discoveryServiceLost) {
      _seen.removeWhere((k, v) => v.name == s.name && v.port == s.port);
      _emit();
    }
  }

  void _emit() {
    _resultsCtrl.add(_seen.values.toList(growable: false));
  }

  /// Manually inject a session (when user types host:port directly).
  void manuallyAdd(DiscoveredSession session) {
    _seen[session.key] = session;
    _emit();
  }

  Future<void> dispose() async {
    await stopAdvertising();
    await stopDiscovery();
    await _resultsCtrl.close();
  }
}
