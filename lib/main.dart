import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'bootstrap/app_initializer.dart';

Future<void> main() async {
  await AppInitializer.initialize();
  runApp(const ProviderScope(child: HeadquartzApp()));
}
