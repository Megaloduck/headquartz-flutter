// lib/core/services/role_service.dart
//
// Port of the MAUI RoleService. A lightweight singleton that holds
// the currently-selected role and exposes department-visibility helpers
// used by HomeScreen to filter the department grid.
//
// Roles mirror the org chart in Headquartz.png:
//   • CEO              → sees every department
//   • Boards Chairman  → sees Management (executive cross-dept reports)
//   • <Department> Mgr → sees their own department only

import '../models/player_role.dart';

class RoleService {
  RoleService._internal();
  static final RoleService instance = RoleService._internal();

  /// All roles available on the login screen.
  final List<PlayerRole> availableRoles = const [
    PlayerRole.ceo,
    PlayerRole.hrManager,
    PlayerRole.financeManager,
    PlayerRole.salesManager,
    PlayerRole.marketingManager,
    PlayerRole.productionManager,
    PlayerRole.warehouseManager,
    PlayerRole.logisticsManager,
    PlayerRole.boardsChairman,
  ];

  /// The currently active role. `null` means logged out.
  PlayerRole? _currentRole;
  PlayerRole? get currentRole => _currentRole;

  void setRole(PlayerRole role) => _currentRole = role;
  void logout() => _currentRole = null;

  bool get isCeo => _currentRole == PlayerRole.ceo;
  bool get isBoardsChairman => _currentRole == PlayerRole.boardsChairman;
  bool get isManager =>
      _currentRole != null &&
      _currentRole != PlayerRole.ceo &&
      _currentRole != PlayerRole.boardsChairman;

  /// Maps a role to the department name (as used in `app.dart`'s
  /// `departments` list) that the role manages. Returns `null` for
  /// roles that aren't tied to a single department (CEO, Chairman).
  String? get ownDepartmentName => switch (_currentRole) {
        PlayerRole.hrManager => 'Human Resources',
        PlayerRole.financeManager => 'Finance',
        PlayerRole.salesManager => 'Sales',
        PlayerRole.marketingManager => 'Marketing',
        PlayerRole.productionManager => 'Production',
        PlayerRole.warehouseManager => 'Warehouse',
        PlayerRole.logisticsManager => 'Logistics',
        _ => null,
      };

  /// Returns true if the active role should see the given department
  /// on the home grid.
  ///   • CEO              → all departments
  ///   • Boards Chairman  → only the 'Management' department
  ///   • Department mgr   → their own department only
  bool canSeeDepartment(String departmentName) {
    if (_currentRole == null) return false;
    if (isCeo) return true;
    if (isBoardsChairman) return departmentName == 'Management';
    return departmentName == ownDepartmentName;
  }
}