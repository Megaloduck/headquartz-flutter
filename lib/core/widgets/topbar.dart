import 'package:flutter/material.dart';

import '../../data/models/company/company.dart';
import '../../data/models/simulation/game_session.dart';
import '../../data/models/player/player.dart';
import '../config/department_constants.dart';
import '../theme/app_colors.dart';
import '../theme/spacing.dart';
import '../theme/typography.dart';
import '../utils/formatters.dart';
import 'app_window.dart';

/// Top bar shown across all gameplay screens.
class GameplayTopbar extends StatelessWidget {
  const GameplayTopbar({
    super.key,
    required this.session,
    required this.localPlayer,
    required this.onTogglePause,
    required this.onSetSpeed,
    required this.onLeave,
  });

  final GameSession session;
  final Player localPlayer;
  final VoidCallback onTogglePause;
  final ValueChanged<double> onSetSpeed;
  final VoidCallback onLeave;

  Color get _roleColor =>
      AppColors.forDepartment(localPlayer.role?.key);

  @override
  Widget build(BuildContext context) {
    return WindowDragArea(
      child: Container(
        height: Spacing.topbarHeight,
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(bottom: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          children: [
            // Brand
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
              child: Row(
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _roleColor.withValues(alpha: 0.8),
                          AppColors.accentBright,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.business_center_rounded,
                        size: 12, color: Colors.white),
                  ),
                  const SizedBox(width: Spacing.sm),
                  Text(
                    'HEADQUARTZ',
                    style: AppTypography.label
                        .copyWith(color: AppColors.textPrimary),
                  ),
                ],
              ),
            ),
            Container(width: 1, height: 24, color: AppColors.border),

            // Company / role badge
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
              child: Row(
                children: [
                  _Badge(
                    text: session.company.name,
                    icon: Icons.account_balance_rounded,
                  ),
                  const SizedBox(width: Spacing.sm),
                  if (localPlayer.role != null)
                    _RoleBadge(role: localPlayer.role!),
                ],
              ),
            ),

            const Spacer(),

            // Sim clock + status
            _ClockWidget(session: session),
            const SizedBox(width: Spacing.lg),

            // Sim speed / pause / leave
            _SpeedSelector(
              speed: session.simulationSpeed,
              status: session.status,
              onTogglePause: onTogglePause,
              onSetSpeed: onSetSpeed,
            ),

            const SizedBox(width: Spacing.lg),
            _CashIndicator(co: session.company),
            const SizedBox(width: Spacing.md),

            // Window controls + leave
            IconButton(
              tooltip: 'Leave session',
              icon: const Icon(Icons.exit_to_app_rounded, size: 16),
              onPressed: onLeave,
            ),
            const WindowControls(),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.text, this.icon});
  final String text;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: Spacing.sm, vertical: Spacing.xs),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(Spacing.radiusSm),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: AppColors.textSecondary),
            const SizedBox(width: 4),
          ],
          Text(text, style: AppTypography.bodySmall),
        ],
      ),
    );
  }
}

class _RoleBadge extends StatelessWidget {
  const _RoleBadge({required this.role});
  final RoleId role;

  @override
  Widget build(BuildContext context) {
    final meta = DepartmentConstants.of(role);
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: Spacing.sm, vertical: Spacing.xs),
      decoration: BoxDecoration(
        color: meta.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(Spacing.radiusSm),
        border: Border.all(color: meta.color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(meta.icon, size: 12, color: meta.color),
          const SizedBox(width: 4),
          Text(
            meta.title.toUpperCase(),
            style: AppTypography.label.copyWith(color: meta.color),
          ),
        ],
      ),
    );
  }
}

class _ClockWidget extends StatelessWidget {
  const _ClockWidget({required this.session});
  final GameSession session;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: switch (session.status) {
              SessionStatus.running => AppColors.success,
              SessionStatus.paused => AppColors.warning,
              SessionStatus.ended => AppColors.danger,
              SessionStatus.lobby => AppColors.info,
            },
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: switch (session.status) {
                  SessionStatus.running => AppColors.success,
                  SessionStatus.paused => AppColors.warning,
                  SessionStatus.ended => AppColors.danger,
                  SessionStatus.lobby => AppColors.info,
                }
                    .withValues(alpha: 0.6),
                blurRadius: 6,
              ),
            ],
          ),
        ),
        const SizedBox(width: Spacing.sm),
        Text(
          Fmt.gameClock(session.gameMinute),
          style: AppTypography.clock,
        ),
      ],
    );
  }
}

class _SpeedSelector extends StatelessWidget {
  const _SpeedSelector({
    required this.speed,
    required this.status,
    required this.onTogglePause,
    required this.onSetSpeed,
  });

  final double speed;
  final SessionStatus status;
  final VoidCallback onTogglePause;
  final ValueChanged<double> onSetSpeed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          tooltip: status == SessionStatus.running ? 'Pause' : 'Play',
          icon: Icon(
            status == SessionStatus.running
                ? Icons.pause_rounded
                : Icons.play_arrow_rounded,
            size: 18,
          ),
          onPressed: onTogglePause,
        ),
        for (final s in [0.5, 1.0, 2.0, 4.0])
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: GestureDetector(
              onTap: () => onSetSpeed(s),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.sm, vertical: 4),
                decoration: BoxDecoration(
                  color: (s - speed).abs() < 0.01
                      ? AppColors.accent.withValues(alpha: 0.18)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(Spacing.radiusSm),
                  border: Border.all(
                    color: (s - speed).abs() < 0.01
                        ? AppColors.accent
                        : AppColors.border,
                  ),
                ),
                child: Text(
                  '${s}x',
                  style: AppTypography.caption.copyWith(
                    color: (s - speed).abs() < 0.01
                        ? AppColors.accentBright
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _CashIndicator extends StatelessWidget {
  const _CashIndicator({required this.co});
  final Company co;

  @override
  Widget build(BuildContext context) {
    final positive = co.cash >= 0;
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: Spacing.md, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(Spacing.radiusSm),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.attach_money_rounded,
            size: 12,
            color: positive ? AppColors.success : AppColors.danger,
          ),
          const SizedBox(width: 2),
          Text(
            Fmt.currencyCompact(co.cash),
            style: AppTypography.bodySmall.copyWith(
              color: positive ? AppColors.success : AppColors.danger,
              fontFamily: 'JetBrainsMono',
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
