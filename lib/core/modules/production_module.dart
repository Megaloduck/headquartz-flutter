// lib/core/modules/production_module.dart
//
// Pure function — Isolate-safe.
// Ticks machines, advances work orders, degrades machine health,
// applies quality penalties, pushes produced units to warehouse.

import 'dart:math';
import '../models/game_state.dart';
import '../models/finance.dart';
import '../models/production.dart';
import '../models/warehouse.dart';

abstract final class ProductionModule {
  static final Random _rnd = Random();

  // Maintenance cost per machine per tick
  static const double _maintenanceCostPerTick = 2000.0 / 2592000;

  static GameState update(GameState state) {
    final prod = state.production;
    double expenseThisTick = 0.0;
    int totalProducedThisTick = 0;
    int totalDefectsThisTick = 0;

    // ── 1. Tick machines ─────────────────────────────────────────────
    final updatedMachines = prod.machines.map((m) {
      if (m.isBrokenDown) return m; // broken machines do nothing

      // Health degrades slightly each tick (faster if running hard)
      final healthDecay = m.isRunning ? 0.00005 : 0.00001;
      final newHealth = (m.health - healthDecay).clamp(0.0, 1.0);

      // Small random breakdown chance when health < 0.3
      final brokeDown = newHealth < 0.3 && _rnd.nextDouble() < 0.0001;

      expenseThisTick += _maintenanceCostPerTick;

      return m.copyWith(
        health: newHealth,
        isRunning: brokeDown ? false : m.isRunning,
      );
    }).toList();

    // ── 2. Advance active work orders ────────────────────────────────
    // Collect units produced per product this tick
    final Map<String, int> producedByProduct = {};

    final updatedOrders = prod.workOrders.map((order) {
      if (order.status != WorkOrderStatus.running) return order;

      // Find machines assigned to this product that are running
      final assignedMachines = updatedMachines
          .where((m) => m.productId == order.productId && m.isRunning && !m.isBrokenDown)
          .toList();

      if (assignedMachines.isEmpty) return order;

      // Units produced this tick by all assigned machines
      final rawOutput = assignedMachines.fold(0, (s, m) => s + m.outputRate);
      // Apply HR productivity multiplier
      final adjustedOutput =
          (rawOutput * state.humanResource.productivityMultiplier * prod.efficiency).floor();

      // Quality check — defects based on quality score
      final defects = (_rnd.nextDouble() > prod.qualityScore
          ? (adjustedOutput * 0.05).ceil()
          : 0);
      final goodUnits = adjustedOutput - defects;

      producedByProduct[order.productId] =
          (producedByProduct[order.productId] ?? 0) + goodUnits;
      totalProducedThisTick += goodUnits;
      totalDefectsThisTick += defects;

      final newCompleted = (order.completedUnits + goodUnits).clamp(0, order.targetUnits);
      final isDone = newCompleted >= order.targetUnits;

      return order.copyWith(
        completedUnits: newCompleted,
        status: isDone ? WorkOrderStatus.completed : WorkOrderStatus.running,
      );
    }).toList();

    // Remove completed orders older than last 20 (keep history readable)
    final trimmedOrders = updatedOrders.length > 50
        ? updatedOrders.sublist(updatedOrders.length - 50)
        : updatedOrders;

    // ── 3. Push produced units into warehouse stock ───────────────────
    final updatedProducts = state.warehouse.products.map((product) {
      final added = producedByProduct[product.id] ?? 0;
      return product.copyWith(stock: product.stock + added);
    }).toList();

    final updatedWarehouse = state.warehouse.copyWith(
      products: updatedProducts,
      usedCapacity: updatedProducts.fold(0.0, (s, p) => s + p.stock),
    );

    // ── 4. Update efficiency based on average machine health ──────────
    final avgHealth = updatedMachines.isEmpty
        ? 1.0
        : updatedMachines.fold(0.0, (s, m) => s + m.health) / updatedMachines.length;
    final newEfficiency = (0.4 + avgHealth * 0.6).clamp(0.0, 1.0);

    // Quality score drifts toward efficiency (neglected machines → poor quality)
    final qualityDrift = (newEfficiency - prod.qualityScore) * 0.001;
    final newQuality = (prod.qualityScore + qualityDrift).clamp(0.5, 1.0);

    final updatedProd = prod.copyWith(
      machines: updatedMachines,
      workOrders: trimmedOrders,
      efficiency: newEfficiency,
      qualityScore: newQuality,
      totalUnitsProduced: prod.totalUnitsProduced + totalProducedThisTick,
      totalDefects: prod.totalDefects + totalDefectsThisTick,
    );

    final updatedFinance = state.finance.copyWith(
      expensePerTick: state.finance.expensePerTick + expenseThisTick,
    );

    return state.copyWith(
      production: updatedProd,
      warehouse: updatedWarehouse,
      finance: updatedFinance,
    );
  }
}