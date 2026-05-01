// lib/core/modules/hr_module.dart
//
// Pure function — Isolate-safe.
// Deducts wages, shifts morale, adjusts productivity multiplier.

import 'dart:math';
import '../models/game_state.dart';
import '../models/finance.dart';
import '../models/human_resource.dart';

abstract final class HumanResourceModule {
  static final Random _rnd = Random();

  static GameState update(GameState state) {
    final hr = state.humanResource;

    // Wage cost: each employee costs totalWagePerTick each tick
    final wageExpense = hr.totalWagePerTick;

    // Morale drifts slightly each tick (random walk ±0.005, clamped 0–1)
    final moraleDrift = (_rnd.nextDouble() - 0.5) * 0.01;
    final newMorale = (hr.moraleLevel + moraleDrift).clamp(0.0, 1.0);

    // Productivity is a function of morale: 0.5 + morale
    // Morale 0.0 → productivity 0.5 (half speed)
    // Morale 1.0 → productivity 1.5 (50% bonus)
    final newProductivity = 0.5 + newMorale;

    final updatedHr = HumanResource(
      employeeCount: hr.employeeCount,
      totalWagePerTick: hr.totalWagePerTick,
      moraleLevel: newMorale,
      productivityMultiplier: newProductivity,
    );

    final updatedFinance = state.finance.copyWith(
      expensePerTick: state.finance.expensePerTick + wageExpense,
    );

    return state.copyWith(
      humanResource: updatedHr,
      finance: updatedFinance,
    );
  }
}