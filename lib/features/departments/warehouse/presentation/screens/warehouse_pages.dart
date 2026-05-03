import 'package:flutter/material.dart';

import '../../../../../core/config/department_constants.dart';
import '../../../generic_dashboard.dart';

class WarehousePages {
  WarehousePages._();

  static Widget byId(String id) {
    switch (id) {
      case 'dashboard':
        return const GenericDepartmentDashboard(
          role: RoleId.warehouse,
          subtitle: 'Facility overview · inventory & flow',
          kpiIds: ['stock', 'production', 'demand'],
        );
      default:
        return DepartmentPagePlaceholder(role: RoleId.warehouse, pageId: id);
    }
  }
}
