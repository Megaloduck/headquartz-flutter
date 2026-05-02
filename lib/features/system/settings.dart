// lib/features/system/settings.dart
//
// Settings page — accessible from the SYSTEM section of every role's
// sidebar. Covers appearance, simulation, notifications, security and
// about. Follows the same ModuleScaffold / shared-widget conventions
// used throughout lib/features/**.

import 'package:flutter/material.dart';
import '../../widgets/shared_widgets.dart';
import '../../core/theme/theme_controller.dart';
import '../../core/theme/app_themes.dart';

const Color _sysColor = Color(0xFF90CAF9);

// ─────────────────────────────────────────────
// MAIN PAGE
// ─────────────────────────────────────────────

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // ── State ─────────────────────────────────────────────────────────

  // Appearance
  bool _compactSidebar   = false;
  bool _showSubtitles    = true;
  String _language       = 'English';

  // Simulation
  bool _autoSave         = true;
  bool _showHints        = true;
  bool _confirmActions   = true;
  String _simSpeed       = 'Normal';
  double _difficultyVal  = 2;

  // Notifications
  bool _notifKPIAlerts   = true;
  bool _notifTaskRemind  = true;
  bool _notifReports     = false;
  bool _notifSystem      = true;

  // Security
  bool _sessionTimeout   = true;
  String _timeoutMins    = '30 min';
  bool _activityLog      = true;

  @override
  Widget build(BuildContext context) {
    final hq = context.hq;

    return Scaffold(
      backgroundColor: hq.page,
      appBar: AppBar(
        backgroundColor: _sysColor,
        foregroundColor: Colors.black87,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Settings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            Text('System configuration',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400)),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: _resetAll,
            icon: const Icon(Icons.restart_alt_rounded,
                color: Colors.black54, size: 18),
            label: const Text('Reset',
                style: TextStyle(color: Colors.black54, fontSize: 13)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildAppearance(hq),
          const SizedBox(height: 16),
          _buildSimulation(hq),
          const SizedBox(height: 16),
          _buildNotifications(hq),
          const SizedBox(height: 16),
          _buildSecurity(hq),
          const SizedBox(height: 16),
          _buildAbout(hq),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // ── APPEARANCE ────────────────────────────────────────────────────

  Widget _buildAppearance(dynamic hq) {
    return _SettingsSection(
      icon: '🎨',
      title: 'Appearance',
      subtitle: 'Theme, layout & language',
      hq: hq,
      children: [
        // Theme toggle — reads from ThemeController
        ListenableBuilder(
          listenable: ThemeController.instance,
          builder: (context, _) => _SettingsTile(
            icon: Icons.dark_mode_rounded,
            iconColor: const Color(0xFF7E57C2),
            title: 'Dark Mode',
            subtitle: ThemeController.instance.isDark
                ? 'Currently using dark theme'
                : 'Currently using light theme',
            hq: hq,
            trailing: Switch(
              value: ThemeController.instance.isDark,
              activeColor: _sysColor,
              onChanged: (_) =>
                  ThemeController.instance.toggle(context),
            ),
          ),
        ),
        _divider(hq),

        _SettingsTile(
          icon: Icons.view_sidebar_rounded,
          iconColor: Colors.teal,
          title: 'Compact Sidebar',
          subtitle: 'Reduce sidebar padding for more screen space',
          hq: hq,
          trailing: Switch(
            value: _compactSidebar,
            activeColor: _sysColor,
            onChanged: (v) => setState(() => _compactSidebar = v),
          ),
        ),
        _divider(hq),

        _SettingsTile(
          icon: Icons.subtitles_rounded,
          iconColor: Colors.blueGrey,
          title: 'Show Menu Subtitles',
          subtitle: 'Display description text below menu items',
          hq: hq,
          trailing: Switch(
            value: _showSubtitles,
            activeColor: _sysColor,
            onChanged: (v) => setState(() => _showSubtitles = v),
          ),
        ),
        _divider(hq),

        _SettingsTile(
          icon: Icons.language_rounded,
          iconColor: Colors.blue,
          title: 'Language',
          subtitle: 'Interface display language',
          hq: hq,
          trailing: _DropdownChip(
            value: _language,
            items: const ['English', 'Español', 'Français', 'Deutsch', '中文'],
            onChanged: (v) => setState(() => _language = v),
            hq: hq,
          ),
        ),
      ],
    );
  }

  // ── SIMULATION ────────────────────────────────────────────────────

  Widget _buildSimulation(dynamic hq) {
    return _SettingsSection(
      icon: '🎮',
      title: 'Simulation',
      subtitle: 'Gameplay preferences & speed',
      hq: hq,
      children: [
        _SettingsTile(
          icon: Icons.save_rounded,
          iconColor: Colors.green,
          title: 'Auto-Save',
          subtitle: 'Automatically save simulation state every 5 minutes',
          hq: hq,
          trailing: Switch(
            value: _autoSave,
            activeColor: _sysColor,
            onChanged: (v) => setState(() => _autoSave = v),
          ),
        ),
        _divider(hq),

        _SettingsTile(
          icon: Icons.lightbulb_rounded,
          iconColor: Colors.amber,
          title: 'Show Hints',
          subtitle: 'Display contextual tips throughout the simulation',
          hq: hq,
          trailing: Switch(
            value: _showHints,
            activeColor: _sysColor,
            onChanged: (v) => setState(() => _showHints = v),
          ),
        ),
        _divider(hq),

        _SettingsTile(
          icon: Icons.check_circle_rounded,
          iconColor: Colors.orange,
          title: 'Confirm Actions',
          subtitle: 'Ask for confirmation before applying changes',
          hq: hq,
          trailing: Switch(
            value: _confirmActions,
            activeColor: _sysColor,
            onChanged: (v) => setState(() => _confirmActions = v),
          ),
        ),
        _divider(hq),

        _SettingsTile(
          icon: Icons.speed_rounded,
          iconColor: Colors.purple,
          title: 'Simulation Speed',
          subtitle: 'How fast time progresses in the simulation',
          hq: hq,
          trailing: _DropdownChip(
            value: _simSpeed,
            items: const ['Slow', 'Normal', 'Fast', 'Turbo'],
            onChanged: (v) => setState(() => _simSpeed = v),
            hq: hq,
          ),
        ),
        _divider(hq),

        // Difficulty slider
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.trending_up_rounded,
                      color: Colors.red, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Difficulty Level',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: hq.primaryText)),
                      Text(
                        _difficultyVal == 1
                            ? 'Easy — forgiving KPI targets'
                            : _difficultyVal == 2
                                ? 'Medium — balanced targets'
                                : _difficultyVal == 3
                                    ? 'Hard — tight margins'
                                    : 'Expert — no room for error',
                        style: TextStyle(
                            fontSize: 12, color: hq.secondaryText),
                      ),
                    ],
                  ),
                ),
              ]),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: _sysColor,
                  thumbColor: _sysColor,
                  overlayColor: _sysColor.withOpacity(0.15),
                  inactiveTrackColor: hq.border,
                ),
                child: Slider(
                  value: _difficultyVal,
                  min: 1,
                  max: 4,
                  divisions: 3,
                  label: ['Easy', 'Medium', 'Hard', 'Expert']
                      [_difficultyVal.round() - 1],
                  onChanged: (v) =>
                      setState(() => _difficultyVal = v),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── NOTIFICATIONS ─────────────────────────────────────────────────

  Widget _buildNotifications(dynamic hq) {
    return _SettingsSection(
      icon: '🔔',
      title: 'Notifications',
      subtitle: 'In-app alert preferences',
      hq: hq,
      children: [
        _SettingsTile(
          icon: Icons.show_chart_rounded,
          iconColor: Colors.red,
          title: 'KPI Alerts',
          subtitle: 'Notify when a KPI crosses a threshold',
          hq: hq,
          trailing: Switch(
            value: _notifKPIAlerts,
            activeColor: _sysColor,
            onChanged: (v) => setState(() => _notifKPIAlerts = v),
          ),
        ),
        _divider(hq),

        _SettingsTile(
          icon: Icons.task_alt_rounded,
          iconColor: Colors.blue,
          title: 'Task Reminders',
          subtitle: 'Remind before scheduled simulation events',
          hq: hq,
          trailing: Switch(
            value: _notifTaskRemind,
            activeColor: _sysColor,
            onChanged: (v) => setState(() => _notifTaskRemind = v),
          ),
        ),
        _divider(hq),

        _SettingsTile(
          icon: Icons.analytics_rounded,
          iconColor: Colors.teal,
          title: 'Report Summaries',
          subtitle: 'Weekly digest of department performance',
          hq: hq,
          trailing: Switch(
            value: _notifReports,
            activeColor: _sysColor,
            onChanged: (v) => setState(() => _notifReports = v),
          ),
        ),
        _divider(hq),

        _SettingsTile(
          icon: Icons.info_outline_rounded,
          iconColor: Colors.orange,
          title: 'System Notices',
          subtitle: 'Updates, maintenance and version alerts',
          hq: hq,
          trailing: Switch(
            value: _notifSystem,
            activeColor: _sysColor,
            onChanged: (v) => setState(() => _notifSystem = v),
          ),
        ),
      ],
    );
  }

  // ── SECURITY ──────────────────────────────────────────────────────

  Widget _buildSecurity(dynamic hq) {
    return _SettingsSection(
      icon: '🔒',
      title: 'Security',
      subtitle: 'Session and access control',
      hq: hq,
      children: [
        _SettingsTile(
          icon: Icons.timer_off_rounded,
          iconColor: Colors.orange,
          title: 'Session Timeout',
          subtitle: 'Auto-logout after a period of inactivity',
          hq: hq,
          trailing: Switch(
            value: _sessionTimeout,
            activeColor: _sysColor,
            onChanged: (v) => setState(() => _sessionTimeout = v),
          ),
        ),
        if (_sessionTimeout) ...[
          _divider(hq),
          _SettingsTile(
            icon: Icons.hourglass_bottom_rounded,
            iconColor: Colors.amber,
            title: 'Timeout Duration',
            subtitle: 'Inactivity period before automatic logout',
            hq: hq,
            trailing: _DropdownChip(
              value: _timeoutMins,
              items: const ['10 min', '15 min', '30 min', '60 min'],
              onChanged: (v) => setState(() => _timeoutMins = v),
              hq: hq,
            ),
          ),
        ],
        _divider(hq),

        _SettingsTile(
          icon: Icons.history_rounded,
          iconColor: Colors.purple,
          title: 'Activity Log',
          subtitle: 'Record user actions for audit purposes',
          hq: hq,
          trailing: Switch(
            value: _activityLog,
            activeColor: _sysColor,
            onChanged: (v) => setState(() => _activityLog = v),
          ),
        ),
        _divider(hq),

        _SettingsTile(
          icon: Icons.password_rounded,
          iconColor: Colors.red,
          title: 'Change Password',
          subtitle: 'Update your simulation account password',
          hq: hq,
          trailing: Icon(Icons.chevron_right_rounded,
              color: hq.secondaryText),
          onTap: () {},
        ),
      ],
    );
  }

  // ── ABOUT ─────────────────────────────────────────────────────────

  Widget _buildAbout(dynamic hq) {
    return _SettingsSection(
      icon: 'ℹ️',
      title: 'About',
      subtitle: 'Version and credits',
      hq: hq,
      children: [
        _InfoRow(label: 'Application',    value: 'Headquartz ERP Simulator', hq: hq),
        _divider(hq),
        _InfoRow(label: 'Version',        value: '1.0.0',                    hq: hq),
        _divider(hq),
        _InfoRow(label: 'Build',          value: 'Flutter 3.x — Stable',     hq: hq),
        _divider(hq),
        _InfoRow(label: 'Platform',       value: 'Multi-platform',           hq: hq),
        _divider(hq),
        _SettingsTile(
          icon: Icons.description_rounded,
          iconColor: Colors.teal,
          title: 'Licenses',
          subtitle: 'Open-source component licenses',
          hq: hq,
          trailing: Icon(Icons.chevron_right_rounded,
              color: hq.secondaryText),
          onTap: () => showLicensePage(context: context),
        ),
      ],
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────

  Widget _divider(dynamic hq) => Divider(
      height: 1, indent: 16, endIndent: 16, color: hq.border);

  void _resetAll() {
    setState(() {
      _compactSidebar  = false;
      _showSubtitles   = true;
      _language        = 'English';
      _autoSave        = true;
      _showHints       = true;
      _confirmActions  = true;
      _simSpeed        = 'Normal';
      _difficultyVal   = 2;
      _notifKPIAlerts  = true;
      _notifTaskRemind = true;
      _notifReports    = false;
      _notifSystem     = true;
      _sessionTimeout  = true;
      _timeoutMins     = '30 min';
      _activityLog     = true;
    });
  }
}

// ─────────────────────────────────────────────
// SETTINGS SECTION CARD
// ─────────────────────────────────────────────

class _SettingsSection extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final List<Widget> children;
  final dynamic hq;

  const _SettingsSection({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.children,
    required this.hq,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: hq.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: hq.border),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                Text(icon,
                    style: const TextStyle(fontSize: 22)),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: hq.primaryText)),
                    Text(subtitle,
                        style: TextStyle(
                            fontSize: 12, color: hq.secondaryText)),
                  ],
                ),
              ],
            ),
          ),
          Divider(height: 1, color: hq.border),
          ...children,
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SETTINGS TILE
// ─────────────────────────────────────────────

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback? onTap;
  final dynamic hq;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.hq,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: hq.primaryText)),
                  Text(subtitle,
                      style: TextStyle(
                          fontSize: 12, color: hq.secondaryText)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            trailing,
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// INFO ROW
// ─────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final dynamic hq;

  const _InfoRow(
      {required this.label, required this.value, required this.hq});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: hq.secondaryText)),
          Text(value,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: hq.primaryText)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// DROPDOWN CHIP
// ─────────────────────────────────────────────

class _DropdownChip extends StatelessWidget {
  final String value;
  final List<String> items;
  final void Function(String) onChanged;
  final dynamic hq;

  const _DropdownChip({
    required this.value,
    required this.items,
    required this.onChanged,
    required this.hq,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: _sysColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _sysColor.withOpacity(0.3)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          dropdownColor: hq.card,
          icon: Icon(Icons.expand_more_rounded,
              size: 16, color: hq.secondaryText),
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: hq.primaryText),
          items: items
              .map((i) => DropdownMenuItem(value: i, child: Text(i)))
              .toList(),
          onChanged: (v) => onChanged(v ?? value),
        ),
      ),
    );
  }
}