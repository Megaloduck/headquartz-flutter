// lib/screens/logistics/logistics_screen.dart
import 'package:flutter/material.dart';
import '../../app.dart';
import '../../widgets/role_shell.dart';
import '../../widgets/shared_widgets.dart';

const Color _logColor = Color(0xFFEF9A9A);

// ═════════════════════════════════════════════
// LOGISTICS SCREEN — entry point
// ═════════════════════════════════════════════

class LogisticsScreen extends StatelessWidget {
  const LogisticsScreen({super.key});

  static Widget _resolve(DepartmentModule m) => switch (m.name) {
        'Logistics Dashboard' => const LogisticsDashboardPage(),
        'Shipments'           => const ShipmentsPage(),
        'Delivery Tracking'   => const DeliveryTrackingPage(),
        'Route Planner'       => const RoutePlannerPage(),
        'SLA Management'      => const SlaManagementPage(),
        'Fleet Management'    => const FleetManagementPage(),
        'Logistics Reports'   => const LogisticsReportsPage(),
        _ => ModulePage(
            moduleName: m.name,
            departmentName: 'Logistics',
            subtitle: m.subtitle,
            color: _logColor),
      };

  @override
  Widget build(BuildContext context) {
    final dept = departments.firstWhere((d) => d.name == 'Logistics');
    return RoleShell(department: dept, moduleResolver: _resolve);
  }
}

// ─────────────────────────────────────────────
// LOGISTICS DASHBOARD
// ─────────────────────────────────────────────

class LogisticsDashboardPage extends StatelessWidget {
  const LogisticsDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'Logistics Dashboard',
      department: 'Logistics',
      color: _logColor,
      children: [
        StatsGrid(cards: const [
          StatCard(label: 'Active Shipments', value: '84',    icon: Icons.local_shipping_rounded,  color: _logColor,    trend: '+12'),
          StatCard(label: 'On-Time Rate',     value: '94%',   icon: Icons.timer_rounded,            color: Colors.green, trend: '+2%'),
          StatCard(label: 'Delayed',          value: '5',     icon: Icons.warning_rounded,          color: Colors.orange),
          StatCard(label: 'Fleet Active',     value: '18/22', icon: Icons.directions_car_rounded,   color: Colors.blue),
        ]),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Shipment Map View'),
        const SizedBox(height: 8),
        const ChartPlaceholder(title: 'Live Shipment Tracker', color: _logColor, height: 200),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Recent Shipments', actionLabel: 'View All'),
        const SizedBox(height: 8),
        const DataRowTile(title: 'SHP-8821 — Acme Corp',    subtitle: 'In Transit • ETA: Jun 4', trailing: 'On Time',   accentColor: _logColor, leadingIcon: Icons.local_shipping_rounded, statusColor: Colors.green),
        const DataRowTile(title: 'SHP-8820 — Nexus Trade',  subtitle: 'Delayed • Weather hold',  trailing: 'Delayed',   accentColor: _logColor, leadingIcon: Icons.local_shipping_rounded, statusColor: Colors.orange),
        const DataRowTile(title: 'SHP-8819 — Summit Group', subtitle: 'Delivered • Jun 2',        trailing: 'Delivered', accentColor: _logColor, leadingIcon: Icons.local_shipping_rounded, statusColor: Colors.green),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// SHIPMENTS
// ─────────────────────────────────────────────

class ShipmentsPage extends StatelessWidget {
  const ShipmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'Shipments',
      department: 'Logistics',
      color: _logColor,
      children: [
        StatsGrid(cards: const [
          StatCard(label: 'Total Shipments', value: '2,841', icon: Icons.inventory_2_rounded,   color: _logColor),
          StatCard(label: 'In Transit',      value: '84',    icon: Icons.local_shipping_rounded, color: Colors.blue),
          StatCard(label: 'Delivered',       value: '2,742', icon: Icons.check_circle_rounded,  color: Colors.green),
          StatCard(label: 'Failed',          value: '15',    icon: Icons.cancel_rounded,        color: Colors.red),
        ]),
        const SizedBox(height: 20),
        const HqSearchField(hint: 'Search shipments...'),
        const SizedBox(height: 16),
        const SectionHeader(title: 'Active Shipments'),
        const SizedBox(height: 8),
        const DataRowTile(title: 'SHP-8821', subtitle: 'Acme Corp • 200 units • Truck 04',   trailing: 'In Transit', accentColor: _logColor, leadingIcon: Icons.local_shipping_rounded, statusColor: Colors.blue),
        const DataRowTile(title: 'SHP-8820', subtitle: 'Nexus Trade • 80 units • Truck 07',  trailing: 'Delayed',    accentColor: _logColor, leadingIcon: Icons.local_shipping_rounded, statusColor: Colors.orange),
        const DataRowTile(title: 'SHP-8818', subtitle: 'BrightRetail • 40 units • Van 02',   trailing: 'In Transit', accentColor: _logColor, leadingIcon: Icons.local_shipping_rounded, statusColor: Colors.blue),
        const SizedBox(height: 20),
        const ChartPlaceholder(title: 'Shipment Volume by Month', color: _logColor),
      ],
      fab: FloatingActionButton.extended(
        backgroundColor: _logColor,
        foregroundColor: Colors.white,
        onPressed: () {},
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Shipment'),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// DELIVERY TRACKING
// ─────────────────────────────────────────────

class DeliveryTrackingPage extends StatelessWidget {
  const DeliveryTrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'Delivery Tracking',
      department: 'Logistics',
      color: _logColor,
      children: [
        StatsGrid(cards: const [
          StatCard(label: 'Tracked Today',   value: '84',  icon: Icons.gps_fixed_rounded,    color: _logColor),
          StatCard(label: 'On Time',         value: '79',  icon: Icons.check_circle_rounded, color: Colors.green),
          StatCard(label: 'Delayed',         value: '5',   icon: Icons.timer_off_rounded,    color: Colors.orange),
          StatCard(label: 'Avg ETA Accuracy',value: '96%', icon: Icons.my_location_rounded,  color: Colors.blue),
        ]),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Live Tracking'),
        const SizedBox(height: 8),
        const ChartPlaceholder(title: 'Live Fleet Map', color: _logColor, height: 220),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Delivery Status'),
        const SizedBox(height: 8),
        const DataRowTile(title: 'SHP-8821 — Truck 04', subtitle: 'Acme Corp • 12km away • ETA 2:30pm', trailing: 'On Track', accentColor: _logColor, leadingIcon: Icons.location_on_rounded, statusColor: Colors.green),
        const DataRowTile(title: 'SHP-8820 — Truck 07', subtitle: 'Nexus Trade • Weather delay • +2hrs', trailing: 'Delayed',  accentColor: _logColor, leadingIcon: Icons.location_on_rounded, statusColor: Colors.orange),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// ROUTE PLANNER
// ─────────────────────────────────────────────

class RoutePlannerPage extends StatelessWidget {
  const RoutePlannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'Route Planner',
      department: 'Logistics',
      color: _logColor,
      children: [
        StatsGrid(cards: const [
          StatCard(label: 'Routes Today', value: '22',   icon: Icons.route_rounded,            color: _logColor),
          StatCard(label: 'Optimized',    value: '18',   icon: Icons.auto_fix_high_rounded,    color: Colors.green),
          StatCard(label: 'Avg Distance', value: '148km',icon: Icons.social_distance_rounded,  color: Colors.blue),
          StatCard(label: 'Fuel Saved',   value: '12%',  icon: Icons.local_gas_station_rounded,color: Colors.green, trend: '+12%'),
        ]),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Route Map'),
        const SizedBox(height: 8),
        const ChartPlaceholder(title: 'Optimized Delivery Routes', color: _logColor, height: 200),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Today\'s Routes', actionLabel: 'Plan Route'),
        const SizedBox(height: 8),
        const DataRowTile(title: 'Route A — North Region', subtitle: '4 stops • Truck 04 • 142km', trailing: 'Active',    accentColor: _logColor, leadingIcon: Icons.route_rounded, statusColor: Colors.green),
        const DataRowTile(title: 'Route B — South Region', subtitle: '6 stops • Truck 07 • 198km', trailing: 'Active',    accentColor: _logColor, leadingIcon: Icons.route_rounded, statusColor: Colors.blue),
        const DataRowTile(title: 'Route C — City Center',  subtitle: '8 stops • Van 02 • 64km',    trailing: 'Completed', accentColor: _logColor, leadingIcon: Icons.route_rounded, statusColor: Colors.green),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// SLA MANAGEMENT
// ─────────────────────────────────────────────

class SlaManagementPage extends StatelessWidget {
  const SlaManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'SLA Management',
      department: 'Logistics',
      color: _logColor,
      children: [
        StatsGrid(cards: const [
          StatCard(label: 'SLA Compliance', value: '96.2%', icon: Icons.verified_rounded,  color: Colors.green, trend: '+1.2%'),
          StatCard(label: 'Active SLAs',    value: '28',    icon: Icons.assignment_rounded, color: _logColor),
          StatCard(label: 'Breached',       value: '4',     icon: Icons.gavel_rounded,      color: Colors.red),
          StatCard(label: 'At Risk',        value: '7',     icon: Icons.warning_rounded,    color: Colors.orange),
        ]),
        const SizedBox(height: 20),
        const SectionHeader(title: 'SLA Overview'),
        const SizedBox(height: 8),
        const ChartPlaceholder(title: 'SLA Compliance Trend', color: _logColor),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Client SLAs', actionLabel: 'Add SLA'),
        const SizedBox(height: 8),
        const DataRowTile(title: 'Acme Corp — Next Day',      subtitle: 'Target: 99% • Current: 98.4%', trailing: 'Compliant', accentColor: _logColor, leadingIcon: Icons.business_rounded, statusColor: Colors.green),
        const DataRowTile(title: 'Nexus Trade — 2 Day',       subtitle: 'Target: 97% • Current: 94.1%', trailing: 'At Risk',   accentColor: _logColor, leadingIcon: Icons.business_rounded, statusColor: Colors.orange),
        const DataRowTile(title: 'BrightRetail — Same Day',   subtitle: 'Target: 95% • Current: 88%',   trailing: 'Breached',  accentColor: _logColor, leadingIcon: Icons.business_rounded, statusColor: Colors.red),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// FLEET MANAGEMENT
// ─────────────────────────────────────────────

class FleetManagementPage extends StatelessWidget {
  const FleetManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'Fleet Management',
      department: 'Logistics',
      color: _logColor,
      children: [
        StatsGrid(cards: const [
          StatCard(label: 'Total Fleet',   value: '22', icon: Icons.directions_car_rounded, color: _logColor),
          StatCard(label: 'Active',        value: '18', icon: Icons.check_circle_rounded,   color: Colors.green),
          StatCard(label: 'In Maintenance',value: '3',  icon: Icons.build_rounded,          color: Colors.orange),
          StatCard(label: 'Idle',          value: '1',  icon: Icons.pause_circle_rounded,   color: Colors.grey),
        ]),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Fleet Status', actionLabel: 'Add Vehicle'),
        const SizedBox(height: 8),
        const DataRowTile(title: 'Truck 04 — TRK-2041', subtitle: '142km today • Driver: Sam O.',    trailing: 'Active',      accentColor: _logColor, leadingIcon: Icons.local_shipping_rounded,    statusColor: Colors.green),
        const DataRowTile(title: 'Truck 07 — TRK-2044', subtitle: '198km today • Driver: J. Mwangi', trailing: 'Active',      accentColor: _logColor, leadingIcon: Icons.local_shipping_rounded,    statusColor: Colors.green),
        const DataRowTile(title: 'Van 02 — VAN-1012',   subtitle: 'In service bay • Est. 4hrs',       trailing: 'Maintenance', accentColor: _logColor, leadingIcon: Icons.airport_shuttle_rounded,  statusColor: Colors.orange),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Fleet Utilization'),
        const SizedBox(height: 8),
        const ChartPlaceholder(title: 'Fleet KM & Utilization', color: _logColor),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// LOGISTICS REPORTS
// ─────────────────────────────────────────────

class LogisticsReportsPage extends StatelessWidget {
  const LogisticsReportsPage({super.key});

  static const List<(String, String, IconData)> _reports = [
    ('Delivery Performance', 'On-time rate & delay analysis',    Icons.timer_rounded),
    ('Shipment Summary',     'Volume, weight & value by route',  Icons.local_shipping_rounded),
    ('Fleet Utilization',    'KM, fuel, cost per vehicle',       Icons.directions_car_rounded),
    ('SLA Compliance',       'Client SLA adherence report',      Icons.verified_rounded),
    ('Route Efficiency',     'Distance, time & fuel savings',    Icons.route_rounded),
    ('Cost per Delivery',    'Breakdown by region & client',     Icons.attach_money_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'Logistics Reports',
      department: 'Logistics',
      color: _logColor,
      children: [
        const SectionHeader(title: 'Available Reports'),
        const SizedBox(height: 12),
        ..._reports.map((r) => DataRowTile(
              title: r.$1, subtitle: r.$2, trailing: 'Export',
              accentColor: _logColor, leadingIcon: r.$3)),
        const SizedBox(height: 20),
        const ChartPlaceholder(title: 'Logistics KPI Overview', color: _logColor, height: 200),
      ],
    );
  }
}