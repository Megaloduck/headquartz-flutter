/// Canonical paths for go_router. Use these — never inline strings.
class Routes {
  Routes._();

  static const splash = '/';
  static const menu = '/menu';
  static const lobby = '/lobby';
  static const lobbyHost = '/lobby/host';
  static const lobbyJoin = '/lobby/join';
  static const lobbyRoom = '/lobby/room';

  static const settings = '/settings';

  static const game = '/game';

  /// Path for a department page: /game/:role/:page
  static String department(String role, [String page = 'dashboard']) =>
      '/game/$role/$page';
}
