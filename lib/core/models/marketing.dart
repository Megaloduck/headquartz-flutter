// lib/core/models/marketing.dart
//
// Isolate-safe — plain Dart, no Flutter imports.

// ─────────────────────────────────────────────
// CAMPAIGN
// ─────────────────────────────────────────────

enum CampaignChannel { social, event, ads, email }
enum CampaignStatus { draft, active, completed, paused }

class Campaign {
  final String id;
  final String name;
  final CampaignChannel channel;
  final CampaignStatus status;
  final double budget;
  final double spent;
  final double demandBoost;    // added to market.demand while active
  final int durationTicks;     // how many ticks it runs
  final int elapsedTicks;
  final double roi;            // calculated after completion

  const Campaign({
    required this.id,
    required this.name,
    this.channel = CampaignChannel.social,
    this.status = CampaignStatus.draft,
    required this.budget,
    this.spent = 0.0,
    this.demandBoost = 5.0,
    this.durationTicks = 300,
    this.elapsedTicks = 0,
    this.roi = 0.0,
  });

  bool get isActive => status == CampaignStatus.active;
  double get progressPct =>
      durationTicks > 0 ? (elapsedTicks / durationTicks).clamp(0.0, 1.0) : 0.0;
  double get costPerTick => durationTicks > 0 ? budget / durationTicks : 0.0;

  Campaign copyWith({
    String? id,
    String? name,
    CampaignChannel? channel,
    CampaignStatus? status,
    double? budget,
    double? spent,
    double? demandBoost,
    int? durationTicks,
    int? elapsedTicks,
    double? roi,
  }) =>
      Campaign(
        id: id ?? this.id,
        name: name ?? this.name,
        channel: channel ?? this.channel,
        status: status ?? this.status,
        budget: budget ?? this.budget,
        spent: spent ?? this.spent,
        demandBoost: demandBoost ?? this.demandBoost,
        durationTicks: durationTicks ?? this.durationTicks,
        elapsedTicks: elapsedTicks ?? this.elapsedTicks,
        roi: roi ?? this.roi,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'channel': channel.name,
        'status': status.name,
        'budget': budget,
        'spent': spent,
        'demandBoost': demandBoost,
        'durationTicks': durationTicks,
        'elapsedTicks': elapsedTicks,
        'roi': roi,
      };

  factory Campaign.fromJson(Map<String, dynamic> j) => Campaign(
        id: j['id'] as String,
        name: j['name'] as String,
        channel: CampaignChannel.values.firstWhere(
            (c) => c.name == j['channel'],
            orElse: () => CampaignChannel.social),
        status: CampaignStatus.values.firstWhere(
            (s) => s.name == j['status'],
            orElse: () => CampaignStatus.draft),
        budget: (j['budget'] as num).toDouble(),
        spent: (j['spent'] as num).toDouble(),
        demandBoost: (j['demandBoost'] as num).toDouble(),
        durationTicks: j['durationTicks'] as int,
        elapsedTicks: j['elapsedTicks'] as int,
        roi: (j['roi'] as num).toDouble(),
      );
}

// ─────────────────────────────────────────────
// MARKETING STATE
// ─────────────────────────────────────────────

class Marketing {
  final List<Campaign> campaigns;
  final double brandScore;         // 0.0–1.0, affects conversion rate in Sales
  final double totalAdSpend;
  final double totalDemandGenerated;
  final double marketSharePct;     // 0.0–100.0

  const Marketing({
    this.campaigns = const [],
    this.brandScore = 0.5,
    this.totalAdSpend = 0.0,
    this.totalDemandGenerated = 0.0,
    this.marketSharePct = 10.0,
  });

  List<Campaign> get activeCampaigns =>
      campaigns.where((c) => c.isActive).toList();

  /// Sum of demand boosts from all active campaigns
  double get totalActiveDemandBoost =>
      activeCampaigns.fold(0.0, (s, c) => s + c.demandBoost);

  /// Brand score conversion bonus applied to Sales.conversionRate
  double get brandConversionBonus => brandScore * 0.2; // up to +20%

  Marketing copyWith({
    List<Campaign>? campaigns,
    double? brandScore,
    double? totalAdSpend,
    double? totalDemandGenerated,
    double? marketSharePct,
  }) =>
      Marketing(
        campaigns: campaigns ?? this.campaigns,
        brandScore: brandScore ?? this.brandScore,
        totalAdSpend: totalAdSpend ?? this.totalAdSpend,
        totalDemandGenerated: totalDemandGenerated ?? this.totalDemandGenerated,
        marketSharePct: marketSharePct ?? this.marketSharePct,
      );

  Map<String, dynamic> toJson() => {
        'campaigns': campaigns.map((c) => c.toJson()).toList(),
        'brandScore': brandScore,
        'totalAdSpend': totalAdSpend,
        'totalDemandGenerated': totalDemandGenerated,
        'marketSharePct': marketSharePct,
      };

  factory Marketing.fromJson(Map<String, dynamic> j) => Marketing(
        campaigns: (j['campaigns'] as List? ?? [])
            .map((e) => Campaign.fromJson(e as Map<String, dynamic>))
            .toList(),
        brandScore: (j['brandScore'] as num).toDouble(),
        totalAdSpend: (j['totalAdSpend'] as num).toDouble(),
        totalDemandGenerated: (j['totalDemandGenerated'] as num).toDouble(),
        marketSharePct: (j['marketSharePct'] as num).toDouble(),
      );
}