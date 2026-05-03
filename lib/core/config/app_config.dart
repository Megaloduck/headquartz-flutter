/// Static, build-time application configuration.
class AppConfig {
  AppConfig._();

  static const String appName = 'Headquartz';
  static const String appTagline = 'Enterprise Resource Planning Simulator';
  static const String version = '1.0.0';
  static const String build = '1';

  // Window dimensions (initial)
  static const double initialWindowWidth = 1440;
  static const double initialWindowHeight = 900;
  static const double minWindowWidth = 1100;
  static const double minWindowHeight = 700;

  // Dev / debug toggles. Wired through environment.dart at runtime.
  static const bool defaultVerboseLogging = true;
  static const bool defaultEnableReplays = true;
}
