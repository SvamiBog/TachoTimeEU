// Нарушения за весь журнал — то, что водитель видел бы на главной, пока
// журнал шёл. Движок считает снимок на момент `now`; здесь снимки берутся
// в контрольных точках — за минуту до конца каждой записи и в её конец — по
// журналу, каким он был в тот момент: записи позже отброшены, текущая
// открыта. Нарушение засчитывается с первой точки, где появилось, до
// исчезновения. Для сверки с отчётом программы анализа тахографа (ENG-20).

import 'package:tacho_engine/tacho_engine.dart';

/// Нарушение в журнале: вид, когда появилось и статья.
typedef JournalViolation = ({
  InfringementType type,
  DateTime at,
  String article,
});

/// Нарушения журнала [periods] по порядку появления. Предупреждения
/// («скоро») не входят — только важность violation.
List<JournalViolation> journalViolations(
  List<ActivityPeriod> periods, {
  ComplianceSettings settings = const ComplianceSettings(),
  List<ManualShift> manualShifts = const [],
  DateTime? lastCardDownload,
  bool includeCard = false,
}) {
  if (periods.isEmpty) return const [];
  final sorted = [...periods]..sort((a, b) => a.start.compareTo(b.start));
  final end = sorted.map((p) => p.end ?? p.start).reduce(_later);
  final points = <DateTime>{
    for (final p in sorted) ...[
      if (p.end case final e?) ...[
        if (e.difference(p.start) > _minute) e.subtract(_minute),
        e,
      ],
    ],
    end,
  }.toList()..sort();

  final result = <JournalViolation>[];
  var previous = <InfringementType>{};
  for (final t in points) {
    final snapshot = calculateCompliance(
      periods: [
        for (final p in sorted)
          if (!p.start.isAfter(t)) _asOf(p, t),
      ],
      now: t,
      manualShifts: manualShifts,
      settings: settings,
      lastCardDownload: lastCardDownload,
    );
    final current = <InfringementType>{};
    for (final i in snapshot.infringements) {
      if (i.severity != InfringementSeverity.violation) continue;
      if (!includeCard && i.category == InfringementCategory.card) continue;
      current.add(i.type);
      if (!previous.contains(i.type)) {
        result.add((type: i.type, at: t, article: i.article));
      }
    }
    previous = current;
  }
  return result;
}

const _minute = Duration(minutes: 1);

/// Запись, какой она была в момент [t]: ещё не закончилась — открыта.
ActivityPeriod _asOf(ActivityPeriod p, DateTime t) {
  final end = p.end;
  return end == null || end.isAfter(t) ? p.withEnd(null) : p;
}

DateTime _later(DateTime a, DateTime b) => a.isAfter(b) ? a : b;
