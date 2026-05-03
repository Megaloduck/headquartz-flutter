import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../bootstrap/dependency_injection.dart';
import '../../core/config/department_constants.dart';
import '../../core/routing/route_names.dart';
import '../../core/simulation/engine/commands.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/typography.dart';
import '../../core/widgets/event_ticker.dart';
import '../../core/widgets/glass_panel.dart';
import '../../core/widgets/sidebar.dart';
import '../../core/widgets/topbar.dart';
import '../../data/models/simulation/game_session.dart';
import '../../data/models/player/player.dart';
import '../chat/presentation/chat_panel.dart';
import 'department_page_registry.dart';

/// The main in-game shell. Hosts:
///   • Topbar (clock, sim controls, role badge, window controls)
///   • DepartmentSidebar (page nav)
///   • Department page content
///   • Chat + Notifications side panel
///   • EventTicker (bottom)
class GameplayShell extends ConsumerWidget {
  const GameplayShell({
    super.key,
    required this.role,
    required this.pageId,
  });

  final RoleId role;
  final String pageId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(currentSessionProvider);
    final me = ref.watch(localPlayerProvider);
    final dispatcher = ref.read(commandDispatcherProvider);

    if (session == null || me == null) {
      return const Scaffold(
        backgroundColor: AppColors.backgroundDeep,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (session.status == SessionStatus.ended) {
      return _EndedScreen(session: session);
    }

    final dept = DepartmentConstants.of(role);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          GameplayTopbar(
            session: session,
            localPlayer: me,
            onTogglePause: () =>
                dispatcher.send(const TogglePauseCommand(issuedBy: 'host')),
            onSetSpeed: (s) =>
                dispatcher.send(SetSpeedCommand(issuedBy: me.id, speed: s)),
            onLeave: () async {
              await ref.read(networkSessionProvider.notifier).endCurrent();
              if (context.mounted) context.go(Routes.menu);
            },
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DepartmentSidebar(
                  department: dept,
                  activePageId: pageId,
                  onPageSelected: (next) =>
                      context.go(Routes.department(role.key, next)),
                ),
                Expanded(
                  child: Container(
                    color: AppColors.background,
                    child: DepartmentPageRegistry.resolve(role, pageId),
                  ),
                ),
                _RightDrawer(session: session, me: me),
              ],
            ),
          ),
          EventTicker(notifications: session.notifications),
        ],
      ),
    );
  }
}

class _RightDrawer extends ConsumerStatefulWidget {
  const _RightDrawer({required this.session, required this.me});
  final GameSession session;
  final Player me;

  @override
  ConsumerState<_RightDrawer> createState() => _RightDrawerState();
}

class _RightDrawerState extends ConsumerState<_RightDrawer> {
  int _tab = 0; // 0: chat, 1: notifications

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(left: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        children: [
          _Tabs(
            value: _tab,
            onChanged: (v) => setState(() => _tab = v),
          ),
          Expanded(
            child: _tab == 0
                ? ChatPanel(session: widget.session)
                : _Notifications(session: widget.session),
          ),
        ],
      ),
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({required this.value, required this.onChanged});
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
              child: _TabBtn(
                  label: 'CHAT',
                  active: value == 0,
                  onTap: () => onChanged(0))),
          Expanded(
              child: _TabBtn(
                  label: 'NOTIFICATIONS',
                  active: value == 1,
                  onTap: () => onChanged(1))),
        ],
      ),
    );
  }
}

class _TabBtn extends StatelessWidget {
  const _TabBtn(
      {required this.label, required this.active, required this.onTap});
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active
              ? AppColors.accent.withValues(alpha: 0.10)
              : Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: active ? AppColors.accent : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: AppTypography.label.copyWith(
            color: active ? AppColors.accentBright : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _Notifications extends StatelessWidget {
  const _Notifications({required this.session});
  final GameSession session;

  @override
  Widget build(BuildContext context) {
    final list = session.notifications;
    if (list.isEmpty) {
      return Center(
        child: Text('No notifications yet', style: AppTypography.caption),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
      itemCount: list.length,
      itemBuilder: (context, i) {
        final n = list[i];
        return Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Spacing.md, vertical: 3),
          child: Container(
            padding: const EdgeInsets.all(Spacing.sm),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(Spacing.radiusSm),
              border: const Border(
                left: BorderSide(color: AppColors.accent, width: 2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(n.title,
                    style: AppTypography.h4.copyWith(fontSize: 12)),
                const SizedBox(height: 2),
                Text(n.body,
                    style: AppTypography.bodySmall, maxLines: 3),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _EndedScreen extends ConsumerWidget {
  const _EndedScreen({required this.session});
  final GameSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWin = session.endReason == SessionEndReason.victory;
    final color = isWin ? AppColors.success : AppColors.danger;
    return Scaffold(
      backgroundColor: AppColors.backgroundDeep,
      body: Center(
        child: GlassPanel(
          padding: const EdgeInsets.all(Spacing.huge),
          glowColor: color,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isWin ? Icons.emoji_events_rounded : Icons.warning_rounded,
                size: 56,
                color: color,
              ),
              const SizedBox(height: Spacing.lg),
              Text(
                isWin ? 'VICTORY' : 'GAME OVER',
                style: AppTypography.display.copyWith(
                    letterSpacing: 8, color: color),
              ),
              const SizedBox(height: Spacing.md),
              Text(
                isWin
                    ? '${session.company.name} reached the victory threshold.'
                    : '${session.company.name} could not stay solvent.',
                style: AppTypography.bodySmall,
              ),
              const SizedBox(height: Spacing.xxxl),
              ElevatedButton.icon(
                onPressed: () async {
                  await ref
                      .read(networkSessionProvider.notifier)
                      .endCurrent();
                  if (context.mounted) context.go(Routes.menu);
                },
                icon: const Icon(Icons.home_rounded, size: 16),
                label: const Text('RETURN TO MENU'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
