/// Text of the foreground service's persistent notification: the current
/// activity and the most important timer, or a pending switch suggestion.
library;

import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/core/l10n/format.dart';
import 'package:tachogo/core/l10n/l10n.dart';

/// Текст постоянного уведомления сервиса: текущий режим и главный таймер.
/// Строки — из ARB на языке интерфейса (`appStrings`).
({String title, String text}) trackingNotification(
  AppLocalizations l,
  ComplianceSnapshot m, {
  AutoSwitch? suggestion,
}) {
  if (suggestion case AutoSwitch(:final at?)) {
    return _suggestion(l, suggestion.reason, formatClock(at));
  }

  String title(String mode) =>
      l.serviceModeTitle(mode, _hm(m.currentModeDuration));
  return switch (m.status) {
    DriverStatus.driving => (
      title: title(l.modeDriving),
      text: _drivingText(l, m),
    ),
    DriverStatus.onBreak => (title: title(l.heroBreak), text: _breakText(l, m)),
    DriverStatus.otherWork => (
      title: title(l.modeWorkFull),
      text: _workdayText(l, m),
    ),
    DriverStatus.availability => (
      title: title(l.modeAvailability),
      text: _workdayText(l, m),
    ),
    DriverStatus.dailyRest => (
      title: title(l.heroDailyRest),
      text: _restText(l, m.offDutyRest, done: l.serviceDailyRestDone),
    ),
    DriverStatus.weeklyRest => (
      title: title(l.heroWeeklyRest),
      text: _restText(l, m.offDutyRest, done: l.serviceWeeklyRestDone),
    ),
    DriverStatus.notStarted => (
      title: l.workdayNoShift,
      text: l.serviceNotStartedText,
    ),
    DriverStatus.unknown => (title: l.modeNone, text: l.serviceNoModeText),
  };
}

/// Предложение переключить режим с местного времени [since]: экипажу —
/// спросить, кто за рулём, остальным — включить вождение.
({String title, String text}) _suggestion(
  AppLocalizations l,
  AutoSwitchReason? reason,
  String since,
) => switch (reason) {
  AutoSwitchReason.team => (
    title: l.serviceTeamTitle,
    text: l.serviceTeamText(since),
  ),
  _ => (title: l.serviceSuggestTitle, text: l.serviceSuggestText(since)),
};

/// За рулём: до перерыва и остаток за день, после 4:30 без перерыва —
/// превышение из нарушения движка.
String _drivingText(AppLocalizations l, ComplianceSnapshot m) {
  final over = m.infringement(InfringementType.continuousExceeded)?.time;
  return over != null
      ? l.serviceDrivingOver(_hm(over))
      : l.serviceDriving(
          _hm(m.drivingUntilBreak),
          _hm(m.dailyDrivingRemaining),
        );
}

/// Перерыв: сколько до полного, затем — сколько можно ехать.
String _breakText(AppLocalizations l, ComplianceSnapshot m) {
  final left = m.currentBreak?.remaining ?? Duration.zero;
  return left > Duration.zero
      ? l.serviceBreakLeft(_hm(left))
      : l.serviceBreakDone(_hm(m.drivingUntilBreak));
}

/// Работа и готовность: рабочий день из лимита.
String _workdayText(AppLocalizations l, ComplianceSnapshot m) =>
    l.serviceWorkday(_hm(m.shiftDuration), _hm(m.shiftLimit));

/// Отдых после смены [rest]: сколько осталось до полного (11 или 45 ч —
/// [OffDutyRest.full]), набран — [done].
String _restText(
  AppLocalizations l,
  OffDutyRest? rest, {
  required String done,
}) {
  if (rest == null || rest.remaining <= Duration.zero) return done;
  return l.serviceRestLeft(formatLimit(l, rest.full), _hm(rest.remaining));
}

/// «4:05»: часы без ограничения, минуты с округлением вниз, без минуса.
String _hm(Duration d) => formatHm(d.isNegative ? Duration.zero : d);
