import 'dart:async';

import '../../../data/models/simulation/game_session.dart';
import '../../utils/logger.dart';
import 'commands.dart';
import 'game_state_manager.dart';

/// CommandBus receives [SimulationCommand]s, validates them against the
/// authoritative [GameStateManager], applies effects, and emits resulting
/// state changes downstream.
class CommandBus {
  CommandBus(this._state);

  final GameStateManager _state;

  final StreamController<SimulationCommand> _accepted =
      StreamController.broadcast();
  final StreamController<RejectedCommand> _rejected =
      StreamController.broadcast();

  Stream<SimulationCommand> get accepted => _accepted.stream;
  Stream<RejectedCommand> get rejected => _rejected.stream;

  /// Submit a command. Validates, then mutates session state if valid.
  void submit(SimulationCommand cmd) {
    final session = _state.session;
    if (session.status != SessionStatus.running) {
      // Allow pause toggle and announcements even when paused.
      if (cmd is! TogglePauseCommand &&
          cmd is! AnnouncementCommand &&
          cmd is! SetSpeedCommand) {
        _reject(cmd, 'Simulation is not running');
        return;
      }
    }

    try {
      _apply(session, cmd);
      _accepted.add(cmd);
    } catch (e, st) {
      logSim.w('Command rejected: $e', e, st);
      _reject(cmd, e.toString());
    }
  }

  void _reject(SimulationCommand cmd, String reason) {
    _rejected.add(RejectedCommand(cmd, reason));
  }

  void _apply(GameSession session, SimulationCommand cmd) {
    switch (cmd) {
      case AdjustPriceCommand c:
        if (c.newPrice <= 0) throw StateError('Price must be > 0');
        _state.updateCompany(
            (co) => co.copyWith(unitPrice: c.newPrice));
      case HireEmployeesCommand c:
        if (c.count <= 0) throw StateError('Count must be > 0');
        final cost = c.count * 4_000.0; // hiring cost
        if (session.company.cash < cost) {
          throw StateError('Not enough cash to hire');
        }
        _state.updateCompany((co) => co.copyWith(
              employees: co.employees + c.count,
              cash: co.cash - cost,
            ));
      case LayoffEmployeesCommand c:
        if (c.count <= 0) throw StateError('Count must be > 0');
        if (c.count > session.company.employees) {
          throw StateError('Cannot lay off more than current employees');
        }
        final severance = c.count * 2_000.0;
        _state.updateCompany((co) => co.copyWith(
              employees: co.employees - c.count,
              cash: co.cash - severance,
              morale: (co.morale - c.count * 1.5)
                  .clamp(0.0, 100.0)
                  .toDouble(),
            ));
      case AdjustSalariesCommand c:
        // Affects morale & runs through finance engine indirectly.
        _state.updateCompany((co) => co.copyWith(
              morale: (co.morale + c.deltaPct * 5)
                  .clamp(0.0, 100.0)
                  .toDouble(),
            ));
      case AllocateBudgetCommand _:
        // Budget allocation is logged; consumed by relevant engines.
        // Implementation: add to a budget map (left as state extension).
        break;
      case TakeLoanCommand c:
        if (c.principal <= 0) throw StateError('Principal must be > 0');
        _state.updateCompany((co) => co.copyWith(
              cash: co.cash + c.principal,
              debt: co.debt + c.principal,
            ));
      case RepayLoanCommand c:
        if (c.amount <= 0) throw StateError('Amount must be > 0');
        if (c.amount > session.company.cash) {
          throw StateError('Not enough cash to repay');
        }
        _state.updateCompany((co) => co.copyWith(
              cash: co.cash - c.amount,
              debt: (co.debt - c.amount).clamp(0.0, double.infinity).toDouble(),
            ));
      case LaunchCampaignCommand c:
        if (c.spend > session.company.cash) {
          throw StateError('Not enough cash to launch campaign');
        }
        _state.updateCompany((co) => co.copyWith(
              cash: co.cash - c.spend,
              brandAwareness:
                  (co.brandAwareness + c.spend / 5_000)
                      .clamp(0.0, 100.0)
                      .toDouble(),
            ));
      case OpenWorkOrderCommand c:
        if (c.units <= 0) throw StateError('Units must be > 0');
        _state.updateCompany((co) => co.copyWith(
              productionRatePerTick:
                  co.productionRatePerTick + c.units / 600,
            ));
      case AddProductionLineCommand _:
        const lineCost = 80_000.0;
        if (session.company.cash < lineCost) {
          throw StateError('Not enough cash for production line');
        }
        _state.updateCompany((co) => co.copyWith(
              cash: co.cash - lineCost,
              productionRatePerTick: co.productionRatePerTick + 4,
            ));
      case PurchaseFleetCommand c:
        final cost = c.vehicles * 25_000.0;
        if (session.company.cash < cost) {
          throw StateError('Not enough cash for fleet');
        }
        _state.updateCompany((co) => co.copyWith(
              cash: co.cash - cost,
              fleet: co.fleet + c.vehicles,
            ));
      case DispatchShipmentCommand _:
        // Marked for the logistics engine; handled later in tick.
        break;
      case AcceptOrderCommand _:
        // Order acceptance flips status. Engines handle at next tick.
        break;
      case AnnouncementCommand c:
        _state.appendChairmanAnnouncement(c.body);
      case TogglePauseCommand _:
        _state.togglePause();
      case SetSpeedCommand c:
        _state.setSpeed(c.speed);
    }
  }

  Future<void> dispose() async {
    await _accepted.close();
    await _rejected.close();
  }
}

class RejectedCommand {
  RejectedCommand(this.command, this.reason);
  final SimulationCommand command;
  final String reason;
}
