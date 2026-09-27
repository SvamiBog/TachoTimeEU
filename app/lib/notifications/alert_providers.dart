import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tachogo/core/observability/observability_providers.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/data/settings/settings_providers.dart';
import 'package:tachogo/notifications/alert_scheduler.dart';
import 'package:tachogo/notifications/notification_platform.dart';

final notificationPlatformProvider = Provider<NotificationPlatform>(
  (ref) => const NotificationPlatform(),
);

/// Расписание уведомлений о лимитах. Запускает `bootstrap`.
final alertSchedulerProvider = Provider<AlertScheduler>((ref) {
  final scheduler = AlertScheduler(
    journal: ref.watch(activityRepositoryProvider),
    edits: ref.watch(journalEditRepositoryProvider),
    cards: ref.watch(cardDownloadRepositoryProvider),
    settings: ref.watch(settingsRepositoryProvider),
    platform: ref.watch(notificationPlatformProvider),
    onError: ref.watch(crashReporterProvider).recordError,
  );
  ref.onDispose(() => unawaited(scheduler.dispose()));
  return scheduler;
});

/// Точные будильники разрешены или не нужны (не Android) — для подсказки
/// в настройках. Экран обновляет его, когда водитель вернулся из настроек
/// телефона.
final FutureProvider<bool> exactAlarmsProvider = FutureProvider.autoDispose((
  ref,
) async {
  final platform = ref.watch(notificationPlatformProvider);
  return !platform.isAndroid || await platform.canScheduleExact();
});
