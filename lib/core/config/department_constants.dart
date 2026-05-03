import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Canonical role identifier. Used across simulation, networking and UI.
enum RoleId {
  hr,
  finance,
  sales,
  marketing,
  production,
  warehouse,
  logistics,
  chairman;

  String get key => name;

  bool get isObserver => this == RoleId.chairman;

  static RoleId? tryParse(String? raw) {
    if (raw == null) return null;
    for (final r in RoleId.values) {
      if (r.name == raw.toLowerCase()) return r;
    }
    return null;
  }
}

/// Static metadata describing each department / role.
@immutable
class DepartmentMeta {
  const DepartmentMeta({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.pages,
  });

  final RoleId id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final List<DepartmentPageMeta> pages;
}

/// Metadata for a single page inside a department.
@immutable
class DepartmentPageMeta {
  const DepartmentPageMeta({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
}

/// Master directory of department metadata. The order here drives the
/// lobby role list and routing.
class DepartmentConstants {
  DepartmentConstants._();

  static const Map<RoleId, DepartmentMeta> all = {
    RoleId.hr: DepartmentMeta(
      id: RoleId.hr,
      title: 'Human Resources',
      subtitle: 'HR Manager',
      icon: Icons.groups_rounded,
      color: AppColors.hr,
      pages: [
        DepartmentPageMeta(
          id: 'dashboard',
          title: 'HR Dashboard',
          subtitle: 'Workforce overview',
          icon: Icons.dashboard_rounded,
        ),
        DepartmentPageMeta(
          id: 'employees',
          title: 'Employee Management',
          subtitle: 'Staff directory',
          icon: Icons.badge_rounded,
        ),
        DepartmentPageMeta(
          id: 'recruitment',
          title: 'Recruitment',
          subtitle: 'Hiring & applicants',
          icon: Icons.person_search_rounded,
        ),
        DepartmentPageMeta(
          id: 'payroll',
          title: 'Payroll',
          subtitle: 'Compensation & pay',
          icon: Icons.payments_rounded,
        ),
        DepartmentPageMeta(
          id: 'development',
          title: 'Development',
          subtitle: 'Training programs',
          icon: Icons.school_rounded,
        ),
        DepartmentPageMeta(
          id: 'performance',
          title: 'Performance Evals',
          subtitle: 'Performance reviews',
          icon: Icons.assessment_rounded,
        ),
        DepartmentPageMeta(
          id: 'reports',
          title: 'HR Reports',
          subtitle: 'Workforce analysis',
          icon: Icons.summarize_rounded,
        ),
      ],
    ),
    RoleId.finance: DepartmentMeta(
      id: RoleId.finance,
      title: 'Finance',
      subtitle: 'Finance Manager',
      icon: Icons.account_balance_rounded,
      color: AppColors.finance,
      pages: [
        DepartmentPageMeta(
          id: 'dashboard',
          title: 'Finance Dashboard',
          subtitle: 'Financial health',
          icon: Icons.dashboard_rounded,
        ),
        DepartmentPageMeta(
          id: 'payable',
          title: 'Accounts Payable',
          subtitle: 'Funds expenditure',
          icon: Icons.upload_rounded,
        ),
        DepartmentPageMeta(
          id: 'receivable',
          title: 'Accounts Receivable',
          subtitle: 'Funds earnings',
          icon: Icons.download_rounded,
        ),
        DepartmentPageMeta(
          id: 'loans',
          title: 'Loans',
          subtitle: 'Debt management',
          icon: Icons.handshake_rounded,
        ),
        DepartmentPageMeta(
          id: 'budget',
          title: 'Budget Allocation',
          subtitle: 'Spending limits',
          icon: Icons.pie_chart_rounded,
        ),
        DepartmentPageMeta(
          id: 'audits',
          title: 'Audits',
          subtitle: 'Fiscal integrity',
          icon: Icons.fact_check_rounded,
        ),
        DepartmentPageMeta(
          id: 'reports',
          title: 'Finance Reports',
          subtitle: 'Fiscal performance',
          icon: Icons.summarize_rounded,
        ),
      ],
    ),
    RoleId.sales: DepartmentMeta(
      id: RoleId.sales,
      title: 'Sales',
      subtitle: 'Sales Manager',
      icon: Icons.trending_up_rounded,
      color: AppColors.sales,
      pages: [
        DepartmentPageMeta(
          id: 'dashboard',
          title: 'Sales Dashboard',
          subtitle: 'Revenue overview',
          icon: Icons.dashboard_rounded,
        ),
        DepartmentPageMeta(
          id: 'clients',
          title: 'Client Management',
          subtitle: 'CRM & accounts',
          icon: Icons.business_center_rounded,
        ),
        DepartmentPageMeta(
          id: 'leads',
          title: 'Leads',
          subtitle: 'Prospect tracking',
          icon: Icons.electric_bolt_rounded,
        ),
        DepartmentPageMeta(
          id: 'orders',
          title: 'Orders',
          subtitle: 'Customer purchases',
          icon: Icons.receipt_long_rounded,
        ),
        DepartmentPageMeta(
          id: 'pipeline',
          title: 'Pipeline Management',
          subtitle: 'Deal forecasting',
          icon: Icons.timeline_rounded,
        ),
        DepartmentPageMeta(
          id: 'incentives',
          title: 'Performance Incentives',
          subtitle: 'Commissions & targets',
          icon: Icons.workspace_premium_rounded,
        ),
        DepartmentPageMeta(
          id: 'reports',
          title: 'Sales Reports',
          subtitle: 'Performance metrics',
          icon: Icons.summarize_rounded,
        ),
      ],
    ),
    RoleId.marketing: DepartmentMeta(
      id: RoleId.marketing,
      title: 'Marketing',
      subtitle: 'Marketing Manager',
      icon: Icons.campaign_rounded,
      color: AppColors.marketing,
      pages: [
        DepartmentPageMeta(
          id: 'dashboard',
          title: 'Marketing Dashboard',
          subtitle: 'Outreach performance',
          icon: Icons.dashboard_rounded,
        ),
        DepartmentPageMeta(
          id: 'campaigns',
          title: 'Campaigns',
          subtitle: 'Active promotions',
          icon: Icons.campaign_rounded,
        ),
        DepartmentPageMeta(
          id: 'research',
          title: 'Market Research',
          subtitle: 'Consumer insights',
          icon: Icons.insights_rounded,
        ),
        DepartmentPageMeta(
          id: 'pricing',
          title: 'Pricing Strategy',
          subtitle: 'Revenue optimization',
          icon: Icons.price_change_rounded,
        ),
        DepartmentPageMeta(
          id: 'product',
          title: 'Product Research',
          subtitle: 'Lifecycle & feedback',
          icon: Icons.science_rounded,
        ),
        DepartmentPageMeta(
          id: 'branding',
          title: 'Branding',
          subtitle: 'Identity & content',
          icon: Icons.palette_rounded,
        ),
        DepartmentPageMeta(
          id: 'reports',
          title: 'Marketing Reports',
          subtitle: 'ROI analysis',
          icon: Icons.summarize_rounded,
        ),
      ],
    ),
    RoleId.production: DepartmentMeta(
      id: RoleId.production,
      title: 'Production',
      subtitle: 'Production Manager',
      icon: Icons.precision_manufacturing_rounded,
      color: AppColors.production,
      pages: [
        DepartmentPageMeta(
          id: 'dashboard',
          title: 'Production Dashboard',
          subtitle: 'Factory overview',
          icon: Icons.dashboard_rounded,
        ),
        DepartmentPageMeta(
          id: 'workorder',
          title: 'Work Order',
          subtitle: 'Job tracking',
          icon: Icons.assignment_rounded,
        ),
        DepartmentPageMeta(
          id: 'lines',
          title: 'Line Management',
          subtitle: 'Throughput & bottlenecks',
          icon: Icons.linear_scale_rounded,
        ),
        DepartmentPageMeta(
          id: 'planner',
          title: 'Resource Planner',
          subtitle: 'Capacity & allocation',
          icon: Icons.calendar_view_week_rounded,
        ),
        DepartmentPageMeta(
          id: 'maintenance',
          title: 'Maintenance',
          subtitle: 'Equipment health',
          icon: Icons.build_rounded,
        ),
        DepartmentPageMeta(
          id: 'quality',
          title: 'Quality Control',
          subtitle: 'Inspection & defects',
          icon: Icons.verified_rounded,
        ),
        DepartmentPageMeta(
          id: 'reports',
          title: 'Production Reports',
          subtitle: 'Output metrics',
          icon: Icons.summarize_rounded,
        ),
      ],
    ),
    RoleId.warehouse: DepartmentMeta(
      id: RoleId.warehouse,
      title: 'Warehouse',
      subtitle: 'Warehouse Manager',
      icon: Icons.warehouse_rounded,
      color: AppColors.warehouse,
      pages: [
        DepartmentPageMeta(
          id: 'dashboard',
          title: 'Warehouse Dashboard',
          subtitle: 'Facility overview',
          icon: Icons.dashboard_rounded,
        ),
        DepartmentPageMeta(
          id: 'inventory',
          title: 'Inventory Management',
          subtitle: 'Current stock details',
          icon: Icons.inventory_2_rounded,
        ),
        DepartmentPageMeta(
          id: 'stockin',
          title: 'Stock In',
          subtitle: 'Goods receiving',
          icon: Icons.input_rounded,
        ),
        DepartmentPageMeta(
          id: 'stockout',
          title: 'Stock Out',
          subtitle: 'Order fulfillment',
          icon: Icons.output_rounded,
        ),
        DepartmentPageMeta(
          id: 'flow',
          title: 'Flow Management',
          subtitle: 'Movement & logistics',
          icon: Icons.swap_horiz_rounded,
        ),
        DepartmentPageMeta(
          id: 'storage',
          title: 'Storage Allocation',
          subtitle: 'Location management',
          icon: Icons.shelves,
        ),
        DepartmentPageMeta(
          id: 'reports',
          title: 'Warehouse Reports',
          subtitle: 'Operational KPIs',
          icon: Icons.summarize_rounded,
        ),
      ],
    ),
    RoleId.logistics: DepartmentMeta(
      id: RoleId.logistics,
      title: 'Logistics',
      subtitle: 'Logistics Manager',
      icon: Icons.local_shipping_rounded,
      color: AppColors.logistics,
      pages: [
        DepartmentPageMeta(
          id: 'dashboard',
          title: 'Logistics Dashboard',
          subtitle: 'Supply chain overview',
          icon: Icons.dashboard_rounded,
        ),
        DepartmentPageMeta(
          id: 'shipments',
          title: 'Shipments',
          subtitle: 'Freight handling',
          icon: Icons.inventory_rounded,
        ),
        DepartmentPageMeta(
          id: 'tracking',
          title: 'Delivery Tracking',
          subtitle: 'Real-time status',
          icon: Icons.location_on_rounded,
        ),
        DepartmentPageMeta(
          id: 'routes',
          title: 'Route Planner',
          subtitle: 'Path optimization',
          icon: Icons.alt_route_rounded,
        ),
        DepartmentPageMeta(
          id: 'sla',
          title: 'SLA Management',
          subtitle: 'Vendor relations',
          icon: Icons.handshake_rounded,
        ),
        DepartmentPageMeta(
          id: 'fleet',
          title: 'Fleet Management',
          subtitle: 'Vehicle controls',
          icon: Icons.directions_bus_rounded,
        ),
        DepartmentPageMeta(
          id: 'reports',
          title: 'Logistics Reports',
          subtitle: 'Network analysis',
          icon: Icons.summarize_rounded,
        ),
      ],
    ),
    RoleId.chairman: DepartmentMeta(
      id: RoleId.chairman,
      title: 'Board Chairman',
      subtitle: 'Observer',
      icon: Icons.workspace_premium_rounded,
      color: AppColors.chairman,
      pages: [
        DepartmentPageMeta(
          id: 'overview',
          title: 'Company Overview',
          subtitle: 'Executive dashboard',
          icon: Icons.dashboard_rounded,
        ),
        DepartmentPageMeta(
          id: 'hr',
          title: 'HR Reports',
          subtitle: 'Workforce analysis',
          icon: Icons.groups_rounded,
        ),
        DepartmentPageMeta(
          id: 'finance',
          title: 'Finance Reports',
          subtitle: 'Fiscal performance',
          icon: Icons.account_balance_rounded,
        ),
        DepartmentPageMeta(
          id: 'sales',
          title: 'Sales Reports',
          subtitle: 'Revenue performance',
          icon: Icons.trending_up_rounded,
        ),
        DepartmentPageMeta(
          id: 'marketing',
          title: 'Marketing Reports',
          subtitle: 'Outreach performance',
          icon: Icons.campaign_rounded,
        ),
        DepartmentPageMeta(
          id: 'production',
          title: 'Production Reports',
          subtitle: 'Output metrics',
          icon: Icons.precision_manufacturing_rounded,
        ),
        DepartmentPageMeta(
          id: 'warehouse',
          title: 'Warehouse Reports',
          subtitle: 'Operational KPIs',
          icon: Icons.warehouse_rounded,
        ),
        DepartmentPageMeta(
          id: 'logistics',
          title: 'Logistics Reports',
          subtitle: 'Network analysis',
          icon: Icons.local_shipping_rounded,
        ),
      ],
    ),
  };

  static DepartmentMeta of(RoleId id) => all[id]!;

  /// Active gameplay roles (excludes the observer Chairman).
  static List<RoleId> get gameplayRoles => RoleId.values
      .where((r) => r != RoleId.chairman)
      .toList(growable: false);
}
