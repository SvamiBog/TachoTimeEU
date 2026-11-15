/// Providers of the infringements of the last 56 days with the driver's
/// explanations (More → "Infringements").
library;

import 'dart:isolate';

import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/data/db/database_provider.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/data/journal/shift_meta.dart';
import 'package:tachogo/data/report/report.dart';
import 'package:tachogo/data/violations/violation_notes.dart';

/// Сколько суток записей предъявляют при проверке на дороге: с 31.12.2024 —
/// 56 (ст. 36 Регламента 165/2014). Сутки — по UTC, вместе с сегодняшними,
/// как период «56 дней» в отчёте ([reportRange]).
const inspectionDays = 56;

/// Начало периода проверки: 00:00 UTC 55 дней назад.
DateTime inspectionStart(DateTime now) =>
    reportRange(ReportPeriod.days56, now).start;

/// Сколько суток нарушение, начатое в [at], ещё входит в период проверки,
/// считая сегодняшние: сегодняшнее — 56, начатое 55 дней назад — 1.
int inspectionDaysLeft(DateTime at, DateTime now) =>
    inspectionDays - _utcDay(now).difference(_utcDay(at)).inDays;

DateTime _utcDay(DateTime t) {
  final u = t.toUtc();
  return DateTime.utc(u.year, u.month, u.day);
}

/// Everything the infringement log needs: the journal, the calculation
/// settings, the shift countries and the period.
typedef ViolationLogInputs = ({
  List<ActivityPeriod> periods,
  List<ManualShift> manualShifts,
  ComplianceSettings settings,
  Map<DateTime, ShiftRoute> routes,
  DateTime from,
  DateTime now,
});

/// Computes the infringement log. In the app it runs in a separate isolate:
/// the engine recomputes the snapshot at every record of the period, on a busy
/// journal that takes about a second.
typedef ViolationLogComputer = Future<List<LoggedViolation>> Function(
  ViolationLogInputs inputs,
);

List<LoggedViolation> computeViolationLog(ViolationLogInputs i) => violationLog(
  periods: i.periods,
  from: i.from,
  now: i.now,
  manualShifts: i.manualShifts,
  settings: i.settings,
  routes: i.routes,
);

// Отдельной функцией: замыкание для изолята не должно захватить ничего,
// кроме входных данных.
Future<List<LoggedViolation>> _inIsolate(ViolationLogInputs inputs) =>
    Isolate.run(() => computeViolationLog(inputs));

/// Расчёт журнала нарушений; тесты экранов считают без изолята.
final violationLogComputerProvider = Provider<ViolationLogComputer>(
  (ref) => _inIsolate,
);

final violationNoteRepositoryProvider = Provider<ViolationNoteRepository>(
  (ref) => ViolationNoteRepository(ref.watch(databaseProvider)),
);

/// Пояснения водителя к нарушениям.
final violationNotesProvider = StreamProvider<List<ViolationNote>>(
  (ref) => ref.watch(violationNoteRepositoryProvider).watchAll(),
);

/// An infringement of the inspection period with the driver's explanation.
@immutable
class ViolationEntry {
  const new({
    required this.violation,
    required this.note,
    required this.daysLeft,
  });

  final LoggedViolation violation;

  /// Пояснение водителя; null — не записано.
  final ViolationNote? note;

  /// Сколько суток нарушение ещё входит в период проверки ([inspectionDays]).
  final int daysLeft;

  bool get explained => note != null;
}

/// The infringements of the inspection period, newest first.
@immutable
class ViolationList {
  const new({required this.from, required this.now, required this.entries});

  /// Начало периода проверки.
  final DateTime from;

  /// Момент расчёта.
  final DateTime now;
  final List<ViolationEntry> entries;

  /// Сколько нарушений без пояснения.
  int get unexplained => entries.where((e) => !e.explained).length;
}

/// The engine's infringement log for the inspection period and the moment it
/// was computed at.
typedef ComputedViolations = ({
  DateTime from,
  DateTime now,
  List<LoggedViolation> violations,
});

/// Нарушения за период проверки по расчёту движка. Пересчёт — при изменении
/// журнала, ручных смен, стран или настроек расчёта и раз в минуту, пока
/// экран открыт: идущее нарушение растёт, а в полночь UTC период сдвигается.
final FutureProvider<ComputedViolations> violationLogProvider =
    FutureProvider.autoDispose<ComputedViolations>((ref) async {
      ref.watch(clockProvider.select(_minuteOf));
      final now = ref.read(clockProvider);
      final settings = await ref.watch(complianceSettingsProvider.future);
      final periods = await ref.watch(activityPeriodsProvider.future);
      final manual = await ref.watch(manualShiftsProvider.future);
      final meta = await ref.watch(shiftMetaProvider.future);
      final from = inspectionStart(now);
      final violations = await ref.watch(violationLogComputerProvider)((
        periods: periods,
        manualShifts: [for (final r in manual) r.shift],
        settings: settings,
        routes: shiftRoutesOf(meta, manual),
        from: from,
        now: now,
      ));
      return (from: from, now: now, violations: violations);
    });

/// Нарушения за период проверки с пояснениями водителя, от новых к старым.
/// Новое пояснение расчёт движка не повторяет.
final Provider<AsyncValue<ViolationList>> violationListProvider =
    Provider.autoDispose<AsyncValue<ViolationList>>((ref) {
      final log = ref.watch(violationLogProvider);
      final notes = ref.watch(violationNotesProvider);
      for (final source in <AsyncValue<Object?>>[log, notes]) {
        if (source case AsyncError(:final error, :final stackTrace)
            when !source.hasValue) {
          return AsyncError(error, stackTrace);
        }
      }
      final result = log.value;
      final written = notes.value;
      if (result == null || written == null) return const AsyncLoading();
      final matched = matchViolationNotes(
        result.violations,
        written,
        result.now,
      );
      return AsyncData(
        ViolationList(
          from: result.from,
          now: result.now,
          entries: [
            for (final (i, v) in result.violations.indexed)
              ViolationEntry(
                violation: v,
                note: matched[i],
                daysLeft: inspectionDaysLeft(v.at, result.now),
              ),
          ].reversed.toList(),
        ),
      );
    });

DateTime _minuteOf(DateTime t) =>
    DateTime.utc(t.year, t.month, t.day, t.hour, t.minute);
