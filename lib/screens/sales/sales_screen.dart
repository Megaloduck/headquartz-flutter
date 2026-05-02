// lib/screens/sales/sales_screen.dart
import 'package:flutter/material.dart';
import '../../widgets/shared_widgets.dart';

const Color _salesColor = Color(0xFFCE93D8);

// ─────────────────────────────────────────────
// SALES DASHBOARD
// ─────────────────────────────────────────────

class SalesDashboardPage extends StatelessWidget {
  const SalesDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'Sales Dashboard',
      department: 'Sales',
      color: _salesColor,
      children: [
        StatsGrid(cards: const [
          StatCard(label: 'Monthly Revenue', value: '\$840K', icon: Icons.monetization_on_rounded, color: Colors.green, trend: '+14%'),
          StatCard(label: 'Deals Closed', value: '38', icon: Icons.handshake_rounded, color: _salesColor, trend: '+6'),
          StatCard(label: 'Pipeline Value', value: '\$2.1M', icon: Icons.account_tree_rounded, color: Colors.blue),
          StatCard(label: 'Win Rate', value: '62%', icon: Icons.emoji_events_rounded, color: Colors.amber, trend: '+4%'),
        ]),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Revenue Trend'),
        const SizedBox(height: 8),
        const ChartPlaceholder(title: 'Monthly Sales Revenue', color: _salesColor, height: 180),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Top Deals', actionLabel: 'View All'),
        const SizedBox(height: 8),
        const DataRowTile(title: 'Acme Corp — Enterprise', subtitle: 'Negotiation • Close: Jun 30', trailing: '\$240K', accentColor: _salesColor, leadingIcon: Icons.business_rounded, statusColor: Colors.orange),
        const DataRowTile(title: 'Nexus Trade — SaaS', subtitle: 'Proposal Sent • Close: Jul 5', trailing: '\$88K', accentColor: _salesColor, leadingIcon: Icons.business_rounded, statusColor: Colors.blue),
        const DataRowTile(title: 'BrightRetail — Logistics', subtitle: 'Contract Review', trailing: '\$64K', accentColor: _salesColor, leadingIcon: Icons.business_rounded, statusColor: Colors.green),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// CLIENT MANAGEMENT
// ─────────────────────────────────────────────

class ClientManagementPage extends StatelessWidget {
  const ClientManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'Client Management',
      department: 'Sales',
      color: _salesColor,
      children: [
        StatsGrid(cards: const [
          StatCard(label: 'Total Clients', value: '142', icon: Icons.people_alt_rounded, color: _salesColor),
          StatCard(label: 'Active', value: '118', icon: Icons.check_circle_rounded, color: Colors.green),
          StatCard(label: 'At Risk', value: '9', icon: Icons.warning_amber_rounded, color: Colors.orange),
          StatCard(label: 'New This Month', value: '7', icon: Icons.person_add_rounded, color: Colors.blue),
        ]),
        const SizedBox(height: 20),
        // ✅ HqSearchField replaces hardcoded TextField(fillColor: Colors.white)
        const HqSearchField(hint: 'Search clients...'),
        const SizedBox(height: 16),
        const SectionHeader(title: 'Client List'),
        const SizedBox(height: 8),
        const DataRowTile(title: 'Acme Corp', subtitle: 'Enterprise • Since 2021', trailing: '\$1.2M LTV', accentColor: _salesColor, leadingIcon: Icons.business_rounded, statusColor: Colors.green),
        const DataRowTile(title: 'Nexus Trade', subtitle: 'Mid-market • Since 2023', trailing: '\$320K LTV', accentColor: _salesColor, leadingIcon: Icons.business_rounded, statusColor: Colors.green),
        const DataRowTile(title: 'Bright Retail', subtitle: 'SMB • Since 2024', trailing: '\$84K LTV', accentColor: _salesColor, leadingIcon: Icons.business_rounded, statusColor: Colors.orange),
        const DataRowTile(title: 'Summit Group', subtitle: 'Enterprise • Since 2020', trailing: '\$2.4M LTV', accentColor: _salesColor, leadingIcon: Icons.business_rounded, statusColor: Colors.green),
      ],
      fab: FloatingActionButton.extended(
        backgroundColor: _salesColor,
        foregroundColor: Colors.black87,
        onPressed: () {},
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Client'),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// LEADS
// ─────────────────────────────────────────────

class LeadsPage extends StatelessWidget {
  const LeadsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'Leads',
      department: 'Sales',
      color: _salesColor,
      children: [
        StatsGrid(cards: const [
          StatCard(label: 'Total Leads', value: '214', icon: Icons.contacts_rounded, color: _salesColor),
          StatCard(label: 'Hot Leads', value: '28', icon: Icons.local_fire_department_rounded, color: Colors.red),
          StatCard(label: 'Qualified', value: '76', icon: Icons.verified_user_rounded, color: Colors.green),
          StatCard(label: 'New This Week', value: '14', icon: Icons.fiber_new_rounded, color: Colors.blue),
        ]),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Hot Leads', actionLabel: 'Add Lead'),
        const SizedBox(height: 8),
        const DataRowTile(title: 'GlobalTech Ltd', subtitle: 'Inbound • CFO contact', trailing: 'Hot', accentColor: Colors.red, leadingIcon: Icons.bolt_rounded, statusColor: Colors.red),
        const DataRowTile(title: 'Metro Logistics', subtitle: 'Referral • Ops Director', trailing: 'Warm', accentColor: Colors.orange, leadingIcon: Icons.local_fire_department_rounded, statusColor: Colors.orange),
        const DataRowTile(title: 'Vertex Manufacturing', subtitle: 'Trade show • CEO', trailing: 'Warm', accentColor: Colors.orange, leadingIcon: Icons.local_fire_department_rounded, statusColor: Colors.orange),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Lead Sources'),
        const SizedBox(height: 8),
        const ChartPlaceholder(title: 'Lead Source Breakdown', color: _salesColor),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// ORDERS
// ─────────────────────────────────────────────

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'Orders',
      department: 'Sales',
      color: _salesColor,
      children: [
        StatsGrid(cards: const [
          StatCard(label: 'Total Orders', value: '1,284', icon: Icons.shopping_cart_rounded, color: _salesColor),
          StatCard(label: 'Pending', value: '42', icon: Icons.hourglass_top_rounded, color: Colors.orange),
          StatCard(label: 'Fulfilled', value: '1,218', icon: Icons.check_circle_rounded, color: Colors.green),
          StatCard(label: 'Cancelled', value: '24', icon: Icons.cancel_rounded, color: Colors.red),
        ]),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Recent Orders', actionLabel: 'New Order'),
        const SizedBox(height: 8),
        const DataRowTile(title: 'ORD-4821', subtitle: 'Acme Corp • Jun 1, 2025', trailing: '\$42,000', accentColor: _salesColor, leadingIcon: Icons.receipt_rounded, statusColor: Colors.green),
        const DataRowTile(title: 'ORD-4820', subtitle: 'Nexus Trade • Jun 1, 2025', trailing: '\$18,500', accentColor: _salesColor, leadingIcon: Icons.receipt_rounded, statusColor: Colors.orange),
        const DataRowTile(title: 'ORD-4819', subtitle: 'Summit Group • May 31, 2025', trailing: '\$96,400', accentColor: _salesColor, leadingIcon: Icons.receipt_rounded, statusColor: Colors.green),
        const SizedBox(height: 20),
        const ChartPlaceholder(title: 'Order Volume by Month', color: _salesColor),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// PIPELINE MANAGEMENT
// ─────────────────────────────────────────────

class PipelineManagementPage extends StatelessWidget {
  const PipelineManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'Pipeline Management',
      department: 'Sales',
      color: _salesColor,
      children: [
        StatsGrid(cards: const [
          StatCard(label: 'Pipeline Value', value: '\$2.1M', icon: Icons.stacked_bar_chart_rounded, color: _salesColor),
          StatCard(label: 'Deals in Pipeline', value: '54', icon: Icons.view_kanban_rounded, color: Colors.blue),
          StatCard(label: 'Avg Deal Size', value: '\$38.9K', icon: Icons.attach_money_rounded, color: Colors.green),
          StatCard(label: 'Avg Sales Cycle', value: '34d', icon: Icons.timer_rounded, color: Colors.orange),
        ]),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Pipeline Stages'),
        const SizedBox(height: 8),
        const ChartPlaceholder(title: 'Pipeline Funnel View', color: _salesColor, height: 200),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Deals by Stage'),
        const SizedBox(height: 8),
        const DataRowTile(title: 'Prospecting', subtitle: '18 deals', trailing: '\$480K', accentColor: Colors.grey, leadingIcon: Icons.search_rounded),
        const DataRowTile(title: 'Qualification', subtitle: '12 deals', trailing: '\$420K', accentColor: Colors.blue, leadingIcon: Icons.filter_list_rounded),
        const DataRowTile(title: 'Proposal', subtitle: '11 deals', trailing: '\$610K', accentColor: Colors.orange, leadingIcon: Icons.description_rounded),
        const DataRowTile(title: 'Negotiation', subtitle: '8 deals', trailing: '\$380K', accentColor: Colors.deepOrange, leadingIcon: Icons.handshake_rounded),
        const DataRowTile(title: 'Closed Won', subtitle: '5 deals', trailing: '\$210K', accentColor: Colors.green, leadingIcon: Icons.emoji_events_rounded),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// PERFORMANCE INCENTIVES
// ─────────────────────────────────────────────

class PerformanceIncentivesPage extends StatelessWidget {
  const PerformanceIncentivesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'Performance Incentives',
      department: 'Sales',
      color: _salesColor,
      children: [
        StatsGrid(cards: const [
          StatCard(label: 'Total Commission', value: '\$84K', icon: Icons.card_giftcard_rounded, color: _salesColor),
          StatCard(label: 'Paid Out', value: '\$62K', icon: Icons.check_circle_rounded, color: Colors.green),
          StatCard(label: 'Pending', value: '\$22K', icon: Icons.hourglass_empty_rounded, color: Colors.orange),
          StatCard(label: 'Top Earner', value: '\$12K', icon: Icons.military_tech_rounded, color: Colors.amber),
        ]),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Sales Rep Leaderboard'),
        const SizedBox(height: 8),
        const DataRowTile(title: 'David Kim', subtitle: '18 deals • 128% of target', trailing: '\$12,400', accentColor: Colors.amber, leadingIcon: Icons.emoji_events_rounded, statusColor: Colors.amber),
        const DataRowTile(title: 'Lisa Chen', subtitle: '14 deals • 112% of target', trailing: '\$9,800', accentColor: _salesColor, leadingIcon: Icons.person_rounded, statusColor: Colors.green),
        const DataRowTile(title: 'Mark Osei', subtitle: '11 deals • 96% of target', trailing: '\$7,200', accentColor: _salesColor, leadingIcon: Icons.person_rounded, statusColor: Colors.blue),
        const SizedBox(height: 20),
        const ChartPlaceholder(title: 'Commission vs Quota Attainment', color: _salesColor),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// SALES REPORTS
// ─────────────────────────────────────────────

class SalesReportsPage extends StatelessWidget {
  const SalesReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'Sales Reports',
      department: 'Sales',
      color: _salesColor,
      children: [
        const SectionHeader(title: 'Available Reports'),
        const SizedBox(height: 12),
        ...[
          ('Revenue Summary', 'Monthly & YTD revenue breakdown', Icons.bar_chart_rounded),
          ('Sales by Rep', 'Individual performance stats', Icons.people_rounded),
          ('Pipeline Report', 'Stage-by-stage deal analysis', Icons.stacked_bar_chart_rounded),
          ('Win/Loss Analysis', 'Closed deals & reasons', Icons.analytics_rounded),
          ('Client Revenue Report', 'Revenue by client account', Icons.business_rounded),
          ('Forecast Report', 'Projected revenue next quarter', Icons.show_chart_rounded),
        ].map((r) => DataRowTile(
              title: r.$1,
              subtitle: r.$2,
              trailing: 'Export',
              accentColor: _salesColor,
              leadingIcon: r.$3,
            )),
        const SizedBox(height: 20),
        const ChartPlaceholder(title: 'Sales KPI Overview', color: _salesColor, height: 200),
      ],
    );
  }
}