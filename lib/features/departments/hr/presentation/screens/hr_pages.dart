import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../bootstrap/dependency_injection.dart';
import '../../../../../core/config/department_constants.dart';
import '../../../../../core/simulation/engine/commands.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/spacing.dart';
import '../../../../../core/theme/typography.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../../../core/widgets/glass_panel.dart';
import '../../../department_page_scaffold.dart';
import '../../../generic_dashboard.dart';

class HrPages {
  HrPages._();

  static Widget byId(String id) {
    switch (id) {
      case 'dashboard':
        return const GenericDepartmentDashboard(
          role: RoleId.hr,
          subtitle: 'Workforce overview · headcount, morale, payroll',
          kpiIds: ['morale', 'reputation', 'cash'],
        );
      case 'recruitment':
        return const _Recruitment();
      case 'payroll':
        return const _Payroll();
      default:
        return DepartmentPagePlaceholder(role: RoleId.hr, pageId: id);
    }
  }
}

class _Recruitment extends ConsumerStatefulWidget {
  const _Recruitment();

  @override
  ConsumerState<_Recruitment> createState() => _RecruitmentState();
}

class _RecruitmentState extends ConsumerState<_Recruitment> {
  int _hireCount = 3;

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(currentSessionProvider);
    final me = ref.watch(localPlayerProvider);
    if (session == null || me == null) return const SizedBox.shrink();
    final co = session.company;
    final hireCost = _hireCount * 4000;

    return DepartmentPageScaffold(
      title: 'Recruitment',
      subtitle: 'Hiring & applicants',
      accent: AppColors.hr,
      icon: Icons.person_search_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GlassPanel(
            padding: const EdgeInsets.all(Spacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PanelHeader(
                    title: 'Open hiring action',
                    icon: Icons.add_business_rounded,
                    accent: AppColors.hr),
                Row(
                  children: [
                    Text('Hire',
                        style: AppTypography.bodySmall),
                    Expanded(
                      child: Slider(
                        value: _hireCount.toDouble(),
                        min: 1,
                        max: 30,
                        divisions: 29,
                        activeColor: AppColors.hr,
                        label: '$_hireCount',
                        onChanged: (v) =>
                            setState(() => _hireCount = v.round()),
                      ),
                    ),
                    SizedBox(
                      width: 64,
                      child: Text('$_hireCount',
                          style: AppTypography.kpiValue,
                          textAlign: TextAlign.right),
                    ),
                  ],
                ),
                const SizedBox(height: Spacing.sm),
                Row(
                  children: [
                    Text('Cost: ${Fmt.currency(hireCost)}',
                        style: AppTypography.bodySmall),
                    const Spacer(),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.person_add_rounded, size: 14),
                      label: const Text('HIRE'),
                      onPressed: co.cash < hireCost
                          ? null
                          : () => ref.read(commandDispatcherProvider).send(
                                HireEmployeesCommand(
                                    issuedBy: me.id, count: _hireCount),
                              ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.hr),
                    ),
                    const SizedBox(width: Spacing.sm),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.person_remove_rounded, size: 14),
                      label: const Text('LAY OFF'),
                      onPressed: () => ref
                          .read(commandDispatcherProvider)
                          .send(LayoffEmployeesCommand(
                              issuedBy: me.id, count: _hireCount)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: Spacing.lg),
          SectionTitle(text: 'Workforce', icon: Icons.groups_rounded),
          GlassPanel(
            padding: const EdgeInsets.all(Spacing.lg),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Headcount', style: AppTypography.bodySmall),
                    Text(Fmt.integer(co.employees.toDouble()),
                        style: AppTypography.kpiHero
                            .copyWith(color: AppColors.hr)),
                  ],
                ),
                const SizedBox(height: Spacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Morale', style: AppTypography.bodySmall),
                    Text('${co.morale.round()} / 100',
                        style: AppTypography.kpiValue
                            .copyWith(color: AppColors.hr)),
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

class _Payroll extends ConsumerWidget {
  const _Payroll();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(currentSessionProvider);
    final me = ref.watch(localPlayerProvider);
    if (session == null || me == null) return const SizedBox.shrink();
    final co = session.company;
    final hourlyBurn = co.employees * 250.0;

    return DepartmentPageScaffold(
      title: 'Payroll',
      subtitle: 'Compensation & pay',
      accent: AppColors.hr,
      icon: Icons.payments_rounded,
      child: Column(
        children: [
          GlassPanel(
            padding: const EdgeInsets.all(Spacing.lg),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('HOURLY BURN',
                          style: AppTypography.kpiLabel),
                      Text(Fmt.currency(hourlyBurn),
                          style: AppTypography.kpiHero
                              .copyWith(color: AppColors.hr)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('DAILY BURN',
                          style: AppTypography.kpiLabel),
                      Text(Fmt.currency(hourlyBurn * 24),
                          style: AppTypography.kpiHero
                              .copyWith(color: AppColors.warning)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Spacing.lg),
          GlassPanel(
            padding: const EdgeInsets.all(Spacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PanelHeader(
                    title: 'Salary adjustments',
                    icon: Icons.tune_rounded,
                    accent: AppColors.hr),
                Row(
                  children: [
                    OutlinedButton.icon(
                      icon: const Icon(Icons.remove_rounded, size: 12),
                      label: const Text('-5%'),
                      onPressed: () => ref
                          .read(commandDispatcherProvider)
                          .send(AdjustSalariesCommand(
                              issuedBy: me.id, deltaPct: -0.05)),
                    ),
                    const SizedBox(width: Spacing.sm),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.add_rounded, size: 12),
                      label: const Text('+5%'),
                      onPressed: () => ref
                          .read(commandDispatcherProvider)
                          .send(AdjustSalariesCommand(
                              issuedBy: me.id, deltaPct: 0.05)),
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
