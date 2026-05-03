import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import '../../config/network_constants.dart';
import '../../utils/logger.dart';
import '../packets/packet_decoder.dart';
import '../packets/packet_encoder.dart';
import '../packets/packet_types.dart';
import 'socket_events.dart';

/// One server-side connection to a single client.
class SocketSession {
  SocketSession({
    required this.id,
    required Socket socket,
    required this.encoder,
  })  : _socket = socket,
        decoder = PacketDecoder() {
    _socket.done.then((_) => _state = SocketState.disconnected);
  }

  final String id;
  final Socket _socket;
  final PacketEncoder encoder;
  final PacketDecoder decoder;

  SocketState _state = SocketState.connected;
  SocketState get state => _state;

  String get remote =>
      '${_socket.remoteAddress.address}:${_socket.remotePort}';

  void send(Packet packet) {
    if (_state != SocketState.connected) return;
    try {
      _socket.add(encoder.encode(packet));
    } catch (e, st) {
      logNet.w('Socket send failed', e, st);
    }
  }

  Stream<Uint8List> get bytes =>
      _socket.cast<List<int>>().map(Uint8List.fromList);

  Future<void> close([DisconnectReason reason = DisconnectReason.localClosed]) async {
    if (_state == SocketState.disconnected) return;
    _state = SocketState.disconnecting;
    try {
      await _socket.flush();
    } catch (_) {}
    try {
      await _socket.close();
    } catch (_) {}
    _state = SocketState.disconnected;
  }
}

/// Server-side TCP listener. Accepts connections and emits them as
/// [SocketSession]s. Higher layers (LobbyHost) drive packet routing.
class SocketServer {
  SocketServer({this.encoder = const PacketEncoder()});

  final PacketEncoder encoder;
  ServerSocket? _server;
  final List<SocketSession> _sessions = [];

  final _onConnect = StreamController<SocketSession>.broadcast();
  final _onDisconnect =
      StreamController<({SocketSession session, DisconnectReason reason})>.broadcast();

  Stream<SocketSession> get onConnect => _onConnect.stream;
  Stream<({SocketSession session, DisconnectReason reason})> get onDisconnect =>
      _onDisconnect.stream;

  int? get port => _server?.port;
  List<SocketSession> get sessions => List.unmodifiable(_sessions);

  Future<int> start({int? preferredPort}) async {
    final port = preferredPort ?? NetworkConstants.defaultPort;
    for (var p = port; p <= NetworkConstants.portRangeEnd; p++) {
      try {
        _server = await ServerSocket.bind(InternetAddress.anyIPv4, p, shared: false);
        logNet.i('SocketServer listening on $p');
        _accept();
        return p;
      } on SocketException {
        continue;
      }
    }
    throw StateError('No free port in range to bind socket server');
  }

  void _accept() {
    _server!.listen((socket) {
      final id = '${socket.remoteAddress.address}:${socket.remotePort}-${DateTime.now().microsecondsSinceEpoch}';
      final session = SocketSession(id: id, socket: socket, encoder: encoder);
      _sessions.add(session);
      logNet.i('Connection accepted from ${session.remote} ($id)');
      _onConnect.add(session);

      socket.done.whenComplete(() {
        _sessions.remove(session);
        _onDisconnect.add((session: session, reason: DisconnectReason.peerClosed));
      });

      socket.handleError((e, st) {
        logNet.w('Socket error from ${session.remote}', e, st);
        _sessions.remove(session);
        _onDisconnect.add((session: session, reason: DisconnectReason.error));
      });
    }, onError: (e, st) => logNet.e('ServerSocket error', e, st));
  }

  void broadcast(Packet packet) {
    for (final s in _sessions) {
      s.send(packet);
    }
  }

  void broadcastExcept(SocketSession exclude, Packet packet) {
    for (final s in _sessions) {
      if (s.id != exclude.id) s.send(packet);
    }
  }

  Future<void> stop() async {
    for (final s in [..._sessions]) {
      await s.close();
    }
    _sessions.clear();
    await _server?.close();
    _server = null;
    await _onConnect.close();
    await _onDisconnect.close();
  }
}
