// lib/core/models/logistics.dart
//
// Isolate-safe — plain Dart, no Flutter imports.

// ─────────────────────────────────────────────
// SHIPMENT
// ─────────────────────────────────────────────

enum ShipmentStatus { preparing, inTransit, delivered, delayed, failed }
enum CarrierType { standard, express, freight }

class Shipment {
  final String id;
  final String orderId;      // linked SalesOrder id
  final String destination;
  final CarrierType carrier;
  final ShipmentStatus status;
  final double cost;
  final int etaTicks;        // ticks remaining until delivery
  final int totalTicks;      // original ETA
  final bool isOnTime;

  const Shipment({
    required this.id,
    required this.orderId,
    required this.destination,
    this.carrier = CarrierType.standard,
    this.status = ShipmentStatus.preparing,
    this.cost = 50.0,
    this.etaTicks = 60,
    this.totalTicks = 60,
    this.isOnTime = true,
  });

  double get deliveryProgress =>
      totalTicks > 0 ? ((totalTicks - etaTicks) / totalTicks).clamp(0.0, 1.0) : 1.0;

  Shipment copyWith({
    String? id,
    String? orderId,
    String? destination,
    CarrierType? carrier,
    ShipmentStatus? status,
    double? cost,
    int? etaTicks,
    int? totalTicks,
    bool? isOnTime,
  }) =>
      Shipment(
        id: id ?? this.id,
        orderId: orderId ?? this.orderId,
        destination: destination ?? this.destination,
        carrier: carrier ?? this.carrier,
        status: status ?? this.status,
        cost: cost ?? this.cost,
        etaTicks: etaTicks ?? this.etaTicks,
        totalTicks: totalTicks ?? this.totalTicks,
        isOnTime: isOnTime ?? this.isOnTime,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'orderId': orderId,
        'destination': destination,
        'carrier': carrier.name,
        'status': status.name,
        'cost': cost,
        'etaTicks': etaTicks,
        'totalTicks': totalTicks,
        'isOnTime': isOnTime,
      };

  factory Shipment.fromJson(Map<String, dynamic> j) => Shipment(
        id: j['id'] as String,
        orderId: j['orderId'] as String,
        destination: j['destination'] as String,
        carrier: CarrierType.values.firstWhere(
            (c) => c.name == j['carrier'],
            orElse: () => CarrierType.standard),
        status: ShipmentStatus.values.firstWhere(
            (s) => s.name == j['status'],
            orElse: () => ShipmentStatus.preparing),
        cost: (j['cost'] as num).toDouble(),
        etaTicks: j['etaTicks'] as int,
        totalTicks: j['totalTicks'] as int,
        isOnTime: j['isOnTime'] as bool,
      );
}

// ─────────────────────────────────────────────
// VEHICLE
// ─────────────────────────────────────────────

enum VehicleStatus { available, onRoute, maintenance }

class Vehicle {
  final String id;
  final String name;
  final VehicleStatus status;
  final double fuelLevel;     // 0.0–1.0
  final int capacity;         // max units per trip
  final double health;        // 0.0–1.0

  const Vehicle({
    required this.id,
    required this.name,
    this.status = VehicleStatus.available,
    this.fuelLevel = 1.0,
    this.capacity = 100,
    this.health = 1.0,
  });

  bool get needsService => health < 0.3 || fuelLevel < 0.15;

  Vehicle copyWith({
    String? id,
    String? name,
    VehicleStatus? status,
    double? fuelLevel,
    int? capacity,
    double? health,
  }) =>
      Vehicle(
        id: id ?? this.id,
        name: name ?? this.name,
        status: status ?? this.status,
        fuelLevel: fuelLevel ?? this.fuelLevel,
        capacity: capacity ?? this.capacity,
        health: health ?? this.health,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'status': status.name,
        'fuelLevel': fuelLevel,
        'capacity': capacity,
        'health': health,
      };

  factory Vehicle.fromJson(Map<String, dynamic> j) => Vehicle(
        id: j['id'] as String,
        name: j['name'] as String,
        status: VehicleStatus.values.firstWhere(
            (s) => s.name == j['status'],
            orElse: () => VehicleStatus.available),
        fuelLevel: (j['fuelLevel'] as num).toDouble(),
        capacity: j['capacity'] as int,
        health: (j['health'] as num).toDouble(),
      );
}

// ─────────────────────────────────────────────
// LOGISTICS STATE
// ─────────────────────────────────────────────

class Logistics {
  final List<Shipment> shipments;
  final List<Vehicle> fleet;
  final double onTimeDeliveryRate;   // 0.0–1.0
  final double avgDeliveryCost;
  final double totalShippingCost;
  final int totalDelivered;
  final int totalDelayed;
  final double slaComplianceRate;    // 0.0–1.0

  const Logistics({
    this.shipments = const [],
    this.fleet = const [],
    this.onTimeDeliveryRate = 0.9,
    this.avgDeliveryCost = 50.0,
    this.totalShippingCost = 0.0,
    this.totalDelivered = 0,
    this.totalDelayed = 0,
    this.slaComplianceRate = 0.95,
  });

  List<Shipment> get activeShipments =>
      shipments.where((s) => s.status == ShipmentStatus.inTransit).toList();
  List<Vehicle> get availableVehicles =>
      fleet.where((v) => v.status == VehicleStatus.available).toList();

  Logistics copyWith({
    List<Shipment>? shipments,
    List<Vehicle>? fleet,
    double? onTimeDeliveryRate,
    double? avgDeliveryCost,
    double? totalShippingCost,
    int? totalDelivered,
    int? totalDelayed,
    double? slaComplianceRate,
  }) =>
      Logistics(
        shipments: shipments ?? this.shipments,
        fleet: fleet ?? this.fleet,
        onTimeDeliveryRate: onTimeDeliveryRate ?? this.onTimeDeliveryRate,
        avgDeliveryCost: avgDeliveryCost ?? this.avgDeliveryCost,
        totalShippingCost: totalShippingCost ?? this.totalShippingCost,
        totalDelivered: totalDelivered ?? this.totalDelivered,
        totalDelayed: totalDelayed ?? this.totalDelayed,
        slaComplianceRate: slaComplianceRate ?? this.slaComplianceRate,
      );

  Map<String, dynamic> toJson() => {
        'shipments': shipments.map((s) => s.toJson()).toList(),
        'fleet': fleet.map((v) => v.toJson()).toList(),
        'onTimeDeliveryRate': onTimeDeliveryRate,
        'avgDeliveryCost': avgDeliveryCost,
        'totalShippingCost': totalShippingCost,
        'totalDelivered': totalDelivered,
        'totalDelayed': totalDelayed,
        'slaComplianceRate': slaComplianceRate,
      };

  factory Logistics.fromJson(Map<String, dynamic> j) => Logistics(
        shipments: (j['shipments'] as List? ?? [])
            .map((e) => Shipment.fromJson(e as Map<String, dynamic>))
            .toList(),
        fleet: (j['fleet'] as List? ?? [])
            .map((e) => Vehicle.fromJson(e as Map<String, dynamic>))
            .toList(),
        onTimeDeliveryRate: (j['onTimeDeliveryRate'] as num).toDouble(),
        avgDeliveryCost: (j['avgDeliveryCost'] as num).toDouble(),
        totalShippingCost: (j['totalShippingCost'] as num).toDouble(),
        totalDelivered: j['totalDelivered'] as int,
        totalDelayed: j['totalDelayed'] as int,
        slaComplianceRate: (j['slaComplianceRate'] as num).toDouble(),
      );
}