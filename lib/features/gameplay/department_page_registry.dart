import 'package:flutter/material.dart';

import '../../core/config/department_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/typography.dart';
import '../../core/widgets/glass_panel.dart';
import '../departments/finance/presentation/screens/finance_dashboard_page.dart';
import '../departments/finance/presentation/screens/finance_pages.dart';
import '../departments/hr/presentation/screens/hr_pages.dart';
import '../departments/sales/presentation/screens/sales_pages.dart';
import '../departments/marketing/presentation/screens/marketing_pages.dart';
import '../departments/production/presentation/screens/production_pages.dart';
import '../departments/warehouse/presentation/screens/warehouse_pages.dart';
import '../departments/logistics/presentation/screens/logistics_pages.dart';
import '../departments/chairman/presentation/screens/chairman_pages.dart';

/// Resolves a department page widget given a [RoleId] and page id.
class DepartmentPageRegistry {
  DepartmentPageRegistry._();

  static Widget resolve(RoleId role, String pageId) {
    switch (role) {
      case RoleId.finance:
        return _financePage(pageId);
      case RoleId.hr:
        return HrPages.byId(pageId);
      case RoleId.sales:
        return SalesPages.byId(pageId);
      case RoleId.marketing:
        return MarketingPages.byId(pageId);
      case RoleId.production:
        return ProductionPages.byId(pageId);
      case RoleId.warehouse:
        return WarehousePages.byId(pageId);
      case RoleId.logistics:
        return LogisticsPages.byId(pageId);
      case RoleId.chairman:
        return ChairmanPages.byId(pageId);
    }
  }

  static Widget _financePage(String id) {
    switch (id) {
      case 'dashboard':
        return const FinanceDashboardPage();
      case 'payable':
        return const FinanceAccountsPayablePage();
      case 'receivable':
        return const FinanceAccountsReceivablePage();
      case 'loans':
        return const FinanceLoansPage();
      case 'budget':
        return const FinanceBudgetAllocationPage();
      case 'audits':
        return const FinanceAuditsPage();
      case 'reports':
        return const FinanceReportsPage();
    }
    return placeholder(
      title: 'Page Not Found',
      subtitle: id,
      message: 'No page handler for "$id" inside Finance.',
    );
  }

  static Widget placeholder({
    required String title,
    required String subtitle,
    String? message,
    IconData icon = Icons.construction_rounded,
    Color color = AppColors.accent,
  }) {
    return _PlaceholderPage(
      title: title,
      subtitle: subtitle,
      message: message,
      icon: icon,
      color: color,
    );
  }
}

class _PlaceholderPage extends StatelessWidget {
  const _PlaceholderPage({
    required this.title,
    required this.subtitle,
    this.message,
    this.icon = Icons.construction_rounded,
    this.color = AppColors.accent,
  });

  final String title;
  final String subtitle;
  final String? message;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Spacing.lg),
      child: GlassPanel(
        padding: const EdgeInsets.all(Spacing.huge),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(Spacing.radiusLg),
                ),
                alignment: Alignment.center,
                child: Icon(icon, size: 30, color: color),
              ),
              const SizedBox(height: Spacing.lg),
              Text(title.toUpperCase(),
                  style: AppTypography.h2.copyWith(letterSpacing: 4)),
              const SizedBox(height: 4),
              Text(subtitle, style: AppTypography.bodySmall),
              if (message != null) ...[
                const SizedBox(height: Spacing.lg),
                Text(message!,
                    style: AppTypography.caption,
                    textAlign: TextAlign.center),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
