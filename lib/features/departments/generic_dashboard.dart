import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../bootstrap/dependency_injection.dart';
import '../../core/config/department_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/typography.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/glass_panel.dart';
import '../../core/widgets/kpi_card.dart';
import '../../core/widgets/status_badge.dart';
import '../../data/models/company/kpi.dart';
import 'department_page_scaffold.dart';

/// Renders a default dashboard for any department.
///
/// Pulls relevant KPIs from the shared [Company] state and wraps them
/// in branded chrome. Individual departments can override with bespoke
/// dashboards if/when they need more depth.
class GenericDepartmentDashboard extends ConsumerWidget {
  const GenericDepartmentDashboard({
    super.key,
    required this.role,
    required this.kpiIds,
    this.subtitle = 'Department overview',
  });

  final RoleId role;
  final List<String> kpiIds;
  final String subtitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(currentSessionProvider);
    if (session == null) return const SizedBox.shrink();
    final meta = DepartmentConstants.of(role);

    final co = session.company;
    final kpiByLookup = {for (final k in co.kpis) k.id: k};
    final selected = [
      for (final id in kpiIds)
        if (kpiByLookup.containsKey(id)) kpiByLookup[id]!
    ];

    return DepartmentPageScaffold(
      title: '${meta.title} Dashboard',
      subtitle: subtitle,
      accent: meta.color,
      icon: meta.icon,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PanelGrid(
            minWidth: 220,
            aspectRatio: 1.3,
            children: [
              for (final k in selected) KpiCard(kpi: k, accent: meta.color),
              if (selected.length < kpiIds.length)
                _PendingCard(accent: meta.color),
            ],
          ),
          const SizedBox(height: Spacing.lg),
          SectionTitle(
            text: 'Department snapshot',
            icon: Icons.insights_rounded,
            accent: meta.color,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _CompanyContextCard(role: role)),
              const SizedBox(width: Spacing.md),
              Expanded(child: _StatusCard(role: role)),
            ],
          ),
        ],
      ),
    );
  }
}

class _PendingCard extends StatelessWidget {
  const _PendingCard({required this.accent});
  final Color accent;
  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.all(Spacing.lg),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.hourglass_top_rounded,
                size: 16, color: accent.withValues(alpha: 0.6)),
            const SizedBox(height: 6),
            Text('Awaiting first tick…',
                style: AppTypography.caption),
          ],
        ),
      ),
    );
  }
}

class _CompanyContextCard extends ConsumerWidget {
  const _CompanyContextCard({required this.role});
  final RoleId role;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(currentSessionProvider)!;
    final co = session.company;
    final meta = DepartmentConstants.of(role);
    return GlassPanel(
      padding: const EdgeInsets.all(Spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          PanelHeader(
              title: 'Company context',
              icon: Icons.business_rounded,
              accent: meta.color),
          _Row('Cash', Fmt.currency(co.cash)),
          _Row('Stock', '${Fmt.integer(co.unitsInStock.toDouble())} units'),
          _Row('Production', '${Fmt.decimal(co.productionRatePerTick)} u/t'),
          _Row('Demand', '${Fmt.decimal(co.demandPerTick)} u/t'),
          _Row('Employees', Fmt.integer(co.employees.toDouble())),
        ],
      ),
    );
  }
}

class _StatusCard extends ConsumerWidget {
  const _StatusCard({required this.role});
  final RoleId role;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(currentSessionProvider)!;
    final co = session.company;
    final meta = DepartmentConstants.of(role);
    return GlassPanel(
      padding: const EdgeInsets.all(Spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          PanelHeader(
              title: 'Status indicators',
              icon: Icons.health_and_safety_rounded,
              accent: meta.color),
          Wrap(
            spacing: Spacing.xs,
            runSpacing: Spacing.xs,
            children: [
              _band('Reputation', co.reputation),
              _band('Morale', co.morale),
              _band('Brand', co.brandAwareness),
              _band('Quality', co.qualityScore),
            ],
          ),
        ],
      ),
    );
  }

  Widget _band(String label, double v) {
    final color = v > 70
        ? AppColors.success
        : v > 40
            ? AppColors.warning
            : AppColors.danger;
    return StatusBadge(
      label: '$label · ${v.round()}',
      color: color,
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodySmall),
          Text(value,
              style: AppTypography.tableCellMono.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

/// Default per-page placeholder for not-yet-implemented departmental pages.
/// Provides the right title/subtitle/icon from registry metadata so it
/// feels like a real, intentional page rather than a "TODO".
class DepartmentPagePlaceholder extends StatelessWidget {
  const DepartmentPagePlaceholder({
    super.key,
    required this.role,
    required this.pageId,
    this.action,
  });

  final RoleId role;
  final String pageId;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final dept = DepartmentConstants.of(role);
    final page = dept.pages.firstWhere(
      (p) => p.id == pageId,
      orElse: () => const DepartmentPageMeta(
        id: '?',
        title: 'Page',
        subtitle: 'Unknown',
        icon: Icons.help_outline_rounded,
      ),
    );

    return DepartmentPageScaffold(
      title: page.title,
      subtitle: page.subtitle,
      accent: dept.color,
      icon: page.icon,
      child: GlassPanel(
        padding: const EdgeInsets.all(Spacing.huge),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: dept.color.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(Spacing.radiusLg),
                ),
                alignment: Alignment.center,
                child:
                    Icon(page.icon, size: 26, color: dept.color),
              ),
              const SizedBox(height: Spacing.lg),
              Text(page.title.toUpperCase(),
                  style: AppTypography.h2
                      .copyWith(letterSpacing: 4, color: dept.color)),
              const SizedBox(height: 4),
              Text(page.subtitle, style: AppTypography.bodySmall),
              const SizedBox(height: Spacing.xl),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Text(
                  'This module is wired into the simulation. The detailed '
                  'workflows for ${dept.title} → ${page.title} will live '
                  'here. The data model and authoritative state are ready.',
                  style: AppTypography.caption,
                  textAlign: TextAlign.center,
                ),
              ),
              if (action != null) ...[
                const SizedBox(height: Spacing.lg),
                action!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
