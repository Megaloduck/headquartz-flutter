// lib/core/services/seed_service.dart
//
// Seeds a fresh GameState with realistic starting data for all departments.

import '../models/game_state.dart';
import '../models/logistics.dart';
import '../models/marketing.dart';
import '../models/product.dart';
import '../models/production.dart';
import '../models/sales.dart';
import '../models/warehouse.dart';

abstract final class SeedService {
  static GameState seed(GameState state) {
    return state.copyWith(
      warehouse: _seedWarehouse(state),
      production: _seedProduction(state),
      sales: _seedSales(state),
      marketing: _seedMarketing(state),
      logistics: _seedLogistics(state),
    );
  }

  // ── Warehouse ─────────────────────────────────────────────────────────────
  static Warehouse _seedWarehouse(GameState s) {
    if (s.warehouse.products.isNotEmpty) return s.warehouse;
    const products = [
      SimProduct(
        id: 'basic_widget',
        name: 'Basic Widget',
        unitPrice: 10.0,
        stock: 200,
        productionRate: 0, // production module drives output now
        reorderPoint: 50,
      ),
      SimProduct(
        id: 'premium_widget',
        name: 'Premium Widget',
        unitPrice: 20.0,
        stock: 100,
        productionRate: 0,
        reorderPoint: 25,
      ),
      SimProduct(
        id: 'deluxe_gadget',
        name: 'Deluxe Gadget',
        unitPrice: 45.0,
        stock: 40,
        productionRate: 0,
        reorderPoint: 10,
      ),
    ];
    return Warehouse(
      products: products,
      totalCapacity: 10000,
      usedCapacity: products.fold(0.0, (s, p) => s + p.stock),
    );
  }

  // ── Production ────────────────────────────────────────────────────────────
  static Production _seedProduction(GameState s) {
    if (s.production.machines.isNotEmpty) return s.production;
    const machines = [
      Machine(
        id: 'MCH-001',
        name: 'Assembly Line A',
        productId: 'basic_widget',
        health: 0.9,
        isRunning: true,
        outputRate: 8,
        level: 1,
      ),
      Machine(
        id: 'MCH-002',
        name: 'Assembly Line B',
        productId: 'premium_widget',
        health: 0.85,
        isRunning: true,
        outputRate: 4,
        level: 1,
      ),
      Machine(
        id: 'MCH-003',
        name: 'Precision Lathe',
        productId: 'deluxe_gadget',
        health: 0.95,
        isRunning: true,
        outputRate: 2,
        level: 2,
      ),
    ];
    return Production(
      machines: machines,
      workOrders: const [],
      qualityScore: 0.88,
      efficiency: 0.9,
    );
  }

  // ── Sales ─────────────────────────────────────────────────────────────────
  static Sales _seedSales(GameState s) {
    if (s.sales.clients.isNotEmpty) return s.sales;
    const clients = [
      SalesClient(
        id: 'CLT-001',
        name: 'Apex Industries',
        tier: 'gold',
        satisfactionScore: 0.9,
        lifetimeValue: 120000.0,
        orderCount: 24,
      ),
      SalesClient(
        id: 'CLT-002',
        name: 'BrightPath Co.',
        tier: 'silver',
        satisfactionScore: 0.75,
        lifetimeValue: 45000.0,
        orderCount: 12,
      ),
      SalesClient(
        id: 'CLT-003',
        name: 'CoreTech Ltd.',
        tier: 'bronze',
        satisfactionScore: 0.65,
        lifetimeValue: 8000.0,
        orderCount: 3,
      ),
    ];
    return Sales(
      clients: clients,
      monthlyTarget: 50000.0,
      conversionRate: 0.35,
    );
  }

  // ── Marketing ─────────────────────────────────────────────────────────────
  static Marketing _seedMarketing(GameState s) {
    if (s.marketing.campaigns.isNotEmpty) return s.marketing;
    const campaigns = [
      Campaign(
        id: 'CMP-001',
        name: 'Q1 Brand Awareness',
        channel: CampaignChannel.social,
        status: CampaignStatus.active,
        budget: 5000.0,
        spent: 1200.0,
        demandBoost: 6.0,
        durationTicks: 500,
        elapsedTicks: 120,
      ),
    ];
    return Marketing(
      campaigns: campaigns,
      brandScore: 0.55,
      marketSharePct: 12.0,
    );
  }

  // ── Logistics ─────────────────────────────────────────────────────────────
  static Logistics _seedLogistics(GameState s) {
    if (s.logistics.fleet.isNotEmpty) return s.logistics;
    const fleet = [
      Vehicle(
        id: 'VEH-001',
        name: 'Truck Alpha',
        status: VehicleStatus.available,
        fuelLevel: 1.0,
        capacity: 150,
        health: 0.95,
      ),
      Vehicle(
        id: 'VEH-002',
        name: 'Van Beta',
        status: VehicleStatus.available,
        fuelLevel: 0.8,
        capacity: 60,
        health: 0.88,
      ),
    ];
    return Logistics(
      fleet: fleet,
      onTimeDeliveryRate: 0.92,
      slaComplianceRate: 0.95,
    );
  }
}