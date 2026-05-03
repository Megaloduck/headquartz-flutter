import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../bootstrap/dependency_injection.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/widgets/animated_background.dart';
import '../../../../core/widgets/app_window.dart';
import '../../../../core/widgets/glass_panel.dart';
import '../../../../core/widgets/loading_overlay.dart';

class HostSetupScreen extends ConsumerStatefulWidget {
  const HostSetupScreen({super.key});

  @override
  ConsumerState<HostSetupScreen> createState() => _HostSetupScreenState();
}

class _HostSetupScreenState extends ConsumerState<HostSetupScreen> {
  late final TextEditingController _sessionCtrl =
      TextEditingController(text: 'My Headquartz Session');
  late final TextEditingController _companyCtrl =
      TextEditingController(text: 'Quartzon Industries');
  bool _starting = false;
  String? _error;

  @override
  void dispose() {
    _sessionCtrl.dispose();
    _companyCtrl.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    if (_starting) return;
    setState(() {
      _starting = true;
      _error = null;
    });
    try {
      final id = ref.read(playerIdentityProvider);
      await ref.read(networkSessionProvider.notifier).startHost(
            hostName: id.name,
            sessionName: _sessionCtrl.text.trim().isEmpty
                ? 'Headquartz Session'
                : _sessionCtrl.text.trim(),
            companyName: _companyCtrl.text.trim().isEmpty
                ? 'Quartzon Industries'
                : _companyCtrl.text.trim(),
          );
      if (mounted) context.go(Routes.lobbyRoom);
    } catch (e) {
      setState(() => _error = '$e');
    } finally {
      if (mounted) setState(() => _starting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDeep,
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(
                  height: Spacing.topbarHeight,
                  child: WindowDragArea(child: SizedBox.expand())),
              Expanded(
                child: AnimatedBackground(
                  accent: AppColors.success,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: Padding(
                        padding: const EdgeInsets.all(Spacing.xxl),
                        child: GlassPanel(
                          padding: const EdgeInsets.all(Spacing.huge),
                          glowColor: AppColors.success,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
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
                                  Text('HOST LAN SESSION',
                                      style: AppTypography.h2.copyWith(
                                          letterSpacing: 3,
                                          color: AppColors.success)),
                                ],
                              ),
                              const SizedBox(height: Spacing.xl),
                              Text(
                                'You\'ll act as the authoritative simulation host. Other players on your LAN will discover and join.',
                                style: AppTypography.bodySmall,
                              ),
                              const SizedBox(height: Spacing.xxl),
                              _LabeledField(
                                label: 'Session Name',
                                controller: _sessionCtrl,
                              ),
                              const SizedBox(height: Spacing.lg),
                              _LabeledField(
                                label: 'Company Name',
                                controller: _companyCtrl,
                              ),
                              const SizedBox(height: Spacing.xl),
                              if (_error != null)
                                Padding(
                                  padding:
                                      const EdgeInsets.only(bottom: Spacing.md),
                                  child: Container(
                                    padding: const EdgeInsets.all(Spacing.md),
                                    decoration: BoxDecoration(
                                      color: AppColors.danger
                                          .withValues(alpha: 0.1),
                                      borderRadius:
                                          BorderRadius.circular(Spacing.radiusSm),
                                      border: Border.all(
                                          color: AppColors.danger
                                              .withValues(alpha: 0.4)),
                                    ),
                                    child: Text(_error!,
                                        style: AppTypography.bodySmall
                                            .copyWith(color: AppColors.danger)),
                                  ),
                                ),
                              ElevatedButton.icon(
                                onPressed: _starting ? null : _start,
                                icon: const Icon(Icons.play_arrow_rounded,
                                    size: 16),
                                label: const Text('CREATE LOBBY'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.success,
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
          if (_starting) const LoadingOverlay(message: 'Starting host…'),
        ],
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({required this.label, required this.controller});
  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(),
            style: AppTypography.label),
        const SizedBox(height: Spacing.xs),
        TextField(
          controller: controller,
          style: AppTypography.body,
        ),
      ],
    );
  }
}
