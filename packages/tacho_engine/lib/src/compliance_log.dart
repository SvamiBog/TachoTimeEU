/// The log a compliance calculation works on: the activity records as a
/// timeline and the manual shifts with the rest after each of them, plus the
/// totals the snapshot and the journal both take from it — driving in a time
/// window, the weekly rests and the right to a reduced one (Art. 6(2), 6(3),
/// 8(6)).
library;

import 'package:tacho_engine/src/compliance.dart';
import 'package:tacho_engine/src/driver_mode.dart';
import 'package:tacho_engine/src/eu_limits.dart';
import 'package:tacho_engine/src/manual_rest.dart';
import 'package:tacho_engine/src/manual_shift.dart';
import 'package:tacho_engine/src/shift_route.dart';
import 'package:tacho_engine/src/shifts.dart';
import 'package:tacho_engine/src/time.dart';
import 'package:tacho_engine/src/timeline.dart';
import 'package:tacho_engine/src/weekly_rest_right.dart';

/// The records and the manual shifts of one calculation at [now].
final class ComplianceLog {
  /// [manual] — смены, внесённые итогами; отдых после каждой — до начала
  /// следующей смены ([manualRests]).
  factory of(Timeline timeline, List<ManualShift> manual, DateTime now) =>
      ComplianceLog._(
        timeline,
        manual,
        manualRests(manual, timeline, now),
        now,
      );

  new _(this.timeline, this.manual, this.restOfManual, this.now)
    : manualRest = restOfManual.nonNulls.toList(),
      days = ManualDays(manual, restOfManual),
      openBlock = switch (timeline.blocks.lastOrNull) {
        final last? when last.open => last,
        _ => null,
      };

  final Timeline timeline;
  final List<ManualShift> manual;

  /// Отдых после каждой смены из [manual], в том же порядке; null — смена
  /// идёт или отдых после неё не начат.
  final List<ManualRest?> restOfManual;

  /// Отдыхи ручных смен, которые есть.
  final List<ManualRest> manualRest;

  /// Рабочие дни, которые продолжаются через ручные смены.
  final ManualDays days;
  final DateTime now;

  /// Текущий режим — последний блок шкалы, если он не закончен; null —
  /// режим не записан.
  final Block? openBlock;

  DriverMode? get currentMode => openBlock?.mode;

  /// Последний отдых из записей; null — отдыха в записях нет.
  RestPeriod? get lastRest => timeline.rests.lastOrNull;

  /// Вождение в [from, to) ([drivingBetween]).
  Duration drivingIn(DateTime from, DateTime to) =>
      drivingBetween(timeline, manual, from, to);
}

/// Вождение в [from, to): из записей [timeline] — точно по отрезкам, даже
/// если смена переходит через границу; ручная смена из [manual] — целиком
/// там, где она началась.
Duration drivingBetween(
  Timeline timeline,
  Iterable<ManualShift> manual,
  DateTime from,
  DateTime to,
) {
  final blocks = timeline.blocks;
  var total = Duration.zero;
  // Блоки идут по времени и не накладываются ([buildBlocks]): все, что
  // кончились до [from], пропускаем сразу, а на первом, начавшемся с [to],
  // останавливаемся. Журнал по неделям и журнал нарушений спрашивают
  // вождение по сотне раз — перебор всех блоков рос бы квадратично.
  for (var i = _firstEndingAfter(blocks, from); i < blocks.length; i++) {
    final b = blocks[i];
    if (!b.start.isBefore(to)) break;
    if (b.mode == DriverMode.driving) {
      total += overlap(b.start, b.end, from, to);
    }
  }
  for (final m in manual) {
    if (!m.start.isBefore(from) && m.start.isBefore(to)) total += m.driving;
  }
  return total;
}

/// Индекс первого блока, который кончается после [at]; длина списка — таких
/// нет. Двоичный поиск: концы блоков не убывают.
int _firstEndingAfter(List<Block> blocks, DateTime at) {
  var low = 0;
  var high = blocks.length;
  while (low < high) {
    final middle = (low + high) >> 1;
    if (blocks[middle].end.isAfter(at)) {
      high = middle;
    } else {
      low = middle + 1;
    }
  }
  return low;
}

/// Отдых ручной смены [r] — тот же, что отдых из записей [p]: они
/// пересекаются (после «Завершить день» с вождением смена стала ручной, а
/// отдых остался записью). Идущий — до [now].
bool overlapsRecordedRest(RestPeriod p, ManualRest r, DateTime now) =>
    p.start.isBefore(r.end ?? now) && (p.open ? now : p.end).isAfter(r.start);

/// Недельные отдыхи из записей [timeline] и после ручных смен
/// ([restOfManual]), идущий — тоже ([WeeklyRest.end] null). Отдых ручной
/// смены, который уже есть в записях, — один раз.
List<WeeklyRest> weeklyRestsOf(
  Timeline timeline,
  List<ManualRest?> restOfManual,
  DateTime now,
) {
  final recordedWeekly = timeline.rests.where((p) => p.isWeekly).toList();
  return [
    for (final p in recordedWeekly)
      WeeklyRest(
        start: p.start,
        end: p.open ? null : p.end,
        duration: p.rest,
        status: weeklyRestStatus(p.rest),
      ),
    for (final r in restOfManual.nonNulls)
      if (r.kind == RestKind.weekly &&
          !recordedWeekly.any((p) => overlapsRecordedRest(p, r, now)))
        WeeklyRest(
          start: r.start,
          end: r.end,
          duration: r.duration,
          status: weeklyRestStatus(r.duration),
        ),
  ];
}

/// Driving of the calendar week of the calculation and of the two weeks it
/// ends (Art. 6(2), 6(3)). A week starts on Monday 00:00 UTC, as on the
/// tachograph.
final class WeekDriving {
  factory of(ComplianceLog log) {
    final start = weekStartUtc(log.now);
    final weekly = log.drivingIn(start, start.add(week));
    return WeekDriving._(
      start: start,
      weekly: weekly,
      fortnight: weekly + log.drivingIn(start.subtract(week), start),
    );
  }

  new _({required this.start, required this.weekly, required this.fortnight});

  final DateTime start;
  final Duration weekly;

  /// Эта неделя и прошлая.
  final Duration fortnight;

  /// До 56 ч за неделю; отрицательный — превышение.
  Duration get weeklyLeft => EuLimits.weeklyDriving - weekly;

  /// До 90 ч за две недели; отрицательный — превышение.
  Duration get fortnightLeft => EuLimits.fortnightDriving - fortnight;
}

/// The completed weekly rests of the log and the right to a reduced one
/// (Art. 8(6)): two in a row only with the mobility package, both outside the
/// company country, and at least two regular ones in any four in a row.
final class WeeklyRestState {
  /// Страна отдыха — там, где кончилась смена перед ним ([routes] и страна
  /// фирмы из [settings]); страна не выбрана — не проверяем.
  factory of(
    ComplianceLog log,
    ComplianceSettings settings,
    Map<DateTime, ShiftRoute> routes,
  ) {
    final completed = _sortedByStart(
      weeklyRestsOf(log.timeline, log.restOfManual, log.now),
    ).where((r) => r.end != null).toList();
    final atBase = atBaseCountry(
      baseCountry: settings.baseCountry,
      shiftStarts: [
        for (final s in log.timeline.shifts) s.start,
        for (final m in log.manual) m.start,
      ],
      routes: routes,
    );
    ReducedWeeklyRestRight rightAt(DateTime start, List<WeeklyRest> before) =>
        reducedWeeklyRestRight(
          before,
          restStart: start,
          mobilityPackage: settings.mobilityPackage,
          atBase: atBase,
        );
    final last = completed.lastOrNull;
    return WeeklyRestState._(
      completed: completed,
      right: rightAt(log.now, completed),
      // Последний недельный — сокращённый, а права на него не было
      lastWithoutRight:
          last != null &&
          last.status == RestStatus.reduced &&
          rightAt(last.start, completed.sublist(0, completed.length - 1)) !=
              ReducedWeeklyRestRight.allowed,
    );
  }

  new _({
    required this.completed,
    required this.right,
    required this.lastWithoutRight,
  });

  /// Законченные недельные отдыхи по началу.
  final List<WeeklyRest> completed;

  /// Право на сокращённый недельный отдых, если начать его сейчас.
  final ReducedWeeklyRestRight right;

  /// Последний недельный отдых сокращён без права на него.
  final bool lastWithoutRight;

  /// Сокращённый недельный отдых можно начать сейчас.
  bool get reducedAvailable => right == ReducedWeeklyRestRight.allowed;

  /// Сокращённый недоступен только из-за страны фирмы.
  bool get reducedAtBase => right == ReducedWeeklyRestRight.atBase;

  WeeklyRest? get last => completed.lastOrNull;

  WeeklyRest? get previous =>
      completed.length < 2 ? null : completed[completed.length - 2];

  /// Рабочая неделя — с конца последнего недельного отдыха; null — о нём
  /// нет данных.
  DateTime? get workWeekStart => last?.end;
}

/// Отдыхи по началу; с одинаковым началом — в прежнем порядке.
List<WeeklyRest> _sortedByStart(List<WeeklyRest> rests) {
  final indexed = rests.indexed.toList()
    ..sort((a, b) {
      final byStart = a.$2.start.compareTo(b.$2.start);
      return byStart != 0 ? byStart : a.$1.compareTo(b.$1);
    });
  return [for (final (_, r) in indexed) r];
}
