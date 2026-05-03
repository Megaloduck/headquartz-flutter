import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/app_config.dart';
import '../../core/routing/route_names.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/typography.dart';
import '../../core/widgets/animated_background.dart';
import '../../core/widgets/app_window.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ac;

  @override
  void initState() {
    super.initState();
    _ac = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..forward();

    Timer(const Duration(milliseconds: 1600), () {
      if (mounted) context.go(Routes.menu);
    });
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDeep,
      body: Column(
        children: [
          const SizedBox(
              height: Spacing.topbarHeight,
              child: WindowDragArea(child: SizedBox.expand())),
          Expanded(
            child: AnimatedBackground(
              child: Center(
                child: FadeTransition(
                  opacity: CurvedAnimation(
                      parent: _ac, curve: Curves.easeOut),
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.06),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                        parent: _ac, curve: Curves.easeOutCubic)),
                    child: const _Brand(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.accentBright, AppColors.sales],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withValues(alpha: 0.4),
                blurRadius: 32,
                spreadRadius: 4,
              ),
            ],
          ),
          alignment: Alignment.center,
          child: const Icon(Icons.business_center_rounded,
              size: 48, color: Colors.white),
        ),
        const SizedBox(height: Spacing.xxl),
        Text(
          AppConfig.appName.toUpperCase(),
          style: AppTypography.display.copyWith(
            color: AppColors.textPrimary,
            letterSpacing: 8,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: Spacing.sm),
        Text(
          AppConfig.appTagline,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondary,
            letterSpacing: 4,
          ),
        ),
        const SizedBox(height: Spacing.xxxl),
        const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            strokeWidth: 1.6,
            valueColor:
                AlwaysStoppedAnimation<Color>(AppColors.accentBright),
          ),
        ),
      ],
    );
  }
}
