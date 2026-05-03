import '../../../core/config/department_constants.dart';

/// Player participating in a session.
class Player {
  Player({
    required this.id,
    required this.name,
    required this.role,
    this.isHost = false,
    this.isReady = false,
    this.isConnected = true,
    this.color = 0xFF3DA9FC,
    this.lastSeen,
  });

  final String id;
  final String name;
  final RoleId? role;
  final bool isHost;
  final bool isReady;
  final bool isConnected;
  final int color;
  final DateTime? lastSeen;

  Player copyWith({
    String? id,
    String? name,
    RoleId? role,
    Object? roleSentinel = _kSentinel,
    bool? isHost,
    bool? isReady,
    bool? isConnected,
    int? color,
    DateTime? lastSeen,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      role: identical(roleSentinel, _kSentinel) ? (role ?? this.role) : roleSentinel as RoleId?,
      isHost: isHost ?? this.isHost,
      isReady: isReady ?? this.isReady,
      isConnected: isConnected ?? this.isConnected,
      color: color ?? this.color,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'role': role?.key,
        'isHost': isHost,
        'isReady': isReady,
        'isConnected': isConnected,
        'color': color,
        'lastSeen': lastSeen?.toIso8601String(),
      };

  static Player fromJson(Map<String, dynamic> json) => Player(
        id: json['id'] as String,
        name: json['name'] as String,
        role: RoleId.tryParse(json['role'] as String?),
        isHost: json['isHost'] as bool? ?? false,
        isReady: json['isReady'] as bool? ?? false,
        isConnected: json['isConnected'] as bool? ?? true,
        color: json['color'] as int? ?? 0xFF3DA9FC,
        lastSeen: json['lastSeen'] == null
            ? null
            : DateTime.tryParse(json['lastSeen'] as String),
      );
}

const Object _kSentinel = Object();
