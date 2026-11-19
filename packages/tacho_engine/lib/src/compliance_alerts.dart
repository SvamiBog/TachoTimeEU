/// Warnings and infringements of a compliance snapshot, rule by rule: the
/// break (Art. 7), daily, weekly and fortnightly driving (Art. 6), the workday
/// (Art. 8(2), 8(5)), the weekly rest and its compensation (Art. 8(6), 8(7)),
/// reduced daily rests (Art. 8(4)) and the driver card download.
library;

import 'package:tacho_engine/src/compliance.dart';
import 'package:tacho_engine/src/compliance_log.dart';
import 'package:tacho_engine/src/driver_mode.dart';
import 'package:tacho_engine/src/eu_limits.dart';
import 'package:tacho_engine/src/infringement.dart';
import 'package:tacho_engine/src/shifts.dart';
import 'package:tacho_engine/src/time.dart';
import 'package:tacho_engine/src/workday.dart';

/// Предупреждения и нарушения на момент расчёта журнала [log]: за
/// [ComplianceSettings.warningLead] до лимита — предупреждение, после —
/// нарушение. Порядок — как в списке снимка: перерыв, вождение за день,
/// рабочий день, неделя и две недели, недельный отдых, компенсация,
/// сокращённые отдыхи, карта.
List<Infringement> complianceAlerts({
  required ComplianceLog log,
  required ComplianceSettings settings,
  required Workday day,
  required WeekDriving week,
  required WeeklyRestState weekly,
  required OffDutyRest? offDuty,
  required List<Compensation> unpaid,
  required int? cardDaysLeft,
}) {
  final lead = settings.warningLead;
  return [
    ?_breakAlert(log, day, lead),
    ..._dailyDrivingAlerts(log, day, lead),
    ?_shiftAlert(log, day, settings),
    ..._weekDrivingAlerts(log, week, lead),
    ..._weeklyRestAlerts(log, weekly, offDuty),
    ..._compensationAlerts(unpaid, log.now),
    if (day.reducedRestsUsed > EuLimits.dailyRestReductionsBetweenWeeklyRests)
      Infringement(
        InfringementType.reducedRestsExceeded,
        count: day.reducedRestsUsed,
      ),
    ?_cardAlert(cardDaysLeft, settings.cardAlertDays),
  ];
}

/// Больше 4:30 без перерыва — нарушение; за [lead] до этого — «скоро
/// перерыв», пока водитель в смене и не отдыхает.
Infringement? _breakAlert(ComplianceLog log, Workday day, Duration lead) {
  final continuous = day.continuousDriving;
  if (continuous > EuLimits.continuousDriving) {
    return Infringement(
      InfringementType.continuousExceeded,
      time: continuous - EuLimits.continuousDriving,
    );
  }
  if (day.shift != null &&
      log.currentMode != DriverMode.rest &&
      continuous > Duration.zero &&
      day.drivingUntilBreak <= lead) {
    return Infringement(
      InfringementType.breakSoon,
      time: day.drivingUntilBreak,
      requiredBreak: day.breakRequired,
    );
  }
  return null;
}

/// Вождение за день больше лимита (9 или 10 ч) — нарушение, за [lead] до
/// лимита за рулём — предупреждение; больше 9 ч в пределах лимита — идёт
/// продление.
List<Infringement> _dailyDrivingAlerts(
  ComplianceLog log,
  Workday day,
  Duration lead,
) {
  final driving = day.driving;
  final limit = day.drivingLimit;
  return [
    if (driving > limit)
      Infringement(
        InfringementType.dailyDriveExceeded,
        time: driving - limit,
        limit: limit,
      )
    else if (day.shift != null &&
        limit - driving <= lead &&
        log.currentMode == DriverMode.driving)
      Infringement(
        InfringementType.dailyDriveSoon,
        time: limit - driving,
        limit: limit,
      ),
    if (driving > EuLimits.dailyDriving && driving <= limit)
      Infringement(
        InfringementType.extensionInUse,
        count: day.extensionsLeft - 1,
      ),
  ];
}

/// Рабочий день длиннее лимита — нарушение, за [ComplianceSettings
/// .warningLead] до конца — предупреждение, пока водитель не отдыхает.
/// Статья — по экипажу ([workdayArticle]): у экипажа — 8(5).
Infringement? _shiftAlert(
  ComplianceLog log,
  Workday day,
  ComplianceSettings settings,
) {
  if (day.shift == null) return null;
  final article = workdayArticle(settings.crew);
  if (day.span > day.limit) {
    return Infringement(
      InfringementType.shiftExceeded,
      time: day.span - day.limit,
      limit: day.limit,
      article: article,
    );
  }
  if (log.currentMode != DriverMode.rest &&
      day.limit - day.span <= settings.warningLead) {
    return Infringement(
      InfringementType.shiftSoon,
      time: day.limit - day.span,
      article: article,
    );
  }
  return null;
}

/// Больше 56 ч за неделю и 90 ч за две — нарушения; за [lead] до лимита за
/// рулём — предупреждение о том, что кончится раньше.
List<Infringement> _weekDrivingAlerts(
  ComplianceLog log,
  WeekDriving week,
  Duration lead,
) {
  final driving = log.currentMode == DriverMode.driving;
  final weeklyLeft = week.weeklyLeft;
  final fortnightLeft = week.fortnightLeft;
  return [
    if (week.weekly > EuLimits.weeklyDriving)
      Infringement(
        InfringementType.weeklyDriveExceeded,
        time: week.weekly - EuLimits.weeklyDriving,
      )
    else if (driving && weeklyLeft <= lead && weeklyLeft <= fortnightLeft)
      Infringement(InfringementType.weeklyDriveSoon, time: weeklyLeft),
    if (week.fortnight > EuLimits.fortnightDriving)
      Infringement(
        InfringementType.fortnightDriveExceeded,
        time: week.fortnight - EuLimits.fortnightDriving,
      )
    else if (driving && fortnightLeft <= lead && fortnightLeft < weeklyLeft)
      Infringement(InfringementType.fortnightDriveSoon, time: fortnightLeft),
  ];
}

/// Недельный отдых: срок 144 ч, сокращённый без права на него и полный
/// отдых, когда сокращённый недоступен.
List<Infringement> _weeklyRestAlerts(
  ComplianceLog log,
  WeeklyRestState weekly,
  OffDutyRest? offDuty,
) {
  final deadline = _deadlineAlert(log, weekly, offDuty);
  final last = weekly.last;
  return [
    ?deadline,
    // Сокращённый недельный отдых без права на него — нарушение, пока он
    // последний недельный.
    if (last != null && weekly.lastWithoutRight)
      Infringement(
        InfringementType.reducedWeeklyRestWithoutRight,
        time: EuLimits.weeklyRestRegular - last.duration,
      ),
    // Идёт недельный отдых, а сокращённый недоступен — заканчивать раньше
    // 45 ч нельзя. После срока 144 ч то же говорит «не прерывайте отдых».
    if (offDuty != null &&
        offDuty.weekly &&
        !weekly.reducedAvailable &&
        offDuty.duration < EuLimits.weeklyRestRegular &&
        deadline?.type != InfringementType.weeklyRestContinue)
      Infringement(
        InfringementType.fullWeeklyRestRequired,
        time: EuLimits.weeklyRestRegular - offDuty.duration,
      ),
  ];
}

/// Срок недельного отдыха — 144 ч от конца прошлого. Отдых, начатый до
/// срока, — начало недельного, если продлится 24 ч (45 ч, если сокращённый
/// недоступен); пока он идёт после срока, его нельзя прерывать. Иначе, если
/// водитель не на недельном отдыхе, — опоздание или «скоро» за сутки.
Infringement? _deadlineAlert(
  ComplianceLog log,
  WeeklyRestState weekly,
  OffDutyRest? offDuty,
) {
  final deadline = weekly.workWeekStart?.add(EuLimits.maxBetweenWeeklyRests);
  if (deadline == null) return null;
  final left = deadline.difference(log.now);
  final lastRest = log.lastRest;
  if (left.isNegative &&
      lastRest != null &&
      lastRest.open &&
      !lastRest.start.isAfter(deadline)) {
    final required = weekly.reducedAvailable
        ? EuLimits.weeklyRestReduced
        : EuLimits.weeklyRestRegular;
    return lastRest.rest < required
        ? Infringement(
            InfringementType.weeklyRestContinue,
            time: required - lastRest.rest,
          )
        : null;
  }
  if (offDuty?.weekly ?? false) return null;
  if (left.isNegative) {
    return Infringement(InfringementType.weeklyRestOverdue, time: -left);
  }
  if (left <= EuLimits.weeklyRestWarning) {
    return Infringement(InfringementType.weeklyRestSoon, time: left);
  }
  return null;
}

/// Компенсация из непогашенных долгов [unpaid] (по сроку): просроченная —
/// нарушение, срок меньше чем через неделю — напоминание.
List<Infringement> _compensationAlerts(
  List<Compensation> unpaid,
  DateTime now,
) {
  final overdue = unpaid.where((c) => c.dueBy.isBefore(now)).firstOrNull;
  final pending = unpaid.where((c) => !c.dueBy.isBefore(now)).firstOrNull;
  return [
    if (overdue != null)
      Infringement(
        InfringementType.compensationOverdue,
        time: overdue.debt,
        days: floorDays(now.difference(overdue.dueBy)),
      ),
    if (pending != null &&
        pending.dueBy.difference(now) <= EuLimits.compensationWarning)
      Infringement(
        InfringementType.compensationSoon,
        time: pending.debt,
        days: floorDays(pending.dueBy.difference(now)),
      ),
  ];
}

/// Карта водителя: просрочено считывание — нарушение, осталось не больше
/// [alertDays] дней — напоминание.
Infringement? _cardAlert(int? daysLeft, int alertDays) {
  if (daysLeft == null) return null;
  if (daysLeft < 0) {
    return Infringement(InfringementType.cardOverdue, days: -daysLeft);
  }
  if (daysLeft <= alertDays) {
    return Infringement(InfringementType.cardSoon, days: daysLeft);
  }
  return null;
}
