import 'dart:convert';
import 'dart:typed_data';

import '../../config/network_constants.dart';
import 'packet_types.dart';

/// Stateful newline-delimited JSON decoder.
///
/// TCP doesn't preserve message boundaries, so we accumulate received
/// bytes and split them on `\n` to recover packet frames.
class PacketDecoder {
  PacketDecoder();

  final List<int> _buffer = [];

  /// Feed bytes from a TCP read; emits zero or more complete [Packet]s.
  Iterable<Packet> feed(Uint8List chunk) sync* {
    _buffer.addAll(chunk);
    if (_buffer.length > NetworkConstants.maxFrameBytes) {
      _buffer.clear();
      throw StateError('Frame buffer overflow');
    }

    while (true) {
      final idx = _buffer.indexOf(0x0A); // '\n'
      if (idx < 0) break;
      final raw = _buffer.sublist(0, idx);
      _buffer.removeRange(0, idx + 1);
      if (raw.isEmpty) continue;
      try {
        final str = utf8.decode(raw);
        final json = jsonDecode(str) as Map<String, dynamic>;
        yield Packet.fromJson(json);
      } catch (_) {
        // Drop malformed frames silently; could surface metric here.
      }
    }
  }

  void reset() => _buffer.clear();
}
