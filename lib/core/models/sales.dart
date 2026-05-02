// lib/core/models/sales.dart
//
// Isolate-safe — plain Dart, no Flutter imports.

// ─────────────────────────────────────────────
// SALES ORDER
// ─────────────────────────────────────────────

enum OrderStatus { pending, processing, shipped, delivered, cancelled }

class SalesOrder {
  final String id;
  final String clientName;
  final String productId;
  final int quantity;
  final double unitPrice;
  final OrderStatus status;
  final DateTime createdAt;

  const SalesOrder({
    required this.id,
    required this.clientName,
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    this.status = OrderStatus.pending,
    required this.createdAt,
  });

  double get totalValue => quantity * unitPrice;

  SalesOrder copyWith({
    String? id,
    String? clientName,
    String? productId,
    int? quantity,
    double? unitPrice,
    OrderStatus? status,
    DateTime? createdAt,
  }) =>
      SalesOrder(
        id: id ?? this.id,
        clientName: clientName ?? this.clientName,
        productId: productId ?? this.productId,
        quantity: quantity ?? this.quantity,
        unitPrice: unitPrice ?? this.unitPrice,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'clientName': clientName,
        'productId': productId,
        'quantity': quantity,
        'unitPrice': unitPrice,
        'status': status.name,
        'createdAt': createdAt.toIso8601String(),
      };

  factory SalesOrder.fromJson(Map<String, dynamic> j) => SalesOrder(
        id: j['id'] as String,
        clientName: j['clientName'] as String,
        productId: j['productId'] as String,
        quantity: j['quantity'] as int,
        unitPrice: (j['unitPrice'] as num).toDouble(),
        status: OrderStatus.values.firstWhere(
            (s) => s.name == j['status'],
            orElse: () => OrderStatus.pending),
        createdAt: DateTime.parse(j['createdAt'] as String),
      );
}

// ─────────────────────────────────────────────
// CLIENT
// ─────────────────────────────────────────────

class SalesClient {
  final String id;
  final String name;
  final String tier;          // 'bronze', 'silver', 'gold'
  final double satisfactionScore; // 0.0–1.0
  final double lifetimeValue;
  final int orderCount;

  const SalesClient({
    required this.id,
    required this.name,
    this.tier = 'bronze',
    this.satisfactionScore = 0.75,
    this.lifetimeValue = 0.0,
    this.orderCount = 0,
  });

  SalesClient copyWith({
    String? id,
    String? name,
    String? tier,
    double? satisfactionScore,
    double? lifetimeValue,
    int? orderCount,
  }) =>
      SalesClient(
        id: id ?? this.id,
        name: name ?? this.name,
        tier: tier ?? this.tier,
        satisfactionScore: satisfactionScore ?? this.satisfactionScore,
        lifetimeValue: lifetimeValue ?? this.lifetimeValue,
        orderCount: orderCount ?? this.orderCount,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'tier': tier,
        'satisfactionScore': satisfactionScore,
        'lifetimeValue': lifetimeValue,
        'orderCount': orderCount,
      };

  factory SalesClient.fromJson(Map<String, dynamic> j) => SalesClient(
        id: j['id'] as String,
        name: j['name'] as String,
        tier: j['tier'] as String,
        satisfactionScore: (j['satisfactionScore'] as num).toDouble(),
        lifetimeValue: (j['lifetimeValue'] as num).toDouble(),
        orderCount: j['orderCount'] as int,
      );
}

// ─────────────────────────────────────────────
// SALES STATE
// ─────────────────────────────────────────────

class Sales {
  final List<SalesOrder> orders;
  final List<SalesClient> clients;
  final double monthlyTarget;
  final double monthlyRevenue;
  final double conversionRate;   // 0.0–1.0
  final int totalOrdersThisMonth;
  final double totalRevenue;

  const Sales({
    this.orders = const [],
    this.clients = const [],
    this.monthlyTarget = 50000.0,
    this.monthlyRevenue = 0.0,
    this.conversionRate = 0.35,
    this.totalOrdersThisMonth = 0,
    this.totalRevenue = 0.0,
  });

  List<SalesOrder> get pendingOrders =>
      orders.where((o) => o.status == OrderStatus.pending).toList();
  List<SalesOrder> get processingOrders =>
      orders.where((o) => o.status == OrderStatus.processing).toList();
  double get targetProgress =>
      monthlyTarget > 0 ? (monthlyRevenue / monthlyTarget).clamp(0.0, 1.0) : 0.0;

  /// Generates a new inbound order each tick based on conversion rate
  /// Called by SalesModule, not directly.
  bool get shouldGenerateOrder => conversionRate > 0;

  Sales copyWith({
    List<SalesOrder>? orders,
    List<SalesClient>? clients,
    double? monthlyTarget,
    double? monthlyRevenue,
    double? conversionRate,
    int? totalOrdersThisMonth,
    double? totalRevenue,
  }) =>
      Sales(
        orders: orders ?? this.orders,
        clients: clients ?? this.clients,
        monthlyTarget: monthlyTarget ?? this.monthlyTarget,
        monthlyRevenue: monthlyRevenue ?? this.monthlyRevenue,
        conversionRate: conversionRate ?? this.conversionRate,
        totalOrdersThisMonth: totalOrdersThisMonth ?? this.totalOrdersThisMonth,
        totalRevenue: totalRevenue ?? this.totalRevenue,
      );

  Map<String, dynamic> toJson() => {
        'orders': orders.map((o) => o.toJson()).toList(),
        'clients': clients.map((c) => c.toJson()).toList(),
        'monthlyTarget': monthlyTarget,
        'monthlyRevenue': monthlyRevenue,
        'conversionRate': conversionRate,
        'totalOrdersThisMonth': totalOrdersThisMonth,
        'totalRevenue': totalRevenue,
      };

  factory Sales.fromJson(Map<String, dynamic> j) => Sales(
        orders: (j['orders'] as List? ?? [])
            .map((e) => SalesOrder.fromJson(e as Map<String, dynamic>))
            .toList(),
        clients: (j['clients'] as List? ?? [])
            .map((e) => SalesClient.fromJson(e as Map<String, dynamic>))
            .toList(),
        monthlyTarget: (j['monthlyTarget'] as num).toDouble(),
        monthlyRevenue: (j['monthlyRevenue'] as num).toDouble(),
        conversionRate: (j['conversionRate'] as num).toDouble(),
        totalOrdersThisMonth: j['totalOrdersThisMonth'] as int,
        totalRevenue: (j['totalRevenue'] as num).toDouble(),
      );
}