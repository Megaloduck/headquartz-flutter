import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/typography.dart';
import '../../core/widgets/glass_panel.dart';

/// Standard scaffold every department page sits inside.
///
/// Provides a sticky title row + scrollable content area so individual
/// pages stay focused on their data.
class DepartmentPageScaffold extends StatelessWidget {
  const DepartmentPageScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.icon,
    this.actions,
    required this.child,
    this.padded = true,
  });

  final String title;
  final String subtitle;
  final Color accent;
  final IconData icon;
  final List<Widget>? actions;
  final Widget child;
  final bool padded;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(
              bottom: BorderSide(color: AppColors.border),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(Spacing.radiusSm),
                ),
                alignment: Alignment.center,
                child: Icon(icon, size: 14, color: accent),
              ),
              const SizedBox(width: Spacing.md),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title.toUpperCase(),
                      style: AppTypography.h3
                          .copyWith(letterSpacing: 2.5, color: accent)),
                  Text(subtitle, style: AppTypography.caption),
                ],
              ),
              const Spacer(),
              if (actions != null) ...actions!,
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: padded
                ? const EdgeInsets.all(Spacing.lg)
                : EdgeInsets.zero,
            child: child,
          ),
        ),
      ],
    );
  }
}

/// Helper section header for inside a department page.
class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.text, this.icon, this.accent});
  final String text;
  final IconData? icon;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.md, top: Spacing.sm),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: accent ?? AppColors.textSecondary),
            const SizedBox(width: 6),
          ],
          Text(
            text.toUpperCase(),
            style: AppTypography.label.copyWith(
              color: accent ?? AppColors.textSecondary,
              letterSpacing: 1.4,
              fontSize: 11,
            ),
          ),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: Container(height: 1, color: AppColors.divider),
          ),
        ],
      ),
    );
  }
}

/// Helper that arranges a list of panels in an auto-wrapping grid.
class PanelGrid extends StatelessWidget {
  const PanelGrid({
    super.key,
    required this.children,
    this.minWidth = 280,
    this.aspectRatio = 1.6,
    this.spacing = Spacing.md,
  });

  final List<Widget> children;
  final double minWidth;
  final double aspectRatio;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final count = (c.maxWidth / minWidth).floor().clamp(1, 8);
        final w = (c.maxWidth - spacing * (count - 1)) / count;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final child in children)
              SizedBox(
                width: w,
                height: w / aspectRatio,
                child: child,
              ),
          ],
        );
      },
    );
  }
}
