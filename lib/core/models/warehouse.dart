// lib/core/models/warehouse.dart

import 'product.dart';

class Warehouse {
  final List<SimProduct> products;
  final double totalCapacity;
  final double usedCapacity;

  const Warehouse({
    this.products = const [],
    this.totalCapacity = 10000.0,
    this.usedCapacity = 0.0,
  });

  int get totalStock => products.fold(0, (sum, p) => sum + p.stock);
  int get lowStockCount => products.where((p) => p.stock <= p.reorderPoint).length;

  Warehouse copyWith({
    List<SimProduct>? products,
    double? totalCapacity,
    double? usedCapacity,
  }) {
    return Warehouse(
      products: products ?? this.products,
      totalCapacity: totalCapacity ?? this.totalCapacity,
      usedCapacity: usedCapacity ?? this.usedCapacity,
    );
  }

  Map<String, dynamic> toJson() => {
        'products': products.map((p) => p.toJson()).toList(),
        'totalCapacity': totalCapacity,
        'usedCapacity': usedCapacity,
      };

  factory Warehouse.fromJson(Map<String, dynamic> json) => Warehouse(
        products: (json['products'] as List<dynamic>? ?? [])
            .map((e) => SimProduct.fromJson(e as Map<String, dynamic>))
            .toList(),
        totalCapacity: (json['totalCapacity'] as num).toDouble(),
        usedCapacity: (json['usedCapacity'] as num).toDouble(),
      );
}