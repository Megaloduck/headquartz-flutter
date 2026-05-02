// lib/core/modules/logistics_module.dart
//
// Pure function — Isolate-safe.
// Advances shipment ETAs, marks deliveries, degrades vehicle health,
// tracks SLA compliance, deducts shipping costs from finance.

import 'dart:math';
import '../models/game_state.dart';
import '../models/finance.dart';
import '../models/logistics.dart';
import '../models/sales.dart';

abstract final class LogisticsModule {
  static final Random _rnd = Random();

  // Auto-spawn a shipment for every shipped SalesOrder that has no shipment yet
  static const List<String> _destinations = [
    'New York', 'Chicago', 'Houston', 'Phoenix',
    'Los Angeles', 'Seattle', 'Miami', 'Dallas',
  ];

  static GameState update(GameState state) {
    final log = state.logistics;
    double shippingCostThisTick = 0.0;
    int deliveredThisTick = 0;
    int delayedThisTick = 0;

    // ── 1. Spawn shipments for newly-shipped sales orders ─────────────
    final existingShipmentOrderIds =
        log.shipments.map((s) => s.orderId).toSet();
    final shippedOrders = state.sales.orders
        .where((o) =>
            o.status == OrderStatus.shipped &&
            !existingShipmentOrderIds.contains(o.id))
        .toList();

    final newShipments = shippedOrders.map((order) {
      final carrier = _pickCarrier(order.totalValue);
      final eta = _etaForCarrier(carrier);
      final cost = _costForCarrier(carrier, order.quantity);
      return Shipment(
        id: 'SHP-${state.simTime.millisecondsSinceEpoch}-${_rnd.nextInt(9999)}',
        orderId: order.id,
        destination: _destinations[_rnd.nextInt(_destinations.length)],
        carrier: carrier,
        status: ShipmentStatus.inTransit,
        cost: cost,
        etaTicks: eta,
        totalTicks: eta,
        isOnTime: true,
      );
    }).toList();

    // ── 2. Advance existing in-transit shipments ──────────────────────
    final advancedShipments = log.shipments.map((s) {
      if (s.status != ShipmentStatus.inTransit) return s;

      final newEta = s.etaTicks - 1;

      // Random delay event (0.01% chance per tick)
      final isDelayed = _rnd.nextDouble() < 0.0001;

      if (newEta <= 0) {
        deliveredThisTick++;
        shippingCostThisTick += s.cost;
        return s.copyWith(
          etaTicks: 0,
          status: ShipmentStatus.delivered,
          isOnTime: !isDelayed,
        );
      }

      if (isDelayed) {
        delayedThisTick++;
        return s.copyWith(
          etaTicks: newEta + 10, // add delay ticks
          status: ShipmentStatus.delayed,
          isOnTime: false,
        );
      }

      return s.copyWith(etaTicks: newEta);
    }).toList();

    // Re-activate delayed shipments (they continue moving)
    final resolvedShipments = advancedShipments.map((s) {
      if (s.status == ShipmentStatus.delayed && s.etaTicks > 0) {
        return s.copyWith(status: ShipmentStatus.inTransit);
      }
      return s;
    }).toList();

    final allShipments = [...resolvedShipments, ...newShipments];

    // Keep last 200 shipments
    final trimmedShipments = allShipments.length > 200
        ? allShipments.sublist(allShipments.length - 200)
        : allShipments;

    // ── 3. Degrade vehicle health on active routes ─────────────────────
    final updatedFleet = log.fleet.map((v) {
      if (v.status != VehicleStatus.onRoute) return v;
      final fuelBurn = 0.001;
      final healthWear = 0.0002;
      final newFuel = (v.fuelLevel - fuelBurn).clamp(0.0, 1.0);
      final newHealth = (v.health - healthWear).clamp(0.0, 1.0);
      final newStatus = (newFuel <= 0.05 || newHealth <= 0.1)
          ? VehicleStatus.maintenance
          : v.status;
      return v.copyWith(
        fuelLevel: newFuel,
        health: newHealth,
        status: newStatus,
      );
    }).toList();

    // ── 4. Recalculate KPIs ───────────────────────────────────────────
    final totalDelivered = log.totalDelivered + deliveredThisTick;
    final totalDelayed = log.totalDelayed + delayedThisTick;
    final onTimeRate = totalDelivered > 0
        ? (totalDelivered - totalDelayed) / totalDelivered
        : log.onTimeDeliveryRate;

    final updatedLog = log.copyWith(
      shipments: trimmedShipments,
      fleet: updatedFleet,
      totalDelivered: totalDelivered,
      totalDelayed: totalDelayed,
      onTimeDeliveryRate: onTimeRate.clamp(0.0, 1.0),
      totalShippingCost: log.totalShippingCost + shippingCostThisTick,
      slaComplianceRate: onTimeRate.clamp(0.0, 1.0),
    );

    final updatedFinance = state.finance.copyWith(
      expensePerTick: state.finance.expensePerTick + shippingCostThisTick,
    );

    return state.copyWith(
      logistics: updatedLog,
      finance: updatedFinance,
    );
  }

  static CarrierType _pickCarrier(double orderValue) {
    if (orderValue > 1000) return CarrierType.express;
    if (orderValue > 500) return CarrierType.standard;
    return CarrierType.freight;
  }

  static int _etaForCarrier(CarrierType c) => switch (c) {
        CarrierType.express => 20,
        CarrierType.standard => 60,
        CarrierType.freight => 120,
      };

  static double _costForCarrier(CarrierType c, int qty) => switch (c) {
        CarrierType.express => 80.0 + qty * 0.5,
        CarrierType.standard => 40.0 + qty * 0.3,
        CarrierType.freight => 20.0 + qty * 0.2,
      };
}