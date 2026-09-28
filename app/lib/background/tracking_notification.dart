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
    final since = formatClock(at);
    return switch (suggestion.reason) {
      AutoSwitchReason.team => (
        title: l.serviceTeamTitle,
        text: l.serviceTeamText(since),
      ),
      _ => (title: l.serviceSuggestTitle, text: l.serviceSuggestText(since)),
    };
  }

  String title(String mode) =>
      l.serviceModeTitle(mode, _hm(m.currentModeDuration));
  switch (m.status) {
    case DriverStatus.driving:
      final over = m.continuousDriving - EuLimits.continuousDriving;
      return (
        title: title(l.modeDriving),
        text: over > Duration.zero
            ? l.serviceDrivingOver(_hm(over))
            : l.serviceDriving(
                _hm(m.drivingUntilBreak),
                _hm(m.dailyDrivingRemaining),
              ),
      );
    case DriverStatus.onBreak:
      final b = m.currentBreak;
      final left = b == null ? Duration.zero : b.required - b.duration;
      return (
        title: title(l.heroBreak),
        text: left > Duration.zero
            ? l.serviceBreakLeft(_hm(left))
            : l.serviceBreakDone(_hm(m.drivingUntilBreak)),
      );
    case DriverStatus.otherWork:
    case DriverStatus.availability:
      return (
        title: title(
          m.status == DriverStatus.otherWork
              ? l.modeWorkFull
              : l.modeAvailability,
        ),
        text: l.serviceWorkday(_hm(m.shiftDuration), _hm(m.shiftLimit)),
      );
    case DriverStatus.dailyRest:
      final left = m.dailyRestRemaining ?? Duration.zero;
      return (
        title: title(l.heroDailyRest),
        text: left > Duration.zero
            ? l.serviceRestLeft(
                formatLimit(l, EuLimits.dailyRestRegular),
                _hm(left),
              )
            : l.serviceDailyRestDone,
      );
    case DriverStatus.weeklyRest:
      final left = m.weeklyRestRemaining ?? Duration.zero;
      return (
        title: title(l.heroWeeklyRest),
        text: left > Duration.zero
            ? l.serviceRestLeft(
                formatLimit(l, EuLimits.weeklyRestRegular),
                _hm(left),
              )
            : l.serviceWeeklyRestDone,
      );
    case DriverStatus.notStarted:
      return (title: l.workdayNoShift, text: l.serviceNotStartedText);
    case DriverStatus.unknown:
      return (title: l.modeNone, text: l.serviceNoModeText);
  }
}

/// «4:05»: часы без ограничения, минуты с округлением вниз, без минуса.
String _hm(Duration d) => formatHm(d.isNegative ? Duration.zero : d);
