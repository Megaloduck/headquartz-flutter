// lib/features/hr/performance_evals.dart
import 'package:flutter/material.dart';
import '../../widgets/shared_widgets.dart';

const Color _hrColor = Color(0xFF4DD0C4);

class PerformanceEvalsPage extends StatelessWidget {
  const PerformanceEvalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'Performance Evals',
      department: 'Human Resources',
      color: _hrColor,
      children: [
        StatsGrid(cards: const [
          StatCard(label: 'Due This Month', value: '48',    icon: Icons.assignment_rounded,     color: _hrColor),
          StatCard(label: 'Completed',      value: '31',    icon: Icons.check_circle_rounded,   color: Colors.green),
          StatCard(label: 'Overdue',        value: '5',     icon: Icons.warning_rounded,        color: Colors.red),
          StatCard(label: 'Avg Rating',     value: '4.1/5', icon: Icons.star_rounded,           color: Colors.amber),
        ]),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Pending Reviews', actionLabel: 'Start Review'),
        const SizedBox(height: 8),
        const DataRowTile(
          title: 'Q2 2025 — Engineering',
          subtitle: '12 employees • Due Jun 30',
          trailing: '4 done',
          accentColor: _hrColor,
          leadingIcon: Icons.engineering_rounded,
          statusColor: Colors.orange,
        ),
        const DataRowTile(
          title: 'Q2 2025 — Sales',
          subtitle: '8 employees • Due Jun 30',
          trailing: '6 done',
          accentColor: _hrColor,
          leadingIcon: Icons.storefront_rounded,
          statusColor: Colors.green,
        ),
        const DataRowTile(
          title: 'Q2 2025 — Operations',
          subtitle: '14 employees • Overdue',
          trailing: '0 done',
          accentColor: _hrColor,
          leadingIcon: Icons.settings_rounded,
          statusColor: Colors.red,
        ),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Rating Distribution'),
        const SizedBox(height: 8),
        const ChartPlaceholder(title: 'Performance Score Distribution', color: _hrColor),
      ],
    );
  }
}