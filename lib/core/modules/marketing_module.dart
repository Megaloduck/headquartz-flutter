// lib/core/modules/marketing_module.dart
//
// Pure function — Isolate-safe.
// Ticks active campaigns, deducts ad spend, evolves brand score,
// boosts market demand, updates conversion rate in Sales.

import 'dart:math';
import '../models/game_state.dart';
import '../models/finance.dart';
import '../models/market.dart';
import '../models/marketing.dart';
import '../models/sales.dart';

abstract final class MarketingModule {
  static final Random _rnd = Random();

  static GameState update(GameState state) {
    final mkt = state.marketing;
    double adSpendThisTick = 0.0;
    double totalDemandBoostThisTick = 0.0;

    // ── 1. Tick each campaign ─────────────────────────────────────────
    final updatedCampaigns = mkt.campaigns.map((c) {
      if (!c.isActive) return c;

      final newElapsed = c.elapsedTicks + 1;
      final newSpent = c.spent + c.costPerTick;
      adSpendThisTick += c.costPerTick;
      totalDemandBoostThisTick += c.demandBoost;

      final finished = newElapsed >= c.durationTicks;

      return c.copyWith(
        elapsedTicks: newElapsed,
        spent: newSpent,
        status: finished ? CampaignStatus.completed : CampaignStatus.active,
      );
    }).toList();

    // ── 2. Brand score drift ──────────────────────────────────────────
    // Active campaigns push brand up; no campaigns → slow decay
    final activeCampaignCount =
        updatedCampaigns.where((c) => c.isActive).length;
    final brandDrift = activeCampaignCount > 0
        ? 0.0002 * activeCampaignCount
        : -0.00005;
    final brandNoise = (_rnd.nextDouble() - 0.5) * 0.0001;
    final newBrandScore = (mkt.brandScore + brandDrift + brandNoise).clamp(0.1, 1.0);

    // ── 3. Apply demand boost to market ──────────────────────────────
    // Base market demand from market module already varies; we add boost
    final boostedDemand =
        (state.market.demand + totalDemandBoostThisTick.round()).clamp(0, 100);

    // ── 4. Propagate brand bonus → Sales conversion rate ─────────────
    final baseConversion = 0.25;
    final newConversionRate =
        (baseConversion + newBrandScore * 0.25).clamp(0.1, 0.8);

    final updatedMkt = mkt.copyWith(
      campaigns: updatedCampaigns,
      brandScore: newBrandScore,
      totalAdSpend: mkt.totalAdSpend + adSpendThisTick,
      totalDemandGenerated: mkt.totalDemandGenerated + totalDemandBoostThisTick,
      marketSharePct: (mkt.marketSharePct + newBrandScore * 0.001).clamp(0.0, 100.0),
    );

    final updatedMarket = state.market.copyWith(demand: boostedDemand);

    final updatedSales = state.sales.copyWith(
      conversionRate: newConversionRate,
    );

    final updatedFinance = state.finance.copyWith(
      expensePerTick: state.finance.expensePerTick + adSpendThisTick,
    );

    return state.copyWith(
      marketing: updatedMkt,
      market: updatedMarket,
      sales: updatedSales,
      finance: updatedFinance,
    );
  }
}