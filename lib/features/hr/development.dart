// lib/features/hr/development.dart
import 'package:flutter/material.dart';
import '../../widgets/shared_widgets.dart';

const Color _hrColor = Color(0xFF4DD0C4);

class DevelopmentPage extends StatelessWidget {
  const DevelopmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'Development',
      department: 'Human Resources',
      color: _hrColor,
      children: [
        StatsGrid(cards: const [
          StatCard(label: 'Active Programs', value: '8',   icon: Icons.school_rounded,    color: _hrColor),
          StatCard(label: 'Enrolled',        value: '134', icon: Icons.people_rounded,    color: Colors.blue),
          StatCard(label: 'Completed',       value: '67',  icon: Icons.verified_rounded,  color: Colors.green),
          StatCard(label: 'Avg Score',       value: '91%', icon: Icons.star_rounded,      color: Colors.amber),
        ]),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Training Programs', actionLabel: 'Add Program'),
        const SizedBox(height: 8),
        const DataRowTile(
          title: 'Leadership Excellence',
          subtitle: 'Management • 6 weeks',
          trailing: '24 enrolled',
          accentColor: _hrColor,
          leadingIcon: Icons.emoji_events_rounded,
          statusColor: Colors.green,
        ),
        const DataRowTile(
          title: 'Data Analytics Basics',
          subtitle: 'Cross-dept • 4 weeks',
          trailing: '41 enrolled',
          accentColor: _hrColor,
          leadingIcon: Icons.analytics_rounded,
          statusColor: Colors.blue,
        ),
        const DataRowTile(
          title: 'Safety & Compliance',
          subtitle: 'All staff • 1 day',
          trailing: '98 enrolled',
          accentColor: _hrColor,
          leadingIcon: Icons.health_and_safety_rounded,
          statusColor: Colors.orange,
        ),
        const SizedBox(height: 20),
        const ChartPlaceholder(title: 'Training Completion Rate', color: _hrColor),
      ],
      fab: FloatingActionButton.extended(
        backgroundColor: _hrColor,
        foregroundColor: Colors.black87,
        onPressed: () {},
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Program'),
      ),
    );
  }
}