// lib/core/models/human_resource.dart

class HumanResource {
  final int employeeCount;
  final double totalWagePerTick;
  final double moraleLevel; // 0.0–1.0
  final double productivityMultiplier; // 0.5–1.5

  const HumanResource({
    this.employeeCount = 5,
    this.totalWagePerTick = 50.0,
    this.moraleLevel = 0.75,
    this.productivityMultiplier = 1.0,
  });

  HumanResource copyWith({
    int? employeeCount,
    double? totalWagePerTick,
    double? moraleLevel,
    double? productivityMultiplier,
  }) {
    return HumanResource(
      employeeCount: employeeCount ?? this.employeeCount,
      totalWagePerTick: totalWagePerTick ?? this.totalWagePerTick,
      moraleLevel: moraleLevel ?? this.moraleLevel,
      productivityMultiplier:
          productivityMultiplier ?? this.productivityMultiplier,
    );
  }

  Map<String, dynamic> toJson() => {
        'employeeCount': employeeCount,
        'totalWagePerTick': totalWagePerTick,
        'moraleLevel': moraleLevel,
        'productivityMultiplier': productivityMultiplier,
      };

  factory HumanResource.fromJson(Map<String, dynamic> json) => HumanResource(
        employeeCount: json['employeeCount'] as int,
        totalWagePerTick: (json['totalWagePerTick'] as num).toDouble(),
        moraleLevel: (json['moraleLevel'] as num).toDouble(),
        productivityMultiplier:
            (json['productivityMultiplier'] as num).toDouble(),
      );
}