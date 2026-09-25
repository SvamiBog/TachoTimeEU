// Помощники для тестов регуляторного движка: журнал режимов описывается
// последовательностью отрезков, время — строками UTC и длительностями «Ч:ММ».
// Тесты перенесены из веб-прототипа (src/domain/tests) и служат спецификацией.

import 'package:tacho_engine/tacho_engine.dart';

const minute = Duration(minutes: 1);
const hour = Duration(hours: 1);
const day = Duration(days: 1);

/// Момент UTC: '2026-09-21 06:00' или '2026-09-21 06:00:30'.
DateTime utc(String value) =>
    DateTime.parse('${value.replaceFirst(' ', 'T')}Z');

Duration minutes(int n) => Duration(minutes: n);

/// Длительность: минуты числом, «Ч:ММ» или [Duration].
Duration dur(Object d) {
  if (d is Duration) return d;
  if (d is int) return Duration(minutes: d);
  final match = RegExp(r'^(\d{1,3}):([0-5]\d)$')
      .firstMatch((d as String).trim());
  if (match == null) throw ArgumentError.value(d, 'd', 'не «Ч:ММ»');
  return Duration(hours: int.parse(match[1]!), minutes: int.parse(match[2]!));
}

/// Отрезок журнала: режим и длительность.
class Seg {
  const new(
    this.mode,
    this.duration, {
    this.ferry = false,
    this.dayEnd = false,
  });

  final DriverMode mode;
  final Duration duration;
  final bool ferry;
  final bool dayEnd;
}

Seg drive(Object d, {bool ferry = false}) =>
    Seg(DriverMode.driving, dur(d), ferry: ferry);
Seg work(Object d, {bool ferry = false}) =>
    Seg(DriverMode.otherWork, dur(d), ferry: ferry);
Seg poa(Object d, {bool ferry = false}) =>
    Seg(DriverMode.availability, dur(d), ferry: ferry);
Seg rest(Object d, {bool ferry = false, bool dayEnd = false}) =>
    Seg(DriverMode.rest, dur(d), ferry: ferry, dayEnd: dayEnd);

/// Повторяет набор отрезков n раз.
List<Seg> repeat(int n, List<Seg> segs) => [
  for (var i = 0; i < n; i++) ...segs,
];

/// Рабочий день с заданным вождением: блоки по 4:30 с перерывами 45 мин,
/// чтобы не нарушать ст. 7 там, где тест проверяет другое правило.
List<Seg> drivingDay(Object total) {
  var left = dur(total);
  final segs = <Seg>[];
  while (left > Duration.zero) {
    final chunk = left < EuLimits.continuousDriving
        ? left
        : EuLimits.continuousDriving;
    segs.add(drive(chunk));
    left -= chunk;
    if (left > Duration.zero) segs.add(rest(45));
  }
  return segs;
}

({List<ActivityPeriod> periods, DateTime end}) _toPeriods(
  DateTime start,
  List<Seg> segs, {
  required bool closeLast,
}) {
  var t = start;
  final periods = <ActivityPeriod>[];
  for (final (i, s) in segs.indexed) {
    final from = t;
    t = t.add(s.duration);
    final open = i == segs.length - 1 && !closeLast;
    periods.add(
      ActivityPeriod(
        id: i,
        mode: s.mode,
        start: from,
        end: open ? null : t,
        ferry: s.ferry,
        dayEnd: s.dayEnd,
      ),
    );
  }
  return (periods: periods, end: t);
}

/// Отрезки подряд с момента start; последний открыт. now — конец последнего
/// отрезка.
({List<ActivityPeriod> periods, DateTime now}) logFrom(
  DateTime start,
  List<Seg> segs,
) {
  final r = _toPeriods(start, segs, closeLast: false);
  return (periods: r.periods, now: r.end);
}

/// Отрезки подряд, последний открыт и идёт до now.
List<ActivityPeriod> logUntil(DateTime now, List<Seg> segs) {
  final total = segs.fold(Duration.zero, (sum, s) => sum + s.duration);
  return _toPeriods(now.subtract(total), segs, closeLast: false).periods;
}

/// Отрезки подряд с момента start, все закрыты.
List<ActivityPeriod> closedLog(DateTime start, List<Seg> segs) =>
    _toPeriods(start, segs, closeLast: true).periods;

ComplianceSnapshot calc(
  List<ActivityPeriod> periods,
  DateTime now, {
  ComplianceSettings settings = const ComplianceSettings(),
  List<ManualShift> manual = const [],
  DateTime? lastCardDownload,
}) => calculateCompliance(
  periods: periods,
  now: now,
  manualShifts: manual,
  settings: settings,
  lastCardDownload: lastCardDownload,
);

List<InfringementType> keys(ComplianceSnapshot m) => [
  for (final i in m.infringements) i.type,
];

/// Смены журнала по возрастанию начала.
List<JournalShift> journalShifts(
  List<ActivityPeriod> periods,
  DateTime now, {
  CrewMode crew = CrewMode.solo,
  List<ManualShift> manual = const [],
}) {
  final m = calc(
    periods,
    now,
    settings: ComplianceSettings(crew: crew),
    manual: manual,
  );
  return [
    for (final w in buildJournal(
      timeline: m.timeline,
      now: now,
      manualShifts: manual,
      crew: crew,
    ))
      ...w.shifts,
  ]..sort((a, b) => a.start.compareTo(b.start));
}

/// Ручная смена: вождение и отдых после неё.
ManualShift manualShift(
  DateTime start, {
  Object span = '10:00',
  Object drive = '9:00',
  RestKind restKind = RestKind.daily,
  Object rest = '11:00',
  bool split = false,
  int? id,
}) => ManualShift(
  id: id,
  start: start,
  end: start.add(dur(span)),
  driving: dur(drive),
  restKind: restKind,
  rest: dur(rest),
  splitRest: split,
);

/// Детерминированный генератор псевдослучайных чисел (mulberry32, как в
/// прототипе): одинаковый seed — одинаковые сценарии при каждом запуске.
class Rng {
  new(int seed) : _a = seed & _mask;

  static const _mask = 0xFFFFFFFF;
  int _a;

  double next() {
    _a = (_a + 0x6D2B79F5) & _mask;
    var t = _a;
    t = _imul(t ^ (t >>> 15), t | 1);
    t = (t ^ (t + _imul(t ^ (t >>> 7), t | 61))) & _mask;
    return ((t ^ (t >>> 14)) & _mask) / 4294967296;
  }

  int nextInt(int min, int max) => min + (next() * (max - min + 1)).floor();

  T pick<T>(List<T> items) => items[(next() * items.length).floor()];

  static int _imul(int a, int b) => (a * b) & _mask;
}
