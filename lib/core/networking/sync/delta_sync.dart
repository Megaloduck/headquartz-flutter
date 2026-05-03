import '../../../data/models/simulation/game_session.dart';

/// Computes a small delta of changed fields between two sessions.
///
/// The current host broadcasts full snapshots, which is fine for LAN.
/// This class exists so we can switch to delta sync when needed.
class DeltaSync {
  static Map<String, dynamic> diff(
      GameSession previous, GameSession current) {
    final out = <String, dynamic>{};
    if (previous.tick != current.tick) out['tick'] = current.tick;
    if (previous.gameMinute != current.gameMinute) {
      out['gameMinute'] = current.gameMinute;
    }
    if (previous.status != current.status) out['status'] = current.status.name;
    if (previous.simulationSpeed != current.simulationSpeed) {
      out['simulationSpeed'] = current.simulationSpeed;
    }
    if (previous.company.toJson().toString() !=
        current.company.toJson().toString()) {
      out['company'] = current.company.toJson();
    }
    if (previous.notifications.length != current.notifications.length) {
      out['notifications'] = current.notifications
          .take(20)
          .map((n) => n.toJson())
          .toList();
    }
    return out;
  }
}
