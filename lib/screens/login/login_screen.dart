// lib/screens/login/login_screen.dart
import 'package:flutter/material.dart';

import '../../app.dart';
import '../../core/models/player_role.dart';
import '../../core/services/role_service.dart';
import '../../core/theme/app_themes.dart';
import '../../core/theme/theme_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  PlayerRole _selected = PlayerRole.ceo;

  void _login() {
    RoleService.instance.setRole(_selected);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hq = context.hq;
    final roles = RoleService.instance.availableRoles;

    return Scaffold(
      backgroundColor: hq.page,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          ListenableBuilder(
            listenable: ThemeController.instance,
            builder: (context, _) => IconButton(
              tooltip: ThemeController.instance.isDark
                  ? 'Switch to Light'
                  : 'Switch to Dark',
              icon: Icon(
                ThemeController.instance.isDark
                    ? Icons.light_mode_rounded
                    : Icons.dark_mode_rounded,
                color: hq.secondaryText,
              ),
              onPressed: () => ThemeController.instance.toggle(context),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Logo ─────────────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: kBrandAmber,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Column(
                      children: [
                        Icon(Icons.business_center_rounded,
                            size: 56, color: Colors.black87),
                        SizedBox(height: 8),
                        Text(
                          'Headquartz',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Colors.black87,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          'Enterprise Resource Planning Simulator',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // ── Login card ───────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: hq.card,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: hq.border),
                      boxShadow: [
                        BoxShadow(
                          color: hq.shadow,
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('Sign in',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: hq.primaryText)),
                        const SizedBox(height: 4),
                        Text('Choose a role to continue',
                            style: TextStyle(
                                fontSize: 12, color: hq.secondaryText)),
                        const SizedBox(height: 20),

                        // Role dropdown
                        Container(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: hq.page,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: hq.border),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<PlayerRole>(
                              value: _selected,
                              isExpanded: true,
                              dropdownColor: hq.card,
                              icon: Icon(Icons.expand_more_rounded,
                                  color: hq.secondaryText),
                              items: roles
                                  .map((r) => DropdownMenuItem(
                                        value: r,
                                        child: Row(
                                          children: [
                                            Icon(_iconFor(r),
                                                size: 18,
                                                color: _colorFor(r)),
                                            const SizedBox(width: 10),
                                            Text(r.displayName,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w600,
                                                    color: hq.primaryText)),
                                          ],
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (r) {
                                if (r != null) setState(() => _selected = r);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        FilledButton.icon(
                          onPressed: _login,
                          style: FilledButton.styleFrom(
                            backgroundColor: kBrandAmber,
                            foregroundColor: Colors.black87,
                            padding:
                                const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: const Icon(Icons.login_rounded),
                          label: const Text('Login',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Demo build — no password required',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 11, color: hq.tertiaryText)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _colorFor(PlayerRole r) => switch (r) {
        PlayerRole.ceo => kBrandAmber,
        PlayerRole.hrManager => const Color(0xFF4DD0C4),
        PlayerRole.financeManager => const Color(0xFFFFD54F),
        PlayerRole.salesManager => const Color(0xFFCE93D8),
        PlayerRole.marketingManager => const Color(0xFF80CBC4),
        PlayerRole.productionManager => const Color(0xFFFF8A65),
        PlayerRole.warehouseManager => const Color(0xFF90CAF9),
        PlayerRole.logisticsManager => const Color(0xFFEF9A9A),
        PlayerRole.boardsChairman => const Color(0xFFA5D6A7),
      };

  IconData _iconFor(PlayerRole r) => switch (r) {
        PlayerRole.ceo => Icons.workspace_premium_rounded,
        PlayerRole.hrManager => Icons.people_rounded,
        PlayerRole.financeManager => Icons.account_balance_rounded,
        PlayerRole.salesManager => Icons.storefront_rounded,
        PlayerRole.marketingManager => Icons.campaign_rounded,
        PlayerRole.productionManager => Icons.factory_rounded,
        PlayerRole.warehouseManager => Icons.warehouse_rounded,
        PlayerRole.logisticsManager => Icons.local_shipping_rounded,
        PlayerRole.boardsChairman => Icons.gavel_rounded,
      };
}