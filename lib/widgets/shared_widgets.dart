// lib/widgets/shared_widgets.dart
//
// Theme-aware shared widgets. Replaces every hardcoded colour
// (Colors.white, Color(0xFFF5F6FA), Colors.grey.shade*) with
// tokens from HeadquartzColors so dark mode flips correctly.
//
// Also adds HqSearchField — a drop-in for the three screens
// that previously used TextField(fillColor: Colors.white).

import 'package:flutter/material.dart';
import '../core/theme/app_themes.dart';

// ─────────────────────────────────────────────
// STAT CARD
// ─────────────────────────────────────────────

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String? trend;
  final bool trendUp;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.trend,
    this.trendUp = true,
  });

  @override
  Widget build(BuildContext context) {
    final hq = context.hq;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 22),
              if (trend != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: trendUp
                        ? Colors.green.withOpacity(0.15)
                        : Colors.red.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        trendUp ? Icons.trending_up : Icons.trending_down,
                        size: 12,
                        color: trendUp ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        trend!,
                        style: TextStyle(
                          fontSize: 10,
                          color: trendUp ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: hq.secondaryText,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// STATS GRID
// ─────────────────────────────────────────────

class StatsGrid extends StatelessWidget {
  final List<StatCard> cards;
  const StatsGrid({super.key, required this.cards});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.6,
      children: cards,
    );
  }
}

// ─────────────────────────────────────────────
// SECTION HEADER
// ─────────────────────────────────────────────

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final hq = context.hq;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: hq.primaryText,
          ),
        ),
        if (actionLabel != null)
          TextButton(
            onPressed: onAction,
            child: Text(actionLabel!, style: const TextStyle(fontSize: 12)),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// DATA ROW TILE
// ─────────────────────────────────────────────

class DataRowTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String trailing;
  final Color accentColor;
  final IconData? leadingIcon;
  final Color? statusColor;

  const DataRowTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.accentColor,
    this.leadingIcon,
    this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    final hq = context.hq;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: hq.card,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: hq.shadow, blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: accentColor.withOpacity(0.15),
            child: Icon(leadingIcon ?? Icons.circle, size: 16, color: accentColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: hq.primaryText)),
                Text(subtitle,
                    style: TextStyle(fontSize: 11, color: hq.secondaryText)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(trailing,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: hq.primaryText)),
              if (statusColor != null)
                Container(
                  margin: const EdgeInsets.only(top: 3),
                  width: 8,
                  height: 8,
                  decoration:
                      BoxDecoration(color: statusColor, shape: BoxShape.circle),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// HQ SEARCH FIELD
// Drop-in for any screen that had:
//   TextField(decoration: InputDecoration(fillColor: Colors.white, ...))
// Usage: HqSearchField(hint: 'Search shipments...')
// ─────────────────────────────────────────────

class HqSearchField extends StatelessWidget {
  final String hint;
  final ValueChanged<String>? onChanged;

  const HqSearchField({super.key, required this.hint, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final hq = context.hq;
    return TextField(
      onChanged: onChanged,
      style: TextStyle(color: hq.primaryText, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: hq.tertiaryText),
        prefixIcon: Icon(Icons.search, color: hq.secondaryText),
        filled: true,
        fillColor: hq.card,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: hq.border, width: 1)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: kBrandAmber, width: 1.5)),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// CHART PLACEHOLDER
// ─────────────────────────────────────────────

class ChartPlaceholder extends StatelessWidget {
  final String title;
  final Color color;
  final double height;

  const ChartPlaceholder({
    super.key,
    required this.title,
    required this.color,
    this.height = 180,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bar_chart_rounded, size: 40, color: color.withOpacity(0.5)),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: color.withOpacity(0.7),
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// STATUS BADGE
// ─────────────────────────────────────────────

class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  const StatusBadge({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 10, color: color, fontWeight: FontWeight.w700)),
    );
  }
}

// ─────────────────────────────────────────────
// MODULE SCAFFOLD
// ─────────────────────────────────────────────

class ModuleScaffold extends StatelessWidget {
  final String title;
  final String department;
  final Color color;
  final List<Widget> children;
  final Widget? fab;

  const ModuleScaffold({
    super.key,
    required this.title,
    required this.department,
    required this.color,
    required this.children,
    this.fab,
  });

  @override
  Widget build(BuildContext context) {
    final hq = context.hq;
    return Scaffold(
      backgroundColor: hq.page,
      appBar: AppBar(
        backgroundColor: color,
        foregroundColor: Colors.black87,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w700)),
            Text(department,
                style: const TextStyle(
                    fontSize: 11, fontWeight: FontWeight.w400)),
          ],
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.filter_list_rounded), onPressed: () {}),
          IconButton(
              icon: const Icon(Icons.more_vert_rounded), onPressed: () {}),
        ],
      ),
      floatingActionButton: fab,
      body: ListView(padding: const EdgeInsets.all(16), children: children),
    );
  }
}