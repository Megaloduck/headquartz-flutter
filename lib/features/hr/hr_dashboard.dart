// lib/features/hr/hr_dashboard.dart
import 'package:flutter/material.dart';
import '../../widgets/shared_widgets.dart';

const Color _hrColor = Color(0xFF4DD0C4);

class HrDashboardPage extends StatelessWidget {
  const HrDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'HR Dashboard',
      department: 'Human Resources',
      color: _hrColor,
      children: [
        StatsGrid(cards: const [
          StatCard(label: 'Total Employees', value: '248',  icon: Icons.people_rounded,              color: _hrColor,       trend: '+4%'),
          StatCard(label: 'Open Positions',  value: '12',   icon: Icons.work_outline_rounded,         color: Colors.orange,  trend: '+2'),
          StatCard(label: 'On Leave Today',  value: '7',    icon: Icons.event_busy_rounded,           color: Colors.purple),
          StatCard(label: 'Avg Satisfaction',value: '87%',  icon: Icons.sentiment_satisfied_rounded,  color: Colors.green,   trend: '+3%'),
        ]),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Recent Activity', actionLabel: 'View All'),
        const SizedBox(height: 8),
        const DataRowTile(
          title: 'New hire onboarded',
          subtitle: 'James Carter • Engineering',
          trailing: 'Today',
          accentColor: _hrColor,
          leadingIcon: Icons.person_add_rounded,
          statusColor: Colors.green,
        ),
        const DataRowTile(
          title: 'Leave approved',
          subtitle: 'Maria Santos • Marketing',
          trailing: 'Yesterday',
          accentColor: Colors.orange,
          leadingIcon: Icons.beach_access_rounded,
          statusColor: Colors.orange,
        ),
        const DataRowTile(
          title: 'Performance review due',
          subtitle: 'Sales Team • 5 pending',
          trailing: 'In 2 days',
          accentColor: Colors.red,
          leadingIcon: Icons.assignment_rounded,
          statusColor: Colors.red,
        ),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Headcount by Department'),
        const SizedBox(height: 8),
        const ChartPlaceholder(title: 'Department Headcount Chart', color: _hrColor),
      ],
      fab: FloatingActionButton.extended(
        backgroundColor: _hrColor,
        foregroundColor: Colors.black87,
        onPressed: () {},
        icon: const Icon(Icons.person_add_rounded),
        label: const Text('Add Employee'),
      ),
    );
  }
}