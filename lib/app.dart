// lib/app.dart
import 'package:flutter/material.dart';

import 'core/models/player_role.dart';
import 'core/services/role_service.dart';
import 'core/theme/app_themes.dart';
import 'core/theme/theme_controller.dart';
import 'screens/login/login_screen.dart';
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
  const DepartmentModule({required this.name, required this.type});
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
// DEPARTMENT DATA
// ─────────────────────────────────────────────

const List<Department> departments = [
  Department(
    name: 'Human Resources',
    managerRole: 'HR Manager',
    color: Color(0xFF4DD0C4),
    modules: [
      DepartmentModule(name: 'HR Dashboard', type: 'page'),
      DepartmentModule(name: 'Employee Management', type: 'page'),
      DepartmentModule(name: 'Recruitment', type: 'page'),
      DepartmentModule(name: 'Payroll', type: 'page'),
      DepartmentModule(name: 'Development', type: 'page'),
      DepartmentModule(name: 'Performance Evals', type: 'page'),
      DepartmentModule(name: 'HR Reports', type: 'page'),
    ],
  ),
  Department(
    name: 'Finance',
    managerRole: 'Finance Manager',
    color: Color(0xFFFFD54F),
    modules: [
      DepartmentModule(name: 'Finance Dashboard', type: 'page'),
      DepartmentModule(name: 'Accounts Payable', type: 'page'),
      DepartmentModule(name: 'Accounts Receivable', type: 'page'),
      DepartmentModule(name: 'Loans', type: 'page'),
      DepartmentModule(name: 'Budget Allocation', type: 'page'),
      DepartmentModule(name: 'Audits', type: 'page'),
      DepartmentModule(name: 'Finance Reports', type: 'page'),
    ],
  ),
  Department(
    name: 'Sales',
    managerRole: 'Sales Manager',
    color: Color(0xFFCE93D8),
    modules: [
      DepartmentModule(name: 'Sales Dashboard', type: 'page'),
      DepartmentModule(name: 'Client Management', type: 'page'),
      DepartmentModule(name: 'Leads', type: 'page'),
      DepartmentModule(name: 'Orders', type: 'page'),
      DepartmentModule(name: 'Pipeline Management', type: 'page'),
      DepartmentModule(name: 'Performance Incentives', type: 'page'),
      DepartmentModule(name: 'Sales Reports', type: 'page'),
    ],
  ),
  Department(
    name: 'Marketing',
    managerRole: 'Marketing Manager',
    color: Color(0xFF80CBC4),
    modules: [
      DepartmentModule(name: 'Marketing Dashboard', type: 'page'),
      DepartmentModule(name: 'Campaigns', type: 'page'),
      DepartmentModule(name: 'Market Research', type: 'page'),
      DepartmentModule(name: 'Pricing Strategy', type: 'page'),
      DepartmentModule(name: 'Product Research', type: 'page'),
      DepartmentModule(name: 'Branding', type: 'page'),
      DepartmentModule(name: 'Marketing Reports', type: 'page'),
    ],
  ),
  Department(
    name: 'Production',
    managerRole: 'Production Manager',
    color: Color(0xFFFF8A65),
    modules: [
      DepartmentModule(name: 'Production Dashboard', type: 'page'),
      DepartmentModule(name: 'Work Order', type: 'page'),
      DepartmentModule(name: 'Line Management', type: 'page'),
      DepartmentModule(name: 'Resource Planner', type: 'page'),
      DepartmentModule(name: 'Maintenance', type: 'page'),
      DepartmentModule(name: 'Quality Control', type: 'page'),
      DepartmentModule(name: 'Production Reports', type: 'page'),
    ],
  ),
  Department(
    name: 'Warehouse',
    managerRole: 'Warehouse Manager',
    color: Color(0xFF90CAF9),
    modules: [
      DepartmentModule(name: 'Warehouse Dashboard', type: 'page'),
      DepartmentModule(name: 'Inventory Management', type: 'page'),
      DepartmentModule(name: 'Stock In', type: 'page'),
      DepartmentModule(name: 'Stock Out', type: 'page'),
      DepartmentModule(name: 'Flow Management', type: 'page'),
      DepartmentModule(name: 'Storage Allocation', type: 'page'),
      DepartmentModule(name: 'Warehouse Reports', type: 'page'),
    ],
  ),
  Department(
    name: 'Logistics',
    managerRole: 'Logistics Manager',
    color: Color(0xFFEF9A9A),
    modules: [
      DepartmentModule(name: 'Logistics Dashboard', type: 'page'),
      DepartmentModule(name: 'Shipments', type: 'page'),
      DepartmentModule(name: 'Delivery Tracking', type: 'page'),
      DepartmentModule(name: 'Route Planner', type: 'page'),
      DepartmentModule(name: 'SLA Management', type: 'page'),
      DepartmentModule(name: 'Fleet Management', type: 'page'),
      DepartmentModule(name: 'Logistics Reports', type: 'page'),
    ],
  ),
  Department(
    name: 'Management',
    managerRole: 'Boards Chairman',
    color: Color(0xFFA5D6A7),
    modules: [
      DepartmentModule(name: 'HR Reports', type: 'page'),
      DepartmentModule(name: 'Finance Reports', type: 'page'),
      DepartmentModule(name: 'Sales Reports', type: 'page'),
      DepartmentModule(name: 'Marketing Reports', type: 'page'),
      DepartmentModule(name: 'Production Reports', type: 'page'),
      DepartmentModule(name: 'Warehouse Reports', type: 'page'),
      DepartmentModule(name: 'Logistics Reports', type: 'page'),
    ],
  ),
];

// ─────────────────────────────────────────────
// APP ROOT
// ─────────────────────────────────────────────

class HeadquartzApp extends StatelessWidget {
  const HeadquartzApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeController.instance,
      builder: (context, _) {
        return MaterialApp(
          title: 'Headquartz ERP',
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: ThemeController.instance.mode,
          home: const LoginScreen(),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
// HOME SCREEN — role-filtered department grid
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
    final role = RoleService.instance.currentRole;
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
          // Theme toggle — sun in dark mode, moon in light mode
          ListenableBuilder(
            listenable: ThemeController.instance,
            builder: (context, _) => IconButton(
              tooltip: ThemeController.instance.isDark
                  ? 'Switch to Light'
                  : 'Switch to Dark',
              icon: Icon(
                ThemeController.instance.isDark
                    ? Icons.light_mode_rounded
                    : Icons.dark_mode_rounded,
              ),
              onPressed: () => ThemeController.instance.toggle(context),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
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
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.lock_outline_rounded,
                        size: 56, color: hq.tertiaryText),
                    const SizedBox(height: 12),
                    Text(
                      'No departments available for this role',
                      style: TextStyle(
                        color: hq.secondaryText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
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
                itemBuilder: (context, index) =>
                    DepartmentCard(department: visible[index]),
              ),
            ),
    );
  }
}

// ─────────────────────────────────────────────
// DEPARTMENT CARD
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
          builder: (_) => DepartmentScreen(department: department),
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
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: department.color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                department.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              department.managerRole,
              style: TextStyle(
                fontSize: 11,
                color: hq.secondaryText,
                fontWeight: FontWeight.w500,
              ),
            ),
            Divider(height: 16, color: hq.border),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: department.modules
                    .map(
                      (m) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          children: [
                            Icon(Icons.arrow_right,
                                size: 16, color: department.color),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                m.name,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: hq.primaryText,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// DEPARTMENT SCREEN — module list
// ─────────────────────────────────────────────

class DepartmentScreen extends StatelessWidget {
  final Department department;
  const DepartmentScreen({super.key, required this.department});

  Widget _resolveScreen({
    required String departmentName,
    required String moduleName,
    required Color color,
  }) {
    switch (departmentName) {
      case 'Human Resources':
        switch (moduleName) {
          case 'HR Dashboard':         return const HrDashboardPage();
          case 'Employee Management':  return const EmployeeManagementPage();
          case 'Recruitment':          return const RecruitmentPage();
          case 'Payroll':              return const PayrollPage();
          case 'Development':          return const DevelopmentPage();
          case 'Performance Evals':    return const PerformanceEvalsPage();
          case 'HR Reports':           return const HrReportsPage();
        }
      case 'Finance':
        switch (moduleName) {
          case 'Finance Dashboard':    return const FinanceDashboardPage();
          case 'Accounts Payable':     return const AccountsPayablePage();
          case 'Accounts Receivable':  return const AccountsReceivablePage();
          case 'Loans':                return const LoansPage();
          case 'Budget Allocation':    return const BudgetAllocationPage();
          case 'Audits':               return const AuditsPage();
          case 'Finance Reports':      return const FinanceReportsPage();
        }
      case 'Sales':
        switch (moduleName) {
          case 'Sales Dashboard':         return const SalesDashboardPage();
          case 'Client Management':       return const ClientManagementPage();
          case 'Leads':                   return const LeadsPage();
          case 'Orders':                  return const OrdersPage();
          case 'Pipeline Management':     return const PipelineManagementPage();
          case 'Performance Incentives':  return const PerformanceIncentivesPage();
          case 'Sales Reports':           return const SalesReportsPage();
        }
      case 'Marketing':
        switch (moduleName) {
          case 'Marketing Dashboard': return const MarketingDashboardPage();
          case 'Campaigns':           return const CampaignsPage();
          case 'Market Research':     return const MarketResearchPage();
          case 'Pricing Strategy':    return const PricingStrategyPage();
          case 'Product Research':    return const ProductResearchPage();
          case 'Branding':            return const BrandingPage();
          case 'Marketing Reports':   return const MarketingReportsPage();
        }
      case 'Production':
        switch (moduleName) {
          case 'Production Dashboard': return const ProductionDashboardPage();
          case 'Work Order':           return const WorkOrderPage();
          case 'Line Management':      return const LineManagementPage();
          case 'Resource Planner':     return const ResourcePlannerPage();
          case 'Maintenance':          return const MaintenancePage();
          case 'Quality Control':      return const QualityControlPage();
          case 'Production Reports':   return const ProductionReportsPage();
        }
      case 'Warehouse':
        switch (moduleName) {
          case 'Warehouse Dashboard':   return const WarehouseDashboardPage();
          case 'Inventory Management':  return const InventoryManagementPage();
          case 'Stock In':              return const StockInPage();
          case 'Stock Out':             return const StockOutPage();
          case 'Flow Management':       return const FlowManagementPage();
          case 'Storage Allocation':    return const StorageAllocationPage();
          case 'Warehouse Reports':     return const WarehouseReportsPage();
        }
      case 'Logistics':
        switch (moduleName) {
          case 'Logistics Dashboard': return const LogisticsDashboardPage();
          case 'Shipments':           return const ShipmentsPage();
          case 'Delivery Tracking':   return const DeliveryTrackingPage();
          case 'Route Planner':       return const RoutePlannerPage();
          case 'SLA Management':      return const SlaManagementPage();
          case 'Fleet Management':    return const FleetManagementPage();
          case 'Logistics Reports':   return const LogisticsReportsPage();
        }
      case 'Management':
        switch (moduleName) {
          case 'HR Reports':          return const MgmtHrReportsPage();
          case 'Finance Reports':     return const MgmtFinanceReportsPage();
          case 'Sales Reports':       return const MgmtSalesReportsPage();
          case 'Marketing Reports':   return const MgmtMarketingReportsPage();
          case 'Production Reports':  return const MgmtProductionReportsPage();
          case 'Warehouse Reports':   return const MgmtWarehouseReportsPage();
          case 'Logistics Reports':   return const MgmtLogisticsReportsPage();
        }
    }
    return ModulePage(
        moduleName: moduleName,
        departmentName: departmentName,
        color: color);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: department.color,
        foregroundColor: Colors.black87,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(department.name),
            Text(department.managerRole,
                style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w400)),
          ],
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: department.modules.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final module = department.modules[index];
          return ModuleTile(
            module: module,
            color: department.color,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => _resolveScreen(
                  departmentName: department.name,
                  moduleName: module.name,
                  color: department.color,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────
// MODULE TILE
// ─────────────────────────────────────────────

class ModuleTile extends StatelessWidget {
  final DepartmentModule module;
  final Color color;
  final VoidCallback onTap;

  const ModuleTile({
    super.key,
    required this.module,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hq = context.hq;
    return ListTile(
      onTap: onTap,
      tileColor: color.withOpacity(0.12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      leading: CircleAvatar(
        backgroundColor: color,
        radius: 18,
        child: const Icon(Icons.grid_view_rounded,
            size: 16, color: Colors.black87),
      ),
      title: Text(
        module.name,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: hq.primaryText,
        ),
      ),
      subtitle: Text(
        module.type.toUpperCase(),
        style: TextStyle(fontSize: 10, color: hq.tertiaryText),
      ),
      trailing: Icon(Icons.chevron_right, color: hq.secondaryText),
    );
  }
}

// ─────────────────────────────────────────────
// MODULE PAGE — fallback placeholder
// ─────────────────────────────────────────────

class ModulePage extends StatelessWidget {
  final String moduleName;
  final String departmentName;
  final Color color;

  const ModulePage({
    super.key,
    required this.moduleName,
    required this.departmentName,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final hq = context.hq;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color,
        foregroundColor: Colors.black87,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(moduleName),
            Text(departmentName,
                style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w400)),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 48,
              backgroundColor: color.withOpacity(0.2),
              child: Icon(Icons.construction_rounded, size: 40, color: color),
            ),
            const SizedBox(height: 24),
            Text(
              moduleName,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              '$departmentName • Page',
              style: TextStyle(color: hq.secondaryText),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Open Module'),
              style: FilledButton.styleFrom(backgroundColor: color),
            ),
          ],
        ),
      ),
    );
  }
}