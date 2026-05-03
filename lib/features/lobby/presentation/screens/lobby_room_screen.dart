import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../bootstrap/dependency_injection.dart';
import '../../../../core/config/department_constants.dart';
import '../../../../core/config/game_constants.dart';
import '../../../../core/networking/lan/lobby_client.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/widgets/animated_background.dart';
import '../../../../core/widgets/app_window.dart';
import '../../../../core/widgets/glass_panel.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../data/models/simulation/game_session.dart';
import '../../../../data/models/player/player.dart';

class LobbyRoomScreen extends ConsumerStatefulWidget {
  const LobbyRoomScreen({super.key});

  @override
  ConsumerState<LobbyRoomScreen> createState() => _LobbyRoomScreenState();
}

class _LobbyRoomScreenState extends ConsumerState<LobbyRoomScreen> {
  final _chatCtrl = TextEditingController();
  StreamSubscription? _eventSub;

  @override
  void initState() {
    super.initState();
    // Listen for game-start event to navigate.
    final ns = ref.read(networkSessionProvider);
    final client = ns?.client;
    if (client != null) {
      _eventSub = client.events.listen((e) {
        if (!mounted) return;
        if (e is LobbyGameStarted) {
          _navigateToGame();
        } else if (e is LobbyRejected) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Rejected: ${e.reason}')));
          context.go(Routes.menu);
        }
      });
    }
  }

  @override
  void dispose() {
    _eventSub?.cancel();
    _chatCtrl.dispose();
    super.dispose();
  }

  void _navigateToGame() {
    final me = ref.read(localPlayerProvider);
    final role = me?.role ?? RoleId.finance;
    context.go(Routes.department(role.key));
  }

  Future<void> _leave() async {
    await ref.read(networkSessionProvider.notifier).endCurrent();
    if (mounted) context.go(Routes.menu);
  }

  void _sendChat() {
    final body = _chatCtrl.text.trim();
    if (body.isEmpty) return;
    ref.read(lobbyActionsProvider).sendChat(body);
    _chatCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(currentSessionProvider);
    final me = ref.watch(localPlayerProvider);
    final ns = ref.watch(networkSessionProvider);

    if (session == null || me == null || ns == null) {
      return const Scaffold(
        backgroundColor: AppColors.backgroundDeep,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // When game starts (status moves to running) navigate.
    if (session.status == SessionStatus.running) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _navigateToGame();
      });
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundDeep,
      body: Column(
        children: [
          const SizedBox(
              height: Spacing.topbarHeight,
              child: WindowDragArea(child: SizedBox.expand())),
          Expanded(
            child: AnimatedBackground(
              child: Padding(
                padding: const EdgeInsets.all(Spacing.lg),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 3,
                      child: _RolePicker(session: session, me: me),
                    ),
                    const SizedBox(width: Spacing.lg),
                    SizedBox(
                      width: 320,
                      child: Column(
                        children: [
                          Expanded(
                            flex: 3,
                            child: _PlayerList(
                              session: session,
                              hostId: ns.host?.hostPlayerId,
                            ),
                          ),
                          const SizedBox(height: Spacing.lg),
                          Expanded(
                            flex: 4,
                            child: GlassPanel(
                              padding: const EdgeInsets.all(Spacing.md),
                              child: Column(
                                children: [
                                  PanelHeader(
                                    title: 'Lobby chat',
                                    icon: Icons.chat_bubble_outline_rounded,
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      reverse: false,
                                      itemCount: session.chat.length,
                                      itemBuilder: (context, i) {
                                        final m = session.chat[i];
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: Spacing.xs),
                                          child: RichText(
                                            text: TextSpan(
                                              style: AppTypography.bodySmall,
                                              children: [
                                                TextSpan(
                                                  text: m.fromName,
                                                  style: AppTypography
                                                      .bodySmall
                                                      .copyWith(
                                                    color: AppColors
                                                        .forDepartment(
                                                            m.fromRole?.key),
                                                    fontWeight:
                                                        FontWeight.w600,
                                                  ),
                                                ),
                                                const TextSpan(text: '  '),
                                                TextSpan(text: m.body),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: _chatCtrl,
                                          onSubmitted: (_) => _sendChat(),
                                          style: AppTypography.body,
                                          decoration: const InputDecoration(
                                            hintText: 'Type a message…',
                                            isDense: true,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: Spacing.xs),
                                      IconButton(
                                        icon: const Icon(Icons.send_rounded,
                                            size: 14),
                                        onPressed: _sendChat,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _LobbyFooter(
            session: session,
            me: me,
            isHost: ns.isHost,
            onReady: (v) =>
                ref.read(lobbyActionsProvider).setReady(v),
            onStart: () => ref.read(lobbyActionsProvider).startGame(),
            onLeave: _leave,
          ),
        ],
      ),
    );
  }
}

class _RolePicker extends ConsumerWidget {
  const _RolePicker({required this.session, required this.me});
  final GameSession session;
  final Player me;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taken = <RoleId, Player>{};
    for (final p in session.players) {
      if (p.role != null) taken[p.role!] = p;
    }

    return GlassPanel(
      padding: const EdgeInsets.all(Spacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PanelHeader(
            title: session.name,
            subtitle: 'Pick a department · 7 active + 1 observer',
            icon: Icons.groups_rounded,
            accent: AppColors.accent,
          ),
          const SizedBox(height: Spacing.md),
          Expanded(
            child: GridView.count(
              crossAxisCount: 4,
              crossAxisSpacing: Spacing.md,
              mainAxisSpacing: Spacing.md,
              childAspectRatio: 1.05,
              children: [
                for (final id in RoleId.values)
                  _RoleCard(
                    meta: DepartmentConstants.of(id),
                    selected: me.role == id,
                    takenBy: taken[id]?.name == me.name ? null : taken[id],
                    onTap: () => ref
                        .read(lobbyActionsProvider)
                        .selectRole(me.role == id ? null : id),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleCard extends StatefulWidget {
  const _RoleCard({
    required this.meta,
    required this.selected,
    required this.takenBy,
    required this.onTap,
  });

  final DepartmentMeta meta;
  final bool selected;
  final Player? takenBy;
  final VoidCallback onTap;

  @override
  State<_RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<_RoleCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final isTaken = widget.takenBy != null;
    final clr = widget.meta.color;
    return MouseRegion(
      cursor: isTaken && !widget.selected
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: isTaken && !widget.selected ? null : widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.all(Spacing.md),
          decoration: BoxDecoration(
            color: widget.selected
                ? clr.withValues(alpha: 0.16)
                : (_hover && !isTaken
                    ? clr.withValues(alpha: 0.08)
                    : AppColors.surfaceElevated),
            borderRadius: BorderRadius.circular(Spacing.radiusMd),
            border: Border.all(
              color: widget.selected
                  ? clr
                  : (isTaken
                      ? AppColors.border.withValues(alpha: 0.4)
                      : (_hover ? clr.withValues(alpha: 0.6) : AppColors.border)),
              width: widget.selected ? 1.5 : 1,
            ),
            boxShadow: widget.selected
                ? [BoxShadow(color: clr.withValues(alpha: 0.3), blurRadius: 14)]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: clr.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(Spacing.radiusSm),
                ),
                alignment: Alignment.center,
                child: Icon(widget.meta.icon, size: 16, color: clr),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(widget.meta.title,
                      style: AppTypography.h4.copyWith(color: clr)),
                  Text(widget.meta.subtitle,
                      style: AppTypography.caption),
                  const SizedBox(height: Spacing.xs),
                  if (isTaken)
                    StatusBadge(
                        label: widget.takenBy!.name.toUpperCase(),
                        color: AppColors.warning,
                        icon: Icons.lock_outline_rounded)
                  else if (widget.selected)
                    StatusBadge(
                        label: 'YOU',
                        color: clr,
                        icon: Icons.check_rounded)
                  else
                    StatusBadge(
                        label: 'AVAILABLE',
                        color: AppColors.success,
                        icon: Icons.circle),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlayerList extends StatelessWidget {
  const _PlayerList({required this.session, required this.hostId});
  final GameSession session;
  final String? hostId;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.all(Spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PanelHeader(
            title: 'Players (${session.players.length}/${GameConstants.maxPlayers})',
            icon: Icons.person_outline_rounded,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: session.players.length,
              itemBuilder: (context, i) {
                final p = session.players[i];
                final color = AppColors.forDepartment(p.role?.key);
                return Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.sm, vertical: Spacing.xs + 2),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius:
                        BorderRadius.circular(Spacing.radiusSm),
                    border: Border.all(
                        color: AppColors.border, width: 0.5),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: p.isReady
                              ? AppColors.success
                              : AppColors.textTertiary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: Spacing.sm),
                      Expanded(
                          child: Text(p.name,
                              style: AppTypography.body)),
                      if (p.isHost)
                        const StatusBadge(
                          label: 'HOST',
                          color: AppColors.warning,
                          icon: Icons.shield_outlined,
                        ),
                      if (p.role != null) ...[
                        const SizedBox(width: 4),
                        StatusBadge(
                          label: DepartmentConstants.of(p.role!)
                              .title
                              .toUpperCase(),
                          color: color,
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _LobbyFooter extends StatelessWidget {
  const _LobbyFooter({
    required this.session,
    required this.me,
    required this.isHost,
    required this.onReady,
    required this.onStart,
    required this.onLeave,
  });

  final GameSession session;
  final Player me;
  final bool isHost;
  final ValueChanged<bool> onReady;
  final VoidCallback onStart;
  final VoidCallback onLeave;

  @override
  Widget build(BuildContext context) {
    final canStart = isHost &&
        session.players.length >= GameConstants.minPlayersToStart &&
        session.players.every((p) => p.isReady);

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: Spacing.lg, vertical: Spacing.md),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          OutlinedButton.icon(
            onPressed: onLeave,
            icon: const Icon(Icons.logout_rounded, size: 14),
            label: const Text('LEAVE'),
          ),
          const Spacer(),
          if (me.role != null) ...[
            OutlinedButton.icon(
              onPressed: () => onReady(!me.isReady),
              icon: Icon(
                me.isReady
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
                size: 14,
                color: me.isReady ? AppColors.success : null,
              ),
              label: Text(me.isReady ? 'READY' : 'NOT READY'),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                    color: me.isReady
                        ? AppColors.success
                        : AppColors.border),
                foregroundColor: me.isReady
                    ? AppColors.success
                    : AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: Spacing.md),
          ],
          if (isHost)
            ElevatedButton.icon(
              onPressed: canStart ? onStart : null,
              icon: const Icon(Icons.play_arrow_rounded, size: 16),
              label: const Text('START SIMULATION'),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    canStart ? AppColors.success : AppColors.surfaceHover,
              ),
            ),
        ],
      ),
    );
  }
}
