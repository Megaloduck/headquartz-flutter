import 'dart:async';

import '../../../data/models/company/company.dart';
import '../../../data/models/simulation/game_session.dart';
import '../../../data/models/simulation/notification.dart';
import 'package:uuid/uuid.dart';

/// Holds the single authoritative [GameSession] state.
///
/// All state mutations flow through here so we get one consistent stream
/// of updates that can be synced to clients.
class GameStateManager {
  GameStateManager(this._session);

  GameSession _session;
  final _ctrl = StreamController<GameSession>.broadcast();
  static const _uuid = Uuid();

  GameSession get session => _session;
  Stream<GameSession> get stream => _ctrl.stream;

  void replace(GameSession next) {
    _session = next;
    _ctrl.add(_session);
  }

  void update(GameSession Function(GameSession) f) {
    replace(f(_session));
  }

  void updateCompany(Company Function(Company) f) {
    replace(_session.copyWith(company: f(_session.company)));
  }

  void appendNotification(GameNotification n) {
    final list = [n, ..._session.notifications];
    if (list.length > 200) list.removeLast();
    replace(_session.copyWith(notifications: list));
  }

  void appendChat(ChatMessage m) {
    final list = [..._session.chat, m];
    if (list.length > 500) list.removeAt(0);
    replace(_session.copyWith(chat: list));
  }

  void appendChairmanAnnouncement(String body) {
    appendNotification(GameNotification(
      id: _uuid.v4(),
      title: 'Chairman Announcement',
      body: body,
      severity: NotificationSeverity.info,
      timestamp: DateTime.now(),
      gameMinute: _session.gameMinute,
    ));
  }

  void togglePause() {
    final next = _session.status == SessionStatus.running
        ? SessionStatus.paused
        : SessionStatus.running;
    replace(_session.copyWith(status: next));
  }

  void setSpeed(double speed) {
    replace(_session.copyWith(simulationSpeed: speed.clamp(0.25, 8.0)));
  }

  Future<void> dispose() => _ctrl.close();
}
