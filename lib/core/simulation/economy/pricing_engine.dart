import '../../config/game_constants.dart';

/// Pricing math helpers: elasticity, optimal price.
class PricingEngine {
  const PricingEngine();

  /// Price elasticity: how demand reacts to price.
  /// Returns a multiplier in [0.2, 2.5].
  double elasticity({required double currentPrice}) {
    final base = GameConstants.defaultUnitSalePrice;
    if (currentPrice <= 0) return 2.5;
    final ratio = base / currentPrice;
    // simple iso-elastic curve
    return (ratio.clamp(0.2, 2.5)).toDouble();
  }
}
