/// Gameplay-tuning constants. Centralised to support balancing.
class GameConstants {
  GameConstants._();

  // ── Player slots ─────────────────────────────────────────────────
  static const int maxPlayers = 8; // 7 active + 1 chairman observer
  static const int minPlayersToStart = 2;

  // ── Starting economy ─────────────────────────────────────────────
  static const double startingCash = 500_000;
  static const double startingEquity = 250_000;
  static const double startingDebt = 0;
  static const double startingReputation = 50;
  static const int startingEmployees = 12;

  // ── Pricing / production defaults ───────────────────────────────
  static const double defaultUnitProductionCost = 35;
  static const double defaultUnitSalePrice = 79;
  static const double defaultLogisticsCostPerUnit = 4.5;
  static const double defaultStorageCostPerUnit = 0.8;

  // ── Bounds ───────────────────────────────────────────────────────
  static const double minReputation = 0;
  static const double maxReputation = 100;
  static const double minMorale = 0;
  static const double maxMorale = 100;

  // ── Victory / loss conditions ───────────────────────────────────
  static const double victoryNetWorth = 5_000_000;
  static const double bankruptcyThreshold = -250_000;

  // ── Misc tuning ──────────────────────────────────────────────────
  static const double demandSeasonalityAmplitude = 0.18;
  static const double aiCompetitorAggressiveness = 0.5;
  static const double crisisBaseProbability = 0.012; // per minute
}
