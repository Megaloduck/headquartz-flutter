import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import '../../utils/logger.dart';
import '../packets/packet_decoder.dart';
import '../packets/packet_encoder.dart';
import '../packets/packet_types.dart';
import 'socket_events.dart';

/// Client-side TCP link to the host.
class SocketClient {
  SocketClient({
    this.encoder = const PacketEncoder(),
  });

  final PacketEncoder encoder;
  final PacketDecoder decoder = PacketDecoder();
  Socket? _socket;
  SocketState _state = SocketState.idle;

  final _packets = StreamController<Packet>.broadcast();
  final _states = StreamController<SocketState>.broadcast();

  Stream<Packet> get packets => _packets.stream;
  Stream<SocketState> get states => _states.stream;
  SocketState get state => _state;

  Future<void> connect(String host, int port,
      {Duration timeout = const Duration(seconds: 6)}) async {
    if (_state == SocketState.connected || _state == SocketState.connecting) {
      return;
    }
    _setState(SocketState.connecting);
    try {
      _socket = await Socket.connect(host, port, timeout: timeout);
      _socket!.setOption(SocketOption.tcpNoDelay, true);
      _setState(SocketState.connected);
      _socket!
          .cast<List<int>>()
          .map(Uint8List.fromList)
          .listen(_onBytes,
              onError: _onSocketError,
              onDone: _onSocketDone,
              cancelOnError: true);
      logNet.i('SocketClient connected to $host:$port');
    } catch (e, st) {
      logNet.w('SocketClient connect failed', e, st);
      _setState(SocketState.error);
      rethrow;
    }
  }

  void send(Packet packet) {
    if (_state != SocketState.connected) return;
    try {
      _socket!.add(encoder.encode(packet));
    } catch (e, st) {
      logNet.w('Socket send failed', e, st);
    }
  }

  void _onBytes(Uint8List chunk) {
    try {
      for (final p in decoder.feed(chunk)) {
        _packets.add(p);
      }
    } catch (e, st) {
      logNet.w('Decode error', e, st);
    }
  }

  void _onSocketError(Object e, StackTrace st) {
    logNet.w('SocketClient error', e, st);
    _setState(SocketState.error);
    _close();
  }

  void _onSocketDone() {
    logNet.i('SocketClient peer closed');
    _setState(SocketState.disconnected);
    _close();
  }

  Future<void> disconnect() async {
    if (_state == SocketState.disconnected || _state == SocketState.idle) return;
    _setState(SocketState.disconnecting);
    await _close();
  }

  Future<void> _close() async {
    try {
      await _socket?.flush();
    } catch (_) {}
    try {
      await _socket?.close();
    } catch (_) {}
    _socket = null;
    if (_state != SocketState.error) {
      _setState(SocketState.disconnected);
    }
  }

  void _setState(SocketState s) {
    _state = s;
    _states.add(s);
  }

  Future<void> dispose() async {
    await disconnect();
    await _packets.close();
    await _states.close();
  }
}
