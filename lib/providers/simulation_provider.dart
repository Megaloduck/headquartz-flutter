// lib/providers/simulation_provider.dart
//
// Riverpod providers that wire SimulationEngine → UI.
//
// Usage in any widget:
//   final state = ref.watch(gameStateProvider).value;
//   final engine = ref.read(simulationEngineProvider);
//   engine.start();

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/models/game_state.dart';
import '../core/services/seed_service.dart';
import '../core/services/simulation_engine.dart';

// ── 1. The engine itself — lives for the app lifetime ────────────────────────

final simulationEngineProvider = Provider<SimulationEngine>((ref) {
  final seededState = SeedService.seed(GameState.initial());

  final engine = SimulationEngine(
    initialState: seededState,
    tickRate: const Duration(seconds: 1),
  );

  // Auto-dispose: stop the Isolate when the provider is destroyed
  ref.onDispose(engine.dispose);

  return engine;
});

// ── 2. Game state stream — rebuilds widgets on every tick ────────────────────

final gameStateProvider = StreamProvider<GameState>((ref) {
  final engine = ref.watch(simulationEngineProvider);
  return engine.stateStream;
});

// ── 3. Convenience sub-providers — watch only what you need ─────────────────
//      These prevent unnecessary rebuilds in role-specific screens.

final cashProvider = Provider<double>((ref) {
  return ref.watch(gameStateProvider).value?.finance.cash ?? 0.0;
});

final marketDemandProvider = Provider<int>((ref) {
  return ref.watch(gameStateProvider).value?.market.demand ?? 0;
});

final marketPriceProvider = Provider<double>((ref) {
  return ref.watch(gameStateProvider).value?.market.price ?? 0.0;
});

final marketTrendProvider = Provider<String>((ref) {
  return ref.watch(gameStateProvider).value?.market.trendDescription ??
      'Loading...';
});

final totalStockProvider = Provider<int>((ref) {
  return ref.watch(gameStateProvider).value?.warehouse.totalStock ?? 0;
});

final warehouseProductsProvider = Provider((ref) {
  return ref.watch(gameStateProvider).value?.warehouse.products ?? [];
});

final moraleProvider = Provider<double>((ref) {
  return ref.watch(gameStateProvider).value?.humanResource.moraleLevel ?? 0.75;
});

final simTimeProvider = Provider<DateTime>((ref) {
  return ref.watch(gameStateProvider).value?.simTime ?? DateTime.utc(2025);
});

final priceHistoryProvider = Provider<List<double>>((ref) {
  return ref.watch(gameStateProvider).value?.market.priceHistory ?? [];
});

// ── 4. Engine control notifier — start / stop / speed ───────────────────────

class SimControlNotifier extends Notifier<bool> {
  @override
  bool build() => false; // isRunning

  Future<void> startEngine() async {
    final engine = ref.read(simulationEngineProvider);
    if (!engine.isRunning) {
      await engine.start();
    }
    state = engine.isRunning;
  }

  void stopEngine() {
    ref.read(simulationEngineProvider).stop();
    state = false;
  }

  void toggleEngine() {
    state ? stopEngine() : startEngine();
  }

  void setSpeed(SimSpeed speed) {
    ref.read(simulationEngineProvider).setTickRate(speed.duration);
  }
}

final simControlProvider =
    NotifierProvider<SimControlNotifier, bool>(SimControlNotifier.new);

// ── 5. Simulation speed enum ─────────────────────────────────────────────────

enum SimSpeed {
  normal(Duration(seconds: 1), 'Normal'),
  fast(Duration(milliseconds: 500), 'Fast ×2'),
  veryFast(Duration(milliseconds: 200), 'Fast ×5'),
  paused(Duration(days: 999), 'Paused');

  const SimSpeed(this.duration, this.label);
  final Duration duration;
  final String label;
}