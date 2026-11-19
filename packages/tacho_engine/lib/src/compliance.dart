/// The heart of the engine: [calculateCompliance] turns the log into a
/// [ComplianceSnapshot] — the driver's state, what is left of every limit of
/// Regulation 561/2006 and the warnings and infringements at a given moment.
library;

import 'package:meta/meta.dart';
import 'package:tacho_engine/src/activity_period.dart';
import 'package:tacho_engine/src/compensation.dart';
import 'package:tacho_engine/src/compliance_alerts.dart';
import 'package:tacho_engine/src/compliance_log.dart';
import 'package:tacho_engine/src/driver_mode.dart';
import 'package:tacho_engine/src/eu_limits.dart';
import 'package:tacho_engine/src/infringement.dart';
import 'package:tacho_engine/src/manual_rest.dart';
import 'package:tacho_engine/src/manual_shift.dart';
import 'package:tacho_engine/src/shift_route.dart';
import 'package:tacho_engine/src/shifts.dart';
import 'package:tacho_engine/src/time.dart';
import 'package:tacho_engine/src/timeline.dart';
import 'package:tacho_engine/src/workday.dart';

export 'package:tacho_engine/src/compensation.dart'
    show Compensation, RestCompensation;

/// Driver settings that change the calculation.
@immutable
class ComplianceSettings {
  const new({
    this.crew = CrewMode.solo,
    this.mobilityPackage = true,
    this.warningLead = EuLimits.warningThreshold,
    this.cardAlertDays = 7,
    this.baseCountry,
  });

  final CrewMode crew;

  /// Пакет мобильности (Регламент 2020/1054): международным перевозчикам
  /// можно два сокращённых недельных отдыха подряд — оба вне страны фирмы.
  final bool mobilityPackage;

  /// Страна фирмы — где зарегистрирован перевозчик, код тахографа. Два
  /// сокращённых недельных отдыха подряд в ней нельзя (ст. 8(6)); null — не
  /// указана, страну отдыха движок не проверяет.
  final String? baseCountry;

  /// За сколько до лимита предупреждать: 15, 30 или 60 мин.
  final Duration warningLead;

  /// За сколько дней напоминать о считывании карты: 3, 7 или 14.
  final int cardAlertDays;
}

/// A weekly rest, from the records or after a manual shift.
@immutable
class WeeklyRest {
  const new({
    required this.start,
    required this.end,
    required this.duration,
    required this.status,
  });

  final DateTime start;

  /// null — отдых идёт.
  final DateTime? end;
  final Duration duration;
  final RestStatus status;

  @override
  bool operator ==(Object other) =>
      other is WeeklyRest &&
      other.start == start &&
      other.end == end &&
      other.duration == duration &&
      other.status == status;

  @override
  int get hashCode => Object.hash(start, end, duration, status);

  @override
  String toString() =>
      'WeeklyRest($start → ${end ?? 'now'}, ${duration.inMinutes} мин, '
      '${status.name})';
}

/// The daily or weekly rest after a shift that is in progress now.
@immutable
class OffDutyRest {
  const new({
    required this.start,
    required this.duration,
    required this.weekly,
  });

  final DateTime start;
  final Duration duration;

  /// Отдых уже длится не меньше 24 ч — это недельный отдых. Отдых после
  /// ручной смены — ещё и если водитель отметил его недельным.
  final bool weekly;
}

/// The break in progress now.
@immutable
class CurrentBreak {
  const new({
    required this.start,
    required this.duration,
    required this.required,
    required this.needed,
  });

  final DateTime start;
  final Duration duration;

  /// Сколько нужно, чтобы перерыв засчитался: 45 мин или 30 после первой
  /// части.
  final Duration required;

  /// Перерыв ещё нужен: есть непрерывное вождение, которое отдых пока не
  /// обнулил. Не нужен, если этот отдых уже засчитан ([remaining] — ноль) или
  /// с прошлого засчитанного перерыва водитель не ездил: тогда отдых может
  /// быть и не засчитан, он копится к суточному.
  final bool needed;

  /// Сколько ещё отдыхать, чтобы этот отдых засчитался перерывом; ноль —
  /// засчитан.
  Duration get remaining => clampToZero(required - duration);
}

/// The driver's state for the home screen.
enum DriverStatus {
  /// Смены нет и водитель не на суточном отдыхе: журнал пуст или начат
  /// с короткого отдыха.
  notStarted,
  driving,
  otherWork,
  availability,

  /// Отдых внутри смены (ещё меньше 9 ч и не объявлен концом дня).
  onBreak,
  dailyRest,
  weeklyRest,

  /// Смена идёт, но текущий режим не записан: журнал обрывается разрывом.
  /// Разрыв не считается отдыхом.
  unknown,
}

/// Result of the calculation: the state, the timers of every limit and the
/// infringements at [now].
@immutable
class ComplianceSnapshot {
  const new({
    required this.now,
    required this.timeline,
    required this.currentMode,
    required this.currentModeStart,
    required this.currentModeDuration,
    required this.shift,
    required this.shiftStart,
    required this.splitFirstPart,
    required this.shiftDuration,
    required this.shiftRegularLimit,
    required this.shiftExtendedLimit,
    required this.shiftLimit,
    required this.dailyRestDeadline,
    required this.offDutyRest,
    required this.continuousDriving,
    required this.drivingUntilBreak,
    required this.breakFirstPart,
    required this.breakRequired,
    required this.breakTaken,
    required this.breakSplit,
    required this.breakFirstPartDone,
    required this.currentBreak,
    required this.dailyDriving,
    required this.dailyDrivingLimit,
    required this.extensionsUsed,
    required this.extensionsLeft,
    required this.reducedRestsUsed,
    required this.reducedRestsLeft,
    required this.weekStart,
    required this.weeklyDriving,
    required this.fortnightDriving,
    required this.weeklyDrivingRemaining,
    required this.fortnightLimiting,
    required this.lastWeeklyRest,
    required this.previousWeeklyRest,
    required this.workWeekStart,
    required this.workWeekDuration,
    required this.weeklyRestDeadline,
    required this.reducedWeeklyRestAvailable,
    required this.reducedWeeklyRestAtBase,
    required this.compensation,
    required this.compensations,
    required this.unpaidCompensations,
    required this.restCompensation,
    required this.cardDaysLeft,
    required this.infringements,
  });

  final DateTime now;
  final Timeline timeline;

  // Текущий режим
  final DriverMode? currentMode;
  final DateTime? currentModeStart;
  final Duration currentModeDuration;

  // Смена и рабочий день (ст. 8(2))

  /// Текущая смена по записям режимов: с ней работают правки журнала.
  final Shift? shift;

  /// Начало рабочего дня: начало смены, а если она продолжает смену,
  /// внесённую итогами (отдых после той был короче 9 ч и день не закончил), —
  /// начало той. От него идут рабочий день и срок суточного отдыха; null —
  /// смены нет.
  final DateTime? shiftStart;

  /// В рабочем дне уже был отдых от 3 ч — первая часть раздельного суточного
  /// отдыха 3 + 9 (ст. 8(2)): в смене по записям, в ручной смене этого дня
  /// или между ними.
  final bool splitFirstPart;

  /// Рабочий день: от его начала ([shiftStart]) до сейчас, во время отдыха —
  /// до начала отдыха.
  final Duration shiftDuration;

  /// Обычный рабочий день: 13 ч (экипаж — 19 ч).
  final Duration shiftRegularLimit;

  /// Удлинённый: 15 ч при сокращённом или раздельном отдыхе (экипаж — 21 ч).
  final Duration shiftExtendedLimit;

  /// Действующий лимит с учётом доступных сокращений.
  final Duration shiftLimit;

  /// Суточный отдых должен закончиться до этого момента.
  final DateTime? dailyRestDeadline;

  /// Водитель сейчас на суточном или недельном отдыхе (смена закончилась).
  final OffDutyRest? offDutyRest;

  // Непрерывное вождение и перерыв (ст. 7)
  final Duration continuousDriving;
  final Duration drivingUntilBreak;
  final BreakPart? breakFirstPart;

  /// Сколько перерыва нужно взять сейчас: 45 мин или 30 после первой части.
  final Duration breakRequired;

  /// Взято в счёт перерыва: первая часть, идущий отдых или обе, если он
  /// вторая часть, — и после того, как 15 + 30 засчитан ([BreakState.taken]).
  final Duration breakTaken;

  /// Перерыв раздельный, 15 + 30: первая часть взята или идёт вторая.
  final bool breakSplit;

  /// Первые 15 мин перерыва набраны ([BreakState.firstPartDone]).
  final bool breakFirstPartDone;
  final CurrentBreak? currentBreak;

  // Суточное вождение (ст. 6(1))
  final Duration dailyDriving;
  final Duration dailyDrivingLimit;

  /// Продления до 10 ч, потраченные на неделе, к которой относится рабочий
  /// день: идёт смена — на неделе её начала ([shiftStart]), смены нет — на
  /// текущей.
  final int extensionsUsed;
  final int extensionsLeft;

  // Сокращённые суточные отдыхи с последнего недельного (ст. 8(4))
  final int reducedRestsUsed;
  final int reducedRestsLeft;

  // Неделя и две недели (ст. 6(2), 6(3))
  final DateTime weekStart;
  final Duration weeklyDriving;
  final Duration fortnightDriving;

  /// Остаток на неделю с учётом лимита 90 ч за две недели.
  final Duration weeklyDrivingRemaining;

  /// Раньше кончается лимит за две недели, а не за неделю.
  final bool fortnightLimiting;

  // Рабочая неделя и недельный отдых (ст. 8(6))
  final WeeklyRest? lastWeeklyRest;
  final WeeklyRest? previousWeeklyRest;

  /// Конец последнего недельного отдыха; null — о нём нет данных.
  final DateTime? workWeekStart;
  final Duration workWeekDuration;

  /// Недельный отдых должен начаться до этого момента (144 ч).
  final DateTime? weeklyRestDeadline;
  final bool reducedWeeklyRestAvailable;

  /// Сокращённый недоступен только из-за страны фирмы: это был бы второй
  /// подряд, а прошлый сокращённый или этот отдых — в стране фирмы.
  final bool reducedWeeklyRestAtBase;

  /// Ближайший по сроку непогашенный долг компенсации.
  final Compensation? compensation;

  /// Все долги за сокращённые недельные отдыхи — погашенные и нет — по
  /// началу отдыха: журнал показывает, какой отдых какой долг погасил. За
  /// два сокращённых подряд — один долг ([Compensation.secondRestStart]).
  final List<Compensation> compensations;

  /// Непогашенные долги по сроку, первый — [compensation]. Долги за
  /// сокращённые отдыхи не подряд — отдельно, за два подряд — один на оба.
  /// Просроченный долг остаётся здесь четыре недели после срока.
  final List<Compensation> unpaidCompensations;

  /// Компенсация в идущем отдыхе: сколько ещё отдыхать, чтобы погасить
  /// долг, или долг уже погашен им; null — долга нет или водитель не на
  /// отдыхе.
  final RestCompensation? restCompensation;

  /// Дней до обязательного считывания карты; null — считываний не было.
  final int? cardDaysLeft;

  final List<Infringement> infringements;

  DriverStatus get status {
    if (offDutyRest case final rest?) {
      return rest.weekly ? DriverStatus.weeklyRest : DriverStatus.dailyRest;
    }
    if (shift == null) return DriverStatus.notStarted;
    return switch (currentMode) {
      DriverMode.driving => DriverStatus.driving,
      DriverMode.otherWork => DriverStatus.otherWork,
      DriverMode.availability => DriverStatus.availability,
      DriverMode.rest => DriverStatus.onBreak,
      null => DriverStatus.unknown,
    };
  }

  // Остатки по таймерам

  Duration get dailyDrivingRemaining =>
      clampToZero(dailyDrivingLimit - dailyDriving);

  Duration get fortnightDrivingRemaining =>
      clampToZero(EuLimits.fortnightDriving - fortnightDriving);

  /// До конца рабочего дня (13/15 ч); null — смены нет.
  Duration? get shiftRemaining =>
      shift == null ? null : clampToZero(shiftLimit - shiftDuration);

  /// До полного суточного отдыха (11 ч); null — водитель не на суточном
  /// отдыхе.
  Duration? get dailyRestRemaining {
    final rest = offDutyRest;
    if (rest == null || rest.weekly) return null;
    return clampToZero(EuLimits.dailyRestRegular - rest.duration);
  }

  /// До полного недельного отдыха (45 ч); null — водитель не на недельном
  /// отдыхе.
  Duration? get weeklyRestRemaining {
    final rest = offDutyRest;
    if (rest == null || !rest.weekly) return null;
    return clampToZero(EuLimits.weeklyRestRegular - rest.duration);
  }

  /// Сколько всего компенсации нужно взять: сумма непогашенных долгов.
  Duration get compensationDebt =>
      unpaidCompensations.fold(Duration.zero, (sum, c) => sum + c.debt);

  /// До начала обязательного недельного отдыха (144 ч).
  Duration? get workWeekRemaining {
    final deadline = weeklyRestDeadline;
    return deadline == null ? null : durationBetween(now, deadline);
  }

  bool has(InfringementType type) => infringements.any((i) => i.type == type);

  Infringement? infringement(InfringementType type) {
    for (final i in infringements) {
      if (i.type == type) return i;
    }
    return null;
  }
}

/// Считает состояние, таймеры и нарушения по журналу на момент [now].
///
/// [periods] — записи режимов в любом порядке; [manualShifts] — смены,
/// внесённые итогами; [lastCardDownload] — последнее считывание карты;
/// [routes] — страны смен по их началу (UTC): по ним и стране фирмы
/// проверяются два сокращённых отдыха подряд.
///
/// Расчёт идёт по частям: журнал ([ComplianceLog]), недельные отдыхи и
/// право на сокращённый ([WeeklyRestState]), рабочий день ([Workday]),
/// вождение за неделю и две ([WeekDriving]), отдых после смены, долги
/// компенсации ([compensationDebts]) и предупреждения ([complianceAlerts]).
ComplianceSnapshot calculateCompliance({
  required Iterable<ActivityPeriod> periods,
  required DateTime now,
  Iterable<ManualShift> manualShifts = const [],
  ComplianceSettings settings = const ComplianceSettings(),
  DateTime? lastCardDownload,
  Map<DateTime, ShiftRoute> routes = const {},
}) {
  if (!now.isUtc) throw ArgumentError.value(now, 'now', 'должно быть в UTC');
  final log = ComplianceLog.of(
    analyzeTimeline(periods, now),
    manualShifts.toList(),
    now,
  );
  final weekly = WeeklyRestState.of(log, settings, routes);
  final day = Workday.of(
    log,
    crew: settings.crew,
    workWeekStart: weekly.workWeekStart,
  );
  final week = WeekDriving.of(log);
  final offDuty = _offDutyRest(log);
  final debts = compensationDebts(log, weekly.completed);
  final cardDaysLeft = _cardDaysLeft(lastCardDownload, now);
  return _snapshot(
    log,
    day: day,
    week: week,
    weekly: weekly,
    offDuty: offDuty,
    debts: debts,
    cardDaysLeft: cardDaysLeft,
    infringements: complianceAlerts(
      log: log,
      settings: settings,
      day: day,
      week: week,
      weekly: weekly,
      offDuty: offDuty,
      unpaid: debts.unpaid,
      cardDaysLeft: cardDaysLeft,
    ),
  );
}

/// Водитель на суточном или недельном отдыхе после смены: смены нет, а идёт
/// отдых, который её закончил, или отдых после последней ручной смены;
/// null — смена идёт или отдыха нет.
///
/// Недельным отдых объявляют у записи ([RestPeriod.weeklyRest]) или у
/// ручной смены перед ним — после «Завершить день» с вождением смена стала
/// ручной, а отдых остался записью.
OffDutyRest? _offDutyRest(ComplianceLog log) {
  if (log.timeline.current != null) return null;
  // Отдых после последней ручной смены, если следующей смены нет. Когда
  // смена кончается «сейчас», записи отдыха после неё нет: его время ещё не
  // наступило, — водитель на этом отдыхе, хотя режим не записан.
  ManualRest? manual;
  for (final r in log.manualRest) {
    if (r.ongoing && (manual?.start.isBefore(r.start) ?? true)) manual = r;
  }
  final lastRest = log.lastRest;
  if (lastRest != null && lastRest.open && lastRest.endsShift) {
    return OffDutyRest(
      start: lastRest.start,
      duration: lastRest.rest,
      weekly: lastRest.isWeekly || manual?.kind == RestKind.weekly,
    );
  }
  if (manual == null) return null;
  return OffDutyRest(
    start: manual.start,
    duration: manual.duration,
    weekly: manual.kind == RestKind.weekly,
  );
}

/// Дней до обязательного считывания карты; null — считываний не было.
/// Считывание «из будущего» (часы телефона переведены назад) считаем
/// сделанным сейчас: больше 28 дней остаться не может.
int? _cardDaysLeft(DateTime? lastDownload, DateTime now) => lastDownload == null
    ? null
    : EuLimits.cardDownloadInterval.inDays -
          floorDays(durationBetween(lastDownload, now));

/// Снимок из частей расчёта. Рабочая неделя — 144 ч от конца последнего
/// недельного отдыха; на недельном отдыхе она не идёт.
ComplianceSnapshot _snapshot(
  ComplianceLog log, {
  required Workday day,
  required WeekDriving week,
  required WeeklyRestState weekly,
  required OffDutyRest? offDuty,
  required CompensationDebts debts,
  required int? cardDaysLeft,
  required List<Infringement> infringements,
}) {
  final now = log.now;
  final openBlock = log.openBlock;
  final workWeekStart = weekly.workWeekStart;
  final onWeeklyRest = offDuty?.weekly ?? false;
  return ComplianceSnapshot(
    now: now,
    timeline: log.timeline,
    currentMode: openBlock?.mode,
    currentModeStart: openBlock?.start,
    currentModeDuration: openBlock == null
        ? Duration.zero
        : durationBetween(openBlock.start, now),
    shift: day.shift,
    shiftStart: day.start,
    splitFirstPart: day.splitFirstPart,
    shiftDuration: day.span,
    shiftRegularLimit: day.regularLimit,
    shiftExtendedLimit: day.extendedLimit,
    shiftLimit: day.limit,
    dailyRestDeadline: day.restDeadline,
    offDutyRest: offDuty,
    continuousDriving: day.continuousDriving,
    drivingUntilBreak: day.drivingUntilBreak,
    breakFirstPart: day.breakState.firstPart,
    breakRequired: day.breakRequired,
    breakTaken: day.breakState.taken,
    breakSplit: day.breakState.split,
    breakFirstPartDone: day.breakState.firstPartDone,
    currentBreak: day.currentBreak,
    dailyDriving: day.driving,
    dailyDrivingLimit: day.drivingLimit,
    extensionsUsed: day.extensionsUsed,
    extensionsLeft: day.extensionsLeft,
    reducedRestsUsed: day.reducedRestsUsed,
    reducedRestsLeft: day.reducedRestsLeft,
    weekStart: week.start,
    weeklyDriving: week.weekly,
    fortnightDriving: week.fortnight,
    weeklyDrivingRemaining: clampToZero(
      shorter(week.weeklyLeft, week.fortnightLeft),
    ),
    fortnightLimiting: week.fortnightLeft < week.weeklyLeft,
    lastWeeklyRest: weekly.last,
    previousWeeklyRest: weekly.previous,
    workWeekStart: workWeekStart,
    workWeekDuration: workWeekStart != null && !onWeeklyRest
        ? durationBetween(workWeekStart, now)
        : Duration.zero,
    weeklyRestDeadline: workWeekStart?.add(EuLimits.maxBetweenWeeklyRests),
    reducedWeeklyRestAvailable: weekly.reducedAvailable,
    reducedWeeklyRestAtBase: weekly.reducedAtBase,
    compensation: debts.unpaid.firstOrNull,
    compensations: debts.all,
    unpaidCompensations: List.unmodifiable(debts.unpaid),
    restCompensation: offDuty == null
        ? null
        : restCompensationOf(offDuty, debts, now),
    cardDaysLeft: cardDaysLeft,
    infringements: List.unmodifiable(infringements),
  );
}
