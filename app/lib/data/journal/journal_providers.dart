import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/data/db/database_provider.dart';
import 'package:tachogo/data/journal/activity_repository.dart';
import 'package:tachogo/data/journal/card_download_repository.dart';
import 'package:tachogo/data/journal/journal_edit_repository.dart';
import 'package:tachogo/data/journal/shift_meta.dart';
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

/// Слой ручных правок журнала (Premium, docs/premium.md).
final journalEditRepositoryProvider = Provider<JournalEditRepository>(
  (ref) => JournalEditRepository(
    ref.watch(databaseProvider),
    ref.watch(settingsRepositoryProvider),
    onChanged: ref.watch(journalChangedCallbackProvider),
  ),
);

/// Смены, внесённые вручную итогами.
final manualShiftsProvider = StreamProvider<List<ManualShiftRecord>>(
  (ref) => ref.watch(journalEditRepositoryProvider).watchManualShifts(),
);

/// Страны и заметки смен из записей режимов: начало смены → данные.
final shiftMetaProvider = StreamProvider<Map<DateTime, ShiftMeta>>(
  (ref) => ref.watch(journalEditRepositoryProvider).watchShiftMeta(),
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

  // `clock` из package:clock — в тестах его подменяет fake_async.
  static DateTime _now() => clock.now().toUtc();
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
  final manual = ref.watch(manualShiftsProvider);
  final lastCard = ref.watch(lastCardDownloadProvider);
  final sources = <AsyncValue<Object?>>[settings, periods, manual, lastCard];
  for (final s in sources) {
    if (s case AsyncError(:final error, :final stackTrace)) {
      return AsyncError(error, stackTrace);
    }
  }
  return switch ((settings, periods, manual, lastCard)) {
    (
      AsyncData(value: final s),
      AsyncData(value: final p),
      AsyncData(value: final m),
      AsyncData(value: final card),
    ) =>
      AsyncData(
        calculateCompliance(
          periods: p,
          now: now,
          manualShifts: [for (final r in m) r.shift],
          settings: s,
          lastCardDownload: card,
        ),
      ),
    _ => const AsyncLoading(),
  };
});

/// Журнал по неделям (экран 2) и данные для отчёта. Показывает целые
/// минуты, поэтому пересчитывается раз в минуту и при изменении данных,
/// а не на каждый тик часов.
final journalProvider = Provider<AsyncValue<Journal>>((ref) {
  ref.watch(clockProvider.select(_minuteOf));
  final now = ref.read(clockProvider);
  final settings = ref.watch(complianceSettingsProvider);
  final periods = ref.watch(activityPeriodsProvider);
  final manual = ref.watch(manualShiftsProvider);
  final meta = ref.watch(shiftMetaProvider);
  final sources = <AsyncValue<Object?>>[settings, periods, manual, meta];
  for (final s in sources) {
    if (s case AsyncError(:final error, :final stackTrace)) {
      return AsyncError(error, stackTrace);
    }
  }
  return switch ((settings, periods, manual, meta)) {
    (
      AsyncData(value: final s),
      AsyncData(value: final p),
      AsyncData(value: final m),
      AsyncData(value: final meta),
    ) =>
      AsyncData(
        Journal(
          now: now,
          periods: p,
          weeks: buildJournal(
            timeline: analyzeTimeline(p, now),
            now: now,
            manualShifts: [for (final r in m) r.shift],
            crew: s.crew,
          ),
          recordedMeta: meta,
          manualMeta: {for (final r in m) ?r.shift.id: r.meta},
        ),
      ),
    _ => const AsyncLoading(),
  };
});

DateTime _minuteOf(DateTime t) =>
    DateTime.utc(t.year, t.month, t.day, t.hour, t.minute);

/// Журнал по неделям со странами и заметками смен.
class Journal {
  const new({
    required this.now,
    required this.periods,
    required this.weeks,
    required this.recordedMeta,
    required this.manualMeta,
  });

  /// Момент расчёта.
  final DateTime now;

  /// Записи режимов — для деталей дня и CSV.
  final List<ActivityPeriod> periods;

  /// Недели от текущей к старым.
  final List<JournalWeek> weeks;
  final Map<DateTime, ShiftMeta> recordedMeta;
  final Map<int, ShiftMeta> manualMeta;

  /// Все смены, от новых к старым.
  Iterable<JournalShift> get shifts => weeks.expand((w) => w.shifts);

  ShiftMeta metaOf(JournalShift shift) {
    final manual = shift.manual;
    if (manual != null) return manualMeta[manual.id] ?? ShiftMeta.empty;
    return recordedMeta[shift.start] ?? ShiftMeta.empty;
  }
}
