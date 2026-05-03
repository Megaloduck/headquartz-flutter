/// Networking / LAN constants.
class NetworkConstants {
  NetworkConstants._();

  // mDNS / Bonsoir service type
  static const String serviceType = '_headquartz._tcp';
  static const String defaultServiceName = 'Headquartz Lobby';

  // Default TCP port range to try when starting host.
  static const int defaultPort = 49152;
  static const int portRangeStart = 49152;
  static const int portRangeEnd = 49200;

  // Heartbeat
  static const Duration heartbeatInterval = Duration(seconds: 2);
  static const Duration heartbeatTimeout = Duration(seconds: 8);

  // Protocol envelope
  static const int protocolVersion = 1;
  static const int magic = 0x48515A; // "HQZ"

  // Sync
  static const Duration deltaSyncInterval = Duration(milliseconds: 100);
  static const int maxOutOfOrderPackets = 32;

  // Reconnect
  static const Duration reconnectBackoff = Duration(seconds: 1);
  static const int maxReconnectAttempts = 10;

  // Limits
  static const int maxFrameBytes = 1 << 20; // 1 MB
}
