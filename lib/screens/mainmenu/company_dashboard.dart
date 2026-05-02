// lib/screens/mainmenu/company_dashboard_page.dart
//
// Flutter port of CompanyDashboardPage.xaml
// Wired to Riverpod gameStateProvider for live data.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/game_state.dart';
import '../../core/theme/app_themes.dart';
import '../../providers/game_provider.dart';

class CompanyDashboardPage extends ConsumerWidget {
  const CompanyDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hq = context.hq;
    final stateAsync = ref.watch(gameStateProvider);

    return stateAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (state) => _DashboardContent(state: state),
    );
  }
}

// ─────────────────────────────────────────────
// Main content (stateless once we have GameState)
// ─────────────────────────────────────────────

class _DashboardContent extends StatelessWidget {
  final GameState state;
  const _DashboardContent({required this.state});

  @override
  Widget build(BuildContext context) {
    final hq = context.hq;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Page Header ──────────────────────────────────────────
          _PageHeader(state: state),
          const SizedBox(height: 20),

          // ── KPI Cards (4 columns) ────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _KpiCard(
                icon: '💰',
                iconBg: const Color(0xFFE8F4FF),
                title: 'Cash Position',
                value: _fmtCurrency(state.finance.cash),
                subtitle: 'Available funds',
                trailingValue: _fmtTrend(state.finance.netProfit),
                trailingColor: state.finance.netProfit >= 0
                    ? Colors.green
                    : Colors.red,
              )),
              const SizedBox(width: 16),
              Expanded(child: _KpiCard(
                icon: '📈',
                iconBg: const Color(0xFFE8F7FF),
                title: 'Revenue',
                value: _fmtCurrency(state.finance.totalRevenue),
                subtitle: 'This month',
                trailingValue: _fmtPct(state.sales.targetProgress),
                trailingColor: state.sales.targetProgress >= 0.8
                    ? Colors.green
                    : Colors.orange,
              )),
              const SizedBox(width: 16),
              Expanded(child: _KpiCard(
                icon: '⚡',
                iconBg: const Color(0xFFF0F7FF),
                title: 'Efficiency',
                value: _fmtPct(state.production.efficiency),
                subtitle: 'Overall efficiency',
                showProgress: true,
                progressValue: state.production.efficiency,
                progressColor: _efficiencyColor(state.production.efficiency),
              )),
              const SizedBox(width: 16),
              Expanded(child: _KpiCard(
                icon: '🌍',
                iconBg: const Color(0xFFF5F7FA),
                title: 'Market Share',
                value: '${state.marketing.marketSharePct.toStringAsFixed(1)}%',
                subtitle: 'Industry position',
                trailingValue: '+${(state.marketing.brandScore * 2).toStringAsFixed(1)}%',
                trailingColor: Colors.green,
              )),
            ],
          ),
          const SizedBox(height: 20),

          // ── Department Performance ───────────────────────────────
          _SectionCard(
            icon: '🏢',
            title: 'Department Performance',
            subtitle: 'Performance across business units',
            actionLabel: 'View Details →',
            child: Row(
              children: [
                Expanded(child: _DeptCard(
                  icon: '🛒',
                  iconBg: const Color(0xFFFFE8E8),
                  name: 'Sales',
                  value: state.sales.targetProgress,
                  valueLabel: _fmtPct(state.sales.targetProgress),
                  valueColor: _efficiencyColor(state.sales.targetProgress),
                  subLabel: '${_fmtPct(state.sales.targetProgress)} of target',
                )),
                const SizedBox(width: 16),
                Expanded(child: _DeptCard(
                  icon: '⚙️',
                  iconBg: const Color(0xFFE8F4FF),
                  name: 'Production',
                  value: state.production.efficiency,
                  valueLabel: _fmtPct(state.production.efficiency),
                  valueColor: _efficiencyColor(state.production.efficiency),
                  subLabel: '${state.production.totalUnitsProduced} units',
                )),
                const SizedBox(width: 16),
                Expanded(child: _DeptCard(
                  icon: '🚚',
                  iconBg: const Color(0xFFE8F7E8),
                  name: 'Logistics',
                  value: state.logistics.onTimeDeliveryRate,
                  valueLabel: _fmtPct(state.logistics.onTimeDeliveryRate),
                  valueColor: _efficiencyColor(state.logistics.onTimeDeliveryRate),
                  subLabel: '${_fmtPct(state.logistics.onTimeDeliveryRate)} on-time',
                )),
                const SizedBox(width: 16),
                Expanded(child: _DeptCard(
                  icon: '💵',
                  iconBg: const Color(0xFFFFF8E8),
                  name: 'Finance',
                  value: (state.finance.cash / 200000).clamp(0.0, 1.0),
                  valueLabel: _fmtCurrency(state.finance.cash),
                  valueColor: state.finance.cash > 0 ? Colors.green : Colors.red,
                  subLabel: 'Net: ${_fmtCurrency(state.finance.netProfit)}',
                )),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ── Inventory Status ─────────────────────────────────────
          _SectionCard(
            icon: '📦',
            title: 'Inventory Status',
            subtitle: 'Current warehouse and stock levels',
            actionLabel: 'View Details →',
            child: Column(
              children: [
                _InventoryRow(
                  label: 'Total Stock',
                  value: '${state.warehouse.totalStock} units',
                  isLarge: true,
                ),
                const SizedBox(height: 8),
                _InventoryRow(
                  label: 'Low Stock Alerts',
                  value: '${state.warehouse.lowStockCount}',
                  valueColor: state.warehouse.lowStockCount > 0
                      ? Colors.orange
                      : Colors.green,
                ),
                const SizedBox(height: 8),
                _InventoryRow(
                  label: 'Pending Orders',
                  value: '${state.sales.pendingOrders.length}',
                  valueColor: Colors.orange,
                ),
                const SizedBox(height: 8),
                _InventoryRow(
                  label: 'Stock Value',
                  value: _fmtCurrency(state.warehouse.products.fold<double>(
                      0, (s, p) => s + p.stock * p.unitPrice)),
                  isLarge: true,
                ),
                const SizedBox(height: 8),
                _InventoryRow(
                  label: 'Capacity Used',
                  value:
                      '${state.warehouse.usedCapacity.toStringAsFixed(0)} / ${state.warehouse.totalCapacity.toStringAsFixed(0)}',
                  valueColor: _efficiencyColor(
                      1 - state.warehouse.usedCapacity / state.warehouse.totalCapacity),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ── Quick Actions ────────────────────────────────────────
          _QuickActionsCard(),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────
  static String _fmtCurrency(double v) {
    if (v.abs() >= 1000000) return '\$${(v / 1000000).toStringAsFixed(2)}M';
    if (v.abs() >= 1000) return '\$${(v / 1000).toStringAsFixed(1)}K';
    return '\$${v.toStringAsFixed(0)}';
  }

  static String _fmtPct(double v) => '${(v * 100).toStringAsFixed(0)}%';

  static String _fmtTrend(double v) {
    final s = v >= 0 ? '+' : '';
    return '$s${_fmtCurrency(v)}';
  }

  static Color _efficiencyColor(double v) {
    if (v >= 0.75) return Colors.green;
    if (v >= 0.5) return Colors.orange;
    return Colors.red;
  }
}

// ─────────────────────────────────────────────
// Page Header
// ─────────────────────────────────────────────

class _PageHeader extends StatelessWidget {
  final GameState state;
  const _PageHeader({required this.state});

  @override
  Widget build(BuildContext context) {
    final hq = context.hq;
    final health = _companyHealth(state);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Company Dashboard',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: hq.primaryText)),
              const SizedBox(height: 4),
              Text(
                  'Complete overview of business operations and performance',
                  style: TextStyle(
                      fontSize: 14, color: hq.secondaryText)),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: hq.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: hq.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: health.$2,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(health.$1,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: hq.primaryText)),
            ],
          ),
        ),
      ],
    );
  }

  static (String, Color) _companyHealth(GameState s) {
    final score = (s.finance.cash > 0 ? 0.3 : 0.0) +
        s.production.efficiency * 0.25 +
        s.logistics.onTimeDeliveryRate * 0.25 +
        s.humanResource.moraleLevel * 0.2;
    if (score >= 0.75) return ('🟢 Excellent', Colors.green);
    if (score >= 0.5) return ('🟡 Good', Colors.amber);
    if (score >= 0.25) return ('🟠 Fair', Colors.orange);
    return ('🔴 Critical', Colors.red);
  }
}

// ─────────────────────────────────────────────
// KPI Card (top row)
// ─────────────────────────────────────────────

class _KpiCard extends StatelessWidget {
  final String icon;
  final Color iconBg;
  final String title;
  final String value;
  final String subtitle;
  final String? trailingValue;
  final Color? trailingColor;
  final bool showProgress;
  final double? progressValue;
  final Color? progressColor;

  const _KpiCard({
    required this.icon,
    required this.iconBg,
    required this.title,
    required this.value,
    required this.subtitle,
    this.trailingValue,
    this.trailingColor,
    this.showProgress = false,
    this.progressValue,
    this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    final hq = context.hq;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: hq.card,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: hq.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon + Title
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(icon, style: const TextStyle(fontSize: 16)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(title,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: hq.primaryText)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Big value
          Text(value,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: hq.primaryText)),
          const SizedBox(height: 8),
          // Footer row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(subtitle,
                  style: TextStyle(fontSize: 12, color: hq.secondaryText)),
              if (showProgress && progressValue != null)
                SizedBox(
                  width: 60,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: progressValue!.clamp(0.0, 1.0),
                      minHeight: 6,
                      backgroundColor: hq.border,
                      color: progressColor ?? Colors.blue,
                    ),
                  ),
                )
              else if (trailingValue != null)
                Text(trailingValue!,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: trailingColor ?? Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Section Card wrapper
// ─────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final String actionLabel;
  final Widget child;

  const _SectionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final hq = context.hq;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: hq.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: hq.border),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Section header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: kBrandAmber.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(icon, style: const TextStyle(fontSize: 20)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: hq.primaryText)),
                    Text(subtitle,
                        style: TextStyle(
                            fontSize: 12, color: hq.secondaryText)),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(actionLabel,
                    style: TextStyle(
                        fontSize: 12, color: kBrandAmber)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Department card (inside Department Performance)
// ─────────────────────────────────────────────

class _DeptCard extends StatelessWidget {
  final String icon;
  final Color iconBg;
  final String name;
  final double value;           // 0–1 for progress bar
  final String valueLabel;
  final Color valueColor;
  final String subLabel;

  const _DeptCard({
    required this.icon,
    required this.iconBg,
    required this.name,
    required this.value,
    required this.valueLabel,
    required this.valueColor,
    required this.subLabel,
  });

  @override
  Widget build(BuildContext context) {
    final hq = context.hq;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: hq.page,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: hq.border),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(icon, style: const TextStyle(fontSize: 16)),
          ),
          const SizedBox(height: 8),
          Text(name,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: hq.primaryText)),
          const SizedBox(height: 6),
          Text(valueLabel,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: valueColor)),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: value.clamp(0.0, 1.0),
              minHeight: 4,
              backgroundColor: hq.border,
              color: valueColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(subLabel,
              style: TextStyle(fontSize: 11, color: hq.secondaryText),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Inventory row
// ─────────────────────────────────────────────

class _InventoryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLarge;
  final Color? valueColor;

  const _InventoryRow({
    required this.label,
    required this.value,
    this.isLarge = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final hq = context.hq;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: isLarge ? 16 : 13,
                fontWeight:
                    isLarge ? FontWeight.w600 : FontWeight.normal,
                color: isLarge ? hq.primaryText : hq.secondaryText)),
        Text(value,
            style: TextStyle(
                fontSize: isLarge ? 20 : 14,
                fontWeight: FontWeight.w700,
                color: valueColor ?? hq.primaryText)),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Quick Actions (4 buttons)
// ─────────────────────────────────────────────

class _QuickActionsCard extends ConsumerWidget {
  const _QuickActionsCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hq = context.hq;
    final control = ref.read(simControlProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: hq.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: hq.border),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Quick Actions',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: hq.primaryText)),
          const SizedBox(height: 16),
          Row(
            children: [
              _QuickActionTile(
                emoji: '📦',
                label: 'Manage Products',
                onTap: () {},
              ),
              const SizedBox(width: 12),
              _QuickActionTile(
                emoji: '📊',
                label: 'Financial Reports',
                onTap: () {},
              ),
              const SizedBox(width: 12),
              _QuickActionTile(
                emoji: '👥',
                label: 'Team Management',
                onTap: () {},
              ),
              const SizedBox(width: 12),
              _QuickActionTile(
                emoji: '🎯',
                label: 'Strategy',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  final String emoji;
  final String label;
  final VoidCallback onTap;

  const _QuickActionTile({
    required this.emoji,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hq = context.hq;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: hq.page,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: hq.border),
          ),
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(height: 8),
              Text(label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 13, color: hq.primaryText)),
            ],
          ),
        ),
      ),
    );
  }
}