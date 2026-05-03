import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../bootstrap/dependency_injection.dart';
import '../../core/config/app_config.dart';
import '../../core/routing/route_names.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/typography.dart';
import '../../core/widgets/animated_background.dart';
import '../../core/widgets/app_window.dart';
import '../../core/widgets/glass_panel.dart';

class MainMenuScreen extends ConsumerStatefulWidget {
  const MainMenuScreen({super.key});

  @override
  ConsumerState<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends ConsumerState<MainMenuScreen> {
  late final TextEditingController _nameCtrl;

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
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 760),
                  child: Padding(
                    padding: const EdgeInsets.all(Spacing.xxl),
                    child: GlassPanel(
                      padding: const EdgeInsets.all(Spacing.huge),
                      glowColor: AppColors.accent,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _Brand(),
                          const SizedBox(height: Spacing.xxxl),
                          _NameField(controller: _nameCtrl),
                          const SizedBox(height: Spacing.xl),
                          _MenuButton(
                            label: 'Host LAN Session',
                            subtitle:
                                'Run the simulation as authoritative host',
                            icon: Icons.dns_rounded,
                            color: AppColors.success,
                            onTap: () {
                              ref
                                  .read(playerIdentityProvider.notifier)
                                  .setName(_nameCtrl.text.trim());
                              context.push(Routes.lobbyHost);
                            },
                          ),
                          const SizedBox(height: Spacing.md),
                          _MenuButton(
                            label: 'Join LAN Session',
                            subtitle:
                                'Discover a host on your local network',
                            icon: Icons.cable_rounded,
                            color: AppColors.accent,
                            onTap: () {
                              ref
                                  .read(playerIdentityProvider.notifier)
                                  .setName(_nameCtrl.text.trim());
                              context.push(Routes.lobbyJoin);
                            },
                          ),
                          const SizedBox(height: Spacing.md),
                          _MenuButton(
                            label: 'Settings',
                            subtitle: 'Audio, network, display',
                            icon: Icons.settings_rounded,
                            color: AppColors.textSecondary,
                            onTap: () => context.push(Routes.settings),
                          ),
                          const SizedBox(height: Spacing.xxl),
                          Text(
                            '${AppConfig.appName} · v${AppConfig.version}',
                            style: AppTypography.caption,
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

class _Brand extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.accentBright, AppColors.sales],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: const Icon(Icons.business_center_rounded,
              color: Colors.white, size: 28),
        ),
        const SizedBox(height: Spacing.lg),
        Text(
          AppConfig.appName.toUpperCase(),
          style: AppTypography.h1.copyWith(
            letterSpacing: 6,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(AppConfig.appTagline,
            style: AppTypography.caption.copyWith(letterSpacing: 2)),
      ],
    );
  }
}

class _NameField extends StatelessWidget {
  const _NameField({required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(right: Spacing.md),
          child: Icon(Icons.person_outline_rounded, size: 16),
        ),
        Expanded(
          child: TextField(
            controller: controller,
            style: AppTypography.body,
            decoration: const InputDecoration(
              hintText: 'Your display name',
              isDense: true,
            ),
          ),
        ),
      ],
    );
  }
}

class _MenuButton extends StatefulWidget {
  const _MenuButton({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  State<_MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<_MenuButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.all(Spacing.lg),
          decoration: BoxDecoration(
            color: _hover
                ? widget.color.withValues(alpha: 0.10)
                : AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(Spacing.radiusMd),
            border: Border.all(
              color: _hover
                  ? widget.color.withValues(alpha: 0.6)
                  : AppColors.border,
            ),
            boxShadow: _hover
                ? [
                    BoxShadow(
                      color: widget.color.withValues(alpha: 0.18),
                      blurRadius: 16,
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: widget.color.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(Spacing.radiusSm),
                ),
                alignment: Alignment.center,
                child:
                    Icon(widget.icon, size: 16, color: widget.color),
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(widget.label, style: AppTypography.h4),
                    const SizedBox(height: 2),
                    Text(widget.subtitle, style: AppTypography.caption),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_rounded,
                  size: 14, color: widget.color),
            ],
          ),
        ),
      ),
    );
  }
}
