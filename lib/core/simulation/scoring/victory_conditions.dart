import '../../../data/models/company/company.dart';
import '../../../data/models/simulation/game_session.dart';
import '../../config/game_constants.dart';

/// Pure checks for end-of-game conditions.
class VictoryConditions {
  const VictoryConditions();

  SessionEndReason check(Company co) {
    if (co.cash + co.equity - co.debt <= GameConstants.bankruptcyThreshold) {
      return SessionEndReason.bankruptcy;
    }
    if (co.netWorth >= GameConstants.victoryNetWorth) {
      return SessionEndReason.victory;
    }
    return SessionEndReason.none;
  }
}
