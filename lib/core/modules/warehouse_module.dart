// lib/core/modules/warehouse_module.dart
//
// Pure function — Isolate-safe.
// Consumes stock based on market demand, adds finance revenue from sales.

import 'dart:math';
import '../models/game_state.dart';
import '../models/finance.dart';
import '../models/warehouse.dart';

abstract final class WarehouseModule {
  static final Random _rnd = Random();

  static GameState update(GameState state) {
    final demand = state.market.demand;
    final price = state.market.price;

    double revenueThisTick = 0;
    double expenseThisTick = 0;

    // Update each product's stock
    final updatedProducts = state.warehouse.products.map((product) {
      // Units sold this tick: proportional to demand, random variance
      final maxSell = (demand / 10).ceil();
      final sold = _rnd.nextInt(maxSell + 1).clamp(0, product.stock);

      // Production replenishment scaled by HR productivity
      final produced = (product.productionRate *
              state.humanResource.productivityMultiplier)
          .floor();

      final newStock = (product.stock - sold + produced).clamp(0, 99999);

      revenueThisTick += sold * price;
      expenseThisTick += produced * (product.unitPrice * 0.4); // 40% COGS

      return product.copyWith(stock: newStock);
    }).toList();

    // Warehouse rental cost per tick (monthly cost ÷ ticks per month)
    // Approx: 30 days × 24 hr × 3600 s = 2,592,000 ticks at 1s rate
    const rentalPerTick = 5000.0 / 2592000;
    expenseThisTick += rentalPerTick;

    final updatedWarehouse = Warehouse(
      products: updatedProducts,
      totalCapacity: state.warehouse.totalCapacity,
      usedCapacity: updatedProducts.fold(0.0, (s, p) => s + p.stock),
    );

    // Accumulate revenue/expense into finance for FinanceModule
    final updatedFinance = state.finance.copyWith(
      revenuePerTick: state.finance.revenuePerTick + revenueThisTick,
      expensePerTick: state.finance.expensePerTick + expenseThisTick,
    );

    return state.copyWith(
      warehouse: updatedWarehouse,
      finance: updatedFinance,
    );
  }
}