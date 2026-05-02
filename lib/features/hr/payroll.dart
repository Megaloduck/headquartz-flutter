// lib/features/hr/payroll.dart
import 'package:flutter/material.dart';
import '../../widgets/shared_widgets.dart';

const Color _hrColor = Color(0xFF4DD0C4);

class PayrollPage extends StatelessWidget {
  const PayrollPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleScaffold(
      title: 'Payroll',
      department: 'Human Resources',
      color: _hrColor,
      children: [
        StatsGrid(cards: const [
          StatCard(label: 'Monthly Payroll',  value: '\$412K', icon: Icons.payments_rounded,             color: _hrColor,       trend: '+2%'),
          StatCard(label: 'Employees Paid',   value: '241',    icon: Icons.check_circle_rounded,         color: Colors.green),
          StatCard(label: 'Pending',          value: '7',      icon: Icons.hourglass_empty_rounded,      color: Colors.orange),
          StatCard(label: 'Deductions',       value: '\$28K',  icon: Icons.remove_circle_outline_rounded, color: Colors.red),
        ]),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Upcoming Payroll Run'),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _hrColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _hrColor.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.calendar_today_rounded, color: _hrColor),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Next Run: June 30, 2025',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  Text('248 employees  •  Est. \$412,000',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Recent Payroll History'),
        const SizedBox(height: 8),
        const DataRowTile(
          title: 'May 2025',
          subtitle: '248 employees processed',
          trailing: '\$408K',
          accentColor: _hrColor,
          leadingIcon: Icons.receipt_rounded,
          statusColor: Colors.green,
        ),
        const DataRowTile(
          title: 'April 2025',
          subtitle: '245 employees processed',
          trailing: '\$401K',
          accentColor: _hrColor,
          leadingIcon: Icons.receipt_rounded,
          statusColor: Colors.green,
        ),
        const DataRowTile(
          title: 'March 2025',
          subtitle: '240 employees processed',
          trailing: '\$395K',
          accentColor: _hrColor,
          leadingIcon: Icons.receipt_rounded,
          statusColor: Colors.green,
        ),
        const SizedBox(height: 20),
        const ChartPlaceholder(title: 'Monthly Payroll Trend', color: _hrColor),
      ],
    );
  }
}