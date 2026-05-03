import 'kpi.dart';

/// Top-level company state. The single source of truth in the simulation.
class Company {
  Company({
    required this.name,
    required this.cash,
    required this.equity,
    required this.debt,
    required this.reputation,
    required this.morale,
    required this.brandAwareness,
    required this.qualityScore,
    required this.unitsInStock,
    required this.unitPrice,
    required this.productionRatePerTick,
    required this.demandPerTick,
    required this.employees,
    required this.fleet,
    required this.kpis,
    this.isBankrupt = false,
  });

  final String name;
  final double cash;
  final double equity;
  final double debt;
  final double reputation; // 0..100
  final double morale; // 0..100
  final double brandAwareness; // 0..100
  final double qualityScore; // 0..100
  final int unitsInStock;
  final double unitPrice;
  final double productionRatePerTick;
  final double demandPerTick;
  final int employees;
  final int fleet;
  final List<Kpi> kpis;
  final bool isBankrupt;

  double get netWorth => cash + equity - debt;

  Company copyWith({
    String? name,
    double? cash,
    double? equity,
    double? debt,
    double? reputation,
    double? morale,
    double? brandAwareness,
    double? qualityScore,
    int? unitsInStock,
    double? unitPrice,
    double? productionRatePerTick,
    double? demandPerTick,
    int? employees,
    int? fleet,
    List<Kpi>? kpis,
    bool? isBankrupt,
  }) =>
      Company(
        name: name ?? this.name,
        cash: cash ?? this.cash,
        equity: equity ?? this.equity,
        debt: debt ?? this.debt,
        reputation: reputation ?? this.reputation,
        morale: morale ?? this.morale,
        brandAwareness: brandAwareness ?? this.brandAwareness,
        qualityScore: qualityScore ?? this.qualityScore,
        unitsInStock: unitsInStock ?? this.unitsInStock,
        unitPrice: unitPrice ?? this.unitPrice,
        productionRatePerTick:
            productionRatePerTick ?? this.productionRatePerTick,
        demandPerTick: demandPerTick ?? this.demandPerTick,
        employees: employees ?? this.employees,
        fleet: fleet ?? this.fleet,
        kpis: kpis ?? this.kpis,
        isBankrupt: isBankrupt ?? this.isBankrupt,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'cash': cash,
        'equity': equity,
        'debt': debt,
        'reputation': reputation,
        'morale': morale,
        'brandAwareness': brandAwareness,
        'qualityScore': qualityScore,
        'unitsInStock': unitsInStock,
        'unitPrice': unitPrice,
        'productionRatePerTick': productionRatePerTick,
        'demandPerTick': demandPerTick,
        'employees': employees,
        'fleet': fleet,
        'kpis': kpis.map((k) => k.toJson()).toList(),
        'isBankrupt': isBankrupt,
      };

  static Company fromJson(Map<String, dynamic> json) => Company(
        name: json['name'] as String,
        cash: (json['cash'] as num).toDouble(),
        equity: (json['equity'] as num).toDouble(),
        debt: (json['debt'] as num).toDouble(),
        reputation: (json['reputation'] as num).toDouble(),
        morale: (json['morale'] as num).toDouble(),
        brandAwareness: (json['brandAwareness'] as num).toDouble(),
        qualityScore: (json['qualityScore'] as num).toDouble(),
        unitsInStock: json['unitsInStock'] as int,
        unitPrice: (json['unitPrice'] as num).toDouble(),
        productionRatePerTick:
            (json['productionRatePerTick'] as num).toDouble(),
        demandPerTick: (json['demandPerTick'] as num).toDouble(),
        employees: json['employees'] as int,
        fleet: json['fleet'] as int,
        kpis: (json['kpis'] as List<dynamic>)
            .map((j) => Kpi.fromJson(j as Map<String, dynamic>))
            .toList(),
        isBankrupt: json['isBankrupt'] as bool? ?? false,
      );
}
