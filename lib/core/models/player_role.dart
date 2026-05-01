// lib/core/models/player_role.dart

enum PlayerRole {
  ceo,
  hrManager,
  financeManager,
  salesManager,
  marketingManager,
  productionManager,
  warehouseManager,
  logisticsManager,
  boardsChairman,
}

extension PlayerRoleExtension on PlayerRole {
  String get displayName => switch (this) {
        PlayerRole.ceo => 'CEO',
        PlayerRole.hrManager => 'HR Manager',
        PlayerRole.financeManager => 'Finance Manager',
        PlayerRole.salesManager => 'Sales Manager',
        PlayerRole.marketingManager => 'Marketing Manager',
        PlayerRole.productionManager => 'Production Manager',
        PlayerRole.warehouseManager => 'Warehouse Manager',
        PlayerRole.logisticsManager => 'Logistics Manager',
        PlayerRole.boardsChairman => 'Boards Chairman',
      };

  String get routePath => switch (this) {
        PlayerRole.ceo => '/ceo',
        PlayerRole.hrManager => '/hr',
        PlayerRole.financeManager => '/finance',
        PlayerRole.salesManager => '/sales',
        PlayerRole.marketingManager => '/marketing',
        PlayerRole.productionManager => '/production',
        PlayerRole.warehouseManager => '/warehouse',
        PlayerRole.logisticsManager => '/logistics',
        PlayerRole.boardsChairman => '/management',
      };
}