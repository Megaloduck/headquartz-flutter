import 'dart:math';

import '../../../data/models/company/company.dart';
import '../../../data/models/simulation/notification.dart';
import '../../config/game_constants.dart';
import 'package:uuid/uuid.dart';

/// Maybe fires random events each tick. Returns notifications to add.
///
/// In a real implementation, the events would also mutate company state.
/// Here we surface them as notifications and small modifiers.
class RandomEventEngine {
  RandomEventEngine();
  static const _uuid = Uuid();

  static const _events = <_Event>[
    _Event('Supplier Delay',
        'A key supplier reports a 24h delay on raw materials.',
        NotificationSeverity.warning),
    _Event('Press Coverage',
        'Industry blog publishes a feature on your latest product.',
        NotificationSeverity.success),
    _Event('Energy Price Spike',
        'Energy prices jumped 12% — production cost up.',
        NotificationSeverity.warning),
    _Event('Competitor Promo',
        'A competitor launched an aggressive 15% discount campaign.',
        NotificationSeverity.danger),
    _Event('Quality Award',
        'Industry body awards you a Quality Excellence badge.',
        NotificationSeverity.success),
    _Event('Logistics Strike',
        'Local logistics workers announce a partial strike.',
        NotificationSeverity.danger),
    _Event('Viral Marketing',
        'Your last campaign trended unexpectedly on social media.',
        NotificationSeverity.success),
    _Event('Quarterly Audit',
        'Audit completed: minor recommendations, no penalties.',
        NotificationSeverity.info),
  ];

  List<GameNotification> maybeFire(Company co, int gameMinute, Random rng) {
    final p = GameConstants.crisisBaseProbability;
    if (rng.nextDouble() > p) return const [];
    final e = _events[rng.nextInt(_events.length)];
    return [
      GameNotification(
        id: _uuid.v4(),
        title: e.title,
        body: e.body,
        severity: e.severity,
        timestamp: DateTime.now(),
        gameMinute: gameMinute,
      ),
    ];
  }
}

class _Event {
  const _Event(this.title, this.body, this.severity);
  final String title;
  final String body;
  final NotificationSeverity severity;
}
