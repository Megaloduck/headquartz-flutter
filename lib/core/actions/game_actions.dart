// lib/core/actions/game_actions.dart
//
// All actions a player can dispatch to mutate GameState.
// Each action is a pure function: (GameState) → GameState.
// Actions are Isolate-safe (plain Dart, no Flutter).
//
// Usage:
//   final next = GameActions.hirEmployee(state, wage: 500);
//   simulationEngine.applyStateUpdate(next);

import 'dart:math';
import '../models/finance.dart';
import '../models/game_state.dart';
import '../models/human_resource.dart';
import '../models/logistics.dart';
import '../models/market.dart';
import '../models/marketing.dart';
import '../models/production.dart';
import '../models/sales.dart';
import '../models/warehouse.dart';

abstract final class GameActions {
  static final Random _rnd = Random();

  // ─────────────────────────────────────────────
  // HR ACTIONS
  // ─────────────────────────────────────────────

  /// Hire one employee at the given monthly wage.
  static GameState hireEmployee(GameState s, {required double wage}) {
    final wagePerTick = wage / 2592000; // monthly → per tick
    return s.copyWith(
      humanResource: HumanResource(
        employeeCount: s.humanResource.employeeCount + 1,
        totalWagePerTick: s.humanResource.totalWagePerTick + wagePerTick,
        moraleLevel: s.humanResource.moraleLevel,
        productivityMultiplier: s.humanResource.productivityMultiplier,
      ),
    );
  }

  /// Fire one employee (reduces headcount & wage bill).
  static GameState fireEmployee(GameState s, {required double wage}) {
    if (s.humanResource.employeeCount <= 0) return s;
    final wagePerTick = wage / 2592000;
    final moralePenalty = -0.05; // morale drops when someone is fired
    return s.copyWith(
      humanResource: HumanResource(
        employeeCount: s.humanResource.employeeCount - 1,
        totalWagePerTick:
            (s.humanResource.totalWagePerTick - wagePerTick).clamp(0, double.infinity),
        moraleLevel: (s.humanResource.moraleLevel + moralePenalty).clamp(0.0, 1.0),
        productivityMultiplier: s.humanResource.productivityMultiplier,
      ),
    );
  }

  /// Run a morale boost event (costs cash).
  static GameState boostMorale(GameState s, {double cost = 2000.0}) {
    if (s.finance.cash < cost) return s; // can't afford
    return s.copyWith(
      finance: s.finance.copyWith(cash: s.finance.cash - cost),
      humanResource: s.humanResource.copyWith(
        moraleLevel: (s.humanResource.moraleLevel + 0.15).clamp(0.0, 1.0),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // PRODUCTION ACTIONS
  // ─────────────────────────────────────────────

  /// Add a new machine to the production floor.
  static GameState addMachine(
    GameState s, {
    required String productId,
    required String machineName,
    double cost = 15000.0,
    int outputRate = 5,
  }) {
    if (s.finance.cash < cost) return s;
    final machine = Machine(
      id: 'MCH-${s.simTime.millisecondsSinceEpoch}-${_rnd.nextInt(999)}',
      name: machineName,
      productId: productId,
      health: 1.0,
      isRunning: true,
      outputRate: outputRate,
      level: 1,
    );
    return s.copyWith(
      production: s.production.copyWith(
        machines: [...s.production.machines, machine],
      ),
      finance: s.finance.copyWith(cash: s.finance.cash - cost),
    );
  }

  /// Perform maintenance on a machine (restores health, costs cash).
  static GameState maintainMachine(
    GameState s, {
    required String machineId,
    double cost = 500.0,
  }) {
    if (s.finance.cash < cost) return s;
    final updatedMachines = s.production.machines.map((m) {
      if (m.id != machineId) return m;
      return m.copyWith(health: 1.0, isRunning: true);
    }).toList();
    return s.copyWith(
      production: s.production.copyWith(machines: updatedMachines),
      finance: s.finance.copyWith(cash: s.finance.cash - cost),
    );
  }

  /// Create a work order for a product.
  static GameState createWorkOrder(
    GameState s, {
    required String productId,
    required int targetUnits,
  }) {
    final order = WorkOrder(
      id: 'WO-${s.simTime.millisecondsSinceEpoch}-${_rnd.nextInt(999)}',
      productId: productId,
      targetUnits: targetUnits,
      status: WorkOrderStatus.running,
      createdAt: s.simTime,
    );
    return s.copyWith(
      production: s.production.copyWith(
        workOrders: [...s.production.workOrders, order],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // WAREHOUSE ACTIONS
  // ─────────────────────────────────────────────

  /// Restock a product by purchasing units directly (emergency restock).
  static GameState emergencyRestock(
    GameState s, {
    required String productId,
    required int units,
    required double unitCost,
  }) {
    final totalCost = units * unitCost;
    if (s.finance.cash < totalCost) return s;
    final updatedProducts = s.warehouse.products.map((p) {
      if (p.id != productId) return p;
      return p.copyWith(stock: p.stock + units);
    }).toList();
    return s.copyWith(
      warehouse: s.warehouse.copyWith(
        products: updatedProducts,
        usedCapacity: updatedProducts.fold<double>(0.0, (sum, p) => sum + p.stock),
      ),
      finance: s.finance.copyWith(cash: s.finance.cash - totalCost),
    );
  }

  /// Adjust reorder point for a product.
  static GameState setReorderPoint(
    GameState s, {
    required String productId,
    required int reorderPoint,
  }) {
    final updatedProducts = s.warehouse.products.map((p) {
      if (p.id != productId) return p;
      return p.copyWith(reorderPoint: reorderPoint);
    }).toList();
    return s.copyWith(
      warehouse: s.warehouse.copyWith(products: updatedProducts),
    );
  }

  // ─────────────────────────────────────────────
  // MARKETING ACTIONS
  // ─────────────────────────────────────────────

  /// Launch a new marketing campaign.
  static GameState launchCampaign(
    GameState s, {
    required String name,
    required CampaignChannel channel,
    required double budget,
    double demandBoost = 8.0,
    int durationTicks = 300,
  }) {
    if (s.finance.cash < budget * 0.1) return s; // require 10% upfront
    final campaign = Campaign(
      id: 'CMP-${s.simTime.millisecondsSinceEpoch}-${_rnd.nextInt(999)}',
      name: name,
      channel: channel,
      status: CampaignStatus.active,
      budget: budget,
      demandBoost: demandBoost,
      durationTicks: durationTicks,
    );
    return s.copyWith(
      marketing: s.marketing.copyWith(
        campaigns: [...s.marketing.campaigns, campaign],
      ),
    );
  }

  /// Pause an active campaign (stops spend and demand boost).
  static GameState pauseCampaign(GameState s, {required String campaignId}) {
    final updated = s.marketing.campaigns.map((c) {
      if (c.id != campaignId || !c.isActive) return c;
      return c.copyWith(status: CampaignStatus.paused);
    }).toList();
    return s.copyWith(
      marketing: s.marketing.copyWith(campaigns: updated),
    );
  }

  /// Resume a paused campaign.
  static GameState resumeCampaign(GameState s, {required String campaignId}) {
    final updated = s.marketing.campaigns.map((c) {
      if (c.id != campaignId || c.status != CampaignStatus.paused) return c;
      return c.copyWith(status: CampaignStatus.active);
    }).toList();
    return s.copyWith(
      marketing: s.marketing.copyWith(campaigns: updated),
    );
  }

  /// Adjust the market selling price.
  static GameState setPrice(GameState s, {required double newPrice}) {
    // Price sensitivity: demand inversely adjusts to price change
    final priceDelta = newPrice - s.market.price;
    final demandAdjust = -(priceDelta * s.market.priceSensitivity).round();
    final newDemand = (s.market.demand + demandAdjust).clamp(0, 100);
    return s.copyWith(
      market: s.market.copyWith(
        price: newPrice.clamp(1.0, 9999.0),
        demand: newDemand,
      ),
    );
  }

  // ─────────────────────────────────────────────
  // SALES ACTIONS
  // ─────────────────────────────────────────────

  /// Manually create a sales order (e.g. direct client deal).
  static GameState createSalesOrder(
    GameState s, {
    required String clientName,
    required String productId,
    required int quantity,
    required double unitPrice,
  }) {
    final order = SalesOrder(
      id: 'ORD-MANUAL-${s.simTime.millisecondsSinceEpoch}-${_rnd.nextInt(999)}',
      clientName: clientName,
      productId: productId,
      quantity: quantity,
      unitPrice: unitPrice,
      status: OrderStatus.pending,
      createdAt: s.simTime,
    );
    return s.copyWith(
      sales: s.sales.copyWith(
        orders: [...s.sales.orders, order],
      ),
    );
  }

  /// Cancel a pending or processing order.
  static GameState cancelOrder(GameState s, {required String orderId}) {
    final updated = s.sales.orders.map((o) {
      if (o.id != orderId) return o;
      if (o.status == OrderStatus.shipped ||
          o.status == OrderStatus.delivered ||
          o.status == OrderStatus.cancelled) return o;
      return o.copyWith(status: OrderStatus.cancelled);
    }).toList();
    return s.copyWith(sales: s.sales.copyWith(orders: updated));
  }

  /// Update monthly sales target.
  static GameState setSalesTarget(GameState s, {required double target}) {
    return s.copyWith(
      sales: s.sales.copyWith(monthlyTarget: target.clamp(1000.0, 10000000.0)),
    );
  }

  // ─────────────────────────────────────────────
  // LOGISTICS ACTIONS
  // ─────────────────────────────────────────────

  /// Add a vehicle to the fleet.
  static GameState addVehicle(
    GameState s, {
    required String name,
    int capacity = 100,
    double cost = 30000.0,
  }) {
    if (s.finance.cash < cost) return s;
    final vehicle = Vehicle(
      id: 'VEH-${s.simTime.millisecondsSinceEpoch}-${_rnd.nextInt(999)}',
      name: name,
      status: VehicleStatus.available,
      fuelLevel: 1.0,
      capacity: capacity,
      health: 1.0,
    );
    return s.copyWith(
      logistics: s.logistics.copyWith(
        fleet: [...s.logistics.fleet, vehicle],
      ),
      finance: s.finance.copyWith(cash: s.finance.cash - cost),
    );
  }

  /// Service a vehicle (restore fuel & health).
  static GameState serviceVehicle(
    GameState s, {
    required String vehicleId,
    double cost = 800.0,
  }) {
    if (s.finance.cash < cost) return s;
    final updated = s.logistics.fleet.map((v) {
      if (v.id != vehicleId) return v;
      return v.copyWith(
        fuelLevel: 1.0,
        health: 1.0,
        status: VehicleStatus.available,
      );
    }).toList();
    return s.copyWith(
      logistics: s.logistics.copyWith(fleet: updated),
      finance: s.finance.copyWith(cash: s.finance.cash - cost),
    );
  }

  // ─────────────────────────────────────────────
  // FINANCE ACTIONS
  // ─────────────────────────────────────────────

  /// Take out a loan (adds cash, creates a recurring expense).
  static GameState takeLoan(
    GameState s, {
    required double amount,
    double interestRate = 0.08,
  }) {
    final monthlyRepayment = amount * (1 + interestRate) / 12;
    final repaymentPerTick = monthlyRepayment / 2592000;
    return s.copyWith(
      finance: s.finance.copyWith(
        cash: s.finance.cash + amount,
        expensePerTick: s.finance.expensePerTick + repaymentPerTick,
      ),
    );
  }

  /// Pay back cash (reduce outstanding debt expense manually).
  static GameState repayLoan(
    GameState s, {
    required double amount,
  }) {
    if (s.finance.cash < amount) return s;
    return s.copyWith(
      finance: s.finance.copyWith(cash: s.finance.cash - amount),
    );
  }
}