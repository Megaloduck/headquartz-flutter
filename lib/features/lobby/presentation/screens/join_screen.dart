import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../bootstrap/dependency_injection.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/animated_background.dart';
import '../../../../core/widgets/app_window.dart';
import '../../../../core/widgets/glass_panel.dart';
import '../../../../data/models/simulation/discovered_session.dart';

class JoinScreen extends ConsumerStatefulWidget {
  const JoinScreen({super.key});

  @override
  ConsumerState<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends ConsumerState<JoinScreen> {
  final _hostCtrl = TextEditingController(text: '127.0.0.1');
  final _portCtrl = TextEditingController(text: '49152');
  String? _error;
  bool _connecting = false;

  @override
  void initState() {
    super.initState();
    // Start discovery on screen mount.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(sessionBrowserProvider).start();
    });
  }

  @override
  void dispose() {
    ref.read(sessionBrowserProvider).stop();
    _hostCtrl.dispose();
    _portCtrl.dispose();
    super.dispose();
  }

  Future<void> _join(String host, int port) async {
    setState(() {
      _connecting = true;
      _error = null;
    });
    try {
      final id = ref.read(playerIdentityProvider);
      await ref
          .read(networkSessionProvider.notifier)
          .joinClient(playerName: id.name, host: host, port: port);
      if (mounted) context.go(Routes.lobbyRoom);
    } catch (e) {
      setState(() => _error = '$e');
    } finally {
      if (mounted) setState(() => _connecting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sessions = ref.watch(discoveredSessionsProvider).maybeWhen(
          data: (v) => v,
          orElse: () => const <DiscoveredSession>[],
        );

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
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 880),
                  child: Padding(
                    padding: const EdgeInsets.all(Spacing.xxl),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: GlassPanel(
                            padding: const EdgeInsets.all(Spacing.xl),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                          Icons.arrow_back_rounded,
                                          size: 16),
                                      onPressed: () => context.pop(),
                                    ),
                                    const SizedBox(width: Spacing.sm),
                                    Text('JOIN LAN SESSION',
                                        style: AppTypography.h2.copyWith(
                                            letterSpacing: 3,
                                            color: AppColors.accent)),
                                  ],
                                ),
                                const SizedBox(height: Spacing.lg),
                                PanelHeader(
                                  title: 'Discovered sessions',
                                  subtitle: 'mDNS broadcast on LAN',
                                  icon: Icons.radar_rounded,
                                  accent: AppColors.accent,
                                ),
                                Expanded(
                                  child: sessions.isEmpty
                                      ? const _EmptyDiscovery()
                                      : ListView.builder(
                                          itemCount: sessions.length,
                                          itemBuilder: (context, i) {
                                            return _SessionTile(
                                              session: sessions[i],
                                              onTap: _connecting
                                                  ? null
                                                  : () => _join(
                                                      sessions[i].host,
                                                      sessions[i].port),
                                            );
                                          },
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: Spacing.lg),
                        SizedBox(
                          width: 280,
                          child: GlassPanel(
                            padding: const EdgeInsets.all(Spacing.xl),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                PanelHeader(
                                  title: 'Manual entry',
                                  subtitle: 'Connect by IP',
                                  icon: Icons.cable_rounded,
                                ),
                                Text('HOST',
                                    style: AppTypography.label),
                                const SizedBox(height: 4),
                                TextField(controller: _hostCtrl),
                                const SizedBox(height: Spacing.md),
                                Text('PORT',
                                    style: AppTypography.label),
                                const SizedBox(height: 4),
                                TextField(controller: _portCtrl),
                                const SizedBox(height: Spacing.lg),
                                if (_error != null)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: Spacing.sm),
                                    child: Text(
                                      _error!,
                                      style: AppTypography.caption
                                          .copyWith(color: AppColors.danger),
                                    ),
                                  ),
                                ElevatedButton.icon(
                                  onPressed: _connecting
                                      ? null
                                      : () {
                                          final host =
                                              _hostCtrl.text.trim();
                                          final portErr = Validators.port(
                                              _portCtrl.text.trim());
                                          if (host.isEmpty ||
                                              portErr != null) {
                                            setState(() => _error =
                                                'Invalid host/port');
                                            return;
                                          }
                                          _join(host,
                                              int.parse(_portCtrl.text.trim()));
                                        },
                                  icon: const Icon(Icons.login_rounded,
                                      size: 14),
                                  label: const Text('CONNECT'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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

class _EmptyDiscovery extends StatelessWidget {
  const _EmptyDiscovery();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
              valueColor:
                  AlwaysStoppedAnimation<Color>(AppColors.accentBright),
            ),
          ),
          const SizedBox(height: Spacing.md),
          Text('Scanning network…',
              style: AppTypography.bodySmall),
          const SizedBox(height: 4),
          Text('No sessions discovered yet.',
              style: AppTypography.caption),
        ],
      ),
    );
  }
}

class _SessionTile extends StatefulWidget {
  const _SessionTile({required this.session, required this.onTap});
  final DiscoveredSession session;
  final VoidCallback? onTap;

  @override
  State<_SessionTile> createState() => _SessionTileState();
}

class _SessionTileState extends State<_SessionTile> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final s = widget.session;
    return MouseRegion(
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.all(Spacing.md),
          decoration: BoxDecoration(
            color: _hover
                ? AppColors.accent.withValues(alpha: 0.08)
                : AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(Spacing.radiusMd),
            border: Border.all(
                color: _hover ? AppColors.accent : AppColors.border),
          ),
          child: Row(
            children: [
              const Icon(Icons.dns_rounded,
                  size: 16, color: AppColors.accentBright),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(s.name, style: AppTypography.h4),
                    Text('${s.host}:${s.port}',
                        style: AppTypography.caption),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.sm, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.surfaceHover,
                  borderRadius: BorderRadius.circular(Spacing.radiusSm),
                ),
                child: Text(
                  '${s.playerCount}/${s.maxPlayers}',
                  style: AppTypography.label.copyWith(
                    color: s.isFull
                        ? AppColors.warning
                        : AppColors.accentBright,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
