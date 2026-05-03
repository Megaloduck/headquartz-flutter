import 'dart:math';

import '../../config/game_constants.dart';

/// Simulates a small number of AI-controlled competitors that fight for
/// market share via pricing pressure.
class CompetitorAi {
  CompetitorAi({Random? rng}) : _rng = rng ?? Random();

  final Random _rng;

  /// Returns market share share of competitors in [0, 1].
  /// Higher aggressiveness pushes player share down.
  double pressure(double playerPriceVsBaseline) {
    final base = GameConstants.aiCompetitorAggressiveness;
    // If our price is too high vs baseline, share shifts to AI.
    final tilt = (playerPriceVsBaseline - 1).clamp(-0.4, 0.4);
    final share = (base + tilt + (_rng.nextDouble() - 0.5) * 0.05)
        .clamp(0.05, 0.85);
    return share.toDouble();
  }
}
