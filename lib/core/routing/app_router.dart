import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../bootstrap/dependency_injection.dart';
import '../../features/gameplay/gameplay_shell.dart';
import '../../features/lobby/presentation/screens/host_setup_screen.dart';
import '../../features/lobby/presentation/screens/join_screen.dart';
import '../../features/lobby/presentation/screens/lobby_room_screen.dart';
import '../../features/menu/main_menu_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../config/department_constants.dart';
import 'route_names.dart';

/// Single GoRouter instance for the whole app.
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: Routes.splash,
    refreshListenable: _RouterRefresh(ref),
    redirect: (context, state) {
      final loc = state.uri.path;
      final ns = ref.read(networkSessionProvider);
      // Block direct nav into game/lobby room when no session is active.
      if (loc.startsWith(Routes.game) && ns == null) {
        return Routes.menu;
      }
      if (loc.startsWith(Routes.lobbyRoom) && ns == null) {
        return Routes.menu;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: Routes.splash,
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: Routes.menu,
        builder: (_, __) => const MainMenuScreen(),
      ),
      GoRoute(
        path: Routes.lobbyHost,
        builder: (_, __) => const HostSetupScreen(),
      ),
      GoRoute(
        path: Routes.lobbyJoin,
        builder: (_, __) => const JoinScreen(),
      ),
      GoRoute(
        path: Routes.lobbyRoom,
        builder: (_, __) => const LobbyRoomScreen(),
      ),
      GoRoute(
        path: Routes.settings,
        builder: (_, __) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/game/:role',
        redirect: (context, state) {
          final role = state.pathParameters['role'];
          return Routes.department(role ?? 'finance');
        },
      ),
      GoRoute(
        path: '/game/:role/:page',
        builder: (_, state) {
          final role = state.pathParameters['role'] ?? '';
          final page = state.pathParameters['page'] ?? 'dashboard';
          final id = RoleId.tryParse(role) ?? RoleId.finance;
          return GameplayShell(role: id, pageId: page);
        },
      ),
    ],
  );
});

/// A Listenable that triggers GoRouter refreshes when network state changes.
class _RouterRefresh extends ChangeNotifier {
  _RouterRefresh(this._ref) {
    _sub = _ref.listen<Object?>(networkSessionProvider, (_, __) {
      notifyListeners();
    });
  }

  // ignore: unused_field
  final Ref _ref;
  late final ProviderSubscription<Object?> _sub;

  @override
  void dispose() {
    _sub.close();
    super.dispose();
  }
}
