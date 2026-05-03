import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../bootstrap/dependency_injection.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/spacing.dart';
import '../../../../../core/theme/typography.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../../../core/widgets/glass_panel.dart';
import '../../../../../core/widgets/kpi_card.dart';
import '../../../../../core/widgets/status_badge.dart';
import '../../../../../data/models/company/company.dart';
import '../../../../../data/models/company/kpi.dart';
import '../../../department_page_scaffold.dart';


class FinanceDashboardPage extends ConsumerWidget {
  const FinanceDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(currentSessionProvider);
    if (session == null) return const SizedBox.shrink();
    final co = session.company;

    Kpi kpi(String id, String label, double value, String unit) {
      final existing =
          co.kpis.where((k) => k.id == id).cast<Kpi?>().firstOrNull;
      return existing ??
          Kpi(id: id, label: label, value: value, unit: unit);
    }

    final cashKpi = kpi('cash', 'Cash', co.cash, '\$');
    final netWorthKpi = kpi('netWorth', 'Net Worth', co.netWorth, '\$');
    final revenueKpi = kpi(
        'revenue_per_unit', 'Revenue / Unit', co.unitPrice, '\$');
    final equityKpi =
        Kpi(id: 'equity', label: 'Equity', value: co.equity, unit: '\$');
    final debtKpi =
        Kpi(id: 'debt', label: 'Debt', value: co.debt, unit: '\$');
    final repKpi =
        kpi('reputation', 'Reputation', co.reputation, '');

    return DepartmentPageScaffold(
      title: 'Finance Dashboard',
      subtitle: 'Real-time financial health · cash, debt, equity, KPIs',
      accent: AppColors.finance,
      icon: Icons.dashboard_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top KPI strip
          PanelGrid(
            minWidth: 220,
            aspectRatio: 1.3,
            children: [
              KpiCard(kpi: cashKpi, accent: AppColors.finance),
              KpiCard(kpi: netWorthKpi, accent: AppColors.success),
              KpiCard(kpi: equityKpi, accent: AppColors.accent),
              KpiCard(kpi: debtKpi, accent: AppColors.danger),
              KpiCard(kpi: revenueKpi, accent: AppColors.warning),
              KpiCard(kpi: repKpi, accent: AppColors.info),
            ],
          ),
          const SizedBox(height: Spacing.lg),

          SectionTitle(
            text: 'Cash flow trend',
            icon: Icons.timeline_rounded,
            accent: AppColors.finance,
          ),
          GlassPanel(
            padding: const EdgeInsets.all(Spacing.lg),
            child: SizedBox(
              height: 220,
              child: _CashFlowChart(history: cashKpi.history),
            ),
          ),

          const SizedBox(height: Spacing.lg),
          SectionTitle(
            text: 'Balance sheet',
            icon: Icons.account_balance_wallet_rounded,
            accent: AppColors.finance,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _BalanceSheetCard(co: co)),
              const SizedBox(width: Spacing.md),
              Expanded(child: _LeverageCard(co: co)),
              const SizedBox(width: Spacing.md),
              Expanded(child: _SolvencyCard(co: co)),
            ],
          ),
        ],
      ),
    );
  }
}

class _CashFlowChart extends StatelessWidget {
  const _CashFlowChart({required this.history});
  final List<double> history;

  @override
  Widget build(BuildContext context) {
    if (history.length < 2) {
      return Center(
          child: Text('Collecting data…', style: AppTypography.caption));
    }
    final spots = [
      for (var i = 0; i < history.length; i++)
        FlSpot(i.toDouble(), history[i]),
    ];
    final minY = history.reduce((a, b) => a < b ? a : b);
    final maxY = history.reduce((a, b) => a > b ? a : b);
    final pad = (maxY - minY).abs() * 0.1 + 1;
    return LineChart(
      LineChartData(
        minY: minY - pad,
        maxY: maxY + pad,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (_) => const FlLine(
            color: AppColors.divider,
            strokeWidth: 0.5,
          ),
        ),
        borderData: FlBorderData(show: false),
        titlesData: const FlTitlesData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.3,
            color: AppColors.finance,
            barWidth: 1.6,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.finance.withValues(alpha: 0.30),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BalanceSheetCard extends StatelessWidget {
  const _BalanceSheetCard({required this.co});
  final Company co;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.all(Spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          PanelHeader(
            title: 'Balance sheet',
            icon: Icons.balance_rounded,
            accent: AppColors.finance,
          ),
          _Row(label: 'Cash', value: Fmt.currency(co.cash)),
          _Row(label: 'Equity', value: Fmt.currency(co.equity)),
          _Row(
              label: 'Debt',
              value: Fmt.currency(co.debt),
              valueColor:
                  co.debt > 0 ? AppColors.danger : AppColors.textPrimary),
          const Divider(height: Spacing.md),
          _Row(
              label: 'Net worth',
              value: Fmt.currency(co.netWorth),
              valueColor: co.netWorth >= 0
                  ? AppColors.success
                  : AppColors.danger,
              bold: true),
        ],
      ),
    );
  }
}

class _LeverageCard extends StatelessWidget {
  const _LeverageCard({required this.co});
  final Company co;

  @override
  Widget build(BuildContext context) {
    final ratio = co.equity == 0 ? 0.0 : co.debt / co.equity;
    final stress = ratio < 0.5
        ? 'LOW'
        : ratio < 1.0
            ? 'MODERATE'
            : ratio < 2.0
                ? 'HIGH'
                : 'CRITICAL';
    final color = ratio < 0.5
        ? AppColors.success
        : ratio < 1.0
            ? AppColors.info
            : ratio < 2.0
                ? AppColors.warning
                : AppColors.danger;
    return GlassPanel(
      padding: const EdgeInsets.all(Spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          PanelHeader(
              title: 'Leverage',
              icon: Icons.percent_rounded,
              accent: color),
          _Row(
              label: 'Debt / Equity',
              value: Fmt.decimal(ratio),
              valueColor: color),
          _Row(label: 'Stress', value: ''),
          const SizedBox(height: 4),
          StatusBadge(label: stress, color: color),
        ],
      ),
    );
  }
}

class _SolvencyCard extends StatelessWidget {
  const _SolvencyCard({required this.co});
  final Company co;

  @override
  Widget build(BuildContext context) {
    // Months of runway based on a rough payroll burn estimate.
    final monthlyBurn = (co.employees * 250 * 60 * 24).abs() + 1;
    final runway = co.cash <= 0 ? 0.0 : co.cash / monthlyBurn * 30; // days
    final ok = runway > 30;
    return GlassPanel(
      padding: const EdgeInsets.all(Spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          PanelHeader(
            title: 'Solvency',
            icon: Icons.water_drop_rounded,
            accent: ok ? AppColors.success : AppColors.warning,
          ),
          _Row(
              label: 'Runway',
              value: '${Fmt.integer(runway)} days',
              valueColor: ok ? AppColors.success : AppColors.warning),
          _Row(
              label: 'Headcount',
              value: Fmt.integer(co.employees.toDouble())),
          _Row(
              label: 'Quality',
              value: '${Fmt.decimal(co.qualityScore)} / 100'),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.label,
    required this.value,
    this.valueColor,
    this.bold = false,
  });
  final String label;
  final String value;
  final Color? valueColor;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodySmall),
          Text(
            value,
            style: AppTypography.tableCellMono.copyWith(
              color: valueColor ?? AppColors.textPrimary,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
