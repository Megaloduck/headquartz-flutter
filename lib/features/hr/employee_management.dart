// lib/features/hr/employee_management.dart
import 'package:flutter/material.dart';
import '../../widgets/shared_widgets.dart';

const Color _hrColor = Color(0xFF4DD0C4);

class EmployeeManagementPage extends StatelessWidget {
  const EmployeeManagementPage({super.key});

  static const List<Map<String, String>> _employees = [
    {'name': 'James Carter', 'role': 'Software Engineer',  'dept': 'Engineering', 'status': 'Active'},
    {'name': 'Maria Santos', 'role': 'Marketing Lead',     'dept': 'Marketing',   'status': 'Active'},
    {'name': 'David Kim',    'role': 'Sales Executive',    'dept': 'Sales',       'status': 'On Leave'},
    {'name': 'Priya Nair',   'role': 'HR Coordinator',     'dept': 'HR',          'status': 'Active'},
    {'name': 'Tom Hughes',   'role': 'Warehouse Ops',      'dept': 'Warehouse',   'status': 'Active'},
    {'name': 'Aisha Musa',   'role': 'Finance Analyst',    'dept': 'Finance',     'status': 'Remote'},
  ];

  Color _statusColor(String status) {
    return switch (status) {
      'Active'   => Colors.green,
      'On Leave' => Colors.orange,
      _          => Colors.blue,
    };
  }

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'Employee Management',
      department: 'Human Resources',
      color: _hrColor,
      children: [
        const HqSearchField(hint: 'Search employees...'),
        const SizedBox(height: 16),
        const SectionHeader(title: 'All Employees (248)'),
        const SizedBox(height: 8),
        ..._employees.map((e) => DataRowTile(
              title: e['name']!,
              subtitle: '${e['role']} • ${e['dept']}',
              trailing: e['status']!,
              accentColor: _hrColor,
              leadingIcon: Icons.person_rounded,
              statusColor: _statusColor(e['status']!),
            )),
      ],
      fab: FloatingActionButton.extended(
        backgroundColor: _hrColor,
        foregroundColor: Colors.black87,
        onPressed: () {},
        icon: const Icon(Icons.person_add_rounded),
        label: const Text('New Employee'),
      ),
    );
  }
}