// lib/core/services/simulation_engine.dart
//
// The heart of Headquartz. Runs the entire simulation tick loop
// inside a dedicated Dart Isolate so the UI thread is never blocked.
//
// Architecture:
//   Main thread                    Isolate
//   ──────────────────             ─────────────────────────────
//   SimulationEngine               _simulationLoop()
//     .start()  ──sendPort──▶      Timer.periodic(1s)
//                                    → MarketModule.update()
//                                    → WarehouseModule.update()
//                                    → HumanResourceModule.update()
//                                    → FinanceModule.update()  (last)
//               ◀──GameState──     sendPort.send(state)
//   _receivePort.listen()
//     → _stateController.add()
//       → StreamProvider<GameState> rebuilds UI widgets

import 'dart:async';
import 'dart:isolate';

import '../models/game_state.dart';
import '../modules/finance_module.dart';
import '../modules/hr_module.dart';
import '../modules/market_module.dart';
import '../modules/warehouse_module.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Message types sent FROM main thread TO isolate
// ─────────────────────────────────────────────────────────────────────────────

sealed class _EngineCommand {}

final class _CmdStart extends _EngineCommand {}

final class _CmdStop extends _EngineCommand {}

final class _CmdSetTickRate extends _EngineCommand {
  final Duration tickRate;
  _CmdSetTickRate(this.tickRate);
}

final class _CmdUpdateState extends _EngineCommand {
  final GameState state;
  _CmdUpdateState(this.state);
}

// ─────────────────────────────────────────────────────────────────────────────
// Bootstrap args passed to the Isolate at spawn time
// ─────────────────────────────────────────────────────────────────────────────

final class _IsolateArgs {
  final SendPort sendPort;    // Isolate sends GameState back here
  final GameState initialState;
  final Duration tickRate;

  const _IsolateArgs({
    required this.sendPort,
    required this.initialState,
    required this.tickRate,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// SimulationEngine — public API used by the Riverpod provider
// ─────────────────────────────────────────────────────────────────────────────

class SimulationEngine {
  Isolate? _isolate;
  ReceivePort? _receivePort;
  SendPort? _isolateSendPort; // port to send commands TO the isolate

  final _stateController = StreamController<GameState>.broadcast();

  bool _isRunning = false;
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
  Duration get tickRate => _tickRate;
  GameState get lastState => _lastKnownState;

  /// Spawns the Isolate and begins the simulation tick loop.
  Future<void> start() async {
    if (_isRunning) return;

    _receivePort = ReceivePort();

    // First message from isolate is its own SendPort so we can send commands
    final completer = Completer<SendPort>();

    _receivePort!.listen((message) {
      if (message is SendPort) {
        // Isolate is ready — store its command port
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
  }

  /// Change tick speed at runtime (e.g. fast-forward mode).
  void setTickRate(Duration newRate) {
    _tickRate = newRate;
    _isolateSendPort?.send(_CmdSetTickRate(newRate));
  }

  /// Push an externally modified GameState into the isolate
  /// (e.g. user manually bought stock, hired an employee, etc.)
  void applyStateUpdate(GameState updated) {
    _lastKnownState = updated;
    _isolateSendPort?.send(_CmdUpdateState(updated));
    // Also emit immediately so UI reflects the change without waiting for tick
    _stateController.add(updated);
  }

  /// Clean up everything — call from provider's onDispose.
  void dispose() {
    stop();
    _stateController.close();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _simulationLoop — runs entirely inside the Isolate
// NO Flutter imports, NO UI references allowed here.
// ─────────────────────────────────────────────────────────────────────────────

void _simulationLoop(_IsolateArgs args) {
  var state = args.initialState;
  var tickRate = args.tickRate;
  Timer? timer;
  bool running = false;

  // Set up our own ReceivePort so main thread can send us commands
  final commandPort = ReceivePort();

  // Send our SendPort back to the main thread immediately
  args.sendPort.send(commandPort.sendPort);

  commandPort.listen((message) {
    if (message is _CmdStart) {
      if (running) return;
      running = true;
      timer = Timer.periodic(tickRate, (_) {
        // ── Tick pipeline (order matters) ──
        state = state.copyWith(
          simTime: state.simTime.add(tickRate),
        );
        state = MarketModule.update(state);
        state = WarehouseModule.update(state);
        state = HumanResourceModule.update(state);
        state = FinanceModule.update(state); // always last — settles cash

        // Push updated state to main thread
        args.sendPort.send(state);
      });
    } else if (message is _CmdStop) {
      timer?.cancel();
      timer = null;
      running = false;
    } else if (message is _CmdSetTickRate) {
      tickRate = message.tickRate;
      if (running) {
        // Restart timer with new rate
        timer?.cancel();
        timer = Timer.periodic(tickRate, (_) {
          state = state.copyWith(simTime: state.simTime.add(tickRate));
          state = MarketModule.update(state);
          state = WarehouseModule.update(state);
          state = HumanResourceModule.update(state);
          state = FinanceModule.update(state);
          args.sendPort.send(state);
        });
      }
    } else if (message is _CmdUpdateState) {
      // Accept external state change (user action from UI)
      state = message.state;
    }
  });
}