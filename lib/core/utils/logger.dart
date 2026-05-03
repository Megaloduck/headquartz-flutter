import 'package:logger/logger.dart';

/// App-wide tagged logger. Wrap [Logger] to add subsystem tags such as
/// `sim`, `net`, `ui`, `lobby`, etc.
class HQLogger {
  HQLogger._(this._tag, this._inner);

  final String _tag;
  final Logger _inner;

  static final Logger _root = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      colors: true,
      printEmojis: false,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
    filter: ProductionFilter(),
  );

  factory HQLogger.tagged(String tag) => HQLogger._(tag, _root);

  void d(Object? msg) => _inner.d('[$_tag] $msg');
  void i(Object? msg) => _inner.i('[$_tag] $msg');
  void w(Object? msg, [Object? error, StackTrace? trace]) =>
      _inner.w('[$_tag] $msg', error: error, stackTrace: trace);
  void e(Object? msg, [Object? error, StackTrace? trace]) =>
      _inner.e('[$_tag] $msg', error: error, stackTrace: trace);
  void t(Object? msg) => _inner.t('[$_tag] $msg');
}

final logSim = HQLogger.tagged('sim');
final logNet = HQLogger.tagged('net');
final logUi = HQLogger.tagged('ui');
final logLobby = HQLogger.tagged('lobby');
final logHost = HQLogger.tagged('host');
final logClient = HQLogger.tagged('client');
final logBoot = HQLogger.tagged('boot');
