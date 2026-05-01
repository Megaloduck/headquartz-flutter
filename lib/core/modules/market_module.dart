// lib/core/modules/market_module.dart
//
// Pure function — takes GameState, returns new GameState.
// No Flutter imports. No side effects. Safe to run inside an Isolate.

import 'dart:math';
import '../models/game_state.dart';
import '../models/market.dart';

abstract final class MarketModule {
  static final Random _rnd = Random();

  static GameState update(GameState state) {
    final market = state.market;

    // Demand drifts ±5 per tick, clamped 0–100
    final newDemand = (market.demand + _rnd.nextInt(11) - 5).clamp(0, 100);

    // Price walks ±0.5 per tick, clamped 1–100
    final newPrice = (market.price + (_rnd.nextDouble() - 0.5))
        .clamp(1.0, 100.0);

    // Trend label
    final trend = newPrice < 20
        ? 'Prices Falling'
        : newPrice < 50
            ? 'Stable Market'
            : 'Prices Rising';

    // Keep last 60 price history points (1 min of ticks)
    final history = [
      ...market.priceHistory,
      newPrice,
    ];
    final trimmedHistory =
        history.length > 60 ? history.sublist(history.length - 60) : history;

    return state.copyWith(
      market: Market(
        demand: newDemand,
        price: newPrice,
        baseDemand: market.baseDemand,
        priceSensitivity: market.priceSensitivity,
        trendDescription: trend,
        priceHistory: trimmedHistory,
      ),
    );
  }

  static String generateForecast(GameState state) {
    final projected = state.market.demand + _rnd.nextInt(21) - 10;
    return 'In 3 sim-days, demand is projected at ≈ ${projected.clamp(0, 100)}.';
  }
}