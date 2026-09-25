import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tachogo/app.dart';
import 'package:tachogo/core/observability/observability_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();
  final crash = container.read(crashReporterProvider);
  await crash.init();

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    crash.recordError(details.exception, details.stack ?? StackTrace.empty);
  };
  // Необработанные асинхронные ошибки не роняют приложение — не fatal.
  PlatformDispatcher.instance.onError = (error, stack) {
    crash.recordError(error, stack);
    return true;
  };

  runApp(
    UncontrolledProviderScope(container: container, child: const TachoGoApp()),
  );
}
