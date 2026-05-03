import 'package:intl/intl.dart';

/// Formatters for display values across the app.
class Fmt {
  Fmt._();

  static final NumberFormat _currency = NumberFormat.currency(
    symbol: '\$',
    decimalDigits: 0,
  );

  static final NumberFormat _currencyCompact = NumberFormat.compactCurrency(
    symbol: '\$',
  );

  static final NumberFormat _decimal2 = NumberFormat('#,##0.00');
  static final NumberFormat _decimal0 = NumberFormat('#,##0');
  static final NumberFormat _percent = NumberFormat.percentPattern();

  static String currency(num value) => _currency.format(value);

  static String currencyCompact(num value) => _currencyCompact.format(value);

  static String integer(num value) => _decimal0.format(value);
  static String decimal(num value) => _decimal2.format(value);

  static String percent(double ratio, {int fractionDigits = 1}) {
    final p = NumberFormat.percentPattern()..maximumFractionDigits = fractionDigits;
    return p.format(ratio);
  }

  /// Format an in-game minute count as `Day N · HH:MM`.
  static String gameClock(int totalInGameMinutes) {
    final day = (totalInGameMinutes ~/ (24 * 60)) + 1;
    final mins = totalInGameMinutes % (24 * 60);
    final hh = (mins ~/ 60).toString().padLeft(2, '0');
    final mm = (mins % 60).toString().padLeft(2, '0');
    return 'D$day · $hh:$mm';
  }

  /// Format any DateTime as HH:mm:ss.
  static String wallClock(DateTime t) =>
      '${t.hour.toString().padLeft(2, '0')}:'
      '${t.minute.toString().padLeft(2, '0')}:'
      '${t.second.toString().padLeft(2, '0')}';

  /// Signed, colored-friendly delta string ("+1,234" / "-567").
  static String signed(num value) {
    if (value > 0) return '+${integer(value)}';
    return integer(value);
  }

  /// Compact human label of a duration ("3m 12s").
  static String duration(Duration d) {
    if (d.inHours > 0) {
      return '${d.inHours}h ${d.inMinutes.remainder(60)}m';
    }
    if (d.inMinutes > 0) {
      return '${d.inMinutes}m ${d.inSeconds.remainder(60)}s';
    }
    return '${d.inSeconds}s';
  }
}
