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

class MarketingPages {
  MarketingPages._();

  static Widget byId(String id) {
    switch (id) {
      case 'dashboard':
        return const GenericDepartmentDashboard(
          role: RoleId.marketing,
          subtitle: 'Outreach performance · brand & demand',
          kpiIds: ['brandAwareness', 'demand', 'reputation'],
        );
      case 'campaigns':
        return const _Campaigns();
      default:
        return DepartmentPagePlaceholder(role: RoleId.marketing, pageId: id);
    }
  }
}

class _Campaigns extends ConsumerStatefulWidget {
  const _Campaigns();

  @override
  ConsumerState<_Campaigns> createState() => _CampaignsState();
}

class _CampaignsState extends ConsumerState<_Campaigns> {
  double _spend = 25_000;
  int _duration = 240;
  final _nameCtrl = TextEditingController(text: 'Spring Launch');

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(currentSessionProvider);
    final me = ref.watch(localPlayerProvider);
    if (session == null || me == null) return const SizedBox.shrink();
    final co = session.company;

    return DepartmentPageScaffold(
      title: 'Campaigns',
      subtitle: 'Active promotions · launch a campaign',
      accent: AppColors.marketing,
      icon: Icons.campaign_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GlassPanel(
            padding: const EdgeInsets.all(Spacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PanelHeader(
                    title: 'New campaign',
                    icon: Icons.add_rounded,
                    accent: AppColors.marketing),
                TextField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(
                      labelText: 'Campaign name', isDense: true),
                  style: AppTypography.body,
                ),
                const SizedBox(height: Spacing.md),
                Row(children: [
                  Text('SPEND', style: AppTypography.kpiLabel),
                  Expanded(
                    child: Slider(
                      value: _spend,
                      min: 5_000,
                      max: 250_000,
                      divisions: 49,
                      activeColor: AppColors.marketing,
                      label: Fmt.currency(_spend),
                      onChanged: (v) => setState(() => _spend = v),
                    ),
                  ),
                  Text(Fmt.currency(_spend),
                      style: AppTypography.kpiValue),
                ]),
                Row(children: [
                  Text('DURATION', style: AppTypography.kpiLabel),
                  Expanded(
                    child: Slider(
                      value: _duration.toDouble(),
                      min: 60,
                      max: 1440,
                      divisions: 23,
                      activeColor: AppColors.marketing,
                      label: '${_duration}m',
                      onChanged: (v) =>
                          setState(() => _duration = v.round()),
                    ),
                  ),
                  Text('${_duration}m',
                      style: AppTypography.kpiValue),
                ]),
                const SizedBox(height: Spacing.md),
                Row(
                  children: [
                    Text(
                        'Cash after: ${Fmt.currency(co.cash - _spend)}',
                        style: AppTypography.bodySmall),
                    const Spacer(),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.rocket_launch_rounded, size: 14),
                      label: const Text('LAUNCH'),
                      onPressed: co.cash < _spend
                          ? null
                          : () => ref
                              .read(commandDispatcherProvider)
                              .send(LaunchCampaignCommand(
                                issuedBy: me.id,
                                name: _nameCtrl.text.trim(),
                                spend: _spend,
                                durationMinutes: _duration,
                              )),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.marketing),
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
