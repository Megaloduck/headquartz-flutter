// lib/core/models/production.dart
//
// Isolate-safe — plain Dart, no Flutter imports.

// ─────────────────────────────────────────────
// MACHINE
// ─────────────────────────────────────────────

class Machine {
  final String id;
  final String name;
  final String productId;   // which SimProduct this machine produces
  final double health;      // 0.0–1.0  (below 0.3 = breakdown risk)
  final bool isRunning;
  final int outputRate;     // units produced per tick when running
  final int level;          // 1–5, upgradeable

  const Machine({
    required this.id,
    required this.name,
    required this.productId,
    this.health = 1.0,
    this.isRunning = true,
    this.outputRate = 5,
    this.level = 1,
  });

  bool get needsMaintenance => health < 0.4;
  bool get isBrokenDown => health <= 0.0;

  Machine copyWith({
    String? id,
    String? name,
    String? productId,
    double? health,
    bool? isRunning,
    int? outputRate,
    int? level,
  }) =>
      Machine(
        id: id ?? this.id,
        name: name ?? this.name,
        productId: productId ?? this.productId,
        health: health ?? this.health,
        isRunning: isRunning ?? this.isRunning,
        outputRate: outputRate ?? this.outputRate,
        level: level ?? this.level,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'productId': productId,
        'health': health,
        'isRunning': isRunning,
        'outputRate': outputRate,
        'level': level,
      };

  factory Machine.fromJson(Map<String, dynamic> j) => Machine(
        id: j['id'] as String,
        name: j['name'] as String,
        productId: j['productId'] as String,
        health: (j['health'] as num).toDouble(),
        isRunning: j['isRunning'] as bool,
        outputRate: j['outputRate'] as int,
        level: j['level'] as int,
      );
}

// ─────────────────────────────────────────────
// WORK ORDER
// ─────────────────────────────────────────────

enum WorkOrderStatus { pending, running, completed, cancelled }

class WorkOrder {
  final String id;
  final String productId;
  final int targetUnits;
  final int completedUnits;
  final WorkOrderStatus status;
  final DateTime createdAt;

  const WorkOrder({
    required this.id,
    required this.productId,
    required this.targetUnits,
    this.completedUnits = 0,
    this.status = WorkOrderStatus.pending,
    required this.createdAt,
  });

  double get progress =>
      targetUnits > 0 ? completedUnits / targetUnits : 0.0;
  bool get isDone => completedUnits >= targetUnits;

  WorkOrder copyWith({
    String? id,
    String? productId,
    int? targetUnits,
    int? completedUnits,
    WorkOrderStatus? status,
    DateTime? createdAt,
  }) =>
      WorkOrder(
        id: id ?? this.id,
        productId: productId ?? this.productId,
        targetUnits: targetUnits ?? this.targetUnits,
        completedUnits: completedUnits ?? this.completedUnits,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'productId': productId,
        'targetUnits': targetUnits,
        'completedUnits': completedUnits,
        'status': status.name,
        'createdAt': createdAt.toIso8601String(),
      };

  factory WorkOrder.fromJson(Map<String, dynamic> j) => WorkOrder(
        id: j['id'] as String,
        productId: j['productId'] as String,
        targetUnits: j['targetUnits'] as int,
        completedUnits: j['completedUnits'] as int,
        status: WorkOrderStatus.values.firstWhere(
            (s) => s.name == j['status'],
            orElse: () => WorkOrderStatus.pending),
        createdAt: DateTime.parse(j['createdAt'] as String),
      );
}

// ─────────────────────────────────────────────
// PRODUCTION STATE
// ─────────────────────────────────────────────

class Production {
  final List<Machine> machines;
  final List<WorkOrder> workOrders;
  final double qualityScore;     // 0.0–1.0
  final double efficiency;       // 0.0–1.0 (affected by maintenance)
  final int totalUnitsProduced;
  final int totalDefects;

  const Production({
    this.machines = const [],
    this.workOrders = const [],
    this.qualityScore = 0.85,
    this.efficiency = 1.0,
    this.totalUnitsProduced = 0,
    this.totalDefects = 0,
  });

  List<WorkOrder> get activeOrders =>
      workOrders.where((o) => o.status == WorkOrderStatus.running).toList();
  List<Machine> get runningMachines =>
      machines.where((m) => m.isRunning && !m.isBrokenDown).toList();
  double get avgMachineHealth =>
      machines.isEmpty ? 1.0 : machines.fold(0.0, (s, m) => s + m.health) / machines.length;

  Production copyWith({
    List<Machine>? machines,
    List<WorkOrder>? workOrders,
    double? qualityScore,
    double? efficiency,
    int? totalUnitsProduced,
    int? totalDefects,
  }) =>
      Production(
        machines: machines ?? this.machines,
        workOrders: workOrders ?? this.workOrders,
        qualityScore: qualityScore ?? this.qualityScore,
        efficiency: efficiency ?? this.efficiency,
        totalUnitsProduced: totalUnitsProduced ?? this.totalUnitsProduced,
        totalDefects: totalDefects ?? this.totalDefects,
      );

  Map<String, dynamic> toJson() => {
        'machines': machines.map((m) => m.toJson()).toList(),
        'workOrders': workOrders.map((w) => w.toJson()).toList(),
        'qualityScore': qualityScore,
        'efficiency': efficiency,
        'totalUnitsProduced': totalUnitsProduced,
        'totalDefects': totalDefects,
      };

  factory Production.fromJson(Map<String, dynamic> j) => Production(
        machines: (j['machines'] as List? ?? [])
            .map((e) => Machine.fromJson(e as Map<String, dynamic>))
            .toList(),
        workOrders: (j['workOrders'] as List? ?? [])
            .map((e) => WorkOrder.fromJson(e as Map<String, dynamic>))
            .toList(),
        qualityScore: (j['qualityScore'] as num).toDouble(),
        efficiency: (j['efficiency'] as num).toDouble(),
        totalUnitsProduced: j['totalUnitsProduced'] as int,
        totalDefects: j['totalDefects'] as int,
      );
}