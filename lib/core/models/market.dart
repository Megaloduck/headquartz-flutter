// lib/core/models/market.dart

class Market {
  final int demand;          // 0–100
  final double price;        // current market price
  final double baseDemand;
  final double priceSensitivity;
  final String trendDescription;
  final List<double> priceHistory; // last 20 ticks for sparkline

  const Market({
    this.demand = 50,
    this.price = 50.0,
    this.baseDemand = 100.0,
    this.priceSensitivity = 1.2,
    this.trendDescription = '➡ Stable Market',
    this.priceHistory = const [],
  });

  Market copyWith({
    int? demand,
    double? price,
    double? baseDemand,
    double? priceSensitivity,
    String? trendDescription,
    List<double>? priceHistory,
  }) {
    return Market(
      demand: demand ?? this.demand,
      price: price ?? this.price,
      baseDemand: baseDemand ?? this.baseDemand,
      priceSensitivity: priceSensitivity ?? this.priceSensitivity,
      trendDescription: trendDescription ?? this.trendDescription,
      priceHistory: priceHistory ?? this.priceHistory,
    );
  }

  Map<String, dynamic> toJson() => {
        'demand': demand,
        'price': price,
        'baseDemand': baseDemand,
        'priceSensitivity': priceSensitivity,
        'trendDescription': trendDescription,
        'priceHistory': priceHistory,
      };

  factory Market.fromJson(Map<String, dynamic> json) => Market(
        demand: json['demand'] as int,
        price: (json['price'] as num).toDouble(),
        baseDemand: (json['baseDemand'] as num).toDouble(),
        priceSensitivity: (json['priceSensitivity'] as num).toDouble(),
        trendDescription: json['trendDescription'] as String,
        priceHistory: (json['priceHistory'] as List<dynamic>? ?? [])
            .map((e) => (e as num).toDouble())
            .toList(),
      );
}