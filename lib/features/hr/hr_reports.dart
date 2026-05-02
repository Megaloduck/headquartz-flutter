// lib/features/hr/hr_reports.dart
import 'package:flutter/material.dart';
import '../../widgets/shared_widgets.dart';

const Color _hrColor = Color(0xFF4DD0C4);

class HrReportsPage extends StatelessWidget {
  const HrReportsPage({super.key});

  static const List<(String, String, IconData)> _reports = [
    ('Headcount Summary',    'Monthly employee count by dept',   Icons.people_rounded),
    ('Turnover Report',      'Attrition rates & exit analysis',  Icons.logout_rounded),
    ('Payroll Summary',      'Salary distribution & costs',      Icons.payments_rounded),
    ('Leave Utilization',    'Leave taken vs entitlement',       Icons.beach_access_rounded),
    ('Training Completion',  'L&D program outcomes',             Icons.school_rounded),
    ('Performance Overview', 'Ratings across departments',       Icons.bar_chart_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'HR Reports',
      department: 'Human Resources',
      color: _hrColor,
      children: [
        const SectionHeader(title: 'Available Reports'),
        const SizedBox(height: 12),
        ..._reports.map((r) => DataRowTile(
              title: r.$1,
              subtitle: r.$2,
              trailing: 'Export',
              accentColor: _hrColor,
              leadingIcon: r.$3,
            )),
        const SizedBox(height: 20),
        const ChartPlaceholder(
            title: 'Monthly HR KPIs Overview', color: _hrColor, height: 200),
      ],
    );
  }
}