// lib/screens/production/production_screen.dart
import 'package:flutter/material.dart';
import '../../app.dart';
import '../../widgets/role_shell.dart';
import '../../widgets/shared_widgets.dart';

const Color _prodColor = Color(0xFFFF8A65);

// ═════════════════════════════════════════════
// PRODUCTION SCREEN — entry point
// ═════════════════════════════════════════════

class ProductionScreen extends StatelessWidget {
  const ProductionScreen({super.key});

  static Widget _resolve(DepartmentModule m) => switch (m.name) {
        'Production Dashboard' => const ProductionDashboardPage(),
        'Work Order'           => const WorkOrderPage(),
        'Line Management'      => const LineManagementPage(),
        'Resource Planner'     => const ResourcePlannerPage(),
        'Maintenance'          => const MaintenancePage(),
        'Quality Control'      => const QualityControlPage(),
        'Production Reports'   => const ProductionReportsPage(),
        _ => ModulePage(
            moduleName: m.name,
            departmentName: 'Production',
            subtitle: m.subtitle,
            color: _prodColor),
      };

  @override
  Widget build(BuildContext context) {
    final dept = departments.firstWhere((d) => d.name == 'Production');
    return RoleShell(department: dept, moduleResolver: _resolve);
  }
}

// ─────────────────────────────────────────────
// PRODUCTION DASHBOARD
// ─────────────────────────────────────────────

class ProductionDashboardPage extends StatelessWidget {
  const ProductionDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'Production Dashboard',
      department: 'Production',
      color: _prodColor,
      children: [
        StatsGrid(cards: const [
          StatCard(label: 'Units Produced',   value: '8,420', icon: Icons.factory_rounded,    color: _prodColor,    trend: '+6%'),
          StatCard(label: 'Line Efficiency',  value: '91%',   icon: Icons.speed_rounded,       color: Colors.green,  trend: '+2%'),
          StatCard(label: 'Defect Rate',      value: '1.2%',  icon: Icons.bug_report_rounded,  color: Colors.red,    trendUp: false),
          StatCard(label: 'Open Work Orders', value: '14',    icon: Icons.assignment_rounded,  color: Colors.orange),
        ]),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Production Output Trend'),
        const SizedBox(height: 8),
        const ChartPlaceholder(title: 'Daily Output by Line', color: _prodColor, height: 180),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Active Work Orders', actionLabel: 'View All'),
        const SizedBox(height: 8),
        const DataRowTile(title: 'WO-2081 — Batch A', subtitle: 'Line 1 • Due Jun 5', trailing: '72% done', accentColor: _prodColor, leadingIcon: Icons.settings_rounded, statusColor: Colors.orange),
        const DataRowTile(title: 'WO-2082 — Batch B', subtitle: 'Line 2 • Due Jun 6', trailing: '45% done', accentColor: _prodColor, leadingIcon: Icons.settings_rounded, statusColor: Colors.blue),
        const DataRowTile(title: 'WO-2079 — Rework',  subtitle: 'Line 3 • Urgent',    trailing: 'Delayed',   accentColor: _prodColor, leadingIcon: Icons.warning_rounded,  statusColor: Colors.red),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// WORK ORDER
// ─────────────────────────────────────────────

class WorkOrderPage extends StatelessWidget {
  const WorkOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'Work Order',
      department: 'Production',
      color: _prodColor,
      children: [
        StatsGrid(cards: const [
          StatCard(label: 'Open',       value: '14',  icon: Icons.pending_rounded,      color: Colors.orange),
          StatCard(label: 'In Progress',value: '8',   icon: Icons.autorenew_rounded,    color: Colors.blue),
          StatCard(label: 'Completed',  value: '284', icon: Icons.check_circle_rounded, color: Colors.green),
          StatCard(label: 'Overdue',    value: '3',   icon: Icons.alarm_rounded,        color: Colors.red),
        ]),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Work Orders', actionLabel: 'Create WO'),
        const SizedBox(height: 8),
        const DataRowTile(title: 'WO-2081', subtitle: 'Product A • 500 units • Line 1', trailing: '72%',  accentColor: _prodColor, leadingIcon: Icons.build_rounded,   statusColor: Colors.orange),
        const DataRowTile(title: 'WO-2082', subtitle: 'Product B • 300 units • Line 2', trailing: '45%',  accentColor: _prodColor, leadingIcon: Icons.build_rounded,   statusColor: Colors.blue),
        const DataRowTile(title: 'WO-2080', subtitle: 'Product C • 200 units • Line 1', trailing: '100%', accentColor: _prodColor, leadingIcon: Icons.build_rounded,   statusColor: Colors.green),
        const DataRowTile(title: 'WO-2079', subtitle: 'Rework Batch • Line 3 • URGENT', trailing: 'Delayed', accentColor: _prodColor, leadingIcon: Icons.warning_rounded, statusColor: Colors.red),
        const SizedBox(height: 20),
        const ChartPlaceholder(title: 'Work Order Completion Rate', color: _prodColor),
      ],
      fab: FloatingActionButton.extended(
        backgroundColor: _prodColor,
        foregroundColor: Colors.white,
        onPressed: () {},
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Work Order'),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// LINE MANAGEMENT
// ─────────────────────────────────────────────

class LineManagementPage extends StatelessWidget {
  const LineManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'Line Management',
      department: 'Production',
      color: _prodColor,
      children: [
        StatsGrid(cards: const [
          StatCard(label: 'Active Lines',   value: '4',        icon: Icons.linear_scale_rounded,  color: _prodColor),
          StatCard(label: 'Total Capacity', value: '1,200/h',  icon: Icons.speed_rounded,          color: Colors.blue),
          StatCard(label: 'Current Output', value: '1,092/h',  icon: Icons.trending_up_rounded,    color: Colors.green),
          StatCard(label: 'Downtime Today', value: '42 min',   icon: Icons.pause_circle_rounded,   color: Colors.red),
        ]),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Production Lines'),
        const SizedBox(height: 8),
        const DataRowTile(title: 'Line 1 — Assembly',  subtitle: 'Running • 320 units/hr', trailing: '96% eff.', accentColor: _prodColor, leadingIcon: Icons.precision_manufacturing_rounded, statusColor: Colors.green),
        const DataRowTile(title: 'Line 2 — Packaging', subtitle: 'Running • 280 units/hr', trailing: '91% eff.', accentColor: _prodColor, leadingIcon: Icons.inventory_rounded,              statusColor: Colors.green),
        const DataRowTile(title: 'Line 3 — Quality',   subtitle: 'Paused • Maintenance',   trailing: 'Down',     accentColor: _prodColor, leadingIcon: Icons.build_rounded,                  statusColor: Colors.red),
        const DataRowTile(title: 'Line 4 — Finishing', subtitle: 'Running • 200 units/hr', trailing: '88% eff.', accentColor: _prodColor, leadingIcon: Icons.auto_fix_high_rounded,           statusColor: Colors.orange),
        const SizedBox(height: 20),
        const ChartPlaceholder(title: 'Line Efficiency Over Time', color: _prodColor),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// RESOURCE PLANNER
// ─────────────────────────────────────────────

class ResourcePlannerPage extends StatelessWidget {
  const ResourcePlannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'Resource Planner',
      department: 'Production',
      color: _prodColor,
      children: [
        StatsGrid(cards: const [
          StatCard(label: 'Workforce',    value: '84',      icon: Icons.people_rounded,                    color: _prodColor),
          StatCard(label: 'Machines',     value: '12',      icon: Icons.precision_manufacturing_rounded,   color: Colors.blue),
          StatCard(label: 'Utilization',  value: '88%',     icon: Icons.donut_large_rounded,               color: Colors.green),
          StatCard(label: 'Scheduled OT', value: '3 shifts',icon: Icons.schedule_rounded,                 color: Colors.orange),
        ]),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Weekly Resource Plan'),
        const SizedBox(height: 8),
        const ChartPlaceholder(title: 'Resource Allocation by Day', color: _prodColor, height: 200),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Resource Requests', actionLabel: 'Request'),
        const SizedBox(height: 8),
        const DataRowTile(title: 'Line 1 Operator — 2 staff',    subtitle: 'Jun 6–8 • Shift B',  trailing: 'Approved', accentColor: _prodColor, leadingIcon: Icons.person_add_rounded, statusColor: Colors.green),
        const DataRowTile(title: 'CNC Machine #4 — Repair',      subtitle: 'Jun 5 • 4hrs downtime', trailing: 'Scheduled', accentColor: _prodColor, leadingIcon: Icons.build_rounded,    statusColor: Colors.orange),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// MAINTENANCE
// ─────────────────────────────────────────────

class MaintenancePage extends StatelessWidget {
  const MaintenancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'Maintenance',
      department: 'Production',
      color: _prodColor,
      children: [
        StatsGrid(cards: const [
          StatCard(label: 'Open Tickets',   value: '9',     icon: Icons.confirmation_number_rounded, color: Colors.orange),
          StatCard(label: 'In Progress',    value: '4',     icon: Icons.build_circle_rounded,        color: Colors.blue),
          StatCard(label: 'Completed',      value: '128',   icon: Icons.check_circle_rounded,        color: Colors.green),
          StatCard(label: 'Avg Resolution', value: '3.2h',  icon: Icons.timer_rounded,               color: _prodColor),
        ]),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Open Maintenance Tickets', actionLabel: 'Log Issue'),
        const SizedBox(height: 8),
        const DataRowTile(title: 'Conveyor Belt Jam — Line 3',   subtitle: 'Mechanical • High priority', trailing: 'In Progress', accentColor: _prodColor, leadingIcon: Icons.warning_rounded,  statusColor: Colors.red),
        const DataRowTile(title: 'CNC Calibration — Machine 4',  subtitle: 'Scheduled • Normal',         trailing: 'Scheduled',   accentColor: _prodColor, leadingIcon: Icons.tune_rounded,     statusColor: Colors.orange),
        const DataRowTile(title: 'HVAC Filter Replacement',      subtitle: 'Preventive • Low priority',  trailing: 'Open',        accentColor: _prodColor, leadingIcon: Icons.air_rounded,      statusColor: Colors.blue),
        const SizedBox(height: 20),
        const ChartPlaceholder(title: 'Maintenance Frequency by Machine', color: _prodColor),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// QUALITY CONTROL
// ─────────────────────────────────────────────

class QualityControlPage extends StatelessWidget {
  const QualityControlPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'Quality Control',
      department: 'Production',
      color: _prodColor,
      children: [
        StatsGrid(cards: const [
          StatCard(label: 'Inspections',  value: '142',   icon: Icons.verified_rounded,   color: _prodColor),
          StatCard(label: 'Pass Rate',    value: '98.8%', icon: Icons.thumb_up_rounded,   color: Colors.green, trend: '+0.4%'),
          StatCard(label: 'Defects Found',value: '18',    icon: Icons.cancel_rounded,     color: Colors.red),
          StatCard(label: 'Rework Orders',value: '4',     icon: Icons.replay_rounded,     color: Colors.orange),
        ]),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Recent Inspections', actionLabel: 'New Inspection'),
        const SizedBox(height: 8),
        const DataRowTile(title: 'Batch A — Line 1', subtitle: 'Jun 2 • 500 units inspected',  trailing: 'Passed', accentColor: _prodColor, leadingIcon: Icons.fact_check_rounded, statusColor: Colors.green),
        const DataRowTile(title: 'Batch C — Line 3', subtitle: 'Jun 1 • 200 units • 3 defects',trailing: 'Rework', accentColor: _prodColor, leadingIcon: Icons.warning_rounded,    statusColor: Colors.orange),
        const DataRowTile(title: 'Batch B — Line 2', subtitle: 'May 31 • 300 units',           trailing: 'Passed', accentColor: _prodColor, leadingIcon: Icons.fact_check_rounded, statusColor: Colors.green),
        const SizedBox(height: 20),
        const ChartPlaceholder(title: 'Defect Rate Trend', color: _prodColor),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// PRODUCTION REPORTS
// ─────────────────────────────────────────────

class ProductionReportsPage extends StatelessWidget {
  const ProductionReportsPage({super.key});

  static const List<(String, String, IconData)> _reports = [
    ('Output Summary',       'Units produced by line & shift',  Icons.bar_chart_rounded),
    ('Efficiency Report',    'OEE per line and machine',        Icons.speed_rounded),
    ('Defect Analysis',      'Defect types, trends & cost',     Icons.bug_report_rounded),
    ('Work Order Status',    'Completion rate & delays',        Icons.assignment_rounded),
    ('Maintenance Log',      'Downtime & repair history',       Icons.build_rounded),
    ('Resource Utilization', 'Staff & machine usage',           Icons.people_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'Production Reports',
      department: 'Production',
      color: _prodColor,
      children: [
        const SectionHeader(title: 'Available Reports'),
        const SizedBox(height: 12),
        ..._reports.map((r) => DataRowTile(
              title: r.$1, subtitle: r.$2, trailing: 'Export',
              accentColor: _prodColor, leadingIcon: r.$3)),
        const SizedBox(height: 20),
        const ChartPlaceholder(title: 'Production KPIs Overview', color: _prodColor, height: 200),
      ],
    );
  }
}