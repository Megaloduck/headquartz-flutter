// lib/core/services/simulation_engine.dart
//
// Spawns a Dart Isolate that runs the game tick loop.
// The main thread sends commands; the Isolate emits GameState on every tick.
//
// TICK PIPELINE ORDER (matters — modules depend on each other):
//   1. MarketModule    — updates demand/price, applies campaign boosts
//   2. HRModule        — wages, morale, productivity multiplier
//   3. ProductionModule — machines tick, work orders advance → units → warehouse
//   4. WarehouseModule — passive auto-sell (legacy path for products without work orders)
//   5. MarketingModule — campaign spend, brand drift, conversion rate update
//   6. SalesModule     — inbound orders generated, processed, revenue booked
//   7. LogisticsModule — shipments advance, vehicles degrade, shipping costs
//   8. FinanceModule   — settles revenue/expense → cash, trims ledger

import 'dart:async';
import 'dart:isolate';

import '../models/game_state.dart';
import '../modules/finance_module.dart';
import '../modules/hr_module.dart';
import '../modules/logistics_module.dart';
import '../modules/market_module.dart';
import '../modules/marketing_module.dart';
import '../modules/production_module.dart';
import '../modules/sales_module.dart';
import '../modules/warehouse_module.dart';
import '../services/seed_service.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Isolate message types
// ─────────────────────────────────────────────────────────────────────────────

class _IsolateArgs {
  final SendPort sendPort;
  final GameState initialState;
  final Duration tickRate;
  const _IsolateArgs({
    required this.sendPort,
    required this.initialState,
    required this.tickRate,
  });
}

class _CmdStart {}
class _CmdStop {}
class _CmdPause {}
class _CmdResume {}
class _CmdSetTickRate { final Duration rate; const _CmdSetTickRate(this.rate); }
class _CmdUpdateState { final GameState state; const _CmdUpdateState(this.state); }

// ─────────────────────────────────────────────────────────────────────────────
// Isolate entry point — runs entirely in the Isolate
// NO Flutter imports, NO UI references.
// ─────────────────────────────────────────────────────────────────────────────

void _simulationLoop(_IsolateArgs args) async {
  final mainPort = args.sendPort;
  final receivePort = ReceivePort();

  // Hand our SendPort back to main thread immediately
  mainPort.send(receivePort.sendPort);

  GameState state = SeedService.seed(args.initialState);
  Duration tickRate = args.tickRate;
  bool running = false;
  bool paused = false;
  Timer? timer;

  void tick() {
    if (!running || paused) return;

    // ── Full 8-module pipeline ────────────────────────────────────────
    state = MarketModule.update(state);
    state = HumanResourceModule.update(state);
    state = ProductionModule.update(state);
    state = WarehouseModule.update(state);
    state = MarketingModule.update(state);
    state = SalesModule.update(state);
    state = LogisticsModule.update(state);
    state = FinanceModule.update(state);

    // Advance sim clock by tickRate
    state = state.copyWith(
      simTime: state.simTime.add(tickRate),
    );

    mainPort.send(state);
  }

  receivePort.listen((msg) {
    if (msg is _CmdStart) {
      running = true;
      paused = false;
      timer?.cancel();
      timer = Timer.periodic(tickRate, (_) => tick());
    } else if (msg is _CmdStop) {
      running = false;
      timer?.cancel();
    } else if (msg is _CmdPause) {
      paused = true;
    } else if (msg is _CmdResume) {
      paused = false;
    } else if (msg is _CmdSetTickRate) {
      tickRate = msg.rate;
      if (running) {
        timer?.cancel();
        timer = Timer.periodic(tickRate, (_) => tick());
      }
    } else if (msg is _CmdUpdateState) {
      // Player action applied — update state immediately
      state = msg.state;
      mainPort.send(state);
    }
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// SimulationEngine — used from the Flutter/Riverpod layer
// ─────────────────────────────────────────────────────────────────────────────

class SimulationEngine {
  Isolate? _isolate;
  ReceivePort? _receivePort;
  SendPort? _isolateSendPort;

  final _stateController = StreamController<GameState>.broadcast();

  bool _isRunning = false;
  bool _isPaused = false;
  Duration _tickRate;
  GameState _lastKnownState;

  SimulationEngine({
    required GameState initialState,
    Duration tickRate = const Duration(seconds: 1),
  })  : _lastKnownState = initialState,
        _tickRate = tickRate;

  // ── Public API ──────────────────────────────────────────────────────────────

  Stream<GameState> get stateStream => _stateController.stream;
  bool get isRunning => _isRunning;
  bool get isPaused => _isPaused;
  Duration get tickRate => _tickRate;
  GameState get lastState => _lastKnownState;

  /// Spawns the Isolate and begins the simulation tick loop.
  Future<void> start() async {
    if (_isRunning) return;

    _receivePort = ReceivePort();
    final completer = Completer<SendPort>();

    _receivePort!.listen((message) {
      if (message is SendPort) {
        completer.complete(message);
      } else if (message is GameState) {
        _lastKnownState = message;
        _stateController.add(message);
      }
    });

    _isolate = await Isolate.spawn(
      _simulationLoop,
      _IsolateArgs(
        sendPort: _receivePort!.sendPort,
        initialState: _lastKnownState,
        tickRate: _tickRate,
      ),
      debugName: 'SimulationEngine',
    );

    _isolateSendPort = await completer.future;
    _isolateSendPort!.send(_CmdStart());
    _isRunning = true;
    _isPaused = false;
  }

  /// Pause the tick loop (engine stays alive, just stops ticking).
  void pause() {
    if (!_isRunning || _isPaused) return;
    _isolateSendPort?.send(_CmdPause());
    _isPaused = true;
  }

  /// Resume after pause.
  void resume() {
    if (!_isRunning || !_isPaused) return;
    _isolateSendPort?.send(_CmdResume());
    _isPaused = false;
  }

  /// Stops the tick loop and kills the Isolate.
  void stop() {
    if (!_isRunning) return;
    _isolateSendPort?.send(_CmdStop());
    _isolate?.kill(priority: Isolate.immediate);
    _receivePort?.close();
    _isolate = null;
    _receivePort = null;
    _isolateSendPort = null;
    _isRunning = false;
    _isPaused = false;
  }

  /// Change tick speed at runtime (e.g. fast-forward mode).
  void setTickRate(Duration newRate) {
    _tickRate = newRate;
    _isolateSendPort?.send(_CmdSetTickRate(newRate));
  }

  /// Push a player action's resulting GameState into the isolate.
  /// Call this after any GameActions.xxx() call.
  void applyStateUpdate(GameState updated) {
    _lastKnownState = updated;
    _isolateSendPort?.send(_CmdUpdateState(updated));
    _stateController.add(updated);
  }

  /// Clean up everything — call from provider's onDispose.
  void dispose() {
    stop();
    _stateController.close();
  }
}