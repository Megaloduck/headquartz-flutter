import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../bootstrap/dependency_injection.dart';
import '../../../../../core/config/department_constants.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/spacing.dart';
import '../../../../../core/theme/typography.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../../../core/widgets/glass_panel.dart';
import '../../../../../core/widgets/kpi_card.dart';
import '../../../department_page_scaffold.dart';
import '../../../generic_dashboard.dart';

class ChairmanPages {
  ChairmanPages._();

  static Widget byId(String id) {
    switch (id) {
      case 'overview':
        return const _Overview();
      case 'hr':
      case 'finance':
      case 'sales':
      case 'marketing':
      case 'production':
      case 'warehouse':
      case 'logistics':
        return _ChairmanReportView(reportFor: id);
    }
    return DepartmentPagePlaceholder(role: RoleId.chairman, pageId: id);
  }
}

class _Overview extends ConsumerStatefulWidget {
  const _Overview();

  @override
  ConsumerState<_Overview> createState() => _OverviewState();
}

class _OverviewState extends ConsumerState<_Overview> {
  final _announceCtrl = TextEditingController();

  @override
  void dispose() {
    _announceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(currentSessionProvider);
    if (session == null) return const SizedBox.shrink();
    final co = session.company;

    return DepartmentPageScaffold(
      title: 'Company Overview',
      subtitle: 'Executive board view · all departments at a glance',
      accent: AppColors.chairman,
      icon: Icons.dashboard_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PanelGrid(
            minWidth: 220,
            aspectRatio: 1.3,
            children: [
              for (final k in co.kpis.take(8))
                KpiCard(kpi: k, accent: AppColors.chairman),
            ],
          ),
          const SizedBox(height: Spacing.lg),
          GlassPanel(
            padding: const EdgeInsets.all(Spacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PanelHeader(
                  title: 'Send announcement',
                  icon: Icons.campaign_rounded,
                  accent: AppColors.chairman,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _announceCtrl,
                        style: AppTypography.body,
                        decoration: const InputDecoration(
                          hintText:
                              'Address the entire company (visible to all)…',
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: Spacing.md),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.send_rounded, size: 14),
                      label: const Text('BROADCAST'),
                      onPressed: () {
                        final txt = _announceCtrl.text.trim();
                        if (txt.isEmpty) return;
                        ref
                            .read(lobbyActionsProvider)
                            .sendAnnouncement(txt);
                        _announceCtrl.clear();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.chairman),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: Spacing.lg),
          SectionTitle(text: 'Company snapshot'),
          GlassPanel(
            padding: const EdgeInsets.all(Spacing.lg),
            child: Wrap(
              spacing: Spacing.huge,
              runSpacing: Spacing.md,
              children: [
                _ChStat(label: 'Cash', value: Fmt.currency(co.cash)),
                _ChStat(
                    label: 'Net worth',
                    value: Fmt.currency(co.netWorth)),
                _ChStat(label: 'Debt', value: Fmt.currency(co.debt)),
                _ChStat(
                    label: 'Headcount',
                    value: Fmt.integer(co.employees.toDouble())),
                _ChStat(
                    label: 'Reputation',
                    value: '${co.reputation.round()} / 100'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChStat extends StatelessWidget {
  const _ChStat({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label.toUpperCase(),
            style: AppTypography.kpiLabel),
        Text(value,
            style: AppTypography.kpiValue
                .copyWith(color: AppColors.chairman)),
      ],
    );
  }
}

class _ChairmanReportView extends ConsumerWidget {
  const _ChairmanReportView({required this.reportFor});
  final String reportFor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(currentSessionProvider);
    if (session == null) return const SizedBox.shrink();
    final role = RoleId.tryParse(reportFor) ?? RoleId.finance;
    final dept = DepartmentConstants.of(role);

    return DepartmentPageScaffold(
      title: '${dept.title} Reports',
      subtitle: 'Read-only board view · synthesised from live state',
      accent: AppColors.chairman,
      icon: dept.icon,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PanelGrid(
            minWidth: 220,
            aspectRatio: 1.3,
            children: [
              for (final k in session.company.kpis)
                KpiCard(kpi: k, accent: dept.color),
            ],
          ),
        ],
      ),
    );
  }
}
