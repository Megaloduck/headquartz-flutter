// lib/core/models/product.dart

class SimProduct {
  final String id;
  final String name;
  final double unitPrice;
  final int stock;
  final int productionRate; // units per tick
  final int reorderPoint;

  const SimProduct({
    required this.id,
    required this.name,
    required this.unitPrice,
    required this.stock,
    required this.productionRate,
    this.reorderPoint = 10,
  });

  SimProduct copyWith({
    String? id,
    String? name,
    double? unitPrice,
    int? stock,
    int? productionRate,
    int? reorderPoint,
  }) {
    return SimProduct(
      id: id ?? this.id,
      name: name ?? this.name,
      unitPrice: unitPrice ?? this.unitPrice,
      stock: stock ?? this.stock,
      productionRate: productionRate ?? this.productionRate,
      reorderPoint: reorderPoint ?? this.reorderPoint,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'unitPrice': unitPrice,
        'stock': stock,
        'productionRate': productionRate,
        'reorderPoint': reorderPoint,
      };

  factory SimProduct.fromJson(Map<String, dynamic> json) => SimProduct(
        id: json['id'] as String,
        name: json['name'] as String,
        unitPrice: (json['unitPrice'] as num).toDouble(),
        stock: json['stock'] as int,
        productionRate: json['productionRate'] as int,
        reorderPoint: json['reorderPoint'] as int? ?? 10,
      );
}