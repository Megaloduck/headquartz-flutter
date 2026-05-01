// lib/core/models/finance.dart

class Finance {
  final double cash;
  final double revenuePerTick;
  final double expensePerTick;
  final double totalRevenue;
  final double totalExpenses;
  final List<FinanceLedgerEntry> ledger;

  const Finance({
    this.cash = 10000.0,
    this.revenuePerTick = 0.0,
    this.expensePerTick = 0.0,
    this.totalRevenue = 0.0,
    this.totalExpenses = 0.0,
    this.ledger = const [],
  });

  double get profitPerTick => revenuePerTick - expensePerTick;
  double get netProfit => totalRevenue - totalExpenses;

  Finance copyWith({
    double? cash,
    double? revenuePerTick,
    double? expensePerTick,
    double? totalRevenue,
    double? totalExpenses,
    List<FinanceLedgerEntry>? ledger,
  }) {
    return Finance(
      cash: cash ?? this.cash,
      revenuePerTick: revenuePerTick ?? this.revenuePerTick,
      expensePerTick: expensePerTick ?? this.expensePerTick,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      totalExpenses: totalExpenses ?? this.totalExpenses,
      ledger: ledger ?? this.ledger,
    );
  }

  Map<String, dynamic> toJson() => {
        'cash': cash,
        'revenuePerTick': revenuePerTick,
        'expensePerTick': expensePerTick,
        'totalRevenue': totalRevenue,
        'totalExpenses': totalExpenses,
        'ledger': ledger.map((e) => e.toJson()).toList(),
      };

  factory Finance.fromJson(Map<String, dynamic> json) => Finance(
        cash: (json['cash'] as num).toDouble(),
        revenuePerTick: (json['revenuePerTick'] as num).toDouble(),
        expensePerTick: (json['expensePerTick'] as num).toDouble(),
        totalRevenue: (json['totalRevenue'] as num).toDouble(),
        totalExpenses: (json['totalExpenses'] as num).toDouble(),
        ledger: (json['ledger'] as List<dynamic>? ?? [])
            .map((e) => FinanceLedgerEntry.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

class FinanceLedgerEntry {
  final String description;
  final double amount; // positive = revenue, negative = expense
  final DateTime timestamp;

  const FinanceLedgerEntry({
    required this.description,
    required this.amount,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'description': description,
        'amount': amount,
        'timestamp': timestamp.toIso8601String(),
      };

  factory FinanceLedgerEntry.fromJson(Map<String, dynamic> json) =>
      FinanceLedgerEntry(
        description: json['description'] as String,
        amount: (json['amount'] as num).toDouble(),
        timestamp: DateTime.parse(json['timestamp'] as String),
      );
}