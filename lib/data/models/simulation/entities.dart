/// Misc domain entities. Kept lightweight & immutable.

enum OrderStatus { pending, accepted, fulfilled, shipped, delivered, cancelled }

class CustomerOrder {
  const CustomerOrder({
    required this.id,
    required this.clientName,
    required this.units,
    required this.unitPrice,
    required this.placedAtMinute,
    required this.dueAtMinute,
    required this.status,
  });

  final String id;
  final String clientName;
  final int units;
  final double unitPrice;
  final int placedAtMinute;
  final int dueAtMinute;
  final OrderStatus status;

  double get value => units * unitPrice;

  CustomerOrder copyWith({OrderStatus? status, int? units}) => CustomerOrder(
        id: id,
        clientName: clientName,
        units: units ?? this.units,
        unitPrice: unitPrice,
        placedAtMinute: placedAtMinute,
        dueAtMinute: dueAtMinute,
        status: status ?? this.status,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'clientName': clientName,
        'units': units,
        'unitPrice': unitPrice,
        'placedAtMinute': placedAtMinute,
        'dueAtMinute': dueAtMinute,
        'status': status.name,
      };

  static CustomerOrder fromJson(Map<String, dynamic> json) => CustomerOrder(
        id: json['id'] as String,
        clientName: json['clientName'] as String,
        units: json['units'] as int,
        unitPrice: (json['unitPrice'] as num).toDouble(),
        placedAtMinute: json['placedAtMinute'] as int,
        dueAtMinute: json['dueAtMinute'] as int,
        status: OrderStatus.values
            .firstWhere((s) => s.name == json['status']),
      );
}

class Employee {
  const Employee({
    required this.id,
    required this.name,
    required this.department,
    required this.role,
    required this.salary,
    required this.morale,
    required this.efficiency,
    required this.skill,
  });

  final String id;
  final String name;
  final String department;
  final String role;
  final double salary;
  final double morale;
  final double efficiency;
  final double skill;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'department': department,
        'role': role,
        'salary': salary,
        'morale': morale,
        'efficiency': efficiency,
        'skill': skill,
      };

  static Employee fromJson(Map<String, dynamic> json) => Employee(
        id: json['id'] as String,
        name: json['name'] as String,
        department: json['department'] as String,
        role: json['role'] as String,
        salary: (json['salary'] as num).toDouble(),
        morale: (json['morale'] as num).toDouble(),
        efficiency: (json['efficiency'] as num).toDouble(),
        skill: (json['skill'] as num).toDouble(),
      );
}

enum ShipmentStatus { queued, inTransit, delivered, delayed }

class Shipment {
  const Shipment({
    required this.id,
    required this.destination,
    required this.units,
    required this.dispatchMinute,
    required this.etaMinute,
    required this.status,
  });

  final String id;
  final String destination;
  final int units;
  final int dispatchMinute;
  final int etaMinute;
  final ShipmentStatus status;

  Shipment copyWith({ShipmentStatus? status, int? etaMinute}) => Shipment(
        id: id,
        destination: destination,
        units: units,
        dispatchMinute: dispatchMinute,
        etaMinute: etaMinute ?? this.etaMinute,
        status: status ?? this.status,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'destination': destination,
        'units': units,
        'dispatchMinute': dispatchMinute,
        'etaMinute': etaMinute,
        'status': status.name,
      };

  static Shipment fromJson(Map<String, dynamic> json) => Shipment(
        id: json['id'] as String,
        destination: json['destination'] as String,
        units: json['units'] as int,
        dispatchMinute: json['dispatchMinute'] as int,
        etaMinute: json['etaMinute'] as int,
        status: ShipmentStatus.values
            .firstWhere((s) => s.name == json['status']),
      );
}
