import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../bootstrap/dependency_injection.dart';
import '../../../core/config/app_config.dart';
import '../../../core/config/network_constants.dart';
import '../../../core/config/simulation_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/typography.dart';
import '../../../core/widgets/animated_background.dart';
import '../../../core/widgets/app_window.dart';
import '../../../core/widgets/glass_panel.dart';

/// User-facing preferences screen.
///
/// Most actual settings (audio, telemetry, replay) are stubbed because
/// they bind to subsystems that are placeholders. This screen at minimum:
///  • lets the player change their display name
///  • surfaces the network/protocol version they'll connect with
///  • shows simulation tick rate / tunables for transparency
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late final TextEditingController _nameCtrl;

  // Local-only toggles — wired to nothing yet, but reflect intent.
  bool _ambientAudio = true;
  bool _notificationSounds = true;
  bool _enableMdns = true;
  bool _verboseLogs = false;

  @override
  void initState() {
    super.initState();
    final id = ref.read(playerIdentityProvider);
    _nameCtrl = TextEditingController(text: id.name);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  void _save() {
    ref
        .read(playerIdentityProvider.notifier)
        .setName(_nameCtrl.text.trim().isEmpty
            ? 'Player'
            : _nameCtrl.text.trim());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Settings saved'),
          duration: Duration(seconds: 2)),
    );
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
              accent: AppColors.textSecondary,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: Padding(
                    padding: const EdgeInsets.all(Spacing.xxl),
                    child: GlassPanel(
                      padding: const EdgeInsets.all(Spacing.xl),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back_rounded,
                                    size: 16),
                                onPressed: () => context.pop(),
                              ),
                              const SizedBox(width: Spacing.sm),
                              Text('SETTINGS',
                                  style: AppTypography.h2.copyWith(
                                      letterSpacing: 4,
                                      color: AppColors.textPrimary)),
                            ],
                          ),
                          const SizedBox(height: Spacing.xl),
                          _Group(
                            title: 'Player',
                            children: [
                              _Field(
                                label: 'Display name',
                                child: TextField(
                                  controller: _nameCtrl,
                                  style: AppTypography.body,
                                  decoration: const InputDecoration(
                                      isDense: true,
                                      hintText: 'Your name in the lobby'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: Spacing.lg),
                          _Group(
                            title: 'Audio',
                            children: [
                              _Toggle(
                                label: 'Ambient soundtrack',
                                subtitle:
                                    'Background score during gameplay',
                                value: _ambientAudio,
                                onChanged: (v) =>
                                    setState(() => _ambientAudio = v),
                              ),
                              _Toggle(
                                label: 'Notification sounds',
                                subtitle:
                                    'Play a chime for events and alerts',
                                value: _notificationSounds,
                                onChanged: (v) => setState(
                                    () => _notificationSounds = v),
                              ),
                            ],
                          ),
                          const SizedBox(height: Spacing.lg),
                          _Group(
                            title: 'Network',
                            children: [
                              _Toggle(
                                label: 'mDNS discovery',
                                subtitle:
                                    'Broadcast and discover sessions on LAN',
                                value: _enableMdns,
                                onChanged: (v) =>
                                    setState(() => _enableMdns = v),
                              ),
                              _ReadOnly(
                                label: 'Service type',
                                value: NetworkConstants.serviceType,
                              ),
                              _ReadOnly(
                                label: 'Default port range',
                                value:
                                    '${NetworkConstants.portRangeStart} – ${NetworkConstants.portRangeEnd}',
                              ),
                              _ReadOnly(
                                label: 'Protocol version',
                                value:
                                    'v${NetworkConstants.protocolVersion}',
                              ),
                            ],
                          ),
                          const SizedBox(height: Spacing.lg),
                          _Group(
                            title: 'Simulation',
                            children: [
                              _ReadOnly(
                                label: 'Tick rate',
                                value:
                                    '${SimulationConstants.tickRateHz} Hz',
                              ),
                              _ReadOnly(
                                label: 'In-game seconds / tick',
                                value:
                                    '${SimulationConstants.inGameSecondsPerTick}',
                              ),
                              _ReadOnly(
                                label: 'Available speeds',
                                value: SimulationConstants
                                    .availableSpeeds
                                    .map((s) => '${s}x')
                                    .join('  ·  '),
                              ),
                            ],
                          ),
                          const SizedBox(height: Spacing.lg),
                          _Group(
                            title: 'Diagnostics',
                            children: [
                              _Toggle(
                                label: 'Verbose logs',
                                subtitle:
                                    'Print engine traces to stdout',
                                value: _verboseLogs,
                                onChanged: (v) =>
                                    setState(() => _verboseLogs = v),
                              ),
                            ],
                          ),
                          const SizedBox(height: Spacing.lg),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              OutlinedButton(
                                onPressed: () => context.pop(),
                                child: const Text('CANCEL'),
                              ),
                              const SizedBox(width: Spacing.md),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.save_rounded,
                                    size: 14),
                                label: const Text('SAVE'),
                                onPressed: _save,
                              ),
                            ],
                          ),
                          const SizedBox(height: Spacing.lg),
                          Center(
                            child: Text(
                              '${AppConfig.appName} v${AppConfig.version}+${AppConfig.build}',
                              style: AppTypography.caption,
                            ),
                          ),
                        ],
                      ),
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

class _Group extends StatelessWidget {
  const _Group({required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: Spacing.sm),
          child: Row(
            children: [
              Text(title.toUpperCase(),
                  style: AppTypography.label
                      .copyWith(letterSpacing: 1.6)),
              const SizedBox(width: Spacing.sm),
              Expanded(child: Container(height: 1, color: AppColors.divider)),
            ],
          ),
        ),
        ...children,
      ],
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.label, required this.child});
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.xs),
      child: Row(
        children: [
          SizedBox(
            width: 180,
            child: Text(label, style: AppTypography.bodySmall),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _Toggle extends StatelessWidget {
  const _Toggle({
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.xs),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label, style: AppTypography.body),
                Text(subtitle, style: AppTypography.caption),
              ],
            ),
          ),
          Switch(
            value: value,
            activeColor: AppColors.accentBright,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _ReadOnly extends StatelessWidget {
  const _ReadOnly({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 180,
            child: Text(label, style: AppTypography.bodySmall),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTypography.tableCellMono.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
