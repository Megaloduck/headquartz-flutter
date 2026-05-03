import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/spacing.dart';
import '../theme/typography.dart';

class HQDataTable extends StatelessWidget {
  const HQDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.onRowTap,
  });

  final List<String> columns;
  final List<List<Widget>> rows;
  final void Function(int index)? onRowTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(Spacing.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: Spacing.md, vertical: Spacing.sm),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                for (final col in columns)
                  Expanded(
                    child: Text(
                      col.toUpperCase(),
                      style: AppTypography.tableHeader,
                    ),
                  ),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: rows.length,
            itemBuilder: (context, i) {
              final row = rows[i];
              final widget = Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.md, vertical: 10),
                decoration: BoxDecoration(
                  color: i.isEven
                      ? Colors.transparent
                      : AppColors.surface.withValues(alpha: 0.5),
                  border: const Border(
                    bottom: BorderSide(
                      color: AppColors.divider,
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    for (final cell in row)
                      Expanded(child: cell),
                  ],
                ),
              );
              if (onRowTap == null) return widget;
              return InkWell(
                onTap: () => onRowTap!(i),
                child: widget,
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Convenience text cell.
class TableTextCell extends StatelessWidget {
  const TableTextCell(this.text, {super.key, this.color, this.mono = false});
  final String text;
  final Color? color;
  final bool mono;

  @override
  Widget build(BuildContext context) {
    final base = mono ? AppTypography.tableCellMono : AppTypography.tableCell;
    return Text(
      text,
      style: base.copyWith(color: color ?? AppColors.textPrimary),
      overflow: TextOverflow.ellipsis,
    );
  }
}
