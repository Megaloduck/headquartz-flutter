import 'package:flutter/material.dart';

import '../config/department_constants.dart';
import '../theme/app_colors.dart';
import '../theme/spacing.dart';
import '../theme/typography.dart';

/// Department-specific page sidebar shown on the left of the gameplay
/// shell. Clicking a page entry triggers [onPageSelected].
class DepartmentSidebar extends StatelessWidget {
  const DepartmentSidebar({
    super.key,
    required this.department,
    required this.activePageId,
    required this.onPageSelected,
    this.collapsed = false,
  });

  final DepartmentMeta department;
  final String activePageId;
  final ValueChanged<String> onPageSelected;
  final bool collapsed;

  @override
  Widget build(BuildContext context) {
    final width =
        collapsed ? Spacing.sidebarCollapsedWidth : Spacing.sidebarWidth;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: width,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(right: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        children: [
          _Header(department: department, collapsed: collapsed),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
              itemCount: department.pages.length,
              itemBuilder: (context, i) {
                final page = department.pages[i];
                final selected = page.id == activePageId;
                return _NavItem(
                  page: page,
                  selected: selected,
                  accent: department.color,
                  collapsed: collapsed,
                  onTap: () => onPageSelected(page.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.department, required this.collapsed});
  final DepartmentMeta department;
  final bool collapsed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Spacing.md,
        Spacing.lg,
        Spacing.md,
        Spacing.md,
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: department.color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(Spacing.radiusMd),
              border:
                  Border.all(color: department.color.withValues(alpha: 0.4)),
            ),
            alignment: Alignment.center,
            child: Icon(department.icon, size: 18, color: department.color),
          ),
          if (!collapsed) ...[
            const SizedBox(width: Spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    department.title,
                    style: AppTypography.h4
                        .copyWith(color: AppColors.textPrimary),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    department.subtitle,
                    style: AppTypography.caption,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  const _NavItem({
    required this.page,
    required this.selected,
    required this.accent,
    required this.collapsed,
    required this.onTap,
  });

  final DepartmentPageMeta page;
  final bool selected;
  final Color accent;
  final bool collapsed;
  final VoidCallback onTap;

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final bg = widget.selected
        ? widget.accent.withValues(alpha: 0.12)
        : (_hover ? AppColors.surfaceHover : Colors.transparent);
    final fg = widget.selected ? widget.accent : AppColors.textSecondary;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(
              horizontal: Spacing.sm, vertical: 2),
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.md,
            vertical: Spacing.sm,
          ),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(Spacing.radiusSm),
            border: Border(
              left: BorderSide(
                color: widget.selected ? widget.accent : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(widget.page.icon, size: 16, color: fg),
              if (!widget.collapsed) ...[
                const SizedBox(width: Spacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.page.title,
                        style: AppTypography.body
                            .copyWith(color: fg, fontWeight: widget.selected ? FontWeight.w600 : FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        widget.page.subtitle,
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textTertiary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
