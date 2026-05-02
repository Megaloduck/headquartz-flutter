// lib/features/system/user_management.dart
//
// User Management page — accessible from the SYSTEM section of
// every role's sidebar.  Follows the same ModuleScaffold / shared-
// widget conventions used throughout lib/features/**.
//
// Sections
//   • Stats grid  (Total Users, Active, Roles, Pending Invites)
//   • Search + filter bar
//   • User roster  (DataRowTile-style cards with role badge & status)
//   • Role & Permission matrix

import 'package:flutter/material.dart';
import '../../widgets/shared_widgets.dart';
import '../../core/theme/app_themes.dart';

const Color _sysColor = Color(0xFF90CAF9); // matches sidebar accent

// ─────────────────────────────────────────────
// DATA MODEL
// ─────────────────────────────────────────────

enum _UserStatus { active, inactive, pending }

class _UserRecord {
  final String name;
  final String email;
  final String role;
  final String department;
  final _UserStatus status;
  final String lastLogin;
  final IconData avatar;

  const _UserRecord({
    required this.name,
    required this.email,
    required this.role,
    required this.department,
    required this.status,
    required this.lastLogin,
    required this.avatar,
  });
}

const List<_UserRecord> _mockUsers = [
  _UserRecord(name: 'Alexandra Chen',   email: 'a.chen@headquartz.com',    role: 'CEO',                department: 'Executive',       status: _UserStatus.active,   lastLogin: '2 min ago',   avatar: Icons.person_rounded),
  _UserRecord(name: 'Marcus Williams',  email: 'm.williams@headquartz.com', role: 'HR Manager',         department: 'Human Resources', status: _UserStatus.active,   lastLogin: '1 hr ago',    avatar: Icons.person_rounded),
  _UserRecord(name: 'Priya Nair',       email: 'p.nair@headquartz.com',     role: 'Finance Manager',    department: 'Finance',         status: _UserStatus.active,   lastLogin: '3 hrs ago',   avatar: Icons.person_rounded),
  _UserRecord(name: 'James O\'Brien',   email: 'j.obrien@headquartz.com',   role: 'Sales Manager',      department: 'Sales',           status: _UserStatus.active,   lastLogin: 'Yesterday',   avatar: Icons.person_rounded),
  _UserRecord(name: 'Sofia Martinez',   email: 's.martinez@headquartz.com', role: 'Marketing Manager',  department: 'Marketing',       status: _UserStatus.inactive, lastLogin: '3 days ago',  avatar: Icons.person_rounded),
  _UserRecord(name: 'David Park',       email: 'd.park@headquartz.com',     role: 'Production Manager', department: 'Production',      status: _UserStatus.active,   lastLogin: '5 hrs ago',   avatar: Icons.person_rounded),
  _UserRecord(name: 'Lisa Thompson',    email: 'l.thompson@headquartz.com', role: 'Warehouse Manager',  department: 'Warehouse',       status: _UserStatus.active,   lastLogin: '2 hrs ago',   avatar: Icons.person_rounded),
  _UserRecord(name: 'Ravi Patel',       email: 'r.patel@headquartz.com',    role: 'Logistics Manager',  department: 'Logistics',       status: _UserStatus.pending,  lastLogin: 'Never',       avatar: Icons.person_rounded),
  _UserRecord(name: 'Eleanor Voss',     email: 'e.voss@headquartz.com',     role: "Boards Chairman",    department: 'Management',      status: _UserStatus.active,   lastLogin: '1 day ago',   avatar: Icons.person_rounded),
];

// Permission matrix rows
const List<(String, List<bool>)> _permMatrix = [
  ('View Department Data',     [true,  true,  true,  true,  true,  true,  true,  true,  true ]),
  ('Edit Department Data',     [true,  true,  true,  true,  true,  true,  true,  true,  false]),
  ('Approve Transactions',     [true,  true,  true,  false, false, false, false, false, true ]),
  ('Run Simulations',          [true,  false, false, false, false, false, false, false, true ]),
  ('Export Reports',           [true,  true,  true,  true,  true,  true,  true,  true,  true ]),
  ('Manage Users',             [true,  false, false, false, false, false, false, false, false]),
  ('System Settings',          [true,  false, false, false, false, false, false, false, false]),
  ('View All Departments',     [true,  false, false, false, false, false, false, false, true ]),
];

const List<String> _roleHeaders = ['CEO', 'HR', 'Fin', 'Sales', 'Mktg', 'Prod', 'WH', 'Log', 'Chair'];

// ─────────────────────────────────────────────
// MAIN PAGE
// ─────────────────────────────────────────────

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;
  String _search = '';

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  List<_UserRecord> get _filtered => _mockUsers
      .where((u) =>
          u.name.toLowerCase().contains(_search.toLowerCase()) ||
          u.role.toLowerCase().contains(_search.toLowerCase()) ||
          u.department.toLowerCase().contains(_search.toLowerCase()))
      .toList();

  // ── Status helpers ────────────────────────────────────────────────

  Color _statusColor(_UserStatus s) => switch (s) {
        _UserStatus.active   => Colors.green,
        _UserStatus.inactive => Colors.orange,
        _UserStatus.pending  => Colors.blue,
      };

  String _statusLabel(_UserStatus s) => switch (s) {
        _UserStatus.active   => 'Active',
        _UserStatus.inactive => 'Inactive',
        _UserStatus.pending  => 'Pending',
      };

  // ── Build ─────────────────────────────────────────────────────────

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
            Text('User Management',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            Text('Access & permissions',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400)),
          ],
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.person_add_rounded),
              tooltip: 'Invite User',
              onPressed: () => _showInviteDialog(context)),
          IconButton(
              icon: const Icon(Icons.more_vert_rounded), onPressed: () {}),
        ],
        bottom: TabBar(
          controller: _tabs,
          indicatorColor: Colors.black87,
          labelColor: Colors.black87,
          unselectedLabelColor: Colors.black54,
          tabs: const [
            Tab(text: 'Users'),
            Tab(text: 'Permissions'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: _sysColor,
        foregroundColor: Colors.black87,
        onPressed: () => _showInviteDialog(context),
        icon: const Icon(Icons.person_add_rounded),
        label: const Text('Invite User'),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          _buildUsersTab(hq),
          _buildPermissionsTab(hq),
        ],
      ),
    );
  }

  // ── USERS TAB ─────────────────────────────────────────────────────

  Widget _buildUsersTab(dynamic hq) {
    final active   = _mockUsers.where((u) => u.status == _UserStatus.active).length;
    final inactive = _mockUsers.where((u) => u.status == _UserStatus.inactive).length;
    final pending  = _mockUsers.where((u) => u.status == _UserStatus.pending).length;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Stats
        StatsGrid(cards: [
          StatCard(label: 'Total Users',     value: '${_mockUsers.length}', icon: Icons.people_rounded,           color: _sysColor),
          StatCard(label: 'Active',          value: '$active',              icon: Icons.check_circle_rounded,     color: Colors.green),
          StatCard(label: 'Inactive',        value: '$inactive',            icon: Icons.pause_circle_rounded,     color: Colors.orange),
          StatCard(label: 'Pending Invite',  value: '$pending',             icon: Icons.mail_outline_rounded,     color: Colors.blue),
        ]),
        const SizedBox(height: 20),

        // Search bar
        HqSearchField(
          hint: 'Search users, roles, departments…',
          onChanged: (v) => setState(() => _search = v),
        ),
        const SizedBox(height: 16),

        // User list
        SectionHeader(
          title: 'All Users (${_filtered.length})',
          actionLabel: 'Export',
          onAction: () {},
        ),
        const SizedBox(height: 8),

        ..._filtered.map((u) => _UserTile(
              user: u,
              statusColor: _statusColor(u.status),
              statusLabel: _statusLabel(u.status),
              onEdit: () => _showEditDialog(context, u),
            )),
      ],
    );
  }

  // ── PERMISSIONS TAB ───────────────────────────────────────────────

  Widget _buildPermissionsTab(dynamic hq) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SectionHeader(title: 'Role Permission Matrix'),
        const SizedBox(height: 4),
        Text(
          'Read-only overview of what each role can do across the system.',
          style: TextStyle(fontSize: 12, color: hq.secondaryText),
        ),
        const SizedBox(height: 16),
        _PermissionMatrix(hq: hq),
        const SizedBox(height: 24),

        // Role cards
        const SectionHeader(title: 'Role Descriptions'),
        const SizedBox(height: 12),
        ..._roleDescriptions.map((r) => _RoleDescCard(
              role: r.$1,
              description: r.$2,
              color: r.$3,
              hq: hq,
            )),
      ],
    );
  }

  // ── DIALOGS ───────────────────────────────────────────────────────

  void _showInviteDialog(BuildContext context) {
    final hq = context.hq;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: hq.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Invite New User',
            style: TextStyle(color: hq.primaryText, fontWeight: FontWeight.w700)),
        content: SizedBox(
          width: 360,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _DialogField(label: 'Full Name', hint: 'e.g. Jane Smith', hq: hq),
              const SizedBox(height: 12),
              _DialogField(label: 'Email Address', hint: 'jane@company.com', hq: hq),
              const SizedBox(height: 12),
              _RoleDropdown(hq: hq),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: hq.secondaryText)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: _sysColor, foregroundColor: Colors.black87),
            onPressed: () => Navigator.pop(context),
            child: const Text('Send Invite'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, _UserRecord user) {
    final hq = context.hq;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: hq.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Edit User — ${user.name}',
            style: TextStyle(color: hq.primaryText, fontWeight: FontWeight.w700)),
        content: SizedBox(
          width: 360,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _DialogField(label: 'Full Name',      hint: user.name,  hq: hq, initial: user.name),
              const SizedBox(height: 12),
              _DialogField(label: 'Email Address',  hint: user.email, hq: hq, initial: user.email),
              const SizedBox(height: 12),
              _RoleDropdown(hq: hq, initial: user.role),
              const SizedBox(height: 12),
              _StatusDropdown(hq: hq, initial: user.status),
            ],
          ),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () => Navigator.pop(context),
            child: const Text('Deactivate'),
          ),
          const Spacer(),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: hq.secondaryText)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: _sysColor, foregroundColor: Colors.black87),
            onPressed: () => Navigator.pop(context),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// USER TILE
// ─────────────────────────────────────────────

class _UserTile extends StatelessWidget {
  final _UserRecord user;
  final Color statusColor;
  final String statusLabel;
  final VoidCallback onEdit;

  const _UserTile({
    required this.user,
    required this.statusColor,
    required this.statusLabel,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final hq = context.hq;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: hq.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: hq.border),
      ),
      child: Row(
        children: [
          // Avatar circle
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: _sysColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(user.avatar, color: _sysColor, size: 22),
          ),
          const SizedBox(width: 12),

          // Name + role + dept
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: hq.primaryText)),
                const SizedBox(height: 2),
                Text('${user.role}  •  ${user.department}',
                    style:
                        TextStyle(fontSize: 12, color: hq.secondaryText)),
                const SizedBox(height: 4),
                Text('Last login: ${user.lastLogin}',
                    style:
                        TextStyle(fontSize: 11, color: hq.tertiaryText)),
              ],
            ),
          ),

          // Status badge
          StatusBadge(label: statusLabel, color: statusColor),
          const SizedBox(width: 8),

          // Edit button
          IconButton(
            icon: Icon(Icons.edit_rounded, size: 18, color: hq.secondaryText),
            onPressed: onEdit,
            tooltip: 'Edit user',
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// PERMISSION MATRIX TABLE
// ─────────────────────────────────────────────

class _PermissionMatrix extends StatelessWidget {
  final dynamic hq;
  const _PermissionMatrix({required this.hq});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: hq.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: hq.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(
                _sysColor.withOpacity(0.12)),
            dataRowMinHeight: 40,
            dataRowMaxHeight: 40,
            columnSpacing: 12,
            headingTextStyle: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: hq.primaryText),
            dataTextStyle:
                TextStyle(fontSize: 12, color: hq.primaryText),
            columns: [
              const DataColumn(label: Text('Permission')),
              ..._roleHeaders
                  .map((r) => DataColumn(label: Text(r))),
            ],
            rows: _permMatrix
                .map((row) => DataRow(cells: [
                      DataCell(Text(row.$1,
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500))),
                      ...row.$2.map((v) => DataCell(
                            Icon(
                              v ? Icons.check_rounded : Icons.remove_rounded,
                              size: 16,
                              color: v
                                  ? Colors.green
                                  : hq.tertiaryText,
                            ),
                          )),
                    ]))
                .toList(),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// ROLE DESCRIPTION CARDS
// ─────────────────────────────────────────────

const List<(String, String, Color)> _roleDescriptions = [
  ('CEO',                 'Full system access. Can manage users, run simulations and view all departments.',       Color(0xFFFFD54F)),
  ('Boards Chairman',     'Cross-department read access with executive report views. No data editing.',            Color(0xFFA5D6A7)),
  ('HR Manager',          'Full HR module access: employees, payroll, recruitment, training and HR reports.',      Color(0xFF4DD0C4)),
  ('Finance Manager',     'Accounts payable/receivable, loans, budget allocation, audits and finance reports.',    Color(0xFF80CBC4)),
  ('Sales Manager',       'Client management, leads, orders, pipeline, incentives and sales reports.',             Color(0xFFFFCC80)),
  ('Marketing Manager',   'Campaigns, market research, pricing, product research, branding and marketing reports.',Color(0xFFCE93D8)),
  ('Production Manager',  'Work orders, line management, resource planning, maintenance, QC and production reports.', Color(0xFFFF8A65)),
  ('Warehouse Manager',   'Inventory, stock in/out, flow management, storage allocation and warehouse reports.',   Color(0xFF90CAF9)),
  ('Logistics Manager',   'Shipments, delivery tracking, route planning, SLA, fleet and logistics reports.',       Color(0xFFF48FB1)),
];

class _RoleDescCard extends StatelessWidget {
  final String role;
  final String description;
  final Color color;
  final dynamic hq;

  const _RoleDescCard({
    required this.role,
    required this.description,
    required this.color,
    required this.hq,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(role,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: color)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(description,
                style:
                    TextStyle(fontSize: 12, color: hq.secondaryText)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// DIALOG HELPERS
// ─────────────────────────────────────────────

class _DialogField extends StatelessWidget {
  final String label;
  final String hint;
  final String? initial;
  final dynamic hq;

  const _DialogField(
      {required this.label, required this.hint, required this.hq, this.initial});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: hq.secondaryText)),
        const SizedBox(height: 6),
        TextFormField(
          initialValue: initial,
          style: TextStyle(color: hq.primaryText, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: hq.tertiaryText, fontSize: 13),
            filled: true,
            fillColor: hq.page,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: hq.border),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
      ],
    );
  }
}

class _RoleDropdown extends StatefulWidget {
  final dynamic hq;
  final String? initial;
  const _RoleDropdown({required this.hq, this.initial});

  @override
  State<_RoleDropdown> createState() => _RoleDropdownState();
}

class _RoleDropdownState extends State<_RoleDropdown> {
  late String _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initial ?? 'HR Manager';
  }

  @override
  Widget build(BuildContext context) {
    final hq = widget.hq;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Role',
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: hq.secondaryText)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: _value,
          dropdownColor: hq.card,
          style: TextStyle(color: hq.primaryText, fontSize: 14),
          decoration: InputDecoration(
            filled: true,
            fillColor: hq.page,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: hq.border),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
          items: _roleDescriptions
              .map((r) => DropdownMenuItem(value: r.$1, child: Text(r.$1)))
              .toList(),
          onChanged: (v) => setState(() => _value = v ?? _value),
        ),
      ],
    );
  }
}

class _StatusDropdown extends StatefulWidget {
  final dynamic hq;
  final _UserStatus initial;
  const _StatusDropdown({required this.hq, required this.initial});

  @override
  State<_StatusDropdown> createState() => _StatusDropdownState();
}

class _StatusDropdownState extends State<_StatusDropdown> {
  late _UserStatus _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    final hq = widget.hq;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Status',
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: hq.secondaryText)),
        const SizedBox(height: 6),
        DropdownButtonFormField<_UserStatus>(
          value: _value,
          dropdownColor: hq.card,
          style: TextStyle(color: hq.primaryText, fontSize: 14),
          decoration: InputDecoration(
            filled: true,
            fillColor: hq.page,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: hq.border),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
          items: const [
            DropdownMenuItem(value: _UserStatus.active,   child: Text('Active')),
            DropdownMenuItem(value: _UserStatus.inactive, child: Text('Inactive')),
            DropdownMenuItem(value: _UserStatus.pending,  child: Text('Pending')),
          ],
          onChanged: (v) => setState(() => _value = v ?? _value),
        ),
      ],
    );
  }
}