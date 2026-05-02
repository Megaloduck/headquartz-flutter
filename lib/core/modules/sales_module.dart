// lib/core/modules/sales_module.dart
//
// Pure function — Isolate-safe.
// Auto-generates inbound orders based on demand + conversion rate,
// advances order statuses, bills revenue when orders ship.

import 'dart:math';
import '../models/game_state.dart';
import '../models/finance.dart';
import '../models/sales.dart';
import '../models/warehouse.dart';

abstract final class SalesModule {
  static final Random _rnd = Random();

  // Ticks between automatic order generation attempts
  static const int _orderGenIntervalTicks = 30;
  static int _ticksSinceLastOrder = 0;

  // Sample client names for auto-generated orders
  static const List<String> _clientNames = [
    'Apex Industries', 'BrightPath Co.', 'CoreTech Ltd.', 'Delta Supplies',
    'EagleMart', 'FrontLine Corp.', 'GlobalGoods Inc.', 'HorizonTrade',
    'IronClad Parts', 'JetSet Wholesale', 'Keystone Partners', 'Luminary Group',
  ];

  static const List<String> _destinations = [
    'New York', 'Chicago', 'Houston', 'Phoenix',
    'Los Angeles', 'Seattle', 'Miami', 'Dallas',
  ];

  static GameState update(GameState state) {
    final sales = state.sales;
    double revenueThisTick = 0.0;

    _ticksSinceLastOrder++;

    // ── 1. Auto-generate inbound orders ──────────────────────────────
    List<SalesOrder> updatedOrders = List.from(sales.orders);
    int newOrderCount = 0;

    if (_ticksSinceLastOrder >= _orderGenIntervalTicks &&
        state.warehouse.products.isNotEmpty) {
      _ticksSinceLastOrder = 0;

      // Chance of generating an order scales with demand & conversion rate
      final chance = (state.market.demand / 100.0) * sales.conversionRate;
      if (_rnd.nextDouble() < chance) {
        final product = state.warehouse.products[
            _rnd.nextInt(state.warehouse.products.length)];
        final qty = _rnd.nextInt(10) + 1;
        final order = SalesOrder(
          id: 'ORD-${state.simTime.millisecondsSinceEpoch}-${_rnd.nextInt(9999)}',
          clientName: _clientNames[_rnd.nextInt(_clientNames.length)],
          productId: product.id,
          quantity: qty,
          unitPrice: state.market.price,
          status: OrderStatus.pending,
          createdAt: state.simTime,
        );
        updatedOrders = [...updatedOrders, order];
        newOrderCount++;
      }
    }

    // ── 2. Advance pending → processing (immediate if stock available) ─
    final Map<String, int> stockReserved = {};
    updatedOrders = updatedOrders.map((order) {
      if (order.status != OrderStatus.pending) return order;

      final reserved = stockReserved[order.productId] ?? 0;
      final product = state.warehouse.products
          .where((p) => p.id == order.productId)
          .firstOrNull;
      if (product == null) return order;

      final availableStock = product.stock - reserved;
      if (availableStock >= order.quantity) {
        stockReserved[order.productId] = reserved + order.quantity;
        return order.copyWith(status: OrderStatus.processing);
      }
      return order; // not enough stock — stays pending
    }).toList();

    // ── 3. Advance processing → shipped (deducts stock, books revenue) ─
    final Map<String, int> stockConsumed = {};
    updatedOrders = updatedOrders.map((order) {
      if (order.status != OrderStatus.processing) return order;
      stockConsumed[order.productId] =
          (stockConsumed[order.productId] ?? 0) + order.quantity;
      revenueThisTick += order.totalValue;
      return order.copyWith(status: OrderStatus.shipped);
    }).toList();

    // ── 4. Deduct consumed stock from warehouse ───────────────────────
    final updatedProducts = state.warehouse.products.map((product) {
      final consumed = stockConsumed[product.id] ?? 0;
      return product.copyWith(stock: (product.stock - consumed).clamp(0, 99999));
    }).toList();

    final updatedWarehouse = state.warehouse.copyWith(
      products: updatedProducts,
      usedCapacity: updatedProducts.fold<double>(0.0, (s, p) => s + p.stock),
    );

    // ── 5. Keep order list bounded (last 100 orders) ──────────────────
    final trimmedOrders = updatedOrders.length > 100
        ? updatedOrders.sublist(updatedOrders.length - 100)
        : updatedOrders;

    // ── 6. Update monthly revenue & client satisfaction ───────────────
    // Upgrade client tier based on lifetime value
    final updatedClients = sales.clients.map((c) {
      String newTier = c.tier;
      if (c.lifetimeValue > 100000) newTier = 'gold';
      else if (c.lifetimeValue > 25000) newTier = 'silver';
      return c.copyWith(tier: newTier);
    }).toList();

    final updatedSales = sales.copyWith(
      orders: trimmedOrders,
      clients: updatedClients,
      monthlyRevenue: sales.monthlyRevenue + revenueThisTick,
      totalRevenue: sales.totalRevenue + revenueThisTick,
      totalOrdersThisMonth: sales.totalOrdersThisMonth + newOrderCount,
    );

    final updatedFinance = state.finance.copyWith(
      revenuePerTick: state.finance.revenuePerTick + revenueThisTick,
    );

    return state.copyWith(
      sales: updatedSales,
      warehouse: updatedWarehouse,
      finance: updatedFinance,
    );
  }
}