import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../bootstrap/dependency_injection.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/glass_panel.dart';
import '../../../core/widgets/kpi_card.dart';

/// Cross-department analytics summary. Can be embedded in a side
/// drawer, a dedicated screen, or a chairman view.
class ReportsPanel extends ConsumerWidget {
  const ReportsPanel({super.key, this.maxKpis = 6});
  final int maxKpis;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(currentSessionProvider);
    if (session == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final co = session.company;

    return Padding(
      padding: const EdgeInsets.all(Spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PanelHeader(
            title: 'Live company report',
            subtitle: '${co.name} · auto-refreshes per tick',
            icon: Icons.summarize_rounded,
            accent: AppColors.accent,
          ),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: Spacing.md,
            mainAxisSpacing: Spacing.md,
            childAspectRatio: 1.6,
            children: [
              for (final k in co.kpis.take(maxKpis))
                KpiCard(kpi: k, accent: AppColors.accent),
            ],
          ),
          const SizedBox(height: Spacing.lg),
          GlassPanel(
            padding: const EdgeInsets.all(Spacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('SUMMARY',
                    style: AppTypography.label),
                const SizedBox(height: Spacing.xs),
                Text(
                  'Cash ${Fmt.currency(co.cash)} · '
                  'Net worth ${Fmt.currency(co.netWorth)} · '
                  'Reputation ${co.reputation.round()} / 100. '
                  '${co.unitsInStock} units in stock at ${Fmt.currency(co.unitPrice)} each. '
                  '${co.employees} employees serving ~${Fmt.decimal(co.demandPerTick)} u/tick.',
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
