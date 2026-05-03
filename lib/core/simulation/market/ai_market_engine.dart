import 'dart:math';

import 'competitor_ai.dart';
import 'market_trends.dart';

/// Composes [CompetitorAi] and [MarketTrends] for higher-level effects.
class AiMarketEngine {
  AiMarketEngine({Random? rng})
      : competitors = CompetitorAi(rng: rng),
        trends = MarketTrends(rng: rng);

  final CompetitorAi competitors;
  final MarketTrends trends;
}
