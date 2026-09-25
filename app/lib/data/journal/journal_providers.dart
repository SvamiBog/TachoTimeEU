import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/data/db/database_provider.dart';
import 'package:tachogo/data/journal/activity_repository.dart';
import 'package:tachogo/data/journal/card_download_repository.dart';

final activityRepositoryProvider = Provider<ActivityRepository>(
  (ref) => ActivityRepository(ref.watch(databaseProvider)),
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

/// Настройки, от которых зависит расчёт. До экрана настроек (Фаза 2) —
/// значения по умолчанию: один водитель, пакет мобильности, порог 30 мин.
final complianceSettingsProvider = Provider<ComplianceSettings>(
  (ref) => const ComplianceSettings(),
);

/// Состояние водителя, таймеры и нарушения на текущий момент.
final complianceProvider = Provider<AsyncValue<ComplianceSnapshot>>((ref) {
  final now = ref.watch(clockProvider);
  final settings = ref.watch(complianceSettingsProvider);
  final periods = ref.watch(activityPeriodsProvider);
  final lastCard = ref.watch(lastCardDownloadProvider);
  return switch ((periods, lastCard)) {
    (AsyncData(value: final p), AsyncData(value: final card)) => AsyncData(
      calculateCompliance(
        periods: p,
        now: now,
        settings: settings,
        lastCardDownload: card,
      ),
    ),
    (AsyncError(:final error, :final stackTrace), _) ||
    (
      _,
      AsyncError(:final error, :final stackTrace),
    ) => AsyncError(error, stackTrace),
    _ => const AsyncLoading(),
  };
});
