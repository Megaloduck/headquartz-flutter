// lib/screens/management/management_screen.dart
import 'package:flutter/material.dart';
import '../../app.dart';
import '../../widgets/role_shell.dart';
import '../../widgets/shared_widgets.dart';

const Color _mgmtColor = Color(0xFFA5D6A7);

// ═════════════════════════════════════════════
// MANAGEMENT SCREEN — entry point
// ═════════════════════════════════════════════

class ManagementScreen extends StatelessWidget {
  const ManagementScreen({super.key});

  static Widget _resolve(DepartmentModule m) => switch (m.name) {
        'HR Reports'         => const MgmtHrReportsPage(),
        'Finance Reports'    => const MgmtFinanceReportsPage(),
        'Sales Reports'      => const MgmtSalesReportsPage(),
        'Marketing Reports'  => const MgmtMarketingReportsPage(),
        'Production Reports' => const MgmtProductionReportsPage(),
        'Warehouse Reports'  => const MgmtWarehouseReportsPage(),
        'Logistics Reports'  => const MgmtLogisticsReportsPage(),
        _ => ModulePage(
            moduleName: m.name,
            departmentName: 'Management',
            subtitle: m.subtitle,
            color: _mgmtColor),
      };

  @override
  Widget build(BuildContext context) {
    final dept = departments.firstWhere((d) => d.name == 'Management');
    return RoleShell(department: dept, moduleResolver: _resolve);
  }
}

// ─────────────────────────────────────────────
// SHARED EXECUTIVE REPORT LAYOUT
// Used by all 7 Mgmt report pages
// ─────────────────────────────────────────────

class _ExecReportPage extends StatelessWidget {
  final String title;
  final List<StatCard> stats;
  final List<(String, String, IconData, Color)> rows;
  final String chartLabel;

  const _ExecReportPage({
    required this.title,
    required this.stats,
    required this.rows,
    required this.chartLabel,
  });

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: title,
      department: 'Management',
      color: _mgmtColor,
      children: [
        StatsGrid(cards: stats),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Key Highlights'),
        const SizedBox(height: 8),
        ...rows.map((r) => DataRowTile(
              title: r.$1,
              subtitle: r.$2,
              trailing: 'View',
              accentColor: r.$4,
              leadingIcon: r.$3,
            )),
        const SizedBox(height: 20),
        ChartPlaceholder(title: chartLabel, color: _mgmtColor, height: 200),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// HR REPORTS
// ─────────────────────────────────────────────

class MgmtHrReportsPage extends StatelessWidget {
  const MgmtHrReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _ExecReportPage(
      title: 'HR Reports',
      chartLabel: 'Headcount & Turnover Trend',
      stats: const [
        StatCard(label: 'Total Headcount', value: '248',   icon: Icons.people_rounded,        color: Color(0xFF4DD0C4)),
        StatCard(label: 'Turnover Rate',   value: '4.2%',  icon: Icons.logout_rounded,        color: Colors.orange),
        StatCard(label: 'Open Positions',  value: '12',    icon: Icons.work_outline_rounded,  color: Colors.blue),
        StatCard(label: 'Payroll Cost',    value: '\$412K',icon: Icons.payments_rounded,      color: _mgmtColor),
      ],
      rows: [
        ('Headcount by Department', 'Distribution across all 7 departments', Icons.bar_chart_rounded, const Color(0xFF4DD0C4)),
        ('Turnover Analysis',       'Exits, reasons & attrition rate',       Icons.analytics_rounded, Colors.orange),
        ('Recruitment Pipeline',    'Open roles vs applications',            Icons.work_rounded,      Colors.blue),
        ('Payroll Summary',         'Monthly cost breakdown',                Icons.payments_rounded,  Colors.purple),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// FINANCE REPORTS
// ─────────────────────────────────────────────

class MgmtFinanceReportsPage extends StatelessWidget {
  const MgmtFinanceReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _ExecReportPage(
      title: 'Finance Reports',
      chartLabel: 'Revenue, Expenses & Net Profit YTD',
      stats: const [
        StatCard(label: 'Revenue YTD',  value: '\$12.4M', icon: Icons.trending_up_rounded,    color: Colors.green, trend: '+8%'),
        StatCard(label: 'Expenses YTD', value: '\$9.1M',  icon: Icons.trending_down_rounded,  color: Colors.red),
        StatCard(label: 'Net Profit',   value: '\$3.3M',  icon: Icons.account_balance_rounded,color: _mgmtColor),
        StatCard(label: 'Cash Position',value: '\$2.1M',  icon: Icons.savings_rounded,        color: Colors.blue),
      ],
      rows: [
        ('P&L Statement',   'Monthly and YTD profit & loss',        Icons.show_chart_rounded,      const Color(0xFFFFD54F)),
        ('Balance Sheet',   'Assets, liabilities & equity',         Icons.account_balance_rounded, Colors.blue),
        ('Cash Flow',       'Operating & free cash flow',           Icons.waterfall_chart_rounded, Colors.green),
        ('Budget vs Actual','Variance analysis by department',      Icons.compare_arrows_rounded,  Colors.orange),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// SALES REPORTS
// ─────────────────────────────────────────────

class MgmtSalesReportsPage extends StatelessWidget {
  const MgmtSalesReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _ExecReportPage(
      title: 'Sales Reports',
      chartLabel: 'Monthly Revenue vs Target',
      stats: const [
        StatCard(label: 'Revenue MTD', value: '\$840K', icon: Icons.monetization_on_rounded,   color: Color(0xFFCE93D8), trend: '+14%'),
        StatCard(label: 'Deals Closed',value: '38',     icon: Icons.handshake_rounded,          color: Colors.green),
        StatCard(label: 'Win Rate',    value: '62%',    icon: Icons.emoji_events_rounded,       color: Colors.amber),
        StatCard(label: 'Pipeline',    value: '\$2.1M', icon: Icons.stacked_bar_chart_rounded,  color: Colors.blue),
      ],
      rows: [
        ('Revenue by Region',   'Sales breakdown by territory',     Icons.map_rounded,               const Color(0xFFCE93D8)),
        ('Top Performers',      'Sales rep league table',           Icons.people_rounded,             Colors.amber),
        ('Pipeline Analysis',   'Stage-by-stage deal report',       Icons.stacked_bar_chart_rounded,  Colors.blue),
        ('Customer Acquisition','New vs retained clients',          Icons.person_add_rounded,         Colors.green),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// MARKETING REPORTS
// ─────────────────────────────────────────────

class MgmtMarketingReportsPage extends StatelessWidget {
  const MgmtMarketingReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _ExecReportPage(
      title: 'Marketing Reports',
      chartLabel: 'Lead Generation & Campaign ROI',
      stats: const [
        StatCard(label: 'Leads MTD',   value: '1,482',   icon: Icons.person_add_rounded,    color: Color(0xFF80CBC4), trend: '+18%'),
        StatCard(label: 'Campaign ROI',value: '3.4x',    icon: Icons.trending_up_rounded,   color: Colors.green),
        StatCard(label: 'Ad Spend',    value: '\$42K',   icon: Icons.campaign_rounded,      color: Colors.orange),
        StatCard(label: 'Brand Score', value: '84/100',  icon: Icons.star_rounded,          color: Colors.amber),
      ],
      rows: [
        ('Campaign Performance', 'ROI by campaign & channel',  Icons.campaign_rounded,       const Color(0xFF80CBC4)),
        ('Lead Source Report',   'Leads by origin & quality',  Icons.contacts_rounded,       Colors.blue),
        ('Brand Awareness',      'Survey results & NPS',       Icons.star_rounded,           Colors.amber),
        ('Content & Social',     'Engagement metrics',         Icons.thumb_up_rounded,       Colors.green),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// PRODUCTION REPORTS
// ─────────────────────────────────────────────

class MgmtProductionReportsPage extends StatelessWidget {
  const MgmtProductionReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _ExecReportPage(
      title: 'Production Reports',
      chartLabel: 'Output & Efficiency Trend',
      stats: const [
        StatCard(label: 'Units MTD',  value: '84,200', icon: Icons.factory_rounded,         color: Color(0xFFFF8A65), trend: '+6%'),
        StatCard(label: 'OEE',        value: '91%',    icon: Icons.speed_rounded,            color: Colors.green),
        StatCard(label: 'Defect Rate',value: '1.2%',   icon: Icons.bug_report_rounded,       color: Colors.red),
        StatCard(label: 'Downtime',   value: '3.2hrs', icon: Icons.pause_circle_rounded,     color: Colors.orange),
      ],
      rows: [
        ('Output Summary',      'Units produced by line & shift',  Icons.bar_chart_rounded,  const Color(0xFFFF8A65)),
        ('Quality Report',      'Defect analysis & pass rate',     Icons.verified_rounded,   Colors.green),
        ('Maintenance Summary', 'Downtime events & causes',        Icons.build_rounded,      Colors.orange),
        ('Resource Utilization','Labor & machine efficiency',      Icons.people_rounded,     Colors.blue),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// WAREHOUSE REPORTS
// ─────────────────────────────────────────────

class MgmtWarehouseReportsPage extends StatelessWidget {
  const MgmtWarehouseReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _ExecReportPage(
      title: 'Warehouse Reports',
      chartLabel: 'Stock Movement & Capacity Trend',
      stats: const [
        StatCard(label: 'Total SKUs',   value: '4,820', icon: Icons.inventory_2_rounded, color: Color(0xFF90CAF9)),
        StatCard(label: 'Capacity Used',value: '74%',   icon: Icons.warehouse_rounded,   color: Colors.orange),
        StatCard(label: 'Pick Accuracy',value: '99.4%', icon: Icons.verified_rounded,    color: Colors.green),
        StatCard(label: 'Throughput',   value: '2,126/d',icon: Icons.swap_horiz_rounded, color: Colors.blue),
      ],
      rows: [
        ('Inventory Valuation', 'Stock value & category summary',  Icons.inventory_rounded,  const Color(0xFF90CAF9)),
        ('Stock Movement',      'In/out volume by period',         Icons.swap_horiz_rounded, Colors.blue),
        ('Capacity Report',     'Zone utilization & forecast',     Icons.storage_rounded,    Colors.orange),
        ('Aging Inventory',     'Items by days in stock',          Icons.schedule_rounded,   Colors.red),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// LOGISTICS REPORTS
// ─────────────────────────────────────────────

class MgmtLogisticsReportsPage extends StatelessWidget {
  const MgmtLogisticsReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _ExecReportPage(
      title: 'Logistics Reports',
      chartLabel: 'Delivery Performance & SLA Compliance',
      stats: const [
        StatCard(label: 'On-Time Rate',     value: '94%',   icon: Icons.timer_rounded,           color: Colors.green,          trend: '+2%'),
        StatCard(label: 'Active Shipments', value: '84',    icon: Icons.local_shipping_rounded,  color: Color(0xFFEF9A9A)),
        StatCard(label: 'SLA Compliance',  value: '96.2%', icon: Icons.verified_rounded,        color: Colors.blue),
        StatCard(label: 'Fleet Active',    value: '18/22', icon: Icons.directions_car_rounded,  color: Colors.orange),
      ],
      rows: [
        ('Delivery Performance', 'On-time rate & delay causes',      Icons.timer_rounded,          const Color(0xFFEF9A9A)),
        ('SLA Compliance',       'Client SLA adherence',             Icons.verified_rounded,       Colors.blue),
        ('Fleet Report',         'Utilization & cost per vehicle',   Icons.directions_car_rounded, Colors.orange),
        ('Cost per Delivery',    'Breakdown by region & route',      Icons.attach_money_rounded,   Colors.green),
      ],
    );
  }
}