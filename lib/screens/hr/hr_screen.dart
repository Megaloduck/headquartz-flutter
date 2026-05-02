// lib/screens/hr/hr_screen.dart
import 'package:flutter/material.dart';
import '../../app.dart';
import '../../widgets/role_shell.dart';
import '../../widgets/shared_widgets.dart';

const Color _hrColor = Color(0xFF4DD0C4);

// ═════════════════════════════════════════════
// HR SCREEN — entry point
// ═════════════════════════════════════════════

class HrScreen extends StatelessWidget {
  const HrScreen({super.key});

  static Widget _resolve(DepartmentModule m) => switch (m.name) {
        'HR Dashboard'        => const HrDashboardPage(),
        'Employee Management' => const EmployeeManagementPage(),
        'Recruitment'         => const RecruitmentPage(),
        'Payroll'             => const PayrollPage(),
        'Development'         => const DevelopmentPage(),
        'Performance Evals'   => const PerformanceEvalsPage(),
        'HR Reports'          => const HrReportsPage(),
        _ => ModulePage(
            moduleName: m.name,
            departmentName: 'Human Resources',
            subtitle: m.subtitle,
            color: _hrColor),
      };

  @override
  Widget build(BuildContext context) {
    final dept =
        departments.firstWhere((d) => d.name == 'Human Resources');
    return RoleShell(department: dept, moduleResolver: _resolve);
  }
}

// ─────────────────────────────────────────────
// HR DASHBOARD
// ─────────────────────────────────────────────

class HrDashboardPage extends StatelessWidget {
  const HrDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'HR Dashboard',
      department: 'Human Resources',
      color: _hrColor,
      children: [
        StatsGrid(cards: const [
          StatCard(label: 'Total Employees',  value: '248', icon: Icons.people_rounded,             color: _hrColor,      trend: '+4%'),
          StatCard(label: 'Open Positions',   value: '12',  icon: Icons.work_outline_rounded,        color: Colors.orange, trend: '+2'),
          StatCard(label: 'On Leave Today',   value: '7',   icon: Icons.event_busy_rounded,          color: Colors.purple),
          StatCard(label: 'Avg Satisfaction', value: '87%', icon: Icons.sentiment_satisfied_rounded, color: Colors.green,  trend: '+3%'),
        ]),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Recent Activity', actionLabel: 'View All'),
        const SizedBox(height: 8),
        const DataRowTile(title: 'New hire onboarded',      subtitle: 'James Carter • Engineering', trailing: 'Today',    accentColor: _hrColor,       leadingIcon: Icons.person_add_rounded,  statusColor: Colors.green),
        const DataRowTile(title: 'Leave approved',          subtitle: 'Maria Santos • Marketing',   trailing: 'Yesterday',accentColor: Colors.orange,  leadingIcon: Icons.beach_access_rounded, statusColor: Colors.orange),
        const DataRowTile(title: 'Performance review due',  subtitle: 'Sales Team • 5 pending',     trailing: 'In 2 days',accentColor: Colors.red,     leadingIcon: Icons.assignment_rounded,  statusColor: Colors.red),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Headcount by Department'),
        const SizedBox(height: 8),
        const ChartPlaceholder(title: 'Department Headcount Chart', color: _hrColor),
      ],
      fab: FloatingActionButton.extended(
        backgroundColor: _hrColor,
        foregroundColor: Colors.black87,
        onPressed: () {},
        icon: const Icon(Icons.person_add_rounded),
        label: const Text('Add Employee'),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// EMPLOYEE MANAGEMENT
// ─────────────────────────────────────────────

class EmployeeManagementPage extends StatelessWidget {
  const EmployeeManagementPage({super.key});

  static const List<Map<String, String>> _employees = [
    {'name': 'James Carter', 'role': 'Software Engineer', 'dept': 'Engineering', 'status': 'Active'},
    {'name': 'Maria Santos', 'role': 'Marketing Lead',    'dept': 'Marketing',   'status': 'Active'},
    {'name': 'David Kim',    'role': 'Sales Executive',   'dept': 'Sales',       'status': 'On Leave'},
    {'name': 'Priya Nair',   'role': 'HR Coordinator',    'dept': 'HR',          'status': 'Active'},
    {'name': 'Tom Hughes',   'role': 'Warehouse Ops',     'dept': 'Warehouse',   'status': 'Active'},
    {'name': 'Aisha Musa',   'role': 'Finance Analyst',   'dept': 'Finance',     'status': 'Remote'},
  ];

  Color _statusColor(String s) => switch (s) {
        'Active'   => Colors.green,
        'On Leave' => Colors.orange,
        _          => Colors.blue,
      };

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'Employee Management',
      department: 'Human Resources',
      color: _hrColor,
      children: [
        const HqSearchField(hint: 'Search employees...'),
        const SizedBox(height: 16),
        const SectionHeader(title: 'All Employees (248)'),
        const SizedBox(height: 8),
        ..._employees.map((e) => DataRowTile(
              title: e['name']!,
              subtitle: '${e['role']} • ${e['dept']}',
              trailing: e['status']!,
              accentColor: _hrColor,
              leadingIcon: Icons.person_rounded,
              statusColor: _statusColor(e['status']!),
            )),
      ],
      fab: FloatingActionButton.extended(
        backgroundColor: _hrColor,
        foregroundColor: Colors.black87,
        onPressed: () {},
        icon: const Icon(Icons.person_add_rounded),
        label: const Text('New Employee'),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// RECRUITMENT
// ─────────────────────────────────────────────

class RecruitmentPage extends StatelessWidget {
  const RecruitmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'Recruitment',
      department: 'Human Resources',
      color: _hrColor,
      children: [
        StatsGrid(cards: const [
          StatCard(label: 'Open Roles',    value: '12', icon: Icons.work_rounded,                color: _hrColor),
          StatCard(label: 'Applications',  value: '84', icon: Icons.inbox_rounded,               color: Colors.blue),
          StatCard(label: 'Interviews',    value: '9',  icon: Icons.record_voice_over_rounded,   color: Colors.purple),
          StatCard(label: 'Offers Sent',   value: '3',  icon: Icons.send_rounded,                color: Colors.green),
        ]),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Open Positions', actionLabel: 'Post New'),
        const SizedBox(height: 8),
        const DataRowTile(title: 'Senior Flutter Developer', subtitle: 'Engineering • Full-time',  trailing: '18 Apps', accentColor: _hrColor, leadingIcon: Icons.code_rounded,           statusColor: Colors.green),
        const DataRowTile(title: 'Sales Executive',          subtitle: 'Sales • Full-time',        trailing: '23 Apps', accentColor: _hrColor, leadingIcon: Icons.handshake_rounded,       statusColor: Colors.green),
        const DataRowTile(title: 'Logistics Coordinator',    subtitle: 'Logistics • Contract',     trailing: '11 Apps', accentColor: _hrColor, leadingIcon: Icons.local_shipping_rounded,  statusColor: Colors.orange),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Hiring Pipeline'),
        const SizedBox(height: 8),
        const ChartPlaceholder(title: 'Funnel: Applied → Hired', color: _hrColor),
      ],
      fab: FloatingActionButton.extended(
        backgroundColor: _hrColor,
        foregroundColor: Colors.black87,
        onPressed: () {},
        icon: const Icon(Icons.add_rounded),
        label: const Text('Post Position'),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// PAYROLL
// ─────────────────────────────────────────────

class PayrollPage extends StatelessWidget {
  const PayrollPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'Payroll',
      department: 'Human Resources',
      color: _hrColor,
      children: [
        StatsGrid(cards: const [
          StatCard(label: 'Monthly Payroll', value: '\$412K', icon: Icons.payments_rounded,              color: _hrColor,      trend: '+2%'),
          StatCard(label: 'Employees Paid',  value: '241',    icon: Icons.check_circle_rounded,          color: Colors.green),
          StatCard(label: 'Pending',         value: '7',      icon: Icons.hourglass_empty_rounded,       color: Colors.orange),
          StatCard(label: 'Deductions',      value: '\$28K',  icon: Icons.remove_circle_outline_rounded, color: Colors.red),
        ]),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Upcoming Payroll Run'),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _hrColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _hrColor.withOpacity(0.3)),
          ),
          child: const Row(
            children: [
              Icon(Icons.calendar_today_rounded, color: _hrColor),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Next Run: June 30, 2025', style: TextStyle(fontWeight: FontWeight.w700)),
                  Text('248 employees • Est. \$412,000', style: TextStyle(fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Recent Payroll History'),
        const SizedBox(height: 8),
        const DataRowTile(title: 'May 2025',   subtitle: '248 employees processed', trailing: '\$408K', accentColor: _hrColor, leadingIcon: Icons.receipt_rounded, statusColor: Colors.green),
        const DataRowTile(title: 'April 2025', subtitle: '245 employees processed', trailing: '\$401K', accentColor: _hrColor, leadingIcon: Icons.receipt_rounded, statusColor: Colors.green),
        const DataRowTile(title: 'March 2025', subtitle: '240 employees processed', trailing: '\$395K', accentColor: _hrColor, leadingIcon: Icons.receipt_rounded, statusColor: Colors.green),
        const SizedBox(height: 20),
        const ChartPlaceholder(title: 'Monthly Payroll Trend', color: _hrColor),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// DEVELOPMENT (L&D)
// ─────────────────────────────────────────────

class DevelopmentPage extends StatelessWidget {
  const DevelopmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'Development',
      department: 'Human Resources',
      color: _hrColor,
      children: [
        StatsGrid(cards: const [
          StatCard(label: 'Active Programs', value: '8',   icon: Icons.school_rounded,   color: _hrColor),
          StatCard(label: 'Enrolled',        value: '134', icon: Icons.people_rounded,   color: Colors.blue),
          StatCard(label: 'Completed',       value: '67',  icon: Icons.verified_rounded, color: Colors.green),
          StatCard(label: 'Avg Score',       value: '91%', icon: Icons.star_rounded,     color: Colors.amber),
        ]),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Training Programs', actionLabel: 'Add Program'),
        const SizedBox(height: 8),
        const DataRowTile(title: 'Leadership Excellence', subtitle: 'Management • 6 weeks', trailing: '24 enrolled', accentColor: _hrColor, leadingIcon: Icons.emoji_events_rounded,     statusColor: Colors.green),
        const DataRowTile(title: 'Data Analytics Basics', subtitle: 'Cross-dept • 4 weeks', trailing: '41 enrolled', accentColor: _hrColor, leadingIcon: Icons.analytics_rounded,         statusColor: Colors.blue),
        const DataRowTile(title: 'Safety & Compliance',   subtitle: 'All staff • 1 day',    trailing: '98 enrolled', accentColor: _hrColor, leadingIcon: Icons.health_and_safety_rounded, statusColor: Colors.orange),
        const SizedBox(height: 20),
        const ChartPlaceholder(title: 'Training Completion Rate', color: _hrColor),
      ],
      fab: FloatingActionButton.extended(
        backgroundColor: _hrColor,
        foregroundColor: Colors.black87,
        onPressed: () {},
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Program'),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// PERFORMANCE EVALS
// ─────────────────────────────────────────────

class PerformanceEvalsPage extends StatelessWidget {
  const PerformanceEvalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'Performance Evals',
      department: 'Human Resources',
      color: _hrColor,
      children: [
        StatsGrid(cards: const [
          StatCard(label: 'Due This Month', value: '48',    icon: Icons.assignment_rounded,   color: _hrColor),
          StatCard(label: 'Completed',      value: '31',    icon: Icons.check_circle_rounded, color: Colors.green),
          StatCard(label: 'Overdue',        value: '5',     icon: Icons.warning_rounded,      color: Colors.red),
          StatCard(label: 'Avg Rating',     value: '4.1/5', icon: Icons.star_rounded,         color: Colors.amber),
        ]),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Pending Reviews', actionLabel: 'Start Review'),
        const SizedBox(height: 8),
        const DataRowTile(title: 'Q2 2025 — Engineering', subtitle: '12 employees • Due Jun 30', trailing: '4 done', accentColor: _hrColor, leadingIcon: Icons.engineering_rounded, statusColor: Colors.orange),
        const DataRowTile(title: 'Q2 2025 — Sales',       subtitle: '8 employees • Due Jun 30',  trailing: '6 done', accentColor: _hrColor, leadingIcon: Icons.storefront_rounded,  statusColor: Colors.green),
        const DataRowTile(title: 'Q2 2025 — Operations',  subtitle: '14 employees • Overdue',    trailing: '0 done', accentColor: _hrColor, leadingIcon: Icons.settings_rounded,    statusColor: Colors.red),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Rating Distribution'),
        const SizedBox(height: 8),
        const ChartPlaceholder(title: 'Performance Score Distribution', color: _hrColor),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// HR REPORTS
// ─────────────────────────────────────────────

class HrReportsPage extends StatelessWidget {
  const HrReportsPage({super.key});

  static const List<(String, String, IconData)> _reports = [
    ('Headcount Summary',    'Monthly employee count by dept',  Icons.people_rounded),
    ('Turnover Report',      'Attrition rates & exit analysis', Icons.logout_rounded),
    ('Payroll Summary',      'Salary distribution & costs',     Icons.payments_rounded),
    ('Leave Utilization',    'Leave taken vs entitlement',      Icons.beach_access_rounded),
    ('Training Completion',  'L&D program outcomes',            Icons.school_rounded),
    ('Performance Overview', 'Ratings across departments',      Icons.bar_chart_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'HR Reports',
      department: 'Human Resources',
      color: _hrColor,
      children: [
        const SectionHeader(title: 'Available Reports'),
        const SizedBox(height: 12),
        ..._reports.map((r) => DataRowTile(
              title: r.$1, subtitle: r.$2, trailing: 'Export',
              accentColor: _hrColor, leadingIcon: r.$3)),
        const SizedBox(height: 20),
        const ChartPlaceholder(title: 'Monthly HR KPIs Overview', color: _hrColor, height: 200),
      ],
    );
  }
} 