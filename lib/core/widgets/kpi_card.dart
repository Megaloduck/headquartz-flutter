import 'package:flutter/material.dart';

import '../../data/models/company/kpi.dart';
import '../theme/app_colors.dart';
import '../theme/spacing.dart';
import '../theme/typography.dart';
import '../utils/formatters.dart';
import 'glass_panel.dart';

/// Compact KPI tile with label, hero value, delta indicator, and a
/// minimal sparkline of recent values.
class KpiCard extends StatelessWidget {
  const KpiCard({
    super.key,
    required this.kpi,
    this.accent,
    this.compact = false,
  });

  final Kpi kpi;
  final Color? accent;
  final bool compact;

  String _formatValue() {
    switch (kpi.unit) {
      case '\$':
        return Fmt.currencyCompact(kpi.value);
      case '%':
        return Fmt.percent(kpi.value / 100);
      case 'u':
        return Fmt.integer(kpi.value);
      default:
        return Fmt.decimal(kpi.value);
    }
  }

  String _formatDelta() {
    if (kpi.delta == 0) return '—';
    final sign = kpi.delta > 0 ? '+' : '';
    if (kpi.unit == '\$') return '$sign${Fmt.currencyCompact(kpi.delta)}';
    return '$sign${Fmt.decimal(kpi.delta)}';
  }

  @override
  Widget build(BuildContext context) {
    final color = accent ?? AppColors.accent;
    final isUp = kpi.delta > 0;
    final deltaColor =
        kpi.delta == 0 ? AppColors.textTertiary : (isUp ? AppColors.success : AppColors.danger);

    return GlassPanel(
      padding: EdgeInsets.all(compact ? Spacing.md : Spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            kpi.label.toUpperCase(),
            style: AppTypography.kpiLabel,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: Spacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Flexible(
                child: Text(
                  _formatValue(),
                  style: (compact ? AppTypography.kpiValue : AppTypography.kpiHero)
                      .copyWith(color: color),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.xs),
          Row(
            children: [
              Icon(
                kpi.delta == 0
                    ? Icons.remove_rounded
                    : (isUp ? Icons.trending_up_rounded : Icons.trending_down_rounded),
                size: 12,
                color: deltaColor,
              ),
              const SizedBox(width: 4),
              Text(
                _formatDelta(),
                style: AppTypography.caption.copyWith(color: deltaColor),
              ),
              const Spacer(),
              if (kpi.history.length >= 2)
                SizedBox(
                  width: 64,
                  height: 22,
                  child: CustomPaint(
                    painter: _Sparkline(
                      values: kpi.history,
                      color: color,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Sparkline extends CustomPainter {
  _Sparkline({required this.values, required this.color});

  final List<double> values;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;
    final minV = values.reduce((a, b) => a < b ? a : b);
    final maxV = values.reduce((a, b) => a > b ? a : b);
    final range = (maxV - minV).abs() < 1e-6 ? 1.0 : (maxV - minV);

    final path = Path();
    for (var i = 0; i < values.length; i++) {
      final x = i / (values.length - 1) * size.width;
      final y = size.height - ((values[i] - minV) / range) * size.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..isAntiAlias = true,
    );

    // Glow under
    final fill = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(
      fill,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withValues(alpha: 0.20), Colors.transparent],
        ).createShader(Offset.zero & size),
    );
  }

  @override
  bool shouldRepaint(covariant _Sparkline oldDelegate) =>
      oldDelegate.values != values || oldDelegate.color != color;
}
