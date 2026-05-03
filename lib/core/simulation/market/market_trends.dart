import 'dart:math';

/// Tracks slow macro market trend - up/down/sideways regimes.
class MarketTrends {
  MarketTrends({this.regime = MarketRegime.bull, this.rng});

  MarketRegime regime;
  final Random? rng;

  double regimeMultiplier() {
    switch (regime) {
      case MarketRegime.bull:
        return 1.10;
      case MarketRegime.bear:
        return 0.85;
      case MarketRegime.flat:
        return 1.0;
    }
  }

  void maybeShift(int gameMinute) {
    final r = rng ?? Random();
    if (gameMinute % 600 != 0) return;
    final v = r.nextDouble();
    if (v < 0.2) regime = MarketRegime.bear;
    else if (v < 0.7) regime = MarketRegime.flat;
    else regime = MarketRegime.bull;
  }
}

enum MarketRegime { bull, bear, flat }
