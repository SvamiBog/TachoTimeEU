import 'dart:io' show Platform;

import 'package:flutter/services.dart' show PlatformException;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

/// Канал уведомлений Android: водитель настраивает звук и важность по
/// каналам в настройках телефона.
enum AlertChannel {
  /// Приближение лимитов и нарушения: всплывающие, со звуком.
  limits,

  /// Отдых набран: обычная важность.
  rest,
}

/// Уведомление в расписании: момент и готовые строки.
typedef ScheduledAlert = ({
  int id,
  DateTime at,
  AlertChannel channel,
  String title,
  String body,
  String? article,
});

/// Названия каналов на языке интерфейса.
typedef AlertChannelNames = Map<AlertChannel, ({String name, String hint})>;

/// Всё, что уведомлениям о лимитах нужно от плагина: расписание,
/// показанные уведомления, точные будильники. Одна точка, которую тесты
/// подменяют целиком. До релиза — только Android (`CLAUDE.md`).
class NotificationPlatform {
  const new();

  static final _plugin = FlutterLocalNotificationsPlugin();
  static Future<void>? _initialized;

  bool get isAndroid => Platform.isAndroid;

  static AndroidFlutterLocalNotificationsPlugin? get _android => _plugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();

  /// Один раз на Flutter-движок: у приложения и фонового сервиса свои.
  /// Не получилось — попробуем при следующем пересчёте.
  Future<void> initialize() => _initialized ??= _plugin
      .initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        ),
      )
      .then<void>(
        (_) {},
        onError: (Object error, StackTrace stack) {
          _initialized = null;
          Error.throwWithStackTrace(error, stack);
        },
      );

  /// Каналы с названиями на языке интерфейса: Android обновляет название
  /// существующего канала, звук и важность остаются, как их настроил
  /// водитель.
  Future<void> createChannels(AlertChannelNames names) async {
    for (final MapEntry(key: channel, value: n) in names.entries) {
      await _android?.createNotificationChannel(
        AndroidNotificationChannel(
          channel.name,
          n.name,
          description: n.hint,
          importance: _importance(channel),
        ),
      );
    }
  }

  /// Точные будильники разрешены (Android 12+: «Будильники и
  /// напоминания»). Без них система может сдвинуть уведомление.
  Future<bool> canScheduleExact() async =>
      await _android?.canScheduleExactNotifications() ?? false;

  /// Открывает системный экран «Будильники и напоминания». Вызывать из UI.
  Future<bool> requestExactAlarms() async =>
      await _android?.requestExactAlarmsPermission() ?? false;

  Future<void> cancelAllPending() => _plugin.cancelAllPendingNotifications();

  /// Ставит уведомление; [exact] — точным будильником. Разрешение на
  /// точные отозвали между проверкой и постановкой — ставим неточный.
  Future<void> schedule(
    ScheduledAlert alert, {
    required bool exact,
    required AlertChannelNames names,
  }) async {
    try {
      await _schedule(alert, exact: exact, names: names);
    } on PlatformException catch (e) {
      if (!exact || e.code != 'exact_alarms_not_permitted') rethrow;
      await _schedule(alert, exact: false, names: names);
    }
  }

  Future<void> _schedule(
    ScheduledAlert alert, {
    required bool exact,
    required AlertChannelNames names,
  }) {
    final channel = names[alert.channel]!;
    return _plugin.zonedSchedule(
      id: alert.id,
      scheduledDate: tz.TZDateTime.from(alert.at, tz.UTC),
      title: alert.title,
      body: alert.body,
      androidScheduleMode: exact
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexactAllowWhileIdle,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          alert.channel.name,
          channel.name,
          channelDescription: channel.hint,
          importance: _importance(alert.channel),
          priority: alert.channel == AlertChannel.limits
              ? Priority.high
              : Priority.defaultPriority,
          category: alert.channel == AlertChannel.limits
              ? AndroidNotificationCategory.reminder
              : AndroidNotificationCategory.status,
          styleInformation: BigTextStyleInformation(alert.body),
          subText: alert.article,
          visibility: NotificationVisibility.public,
        ),
      ),
    );
  }

  /// id уведомлений, которые сейчас видны в шторке.
  Future<List<int>> activeIds() async => [
    for (final n in await _plugin.getActiveNotifications()) ?n.id,
  ];

  /// id уведомлений в расписании системы — ещё не показанных. Для отчёта
  /// о проблеме в бете.
  Future<List<int>> pendingIds() async => [
    for (final r in await _plugin.pendingNotificationRequests()) r.id,
  ];

  /// Убирает уведомление из шторки и из расписания.
  Future<void> cancel(int id) => _plugin.cancel(id: id);

  static Importance _importance(AlertChannel channel) => switch (channel) {
    AlertChannel.limits => Importance.high,
    AlertChannel.rest => Importance.defaultImportance,
  };
}
