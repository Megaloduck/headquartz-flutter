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

class LogisticsPages {
  LogisticsPages._();

  static Widget byId(String id) {
    switch (id) {
      case 'dashboard':
        return const GenericDepartmentDashboard(
          role: RoleId.logistics,
          subtitle: 'Supply chain · fleet & deliveries',
          kpiIds: ['stock', 'demand', 'cash'],
        );
      case 'fleet':
        return const _Fleet();
      default:
        return DepartmentPagePlaceholder(role: RoleId.logistics, pageId: id);
    }
  }
}

class _Fleet extends ConsumerStatefulWidget {
  const _Fleet();

  @override
  ConsumerState<_Fleet> createState() => _FleetState();
}

class _FleetState extends ConsumerState<_Fleet> {
  int _vehicles = 1;

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(currentSessionProvider);
    final me = ref.watch(localPlayerProvider);
    if (session == null || me == null) return const SizedBox.shrink();
    final co = session.company;
    final cost = _vehicles * 25_000;

    return DepartmentPageScaffold(
      title: 'Fleet Management',
      subtitle: 'Vehicle controls · purchase fleet',
      accent: AppColors.logistics,
      icon: Icons.directions_bus_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GlassPanel(
            padding: const EdgeInsets.all(Spacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PanelHeader(
                    title: 'Active fleet',
                    icon: Icons.local_shipping_rounded,
                    accent: AppColors.logistics),
                Text('${co.fleet} vehicles',
                    style: AppTypography.kpiHero
                        .copyWith(color: AppColors.logistics)),
                const SizedBox(height: Spacing.md),
                Row(
                  children: [
                    Text('PURCHASE',
                        style: AppTypography.kpiLabel),
                    Expanded(
                      child: Slider(
                        value: _vehicles.toDouble(),
                        min: 1,
                        max: 12,
                        divisions: 11,
                        activeColor: AppColors.logistics,
                        label: '$_vehicles',
                        onChanged: (v) =>
                            setState(() => _vehicles = v.round()),
                      ),
                    ),
                    Text('$_vehicles · ${Fmt.currency(cost)}',
                        style: AppTypography.kpiValue),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: co.cash < cost
                      ? null
                      : () => ref
                          .read(commandDispatcherProvider)
                          .send(PurchaseFleetCommand(
                              issuedBy: me.id, vehicles: _vehicles)),
                  icon: const Icon(Icons.add_rounded, size: 14),
                  label: const Text('BUY VEHICLES'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.logistics),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
