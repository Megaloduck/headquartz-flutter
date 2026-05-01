// lib/core/services/seed_service.dart

import '../models/game_state.dart';
import '../models/product.dart';
import '../models/warehouse.dart';

abstract final class SeedService {
  static GameState seed(GameState state) {
    // Only seed if warehouse is empty
    if (state.warehouse.products.isNotEmpty) return state;

    const products = [
      SimProduct(
        id: 'basic_widget',
        name: 'Basic Widget',
        unitPrice: 10.0,
        stock: 50,
        productionRate: 5,
        reorderPoint: 15,
      ),
      SimProduct(
        id: 'premium_widget',
        name: 'Premium Widget',
        unitPrice: 20.0,
        stock: 25,
        productionRate: 2,
        reorderPoint: 8,
      ),
      SimProduct(
        id: 'deluxe_gadget',
        name: 'Deluxe Gadget',
        unitPrice: 45.0,
        stock: 10,
        productionRate: 1,
        reorderPoint: 5,
      ),
    ];

    return state.copyWith(
      warehouse: Warehouse(
        products: products,
        totalCapacity: 10000,
        usedCapacity: products.fold(0.0, (s, p) => s + p.stock),
      ),
    );
  }
}