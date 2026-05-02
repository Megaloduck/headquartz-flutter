// lib/providers/game_provider.dart
//
// Riverpod 3 providers — uses Notifier API (ChangeNotifierProvider removed in v3).

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/models/game_state.dart';
import '../core/services/simulation_engine.dart';

// ── 1. Engine provider ────────────────────────────────────────────────────────

final gameEngineProvider = Provider<SimulationEngine>((ref) {
  final engine = SimulationEngine(
    initialState: GameState.initial(),
    tickRate: const Duration(seconds: 1),
  );
  ref.onDispose(engine.dispose);
  return engine;
});

// ── 2. GameState stream ───────────────────────────────────────────────────────

final gameStateProvider = StreamProvider<GameState>((ref) {
  final engine = ref.watch(gameEngineProvider);
  return engine.stateStream;
});

// ── 3. SimControl state ───────────────────────────────────────────────────────

class SimControlState {
  final bool isRunning;
  final bool isPaused;
  final double speedMultiplier;

  const SimControlState({
    this.isRunning = false,
    this.isPaused = false,
    this.speedMultiplier = 1.0,
  });

  SimControlState copyWith({
    bool? isRunning,
    bool? isPaused,
    double? speedMultiplier,
  }) =>
      SimControlState(
        isRunning: isRunning ?? this.isRunning,
        isPaused: isPaused ?? this.isPaused,
        speedMultiplier: speedMultiplier ?? this.speedMultiplier,
      );
}

// ── 4. SimControl Notifier (Riverpod 3 Notifier API) ─────────────────────────

class SimControlNotifier extends Notifier<SimControlState> {
  SimulationEngine get _engine => ref.read(gameEngineProvider);

  @override
  SimControlState build() => const SimControlState();

  Future<void> start() async {
    await _engine.start();
    state = state.copyWith(isRunning: true, isPaused: false);
  }

  void stop() {
    _engine.stop();
    state = state.copyWith(isRunning: false, isPaused: false);
  }

  void pause() {
    _engine.pause();
    state = state.copyWith(isPaused: true);
  }

  void resume() {
    _engine.resume();
    state = state.copyWith(isPaused: false);
  }

  void setSpeed(double multiplier) {
    final clamped = multiplier.clamp(0.25, 10.0);
    final ms = (1000 / clamped).round();
    _engine.setTickRate(Duration(milliseconds: ms));
    state = state.copyWith(speedMultiplier: clamped);
  }

  /// Apply a player action. Pass a pure function: (GameState) → GameState.
  void dispatch(GameState Function(GameState) action) {
    final next = action(_engine.lastState);
    _engine.applyStateUpdate(next);
  }
}

final simControlProvider =
    NotifierProvider<SimControlNotifier, SimControlState>(
  SimControlNotifier.new,
);

// ── 5. Convenience selectors ──────────────────────────────────────────────────

final financeStateProvider =
    Provider((ref) => ref.watch(gameStateProvider).whenData((s) => s.finance));

final hrStateProvider =
    Provider((ref) => ref.watch(gameStateProvider).whenData((s) => s.humanResource));

final warehouseStateProvider =
    Provider((ref) => ref.watch(gameStateProvider).whenData((s) => s.warehouse));

final productionStateProvider =
    Provider((ref) => ref.watch(gameStateProvider).whenData((s) => s.production));

final salesStateProvider =
    Provider((ref) => ref.watch(gameStateProvider).whenData((s) => s.sales));

final marketingStateProvider =
    Provider((ref) => ref.watch(gameStateProvider).whenData((s) => s.marketing));

final logisticsStateProvider =
    Provider((ref) => ref.watch(gameStateProvider).whenData((s) => s.logistics));

final marketStateProvider =
    Provider((ref) => ref.watch(gameStateProvider).whenData((s) => s.market));