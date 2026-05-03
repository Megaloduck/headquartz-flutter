import '../../../data/models/simulation/notification.dart';
import '../../../data/models/player/player.dart';
import '../../../data/models/simulation/game_session.dart';
import '../../config/department_constants.dart';

/// Wire-level message kinds. Stable strings keep the protocol forward-
/// compatible across versions.
enum PacketKind {
  // ── Lobby / handshake ───────────────────────────────────────────
  hello, // client -> host
  welcome, // host -> client (assigns playerId)
  reject, // host -> client (kicks with reason)

  // ── Lobby state ─────────────────────────────────────────────────
  lobbyState, // host -> all
  selectRole, // client -> host
  ready, // client -> host
  startGame, // host -> all (also command to begin)

  // ── Simulation ──────────────────────────────────────────────────
  command, // client -> host
  fullSync, // host -> client (entire session)
  deltaSync, // host -> all (changed fields only)

  // ── Realtime side-channels ──────────────────────────────────────
  chat, // any -> host -> all
  notification, // host -> all
  announcement, // chairman -> host -> all

  // ── Heartbeat / liveness ────────────────────────────────────────
  ping,
  pong,

  // ── Termination ─────────────────────────────────────────────────
  bye,
  ended,
}

/// Wire envelope for any packet.
class Packet {
  const Packet({
    required this.kind,
    required this.body,
    this.protocolVersion = 1,
  });

  final PacketKind kind;
  final Map<String, dynamic> body;
  final int protocolVersion;

  Map<String, dynamic> toJson() => {
        'v': protocolVersion,
        'k': kind.name,
        'b': body,
      };

  static Packet fromJson(Map<String, dynamic> json) => Packet(
        protocolVersion: json['v'] as int? ?? 1,
        kind: PacketKind.values.firstWhere((k) => k.name == json['k']),
        body: (json['b'] as Map).cast<String, dynamic>(),
      );
}

// ── Helpers for typed packet construction ────────────────────────

class HelloBody {
  static Map<String, dynamic> build({
    required String playerName,
    required String? clientUuid,
  }) =>
      {
        'name': playerName,
        if (clientUuid != null) 'clientUuid': clientUuid,
      };
}

class WelcomeBody {
  static Map<String, dynamic> build({
    required String playerId,
    required GameSession session,
  }) =>
      {
        'playerId': playerId,
        'session': session.toJson(),
      };
}

class RejectBody {
  static Map<String, dynamic> build({required String reason}) =>
      {'reason': reason};
}

class LobbyStateBody {
  static Map<String, dynamic> build({
    required List<Player> players,
    required String sessionName,
  }) =>
      {
        'sessionName': sessionName,
        'players': players.map((p) => p.toJson()).toList(),
      };
}

class SelectRoleBody {
  static Map<String, dynamic> build({required RoleId? role}) =>
      {'role': role?.key};
}

class ReadyBody {
  static Map<String, dynamic> build({required bool ready}) =>
      {'ready': ready};
}

class CommandBody {
  static Map<String, dynamic> build(Map<String, dynamic> command) =>
      {'command': command};
}

class FullSyncBody {
  static Map<String, dynamic> build(GameSession session) =>
      {'session': session.toJson()};
}

class DeltaSyncBody {
  static Map<String, dynamic> build(Map<String, dynamic> delta) => delta;
}

class ChatBody {
  static Map<String, dynamic> build({
    required String body,
  }) =>
      {'body': body};
}

class NotificationBody {
  static Map<String, dynamic> build(GameNotification n) =>
      {'notification': n.toJson()};
}

class AnnouncementBody {
  static Map<String, dynamic> build({required String text}) =>
      {'text': text};
}

class PingBody {
  static Map<String, dynamic> build({required int ts}) => {'ts': ts};
}

class PongBody {
  static Map<String, dynamic> build({required int ts}) => {'ts': ts};
}

class ByeBody {
  static Map<String, dynamic> build({String reason = ''}) => {'reason': reason};
}

class EndedBody {
  static Map<String, dynamic> build({required String reason}) =>
      {'reason': reason};
}
