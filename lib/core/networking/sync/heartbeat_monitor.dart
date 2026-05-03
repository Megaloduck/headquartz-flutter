import 'dart:async';

import '../../config/network_constants.dart';
import '../packets/packet_factory.dart';
import '../socket/socket_client.dart';

/// Sends periodic ping frames over a [SocketClient] and tracks last
/// pong arrival. Disconnects if the timeout elapses with no response.
class HeartbeatMonitor {
  HeartbeatMonitor(this.client);

  final SocketClient client;
  Timer? _timer;
  DateTime? _lastPong;
  Duration? _lastRttSample;

  Duration? get lastRtt => _lastRttSample;

  void start() {
    _lastPong = DateTime.now();
    _timer = Timer.periodic(NetworkConstants.heartbeatInterval, (_) {
      client.send(PacketFactory.ping());
      final since = _lastPong == null
          ? Duration.zero
          : DateTime.now().difference(_lastPong!);
      if (since > NetworkConstants.heartbeatTimeout) {
        client.disconnect();
        stop();
      }
    });

    client.packets.listen((p) {
      if (p.kind.name == 'pong') {
        _lastPong = DateTime.now();
        final ts = (p.body['ts'] as num?)?.toInt();
        if (ts != null) {
          _lastRttSample = Duration(
              milliseconds:
                  DateTime.now().millisecondsSinceEpoch - ts);
        }
      }
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }
}
