import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/core/l10n/format.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/data/report/report.dart';
import 'package:tachogo/l10n/app_localizations.dart';

/// Нарушение за период со статьёй регламента.
typedef ReportViolation = ({String text, String regulation, String article});

/// Нарушения по оценке журнала: больше 10 ч вождения, больше 15 ч (экипаж —
/// 21 ч) рабочего дня, недостаточный отдых, больше 56 ч за неделю и 90 ч за
/// две. Правила не повторяются — берутся оценки `buildJournal`.
List<ReportViolation> reportViolations(
  Journal journal,
  TimeRange range, {
  required CrewMode crew,
  required AppLocalizations l,
  required String locale,
}) {
  String date(DateTime t) => formatWeekdayDay(t, locale);
  ReportViolation v(String text, InfringementType type, [String? article]) => (
    text: text,
    regulation: type.regulation,
    article: article ?? type.article,
  );
  final spanLimit = workdayWindow(crew) - EuLimits.dailyRestReduced;
  final result = <ReportViolation>[];
  for (final s in shiftsInRange(journal.shifts, range)) {
    if (s.driveLevel == JournalLevel.bad) {
      result.add(
        v(
          l.reportViolationDrive(date(s.start), formatHm(s.driving)),
          InfringementType.dailyDriveExceeded,
        ),
      );
    }
    if (s.spanLevel == JournalLevel.bad) {
      result.add(
        v(
          l.reportViolationSpan(
            date(s.start),
            formatHm(s.span),
            spanLimit.inHours,
          ),
          InfringementType.shiftExceeded,
          crew == CrewMode.team ? '8(5)' : null,
        ),
      );
    }
    if (s.restLevel == JournalLevel.bad) {
      // Отдыху отдельного вида нарушения в движке нет — статья по виду отдыха
      result.add((
        text: l.reportViolationRest(date(s.start), formatHm(s.rest.duration)),
        regulation: '561/2006',
        article: s.rest.kind == RestKind.weekly ? '8(6)' : '8(2)',
      ));
    }
  }
  for (final w in journal.weeks.reversed) {
    final weekEnd = w.start.add(week);
    if (!weekEnd.isAfter(range.start) || !w.start.isBefore(range.end)) {
      continue;
    }
    final label = formatWeekRange(w.start, locale);
    if (w.driving > EuLimits.weeklyDriving) {
      result.add(
        v(
          l.reportViolationWeek(label, formatHm(w.driving)),
          InfringementType.weeklyDriveExceeded,
        ),
      );
    }
    if (w.fortnightDriving > EuLimits.fortnightDriving) {
      result.add(
        v(
          l.reportViolationFortnight(label, formatHm(w.fortnightDriving)),
          InfringementType.fortnightDriveExceeded,
        ),
      );
    }
  }
  return result;
}
