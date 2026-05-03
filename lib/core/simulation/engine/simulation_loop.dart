import 'dart:async';

import '../../config/simulation_constants.dart';
import '../../utils/logger.dart';
import 'tick_engine.dart';

/// Drives the [TickEngine] at [SimulationConstants.tickRateHz].
///
/// Lives only on the host. Clients receive the resulting state changes
/// via the network.
class SimulationLoop {
  SimulationLoop({required this.engine});

  final TickEngine engine;
  Timer? _timer;
  double _speed = 1.0;
  bool _isRunning = false;

  bool get isRunning => _isRunning;

  void start() {
    if (_isRunning) return;
    _isRunning = true;
    _scheduleNext();
    logSim.i('SimulationLoop started at ${SimulationConstants.tickRateHz}Hz');
  }

  void stop() {
    _isRunning = false;
    _timer?.cancel();
    _timer = null;
    logSim.i('SimulationLoop stopped');
  }

  void setSpeed(double speed) {
    _speed = speed.clamp(0.25, 8.0);
    if (_isRunning) {
      _timer?.cancel();
      _scheduleNext();
    }
  }

  void _scheduleNext() {
    if (!_isRunning) return;
    final periodMs =
        (SimulationConstants.tickPeriodMs / _speed).round().clamp(8, 1000);
    _timer = Timer.periodic(Duration(milliseconds: periodMs), (_) {
      try {
        engine.tick();
      } catch (e, st) {
        logSim.e('Tick error', e, st);
      }
    });
  }
}
