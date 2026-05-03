/// A LAN session announcement received via mDNS / Bonsoir.
class DiscoveredSession {
  const DiscoveredSession({
    required this.name,
    required this.host,
    required this.port,
    required this.playerCount,
    required this.maxPlayers,
    required this.discoveredAt,
    this.protocolVersion = 1,
    this.requiresPassword = false,
  });

  final String name;
  final String host;
  final int port;
  final int playerCount;
  final int maxPlayers;
  final DateTime discoveredAt;
  final int protocolVersion;
  final bool requiresPassword;

  String get key => '$host:$port';
  bool get isFull => playerCount >= maxPlayers;
}
