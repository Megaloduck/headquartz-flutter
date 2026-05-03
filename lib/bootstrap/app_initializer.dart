import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:window_manager/window_manager.dart';

import '../core/utils/logger.dart';
import 'service_locator.dart';

/// Performs all early-startup initialisation.
///
/// Every subsystem is wrapped in its own try/catch so a single failure
/// can't prevent the Flutter window from coming up. Boot progress is
/// logged at info level so you can confirm in the debug console.
class AppInitializer {
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    debugPrint('[Headquartz] boot: WidgetsFlutterBinding ready');

    // ── Local persistence ─────────────────────────────────────────
    try {
      await Hive.initFlutter();
      debugPrint('[Headquartz] boot: Hive initialized');
    } catch (e, st) {
      logBoot.w('Hive init failed (non-fatal)', e, st);
    }

    // ── Desktop window ────────────────────────────────────────────
    //
    // We deliberately DO NOT use TitleBarStyle.hidden here. Hidden
    // title bars on Windows require platform-specific changes in
    // `windows/runner/flutter_window.cpp` to coordinate with
    // window_manager — without those, the process runs but the window
    // never actually paints. The native title bar coexists fine with
    // our custom topbar; visually it's a small redundancy, not a
    // blocker.
    if (!kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux)) {
      try {
        await windowManager.ensureInitialized();
        debugPrint('[Headquartz] boot: windowManager initialized');

        const opts = WindowOptions(
          size: Size(1440, 900),
          minimumSize: Size(1024, 640),
          center: true,
          backgroundColor: Color(0xFF05070A),
          skipTaskbar: false,
          title: 'Headquartz',
        );

        // Don't await — if the host platform is slow to fire the
        // ready-to-show callback we still want runApp to proceed and
        // the default Flutter window to come up.
        unawaited(windowManager.waitUntilReadyToShow(opts, () async {
          try {
            await windowManager.show();
            await windowManager.focus();
            debugPrint('[Headquartz] boot: window shown & focused');
          } catch (e, st) {
            logBoot.w('window show/focus failed', e, st);
          }
        }));
      } catch (e, st) {
        logBoot.w('window_manager init failed (non-fatal)', e, st);
      }
    }

    // ── DI ────────────────────────────────────────────────────────
    try {
      await initServiceLocator();
      debugPrint('[Headquartz] boot: service locator ready');
    } catch (e, st) {
      logBoot.w('Service locator init failed', e, st);
    }

    debugPrint('[Headquartz] boot: complete — handing off to runApp');
  }
}