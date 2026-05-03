import '../../../core/config/department_constants.dart';

enum NotificationSeverity { info, success, warning, danger }

class GameNotification {
  GameNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.severity,
    required this.timestamp,
    this.fromRole,
    this.toRole,
    this.gameMinute,
  });

  final String id;
  final String title;
  final String body;
  final NotificationSeverity severity;
  final DateTime timestamp;
  final RoleId? fromRole;
  final RoleId? toRole;
  final int? gameMinute;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'severity': severity.name,
        'timestamp': timestamp.toIso8601String(),
        'fromRole': fromRole?.key,
        'toRole': toRole?.key,
        'gameMinute': gameMinute,
      };

  static GameNotification fromJson(Map<String, dynamic> json) =>
      GameNotification(
        id: json['id'] as String,
        title: json['title'] as String,
        body: json['body'] as String,
        severity: NotificationSeverity.values
            .firstWhere((s) => s.name == json['severity']),
        timestamp: DateTime.parse(json['timestamp'] as String),
        fromRole: RoleId.tryParse(json['fromRole'] as String?),
        toRole: RoleId.tryParse(json['toRole'] as String?),
        gameMinute: json['gameMinute'] as int?,
      );
}

class ChatMessage {
  ChatMessage({
    required this.id,
    required this.fromPlayerId,
    required this.fromName,
    required this.body,
    required this.timestamp,
    this.fromRole,
  });

  final String id;
  final String fromPlayerId;
  final String fromName;
  final String body;
  final DateTime timestamp;
  final RoleId? fromRole;

  Map<String, dynamic> toJson() => {
        'id': id,
        'fromPlayerId': fromPlayerId,
        'fromName': fromName,
        'body': body,
        'timestamp': timestamp.toIso8601String(),
        'fromRole': fromRole?.key,
      };

  static ChatMessage fromJson(Map<String, dynamic> json) => ChatMessage(
        id: json['id'] as String,
        fromPlayerId: json['fromPlayerId'] as String,
        fromName: json['fromName'] as String,
        body: json['body'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
        fromRole: RoleId.tryParse(json['fromRole'] as String?),
      );
}
