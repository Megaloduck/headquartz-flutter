import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:window_manager/window_manager.dart';

import '../core/config/app_config.dart';
import '../core/utils/logger.dart';
import 'service_locator.dart';

/// Performs all early-startup initialisation.
///
/// Must be called before [runApp]. Safely no-ops on platforms where a
/// given subsystem isn't applicable.
class AppInitializer {
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Local persistence.
    try {
      await Hive.initFlutter();
    } catch (e, st) {
      logBoot.w('Hive init failed (non-fatal)', e, st);
    }

    // Desktop window. Mobile / web simply skips.
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      try {
        await windowManager.ensureInitialized();
        const opts = WindowOptions(
          size: Size(
            AppConfig.initialWindowWidth,
            AppConfig.initialWindowHeight,
          ),
          minimumSize: Size(
            AppConfig.minWindowWidth,
            AppConfig.minWindowHeight,
          ),
          center: true,
          backgroundColor: Color(0xFF05070A),
          skipTaskbar: false,
          titleBarStyle: TitleBarStyle.hidden,
          title: '${AppConfig.appName} — ${AppConfig.appTagline}',
        );
        await windowManager.waitUntilReadyToShow(opts, () async {
          await windowManager.show();
          await windowManager.focus();
        });
      } catch (e, st) {
        logBoot.w('window_manager init failed (non-fatal)', e, st);
      }
    }

    await initServiceLocator();

    logBoot.i('Headquartz ${AppConfig.version}+${AppConfig.build} initialized');
  }
}
