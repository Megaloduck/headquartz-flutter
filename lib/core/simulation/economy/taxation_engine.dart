/// Period taxation calculation. Applied at month-ends (in-game).
class TaxationEngine {
  const TaxationEngine({this.rate = 0.18});
  final double rate;

  double monthly(double profit) => profit > 0 ? profit * rate : 0;
}
