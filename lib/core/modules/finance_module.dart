// lib/core/modules/finance_module.dart
//
// Pure function — Isolate-safe.
// Always runs LAST in the tick pipeline.
// Settles revenuePerTick / expensePerTick into cash, then resets them.

import '../models/game_state.dart';
import '../models/finance.dart';

abstract final class FinanceModule {
  static GameState update(GameState state) {
    final f = state.finance;
    final net = f.revenuePerTick - f.expensePerTick;

    // Build ledger entry only when something happened
    final newLedger = net != 0
        ? [
            ...f.ledger,
            FinanceLedgerEntry(
              description:
                  'Tick: +\$${f.revenuePerTick.toStringAsFixed(2)} revenue, '
                  '-\$${f.expensePerTick.toStringAsFixed(2)} expenses',
              amount: net,
              timestamp: state.simTime,
            ),
          ]
        : f.ledger;

    // Keep ledger to last 100 entries to avoid unbounded growth
    final trimmedLedger =
        newLedger.length > 100 ? newLedger.sublist(newLedger.length - 100) : newLedger;

    return state.copyWith(
      finance: Finance(
        cash: f.cash + net,
        revenuePerTick: 0,   // reset for next tick
        expensePerTick: 0,   // reset for next tick
        totalRevenue: f.totalRevenue + f.revenuePerTick,
        totalExpenses: f.totalExpenses + f.expensePerTick,
        ledger: trimmedLedger,
      ),
    );
  }
}