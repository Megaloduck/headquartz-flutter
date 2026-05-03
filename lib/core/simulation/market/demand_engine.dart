import 'dart:math';

import '../../../data/models/company/company.dart';
import '../../config/game_constants.dart';
import '../../config/simulation_constants.dart';
import '../economy/pricing_engine.dart';

/// Updates market demand each tick using brand awareness, reputation,
/// price elasticity, and a daily seasonal sine wave.
class DemandEngine {
  const DemandEngine({this.pricing = const PricingEngine()});
  final PricingEngine pricing;

  Company applyTick(Company co, int gameMinute, Random rng) {
    final dayMinute = gameMinute % SimulationConstants.minutesPerGameDay;
    final dayPhase = dayMinute / SimulationConstants.minutesPerGameDay;
    final seasonal =
        1 + GameConstants.demandSeasonalityAmplitude * sin(2 * pi * dayPhase);

    final brandLift = 1 + co.brandAwareness / 200; // up to +50%
    final repLift = 1 + (co.reputation - 50) / 200; // -25%..+25%
    final elasticity = pricing.elasticity(currentPrice: co.unitPrice);
    final noise = 1 + (rng.nextDouble() - 0.5) * 0.05;

    final base = 2.0; // baseline demand units / tick
    final demand =
        base * seasonal * brandLift * repLift * elasticity * noise;

    return co.copyWith(demandPerTick: max(0.1, demand));
  }
}
