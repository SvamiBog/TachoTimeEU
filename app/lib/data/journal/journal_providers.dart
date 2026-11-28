/// Providers of the journal data, the ticking clock and the engine results that
/// screens watch.
library;

import 'dart:async';
import 'dart:ui' show AppLifecycleState;

import 'package:clock/clock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show ProviderBase;
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/data/backup/journal_backup.dart';
import 'package:tachogo/data/db/database_provider.dart';
import 'package:tachogo/data/journal/activity_repository.dart';
import 'package:tachogo/data/journal/card_download_repository.dart';
import 'package:tachogo/data/journal/card_import_repository.dart';
import 'package:tachogo/data/journal/journal_cleaner.dart';
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

/// Перенос считанной карты в журнал и «Вернуть как было» (BT-24).
final cardImportRepositoryProvider = Provider<CardImportRepository>(
  (ref) => CardImportRepository(
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

/// «Очистить все данные» в настройках.
final journalCleanerProvider = Provider<JournalCleaner>(
  (ref) => JournalCleaner(
    ref.watch(databaseProvider),
    onChanged: ref.watch(journalChangedCallbackProvider),
  ),
);

/// Перенос журнала на другой телефон файлом (Premium, docs/premium.md).
final journalBackupProvider = Provider<JournalBackup>(
  (ref) => JournalBackup(
    ref.watch(databaseProvider),
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

/// Приложение на экране. Сообщает корневой виджет (`TachoGoApp`); пока он
/// не сообщил — на экране.
final appVisibleProvider = NotifierProvider<AppVisibility, bool>(
  AppVisibility.new,
);

/// Whether the app is on screen: the clock ticks only while it is.
class AppVisibility extends Notifier<bool> {
  @override
  bool build() => true;

  /// Состояние приложения изменилось. Шторка уведомлений и системный
  /// диалог (`inactive`) приложение не прячут — часы идут.
  void onLifecycle(AppLifecycleState lifecycle) => state = switch (lifecycle) {
    AppLifecycleState.resumed || AppLifecycleState.inactive => true,
    AppLifecycleState.hidden ||
    AppLifecycleState.paused ||
    AppLifecycleState.detached => false,
  };
}

/// Текущее время UTC, обновляется раз в секунду: от него пересчитываются
/// таймеры. Время режима идёт от момента переключения, а не от начала
/// минуты, поэтому тик по минутам запаздывал бы до 59 с.
///
/// В свёрнутом приложении ([appVisibleProvider]) часы стоят: процесс живёт
/// вместе с фоновым сервисом, и расчёт по всему журналу раз в секунду шёл
/// бы часами впустую. Уведомления от этих часов не зависят — их ставит
/// `AlertScheduler` по прогнозу. Вернувшись на экран, часы сразу показывают
/// текущее время.
final clockProvider = NotifierProvider<Clock, DateTime>(Clock.new);

/// The current UTC time, updated every second while the app is on screen:
/// timers are recomputed from it.
class Clock extends Notifier<DateTime> {
  static const tick = Duration(seconds: 1);

  @override
  DateTime build() {
    if (ref.watch(appVisibleProvider)) {
      final timer = Timer.periodic(tick, (_) => state = _now());
      ref.onDispose(timer.cancel);
    }
    return _now();
  }

  // `clock` из package:clock — в тестах его подменяет fake_async.
  static DateTime _now() => clock.now().toUtc();
}

/// Настройки, от которых зависит расчёт: экипаж, пакет мобильности, страна
/// фирмы, пороги.
final complianceSettingsProvider = StreamProvider<ComplianceSettings>(
  (ref) => ref.watch(settingsRepositoryProvider).watchComplianceSettings(),
);

/// Всё, что расчёт читает из базы. Корневой виджет подписывается на них с
/// первого кадра: база отвечает в своём изоляте, пока читаются настройки и
/// строится главная, — иначе чтение журнала началось бы только после этого.
final journalSources = <ProviderBase<AsyncValue<Object?>>>[
  complianceSettingsProvider,
  activityPeriodsProvider,
  manualShiftsProvider,
  lastCardDownloadProvider,
  shiftMetaProvider,
];

/// Состояние водителя, таймеры и нарушения на текущий момент.
final complianceProvider = Provider<AsyncValue<ComplianceSnapshot>>((ref) {
  final now = ref.watch(clockProvider);
  final settings = ref.watch(complianceSettingsProvider);
  final periods = ref.watch(activityPeriodsProvider);
  final manual = ref.watch(manualShiftsProvider);
  final lastCard = ref.watch(lastCardDownloadProvider);
  final meta = ref.watch(shiftMetaProvider);
  final sources = <AsyncValue<Object?>>[
    settings,
    periods,
    manual,
    lastCard,
    meta,
  ];
  for (final s in sources) {
    if (s case AsyncError(:final error, :final stackTrace)) {
      return AsyncError(error, stackTrace);
    }
  }
  return switch ((settings, periods, manual, lastCard, meta)) {
    (
      AsyncData(value: final s),
      AsyncData(value: final p),
      AsyncData(value: final m),
      AsyncData(value: final card),
      AsyncData(value: final meta),
    ) =>
      AsyncData(
        calculateCompliance(
          periods: p,
          now: now,
          manualShifts: [for (final r in m) r.shift],
          settings: s,
          lastCardDownload: card,
          routes: shiftRoutesOf(meta, m),
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
      AsyncData(_journal(now, s, p, m, meta)),
    _ => const AsyncLoading(),
  };
});

Journal _journal(
  DateTime now,
  ComplianceSettings settings,
  List<ActivityPeriod> periods,
  List<ManualShiftRecord> manual,
  Map<DateTime, ShiftMeta> meta,
) => _buildJournal(
  now: now,
  settings: settings,
  periods: periods,
  manualShifts: [for (final r in manual) r.shift],
  routes: shiftRoutesOf(meta, manual),
  recordedMeta: meta,
  manualMeta: {for (final r in manual) ?r.shift.id: r.meta},
);

/// Журнал прямо из базы, не дожидаясь потоков [journalProvider]: сразу
/// после записи правки. Страны смен для расчёта — [routes], страны и
/// заметки в журнал не читаются.
Future<Journal> readJournal({
  required ActivityRepository activity,
  required JournalEditRepository edits,
  required ComplianceSettings settings,
  required Map<DateTime, ShiftRoute> routes,
  required DateTime now,
}) async {
  final periods = await activity.periods();
  final manual = await edits.manualShifts();
  return _buildJournal(
    now: now,
    settings: settings,
    periods: periods,
    manualShifts: manual,
    routes: routes,
  );
}

Journal _buildJournal({
  required DateTime now,
  required ComplianceSettings settings,
  required List<ActivityPeriod> periods,
  required List<ManualShift> manualShifts,
  required Map<DateTime, ShiftRoute> routes,
  Map<DateTime, ShiftMeta> recordedMeta = const {},
  Map<int, ShiftMeta> manualMeta = const {},
}) {
  final timeline = analyzeTimeline(periods, now);
  return Journal(
    now: now,
    periods: periods,
    timeline: timeline,
    weeks: buildJournal(
      timeline: timeline,
      now: now,
      manualShifts: manualShifts,
      crew: settings.crew,
      mobilityPackage: settings.mobilityPackage,
      baseCountry: settings.baseCountry,
      routes: routes,
    ),
    recordedMeta: recordedMeta,
    manualMeta: manualMeta,
  );
}

DateTime _minuteOf(DateTime t) =>
    DateTime.utc(t.year, t.month, t.day, t.hour, t.minute);

/// The journal by weeks with the countries and notes of the shifts.
class Journal {
  const new({
    required this.now,
    required this.periods,
    required this.timeline,
    required this.weeks,
    required this.recordedMeta,
    required this.manualMeta,
  });

  /// Момент расчёта.
  final DateTime now;

  /// Записи режимов — для правок и CSV.
  final List<ActivityPeriod> periods;

  /// Шкала: блоки режимов для деталей дня.
  final Timeline timeline;

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

  /// Страны смен для движка по началу смены — для рабочих дней.
  Map<DateTime, ShiftRoute> get routes => {
    for (final s in shifts) s.start: metaOf(s).route,
  };
}
