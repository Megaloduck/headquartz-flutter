/// Simulation timing & tick constants.
class SimulationConstants {
  SimulationConstants._();

  /// Real-time tick rate (Hz). 10 Hz strikes a good balance for
  /// realtime feel without over-broadcasting.
  static const int tickRateHz = 10;

  /// One tick equals this many in-game seconds.
  /// 6 in-game seconds per real tick → 1 real second = 60 in-game seconds.
  /// So 1 in-game minute = 1 real second. Adjust to slow / speed up.
  static const int inGameSecondsPerTick = 6;

  /// Tick period in real-time milliseconds.
  static const int tickPeriodMs = 1000 ~/ tickRateHz; // 100ms

  /// Default playback speed (1.0 = normal).
  static const double defaultSpeed = 1.0;
  static const List<double> availableSpeeds = [0.5, 1.0, 2.0, 4.0];

  /// Snapshots are taken every N ticks for replay/recovery.
  static const int snapshotEveryTicks = 50;

  /// Game day length in in-game minutes.
  static const int minutesPerGameDay = 24 * 60;
}
