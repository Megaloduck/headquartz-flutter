import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../bootstrap/dependency_injection.dart';
import '../../../../../core/simulation/engine/commands.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/spacing.dart';
import '../../../../../core/theme/typography.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../../../core/widgets/data_table.dart';
import '../../../../../core/widgets/glass_panel.dart';
import '../../../../../core/widgets/status_badge.dart';
import '../../../../../data/models/simulation/entities.dart';
import '../../../department_page_scaffold.dart';

// ─────────────────────────────────────────────────────────────────
// Accounts Payable
// ─────────────────────────────────────────────────────────────────
class FinanceAccountsPayablePage extends ConsumerWidget {
  const FinanceAccountsPayablePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(currentSessionProvider);
    if (session == null) return const SizedBox.shrink();
    final co = session.company;

    final invoices = [
      _Invoice('Raw Materials Co.', 18_400, 'Production'),
      _Invoice('Energy Provider', 6_200, 'Operations'),
      _Invoice('Software Licenses', 4_800, 'IT'),
      _Invoice('Logistics Partner', 9_300, 'Logistics'),
      _Invoice('Marketing Agency', 12_500, 'Marketing'),
    ];
    final total = invoices.fold<double>(0, (a, b) => a + b.amount);

    return DepartmentPageScaffold(
      title: 'Accounts Payable',
      subtitle: 'Funds expenditure · pending invoices',
      accent: AppColors.finance,
      icon: Icons.upload_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GlassPanel(
            padding: const EdgeInsets.all(Spacing.lg),
            child: Row(
              children: [
                _Stat(label: 'Outstanding', value: Fmt.currency(total)),
                const SizedBox(width: Spacing.huge),
                _Stat(
                    label: 'Available cash',
                    value: Fmt.currency(co.cash),
                    color: AppColors.finance),
                const SizedBox(width: Spacing.huge),
                _Stat(
                    label: 'After payment',
                    value: Fmt.currency(co.cash - total),
                    color: co.cash - total > 0
                        ? AppColors.success
                        : AppColors.danger),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: co.cash < total ? null : () {},
                  icon: const Icon(Icons.payments_rounded, size: 14),
                  label: const Text('PAY ALL'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.finance),
                ),
              ],
            ),
          ),
          const SizedBox(height: Spacing.lg),
          SectionTitle(text: 'Pending invoices', icon: Icons.receipt_rounded),
          HQDataTable(
            columns: const ['Vendor', 'Department', 'Amount', 'Status'],
            rows: [
              for (final inv in invoices)
                [
                  TableTextCell(inv.vendor),
                  TableTextCell(inv.dept,
                      color: AppColors.textSecondary),
                  TableTextCell(Fmt.currency(inv.amount), mono: true),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: StatusBadge(
                        label: 'PENDING', color: AppColors.warning),
                  ),
                ],
            ],
          ),
        ],
      ),
    );
  }
}

class _Invoice {
  const _Invoice(this.vendor, this.amount, this.dept);
  final String vendor;
  final double amount;
  final String dept;
}

// ─────────────────────────────────────────────────────────────────
// Accounts Receivable
// ─────────────────────────────────────────────────────────────────
class FinanceAccountsReceivablePage extends ConsumerWidget {
  const FinanceAccountsReceivablePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(currentSessionProvider);
    if (session == null) return const SizedBox.shrink();
    final co = session.company;

    final receivables = [
      ('Acme Corp', 24_000, OrderStatus.shipped),
      ('Globex', 18_400, OrderStatus.delivered),
      ('Initech', 9_200, OrderStatus.fulfilled),
      ('Soylent Green', 14_300, OrderStatus.shipped),
    ];
    final total = receivables.fold<double>(0, (a, b) => a + b.$2);

    return DepartmentPageScaffold(
      title: 'Accounts Receivable',
      subtitle: 'Funds earnings · invoices issued',
      accent: AppColors.finance,
      icon: Icons.download_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GlassPanel(
            padding: const EdgeInsets.all(Spacing.lg),
            child: Row(
              children: [
                _Stat(
                    label: 'Outstanding',
                    value: Fmt.currency(total),
                    color: AppColors.success),
                const SizedBox(width: Spacing.huge),
                _Stat(
                    label: 'Latest revenue',
                    value: Fmt.currency(co.unitPrice * co.demandPerTick * 60)),
                const SizedBox(width: Spacing.huge),
                _Stat(
                    label: 'Aged > 30d',
                    value: Fmt.currency(0),
                    color: AppColors.danger),
              ],
            ),
          ),
          const SizedBox(height: Spacing.lg),
          SectionTitle(
              text: 'Open receivables', icon: Icons.receipt_long_rounded),
          HQDataTable(
            columns: const ['Client', 'Amount', 'Stage', ''],
            rows: [
              for (final r in receivables)
                [
                  TableTextCell(r.$1),
                  TableTextCell(Fmt.currency(r.$2), mono: true),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: StatusBadge(
                      label: r.$3.name.toUpperCase(),
                      color: r.$3 == OrderStatus.delivered
                          ? AppColors.success
                          : AppColors.info,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text('REMIND'),
                    ),
                  ),
                ],
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// Loans
// ─────────────────────────────────────────────────────────────────
class FinanceLoansPage extends ConsumerStatefulWidget {
  const FinanceLoansPage({super.key});

  @override
  ConsumerState<FinanceLoansPage> createState() => _FinanceLoansPageState();
}

class _FinanceLoansPageState extends ConsumerState<FinanceLoansPage> {
  double _amount = 100_000;

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(currentSessionProvider);
    final me = ref.watch(localPlayerProvider);
    if (session == null || me == null) return const SizedBox.shrink();
    final co = session.company;

    return DepartmentPageScaffold(
      title: 'Loans',
      subtitle: 'Debt management · borrow / repay',
      accent: AppColors.finance,
      icon: Icons.handshake_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: GlassPanel(
                  padding: const EdgeInsets.all(Spacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PanelHeader(
                          title: 'Outstanding debt',
                          icon: Icons.receipt_long_rounded,
                          accent: AppColors.danger),
                      Text(Fmt.currency(co.debt),
                          style: AppTypography.kpiHero
                              .copyWith(color: AppColors.danger)),
                      const SizedBox(height: Spacing.sm),
                      Text(
                          'Effective rate: ${Fmt.percent(_estRate(co.debt, co.equity))}',
                          style: AppTypography.bodySmall),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: Spacing.lg),
              Expanded(
                flex: 2,
                child: GlassPanel(
                  padding: const EdgeInsets.all(Spacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      PanelHeader(
                          title: 'New action',
                          icon: Icons.tune_rounded,
                          accent: AppColors.finance),
                      Row(
                        children: [
                          Expanded(
                            child: Slider(
                              value: _amount,
                              min: 10_000,
                              max: 1_000_000,
                              divisions: 99,
                              activeColor: AppColors.finance,
                              label: Fmt.currency(_amount),
                              onChanged: (v) => setState(() => _amount = v),
                            ),
                          ),
                          SizedBox(
                            width: 120,
                            child: Text(Fmt.currency(_amount),
                                style: AppTypography.kpiValue,
                                textAlign: TextAlign.right),
                          ),
                        ],
                      ),
                      const SizedBox(height: Spacing.md),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.add_rounded, size: 14),
                              label: const Text('TAKE LOAN'),
                              onPressed: () {
                                ref.read(commandDispatcherProvider).send(
                                      TakeLoanCommand(
                                          issuedBy: me.id,
                                          principal: _amount),
                                    );
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.finance),
                            ),
                          ),
                          const SizedBox(width: Spacing.md),
                          Expanded(
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.remove_rounded, size: 14),
                              label: const Text('REPAY'),
                              onPressed: co.debt <= 0
                                  ? null
                                  : () {
                                      ref.read(commandDispatcherProvider).send(
                                            RepayLoanCommand(
                                                issuedBy: me.id,
                                                amount: _amount.clamp(
                                                    0, co.debt)),
                                          );
                                    },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  double _estRate(double debt, double equity) {
    final ratio = equity == 0 ? double.infinity : debt / equity;
    if (ratio < 0.5) return 0.04;
    if (ratio < 1.0) return 0.07;
    if (ratio < 2.0) return 0.10;
    return 0.14;
  }
}

// ─────────────────────────────────────────────────────────────────
// Budget Allocation
// ─────────────────────────────────────────────────────────────────
class FinanceBudgetAllocationPage extends ConsumerWidget {
  const FinanceBudgetAllocationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(currentSessionProvider);
    if (session == null) return const SizedBox.shrink();
    final co = session.company;

    final entries = [
      ('HR', AppColors.hr, 0.12),
      ('Sales', AppColors.sales, 0.18),
      ('Marketing', AppColors.marketing, 0.15),
      ('Production', AppColors.production, 0.22),
      ('Warehouse', AppColors.warehouse, 0.10),
      ('Logistics', AppColors.logistics, 0.13),
      ('Reserve', AppColors.textSecondary, 0.10),
    ];

    return DepartmentPageScaffold(
      title: 'Budget Allocation',
      subtitle: 'Spending limits · per-department envelope',
      accent: AppColors.finance,
      icon: Icons.pie_chart_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GlassPanel(
            padding: const EdgeInsets.all(Spacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PanelHeader(
                    title:
                        'Operating budget · ${Fmt.currency(co.cash * 0.4)}',
                    icon: Icons.savings_rounded,
                    accent: AppColors.finance),
                const SizedBox(height: Spacing.sm),
                ClipRRect(
                  borderRadius: BorderRadius.circular(Spacing.radiusSm),
                  child: SizedBox(
                    height: 12,
                    child: Row(
                      children: [
                        for (final e in entries)
                          Expanded(
                            flex: (e.$3 * 100).round(),
                            child: Container(color: e.$2),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: Spacing.md),
                Wrap(
                  spacing: Spacing.lg,
                  runSpacing: Spacing.sm,
                  children: [
                    for (final e in entries)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                  color: e.$2, shape: BoxShape.circle)),
                          const SizedBox(width: 6),
                          Text(
                              '${e.$1}  ${Fmt.percent(e.$3, fractionDigits: 0)}',
                              style: AppTypography.caption),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// Audits
// ─────────────────────────────────────────────────────────────────
class FinanceAuditsPage extends ConsumerWidget {
  const FinanceAuditsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(currentSessionProvider);
    if (session == null) return const SizedBox.shrink();
    final co = session.company;
    final monthlyRev = co.unitPrice * co.demandPerTick * 60 * 24 * 30;
    final monthlyExp = co.employees * 250 * 60 * 24 * 30 +
        (co.productionRatePerTick * 35 * 60 * 24 * 30);
    final monthlyProfit = monthlyRev - monthlyExp;

    return DepartmentPageScaffold(
      title: 'Audits',
      subtitle: 'Fiscal integrity · P&L snapshot',
      accent: AppColors.finance,
      icon: Icons.fact_check_rounded,
      child: Column(
        children: [
          PanelGrid(
            minWidth: 240,
            aspectRatio: 1.4,
            children: [
              _StatPanel(
                label: 'Revenue (est.)',
                value: Fmt.currency(monthlyRev),
                accent: AppColors.success,
              ),
              _StatPanel(
                label: 'Expenses (est.)',
                value: Fmt.currency(monthlyExp),
                accent: AppColors.warning,
              ),
              _StatPanel(
                label: 'Net profit',
                value: Fmt.currency(monthlyProfit),
                accent: monthlyProfit >= 0
                    ? AppColors.success
                    : AppColors.danger,
              ),
              _StatPanel(
                label: 'Margin',
                value: Fmt.percent(
                    monthlyRev == 0 ? 0 : monthlyProfit / monthlyRev),
                accent: AppColors.info,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// Reports
// ─────────────────────────────────────────────────────────────────
class FinanceReportsPage extends ConsumerWidget {
  const FinanceReportsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(currentSessionProvider);
    if (session == null) return const SizedBox.shrink();

    return DepartmentPageScaffold(
      title: 'Finance Reports',
      subtitle: 'Fiscal performance · KPIs',
      accent: AppColors.finance,
      icon: Icons.summarize_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final k in session.company.kpis)
            Padding(
              padding: const EdgeInsets.only(bottom: Spacing.sm),
              child: GlassPanel(
                padding: const EdgeInsets.all(Spacing.md),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(k.label, style: AppTypography.body),
                    ),
                    Text(
                      _formatKpi(k),
                      style: AppTypography.tableCellMono.copyWith(
                          color: AppColors.finance,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatKpi(dynamic k) {
    switch (k.unit) {
      case '\$':
        return Fmt.currencyCompact(k.value);
      case 'u':
        return Fmt.integer(k.value);
      default:
        return Fmt.decimal(k.value);
    }
  }
}

// ─────────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────────
class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value, this.color});
  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label.toUpperCase(), style: AppTypography.kpiLabel),
        Text(value,
            style: AppTypography.kpiValue
                .copyWith(color: color ?? AppColors.textPrimary)),
      ],
    );
  }
}

class _StatPanel extends StatelessWidget {
  const _StatPanel({
    required this.label,
    required this.value,
    required this.accent,
  });
  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.all(Spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label.toUpperCase(),
              style: AppTypography.kpiLabel),
          const SizedBox(height: Spacing.xs),
          Text(value,
              style: AppTypography.kpiHero.copyWith(color: accent)),
        ],
      ),
    );
  }
}
