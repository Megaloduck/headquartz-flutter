import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/spacing.dart';
import '../theme/typography.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key, this.message});
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundDeep.withValues(alpha: 0.85),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor:
                  AlwaysStoppedAnimation<Color>(AppColors.accentBright),
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: Spacing.md),
            Text(message!, style: AppTypography.bodySmall),
          ],
        ],
      ),
    );
  }
}
