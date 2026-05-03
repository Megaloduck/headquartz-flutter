import 'dart:math';

import '../../../data/models/company/company.dart';
import '../../../data/models/simulation/game_session.dart';
import '../../../data/models/company/kpi.dart';
import '../../../data/models/simulation/notification.dart';
import '../../config/game_constants.dart';
import '../economy/economy_engine.dart';
import '../market/demand_engine.dart';
import '../events/random_event_engine.dart';
import 'game_state_manager.dart';
import 'simulation_clock.dart';
import '../../config/simulation_constants.dart';
import 'package:uuid/uuid.dart';

/// Runs all simulation systems for a single tick.
///
/// Pure-ish: takes the current [GameSession] and produces the next one
/// via [GameStateManager.replace]. Subsystems may emit notifications.
class TickEngine {
  TickEngine({
    required GameStateManager state,
    required this.clock,
    required this.economy,
    required this.demand,
    required this.events,
    Random? random,
  })  : _state = state,
        _rng = random ?? Random();

  final GameStateManager _state;
  final SimulationClock clock;
  final EconomyEngine economy;
  final DemandEngine demand;
  final RandomEventEngine events;
  final Random _rng;
  static const _uuid = Uuid();

  /// Step one tick.
  void tick() {
    final s = _state.session;
    if (s.status != SessionStatus.running) return;

    final nextTick = s.tick + 1;
    final nextMinute = clock.gameMinutesAtTick(nextTick);

    // 1. Demand & market.
    var co = demand.applyTick(s.company, nextMinute, _rng);

    // 2. Production & sales (economy).
    co = economy.applyTick(co, nextMinute, _rng);

    // 3. Random events.
    final evtNotifications = events.maybeFire(co, nextMinute, _rng);

    // 4. KPI update (rolling history).
    co = _updateKpis(co);

    // 5. Bankruptcy / victory checks.
    final endReason = _checkEndConditions(co);

    var nextSession = s.copyWith(
      tick: nextTick,
      gameMinute: nextMinute,
      company: co,
    );

    if (endReason != SessionEndReason.none) {
      nextSession = nextSession.copyWith(
        status: SessionStatus.ended,
        endReason: endReason,
      );
    }

    if (evtNotifications.isNotEmpty) {
      final list = [...evtNotifications, ...nextSession.notifications];
      if (list.length > 200) list.removeRange(200, list.length);
      nextSession = nextSession.copyWith(notifications: list);
    }

    _state.replace(nextSession);
  }

  Company _updateKpis(Company co) {
    final updated = <Kpi>[];
    final byId = {for (final k in co.kpis) k.id: k};

    void push(String id, String label, double value, String unit) {
      final prev = byId[id];
      final history = [...?prev?.history, value];
      if (history.length > 60) history.removeAt(0);
      final delta = prev == null ? 0.0 : value - prev.value;
      updated.add(Kpi(
        id: id,
        label: label,
        value: value,
        unit: unit,
        delta: delta,
        history: history,
      ));
    }

    push('cash', 'Cash', co.cash, '\$');
    push('netWorth', 'Net Worth', co.netWorth, '\$');
    push('reputation', 'Reputation', co.reputation, '');
    push('morale', 'Employee Morale', co.morale, '');
    push('brandAwareness', 'Brand Awareness', co.brandAwareness, '');
    push('quality', 'Quality Score', co.qualityScore, '');
    push('stock', 'Units in Stock', co.unitsInStock.toDouble(), 'u');
    push('demand', 'Demand', co.demandPerTick, 'u/tick');
    push('production', 'Production', co.productionRatePerTick, 'u/tick');

    // Preserve any KPI not produced here.
    for (final k in co.kpis) {
      if (!updated.any((u) => u.id == k.id)) updated.add(k);
    }
    return co.copyWith(kpis: updated);
  }

  SessionEndReason _checkEndConditions(Company co) {
    if (co.cash + co.equity - co.debt <= GameConstants.bankruptcyThreshold) {
      return SessionEndReason.bankruptcy;
    }
    if (co.netWorth >= GameConstants.victoryNetWorth) {
      return SessionEndReason.victory;
    }
    return SessionEndReason.none;
  }
}

/// Convenience id helper for engines.
String genId() => const Uuid().v4();

/// Re-export tick period for the host scheduler.
const tickPeriodMs = SimulationConstants.tickPeriodMs;

/// Build a default session for a brand-new game.
GameSession makeStartingSession({
  required String id,
  required String name,
  required String companyName,
}) {
  return GameSession(
    id: id,
    name: name,
    players: const [],
    status: SessionStatus.lobby,
    tick: 0,
    gameMinute: 0,
    company: Company(
      name: companyName,
      cash: GameConstants.startingCash,
      equity: GameConstants.startingEquity,
      debt: GameConstants.startingDebt,
      reputation: GameConstants.startingReputation,
      morale: 70,
      brandAwareness: 30,
      qualityScore: 75,
      unitsInStock: 0,
      unitPrice: GameConstants.defaultUnitSalePrice,
      productionRatePerTick: 1.5,
      demandPerTick: 1.0,
      employees: GameConstants.startingEmployees,
      fleet: 2,
      kpis: const [],
    ),
    notifications: const [],
    chat: const [],
    orders: const [],
    shipments: const [],
  );
}

// Empty notification stub — sometimes used during initialisation.
GameNotification _stubNotification() => GameNotification(
      id: _uuid.v4(),
      title: '',
      body: '',
      severity: NotificationSeverity.info,
      timestamp: DateTime.now(),
    );

// suppress unused warning when unused.
// ignore: unused_element
final _u = _stubNotification;
const _uuid = Uuid();
