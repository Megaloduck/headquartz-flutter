// lib/app.dart
//
// ─── SHELL ONLY ───────────────────────────────────────────────────────────────
// This file owns:
//   • HeadquartzApp (MaterialApp root)
//   • HomeScreen    (role-picker grid)
//   • DepartmentCard (routes to each role's own screen)
//   • Department / DepartmentModule models
//   • departments list (single source of truth for all role data)
//
// Everything else (sidebar, RoleShell, ModulePage) lives in:
//   lib/widgets/role_shell.dart
//
// Each role's pages live in:
//   lib/screens/<role>/<role>_screen.dart
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

import 'core/models/player_role.dart';
import 'core/services/role_service.dart';
import 'core/theme/app_themes.dart';
import 'core/theme/theme_controller.dart';
import 'screens/login/login_screen.dart';

// Role screens — each owns its own sidebar wiring + page resolver
import 'screens/hr/hr_screen.dart';
import 'screens/finance/finance_screen.dart';
import 'screens/sales/sales_screen.dart';
import 'screens/marketing/marketing_screen.dart';
import 'screens/production/production_screen.dart';
import 'screens/warehouse/warehouse_screen.dart';
import 'screens/logistics/logistics_screen.dart';
import 'screens/management/management_screen.dart';

// ─────────────────────────────────────────────
// MODELS
// ─────────────────────────────────────────────

class DepartmentModule {
  final String name;
  final String type;
  final String subtitle;
  final String emoji;
  const DepartmentModule({
    required this.name,
    required this.type,
    required this.subtitle,
    required this.emoji,
  });
}

class Department {
  final String name;
  final String managerRole;
  final Color color;
  final List<DepartmentModule> modules;
  const Department({
    required this.name,
    required this.managerRole,
    required this.color,
    required this.modules,
  });
}

// ─────────────────────────────────────────────
// DEPARTMENT DATA  (single source of truth)
// ─────────────────────────────────────────────

const List<Department> departments = [
  Department(
    name: 'Human Resources',
    managerRole: 'HR Manager',
    color: Color(0xFF4DD0C4),
    modules: [
      DepartmentModule(name: 'HR Dashboard',        type: 'page', subtitle: 'Workforce overview',      emoji: '📊'),
      DepartmentModule(name: 'Employee Management', type: 'page', subtitle: 'Staff directory',         emoji: '👥'),
      DepartmentModule(name: 'Recruitment',         type: 'page', subtitle: 'Hiring and Applicants',   emoji: '🔍'),
      DepartmentModule(name: 'Payroll',             type: 'page', subtitle: 'Compensation and Pay',    emoji: '💵'),
      DepartmentModule(name: 'Development',         type: 'page', subtitle: 'Training programs',       emoji: '📚'),
      DepartmentModule(name: 'Performance Evals',   type: 'page', subtitle: 'Enforcement reviews',     emoji: '⭐'),
      DepartmentModule(name: 'HR Reports',          type: 'page', subtitle: 'Workforce analysis',      emoji: '📋'),
    ],
  ),
  Department(
    name: 'Finance',
    managerRole: 'Finance Manager',
    color: Color(0xFFFFD54F),
    modules: [
      DepartmentModule(name: 'Finance Dashboard',   type: 'page', subtitle: 'Financial health',        emoji: '💰'),
      DepartmentModule(name: 'Accounts Payable',    type: 'page', subtitle: 'Funds expenditure',       emoji: '📤'),
      DepartmentModule(name: 'Accounts Receivable', type: 'page', subtitle: 'Funds earnings',          emoji: '📥'),
      DepartmentModule(name: 'Loans',               type: 'page', subtitle: 'Debt management',         emoji: '🏦'),
      DepartmentModule(name: 'Budget Allocation',   type: 'page', subtitle: 'Spending limits',         emoji: '📊'),
      DepartmentModule(name: 'Audits',              type: 'page', subtitle: 'Fiscal Integrity',        emoji: '🔎'),
      DepartmentModule(name: 'Finance Reports',     type: 'page', subtitle: 'Fiscal performance',      emoji: '📋'),
    ],
  ),
  Department(
    name: 'Sales',
    managerRole: 'Sales Manager',
    color: Color(0xFFCE93D8),
    modules: [
      DepartmentModule(name: 'Sales Dashboard',        type: 'page', subtitle: 'Revenue overview',      emoji: '📈'),
      DepartmentModule(name: 'Client Management',      type: 'page', subtitle: 'CRM & Accounts',        emoji: '🤝'),
      DepartmentModule(name: 'Leads',                  type: 'page', subtitle: 'Prospect tracking',     emoji: '🎯'),
      DepartmentModule(name: 'Orders',                 type: 'page', subtitle: 'Customer purchases',    emoji: '📦'),
      DepartmentModule(name: 'Pipeline Management',    type: 'page', subtitle: 'Deal forecasting',      emoji: '🔄'),
      DepartmentModule(name: 'Performance Incentives', type: 'page', subtitle: 'Commissions & Targets', emoji: '🏆'),
      DepartmentModule(name: 'Sales Reports',          type: 'page', subtitle: 'Performance metrics',   emoji: '📋'),
    ],
  ),
  Department(
    name: 'Marketing',
    managerRole: 'Marketing Manager',
    color: Color(0xFF80CBC4),
    modules: [
      DepartmentModule(name: 'Marketing Dashboard', type: 'page', subtitle: 'Outreach performance',    emoji: '📢'),
      DepartmentModule(name: 'Campaigns',           type: 'page', subtitle: 'Active promotions',       emoji: '🎪'),
      DepartmentModule(name: 'Market Research',     type: 'page', subtitle: 'Consumer insights',       emoji: '🔬'),
      DepartmentModule(name: 'Pricing Strategy',    type: 'page', subtitle: 'Revenue optimization',    emoji: '💲'),
      DepartmentModule(name: 'Product Research',    type: 'page', subtitle: 'Lifecycle & Feedback',    emoji: '🧪'),
      DepartmentModule(name: 'Branding',            type: 'page', subtitle: 'Identity & Content',      emoji: '🎨'),
      DepartmentModule(name: 'Marketing Reports',   type: 'page', subtitle: 'ROI Analysis',            emoji: '📊'),
    ],
  ),
  Department(
    name: 'Production',
    managerRole: 'Production Manager',
    color: Color(0xFFFF8A65),
    modules: [
      DepartmentModule(name: 'Production Dashboard', type: 'page', subtitle: 'Factory overview',          emoji: '🏭'),
      DepartmentModule(name: 'Work Order',           type: 'page', subtitle: 'Job tracking',              emoji: '📋'),
      DepartmentModule(name: 'Line Management',      type: 'page', subtitle: 'Throughput & Bottlenecks',  emoji: '⚙️'),
      DepartmentModule(name: 'Resource Planner',     type: 'page', subtitle: 'Capacity & Allocation',     emoji: '📅'),
      DepartmentModule(name: 'Maintenance',          type: 'page', subtitle: 'Equipment Health',          emoji: '🔧'),
      DepartmentModule(name: 'Quality Control',      type: 'page', subtitle: 'Inspection and Defects',    emoji: '✅'),
      DepartmentModule(name: 'Production Reports',   type: 'page', subtitle: 'Output metrics',            emoji: '📈'),
    ],
  ),
  Department(
    name: 'Warehouse',
    managerRole: 'Warehouse Manager',
    color: Color(0xFF90CAF9),
    modules: [
      DepartmentModule(name: 'Warehouse Dashboard',  type: 'page', subtitle: 'Facility Overview',         emoji: '🏪'),
      DepartmentModule(name: 'Inventory Management', type: 'page', subtitle: 'Current Stock details',     emoji: '📦'),
      DepartmentModule(name: 'Stock In',             type: 'page', subtitle: 'Goods receiving',           emoji: '📥'),
      DepartmentModule(name: 'Stock Out',            type: 'page', subtitle: 'Order fulfillment',         emoji: '📤'),
      DepartmentModule(name: 'Flow Management',      type: 'page', subtitle: 'Movement & Logistics',      emoji: '🔄'),
      DepartmentModule(name: 'Storage Allocation',   type: 'page', subtitle: 'Location management',       emoji: '🗂️'),
      DepartmentModule(name: 'Warehouse Reports',    type: 'page', subtitle: 'Operational KPIs',          emoji: '📊'),
    ],
  ),
  Department(
    name: 'Logistics',
    managerRole: 'Logistics Manager',
    color: Color(0xFFEF9A9A),
    modules: [
      DepartmentModule(name: 'Logistics Dashboard', type: 'page', subtitle: 'Supply Chain overview',     emoji: '🚛'),
      DepartmentModule(name: 'Shipments',           type: 'page', subtitle: 'Freight handling',          emoji: '📫'),
      DepartmentModule(name: 'Delivery Tracking',   type: 'page', subtitle: 'Real-time Status',          emoji: '📍'),
      DepartmentModule(name: 'Route Planner',       type: 'page', subtitle: 'Path optimization',         emoji: '🗺️'),
      DepartmentModule(name: 'SLA Management',      type: 'page', subtitle: 'Vendor relations',          emoji: '📜'),
      DepartmentModule(name: 'Fleet Management',    type: 'page', subtitle: 'Vehicle controls',          emoji: '🚗'),
      DepartmentModule(name: 'Logistics Reports',   type: 'page', subtitle: 'Network analysis',          emoji: '📋'),
    ],
  ),
  Department(
    name: 'Management',
    managerRole: 'Boards Chairman',
    color: Color(0xFFA5D6A7),
    modules: [
      DepartmentModule(name: 'HR Reports',         type: 'page', subtitle: 'Workforce analysis',         emoji: '👥'),
      DepartmentModule(name: 'Finance Reports',    type: 'page', subtitle: 'Fiscal performance',         emoji: '💰'),
      DepartmentModule(name: 'Sales Reports',      type: 'page', subtitle: 'Performance metrics',        emoji: '📈'),
      DepartmentModule(name: 'Marketing Reports',  type: 'page', subtitle: 'ROI Analysis',               emoji: '📢'),
      DepartmentModule(name: 'Production Reports', type: 'page', subtitle: 'Output metrics',             emoji: '🏭'),
      DepartmentModule(name: 'Warehouse Reports',  type: 'page', subtitle: 'Operational KPIs',           emoji: '🏪'),
      DepartmentModule(name: 'Logistics Reports',  type: 'page', subtitle: 'Network analysis',           emoji: '🚛'),
    ],
  ),
];

// ─────────────────────────────────────────────
// ROUTING MAP  department name → screen widget
// ─────────────────────────────────────────────

Widget _screenForDepartment(Department dept) {
  return switch (dept.name) {
    'Human Resources' => const HrScreen(),
    'Finance'         => const FinanceScreen(),
    'Sales'           => const SalesScreen(),
    'Marketing'       => const MarketingScreen(),
    'Production'      => const ProductionScreen(),
    'Warehouse'       => const WarehouseScreen(),
    'Logistics'       => const LogisticsScreen(),
    'Management'      => const ManagementScreen(),
    _                 => const SizedBox.shrink(),
  };
}

// ─────────────────────────────────────────────
// APP ROOT
// ─────────────────────────────────────────────

class HeadquartzApp extends StatelessWidget {
  const HeadquartzApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeController.instance,
      builder: (context, _) => MaterialApp(
        title: 'Headquartz ERP',
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeController.instance.mode,
        home: const LoginScreen(),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// HOME SCREEN — role-picker grid
// ─────────────────────────────────────────────

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _logout(BuildContext context) {
    RoleService.instance.logout();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final role    = RoleService.instance.currentRole;
    final visible = departments
        .where((d) => RoleService.instance.canSeeDepartment(d.name))
        .toList();
    final hq = context.hq;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Headquartz'),
            Text(
              role != null
                  ? 'Signed in as ${role.displayName}'
                  : 'Enterprise Resource Planning Simulator',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        actions: [
          ListenableBuilder(
            listenable: ThemeController.instance,
            builder: (context, _) => IconButton(
              tooltip: ThemeController.instance.isDark
                  ? 'Switch to Light'
                  : 'Switch to Dark',
              icon: Icon(ThemeController.instance.isDark
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded),
              onPressed: () => ThemeController.instance.toggle(context),
            ),
          ),
          IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {}),
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => _logout(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: visible.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock_outline_rounded,
                      size: 56, color: hq.tertiaryText),
                  const SizedBox(height: 12),
                  Text('No departments available for this role',
                      style: TextStyle(
                          color: hq.secondaryText,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                itemCount: visible.length,
                gridDelegate:
                    const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 320,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.1,
                ),
                itemBuilder: (context, i) =>
                    DepartmentCard(department: visible[i]),
              ),
            ),
    );
  }
}

// ─────────────────────────────────────────────
// DEPARTMENT CARD
// Taps route to the role's own screen
// ─────────────────────────────────────────────

class DepartmentCard extends StatelessWidget {
  final Department department;
  const DepartmentCard({super.key, required this.department});

  @override
  Widget build(BuildContext context) {
    final hq = context.hq;
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => _screenForDepartment(department),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: department.color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: department.color, width: 1.5),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Role colour pill
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                  color: department.color,
                  borderRadius: BorderRadius.circular(8)),
              child: Text(department.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: Colors.black87)),
            ),
            const SizedBox(height: 8),
            Text(department.managerRole,
                style: TextStyle(
                    fontSize: 11,
                    color: hq.secondaryText,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 12),
            Divider(height: 16, color: hq.border),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: department.modules
                    .map((m) => Padding(
                          padding:
                              const EdgeInsets.symmetric(vertical: 2),
                          child: Row(children: [
                            Text(m.emoji,
                                style: const TextStyle(fontSize: 11)),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(m.name,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: hq.primaryText),
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ]),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}