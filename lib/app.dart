// lib/app.dart
import 'package:flutter/material.dart';

import 'core/models/player_role.dart';
import 'core/services/role_service.dart';
import 'core/theme/app_themes.dart';
import 'core/theme/theme_controller.dart';
import 'screens/login/login_screen.dart';
import 'features/hr/hr.dart';
import 'screens/finance/finance_screen.dart';
import 'screens/sales/sales_screen.dart';
import 'screens/marketing/marketing_screen.dart';
import 'screens/production/production_screen.dart';
import 'screens/warehouse/warehouse_screen.dart';
import 'screens/logistics/logistics_screen.dart';
import 'screens/management/management_screen.dart';

// ─────────────────────────────────────────────
// SIDEBAR PALETTE
// Matches MAUI SidebarBackgroundColor / HeaderBackgroundColor
// ─────────────────────────────────────────────

const Color _kSidebarBg   = Color(0xFF16182A);
const Color _kHeaderBg    = Color(0xFF0F1019);
const Color _kNavActive   = Color(0xFF252840);
const Color _kNavHover    = Color(0xFF1E2035);
const Color _kSidebarText = Color(0xFFE8E9F3);
const Color _kSidebarSub  = Color(0xFF8B8FA8);
const Color _kSidebarDiv  = Color(0xFF252838);

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
// DEPARTMENT DATA
// Subtitles from Headquartz___Role_Features.pdf (Subtitle column)
// ─────────────────────────────────────────────

const List<Department> departments = [
  Department(
    name: 'Human Resources',
    managerRole: 'HR Manager',
    color: Color(0xFF4DD0C4),
    modules: [
      DepartmentModule(name: 'HR Dashboard',        type: 'page', subtitle: 'Workforce overview',    emoji: '📊'),
      DepartmentModule(name: 'Employee Management', type: 'page', subtitle: 'Staff directory',       emoji: '👥'),
      DepartmentModule(name: 'Recruitment',         type: 'page', subtitle: 'Hiring and Applicants', emoji: '🔍'),
      DepartmentModule(name: 'Payroll',             type: 'page', subtitle: 'Compensation and Pay',  emoji: '💵'),
      DepartmentModule(name: 'Development',         type: 'page', subtitle: 'Training programs',     emoji: '📚'),
      DepartmentModule(name: 'Performance Evals',   type: 'page', subtitle: 'Enforcement reviews',   emoji: '⭐'),
      DepartmentModule(name: 'HR Reports',          type: 'page', subtitle: 'Workforce analysis',    emoji: '📋'),
    ],
  ),
  Department(
    name: 'Finance',
    managerRole: 'Finance Manager',
    color: Color(0xFFFFD54F),
    modules: [
      DepartmentModule(name: 'Finance Dashboard',   type: 'page', subtitle: 'Financial health',   emoji: '💰'),
      DepartmentModule(name: 'Accounts Payable',    type: 'page', subtitle: 'Funds expenditure',  emoji: '📤'),
      DepartmentModule(name: 'Accounts Receivable', type: 'page', subtitle: 'Funds earnings',     emoji: '📥'),
      DepartmentModule(name: 'Loans',               type: 'page', subtitle: 'Debt management',    emoji: '🏦'),
      DepartmentModule(name: 'Budget Allocation',   type: 'page', subtitle: 'Spending limits',    emoji: '📊'),
      DepartmentModule(name: 'Audits',              type: 'page', subtitle: 'Fiscal Integrity',   emoji: '🔎'),
      DepartmentModule(name: 'Finance Reports',     type: 'page', subtitle: 'Fiscal performance', emoji: '📋'),
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
      DepartmentModule(name: 'Marketing Dashboard', type: 'page', subtitle: 'Outreach performance', emoji: '📢'),
      DepartmentModule(name: 'Campaigns',           type: 'page', subtitle: 'Active promotions',    emoji: '🎪'),
      DepartmentModule(name: 'Market Research',     type: 'page', subtitle: 'Consumer insights',    emoji: '🔬'),
      DepartmentModule(name: 'Pricing Strategy',    type: 'page', subtitle: 'Revenue optimization', emoji: '💲'),
      DepartmentModule(name: 'Product Research',    type: 'page', subtitle: 'Lifecycle & Feedback', emoji: '🧪'),
      DepartmentModule(name: 'Branding',            type: 'page', subtitle: 'Identity & Content',   emoji: '🎨'),
      DepartmentModule(name: 'Marketing Reports',   type: 'page', subtitle: 'ROI Analysis',         emoji: '📊'),
    ],
  ),
  Department(
    name: 'Production',
    managerRole: 'Production Manager',
    color: Color(0xFFFF8A65),
    modules: [
      DepartmentModule(name: 'Production Dashboard', type: 'page', subtitle: 'Factory overview',         emoji: '🏭'),
      DepartmentModule(name: 'Work Order',           type: 'page', subtitle: 'Job tracking',             emoji: '📋'),
      DepartmentModule(name: 'Line Management',      type: 'page', subtitle: 'Throughput & Bottlenecks', emoji: '⚙️'),
      DepartmentModule(name: 'Resource Planner',     type: 'page', subtitle: 'Capacity & Allocation',    emoji: '📅'),
      DepartmentModule(name: 'Maintenance',          type: 'page', subtitle: 'Equipment Health',         emoji: '🔧'),
      DepartmentModule(name: 'Quality Control',      type: 'page', subtitle: 'Inspection and Defects',   emoji: '✅'),
      DepartmentModule(name: 'Production Reports',   type: 'page', subtitle: 'Output metrics',           emoji: '📈'),
    ],
  ),
  Department(
    name: 'Warehouse',
    managerRole: 'Warehouse Manager',
    color: Color(0xFF90CAF9),
    modules: [
      DepartmentModule(name: 'Warehouse Dashboard',  type: 'page', subtitle: 'Facility Overview',     emoji: '🏪'),
      DepartmentModule(name: 'Inventory Management', type: 'page', subtitle: 'Current Stock details', emoji: '📦'),
      DepartmentModule(name: 'Stock In',             type: 'page', subtitle: 'Goods receiving',       emoji: '📥'),
      DepartmentModule(name: 'Stock Out',            type: 'page', subtitle: 'Order fulfillment',     emoji: '📤'),
      DepartmentModule(name: 'Flow Management',      type: 'page', subtitle: 'Movement & Logistics',  emoji: '🔄'),
      DepartmentModule(name: 'Storage Allocation',   type: 'page', subtitle: 'Location management',   emoji: '🗂️'),
      DepartmentModule(name: 'Warehouse Reports',    type: 'page', subtitle: 'Operational KPIs',      emoji: '📊'),
    ],
  ),
  Department(
    name: 'Logistics',
    managerRole: 'Logistics Manager',
    color: Color(0xFFEF9A9A),
    modules: [
      DepartmentModule(name: 'Logistics Dashboard', type: 'page', subtitle: 'Supply Chain overview', emoji: '🚛'),
      DepartmentModule(name: 'Shipments',           type: 'page', subtitle: 'Freight handling',      emoji: '📫'),
      DepartmentModule(name: 'Delivery Tracking',   type: 'page', subtitle: 'Real-time Status',      emoji: '📍'),
      DepartmentModule(name: 'Route Planner',       type: 'page', subtitle: 'Path optimization',     emoji: '🗺️'),
      DepartmentModule(name: 'SLA Management',      type: 'page', subtitle: 'Vendor relations',      emoji: '📜'),
      DepartmentModule(name: 'Fleet Management',    type: 'page', subtitle: 'Vehicle controls',      emoji: '🚗'),
      DepartmentModule(name: 'Logistics Reports',   type: 'page', subtitle: 'Network analysis',      emoji: '📋'),
    ],
  ),
  Department(
    name: 'Management',
    managerRole: 'Boards Chairman',
    color: Color(0xFFA5D6A7),
    modules: [
      DepartmentModule(name: 'HR Reports',         type: 'page', subtitle: 'Workforce analysis',  emoji: '👥'),
      DepartmentModule(name: 'Finance Reports',    type: 'page', subtitle: 'Fiscal performance',  emoji: '💰'),
      DepartmentModule(name: 'Sales Reports',      type: 'page', subtitle: 'Performance metrics', emoji: '📈'),
      DepartmentModule(name: 'Marketing Reports',  type: 'page', subtitle: 'ROI Analysis',        emoji: '📢'),
      DepartmentModule(name: 'Production Reports', type: 'page', subtitle: 'Output metrics',      emoji: '🏭'),
      DepartmentModule(name: 'Warehouse Reports',  type: 'page', subtitle: 'Operational KPIs',    emoji: '🏪'),
      DepartmentModule(name: 'Logistics Reports',  type: 'page', subtitle: 'Network analysis',    emoji: '🚛'),
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
          ListenableBuilder(
            listenable: ThemeController.instance,
            builder: (context, _) => IconButton(
              tooltip: ThemeController.instance.isDark ? 'Switch to Light' : 'Switch to Dark',
              icon: Icon(ThemeController.instance.isDark
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded),
              onPressed: () => ThemeController.instance.toggle(context),
            ),
          ),
          IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {}),
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
                  Icon(Icons.lock_outline_rounded, size: 56, color: hq.tertiaryText),
                  const SizedBox(height: 12),
                  Text('No departments available for this role',
                      style: TextStyle(color: hq.secondaryText, fontWeight: FontWeight.w600)),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                itemCount: visible.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 320,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.1,
                ),
                itemBuilder: (context, index) => DepartmentCard(department: visible[index]),
              ),
            ),
    );
  }
}

// ─────────────────────────────────────────────
// DEPARTMENT CARD (home grid tile)
// Tapping navigates to RoleShell (sidebar + content)
// ─────────────────────────────────────────────

class DepartmentCard extends StatelessWidget {
  final Department department;
  const DepartmentCard({super.key, required this.department});

  @override
  Widget build(BuildContext context) {
    final hq = context.hq;
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => RoleShell(department: department)),
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                  color: department.color, borderRadius: BorderRadius.circular(8)),
              child: Text(department.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 13, color: Colors.black87)),
            ),
            const SizedBox(height: 8),
            Text(department.managerRole,
                style: TextStyle(
                    fontSize: 11, color: hq.secondaryText, fontWeight: FontWeight.w500)),
            Divider(height: 16, color: hq.border),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: department.modules
                    .map((m) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(children: [
                            Text(m.emoji, style: const TextStyle(fontSize: 11)),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(m.name,
                                  style: TextStyle(fontSize: 12, color: hq.primaryText),
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

// ═════════════════════════════════════════════
// ROLE SHELL
// Persistent split layout: sidebar (260px) + content area (*)
// Mirrors MAUI: Grid ColumnDefinitions="260,*"
// ═════════════════════════════════════════════

class RoleShell extends StatefulWidget {
  final Department department;
  const RoleShell({super.key, required this.department});

  @override
  State<RoleShell> createState() => _RoleShellState();
}

class _RoleShellState extends State<RoleShell> {
  String _activePage = 'Dashboard';
  late Widget _activeContent;

  @override
  void initState() {
    super.initState();
    _activeContent = _makePlaceholder('Dashboard', 'Analytics overview', kBrandAmber);
  }

  // ── MAIN MENU helpers ─────────────────────────────────────────────────────

  Widget _makePlaceholder(String name, String subtitle, Color color) =>
      ModulePage(moduleName: name, departmentName: 'Company', subtitle: subtitle, color: color);

  // ── Module → Widget resolver ──────────────────────────────────────────────

  Widget _resolveModuleWidget(DepartmentModule module) {
    switch (widget.department.name) {
      case 'Human Resources':
        switch (module.name) {
          case 'HR Dashboard':        return const HrDashboardPage();
          case 'Employee Management': return const EmployeeManagementPage();
          case 'Recruitment':         return const RecruitmentPage();
          case 'Payroll':             return const PayrollPage();
          case 'Development':         return const DevelopmentPage();
          case 'Performance Evals':   return const PerformanceEvalsPage();
          case 'HR Reports':          return const HrReportsPage();
        }
      case 'Finance':
        switch (module.name) {
          case 'Finance Dashboard':   return const FinanceDashboardPage();
          case 'Accounts Payable':    return const AccountsPayablePage();
          case 'Accounts Receivable': return const AccountsReceivablePage();
          case 'Loans':               return const LoansPage();
          case 'Budget Allocation':   return const BudgetAllocationPage();
          case 'Audits':              return const AuditsPage();
          case 'Finance Reports':     return const FinanceReportsPage();
        }
      case 'Sales':
        switch (module.name) {
          case 'Sales Dashboard':        return const SalesDashboardPage();
          case 'Client Management':      return const ClientManagementPage();
          case 'Leads':                  return const LeadsPage();
          case 'Orders':                 return const OrdersPage();
          case 'Pipeline Management':    return const PipelineManagementPage();
          case 'Performance Incentives': return const PerformanceIncentivesPage();
          case 'Sales Reports':          return const SalesReportsPage();
        }
      case 'Marketing':
        switch (module.name) {
          case 'Marketing Dashboard': return const MarketingDashboardPage();
          case 'Campaigns':           return const CampaignsPage();
          case 'Market Research':     return const MarketResearchPage();
          case 'Pricing Strategy':    return const PricingStrategyPage();
          case 'Product Research':    return const ProductResearchPage();
          case 'Branding':            return const BrandingPage();
          case 'Marketing Reports':   return const MarketingReportsPage();
        }
      case 'Production':
        switch (module.name) {
          case 'Production Dashboard': return const ProductionDashboardPage();
          case 'Work Order':           return const WorkOrderPage();
          case 'Line Management':      return const LineManagementPage();
          case 'Resource Planner':     return const ResourcePlannerPage();
          case 'Maintenance':          return const MaintenancePage();
          case 'Quality Control':      return const QualityControlPage();
          case 'Production Reports':   return const ProductionReportsPage();
        }
      case 'Warehouse':
        switch (module.name) {
          case 'Warehouse Dashboard':  return const WarehouseDashboardPage();
          case 'Inventory Management': return const InventoryManagementPage();
          case 'Stock In':             return const StockInPage();
          case 'Stock Out':            return const StockOutPage();
          case 'Flow Management':      return const FlowManagementPage();
          case 'Storage Allocation':   return const StorageAllocationPage();
          case 'Warehouse Reports':    return const WarehouseReportsPage();
        }
      case 'Logistics':
        switch (module.name) {
          case 'Logistics Dashboard': return const LogisticsDashboardPage();
          case 'Shipments':           return const ShipmentsPage();
          case 'Delivery Tracking':   return const DeliveryTrackingPage();
          case 'Route Planner':       return const RoutePlannerPage();
          case 'SLA Management':      return const SlaManagementPage();
          case 'Fleet Management':    return const FleetManagementPage();
          case 'Logistics Reports':   return const LogisticsReportsPage();
        }
      case 'Management':
        switch (module.name) {
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
      moduleName: module.name,
      departmentName: widget.department.name,
      subtitle: module.subtitle,
      color: widget.department.color,
    );
  }

  void _navigate(String pageName, Widget content) =>
      setState(() { _activePage = pageName; _activeContent = content; });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // ── Left sidebar (260px fixed) ──────────────────────────────────
          _HqSidebar(
            department: widget.department,
            activePage: _activePage,
            onDashboard: () => _navigate('Dashboard',
                _makePlaceholder('Dashboard', 'Analytics overview', kBrandAmber)),
            onOverview: () => _navigate('Overview',
                _makePlaceholder('Overview', 'Company snapshot', kBrandAmber)),
            onModuleTap: (m) => _navigate(m.name, _resolveModuleWidget(m)),
            onBack: () => Navigator.of(context).pop(),
          ),
          // ── Right content area (fills remaining width) ──────────────────
          Expanded(child: _activeContent),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════
// HQ SIDEBAR SHELL
// Mirrors MAUI: Border(SidebarBg, RoundRectangle 0,15,0,15)
//   Grid(Auto, *, Auto) → header / scroll / footer
// ═════════════════════════════════════════════

class _HqSidebar extends StatelessWidget {
  final Department department;
  final String activePage;
  final VoidCallback onDashboard;
  final VoidCallback onOverview;
  final void Function(DepartmentModule) onModuleTap;
  final VoidCallback onBack;

  const _HqSidebar({
    required this.department,
    required this.activePage,
    required this.onDashboard,
    required this.onOverview,
    required this.onModuleTap,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
        child: Container(
          color: _kSidebarBg,
          child: Column(
            children: [
              _SidebarHeader(department: department, onBack: onBack),
              Expanded(
                child: _SidebarNav(
                  department: department,
                  activePage: activePage,
                  onDashboard: onDashboard,
                  onOverview: onOverview,
                  onModuleTap: onModuleTap,
                ),
              ),
              const _SidebarFooter(),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SIDEBAR HEADER
// Mirrors MAUI: Border(HeaderBg, Padding 16,20,16,16)
// ─────────────────────────────────────────────

class _SidebarHeader extends StatelessWidget {
  final Department department;
  final VoidCallback onBack;
  const _SidebarHeader({required this.department, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _kHeaderBg,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Logo row ──────────────────────────────────────────────────
          Row(
            children: [
              // HQ badge — gradient purple matching screenshot
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF7C6FF7), Color(0xFF5A50D4)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text('HQ',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5)),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Headquartz',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: _kSidebarText)),
                    Text('ERP Simulation Platform',
                        style: TextStyle(fontSize: 11, color: _kSidebarSub)),
                  ],
                ),
              ),
              // Back to home button
              GestureDetector(
                onTap: onBack,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.07),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: const Icon(Icons.home_rounded, size: 15, color: _kSidebarSub),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ── Role badge ────────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: department.color.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: const Center(child: Text('👤', style: TextStyle(fontSize: 14))),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    department.managerRole,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _kSidebarText),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          Container(height: 1, color: _kSidebarDiv),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SIDEBAR NAV SCROLL AREA
// Mirrors MAUI: ScrollView > VerticalStackLayout
//   MAIN MENU, [Divider], TOOLS, [Divider], SYSTEM
// ─────────────────────────────────────────────

class _SidebarNav extends StatelessWidget {
  final Department department;
  final String activePage;
  final VoidCallback onDashboard;
  final VoidCallback onOverview;
  final void Function(DepartmentModule) onModuleTap;

  const _SidebarNav({
    required this.department,
    required this.activePage,
    required this.onDashboard,
    required this.onOverview,
    required this.onModuleTap,
  });

  Widget _divider() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Container(height: 1, color: _kSidebarDiv),
      );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── MAIN MENU ────────────────────────────────────────────────
          const _SidebarSectionLabel('MAIN MENU'),
          _SidebarNavItem(
            emoji: '📊',
            title: 'Dashboard',
            subtitle: 'Analytics overview',
            isActive: activePage == 'Dashboard',
            accentColor: kBrandAmber,
            onTap: onDashboard,
          ),
          _SidebarNavItem(
            emoji: '🏠',
            title: 'Overview',
            subtitle: 'Company snapshot',
            isActive: activePage == 'Overview',
            accentColor: kBrandAmber,
            onTap: onOverview,
          ),

          _divider(),

          // ── TOOLS ────────────────────────────────────────────────────
          const _SidebarSectionLabel('TOOLS'),
          ...department.modules.map((m) => _SidebarNavItem(
                emoji: m.emoji,
                title: m.name,
                subtitle: m.subtitle,
                isActive: activePage == m.name,
                accentColor: department.color,
                onTap: () => onModuleTap(m),
              )),

          _divider(),

          // ── SYSTEM ───────────────────────────────────────────────────
          const _SidebarSectionLabel('SYSTEM'),
          _SidebarNavItem(
            emoji: '👨‍💼',
            title: 'User Management',
            subtitle: 'Access and permissions',
            isActive: activePage == 'User Management',
            accentColor: const Color(0xFF90CAF9),
            onTap: () {},
          ),
          _SidebarNavItem(
            emoji: '⚙️',
            title: 'Settings',
            subtitle: 'System configuration',
            isActive: activePage == 'Settings',
            accentColor: const Color(0xFF90CAF9),
            onTap: () {},
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SIDEBAR SECTION LABEL
// Mirrors MAUI: SidebarSectionHeader style (small-caps, muted)
// ─────────────────────────────────────────────

class _SidebarSectionLabel extends StatelessWidget {
  final String text;
  const _SidebarSectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: _kSidebarSub,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SIDEBAR NAV ITEM
// Mirrors MAUI: Border(SidebarItemStyle) > Grid(40,*) >
//   [emoji box] + [title / subtitle]
// Adds hover state (MouseRegion) and active left-border accent
// ─────────────────────────────────────────────

class _SidebarNavItem extends StatefulWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final bool isActive;
  final Color accentColor;
  final VoidCallback onTap;

  const _SidebarNavItem({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.isActive,
    required this.accentColor,
    required this.onTap,
  });

  @override
  State<_SidebarNavItem> createState() => _SidebarNavItemState();
}

class _SidebarNavItemState extends State<_SidebarNavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final bg = widget.isActive
        ? _kNavActive
        : _hovered
            ? _kNavHover
            : Colors.transparent;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          margin: const EdgeInsets.symmetric(vertical: 1),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(8),
            border: Border(
              left: BorderSide(
                color: widget.isActive ? widget.accentColor : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Row(
            children: [
              // ── Emoji container (matches MAUI: CardBg, RoundRectangle 8) ──
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: widget.isActive
                      ? widget.accentColor.withOpacity(0.18)
                      : Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(widget.emoji, style: const TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(width: 10),
              // ── Title + Subtitle ─────────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: widget.isActive ? Colors.white : _kSidebarText,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 1),
                    Text(
                      widget.subtitle,
                      style: TextStyle(
                        fontSize: 10,
                        color: widget.isActive
                            ? _kSidebarText.withOpacity(0.6)
                            : _kSidebarSub,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SIDEBAR FOOTER
// Mirrors MAUI: Border(HeaderBg, Padding 16,12,16,16)
//   Divider + green ✓ + "v1.0.0 • Production Ready"
// ─────────────────────────────────────────────

class _SidebarFooter extends StatelessWidget {
  const _SidebarFooter();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _kHeaderBg,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        children: [
          Container(height: 1, color: _kSidebarDiv),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                    color: Color(0xFF4CAF50), shape: BoxShape.circle),
                child: const Center(
                  child: Text('✓',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w800)),
                ),
              ),
              const SizedBox(width: 6),
              const Text('v1.0.0 • Production Ready',
                  style: TextStyle(fontSize: 11, color: _kSidebarSub)),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// MODULE PAGE — fallback placeholder content
// ─────────────────────────────────────────────

class ModulePage extends StatelessWidget {
  final String moduleName;
  final String departmentName;
  final String subtitle;
  final Color color;

  const ModulePage({
    super.key,
    required this.moduleName,
    required this.departmentName,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final hq = context.hq;
    return Scaffold(
      backgroundColor: hq.page,
      appBar: AppBar(
        backgroundColor: color,
        foregroundColor: Colors.black87,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(moduleName),
            Text(subtitle,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
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
            Text(moduleName,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text('$departmentName • $subtitle',
                style: TextStyle(color: hq.secondaryText)),
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