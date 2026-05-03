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

class SalesPages {
  SalesPages._();

  static Widget byId(String id) {
    switch (id) {
      case 'dashboard':
        return const GenericDepartmentDashboard(
          role: RoleId.sales,
          subtitle: 'Revenue overview · pipeline & performance',
          kpiIds: ['cash', 'demand', 'reputation', 'revenue_per_unit'],
        );
      case 'orders':
        return const _Orders();
      default:
        return DepartmentPagePlaceholder(role: RoleId.sales, pageId: id);
    }
  }
}

class _Orders extends ConsumerStatefulWidget {
  const _Orders();

  @override
  ConsumerState<_Orders> createState() => _OrdersState();
}

class _OrdersState extends ConsumerState<_Orders> {
  late final TextEditingController _priceCtrl;

  @override
  void initState() {
    super.initState();
    final session = ref.read(currentSessionProvider);
    _priceCtrl = TextEditingController(
      text: session?.company.unitPrice.toStringAsFixed(2) ?? '79.00',
    );
  }

  @override
  void dispose() {
    _priceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(currentSessionProvider);
    final me = ref.watch(localPlayerProvider);
    if (session == null || me == null) return const SizedBox.shrink();
    final co = session.company;

    return DepartmentPageScaffold(
      title: 'Orders',
      subtitle: 'Customer purchases · live pricing',
      accent: AppColors.sales,
      icon: Icons.receipt_long_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GlassPanel(
            padding: const EdgeInsets.all(Spacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PanelHeader(
                    title: 'Pricing strategy',
                    icon: Icons.price_change_rounded,
                    accent: AppColors.sales),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _priceCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        style: AppTypography.kpiValue,
                        decoration: const InputDecoration(
                          prefixText: '\$',
                          isDense: true,
                          hintText: 'Unit price',
                        ),
                      ),
                    ),
                    const SizedBox(width: Spacing.md),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.check_rounded, size: 14),
                      label: const Text('SET PRICE'),
                      onPressed: () {
                        final v = double.tryParse(_priceCtrl.text.trim());
                        if (v == null || v <= 0) return;
                        ref.read(commandDispatcherProvider).send(
                              AdjustPriceCommand(
                                  issuedBy: me.id, newPrice: v),
                            );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.sales),
                    ),
                  ],
                ),
                const SizedBox(height: Spacing.md),
                Row(
                  children: [
                    Text(
                      'Current: ${Fmt.currency(co.unitPrice)} · '
                      'Demand: ${Fmt.decimal(co.demandPerTick)} u/t · '
                      'Stock: ${co.unitsInStock} u',
                      style: AppTypography.bodySmall,
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
