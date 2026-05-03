import 'dart:math';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Slow-pulsing radial gradient background. Used on splash, main menu,
/// lobby for a subtle "alive" enterprise feel without being noisy.
class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({
    super.key,
    this.child,
    this.accent,
  });

  final Widget? child;
  final Color? accent;

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ac;

  @override
  void initState() {
    super.initState();
    _ac = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 24),
    )..repeat();
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accent = widget.accent ?? AppColors.accent;
    return AnimatedBuilder(
      animation: _ac,
      builder: (context, _) {
        final t = _ac.value;
        final dx = sin(t * 2 * pi) * 0.25;
        final dy = cos(t * 2 * pi) * 0.20;
        return Stack(
          fit: StackFit.expand,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(dx, -0.3 + dy),
                  radius: 1.4,
                  colors: [
                    accent.withValues(alpha: 0.22),
                    AppColors.backgroundDeep,
                    AppColors.backgroundDeep,
                  ],
                  stops: const [0.0, 0.6, 1.0],
                ),
              ),
            ),
            // Subtle vignette / scanlines for "terminal" feel.
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _GridPainter(opacity: 0.03),
                ),
              ),
            ),
            if (widget.child != null) widget.child!,
          ],
        );
      },
    );
  }
}

class _GridPainter extends CustomPainter {
  _GridPainter({required this.opacity});
  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: opacity)
      ..strokeWidth = 0.5;
    const step = 32.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) =>
      oldDelegate.opacity != opacity;
}
