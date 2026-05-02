// lib/features/hr/recruitment.dart
import 'package:flutter/material.dart';
import '../../widgets/shared_widgets.dart';

const Color _hrColor = Color(0xFF4DD0C4);

class RecruitmentPage extends StatelessWidget {
  const RecruitmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'Recruitment',
      department: 'Human Resources',
      color: _hrColor,
      children: [
        StatsGrid(cards: const [
          StatCard(label: 'Open Roles',    value: '12', icon: Icons.work_rounded,               color: _hrColor),
          StatCard(label: 'Applications',  value: '84', icon: Icons.inbox_rounded,               color: Colors.blue),
          StatCard(label: 'Interviews',    value: '9',  icon: Icons.record_voice_over_rounded,   color: Colors.purple),
          StatCard(label: 'Offers Sent',   value: '3',  icon: Icons.send_rounded,                color: Colors.green),
        ]),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Open Positions', actionLabel: 'Post New'),
        const SizedBox(height: 8),
        const DataRowTile(
          title: 'Senior Flutter Developer',
          subtitle: 'Engineering • Full-time',
          trailing: '18 Apps',
          accentColor: _hrColor,
          leadingIcon: Icons.code_rounded,
          statusColor: Colors.green,
        ),
        const DataRowTile(
          title: 'Sales Executive',
          subtitle: 'Sales • Full-time',
          trailing: '23 Apps',
          accentColor: _hrColor,
          leadingIcon: Icons.handshake_rounded,
          statusColor: Colors.green,
        ),
        const DataRowTile(
          title: 'Logistics Coordinator',
          subtitle: 'Logistics • Contract',
          trailing: '11 Apps',
          accentColor: _hrColor,
          leadingIcon: Icons.local_shipping_rounded,
          statusColor: Colors.orange,
        ),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Hiring Pipeline'),
        const SizedBox(height: 8),
        const ChartPlaceholder(title: 'Funnel: Applied → Hired', color: _hrColor),
      ],
      fab: FloatingActionButton.extended(
        backgroundColor: _hrColor,
        foregroundColor: Colors.black87,
        onPressed: () {},
        icon: const Icon(Icons.add_rounded),
        label: const Text('Post Position'),
      ),
    );
  }
}