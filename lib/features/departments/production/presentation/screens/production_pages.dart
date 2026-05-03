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

class ProductionPages {
  ProductionPages._();

  static Widget byId(String id) {
    switch (id) {
      case 'dashboard':
        return const GenericDepartmentDashboard(
          role: RoleId.production,
          subtitle: 'Factory overview · production rate, stock, quality',
          kpiIds: ['production', 'stock', 'quality'],
        );
      case 'lines':
        return const _Lines();
      case 'workorder':
        return const _WorkOrder();
      default:
        return DepartmentPagePlaceholder(
            role: RoleId.production, pageId: id);
    }
  }
}

class _Lines extends ConsumerWidget {
  const _Lines();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(currentSessionProvider);
    final me = ref.watch(localPlayerProvider);
    if (session == null || me == null) return const SizedBox.shrink();
    final co = session.company;

    return DepartmentPageScaffold(
      title: 'Line Management',
      subtitle: 'Throughput · add capacity',
      accent: AppColors.production,
      icon: Icons.linear_scale_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GlassPanel(
            padding: const EdgeInsets.all(Spacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PanelHeader(
                    title: 'Throughput',
                    icon: Icons.speed_rounded,
                    accent: AppColors.production),
                Text('${Fmt.decimal(co.productionRatePerTick)} u/tick',
                    style: AppTypography.kpiHero
                        .copyWith(color: AppColors.production)),
                const SizedBox(height: Spacing.md),
                ElevatedButton.icon(
                  onPressed: co.cash < 80_000
                      ? null
                      : () => ref
                          .read(commandDispatcherProvider)
                          .send(AddProductionLineCommand(issuedBy: me.id)),
                  icon: const Icon(Icons.add_rounded, size: 14),
                  label: const Text('ADD PRODUCTION LINE  ·  \$80,000'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.production),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkOrder extends ConsumerStatefulWidget {
  const _WorkOrder();

  @override
  ConsumerState<_WorkOrder> createState() => _WorkOrderState();
}

class _WorkOrderState extends ConsumerState<_WorkOrder> {
  int _units = 100;

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(currentSessionProvider);
    final me = ref.watch(localPlayerProvider);
    if (session == null || me == null) return const SizedBox.shrink();

    return DepartmentPageScaffold(
      title: 'Work Order',
      subtitle: 'Job tracking · open new order',
      accent: AppColors.production,
      icon: Icons.assignment_rounded,
      child: GlassPanel(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PanelHeader(
                title: 'New work order',
                icon: Icons.add_circle_outline_rounded,
                accent: AppColors.production),
            Row(
              children: [
                Text('UNITS', style: AppTypography.kpiLabel),
                Expanded(
                  child: Slider(
                    value: _units.toDouble(),
                    min: 10,
                    max: 1000,
                    divisions: 99,
                    activeColor: AppColors.production,
                    label: '$_units',
                    onChanged: (v) => setState(() => _units = v.round()),
                  ),
                ),
                Text('$_units', style: AppTypography.kpiValue),
              ],
            ),
            const SizedBox(height: Spacing.md),
            ElevatedButton.icon(
              onPressed: () => ref
                  .read(commandDispatcherProvider)
                  .send(OpenWorkOrderCommand(issuedBy: me.id, units: _units)),
              icon: const Icon(Icons.play_arrow_rounded, size: 14),
              label: const Text('OPEN'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.production),
            ),
          ],
        ),
      ),
    );
  }
}
