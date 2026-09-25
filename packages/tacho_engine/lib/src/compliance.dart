import 'package:meta/meta.dart';
import 'package:tacho_engine/src/activity_period.dart';
import 'package:tacho_engine/src/driver_mode.dart';
import 'package:tacho_engine/src/eu_limits.dart';
import 'package:tacho_engine/src/infringement.dart';
import 'package:tacho_engine/src/manual_shift.dart';
import 'package:tacho_engine/src/shifts.dart';
import 'package:tacho_engine/src/time.dart';

/// Настройки водителя, которые влияют на расчёт.
@immutable
class ComplianceSettings {
  const new({
    this.crew = CrewMode.solo,
    this.mobilityPackage = true,
    this.warningLead = EuLimits.warningThreshold,
    this.cardAlertDays = 7,
  });

  final CrewMode crew;

  /// Пакет мобильности (Регламент 2020/1054): международным перевозчикам
  /// можно два сокращённых недельных отдыха подряд.
  final bool mobilityPackage;

  /// За сколько до лимита предупреждать: 15, 30 или 60 мин.
  final Duration warningLead;

  /// За сколько дней напоминать о считывании карты: 3, 7 или 14.
  final int cardAlertDays;
}

/// Недельный отдых из записей или из ручной смены.
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

/// Суточный или недельный отдых после смены, который идёт сейчас.
@immutable
class OffDutyRest {
  const new({
    required this.start,
    required this.duration,
    required this.weekly,
  });

  final DateTime start;
  final Duration duration;

  /// Отдых уже длится не меньше 24 ч — это недельный отдых.
  final bool weekly;
}

/// Перерыв, который идёт сейчас.
@immutable
class CurrentBreak {
  const new({
    required this.start,
    required this.duration,
    required this.required,
  });

  final DateTime start;
  final Duration duration;

  /// Сколько нужно, чтобы перерыв засчитался: 45 мин или 30 после первой
  /// части.
  final Duration required;
}

/// Долг за сокращённый недельный отдых (ст. 8(6)).
@immutable
class Compensation {
  const new({required this.debt, required this.dueBy});

  /// Сколько не хватило до 45 ч.
  final Duration debt;

  /// До какого момента долг нужно присоединить к отдыху.
  final DateTime dueBy;

  @override
  bool operator ==(Object other) =>
      other is Compensation && other.debt == debt && other.dueBy == dueBy;

  @override
  int get hashCode => Object.hash(debt, dueBy);

  @override
  String toString() => 'Compensation(${debt.inMinutes} мин до $dueBy)';
}

/// Состояние водителя для главного экрана.
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

/// Результат расчёта: состояние, таймеры по лимитам и нарушения на момент
/// [now].
@immutable
class ComplianceSnapshot {
  const new({
    required this.now,
    required this.timeline,
    required this.currentMode,
    required this.currentModeStart,
    required this.currentModeDuration,
    required this.shift,
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
    required this.compensation,
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
  final Shift? shift;

  /// Рабочий день: от начала смены до сейчас, во время отдыха — до его
  /// начала.
  final Duration shiftDuration;

  /// Обычный рабочий день: 13 ч (экипаж — 21 ч).
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
  final CurrentBreak? currentBreak;

  // Суточное вождение (ст. 6(1))
  final Duration dailyDriving;
  final Duration dailyDrivingLimit;
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
  final Compensation? compensation;

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
/// внесённые итогами; [lastCardDownload] — последнее считывание карты.
ComplianceSnapshot calculateCompliance({
  required Iterable<ActivityPeriod> periods,
  required DateTime now,
  Iterable<ManualShift> manualShifts = const [],
  ComplianceSettings settings = const ComplianceSettings(),
  DateTime? lastCardDownload,
}) {
  if (!now.isUtc) throw ArgumentError.value(now, 'now', 'должно быть в UTC');
  final manual = manualShifts.toList();
  final timeline = analyzeTimeline(periods, now);
  final lead = settings.warningLead;
  final crew = settings.crew;
  final team = crew == CrewMode.team;
  final infringements = <Infringement>[];

  // Текущий режим
  final lastBlock = timeline.blocks.isEmpty ? null : timeline.blocks.last;
  final openBlock = lastBlock != null && lastBlock.open ? lastBlock : null;
  final currentMode = openBlock?.mode;
  final resting = currentMode == DriverMode.rest;

  // Смена и отдых после неё
  final shift = timeline.current;
  final lastRest = timeline.rests.isEmpty ? null : timeline.rests.last;
  final offDutyRest =
      shift == null &&
          lastRest != null &&
          lastRest.open &&
          (lastRest.rest >= EuLimits.dailyRestReduced || lastRest.dayEnd)
      ? OffDutyRest(
          start: lastRest.start,
          duration: lastRest.rest,
          weekly: lastRest.isWeekly,
        )
      : null;

  final breakState = computeBreakState(shift?.blocks ?? const []);
  final continuousDriving = breakState.continuousDriving;
  final breakRequired = breakState.firstPartTaken
      ? EuLimits.breakSplitSecond
      : EuLimits.breakFull;
  final currentRest = breakState.currentRest;
  final currentBreak = currentRest == null
      ? null
      : CurrentBreak(
          start: currentRest.start,
          duration: currentRest.duration,
          required: currentRest.firstPartBefore
              ? EuLimits.breakSplitSecond
              : EuLimits.breakFull,
        );

  // Недели: понедельник 00:00 UTC, как на тахографе
  final weekStart = weekStartUtc(now);
  final prevWeekStart = weekStart.subtract(week);
  Duration drivingIn(DateTime from, DateTime to) {
    var total = Duration.zero;
    for (final b in timeline.blocks) {
      if (b.mode == DriverMode.driving) {
        total += overlap(b.start, b.end, from, to);
      }
    }
    for (final m in manual) {
      if (!m.start.isBefore(from) && m.start.isBefore(to)) total += m.driving;
    }
    return total;
  }

  final weeklyDriving = drivingIn(weekStart, weekStart.add(week));
  final fortnightDriving = weeklyDriving + drivingIn(prevWeekStart, weekStart);
  final weeklyLeft = EuLimits.weeklyDriving - weeklyDriving;
  final fortnightLeft = EuLimits.fortnightDriving - fortnightDriving;

  // Продления до 10 ч на этой неделе — по завершённым сменам
  bool inThisWeek(DateTime t) =>
      !t.isBefore(weekStart) && t.isBefore(weekStart.add(week));
  final extensionsUsed =
      timeline.shifts
          .where(
            (s) =>
                !identical(s, shift) &&
                !s.start.isBefore(weekStart) &&
                s.driving > EuLimits.dailyDriving,
          )
          .length +
      manual
          .where(
            (m) => inThisWeek(m.start) && m.driving > EuLimits.dailyDriving,
          )
          .length;
  final extensionsLeft = _nonNegative(
    EuLimits.dailyDrivingExtensionsPerWeek - extensionsUsed,
  );
  final dailyDriving = shift?.driving ?? Duration.zero;
  final dailyDrivingLimit = extensionsLeft > 0
      ? EuLimits.dailyDrivingExtended
      : EuLimits.dailyDriving;

  // Недельные отдыхи: из записей и из ручных смен
  final recordedWeekly = [
    for (final p in timeline.rests)
      if (p.isWeekly)
        WeeklyRest(
          start: p.start,
          end: p.open ? null : p.end,
          duration: p.rest,
          status: weeklyRestStatus(p.rest),
        ),
  ];
  final weeklyRests = [...recordedWeekly];
  for (final m in manual) {
    final end = m.end;
    if (m.restKind != RestKind.weekly || end == null) continue;
    final restEnd = end.add(m.rest);
    // Тот же отдых уже есть в записях режимов — не считаем его дважды
    final duplicate = recordedWeekly.any(
      (r) => r.start.isBefore(restEnd) && (r.end ?? now).isAfter(end),
    );
    if (duplicate) continue;
    weeklyRests.add(
      WeeklyRest(
        start: end,
        end: restEnd,
        duration: m.rest,
        status: weeklyRestStatus(m.rest),
      ),
    );
  }
  final completedWeekly = _sortedByStart(weeklyRests)
      .where((r) => r.end != null)
      .toList();
  final lastWeeklyRest = completedWeekly.isEmpty ? null : completedWeekly.last;
  final previousWeeklyRest = completedWeekly.length < 2
      ? null
      : completedWeekly[completedWeekly.length - 2];
  final reducedWeeklyRestAvailable =
      lastWeeklyRest == null ||
      lastWeeklyRest.status == RestStatus.full ||
      (settings.mobilityPackage &&
          (previousWeeklyRest == null ||
              previousWeeklyRest.status == RestStatus.full));

  // Компенсация сокращённого недельного отдыха — до конца третьей недели
  Compensation? compensation;
  for (final r in completedWeekly) {
    final end = r.end;
    if (r.status != RestStatus.reduced || end == null) continue;
    final debt = EuLimits.weeklyRestRegular - r.duration;
    final dueBy = weekStartUtc(r.start)
        .add(week * (EuLimits.compensationWeeks + 1));
    if (dueBy.isBefore(now.subtract(week * 4))) continue;
    final repaid = timeline.rests.any(
      (p) =>
          !p.start.isBefore(end) &&
          !p.open &&
          p.rest >= EuLimits.dailyRestRegular + debt,
    );
    if (!repaid &&
        (compensation == null || dueBy.isBefore(compensation.dueBy))) {
      compensation = Compensation(debt: debt, dueBy: dueBy);
    }
  }

  // Рабочая неделя: 144 ч от конца предыдущего недельного отдыха
  final onWeeklyRest = offDutyRest?.weekly ?? false;
  final workWeekStart = lastWeeklyRest?.end;
  final weeklyRestDeadline = workWeekStart?.add(EuLimits.maxBetweenWeeklyRests);
  final workWeekDuration = workWeekStart != null && !onWeeklyRest
      ? durationBetween(workWeekStart, now)
      : Duration.zero;

  // Сокращённые суточные отдыхи с последнего недельного
  bool sinceWorkWeek(DateTime t) =>
      workWeekStart == null || !t.isBefore(workWeekStart);
  var reducedRestsUsed = 0;
  for (final s in timeline.shifts) {
    final r = s.restAfter;
    if (r == null || r.open || !sinceWorkWeek(r.start) || r.isWeekly) {
      continue;
    }
    final inWindow = shiftRestInWindow(timeline.blocks, s, crew);
    if (dailyRestStatus(inWindow, split: s.splitFirstPart) ==
        RestStatus.reduced) {
      reducedRestsUsed++;
    }
  }
  for (final m in manual) {
    final end = m.end;
    if (end == null || !sinceWorkWeek(end) || m.restKind != RestKind.daily) {
      continue;
    }
    final inWindow = restInWindow(durationBetween(m.start, end), m.rest, crew);
    if (dailyRestStatus(inWindow, split: m.splitRest) == RestStatus.reduced) {
      reducedRestsUsed++;
    }
  }
  final reducedRestsLeft = _nonNegative(
    EuLimits.dailyRestReductionsBetweenWeeklyRests - reducedRestsUsed,
  );

  // Рабочий день: во время отдыха считаем до его начала — отдых и есть
  // конец дня
  final spanEnd = resting && currentRest != null ? currentRest.start : now;
  final shiftDuration = shift == null
      ? Duration.zero
      : durationBetween(shift.start, spanEnd);
  final window = workdayWindow(crew);
  final shiftRegularLimit = team
      ? window - EuLimits.teamDailyRest
      : window - EuLimits.dailyRestRegular;
  final shiftExtendedLimit = window - EuLimits.dailyRestReduced;
  final canExtend =
      team || reducedRestsLeft > 0 || (shift?.splitFirstPart ?? false);
  final shiftLimit = canExtend ? shiftExtendedLimit : shiftRegularLimit;
  final dailyRestDeadline = shift?.start.add(window);

  // Карта водителя
  final cardDaysLeft = lastCardDownload == null
      ? null
      : EuLimits.cardDownloadInterval.inDays -
            floorDays(now.difference(lastCardDownload));

  // Предупреждения и нарушения
  final drivingUntilBreak = clampToZero(
    EuLimits.continuousDriving - continuousDriving,
  );
  if (continuousDriving > EuLimits.continuousDriving) {
    infringements.add(
      Infringement(
        InfringementType.continuousExceeded,
        time: continuousDriving - EuLimits.continuousDriving,
      ),
    );
  } else if (shift != null &&
      !resting &&
      continuousDriving > Duration.zero &&
      drivingUntilBreak <= lead) {
    infringements.add(
      Infringement(
        InfringementType.breakSoon,
        time: drivingUntilBreak,
        requiredBreak: breakRequired,
      ),
    );
  }

  if (dailyDriving > dailyDrivingLimit) {
    infringements.add(
      Infringement(
        InfringementType.dailyDriveExceeded,
        time: dailyDriving - dailyDrivingLimit,
        limit: dailyDrivingLimit,
      ),
    );
  } else if (shift != null &&
      dailyDrivingLimit - dailyDriving <= lead &&
      currentMode == DriverMode.driving) {
    infringements.add(
      Infringement(
        InfringementType.dailyDriveSoon,
        time: dailyDrivingLimit - dailyDriving,
        limit: dailyDrivingLimit,
      ),
    );
  }
  if (dailyDriving > EuLimits.dailyDriving &&
      dailyDriving <= dailyDrivingLimit) {
    infringements.add(
      Infringement(InfringementType.extensionInUse, count: extensionsLeft - 1),
    );
  }

  if (shift != null && shiftDuration > shiftLimit) {
    infringements.add(
      Infringement(
        InfringementType.shiftExceeded,
        time: shiftDuration - shiftLimit,
        limit: shiftLimit,
      ),
    );
  } else if (shift != null && !resting && shiftLimit - shiftDuration <= lead) {
    infringements.add(
      Infringement(
        InfringementType.shiftSoon,
        time: shiftLimit - shiftDuration,
      ),
    );
  }

  final driving = currentMode == DriverMode.driving;
  if (weeklyDriving > EuLimits.weeklyDriving) {
    infringements.add(
      Infringement(
        InfringementType.weeklyDriveExceeded,
        time: weeklyDriving - EuLimits.weeklyDriving,
      ),
    );
  } else if (driving && weeklyLeft <= lead && weeklyLeft <= fortnightLeft) {
    infringements.add(
      Infringement(InfringementType.weeklyDriveSoon, time: weeklyLeft),
    );
  }
  if (fortnightDriving > EuLimits.fortnightDriving) {
    infringements.add(
      Infringement(
        InfringementType.fortnightDriveExceeded,
        time: fortnightDriving - EuLimits.fortnightDriving,
      ),
    );
  } else if (driving && fortnightLeft <= lead && fortnightLeft < weeklyLeft) {
    infringements.add(
      Infringement(InfringementType.fortnightDriveSoon, time: fortnightLeft),
    );
  }

  // Отдых, начатый до дедлайна, — начало недельного, если продлится 24 ч
  if (weeklyRestDeadline != null && !onWeeklyRest) {
    final restStartedInTime =
        lastRest != null &&
        lastRest.open &&
        !lastRest.start.isAfter(weeklyRestDeadline);
    final left = weeklyRestDeadline.difference(now);
    if (left.isNegative && !restStartedInTime) {
      infringements.add(
        Infringement(InfringementType.weeklyRestOverdue, time: -left),
      );
    } else if (!left.isNegative && left <= EuLimits.weeklyRestWarning) {
      infringements.add(
        Infringement(InfringementType.weeklyRestSoon, time: left),
      );
    }
  }

  if (reducedRestsUsed > EuLimits.dailyRestReductionsBetweenWeeklyRests) {
    infringements.add(
      Infringement(
        InfringementType.reducedRestsExceeded,
        count: reducedRestsUsed,
      ),
    );
  }

  if (cardDaysLeft != null) {
    if (cardDaysLeft < 0) {
      infringements.add(
        Infringement(InfringementType.cardOverdue, days: -cardDaysLeft),
      );
    } else if (cardDaysLeft <= settings.cardAlertDays) {
      infringements.add(
        Infringement(InfringementType.cardSoon, days: cardDaysLeft),
      );
    }
  }

  return ComplianceSnapshot(
    now: now,
    timeline: timeline,
    currentMode: currentMode,
    currentModeStart: openBlock?.start,
    currentModeDuration: openBlock == null
        ? Duration.zero
        : durationBetween(openBlock.start, now),
    shift: shift,
    shiftDuration: shiftDuration,
    shiftRegularLimit: shiftRegularLimit,
    shiftExtendedLimit: shiftExtendedLimit,
    shiftLimit: shiftLimit,
    dailyRestDeadline: dailyRestDeadline,
    offDutyRest: offDutyRest,
    continuousDriving: continuousDriving,
    drivingUntilBreak: drivingUntilBreak,
    breakFirstPart: breakState.firstPart,
    breakRequired: breakRequired,
    currentBreak: currentBreak,
    dailyDriving: dailyDriving,
    dailyDrivingLimit: dailyDrivingLimit,
    extensionsUsed: extensionsUsed,
    extensionsLeft: extensionsLeft,
    reducedRestsUsed: reducedRestsUsed,
    reducedRestsLeft: reducedRestsLeft,
    weekStart: weekStart,
    weeklyDriving: weeklyDriving,
    fortnightDriving: fortnightDriving,
    weeklyDrivingRemaining: clampToZero(shorter(weeklyLeft, fortnightLeft)),
    fortnightLimiting: fortnightLeft < weeklyLeft,
    lastWeeklyRest: lastWeeklyRest,
    previousWeeklyRest: previousWeeklyRest,
    workWeekStart: workWeekStart,
    workWeekDuration: workWeekDuration,
    weeklyRestDeadline: weeklyRestDeadline,
    reducedWeeklyRestAvailable: reducedWeeklyRestAvailable,
    compensation: compensation,
    cardDaysLeft: cardDaysLeft,
    infringements: List.unmodifiable(infringements),
  );
}

int _nonNegative(int n) => n < 0 ? 0 : n;

List<WeeklyRest> _sortedByStart(List<WeeklyRest> rests) {
  final indexed = rests.indexed.toList()
    ..sort((a, b) {
      final byStart = a.$2.start.compareTo(b.$2.start);
      return byStart != 0 ? byStart : a.$1.compareTo(b.$1);
    });
  return [for (final (_, r) in indexed) r];
}
