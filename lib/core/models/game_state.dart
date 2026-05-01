// lib/core/models/game_state.dart
//
// Plain immutable Dart class — intentionally NO freezed dependency.
// This class is sent across Isolate boundaries via SendPort.send(),
// which requires the object to be a primitive or implement the
// Dart object copy protocol. Keeping it plain Dart ensures full
// Isolate compatibility without special handling.

import 'company.dart';
import 'finance.dart';
import 'human_resource.dart';
import 'market.dart';
import 'player_role.dart';
import 'warehouse.dart';

class GameState {
  final DateTime simTime;
  final PlayerRole currentRole;
  final Company company;
  final Market market;
  final Finance finance;
  final Warehouse warehouse;
  final HumanResource humanResource;

  const GameState({
    required this.simTime,
    required this.currentRole,
    required this.company,
    required this.market,
    required this.finance,
    required this.warehouse,
    required this.humanResource,
  });

  GameState copyWith({
    DateTime? simTime,
    PlayerRole? currentRole,
    Company? company,
    Market? market,
    Finance? finance,
    Warehouse? warehouse,
    HumanResource? humanResource,
  }) {
    return GameState(
      simTime: simTime ?? this.simTime,
      currentRole: currentRole ?? this.currentRole,
      company: company ?? this.company,
      market: market ?? this.market,
      finance: finance ?? this.finance,
      warehouse: warehouse ?? this.warehouse,
      humanResource: humanResource ?? this.humanResource,
    );
  }

  Map<String, dynamic> toJson() => {
        'simTime': simTime.toIso8601String(),
        'currentRole': currentRole.name,
        'company': company.toJson(),
        'market': market.toJson(),
        'finance': finance.toJson(),
        'warehouse': warehouse.toJson(),
        'humanResource': humanResource.toJson(),
      };

  factory GameState.fromJson(Map<String, dynamic> json) => GameState(
        simTime: DateTime.parse(json['simTime'] as String),
        currentRole: PlayerRole.values.firstWhere(
          (r) => r.name == json['currentRole'],
          orElse: () => PlayerRole.ceo,
        ),
        company: Company.fromJson(json['company'] as Map<String, dynamic>),
        market: Market.fromJson(json['market'] as Map<String, dynamic>),
        finance: Finance.fromJson(json['finance'] as Map<String, dynamic>),
        warehouse:
            Warehouse.fromJson(json['warehouse'] as Map<String, dynamic>),
        humanResource: HumanResource.fromJson(
            json['humanResource'] as Map<String, dynamic>),
      );

  /// Initial seeded state for a new game
  factory GameState.initial() => GameState(
        simTime: DateTime.utc(2025, 1, 1, 8, 0, 0),
        currentRole: PlayerRole.ceo,
        company: const Company(name: 'Headquartz Corp', level: 1),
        market: const Market(demand: 50, price: 50.0),
        finance: const Finance(cash: 10000.0),
        warehouse: const Warehouse(),
        humanResource: const HumanResource(),
      );
}