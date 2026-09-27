import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tachogo/app.dart';
import 'package:tachogo/background/tracking_service.dart';
import 'package:tachogo/bootstrap.dart';
import 'package:tachogo/data/journal/journal_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Канал с задачей фонового сервиса автоопределения (Android).
  FlutterForegroundTask.initCommunicationPort();

  final container = ProviderContainer(
    overrides: [
      journalChangedCallbackProvider.overrideWithValue(
        TrackingMessages.notifyJournalChanged,
      ),
    ],
  );
  await bootstrap(container);

  runApp(
    UncontrolledProviderScope(container: container, child: const TachoGoApp()),
  );
}
