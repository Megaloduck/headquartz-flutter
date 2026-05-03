import 'package:get_it/get_it.dart';

import '../core/networking/lan/discovery_service.dart';
import '../core/networking/lan/session_browser.dart';

/// Global DI container. Use sparingly — Riverpod is the primary state
/// mechanism. Keep this for objects whose lifetime spans the whole app
/// and are awkward to thread through providers.
final GetIt sl = GetIt.instance;

Future<void> initServiceLocator() async {
  if (!sl.isRegistered<DiscoveryService>()) {
    sl.registerLazySingleton<DiscoveryService>(() => DiscoveryService());
  }
  if (!sl.isRegistered<SessionBrowser>()) {
    sl.registerLazySingleton<SessionBrowser>(
        () => SessionBrowser(sl<DiscoveryService>()));
  }
}
