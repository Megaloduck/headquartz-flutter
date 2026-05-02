// lib/screens/mainmenu/overview_page.dart
//
// Simulation Overview — timeline, speed controls, 7-day calendar,
// events list, and milestones. All wired to Riverpod providers.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/game_state.dart';
import '../../core/theme/app_themes.dart';
import '../../providers/game_provider.dart';

class OverviewPage extends ConsumerWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(gameStateProvider);
    final controlState = ref.watch(simControlProvider);
    final controlNotifier = ref.read(simControlProvider.notifier);

    return stateAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (state) => _OverviewContent(
        state: state,
        controlState: controlState,
        controlNotifier: controlNotifier,
      ),
    );
  }
}

// ─────────────────────────────────────────────
class _OverviewContent extends StatelessWidget {
  final GameState state;
  final SimControlState controlState;
  final SimControlNotifier controlNotifier;

  const _OverviewContent({
    required this.state,
    required this.controlState,
    required this.controlNotifier,
  });

  @override
  Widget build(BuildContext context) {
    final hq = context.hq;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Page Header ──────────────────────────────────────────
          _OverviewHeader(state: state, isRunning: controlState.isRunning),
          const SizedBox(height: 20),

          // ── Simulation Time & Controls ───────────────────────────
          _SimTimeCard(
            state: state,
            controlState: controlState,
            controlNotifier: controlNotifier,
          ),
          const SizedBox(height: 20),

          // ── Upcoming Events Calendar ─────────────────────────────
          _EventsCalendarCard(state: state),
          const SizedBox(height: 20),

          // ── Milestones & Progress ────────────────────────────────
          _MilestonesCard(state: state),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Page Header
// ─────────────────────────────────────────────

class _OverviewHeader extends StatelessWidget {
  final GameState state;
  final bool isRunning;
  const _OverviewHeader({required this.state, required this.isRunning});

  @override
  Widget build(BuildContext context) {
    final hq = context.hq;
    final statusColor = isRunning ? Colors.green : Colors.orange;
    final statusText = isRunning ? 'Running' : 'Paused';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Simulation Overview',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: hq.primaryText)),
              const SizedBox(height: 4),
              Text('Monitor simulation progress and upcoming events',
                  style: TextStyle(fontSize: 14, color: hq.secondaryText)),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: hq.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: hq.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(statusText,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: hq.primaryText)),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Simulation Time & Controls Card
// ─────────────────────────────────────────────

class _SimTimeCard extends StatelessWidget {
  final GameState state;
  final SimControlState controlState;
  final SimControlNotifier controlNotifier;

  const _SimTimeCard({
    required this.state,
    required this.controlState,
    required this.controlNotifier,
  });

  @override
  Widget build(BuildContext context) {
    final hq = context.hq;
    final quarter = _currentQuarter(state.simTime);
    final quarterProgress = _quarterProgress(state.simTime);
    final phase = _simPhase(state.simTime);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: hq.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: hq.border),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Row 1: Timeline ────────────────────────────────────
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Simulation Timeline',
                  style: TextStyle(fontSize: 14, color: hq.secondaryText)),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text('⏱️', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_formatSimTime(state.simTime),
                            style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: hq.primaryText)),
                        Text(phase,
                            style: TextStyle(
                                fontSize: 12, color: hq.secondaryText)),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: controlState.isRunning
                          ? Colors.green
                          : Colors.orange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      controlState.isRunning ? 'Running' : 'Paused',
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ── Quarter Progress Bar ──────────────────────────
              Stack(
                children: [
                  // Base bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: quarterProgress,
                      minHeight: 8,
                      backgroundColor: hq.border,
                      color: kBrandAmber,
                    ),
                  ),
                  // Quarter tick marks
                  Positioned.fill(
                    child: Row(
                      children: [
                        const Spacer(flex: 25),
                        Container(
                            width: 2, height: 16, color: hq.border),
                        const Spacer(flex: 25),
                        Container(
                            width: 2, height: 16, color: hq.border),
                        const Spacer(flex: 25),
                        Container(
                            width: 2, height: 16, color: hq.border),
                        const Spacer(flex: 25),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Q1', style: TextStyle(fontSize: 10, color: hq.secondaryText)),
                  Text('Q2', style: TextStyle(fontSize: 10, color: hq.secondaryText)),
                  Text('Q3', style: TextStyle(fontSize: 10, color: hq.secondaryText)),
                  Text('Q4', style: TextStyle(fontSize: 10, color: hq.secondaryText)),
                ],
              ),
              const SizedBox(height: 4),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  decoration: BoxDecoration(
                    color: kBrandAmber,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Q$quarter  ·  ${(quarterProgress * 100).toStringAsFixed(0)}% of quarter complete',
                    style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          Divider(color: hq.border),
          const SizedBox(height: 16),

          // ── Row 2: Speed Controls + Action Buttons ─────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Speed selector
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Simulation Speed',
                        style: TextStyle(
                            fontSize: 14, color: hq.secondaryText)),
                    const SizedBox(height: 8),
                    Row(
                      children: [1.0, 2.0, 4.0, 8.0].map((speed) {
                        final isActive =
                            controlState.speedMultiplier == speed;
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: _SpeedButton(
                            label: '${speed.toStringAsFixed(0)}x',
                            isActive: isActive,
                            onTap: () => controlNotifier.setSpeed(speed),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),

              // Control buttons
              Row(
                children: [
                  _ControlButton(
                    label: controlState.isRunning ? '⏸ Pause' : '▶ Start',
                    color: controlState.isRunning
                        ? Colors.orange
                        : Colors.green,
                    textColor: Colors.white,
                    onTap: () => controlState.isRunning
                        ? controlNotifier.pause()
                        : controlNotifier.start(),
                  ),
                  const SizedBox(width: 10),
                  _ControlButton(
                    label: '💾 Save',
                    color: hq.card,
                    textColor: hq.primaryText,
                    border: hq.border,
                    onTap: () {
                      // TODO: save game state
                    },
                  ),
                  const SizedBox(width: 10),
                  _ControlButton(
                    label: '📂 Load',
                    color: const Color(0xFF2196F3),
                    textColor: Colors.white,
                    onTap: () {
                      // TODO: load game state
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _formatSimTime(DateTime t) =>
      '${t.year}-${_p(t.month)}-${_p(t.day)}  ${_p(t.hour)}:${_p(t.minute)}:${_p(t.second)}';
  static String _p(int n) => n.toString().padLeft(2, '0');

  static int _currentQuarter(DateTime t) => ((t.month - 1) ~/ 3) + 1;
  static double _quarterProgress(DateTime t) {
    final monthInQ = ((t.month - 1) % 3);
    return (monthInQ * 30 + t.day) / 90.0;
  }

  static String _simPhase(DateTime t) {
    final q = _currentQuarter(t);
    return 'Year ${t.year} · Q$q · ${t.month > 6 ? 'H2' : 'H1'}';
  }
}

// ─────────────────────────────────────────────
// Speed button
// ─────────────────────────────────────────────

class _SpeedButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _SpeedButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hq = context.hq;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? kBrandAmber : hq.page,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: isActive ? kBrandAmber : hq.border),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: isActive ? Colors.black87 : hq.secondaryText,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Control button (Start/Pause/Save/Load)
// ─────────────────────────────────────────────

class _ControlButton extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
  final Color? border;
  final VoidCallback onTap;

  const _ControlButton({
    required this.label,
    required this.color,
    required this.textColor,
    required this.onTap,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border: border != null ? Border.all(color: border!) : null,
        ),
        child: Text(
          label,
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: textColor),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Events Calendar Card
// ─────────────────────────────────────────────

class _EventsCalendarCard extends StatelessWidget {
  final GameState state;
  const _EventsCalendarCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final hq = context.hq;
    final simDay = state.simTime.weekday; // 1=Mon … 7=Sun
    final upcomingEvents = _buildEvents(state);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: hq.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: hq.border),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: kBrandAmber.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text('📅', style: TextStyle(fontSize: 20)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Upcoming Events',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: hq.primaryText)),
                    Text('Simulation schedule for next 7 days',
                        style: TextStyle(
                            fontSize: 12, color: hq.secondaryText)),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text('View All →',
                    style: TextStyle(fontSize: 12, color: kBrandAmber)),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 7-day week strip
          Row(
            children: List.generate(7, (i) {
              final dayNum = state.simTime.day - state.simTime.weekday + 1 + i;
              final isToday = i == state.simTime.weekday - 1;
              final hasEvent = upcomingEvents.any(
                  (e) => e.dayOfWeek == i + 1);
              final dayLabels = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];

              return Expanded(
                child: Column(
                  children: [
                    Text(dayLabels[i],
                        style: TextStyle(
                            fontSize: 11, color: hq.secondaryText)),
                    const SizedBox(height: 4),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: isToday
                            ? kBrandAmber
                            : hasEvent
                                ? const Color(0xFF4CAF50)
                                : hq.page,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: isToday ? kBrandAmber : hq.border),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${dayNum > 0 ? dayNum : dayNum + 28}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: (isToday || hasEvent)
                              ? FontWeight.w700
                              : FontWeight.normal,
                          color: (isToday || hasEvent)
                              ? Colors.white
                              : hq.primaryText,
                        ),
                      ),
                    ),
                    if (hasEvent)
                      Container(
                        margin: const EdgeInsets.only(top: 3),
                        width: 16,
                        height: 2,
                        color: const Color(0xFF4CAF50),
                      ),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: 16),

          // Events list
          if (upcomingEvents.isEmpty)
            _NoEventsPlaceholder()
          else
            ...upcomingEvents.map((e) => _EventRow(event: e)),
        ],
      ),
    );
  }

  // Generate events derived from current GameState
  List<_SimEvent> _buildEvents(GameState s) {
    final events = <_SimEvent>[];

    if (s.production.machines.any((m) => m.needsMaintenance)) {
      events.add(_SimEvent(
        title: 'Machine Maintenance Due',
        description:
            '${s.production.machines.where((m) => m.needsMaintenance).length} machines need service',
        color: Colors.orange,
        dayOfWeek: 3,
        time: '09:00',
        date: 'Today',
      ));
    }
    if (s.warehouse.lowStockCount > 0) {
      events.add(_SimEvent(
        title: 'Low Stock Alert',
        description: '${s.warehouse.lowStockCount} products below reorder point',
        color: Colors.red,
        dayOfWeek: 1,
        time: '08:00',
        date: 'Today',
      ));
    }
    if (s.marketing.activeCampaigns.isNotEmpty) {
      events.add(_SimEvent(
        title: 'Campaign Check-in',
        description:
            '${s.marketing.activeCampaigns.length} active campaigns running',
        color: const Color(0xFF2196F3),
        dayOfWeek: 5,
        time: '14:00',
        date: 'Fri',
      ));
    }
    if (s.logistics.fleet.any((v) => v.needsService)) {
      events.add(_SimEvent(
        title: 'Fleet Service',
        description:
            '${s.logistics.fleet.where((v) => v.needsService).length} vehicles need service',
        color: Colors.purple,
        dayOfWeek: 4,
        time: '10:00',
        date: 'Thu',
      ));
    }
    if (s.sales.targetProgress < 0.5) {
      events.add(_SimEvent(
        title: 'Sales Target Review',
        description: 'Monthly target at ${(s.sales.targetProgress * 100).toStringAsFixed(0)}%',
        color: Colors.teal,
        dayOfWeek: 2,
        time: '16:00',
        date: 'Tue',
      ));
    }

    return events;
  }
}

class _SimEvent {
  final String title;
  final String description;
  final Color color;
  final int dayOfWeek;
  final String time;
  final String date;

  const _SimEvent({
    required this.title,
    required this.description,
    required this.color,
    required this.dayOfWeek,
    required this.time,
    required this.date,
  });
}

class _EventRow extends StatelessWidget {
  final _SimEvent event;
  const _EventRow({required this.event});

  @override
  Widget build(BuildContext context) {
    final hq = context.hq;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          // Color bar
          Container(
            width: 4,
            height: 44,
            decoration: BoxDecoration(
              color: event.color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.title,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: hq.primaryText)),
                Text(event.description,
                    style: TextStyle(
                        fontSize: 12, color: hq.secondaryText),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          // Date/time
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(event.date,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: hq.primaryText)),
              Text(event.time,
                  style: TextStyle(
                      fontSize: 11, color: hq.secondaryText)),
            ],
          ),
        ],
      ),
    );
  }
}

class _NoEventsPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final hq = context.hq;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      decoration: BoxDecoration(
        color: hq.page,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          const Text('📅', style: TextStyle(fontSize: 32)),
          const SizedBox(height: 12),
          Text('No upcoming events',
              style: TextStyle(
                  fontSize: 14, color: hq.secondaryText)),
          const SizedBox(height: 4),
          Text('Events will appear here as simulation progresses',
              style:
                  TextStyle(fontSize: 12, color: hq.secondaryText),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Milestones Card
// ─────────────────────────────────────────────

class _MilestonesCard extends StatelessWidget {
  final GameState state;
  const _MilestonesCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final hq = context.hq;
    final quarter = ((state.simTime.month - 1) ~/ 3) + 1;
    final quarterPct = _quarterPct(state.simTime);
    final simHours = state.simTime.difference(DateTime.utc(2025, 1, 1)).inHours;
    final eventsCompleted = state.production.totalUnitsProduced ~/ 100;
    final decisionsMade = state.sales.totalOrdersThisMonth +
        state.marketing.activeCampaigns.length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: hq.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: hq.border),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: kBrandAmber.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text('🏁', style: TextStyle(fontSize: 20)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Milestones & Progress',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: hq.primaryText)),
                    Text('Key simulation achievements',
                        style: TextStyle(
                            fontSize: 12, color: hq.secondaryText)),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text('View Details →',
                    style: TextStyle(fontSize: 12, color: kBrandAmber)),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 4-column milestone grid
          Row(
            children: [
              Expanded(child: _MilestoneTile(
                value: '${(quarterPct * 100).toStringAsFixed(0)}%',
                label: 'Quarter Complete',
                color: kBrandAmber,
              )),
              const SizedBox(width: 12),
              Expanded(child: _MilestoneTile(
                value: '$eventsCompleted',
                label: 'Events Completed',
                color: Colors.green,
              )),
              const SizedBox(width: 12),
              Expanded(child: _MilestoneTile(
                value: '$decisionsMade',
                label: 'Decisions Made',
                color: const Color(0xFF2196F3),
              )),
              const SizedBox(width: 12),
              Expanded(child: _MilestoneTile(
                value: '${simHours}h',
                label: 'Simulation Time',
                color: Colors.orange,
              )),
            ],
          ),
        ],
      ),
    );
  }

  static double _quarterPct(DateTime t) {
    final monthInQ = (t.month - 1) % 3;
    return (monthInQ * 30 + t.day) / 90.0;
  }
}

class _MilestoneTile extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _MilestoneTile({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final hq = context.hq;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: hq.page,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: hq.border),
      ),
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: color)),
          const SizedBox(height: 6),
          Text(label,
              style: TextStyle(
                  fontSize: 12, color: hq.secondaryText),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}