import 'dart:async';

import 'packet_types.dart';

typedef PacketHandler = FutureOr<void> Function(Packet packet);

/// Maps [PacketKind] -> handler. Used by host and client receive loops.
class PacketRouter {
  final Map<PacketKind, PacketHandler> _handlers = {};
  PacketHandler? _fallback;

  void on(PacketKind kind, PacketHandler handler) {
    _handlers[kind] = handler;
  }

  void onFallback(PacketHandler handler) => _fallback = handler;

  Future<void> dispatch(Packet packet) async {
    final h = _handlers[packet.kind] ?? _fallback;
    if (h != null) await h(packet);
  }
}
