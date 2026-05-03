/// Computes adjustments to company reputation.
class ReputationEngine {
  const ReputationEngine();

  /// Quality bonus applied as a delta per tick.
  double tickDelta({
    required double quality,
    required double brandAwareness,
    required bool stockedOut,
  }) {
    final qBonus = (quality - 50) * 0.0008;
    final bBonus = (brandAwareness - 50) * 0.0004;
    final penalty = stockedOut ? 0.05 : 0.0;
    return qBonus + bBonus - penalty;
  }
}
