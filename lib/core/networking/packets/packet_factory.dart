import '../../../data/models/simulation/game_session.dart';
import '../../../data/models/simulation/notification.dart';
import '../../../data/models/player/player.dart';
import '../../config/department_constants.dart';
import 'packet_types.dart';

/// Convenience builders so call sites don't deal with map keys.
class PacketFactory {
  PacketFactory._();

  static Packet hello(String name, {String? clientUuid}) => Packet(
        kind: PacketKind.hello,
        body: HelloBody.build(playerName: name, clientUuid: clientUuid),
      );

  static Packet welcome({
    required String playerId,
    required GameSession session,
  }) =>
      Packet(
        kind: PacketKind.welcome,
        body: WelcomeBody.build(playerId: playerId, session: session),
      );

  static Packet reject(String reason) => Packet(
        kind: PacketKind.reject,
        body: RejectBody.build(reason: reason),
      );

  static Packet lobbyState({
    required List<Player> players,
    required String sessionName,
  }) =>
      Packet(
        kind: PacketKind.lobbyState,
        body: LobbyStateBody.build(
          players: players,
          sessionName: sessionName,
        ),
      );

  static Packet selectRole(RoleId? role) => Packet(
        kind: PacketKind.selectRole,
        body: SelectRoleBody.build(role: role),
      );

  static Packet ready(bool ready) => Packet(
        kind: PacketKind.ready,
        body: ReadyBody.build(ready: ready),
      );

  static Packet startGame() =>
      const Packet(kind: PacketKind.startGame, body: {});

  static Packet command(Map<String, dynamic> cmd) => Packet(
        kind: PacketKind.command,
        body: CommandBody.build(cmd),
      );

  static Packet fullSync(GameSession session) => Packet(
        kind: PacketKind.fullSync,
        body: FullSyncBody.build(session),
      );

  static Packet deltaSync(Map<String, dynamic> delta) => Packet(
        kind: PacketKind.deltaSync,
        body: DeltaSyncBody.build(delta),
      );

  static Packet chat(String body) =>
      Packet(kind: PacketKind.chat, body: ChatBody.build(body: body));

  static Packet notification(GameNotification n) => Packet(
        kind: PacketKind.notification,
        body: NotificationBody.build(n),
      );

  static Packet announcement(String text) => Packet(
        kind: PacketKind.announcement,
        body: AnnouncementBody.build(text: text),
      );

  static Packet ping() => Packet(
        kind: PacketKind.ping,
        body: PingBody.build(ts: DateTime.now().millisecondsSinceEpoch),
      );

  static Packet pong(int ts) =>
      Packet(kind: PacketKind.pong, body: PongBody.build(ts: ts));

  static Packet bye([String reason = '']) =>
      Packet(kind: PacketKind.bye, body: ByeBody.build(reason: reason));

  static Packet ended(String reason) => Packet(
        kind: PacketKind.ended,
        body: EndedBody.build(reason: reason),
      );
}
