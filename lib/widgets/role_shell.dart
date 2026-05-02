// lib/widgets/role_shell.dart
//
// Shared sidebar + split-screen shell used by every role screen.
//
// Usage in a role screen:
//
//   class HrScreen extends StatelessWidget {
//     const HrScreen({super.key});
//
//     static Widget _resolve(DepartmentModule m) => switch (m.name) {
//       'HR Dashboard' => const HrDashboardPage(),
//       ...
//       _ => ModulePage(moduleName: m.name, ...),
//     };
//
//     @override
//     Widget build(BuildContext context) {
//       final dept = departments.firstWhere((d) => d.name == 'Human Resources');
//       return RoleShell(department: dept, moduleResolver: _resolve);
//     }
//   }

import 'package:flutter/material.dart';

import '../app.dart';                          // Department, DepartmentModule, departments
import '../core/theme/app_themes.dart';
import '../core/theme/theme_controller.dart';
import '../features/system/user_management.dart';
import '../features/system/settings.dart';

// ─────────────────────────────────────────────
// SIDEBAR PALETTE
// ─────────────────────────────────────────────

const Color _kSidebarBg   = Color(0xFF16182A);
const Color _kHeaderBg    = Color(0xFF0F1019);
const Color _kNavActive   = Color(0xFF252840);
const Color _kNavHover    = Color(0xFF1E2035);
const Color _kSidebarText = Color(0xFFE8E9F3);
const Color _kSidebarSub  = Color(0xFF8B8FA8);
const Color _kSidebarDiv  = Color(0xFF252838);

// ═════════════════════════════════════════════
// ROLE SHELL
// Split layout: sidebar (260 px) + content area (*)
// The `moduleResolver` callback is supplied by each role screen.
// ═════════════════════════════════════════════

class RoleShell extends StatefulWidget {
  /// The department this shell represents.
  final Department department;

  /// Maps a tapped sidebar module to the Widget that fills the right panel.
  /// Each role screen implements this with its own switch.
  final Widget Function(DepartmentModule module) moduleResolver;

  const RoleShell({
    super.key,
    required this.department,
    required this.moduleResolver,
  });

  @override
  State<RoleShell> createState() => _RoleShellState();
}

class _RoleShellState extends State<RoleShell> {
  String _activePage = 'Dashboard';
  late Widget _activeContent;

  @override
  void initState() {
    super.initState();
    _activeContent =
        _placeholder('Dashboard', 'Analytics overview', kBrandAmber);
  }

  Widget _placeholder(String name, String subtitle, Color color) =>
      ModulePage(
        moduleName: name,
        departmentName: 'Company',
        subtitle: subtitle,
        color: color,
      );

  void _navigate(String name, Widget content) =>
      setState(() {
        _activePage    = name;
        _activeContent = content;
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // ── Left sidebar (260 px fixed) ─────────────────────────
          _HqSidebar(
            department: widget.department,
            activePage: _activePage,
            onBack: () => Navigator.of(context).pop(),
            onDashboard: () => _navigate(
              'Dashboard',
              _placeholder('Dashboard', 'Analytics overview', kBrandAmber),
            ),
            onOverview: () => _navigate(
              'Overview',
              _placeholder('Overview', 'Company snapshot', kBrandAmber),
            ),
            onModuleTap: (m) =>
                _navigate(m.name, widget.moduleResolver(m)),
            onUserManagement: () =>
                _navigate('User Management', const UserManagementPage()),
            onSettings: () =>
                _navigate('Settings', const SettingsPage()),
          ),

          // ── Right content area (*) ──────────────────────────────
          Expanded(child: _activeContent),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════
// _HqSidebar — outer 260 px container
// ═════════════════════════════════════════════

class _HqSidebar extends StatelessWidget {
  final Department department;
  final String activePage;
  final VoidCallback onBack;
  final VoidCallback onDashboard;
  final VoidCallback onOverview;
  final void Function(DepartmentModule) onModuleTap;
  final VoidCallback onUserManagement;
  final VoidCallback onSettings;

  const _HqSidebar({
    required this.department,
    required this.activePage,
    required this.onBack,
    required this.onDashboard,
    required this.onOverview,
    required this.onModuleTap,
    required this.onUserManagement,
    required this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: Column(
        children: [
          _SidebarHeader(department: department, onBack: onBack),
          Expanded(
            child: Container(
              color: _kSidebarBg,
              child: _SidebarNav(
                department: department,
                activePage: activePage,
                onDashboard: onDashboard,
                onOverview: onOverview,
                onModuleTap: onModuleTap,
                onUserManagement: onUserManagement,
                onSettings: onSettings,
              ),
            ),
          ),
          const _SidebarFooter(),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SIDEBAR HEADER
// ─────────────────────────────────────────────

class _SidebarHeader extends StatelessWidget {
  final Department department;
  final VoidCallback onBack;
  const _SidebarHeader(
      {required this.department, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _kHeaderBg,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back + app name row
          Row(
            children: [
              InkWell(
                onTap: onBack,
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(Icons.arrow_back_ios_new_rounded,
                      size: 14, color: _kSidebarSub),
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'Headquartz',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: kBrandAmber,
                    letterSpacing: 0.5),
              ),
              const Spacer(),
              // Theme toggle lives in the sidebar header
              ListenableBuilder(
                listenable: ThemeController.instance,
                builder: (ctx, _) => InkWell(
                  onTap: () => ThemeController.instance.toggle(ctx),
                  borderRadius: BorderRadius.circular(6),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      ThemeController.instance.isDark
                          ? Icons.light_mode_rounded
                          : Icons.dark_mode_rounded,
                      size: 16,
                      color: _kSidebarSub,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Department pill
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: department.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: department.color.withOpacity(0.4)),
            ),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: department.color.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Center(
                      child: Text('👤',
                          style: TextStyle(fontSize: 14))),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    department.managerRole,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _kSidebarText),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          Container(height: 1, color: _kSidebarDiv),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SIDEBAR NAV  — MAIN MENU / TOOLS / SYSTEM
// ─────────────────────────────────────────────

class _SidebarNav extends StatelessWidget {
  final Department department;
  final String activePage;
  final VoidCallback onDashboard;
  final VoidCallback onOverview;
  final void Function(DepartmentModule) onModuleTap;
  final VoidCallback onUserManagement;
  final VoidCallback onSettings;

  const _SidebarNav({
    required this.department,
    required this.activePage,
    required this.onDashboard,
    required this.onOverview,
    required this.onModuleTap,
    required this.onUserManagement,
    required this.onSettings,
  });

  Widget _divider() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Container(height: 1, color: _kSidebarDiv),
      );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── MAIN MENU ────────────────────────────────────────────
          const _SidebarSectionLabel('MAIN MENU'),
          _SidebarNavItem(
            emoji: '📊',
            title: 'Dashboard',
            subtitle: 'Analytics overview',
            isActive: activePage == 'Dashboard',
            accentColor: kBrandAmber,
            onTap: onDashboard,
          ),
          _SidebarNavItem(
            emoji: '🏠',
            title: 'Overview',
            subtitle: 'Company snapshot',
            isActive: activePage == 'Overview',
            accentColor: kBrandAmber,
            onTap: onOverview,
          ),

          _divider(),

          // ── TOOLS ────────────────────────────────────────────────
          const _SidebarSectionLabel('TOOLS'),
          ...department.modules.map((m) => _SidebarNavItem(
                emoji: m.emoji,
                title: m.name,
                subtitle: m.subtitle,
                isActive: activePage == m.name,
                accentColor: department.color,
                onTap: () => onModuleTap(m),
              )),

          _divider(),

          // ── SYSTEM ───────────────────────────────────────────────
          const _SidebarSectionLabel('SYSTEM'),
          _SidebarNavItem(
            emoji: '👨‍💼',
            title: 'User Management',
            subtitle: 'Access and permissions',
            isActive: activePage == 'User Management',
            accentColor: const Color(0xFF90CAF9),
            onTap: onUserManagement,
          ),
          _SidebarNavItem(
            emoji: '⚙️',
            title: 'Settings',
            subtitle: 'System configuration',
            isActive: activePage == 'Settings',
            accentColor: const Color(0xFF90CAF9),
            onTap: onSettings,
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SIDEBAR SECTION LABEL
// ─────────────────────────────────────────────

class _SidebarSectionLabel extends StatelessWidget {
  final String text;
  const _SidebarSectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: _kSidebarSub,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SIDEBAR NAV ITEM
// ─────────────────────────────────────────────

class _SidebarNavItem extends StatefulWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final bool isActive;
  final Color accentColor;
  final VoidCallback onTap;

  const _SidebarNavItem({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.isActive,
    required this.accentColor,
    required this.onTap,
  });

  @override
  State<_SidebarNavItem> createState() => _SidebarNavItemState();
}

class _SidebarNavItemState extends State<_SidebarNavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final bg = widget.isActive
        ? _kNavActive
        : _hovered
            ? _kNavHover
            : Colors.transparent;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(vertical: 1),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(8),
            border: widget.isActive
                ? Border(
                    left: BorderSide(
                        color: widget.accentColor, width: 3))
                : null,
          ),
          padding: EdgeInsets.fromLTRB(
              widget.isActive ? 9 : 12, 9, 12, 9),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: widget.isActive
                      ? widget.accentColor.withOpacity(0.2)
                      : _kSidebarDiv,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Center(
                  child: Text(widget.emoji,
                      style: const TextStyle(fontSize: 15)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: widget.isActive
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: widget.isActive
                            ? Colors.white
                            : _kSidebarText,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 1),
                    Text(
                      widget.subtitle,
                      style: TextStyle(
                        fontSize: 10,
                        color: widget.isActive
                            ? _kSidebarText.withOpacity(0.6)
                            : _kSidebarSub,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SIDEBAR FOOTER
// ─────────────────────────────────────────────

class _SidebarFooter extends StatelessWidget {
  const _SidebarFooter();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _kHeaderBg,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        children: [
          Container(height: 1, color: _kSidebarDiv),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                    color: Color(0xFF4CAF50),
                    shape: BoxShape.circle),
                child: const Center(
                  child: Text('✓',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w800)),
                ),
              ),
              const SizedBox(width: 6),
              const Text('v1.0.0 • Production Ready',
                  style: TextStyle(
                      fontSize: 11, color: _kSidebarSub)),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// MODULE PAGE — fallback placeholder
// Used for Dashboard / Overview and any unresolved module.
// ─────────────────────────────────────────────

class ModulePage extends StatelessWidget {
  final String moduleName;
  final String departmentName;
  final String subtitle;
  final Color color;

  const ModulePage({
    super.key,
    required this.moduleName,
    required this.departmentName,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final hq = context.hq;
    return Scaffold(
      backgroundColor: hq.page,
      appBar: AppBar(
        backgroundColor: color,
        foregroundColor: Colors.black87,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(moduleName,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w700)),
            Text(departmentName,
                style: const TextStyle(
                    fontSize: 11, fontWeight: FontWeight.w400)),
          ],
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.filter_list_rounded),
              onPressed: () {}),
          IconButton(
              icon: const Icon(Icons.more_vert_rounded),
              onPressed: () {}),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  shape: BoxShape.circle),
              child: Icon(Icons.construction_rounded,
                  size: 36, color: color),
            ),
            const SizedBox(height: 20),
            Text(moduleName,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: hq.primaryText)),
            const SizedBox(height: 6),
            Text(subtitle,
                style: TextStyle(
                    fontSize: 14, color: hq.secondaryText)),
            const SizedBox(height: 4),
            Text('$departmentName  •  Coming soon',
                style: TextStyle(
                    fontSize: 12, color: hq.tertiaryText)),
          ],
        ),
      ),
    );
  }
}