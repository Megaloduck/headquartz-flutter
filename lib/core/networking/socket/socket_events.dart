/// Lifecycle states for both server-side connections and client links.
enum SocketState {
  idle,
  connecting,
  connected,
  disconnecting,
  disconnected,
  error,
}

/// Reason for a disconnection.
class DisconnectReason {
  const DisconnectReason(this.code, this.message);
  final String code;
  final String message;

  static const peerClosed = DisconnectReason('peer_closed', 'Peer closed');
  static const localClosed = DisconnectReason('local_closed', 'Local closed');
  static const timeout =
      DisconnectReason('timeout', 'Heartbeat timeout');
  static const error = DisconnectReason('error', 'Socket error');
  static const rejected = DisconnectReason('rejected', 'Rejected by host');
}
