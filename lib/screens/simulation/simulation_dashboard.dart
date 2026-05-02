// lib/screens/simulation/simulation_dashboard.dart
//
// The main real-time game view.
// Shows all 7 department KPIs ticking live, sim clock, speed controls,
// and quick-action buttons so the CEO can immediately see the engine working.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/actions/game_actions.dart';
import '../../core/models/game_state.dart';
import '../../core/models/marketing.dart';
import '../../core/theme/app_themes.dart';
import '../../providers/game_provider.dart';

class SimulationDashboard extends ConsumerStatefulWidget {
  const SimulationDashboard({super.key});

  @override
  ConsumerState<SimulationDashboard> createState() => _SimulationDashboardState();
}

class _SimulationDashboardState extends ConsumerState<SimulationDashboard> {
  @override
  void initState() {
    super.initState();
    // Auto-start simulation when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(simControlProvider.notifier).start();
    });
  }

  @override
  Widget build(BuildContext context) {
    final hq = context.hq;
    final stateAsync = ref.watch(gameStateProvider);
    final controlState = ref.watch(simControlProvider);
    final controlNotifier = ref.read(simControlProvider.notifier);

    return Scaffold(
      backgroundColor: hq.page,
      appBar: AppBar(
        backgroundColor: kBrandAmber,
        foregroundColor: Colors.black87,
        title: stateAsync.when(
          data: (s) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Headquartz — Live Simulation',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              Text(
                _formatSimTime(s.simTime),
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w400),
              ),
            ],
          ),
          loading: () => const Text('Headquartz — Starting...'),
          error: (e, _) => const Text('Headquartz'),
        ),
        actions: [
          // Speed selector
          _SpeedSelector(
            speedMultiplier: controlState.speedMultiplier,
            onChanged: controlNotifier.setSpeed,
          ),
          const SizedBox(width: 8),
          // Pause / Resume
          IconButton(
            tooltip: controlState.isPaused ? 'Resume' : 'Pause',
            icon: Icon(controlState.isPaused
                ? Icons.play_arrow_rounded
                : Icons.pause_rounded),
            onPressed: () => controlState.isPaused
                ? controlNotifier.resume()
                : controlNotifier.pause(),
          ),
          // Stop
          IconButton(
            tooltip: 'Stop Simulation',
            icon: const Icon(Icons.stop_rounded),
            onPressed: () {
              controlNotifier.stop();
              Navigator.of(context).pop();
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: stateAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
        data: (state) => _DashboardBody(state: state),
      ),
    );
  }

  String _formatSimTime(DateTime t) =>
      '${t.year}-${_p(t.month)}-${_p(t.day)}  '
      '${_p(t.hour)}:${_p(t.minute)}:${_p(t.second)}';
  String _p(int n) => n.toString().padLeft(2, '0');
}

// ─────────────────────────────────────────────
// Dashboard Body
// ─────────────────────────────────────────────

class _DashboardBody extends ConsumerWidget {
  final GameState state;
  const _DashboardBody({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hq = context.hq;
    final control = ref.read(simControlProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Top KPI bar ────────────────────────────────────────────
          _TopKpiBar(state: state),
          const SizedBox(height: 16),

          // ── Department cards grid ──────────────────────────────────
          _SectionLabel(label: 'Department Status', hq: hq),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _DeptCard(
                title: 'Finance',
                color: const Color(0xFFFFD54F),
                icon: Icons.account_balance_rounded,
                lines: [
                  'Cash: \$${_fmt(state.finance.cash)}',
                  'Revenue: \$${_fmt(state.finance.totalRevenue)}',
                  'Expenses: \$${_fmt(state.finance.totalExpenses)}',
                  'Net Profit: \$${_fmt(state.finance.netProfit)}',
                ],
              ),
              _DeptCard(
                title: 'Human Resources',
                color: const Color(0xFF4DD0C4),
                icon: Icons.people_rounded,
                lines: [
                  'Employees: ${state.humanResource.employeeCount}',
                  'Morale: ${(state.humanResource.moraleLevel * 100).toStringAsFixed(1)}%',
                  'Productivity: ${(state.humanResource.productivityMultiplier * 100).toStringAsFixed(0)}%',
                  'Wage/tick: \$${state.humanResource.totalWagePerTick.toStringAsFixed(4)}',
                ],
              ),
              _DeptCard(
                title: 'Production',
                color: const Color(0xFFFF8A65),
                icon: Icons.factory_rounded,
                lines: [
                  'Machines: ${state.production.machines.length} '
                      '(${state.production.runningMachines.length} running)',
                  'Efficiency: ${(state.production.efficiency * 100).toStringAsFixed(1)}%',
                  'Quality: ${(state.production.qualityScore * 100).toStringAsFixed(1)}%',
                  'Units produced: ${state.production.totalUnitsProduced}',
                ],
              ),
              _DeptCard(
                title: 'Warehouse',
                color: const Color(0xFF90CAF9),
                icon: Icons.warehouse_rounded,
                lines: [
                  'Products: ${state.warehouse.products.length}',
                  'Total stock: ${state.warehouse.totalStock}',
                  'Low stock: ${state.warehouse.lowStockCount}',
                  'Capacity used: ${state.warehouse.usedCapacity.toStringAsFixed(0)}/${state.warehouse.totalCapacity.toStringAsFixed(0)}',
                ],
              ),
              _DeptCard(
                title: 'Sales',
                color: const Color(0xFFCE93D8),
                icon: Icons.storefront_rounded,
                lines: [
                  'Monthly target: \$${_fmt(state.sales.monthlyTarget)}',
                  'Monthly revenue: \$${_fmt(state.sales.monthlyRevenue)}',
                  'Progress: ${(state.sales.targetProgress * 100).toStringAsFixed(1)}%',
                  'Conversion rate: ${(state.sales.conversionRate * 100).toStringAsFixed(1)}%',
                ],
              ),
              _DeptCard(
                title: 'Marketing',
                color: const Color(0xFF80CBC4),
                icon: Icons.campaign_rounded,
                lines: [
                  'Brand score: ${(state.marketing.brandScore * 100).toStringAsFixed(1)}%',
                  'Active campaigns: ${state.marketing.activeCampaigns.length}',
                  'Market share: ${state.marketing.marketSharePct.toStringAsFixed(1)}%',
                  'Ad spend: \$${_fmt(state.marketing.totalAdSpend)}',
                ],
              ),
              _DeptCard(
                title: 'Logistics',
                color: const Color(0xFFEF9A9A),
                icon: Icons.local_shipping_rounded,
                lines: [
                  'In-transit: ${state.logistics.activeShipments.length}',
                  'Fleet: ${state.logistics.fleet.length} vehicles',
                  'On-time: ${(state.logistics.onTimeDeliveryRate * 100).toStringAsFixed(1)}%',
                  'SLA: ${(state.logistics.slaComplianceRate * 100).toStringAsFixed(1)}%',
                ],
              ),
              _DeptCard(
                title: 'Market',
                color: kBrandAmber,
                icon: Icons.trending_up_rounded,
                lines: [
                  'Demand: ${state.market.demand}/100',
                  'Price: \$${state.market.price.toStringAsFixed(2)}',
                  state.market.trendDescription,
                  'Price history: ${state.market.priceHistory.length} pts',
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ── Quick Actions ──────────────────────────────────────────
          _SectionLabel(label: 'Quick Actions', hq: hq),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _ActionButton(
                label: 'Hire Employee',
                icon: Icons.person_add_rounded,
                color: const Color(0xFF4DD0C4),
                onTap: () => control.dispatch(
                  (s) => GameActions.hireEmployee(s, wage: 3500),
                ),
              ),
              _ActionButton(
                label: 'Boost Morale',
                icon: Icons.celebration_rounded,
                color: const Color(0xFF4DD0C4),
                onTap: () => control.dispatch(
                  (s) => GameActions.boostMorale(s, cost: 2000),
                ),
              ),
              _ActionButton(
                label: 'Launch Campaign',
                icon: Icons.campaign_rounded,
                color: const Color(0xFF80CBC4),
                onTap: () => control.dispatch(
                  (s) => GameActions.launchCampaign(
                    s,
                    name: 'Flash Campaign',
                    channel: CampaignChannel.social,
                    budget: 3000,
                    demandBoost: 10,
                    durationTicks: 120,
                  ),
                ),
              ),
              _ActionButton(
                label: 'Raise Price +\$5',
                icon: Icons.price_change_rounded,
                color: kBrandAmber,
                onTap: () => control.dispatch(
                  (s) => GameActions.setPrice(s, newPrice: s.market.price + 5),
                ),
              ),
              _ActionButton(
                label: 'Lower Price -\$5',
                icon: Icons.discount_rounded,
                color: kBrandAmber,
                onTap: () => control.dispatch(
                  (s) => GameActions.setPrice(s, newPrice: s.market.price - 5),
                ),
              ),
              _ActionButton(
                label: 'Emergency Restock',
                icon: Icons.inventory_rounded,
                color: const Color(0xFF90CAF9),
                onTap: () {
                  final products = ref
                      .read(gameStateProvider)
                      .value?.warehouse
                      .products;
                  if (products == null || products.isEmpty) return;
                  control.dispatch(
                    (s) => GameActions.emergencyRestock(
                      s,
                      productId: products.first.id,
                      units: 100,
                      unitCost: products.first.unitPrice * 0.4,
                    ),
                  );
                },
              ),
              _ActionButton(
                label: 'Add Machine',
                icon: Icons.precision_manufacturing_rounded,
                color: const Color(0xFFFF8A65),
                onTap: () => control.dispatch(
                  (s) {
                    if (s.warehouse.products.isEmpty) return s;
                    return GameActions.addMachine(
                      s,
                      productId: s.warehouse.products.first.id,
                      machineName: 'Auto Machine',
                      cost: 15000,
                      outputRate: 6,
                    );
                  },
                ),
              ),
              _ActionButton(
                label: 'Take Loan \$50K',
                icon: Icons.account_balance_rounded,
                color: const Color(0xFFFFD54F),
                onTap: () => control.dispatch(
                  (s) => GameActions.takeLoan(s, amount: 50000),
                ),
              ),
              _ActionButton(
                label: 'Add Vehicle',
                icon: Icons.local_shipping_rounded,
                color: const Color(0xFFEF9A9A),
                onTap: () => control.dispatch(
                  (s) => GameActions.addVehicle(
                    s,
                    name: 'Truck ${s.logistics.fleet.length + 1}',
                    capacity: 120,
                    cost: 30000,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ── Product stock table ────────────────────────────────────
          _SectionLabel(label: 'Warehouse — Live Stock', hq: hq),
          const SizedBox(height: 8),
          ...state.warehouse.products.map((p) {
            final pct = (p.stock / state.warehouse.totalCapacity).clamp(0.0, 1.0);
            final isLow = p.stock <= p.reorderPoint;
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: hq.card,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: isLow ? Colors.orange : hq.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(p.name,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: hq.primaryText)),
                      Text(
                        '${p.stock} units  ·  \$${p.unitPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                            fontSize: 12, color: hq.secondaryText),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: pct,
                      minHeight: 6,
                      backgroundColor: hq.border,
                      color: isLow ? Colors.orange : const Color(0xFF90CAF9),
                    ),
                  ),
                  if (isLow)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text('⚠ Below reorder point (${p.reorderPoint})',
                          style: const TextStyle(
                              fontSize: 11, color: Colors.orange)),
                    ),
                ],
              ),
            );
          }),

          const SizedBox(height: 20),

          // ── Active shipments ───────────────────────────────────────
          _SectionLabel(label: 'Logistics — Active Shipments', hq: hq),
          const SizedBox(height: 8),
          if (state.logistics.activeShipments.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text('No shipments in transit.',
                  style: TextStyle(color: hq.secondaryText, fontSize: 13)),
            )
          else
            ...state.logistics.activeShipments.take(5).map((s) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: hq.card,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: hq.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.local_shipping_rounded,
                          size: 18, color: Color(0xFFEF9A9A)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(s.destination,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: hq.primaryText,
                                    fontSize: 13)),
                            Text(
                                '${s.carrier.name.toUpperCase()} · ETA: ${s.etaTicks} ticks',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: hq.secondaryText)),
                          ],
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: SizedBox(
                          width: 80,
                          child: LinearProgressIndicator(
                            value: s.deliveryProgress,
                            minHeight: 6,
                            backgroundColor: hq.border,
                            color: const Color(0xFFEF9A9A),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  static String _fmt(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(2)}M';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}K';
    return v.toStringAsFixed(0);
  }
}

// ─────────────────────────────────────────────
// Top KPI bar
// ─────────────────────────────────────────────

class _TopKpiBar extends StatelessWidget {
  final GameState state;
  const _TopKpiBar({required this.state});

  @override
  Widget build(BuildContext context) {
    final hq = context.hq;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: hq.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kBrandAmber.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _KpiChip(
              label: 'Cash',
              value: '\$${_fmt(state.finance.cash)}',
              color: const Color(0xFFFFD54F)),
          _KpiChip(
              label: 'Demand',
              value: '${state.market.demand}/100',
              color: kBrandAmber),
          _KpiChip(
              label: 'Employees',
              value: '${state.humanResource.employeeCount}',
              color: const Color(0xFF4DD0C4)),
          _KpiChip(
              label: 'Stock',
              value: '${state.warehouse.totalStock}',
              color: const Color(0xFF90CAF9)),
          _KpiChip(
              label: 'Brand',
              value:
                  '${(state.marketing.brandScore * 100).toStringAsFixed(0)}%',
              color: const Color(0xFF80CBC4)),
        ],
      ),
    );
  }

  static String _fmt(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(2)}M';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}K';
    return v.toStringAsFixed(0);
  }
}

class _KpiChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _KpiChip(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    final hq = context.hq;
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 16,
                color: color)),
        Text(label,
            style:
                TextStyle(fontSize: 10, color: hq.secondaryText)),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Department card
// ─────────────────────────────────────────────

class _DeptCard extends StatelessWidget {
  final String title;
  final Color color;
  final IconData icon;
  final List<String> lines;

  const _DeptCard({
    required this.title,
    required this.color,
    required this.icon,
    required this.lines,
  });

  @override
  Widget build(BuildContext context) {
    final hq = context.hq;
    final width = (MediaQuery.of(context).size.width - 44) / 2;
    return Container(
      width: width.clamp(160, 320),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: hq.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(title,
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: color)),
          ]),
          const SizedBox(height: 8),
          ...lines.map((l) => Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(l,
                    style: TextStyle(
                        fontSize: 12, color: hq.secondaryText)),
              )),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Action button
// ─────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16, color: color),
      label: Text(label,
          style: TextStyle(
              fontSize: 12, color: color, fontWeight: FontWeight.w600)),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color.withOpacity(0.6)),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Speed selector
// ─────────────────────────────────────────────

class _SpeedSelector extends StatelessWidget {
  final double speedMultiplier;
  final void Function(double) onChanged;
  const _SpeedSelector({required this.speedMultiplier, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<double>(
      value: speedMultiplier,
      dropdownColor: Colors.black87,
      underline: const SizedBox(),
      icon: const Icon(Icons.speed_rounded, color: Colors.black87, size: 18),
      items: const [
        DropdownMenuItem(value: 0.5, child: Text('0.5×', style: TextStyle(fontSize: 13))),
        DropdownMenuItem(value: 1.0, child: Text('1×', style: TextStyle(fontSize: 13))),
        DropdownMenuItem(value: 2.0, child: Text('2×', style: TextStyle(fontSize: 13))),
        DropdownMenuItem(value: 5.0, child: Text('5×', style: TextStyle(fontSize: 13))),
        DropdownMenuItem(value: 10.0, child: Text('10×', style: TextStyle(fontSize: 13))),
      ],
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
    );
  }
}

// ─────────────────────────────────────────────
// Section label helper
// ─────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  final dynamic hq;
  const _SectionLabel({required this.label, required this.hq});

  @override
  Widget build(BuildContext context) {
    return Text(label,
        style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 13,
            color: hq.secondaryText,
            letterSpacing: 0.5));
  }
}