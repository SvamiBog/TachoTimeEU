import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/data/db/database_provider.dart';
import 'package:tachogo/data/journal/activity_repository.dart';
import 'package:tachogo/data/journal/card_download_repository.dart';
import 'package:tachogo/data/settings/settings_providers.dart';

/// Сообщает другому Flutter-движку, что журнал изменился: приложение —
/// фоновому сервису и наоборот. Задают `main.dart` и задача сервиса.
final journalChangedCallbackProvider = Provider<void Function()?>(
  (ref) => null,
);

final activityRepositoryProvider = Provider<ActivityRepository>(
  (ref) => ActivityRepository(
    ref.watch(databaseProvider),
    onChanged: ref.watch(journalChangedCallbackProvider),
  ),
);

final cardDownloadRepositoryProvider = Provider<CardDownloadRepository>(
  (ref) => CardDownloadRepository(ref.watch(databaseProvider)),
);

final activityPeriodsProvider = StreamProvider<List<ActivityPeriod>>(
  (ref) => ref.watch(activityRepositoryProvider).watchPeriods(),
);

final lastCardDownloadProvider = StreamProvider<DateTime?>(
  (ref) => ref.watch(cardDownloadRepositoryProvider).watchLast(),
);

/// Текущее время UTC, обновляется раз в секунду: от него пересчитываются
/// таймеры. Время режима идёт от момента переключения, а не от начала
/// минуты, поэтому тик по минутам запаздывал бы до 59 с.
final clockProvider = NotifierProvider<Clock, DateTime>(Clock.new);

class Clock extends Notifier<DateTime> {
  static const tick = Duration(seconds: 1);

  @override
  DateTime build() {
    final timer = Timer.periodic(tick, (_) => state = _now());
    ref.onDispose(timer.cancel);
    return _now();
  }

  static DateTime _now() => DateTime.now().toUtc();
}

/// Настройки, от которых зависит расчёт: экипаж, пакет мобильности, пороги.
final complianceSettingsProvider = StreamProvider<ComplianceSettings>(
  (ref) => ref.watch(settingsRepositoryProvider).watchComplianceSettings(),
);

/// Состояние водителя, таймеры и нарушения на текущий момент.
final complianceProvider = Provider<AsyncValue<ComplianceSnapshot>>((ref) {
  final now = ref.watch(clockProvider);
  final settings = ref.watch(complianceSettingsProvider);
  final periods = ref.watch(activityPeriodsProvider);
  final lastCard = ref.watch(lastCardDownloadProvider);
  final sources = <AsyncValue<Object?>>[settings, periods, lastCard];
  for (final s in sources) {
    if (s case AsyncError(:final error, :final stackTrace)) {
      return AsyncError(error, stackTrace);
    }
  }
  return switch ((settings, periods, lastCard)) {
    (
      AsyncData(value: final s),
      AsyncData(value: final p),
      AsyncData(value: final card),
    ) =>
      AsyncData(
        calculateCompliance(
          periods: p,
          now: now,
          settings: s,
          lastCardDownload: card,
        ),
      ),
    _ => const AsyncLoading(),
  };
});
