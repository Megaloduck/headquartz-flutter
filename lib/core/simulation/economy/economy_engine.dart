import 'dart:math';

import '../../../data/models/company/company.dart';
import '../../config/game_constants.dart';

/// Encapsulates the per-tick economic flow: production, sales,
/// operating costs, payroll cadence.
class EconomyEngine {
  const EconomyEngine();

  Company applyTick(Company co, int gameMinute, Random rng) {
    if (co.isBankrupt) return co;

    // ── Production ─────────────────────────────────────────────────
    final efficiency = (co.morale / 100) * 0.4 + 0.6; // 0.6..1.0
    final produced = co.productionRatePerTick * efficiency;
    final productionCost =
        produced * GameConstants.defaultUnitProductionCost;

    // ── Sales: lesser of demand and stock ─────────────────────────
    final available = co.unitsInStock + produced;
    final salesUnits = min(available, co.demandPerTick);
    final revenue = salesUnits * co.unitPrice;

    // ── Variable logistics + storage ──────────────────────────────
    final logisticsCost =
        salesUnits * GameConstants.defaultLogisticsCostPerUnit;
    final storageCost =
        max(0, available - salesUnits) *
            GameConstants.defaultStorageCostPerUnit;

    // ── Payroll cadence: pay every in-game hour (60 minutes). ─────
    double payrollThisTick = 0;
    if (gameMinute % 60 == 0 && gameMinute > 0) {
      payrollThisTick = co.employees * 250.0; // hourly burn
    }

    // ── Loan interest accrual: 0.04% per in-game hour. ────────────
    double interestThisTick = 0;
    if (gameMinute % 60 == 0 && gameMinute > 0) {
      interestThisTick = co.debt * 0.0004;
    }

    final newCash = co.cash +
        revenue -
        productionCost -
        logisticsCost -
        storageCost -
        payrollThisTick -
        interestThisTick;

    final newStock = (available - salesUnits).round();

    // ── Reputation drift ──────────────────────────────────────────
    final stockOutPenalty =
        co.demandPerTick > co.productionRatePerTick + co.unitsInStock
            ? 0.05
            : 0.0;
    final qualityBonus = (co.qualityScore - 50) * 0.0008;
    final newRep = (co.reputation + qualityBonus - stockOutPenalty)
        .clamp(GameConstants.minReputation, GameConstants.maxReputation)
        .toDouble();

    // ── Morale drift toward 70 ────────────────────────────────────
    final newMorale = (co.morale + (70 - co.morale) * 0.001)
        .clamp(GameConstants.minMorale, GameConstants.maxMorale)
        .toDouble();

    // ── Brand decay ───────────────────────────────────────────────
    final newBrand =
        (co.brandAwareness - 0.005).clamp(0.0, 100.0).toDouble();

    return co.copyWith(
      cash: newCash,
      unitsInStock: newStock,
      reputation: newRep,
      morale: newMorale,
      brandAwareness: newBrand,
    );
  }
}
