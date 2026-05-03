import '../../../data/models/simulation/game_session.dart';

/// Helpers for snapshotting / restoring session state on reconnect.
/// The current host already returns a full sync to reconnecting peers,
/// so this class is a small ergonomic wrapper.
class StateRecovery {
  static GameSession resnapshot(GameSession s) => s;
}
