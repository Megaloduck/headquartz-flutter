import 'dart:convert';
import 'dart:typed_data';

import 'packet_types.dart';

/// Encodes a [Packet] to a UTF-8 byte buffer using newline-delimited JSON.
///
/// Each frame is `<json>\n`. This is simple, debuggable and adequate for
/// LAN play. For higher throughput we could move to length-prefixed
/// MessagePack later — the call sites won't have to change.
class PacketEncoder {
  const PacketEncoder();

  Uint8List encode(Packet packet) {
    final str = jsonEncode(packet.toJson());
    final bytes = utf8.encode('$str\n');
    return Uint8List.fromList(bytes);
  }
}
