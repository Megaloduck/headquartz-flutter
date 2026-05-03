import '../../../core/config/department_constants.dart';
import '../company/company.dart';
import 'entities.dart';
import 'notification.dart';
import '../player/player.dart';

enum SessionStatus { lobby, running, paused, ended }
enum SessionEndReason { none, victory, bankruptcy, hostQuit }

/// The full authoritative session — everything the host owns.
class GameSession {
  const GameSession({
    required this.id,
    required this.name,
    required this.players,
    required this.company,
    required this.status,
    required this.tick,
    required this.gameMinute,
    required this.notifications,
    required this.chat,
    required this.orders,
    required this.shipments,
    this.endReason = SessionEndReason.none,
    this.simulationSpeed = 1.0,
  });

  final String id;
  final String name;
  final List<Player> players;
  final Company company;
  final SessionStatus status;
  final int tick;
  final int gameMinute;
  final List<GameNotification> notifications;
  final List<ChatMessage> chat;
  final List<CustomerOrder> orders;
  final List<Shipment> shipments;
  final SessionEndReason endReason;
  final double simulationSpeed;

  Player? playerByRole(RoleId role) => players
      .cast<Player?>()
      .firstWhere((p) => p?.role == role, orElse: () => null);

  Player? get host =>
      players.cast<Player?>().firstWhere((p) => p!.isHost, orElse: () => null);

  GameSession copyWith({
    String? name,
    List<Player>? players,
    Company? company,
    SessionStatus? status,
    int? tick,
    int? gameMinute,
    List<GameNotification>? notifications,
    List<ChatMessage>? chat,
    List<CustomerOrder>? orders,
    List<Shipment>? shipments,
    SessionEndReason? endReason,
    double? simulationSpeed,
  }) =>
      GameSession(
        id: id,
        name: name ?? this.name,
        players: players ?? this.players,
        company: company ?? this.company,
        status: status ?? this.status,
        tick: tick ?? this.tick,
        gameMinute: gameMinute ?? this.gameMinute,
        notifications: notifications ?? this.notifications,
        chat: chat ?? this.chat,
        orders: orders ?? this.orders,
        shipments: shipments ?? this.shipments,
        endReason: endReason ?? this.endReason,
        simulationSpeed: simulationSpeed ?? this.simulationSpeed,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'players': players.map((p) => p.toJson()).toList(),
        'company': company.toJson(),
        'status': status.name,
        'tick': tick,
        'gameMinute': gameMinute,
        'notifications': notifications.map((n) => n.toJson()).toList(),
        'chat': chat.map((c) => c.toJson()).toList(),
        'orders': orders.map((o) => o.toJson()).toList(),
        'shipments': shipments.map((s) => s.toJson()).toList(),
        'endReason': endReason.name,
        'simulationSpeed': simulationSpeed,
      };

  static GameSession fromJson(Map<String, dynamic> json) => GameSession(
        id: json['id'] as String,
        name: json['name'] as String,
        players: (json['players'] as List<dynamic>)
            .map((p) => Player.fromJson(p as Map<String, dynamic>))
            .toList(),
        company: Company.fromJson(json['company'] as Map<String, dynamic>),
        status: SessionStatus.values
            .firstWhere((s) => s.name == json['status']),
        tick: json['tick'] as int,
        gameMinute: json['gameMinute'] as int,
        notifications: (json['notifications'] as List<dynamic>)
            .map((n) => GameNotification.fromJson(n as Map<String, dynamic>))
            .toList(),
        chat: (json['chat'] as List<dynamic>)
            .map((c) => ChatMessage.fromJson(c as Map<String, dynamic>))
            .toList(),
        orders: (json['orders'] as List<dynamic>)
            .map((o) => CustomerOrder.fromJson(o as Map<String, dynamic>))
            .toList(),
        shipments: (json['shipments'] as List<dynamic>)
            .map((s) => Shipment.fromJson(s as Map<String, dynamic>))
            .toList(),
        endReason: SessionEndReason.values
            .firstWhere((s) => s.name == json['endReason']),
        simulationSpeed:
            (json['simulationSpeed'] as num?)?.toDouble() ?? 1.0,
      );
}
