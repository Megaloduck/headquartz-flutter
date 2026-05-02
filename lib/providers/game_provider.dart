// lib/providers/game_provider.dart
//
// Riverpod providers that bridge SimulationEngine ↔ Flutter UI.
//
// Usage in any widget:
//   final state = ref.watch(gameStateProvider);
//   ref.read(gameEngineProvider).applyStateUpdate(
//     GameActions.hireEmployee(state, wage: 3000),
//   );

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/actions/game_actions.dart';
import '../core/models/game_state.dart';
import '../core/services/simulation_engine.dart';

// ─────────────────────────────────────────────
// 1. Engine provider (singleton, auto-disposed on last listener)
// ─────────────────────────────────────────────

final gameEngineProvider = Provider<SimulationEngine>((ref) {
  final engine = SimulationEngine(
    initialState: GameState.initial(),
    tickRate: const Duration(seconds: 1),
  );

  ref.onDispose(engine.dispose);
  return engine;
});

// ─────────────────────────────────────────────
// 2. GameState stream provider — rebuilds UI on every tick
// ─────────────────────────────────────────────

final gameStateProvider = StreamProvider<GameState>((ref) {
  final engine = ref.watch(gameEngineProvider);
  return engine.stateStream;
});

// ─────────────────────────────────────────────
// 3. Simulation control notifier
//    Exposes start/stop/pause/resume/setSpeed
// ─────────────────────────────────────────────

class SimControlNotifier extends ChangeNotifier {
  final SimulationEngine _engine;

  bool get isRunning => _engine.isRunning;
  bool get isPaused => _engine.isPaused;
  double _speedMultiplier = 1.0;
  double get speedMultiplier => _speedMultiplier;

  SimControlNotifier(this._engine);

  Future<void> start() async {
    await _engine.start();
    notifyListeners();
  }

  void stop() {
    _engine.stop();
    notifyListeners();
  }

  void pause() {
    _engine.pause();
    notifyListeners();
  }

  void resume() {
    _engine.resume();
    notifyListeners();
  }

  void setSpeed(double multiplier) {
    _speedMultiplier = multiplier.clamp(0.25, 10.0);
    final ms = (1000 / _speedMultiplier).round();
    _engine.setTickRate(Duration(milliseconds: ms));
    notifyListeners();
  }

  /// Apply a player action — wraps applyStateUpdate.
  void dispatch(GameState Function(GameState) action) {
    final next = action(_engine.lastState);
    _engine.applyStateUpdate(next);
  }
}

final simControlProvider = ChangeNotifierProvider<SimControlNotifier>((ref) {
  final engine = ref.watch(gameEngineProvider);
  return SimControlNotifier(engine);
});

// ─────────────────────────────────────────────
// 4. Convenience selector providers
//    Use these in department screens instead of watching entire GameState
// ─────────────────────────────────────────────

final financeStateProvider = Provider<AsyncValue<dynamic>>((ref) {
  return ref.watch(gameStateProvider).whenData((s) => s.finance);
});

final hrStateProvider = Provider<AsyncValue<dynamic>>((ref) {
  return ref.watch(gameStateProvider).whenData((s) => s.humanResource);
});

final warehouseStateProvider = Provider<AsyncValue<dynamic>>((ref) {
  return ref.watch(gameStateProvider).whenData((s) => s.warehouse);
});

final productionStateProvider = Provider<AsyncValue<dynamic>>((ref) {
  return ref.watch(gameStateProvider).whenData((s) => s.production);
});

final salesStateProvider = Provider<AsyncValue<dynamic>>((ref) {
  return ref.watch(gameStateProvider).whenData((s) => s.sales);
});

final marketingStateProvider = Provider<AsyncValue<dynamic>>((ref) {
  return ref.watch(gameStateProvider).whenData((s) => s.marketing);
});

final logisticsStateProvider = Provider<AsyncValue<dynamic>>((ref) {
  return ref.watch(gameStateProvider).whenData((s) => s.logistics);
});

final marketStateProvider = Provider<AsyncValue<dynamic>>((ref) {
  return ref.watch(gameStateProvider).whenData((s) => s.market);
});