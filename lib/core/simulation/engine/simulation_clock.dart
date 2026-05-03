import '../../config/simulation_constants.dart';

/// Pure clock — converts real-time ticks into in-game minutes.
///
/// Stateless math; the canonical tick counter lives on [GameSession].
class SimulationClock {
  const SimulationClock();

  /// In-game minutes elapsed for a given tick count.
  int gameMinutesAtTick(int tick) {
    final inGameSeconds = tick * SimulationConstants.inGameSecondsPerTick;
    return inGameSeconds ~/ 60;
  }

  /// In-game day index (1-based).
  int dayAtTick(int tick) {
    final m = gameMinutesAtTick(tick);
    return (m ~/ SimulationConstants.minutesPerGameDay) + 1;
  }

  /// In-game time of day (HH:MM).
  ({int hour, int minute}) clockAtTick(int tick) {
    final m = gameMinutesAtTick(tick) % SimulationConstants.minutesPerGameDay;
    return (hour: m ~/ 60, minute: m % 60);
  }

  /// Real-time duration spent for [tickCount].
  Duration realDurationForTicks(int tickCount) =>
      Duration(milliseconds: tickCount * SimulationConstants.tickPeriodMs);
}
