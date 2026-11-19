/// Infringements of the report period, worked out from the journal.
library;

import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/core/l10n/format.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/data/report/report.dart';
import 'package:tachogo/l10n/app_localizations.dart';

/// An infringement in the period with the article of the regulation.
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
  final texts = _ViolationTexts(crew: crew, l: l, locale: locale);
  return [
    for (final s in shiftsInRange(journal.shifts, range)) ...texts.ofShift(s),
    for (final w in journal.weeks.reversed)
      if (w.start.add(week).isAfter(range.start) && w.start.isBefore(range.end))
        ...texts.ofWeek(w),
  ];
}

/// Infringements of one shift or week in the report's words, with the
/// article of the regulation.
final class _ViolationTexts {
  const new({required this.crew, required this.l, required this.locale});

  final CrewMode crew;
  final AppLocalizations l;
  final String locale;

  String _date(DateTime t) => formatWeekdayDay(t, locale);

  static ReportViolation _of(
    String text,
    InfringementType type, [
    String? article,
  ]) => (
    text: text,
    regulation: type.regulation,
    article: article ?? type.article,
  );

  /// Вождение за день, рабочий день и отдых после смены [s].
  List<ReportViolation> ofShift(JournalShift s) => [
    if (s.driveLevel == JournalLevel.bad)
      _of(
        l.reportViolationDrive(_date(s.start), formatHm(s.driving)),
        InfringementType.dailyDriveExceeded,
      ),
    if (s.spanLevel == JournalLevel.bad)
      _of(
        l.reportViolationSpan(
          _date(s.start),
          formatHm(s.span),
          extendedWorkday(crew).inHours,
        ),
        InfringementType.shiftExceeded,
        workdayArticle(crew),
      ),
    // У отдыха отдельного вида нарушения нет — регламент и статья из журнала
    if (s.restLevel == JournalLevel.bad)
      (
        text: l.reportViolationRest(_date(s.start), formatHm(s.rest.duration)),
        regulation: s.rest.regulation,
        article: s.rest.article,
      ),
  ];

  /// Вождение за неделю [w] и за две недели, которыми она кончается.
  List<ReportViolation> ofWeek(JournalWeek w) {
    final label = formatWeekRange(w.start, locale);
    return [
      if (w.drivingLevel == JournalLevel.bad)
        _of(
          l.reportViolationWeek(label, formatHm(w.driving)),
          InfringementType.weeklyDriveExceeded,
        ),
      if (w.fortnightLevel == JournalLevel.bad)
        _of(
          l.reportViolationFortnight(label, formatHm(w.fortnightDriving)),
          InfringementType.fortnightDriveExceeded,
        ),
    ];
  }
}

/// Нарушения вокруг смены [start]–[end] (null — идёт) после её сохранения:
/// в самой смене, в отдыхе перед ней (новая смена его завершила) и в
/// неделях, куда она попала.
List<ReportViolation> violationsAroundShift(
  Journal journal, {
  required DateTime start,
  required DateTime? end,
  required DateTime now,
  required CrewMode crew,
  required AppLocalizations l,
  required String locale,
}) {
  // Отдых перед сменой — у предыдущей смены журнала
  DateTime? previous;
  for (final s in journal.shifts) {
    if (s.start.isBefore(start) &&
        (previous == null || s.start.isAfter(previous))) {
      previous = s.start;
    }
  }
  return reportViolations(
    journal,
    (
      start: previous ?? start,
      end: (end ?? now).add(const Duration(minutes: 1)),
    ),
    crew: crew,
    l: l,
    locale: locale,
  );
}
