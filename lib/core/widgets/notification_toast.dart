import 'package:flutter/material.dart';

import '../../data/models/simulation/notification.dart';
import '../theme/app_colors.dart';
import '../theme/spacing.dart';
import '../theme/typography.dart';

class NotificationToast extends StatelessWidget {
  const NotificationToast({super.key, required this.n});
  final GameNotification n;

  Color _color() {
    return switch (n.severity) {
      NotificationSeverity.info => AppColors.info,
      NotificationSeverity.success => AppColors.success,
      NotificationSeverity.warning => AppColors.warning,
      NotificationSeverity.danger => AppColors.danger,
    };
  }

  IconData _icon() {
    return switch (n.severity) {
      NotificationSeverity.info => Icons.info_outline_rounded,
      NotificationSeverity.success => Icons.check_circle_outline_rounded,
      NotificationSeverity.warning => Icons.warning_amber_rounded,
      NotificationSeverity.danger => Icons.error_outline_rounded,
    };
  }

  @override
  Widget build(BuildContext context) {
    final c = _color();
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: Spacing.md, vertical: 4),
      padding: const EdgeInsets.symmetric(
          horizontal: Spacing.md, vertical: Spacing.sm),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(Spacing.radiusSm),
        border: Border(left: BorderSide(color: c, width: 2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(_icon(), size: 14, color: c),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(n.title, style: AppTypography.h4),
                const SizedBox(height: 2),
                Text(
                  n.body,
                  style: AppTypography.bodySmall,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
