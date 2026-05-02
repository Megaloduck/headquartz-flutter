// lib/screens/warehouse/warehouse_screen.dart
import 'package:flutter/material.dart';
import '../../app.dart';
import '../../widgets/role_shell.dart';
import '../../widgets/shared_widgets.dart';

const Color _whColor = Color(0xFF90CAF9);

// ═════════════════════════════════════════════
// WAREHOUSE SCREEN — entry point
// ═════════════════════════════════════════════

class WarehouseScreen extends StatelessWidget {
  const WarehouseScreen({super.key});

  static Widget _resolve(DepartmentModule m) => switch (m.name) {
        'Warehouse Dashboard'  => const WarehouseDashboardPage(),
        'Inventory Management' => const InventoryManagementPage(),
        'Stock In'             => const StockInPage(),
        'Stock Out'            => const StockOutPage(),
        'Flow Management'      => const FlowManagementPage(),
        'Storage Allocation'   => const StorageAllocationPage(),
        'Warehouse Reports'    => const WarehouseReportsPage(),
        _ => ModulePage(
            moduleName: m.name,
            departmentName: 'Warehouse',
            subtitle: m.subtitle,
            color: _whColor),
      };

  @override
  Widget build(BuildContext context) {
    final dept = departments.firstWhere((d) => d.name == 'Warehouse');
    return RoleShell(department: dept, moduleResolver: _resolve);
  }
}

// ─────────────────────────────────────────────
// WAREHOUSE DASHBOARD
// ─────────────────────────────────────────────

class WarehouseDashboardPage extends StatelessWidget {
  const WarehouseDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'Warehouse Dashboard',
      department: 'Warehouse',
      color: _whColor,
      children: [
        StatsGrid(cards: const [
          StatCard(label: 'Total SKUs',     value: '4,820', icon: Icons.inventory_2_rounded,    color: _whColor),
          StatCard(label: 'Capacity Used',  value: '74%',   icon: Icons.warehouse_rounded,       color: Colors.orange, trend: '+3%', trendUp: false),
          StatCard(label: 'Stock-In Today', value: '284',   icon: Icons.arrow_downward_rounded,  color: Colors.green),
          StatCard(label: 'Stock-Out Today',value: '198',   icon: Icons.arrow_upward_rounded,    color: Colors.blue),
        ]),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Inventory Overview'),
        const SizedBox(height: 8),
        const ChartPlaceholder(title: 'Stock Levels by Category', color: _whColor, height: 180),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Alerts', actionLabel: 'View All'),
        const SizedBox(height: 8),
        const DataRowTile(title: 'Low Stock — Product X',  subtitle: 'Zone A • 12 units remaining', trailing: 'Reorder', accentColor: Colors.orange, leadingIcon: Icons.warning_amber_rounded, statusColor: Colors.orange),
        const DataRowTile(title: 'Overstock — Product Y',  subtitle: 'Zone B • 2,400 units',        trailing: 'Review',  accentColor: Colors.blue,   leadingIcon: Icons.info_rounded,         statusColor: Colors.blue),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// INVENTORY MANAGEMENT
// ─────────────────────────────────────────────

class InventoryManagementPage extends StatelessWidget {
  const InventoryManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'Inventory Management',
      department: 'Warehouse',
      color: _whColor,
      children: [
        StatsGrid(cards: const [
          StatCard(label: 'Total SKUs',      value: '4,820', icon: Icons.inventory_2_rounded,              color: _whColor),
          StatCard(label: 'Low Stock Items', value: '24',    icon: Icons.warning_rounded,                  color: Colors.orange),
          StatCard(label: 'Out of Stock',    value: '6',     icon: Icons.remove_shopping_cart_rounded,     color: Colors.red),
          StatCard(label: 'Overstock',       value: '18',    icon: Icons.add_shopping_cart_rounded,        color: Colors.blue),
        ]),
        const SizedBox(height: 20),
        const HqSearchField(hint: 'Search inventory...'),
        const SizedBox(height: 16),
        const SectionHeader(title: 'Inventory List'),
        const SizedBox(height: 8),
        const DataRowTile(title: 'Product A — SKU-0041', subtitle: 'Zone A, Shelf 4 • Reorder: 50',  trailing: '284 units', accentColor: _whColor, leadingIcon: Icons.qr_code_rounded, statusColor: Colors.green),
        const DataRowTile(title: 'Product B — SKU-0042', subtitle: 'Zone B, Shelf 2 • Reorder: 100', trailing: '12 units',  accentColor: _whColor, leadingIcon: Icons.qr_code_rounded, statusColor: Colors.orange),
        const DataRowTile(title: 'Product C — SKU-0043', subtitle: 'Zone A, Shelf 1 • Reorder: 50',  trailing: '0 units',   accentColor: _whColor, leadingIcon: Icons.qr_code_rounded, statusColor: Colors.red),
        const SizedBox(height: 20),
        const ChartPlaceholder(title: 'Stock Movement Trend', color: _whColor),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// STOCK IN
// ─────────────────────────────────────────────

class StockInPage extends StatelessWidget {
  const StockInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'Stock In',
      department: 'Warehouse',
      color: _whColor,
      children: [
        StatsGrid(cards: const [
          StatCard(label: 'Today\'s Receipts', value: '8',     icon: Icons.receipt_rounded,        color: _whColor),
          StatCard(label: 'Units Received',    value: '1,284', icon: Icons.arrow_downward_rounded, color: Colors.green),
          StatCard(label: 'Pending POs',       value: '5',     icon: Icons.hourglass_top_rounded,  color: Colors.orange),
          StatCard(label: 'Rejected',          value: '2',     icon: Icons.cancel_rounded,         color: Colors.red),
        ]),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Recent Receipts', actionLabel: 'Record Receipt'),
        const SizedBox(height: 8),
        const DataRowTile(title: 'GRN-0821', subtitle: 'Raw Materials Ltd • Jun 2',      trailing: '400 units', accentColor: _whColor, leadingIcon: Icons.move_to_inbox_rounded, statusColor: Colors.green),
        const DataRowTile(title: 'GRN-0820', subtitle: 'Parts Supplier Co • Jun 2',      trailing: '200 units', accentColor: _whColor, leadingIcon: Icons.move_to_inbox_rounded, statusColor: Colors.green),
        const DataRowTile(title: 'GRN-0819', subtitle: 'Packaging Inc • Jun 1 • Partial',trailing: '180/300',   accentColor: _whColor, leadingIcon: Icons.move_to_inbox_rounded, statusColor: Colors.orange),
        const SizedBox(height: 20),
        const ChartPlaceholder(title: 'Daily Stock-In Volume', color: _whColor),
      ],
      fab: FloatingActionButton.extended(
        backgroundColor: _whColor,
        foregroundColor: Colors.black87,
        onPressed: () {},
        icon: const Icon(Icons.add_rounded),
        label: const Text('Record Receipt'),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// STOCK OUT
// ─────────────────────────────────────────────

class StockOutPage extends StatelessWidget {
  const StockOutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'Stock Out',
      department: 'Warehouse',
      color: _whColor,
      children: [
        StatsGrid(cards: const [
          StatCard(label: 'Dispatched Today', value: '14',  icon: Icons.local_shipping_rounded,    color: _whColor),
          StatCard(label: 'Units Dispatched', value: '842', icon: Icons.arrow_upward_rounded,      color: Colors.blue),
          StatCard(label: 'Pending Picks',    value: '7',   icon: Icons.shopping_basket_rounded,   color: Colors.orange),
          StatCard(label: 'Returns',          value: '3',   icon: Icons.assignment_return_rounded, color: Colors.red),
        ]),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Dispatch Orders', actionLabel: 'New Dispatch'),
        const SizedBox(height: 8),
        const DataRowTile(title: 'DO-1421', subtitle: 'Acme Corp • Jun 2 • 200 units',    trailing: 'Dispatched',  accentColor: _whColor, leadingIcon: Icons.outbox_rounded, statusColor: Colors.green),
        const DataRowTile(title: 'DO-1422', subtitle: 'Nexus Trade • Jun 2 • Picking',    trailing: 'In Progress', accentColor: _whColor, leadingIcon: Icons.outbox_rounded, statusColor: Colors.orange),
        const DataRowTile(title: 'DO-1423', subtitle: 'BrightRetail • Jun 3 • Pending',   trailing: 'Pending',     accentColor: _whColor, leadingIcon: Icons.outbox_rounded, statusColor: Colors.blue),
        const SizedBox(height: 20),
        const ChartPlaceholder(title: 'Daily Dispatch Volume', color: _whColor),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// FLOW MANAGEMENT
// ─────────────────────────────────────────────

class FlowManagementPage extends StatelessWidget {
  const FlowManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'Flow Management',
      department: 'Warehouse',
      color: _whColor,
      children: [
        StatsGrid(cards: const [
          StatCard(label: 'Daily Throughput', value: '2,126', icon: Icons.swap_horiz_rounded, color: _whColor),
          StatCard(label: 'Pick Rate',        value: '142/hr',icon: Icons.speed_rounded,       color: Colors.green),
          StatCard(label: 'Accuracy Rate',    value: '99.4%', icon: Icons.verified_rounded,    color: Colors.blue, trend: '+0.2%'),
          StatCard(label: 'Bottlenecks',      value: '2',     icon: Icons.warning_rounded,     color: Colors.orange),
        ]),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Warehouse Flow Map'),
        const SizedBox(height: 8),
        const ChartPlaceholder(title: 'Material Flow Heatmap', color: _whColor, height: 200),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Bottleneck Alerts'),
        const SizedBox(height: 8),
        const DataRowTile(title: 'Receiving Dock — Zone A', subtitle: 'Avg wait: 28 min • High volume', trailing: 'Active', accentColor: Colors.orange, leadingIcon: Icons.warning_rounded, statusColor: Colors.orange),
        const DataRowTile(title: 'Packing Station 3',       subtitle: 'Understaffed • 40% slower',     trailing: 'Active', accentColor: Colors.orange, leadingIcon: Icons.warning_rounded, statusColor: Colors.orange),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// STORAGE ALLOCATION
// ─────────────────────────────────────────────

class StorageAllocationPage extends StatelessWidget {
  const StorageAllocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'Storage Allocation',
      department: 'Warehouse',
      color: _whColor,
      children: [
        StatsGrid(cards: const [
          StatCard(label: 'Total Zones',  value: '6',     icon: Icons.grid_view_rounded,      color: _whColor),
          StatCard(label: 'Capacity Used',value: '74%',   icon: Icons.storage_rounded,        color: Colors.orange),
          StatCard(label: 'Free Slots',   value: '1,240', icon: Icons.space_dashboard_rounded,color: Colors.green),
          StatCard(label: 'Relocations',  value: '8',     icon: Icons.swap_vert_rounded,      color: Colors.blue),
        ]),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Zone Capacity'),
        const SizedBox(height: 8),
        const ChartPlaceholder(title: 'Warehouse Capacity Map', color: _whColor, height: 200),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Zone Details'),
        const SizedBox(height: 8),
        const DataRowTile(title: 'Zone A — Raw Materials', subtitle: '840/1000 slots used',  trailing: '84%', accentColor: _whColor, leadingIcon: Icons.grid_4x4_rounded, statusColor: Colors.orange),
        const DataRowTile(title: 'Zone B — Finished Goods',subtitle: '620/1000 slots used',  trailing: '62%', accentColor: _whColor, leadingIcon: Icons.grid_4x4_rounded, statusColor: Colors.green),
        const DataRowTile(title: 'Zone C — Packaging',     subtitle: '290/400 slots used',   trailing: '73%', accentColor: _whColor, leadingIcon: Icons.grid_4x4_rounded, statusColor: Colors.orange),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// WAREHOUSE REPORTS
// ─────────────────────────────────────────────

class WarehouseReportsPage extends StatelessWidget {
  const WarehouseReportsPage({super.key});

  static const List<(String, String, IconData)> _reports = [
    ('Inventory Valuation',    'Stock value by category & zone',  Icons.inventory_rounded),
    ('Stock Movement Report',  'In/out by SKU & date range',      Icons.swap_horiz_rounded),
    ('Capacity Utilization',   'Zone usage & forecasted fill',    Icons.warehouse_rounded),
    ('Aging Inventory',        'Items by days in stock',          Icons.schedule_rounded),
    ('Pick Accuracy Report',   'Error rate & root cause',         Icons.fact_check_rounded),
    ('Supplier Receipt Report','GRN summary by supplier',         Icons.local_shipping_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'Warehouse Reports',
      department: 'Warehouse',
      color: _whColor,
      children: [
        const SectionHeader(title: 'Available Reports'),
        const SizedBox(height: 12),
        ..._reports.map((r) => DataRowTile(
              title: r.$1, subtitle: r.$2, trailing: 'Export',
              accentColor: _whColor, leadingIcon: r.$3)),
        const SizedBox(height: 20),
        const ChartPlaceholder(title: 'Warehouse KPIs Overview', color: _whColor, height: 200),
      ],
    );
  }
}