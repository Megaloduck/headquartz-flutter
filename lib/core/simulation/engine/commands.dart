import '../../config/department_constants.dart';

/// Base class for all simulation commands.
///
/// Commands are intent objects sent from any UI (or AI) into the
/// authoritative simulation. The host's [CommandBus] validates and
/// applies them.
sealed class SimulationCommand {
  const SimulationCommand({required this.issuedBy});
  final String issuedBy; // playerId

  Map<String, dynamic> toJson();
  String get type;

  static SimulationCommand fromJson(Map<String, dynamic> json) {
    final t = json['type'] as String;
    final issuedBy = json['issuedBy'] as String;
    switch (t) {
      case 'AdjustPriceCommand':
        return AdjustPriceCommand(
          issuedBy: issuedBy,
          newPrice: (json['newPrice'] as num).toDouble(),
        );
      case 'HireEmployeesCommand':
        return HireEmployeesCommand(
          issuedBy: issuedBy,
          count: json['count'] as int,
        );
      case 'LayoffEmployeesCommand':
        return LayoffEmployeesCommand(
          issuedBy: issuedBy,
          count: json['count'] as int,
        );
      case 'AdjustSalariesCommand':
        return AdjustSalariesCommand(
          issuedBy: issuedBy,
          deltaPct: (json['deltaPct'] as num).toDouble(),
        );
      case 'AllocateBudgetCommand':
        return AllocateBudgetCommand(
          issuedBy: issuedBy,
          department: RoleId.tryParse(json['department'] as String?)!,
          amount: (json['amount'] as num).toDouble(),
        );
      case 'TakeLoanCommand':
        return TakeLoanCommand(
          issuedBy: issuedBy,
          principal: (json['principal'] as num).toDouble(),
        );
      case 'RepayLoanCommand':
        return RepayLoanCommand(
          issuedBy: issuedBy,
          amount: (json['amount'] as num).toDouble(),
        );
      case 'LaunchCampaignCommand':
        return LaunchCampaignCommand(
          issuedBy: issuedBy,
          name: json['name'] as String,
          spend: (json['spend'] as num).toDouble(),
          durationMinutes: json['durationMinutes'] as int,
        );
      case 'OpenWorkOrderCommand':
        return OpenWorkOrderCommand(
          issuedBy: issuedBy,
          units: json['units'] as int,
        );
      case 'AddProductionLineCommand':
        return AddProductionLineCommand(issuedBy: issuedBy);
      case 'PurchaseFleetCommand':
        return PurchaseFleetCommand(
          issuedBy: issuedBy,
          vehicles: json['vehicles'] as int,
        );
      case 'DispatchShipmentCommand':
        return DispatchShipmentCommand(
          issuedBy: issuedBy,
          orderId: json['orderId'] as String,
        );
      case 'AcceptOrderCommand':
        return AcceptOrderCommand(
          issuedBy: issuedBy,
          orderId: json['orderId'] as String,
        );
      case 'AnnouncementCommand':
        return AnnouncementCommand(
          issuedBy: issuedBy,
          body: json['body'] as String,
        );
      case 'TogglePauseCommand':
        return const TogglePauseCommand(issuedBy: 'host');
      case 'SetSpeedCommand':
        return SetSpeedCommand(
          issuedBy: issuedBy,
          speed: (json['speed'] as num).toDouble(),
        );
    }
    throw StateError('Unknown command type: $t');
  }
}

class AdjustPriceCommand extends SimulationCommand {
  const AdjustPriceCommand({required super.issuedBy, required this.newPrice});
  final double newPrice;
  @override
  String get type => 'AdjustPriceCommand';
  @override
  Map<String, dynamic> toJson() =>
      {'type': type, 'issuedBy': issuedBy, 'newPrice': newPrice};
}

class HireEmployeesCommand extends SimulationCommand {
  const HireEmployeesCommand({required super.issuedBy, required this.count});
  final int count;
  @override
  String get type => 'HireEmployeesCommand';
  @override
  Map<String, dynamic> toJson() =>
      {'type': type, 'issuedBy': issuedBy, 'count': count};
}

class LayoffEmployeesCommand extends SimulationCommand {
  const LayoffEmployeesCommand({required super.issuedBy, required this.count});
  final int count;
  @override
  String get type => 'LayoffEmployeesCommand';
  @override
  Map<String, dynamic> toJson() =>
      {'type': type, 'issuedBy': issuedBy, 'count': count};
}

class AdjustSalariesCommand extends SimulationCommand {
  const AdjustSalariesCommand(
      {required super.issuedBy, required this.deltaPct});
  final double deltaPct;
  @override
  String get type => 'AdjustSalariesCommand';
  @override
  Map<String, dynamic> toJson() =>
      {'type': type, 'issuedBy': issuedBy, 'deltaPct': deltaPct};
}

class AllocateBudgetCommand extends SimulationCommand {
  const AllocateBudgetCommand({
    required super.issuedBy,
    required this.department,
    required this.amount,
  });
  final RoleId department;
  final double amount;
  @override
  String get type => 'AllocateBudgetCommand';
  @override
  Map<String, dynamic> toJson() => {
        'type': type,
        'issuedBy': issuedBy,
        'department': department.key,
        'amount': amount,
      };
}

class TakeLoanCommand extends SimulationCommand {
  const TakeLoanCommand({required super.issuedBy, required this.principal});
  final double principal;
  @override
  String get type => 'TakeLoanCommand';
  @override
  Map<String, dynamic> toJson() =>
      {'type': type, 'issuedBy': issuedBy, 'principal': principal};
}

class RepayLoanCommand extends SimulationCommand {
  const RepayLoanCommand({required super.issuedBy, required this.amount});
  final double amount;
  @override
  String get type => 'RepayLoanCommand';
  @override
  Map<String, dynamic> toJson() =>
      {'type': type, 'issuedBy': issuedBy, 'amount': amount};
}

class LaunchCampaignCommand extends SimulationCommand {
  const LaunchCampaignCommand({
    required super.issuedBy,
    required this.name,
    required this.spend,
    required this.durationMinutes,
  });
  final String name;
  final double spend;
  final int durationMinutes;
  @override
  String get type => 'LaunchCampaignCommand';
  @override
  Map<String, dynamic> toJson() => {
        'type': type,
        'issuedBy': issuedBy,
        'name': name,
        'spend': spend,
        'durationMinutes': durationMinutes,
      };
}

class OpenWorkOrderCommand extends SimulationCommand {
  const OpenWorkOrderCommand({required super.issuedBy, required this.units});
  final int units;
  @override
  String get type => 'OpenWorkOrderCommand';
  @override
  Map<String, dynamic> toJson() =>
      {'type': type, 'issuedBy': issuedBy, 'units': units};
}

class AddProductionLineCommand extends SimulationCommand {
  const AddProductionLineCommand({required super.issuedBy});
  @override
  String get type => 'AddProductionLineCommand';
  @override
  Map<String, dynamic> toJson() => {'type': type, 'issuedBy': issuedBy};
}

class PurchaseFleetCommand extends SimulationCommand {
  const PurchaseFleetCommand(
      {required super.issuedBy, required this.vehicles});
  final int vehicles;
  @override
  String get type => 'PurchaseFleetCommand';
  @override
  Map<String, dynamic> toJson() =>
      {'type': type, 'issuedBy': issuedBy, 'vehicles': vehicles};
}

class DispatchShipmentCommand extends SimulationCommand {
  const DispatchShipmentCommand(
      {required super.issuedBy, required this.orderId});
  final String orderId;
  @override
  String get type => 'DispatchShipmentCommand';
  @override
  Map<String, dynamic> toJson() =>
      {'type': type, 'issuedBy': issuedBy, 'orderId': orderId};
}

class AcceptOrderCommand extends SimulationCommand {
  const AcceptOrderCommand({required super.issuedBy, required this.orderId});
  final String orderId;
  @override
  String get type => 'AcceptOrderCommand';
  @override
  Map<String, dynamic> toJson() =>
      {'type': type, 'issuedBy': issuedBy, 'orderId': orderId};
}

class AnnouncementCommand extends SimulationCommand {
  const AnnouncementCommand({required super.issuedBy, required this.body});
  final String body;
  @override
  String get type => 'AnnouncementCommand';
  @override
  Map<String, dynamic> toJson() =>
      {'type': type, 'issuedBy': issuedBy, 'body': body};
}

class TogglePauseCommand extends SimulationCommand {
  const TogglePauseCommand({required super.issuedBy});
  @override
  String get type => 'TogglePauseCommand';
  @override
  Map<String, dynamic> toJson() => {'type': type, 'issuedBy': issuedBy};
}

class SetSpeedCommand extends SimulationCommand {
  const SetSpeedCommand({required super.issuedBy, required this.speed});
  final double speed;
  @override
  String get type => 'SetSpeedCommand';
  @override
  Map<String, dynamic> toJson() =>
      {'type': type, 'issuedBy': issuedBy, 'speed': speed};
}
