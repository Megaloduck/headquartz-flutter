// lib/screens/finance/finance_screen.dart
import 'package:flutter/material.dart';
import '../../app.dart';
import '../../widgets/role_shell.dart';
import '../../widgets/shared_widgets.dart';

const Color _finColor = Color(0xFFFFD54F);

// ═════════════════════════════════════════════
// FINANCE SCREEN — entry point
// ═════════════════════════════════════════════

class FinanceScreen extends StatelessWidget {
  const FinanceScreen({super.key});

  static Widget _resolve(DepartmentModule m) => switch (m.name) {
        'Finance Dashboard'   => const FinanceDashboardPage(),
        'Accounts Payable'    => const AccountsPayablePage(),
        'Accounts Receivable' => const AccountsReceivablePage(),
        'Loans'               => const LoansPage(),
        'Budget Allocation'   => const BudgetAllocationPage(),
        'Audits'              => const AuditsPage(),
        'Finance Reports'     => const FinanceReportsPage(),
        _ => ModulePage(
            moduleName: m.name,
            departmentName: 'Finance',
            subtitle: m.subtitle,
            color: _finColor),
      };

  @override
  Widget build(BuildContext context) {
    final dept = departments.firstWhere((d) => d.name == 'Finance');
    return RoleShell(department: dept, moduleResolver: _resolve);
  }
}

// ─────────────────────────────────────────────
// FINANCE DASHBOARD
// ─────────────────────────────────────────────

class FinanceDashboardPage extends StatelessWidget {
  const FinanceDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'Finance Dashboard',
      department: 'Finance',
      color: _finColor,
      children: [
        StatsGrid(cards: const [
          StatCard(label: 'Total Revenue',  value: '\$2.4M', icon: Icons.trending_up_rounded,   color: Colors.green,  trend: '+8%'),
          StatCard(label: 'Total Expenses', value: '\$1.8M', icon: Icons.trending_down_rounded, color: Colors.red,    trend: '+3%', trendUp: false),
          StatCard(label: 'Net Profit',     value: '\$612K', icon: Icons.account_balance_rounded,color: _finColor,    trend: '+12%'),
          StatCard(label: 'Cash Flow',      value: '\$340K', icon: Icons.waterfall_chart_rounded,color: Colors.blue),
        ]),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Revenue vs Expenses'),
        const SizedBox(height: 8),
        const ChartPlaceholder(title: 'Monthly Revenue vs Expenses', color: _finColor, height: 200),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Recent Transactions', actionLabel: 'View All'),
        const SizedBox(height: 8),
        const DataRowTile(title: 'Client Payment Received', subtitle: 'Acme Corp • Invoice #1042', trailing: '+\$84,000',  accentColor: Colors.green,  leadingIcon: Icons.arrow_downward_rounded, statusColor: Colors.green),
        const DataRowTile(title: 'Supplier Payment',        subtitle: 'Raw Materials Ltd',         trailing: '-\$22,400',  accentColor: Colors.red,    leadingIcon: Icons.arrow_upward_rounded,   statusColor: Colors.red),
        const DataRowTile(title: 'Payroll Disbursement',    subtitle: 'May 2025 • 248 staff',      trailing: '-\$408,000', accentColor: Colors.orange, leadingIcon: Icons.payments_rounded,       statusColor: Colors.orange),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// ACCOUNTS PAYABLE
// ─────────────────────────────────────────────

class AccountsPayablePage extends StatelessWidget {
  const AccountsPayablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'Accounts Payable',
      department: 'Finance',
      color: _finColor,
      children: [
        StatsGrid(cards: const [
          StatCard(label: 'Total Payable',   value: '\$284K', icon: Icons.receipt_long_rounded, color: _finColor),
          StatCard(label: 'Overdue',         value: '\$42K',  icon: Icons.warning_rounded,      color: Colors.red,    trend: '3 invoices', trendUp: false),
          StatCard(label: 'Due This Week',   value: '\$91K',  icon: Icons.schedule_rounded,     color: Colors.orange),
          StatCard(label: 'Paid This Month', value: '\$176K', icon: Icons.check_circle_rounded, color: Colors.green),
        ]),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Pending Invoices', actionLabel: 'Add Invoice'),
        const SizedBox(height: 8),
        const DataRowTile(title: 'Raw Materials Ltd', subtitle: 'INV-2045 • Due Jun 10', trailing: '\$22,400', accentColor: _finColor, leadingIcon: Icons.inventory_rounded,    statusColor: Colors.orange),
        const DataRowTile(title: 'Tech Solutions Inc', subtitle: 'INV-2046 • Due Jun 14', trailing: '\$8,750',  accentColor: _finColor, leadingIcon: Icons.computer_rounded,     statusColor: Colors.orange),
        const DataRowTile(title: 'Office Supplies Co', subtitle: 'INV-2041 • OVERDUE',    trailing: '\$1,200',  accentColor: _finColor, leadingIcon: Icons.shopping_bag_rounded, statusColor: Colors.red),
        const SizedBox(height: 20),
        const ChartPlaceholder(title: 'Payable Aging Report', color: _finColor),
      ],
      fab: FloatingActionButton.extended(
        backgroundColor: _finColor,
        foregroundColor: Colors.black87,
        onPressed: () {},
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Invoice'),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// ACCOUNTS RECEIVABLE
// ─────────────────────────────────────────────

class AccountsReceivablePage extends StatelessWidget {
  const AccountsReceivablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'Accounts Receivable',
      department: 'Finance',
      color: _finColor,
      children: [
        StatsGrid(cards: const [
          StatCard(label: 'Total Receivable',    value: '\$531K', icon: Icons.request_quote_rounded, color: _finColor),
          StatCard(label: 'Overdue',             value: '\$68K',  icon: Icons.warning_rounded,       color: Colors.red,    trendUp: false),
          StatCard(label: 'Collected This Month',value: '\$312K', icon: Icons.savings_rounded,       color: Colors.green,  trend: '+9%'),
          StatCard(label: 'Avg Days to Pay',     value: '28d',    icon: Icons.timer_rounded,         color: Colors.blue),
        ]),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Outstanding Invoices', actionLabel: 'Send Reminder'),
        const SizedBox(height: 8),
        const DataRowTile(title: 'Acme Corp',    subtitle: 'INV-1042 • Due Jun 20', trailing: '\$84,000', accentColor: _finColor, leadingIcon: Icons.business_rounded, statusColor: Colors.green),
        const DataRowTile(title: 'Nexus Trade',  subtitle: 'INV-1038 • Due Jun 12', trailing: '\$41,500', accentColor: _finColor, leadingIcon: Icons.business_rounded, statusColor: Colors.orange),
        const DataRowTile(title: 'Bright Retail',subtitle: 'INV-1031 • OVERDUE',    trailing: '\$18,200', accentColor: _finColor, leadingIcon: Icons.business_rounded, statusColor: Colors.red),
        const SizedBox(height: 20),
        const ChartPlaceholder(title: 'Collection Trend', color: _finColor),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// LOANS
// ─────────────────────────────────────────────

class LoansPage extends StatelessWidget {
  const LoansPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'Loans',
      department: 'Finance',
      color: _finColor,
      children: [
        StatsGrid(cards: const [
          StatCard(label: 'Total Loans',      value: '\$1.2M', icon: Icons.account_balance_rounded,  color: _finColor),
          StatCard(label: 'Active Loans',     value: '6',      icon: Icons.pending_actions_rounded,   color: Colors.blue),
          StatCard(label: 'Monthly Payment',  value: '\$48K',  icon: Icons.payment_rounded,           color: Colors.orange),
          StatCard(label: 'Interest Rate Avg',value: '5.4%',   icon: Icons.percent_rounded,           color: Colors.red),
        ]),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Active Loan Facilities', actionLabel: 'Apply'),
        const SizedBox(height: 8),
        const DataRowTile(title: 'Capital Expansion Loan', subtitle: 'First National Bank • 3.9%', trailing: '\$600K', accentColor: _finColor, leadingIcon: Icons.domain_rounded,                        statusColor: Colors.green),
        const DataRowTile(title: 'Equipment Financing',    subtitle: 'Machinery Trust • 6.1%',     trailing: '\$320K', accentColor: _finColor, leadingIcon: Icons.precision_manufacturing_rounded,        statusColor: Colors.blue),
        const DataRowTile(title: 'Working Capital Line',   subtitle: 'City Credit Union • 5.8%',   trailing: '\$280K', accentColor: _finColor, leadingIcon: Icons.account_balance_wallet_rounded,        statusColor: Colors.orange),
        const SizedBox(height: 20),
        const ChartPlaceholder(title: 'Loan Repayment Schedule', color: _finColor),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// BUDGET ALLOCATION
// ─────────────────────────────────────────────

class BudgetAllocationPage extends StatelessWidget {
  const BudgetAllocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'Budget Allocation',
      department: 'Finance',
      color: _finColor,
      children: [
        StatsGrid(cards: const [
          StatCard(label: 'Annual Budget', value: '\$4.8M', icon: Icons.pie_chart_rounded,   color: _finColor),
          StatCard(label: 'Allocated',     value: '\$3.9M', icon: Icons.donut_large_rounded, color: Colors.blue),
          StatCard(label: 'Spent YTD',     value: '\$2.1M', icon: Icons.money_off_rounded,   color: Colors.orange),
          StatCard(label: 'Remaining',     value: '\$900K', icon: Icons.savings_rounded,     color: Colors.green),
        ]),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Budget by Department'),
        const SizedBox(height: 8),
        const ChartPlaceholder(title: 'Budget Allocation Pie Chart', color: _finColor, height: 200),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Department Budgets', actionLabel: 'Edit'),
        const SizedBox(height: 8),
        const DataRowTile(title: 'Human Resources', subtitle: 'Allocated: \$480K • Spent: \$220K', trailing: '46%', accentColor: Color(0xFF4DD0C4), leadingIcon: Icons.people_rounded,         statusColor: Colors.green),
        const DataRowTile(title: 'Sales',           subtitle: 'Allocated: \$720K • Spent: \$390K', trailing: '54%', accentColor: Color(0xFFCE93D8), leadingIcon: Icons.storefront_rounded,      statusColor: Colors.orange),
        const DataRowTile(title: 'Production',      subtitle: 'Allocated: \$1.2M • Spent: \$740K', trailing: '62%', accentColor: Color(0xFFFF8A65), leadingIcon: Icons.factory_rounded,         statusColor: Colors.orange),
        const DataRowTile(title: 'Logistics',       subtitle: 'Allocated: \$540K • Spent: \$210K', trailing: '39%', accentColor: Color(0xFFEF9A9A), leadingIcon: Icons.local_shipping_rounded,  statusColor: Colors.green),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// AUDITS
// ─────────────────────────────────────────────

class AuditsPage extends StatelessWidget {
  const AuditsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'Audits',
      department: 'Finance',
      color: _finColor,
      children: [
        StatsGrid(cards: const [
          StatCard(label: 'Scheduled',   value: '4',  icon: Icons.event_note_rounded, color: _finColor),
          StatCard(label: 'In Progress', value: '1',  icon: Icons.refresh_rounded,    color: Colors.blue),
          StatCard(label: 'Completed',   value: '11', icon: Icons.verified_rounded,   color: Colors.green),
          StatCard(label: 'Issues Found',value: '3',  icon: Icons.bug_report_rounded, color: Colors.red),
        ]),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Audit Schedule', actionLabel: 'Schedule'),
        const SizedBox(height: 8),
        const DataRowTile(title: 'Q2 Internal Audit',       subtitle: 'Finance Dept • Jun 20–24',    trailing: 'Scheduled', accentColor: _finColor, leadingIcon: Icons.search_rounded,          statusColor: Colors.blue),
        const DataRowTile(title: 'Annual External Audit',   subtitle: 'Grant & Partners • Aug 2025', trailing: 'Upcoming',  accentColor: _finColor, leadingIcon: Icons.business_center_rounded, statusColor: Colors.grey),
        const DataRowTile(title: 'Payroll Compliance Check',subtitle: 'HR & Finance • Complete',     trailing: 'Passed',    accentColor: _finColor, leadingIcon: Icons.fact_check_rounded,      statusColor: Colors.green),
        const SizedBox(height: 20),
        const ChartPlaceholder(title: 'Audit Findings Trend', color: _finColor),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// FINANCE REPORTS
// ─────────────────────────────────────────────

class FinanceReportsPage extends StatelessWidget {
  const FinanceReportsPage({super.key});

  static const List<(String, String, IconData)> _reports = [
    ('Profit & Loss Statement', 'Monthly and YTD P&L breakdown',      Icons.show_chart_rounded),
    ('Balance Sheet',           'Assets, liabilities & equity',        Icons.account_balance_rounded),
    ('Cash Flow Statement',     'Operating, investing, financing',      Icons.waterfall_chart_rounded),
    ('Budget vs Actual',        'Variance analysis by dept',           Icons.compare_arrows_rounded),
    ('Accounts Aging Report',   'Payable and receivable aging',        Icons.schedule_rounded),
    ('Tax Summary',             'GST, income tax, payroll tax',        Icons.receipt_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'Finance Reports',
      department: 'Finance',
      color: _finColor,
      children: [
        const SectionHeader(title: 'Available Reports'),
        const SizedBox(height: 12),
        ..._reports.map((r) => DataRowTile(
              title: r.$1, subtitle: r.$2, trailing: 'Export',
              accentColor: _finColor, leadingIcon: r.$3)),
        const SizedBox(height: 20),
        const ChartPlaceholder(title: 'YTD Financial Overview', color: _finColor, height: 200),
      ],
    );
  }
}