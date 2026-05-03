import 'dart:async';

import 'package:flutter/material.dart';

import '../../data/models/simulation/notification.dart';
import '../theme/app_colors.dart';
import '../theme/spacing.dart';
import '../theme/typography.dart';
import '../utils/formatters.dart';

/// Marquee-style ticker showing recent notifications.
class EventTicker extends StatefulWidget {
  const EventTicker({super.key, required this.notifications});
  final List<GameNotification> notifications;

  @override
  State<EventTicker> createState() => _EventTickerState();
}

class _EventTickerState extends State<EventTicker> {
  final _ctrl = ScrollController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 33), (_) {
      if (!_ctrl.hasClients) return;
      final next = _ctrl.offset + 0.7;
      if (next >= _ctrl.position.maxScrollExtent) {
        _ctrl.jumpTo(0);
      } else {
        _ctrl.jumpTo(next);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  Color _colorFor(NotificationSeverity s) => switch (s) {
        NotificationSeverity.info => AppColors.info,
        NotificationSeverity.success => AppColors.success,
        NotificationSeverity.warning => AppColors.warning,
        NotificationSeverity.danger => AppColors.danger,
      };

  @override
  Widget build(BuildContext context) {
    final items = widget.notifications.take(40).toList();
    if (items.isEmpty) {
      return Container(
        height: Spacing.tickerHeight,
        color: AppColors.surface,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
        child: Text('No events yet · waiting for first tick…',
            style: AppTypography.ticker.copyWith(color: AppColors.textTertiary)),
      );
    }

    final reel = [...items, ...items]; // looped
    return Container(
      height: Spacing.tickerHeight,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
            color: AppColors.tickerGlow.withValues(alpha: 0.08),
            alignment: Alignment.center,
            child: Text('LIVE',
                style: AppTypography.label.copyWith(
                    color: AppColors.tickerGlow,
                    letterSpacing: 1.4,
                    fontWeight: FontWeight.w800)),
          ),
          Expanded(
            child: ListView.builder(
              controller: _ctrl,
              scrollDirection: Axis.horizontal,
              itemCount: reel.length,
              itemBuilder: (context, i) {
                final n = reel[i];
                final c = _colorFor(n.severity);
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.md),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 4,
                        height: 4,
                        decoration:
                            BoxDecoration(color: c, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${Fmt.wallClock(n.timestamp)}  ${n.title}: ${n.body}',
                        style: AppTypography.ticker.copyWith(color: c),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
