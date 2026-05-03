import 'dart:math';

/// Slow-changing macro inflation. Affects unit costs over many in-game days.
class InflationEngine {
  const InflationEngine({this.annualRate = 0.025});
  final double annualRate;

  double dailyMultiplier(int day, Random rng) {
    final shock = (rng.nextDouble() - 0.5) * 0.002;
    return 1 + (annualRate / 365) + shock;
  }
}
