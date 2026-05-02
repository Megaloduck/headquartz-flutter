// lib/screens/marketing/marketing_screen.dart
import 'package:flutter/material.dart';
import '../../app.dart';
import '../../widgets/role_shell.dart';
import '../../widgets/shared_widgets.dart';

const Color _mktColor = Color(0xFF80CBC4);

// ═════════════════════════════════════════════
// MARKETING SCREEN — entry point
// ═════════════════════════════════════════════

class MarketingScreen extends StatelessWidget {
  const MarketingScreen({super.key});

  static Widget _resolve(DepartmentModule m) => switch (m.name) {
        'Marketing Dashboard' => const MarketingDashboardPage(),
        'Campaigns'           => const CampaignsPage(),
        'Market Research'     => const MarketResearchPage(),
        'Pricing Strategy'    => const PricingStrategyPage(),
        'Product Research'    => const ProductResearchPage(),
        'Branding'            => const BrandingPage(),
        'Marketing Reports'   => const MarketingReportsPage(),
        _ => ModulePage(
            moduleName: m.name,
            departmentName: 'Marketing',
            subtitle: m.subtitle,
            color: _mktColor),
      };

  @override
  Widget build(BuildContext context) {
    final dept = departments.firstWhere((d) => d.name == 'Marketing');
    return RoleShell(department: dept, moduleResolver: _resolve);
  }
}

// ─────────────────────────────────────────────
// MARKETING DASHBOARD
// ─────────────────────────────────────────────

class MarketingDashboardPage extends StatelessWidget {
  const MarketingDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'Marketing Dashboard',
      department: 'Marketing',
      color: _mktColor,
      children: [
        StatsGrid(cards: const [
          StatCard(label: 'Leads Generated', value: '1,482', icon: Icons.person_add_rounded,   color: _mktColor,     trend: '+18%'),
          StatCard(label: 'Campaign ROI',    value: '3.4x',  icon: Icons.trending_up_rounded,  color: Colors.green,  trend: '+0.4x'),
          StatCard(label: 'Email Open Rate', value: '34%',   icon: Icons.mail_rounded,         color: Colors.blue),
          StatCard(label: 'Ad Spend',        value: '\$42K', icon: Icons.campaign_rounded,     color: Colors.orange),
        ]),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Campaign Performance'),
        const SizedBox(height: 8),
        const ChartPlaceholder(title: 'Leads by Channel', color: _mktColor, height: 180),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Active Campaigns', actionLabel: 'View All'),
        const SizedBox(height: 8),
        const DataRowTile(title: 'Summer Launch 2025', subtitle: 'Email + Social • Running', trailing: '4,200 reach', accentColor: _mktColor, leadingIcon: Icons.rocket_launch_rounded, statusColor: Colors.green),
        const DataRowTile(title: 'B2B Outreach Q2',   subtitle: 'LinkedIn • Running',       trailing: '1,800 reach', accentColor: _mktColor, leadingIcon: Icons.business_rounded,      statusColor: Colors.blue),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// CAMPAIGNS
// ─────────────────────────────────────────────

class CampaignsPage extends StatelessWidget {
  const CampaignsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'Campaigns',
      department: 'Marketing',
      color: _mktColor,
      children: [
        StatsGrid(cards: const [
          StatCard(label: 'Active',       value: '6',    icon: Icons.play_circle_rounded,            color: Colors.green),
          StatCard(label: 'Scheduled',    value: '4',    icon: Icons.schedule_rounded,               color: Colors.blue),
          StatCard(label: 'Completed',    value: '22',   icon: Icons.check_circle_rounded,           color: _mktColor),
          StatCard(label: 'Total Budget', value: '\$128K',icon: Icons.account_balance_wallet_rounded, color: Colors.orange),
        ]),
        const SizedBox(height: 20),
        const SectionHeader(title: 'All Campaigns', actionLabel: 'New Campaign'),
        const SizedBox(height: 8),
        const DataRowTile(title: 'Summer Launch 2025',   subtitle: 'Email + Social • Jun 1–30',  trailing: '\$18K budget', accentColor: _mktColor, leadingIcon: Icons.wb_sunny_rounded,      statusColor: Colors.green),
        const DataRowTile(title: 'B2B Outreach Q2',      subtitle: 'LinkedIn • May–Jun',         trailing: '\$9K budget',  accentColor: _mktColor, leadingIcon: Icons.business_rounded,      statusColor: Colors.green),
        const DataRowTile(title: 'Product Launch — v3',  subtitle: 'Multi-channel • Jul 15',     trailing: '\$32K budget', accentColor: _mktColor, leadingIcon: Icons.new_releases_rounded,  statusColor: Colors.blue),
        const DataRowTile(title: 'Holiday Campaign',     subtitle: 'Dec 2025 • Planned',         trailing: '\$24K budget', accentColor: _mktColor, leadingIcon: Icons.celebration_rounded,   statusColor: Colors.grey),
        const SizedBox(height: 20),
        const ChartPlaceholder(title: 'Campaign ROI Comparison', color: _mktColor),
      ],
      fab: FloatingActionButton.extended(
        backgroundColor: _mktColor,
        foregroundColor: Colors.black87,
        onPressed: () {},
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Campaign'),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// MARKET RESEARCH
// ─────────────────────────────────────────────

class MarketResearchPage extends StatelessWidget {
  const MarketResearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'Market Research',
      department: 'Marketing',
      color: _mktColor,
      children: [
        StatsGrid(cards: const [
          StatCard(label: 'Reports',        value: '18',    icon: Icons.library_books_rounded, color: _mktColor),
          StatCard(label: 'Surveys Active', value: '3',     icon: Icons.poll_rounded,          color: Colors.blue),
          StatCard(label: 'Respondents',    value: '2,840', icon: Icons.group_rounded,         color: Colors.green),
          StatCard(label: 'Insights',       value: '47',    icon: Icons.lightbulb_rounded,     color: Colors.amber),
        ]),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Recent Research', actionLabel: 'New Study'),
        const SizedBox(height: 8),
        const DataRowTile(title: 'Customer Satisfaction Q1',  subtitle: '1,200 respondents • Completed',  trailing: 'NPS: 72',  accentColor: _mktColor, leadingIcon: Icons.sentiment_satisfied_rounded, statusColor: Colors.green),
        const DataRowTile(title: 'Market Sizing — SMB Segment',subtitle: 'Desk research • In progress',   trailing: '60% done', accentColor: _mktColor, leadingIcon: Icons.pie_chart_rounded,          statusColor: Colors.orange),
        const DataRowTile(title: 'Competitor Benchmarking',   subtitle: '5 competitors • Completed',      trailing: 'View',     accentColor: _mktColor, leadingIcon: Icons.compare_rounded,            statusColor: Colors.green),
        const SizedBox(height: 20),
        const ChartPlaceholder(title: 'Market Share Trend', color: _mktColor),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// PRICING STRATEGY
// ─────────────────────────────────────────────

class PricingStrategyPage extends StatelessWidget {
  const PricingStrategyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'Pricing Strategy',
      department: 'Marketing',
      color: _mktColor,
      children: [
        StatsGrid(cards: const [
          StatCard(label: 'Products Priced',  value: '84',  icon: Icons.sell_rounded,         color: _mktColor),
          StatCard(label: 'Avg Margin',       value: '42%', icon: Icons.percent_rounded,       color: Colors.green, trend: '+2%'),
          StatCard(label: 'Price Changes',    value: '6',   icon: Icons.edit_rounded,          color: Colors.orange),
          StatCard(label: 'Discounts Active', value: '4',   icon: Icons.local_offer_rounded,   color: Colors.blue),
        ]),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Price Lists', actionLabel: 'Edit'),
        const SizedBox(height: 8),
        const DataRowTile(title: 'Standard Tier',   subtitle: '52 SKUs • SMB segment',       trailing: 'Active', accentColor: _mktColor, leadingIcon: Icons.list_alt_rounded,   statusColor: Colors.green),
        const DataRowTile(title: 'Enterprise Tier', subtitle: '84 SKUs • Large accounts',    trailing: 'Active', accentColor: _mktColor, leadingIcon: Icons.business_rounded,   statusColor: Colors.green),
        const DataRowTile(title: 'Partner Pricing', subtitle: '40 SKUs • Channel partners',  trailing: 'Active', accentColor: _mktColor, leadingIcon: Icons.handshake_rounded,  statusColor: Colors.blue),
        const SizedBox(height: 20),
        const ChartPlaceholder(title: 'Price vs Margin Analysis', color: _mktColor),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// PRODUCT RESEARCH
// ─────────────────────────────────────────────

class ProductResearchPage extends StatelessWidget {
  const ProductResearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'Product Research',
      department: 'Marketing',
      color: _mktColor,
      children: [
        StatsGrid(cards: const [
          StatCard(label: 'Active Studies',  value: '5',  icon: Icons.science_rounded,         color: _mktColor),
          StatCard(label: 'Ideas Pipeline',  value: '28', icon: Icons.lightbulb_rounded,        color: Colors.amber),
          StatCard(label: 'In Development',  value: '4',  icon: Icons.build_rounded,            color: Colors.blue),
          StatCard(label: 'Launched',        value: '12', icon: Icons.rocket_launch_rounded,    color: Colors.green),
        ]),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Research Projects', actionLabel: 'New Study'),
        const SizedBox(height: 8),
        const DataRowTile(title: 'ERP Mobile Companion',     subtitle: 'Feasibility study • In progress', trailing: '40% done', accentColor: _mktColor, leadingIcon: Icons.phone_android_rounded, statusColor: Colors.orange),
        const DataRowTile(title: 'AI-Assisted Forecasting',  subtitle: 'Discovery phase',                 trailing: 'New',      accentColor: _mktColor, leadingIcon: Icons.auto_graph_rounded,    statusColor: Colors.blue),
        const DataRowTile(title: 'Customer Portal v2',       subtitle: 'Completed • Greenlit',            trailing: 'Approved', accentColor: _mktColor, leadingIcon: Icons.web_rounded,           statusColor: Colors.green),
        const SizedBox(height: 20),
        const ChartPlaceholder(title: 'Product Roadmap Timeline', color: _mktColor),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// BRANDING
// ─────────────────────────────────────────────

class BrandingPage extends StatelessWidget {
  const BrandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'Branding',
      department: 'Marketing',
      color: _mktColor,
      children: [
        StatsGrid(cards: const [
          StatCard(label: 'Brand Score', value: '84/100',  icon: Icons.star_rounded,         color: _mktColor),
          StatCard(label: 'Assets',      value: '312',     icon: Icons.collections_rounded,  color: Colors.blue),
          StatCard(label: 'Campaigns',   value: '8',       icon: Icons.campaign_rounded,     color: Colors.green),
          StatCard(label: 'Guidelines',  value: '3 docs',  icon: Icons.menu_book_rounded,    color: Colors.orange),
        ]),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Brand Assets', actionLabel: 'Upload'),
        const SizedBox(height: 8),
        const DataRowTile(title: 'Logo Pack',              subtitle: 'SVG, PNG • All variants',  trailing: 'Download', accentColor: _mktColor, leadingIcon: Icons.image_rounded,         statusColor: Colors.green),
        const DataRowTile(title: 'Brand Guidelines v2',    subtitle: 'PDF • 48 pages',           trailing: 'Download', accentColor: _mktColor, leadingIcon: Icons.menu_book_rounded,     statusColor: Colors.green),
        const DataRowTile(title: 'Social Media Templates', subtitle: 'Canva • 32 templates',     trailing: 'Open',     accentColor: _mktColor, leadingIcon: Icons.photo_library_rounded, statusColor: Colors.blue),
        const SizedBox(height: 20),
        const ChartPlaceholder(title: 'Brand Awareness Survey', color: _mktColor),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// MARKETING REPORTS
// ─────────────────────────────────────────────

class MarketingReportsPage extends StatelessWidget {
  const MarketingReportsPage({super.key});

  static const List<(String, String, IconData)> _reports = [
    ('Campaign Performance',  'ROI, reach & conversions per campaign',  Icons.campaign_rounded),
    ('Lead Generation Report','Leads by source, quality & conversion',  Icons.person_add_rounded),
    ('Email Marketing Stats', 'Open, click, bounce rates',              Icons.email_rounded),
    ('Social Media Analytics','Engagement & follower growth',           Icons.thumb_up_rounded),
    ('Brand Awareness',       'Survey results & NPS trend',             Icons.star_rounded),
    ('Budget Utilization',    'Spend vs planned by channel',            Icons.account_balance_wallet_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'Marketing Reports',
      department: 'Marketing',
      color: _mktColor,
      children: [
        const SectionHeader(title: 'Available Reports'),
        const SizedBox(height: 12),
        ..._reports.map((r) => DataRowTile(
              title: r.$1, subtitle: r.$2, trailing: 'Export',
              accentColor: _mktColor, leadingIcon: r.$3)),
        const SizedBox(height: 20),
        const ChartPlaceholder(title: 'Marketing KPI Overview', color: _mktColor, height: 200),
      ],
    );
  }
}