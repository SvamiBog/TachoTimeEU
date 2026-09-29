import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/core/l10n/format.dart';
import 'package:tachogo/core/l10n/infringement_text.dart';
import 'package:tachogo/data/settings/settings_repository.dart';
import 'package:tachogo/l10n/app_localizations.dart';
import 'package:tachogo/notifications/notification_platform.dart';

// Что и когда показать водителю по прогнозу движка: категории из
// настроек, тексты из ARB, id уведомления на вид события.

/// id уведомлений о лимитах: по одному на вид. Сервис автоопределения
/// занимает 561 — диапазоны не пересекаются.
const _limitIds = 1000;
const _restIds = 1100;

int alertId(Enum kind) => switch (kind) {
  InfringementType() => _limitIds + kind.index,
  RestMilestone() => _restIds + kind.index,
  _ => throw ArgumentError.value(kind, 'kind'),
};

/// Вид события по id уведомления; null — уведомление не о лимитах.
Enum? alertKindOf(int id) {
  if (id >= _limitIds && id < _limitIds + InfringementType.values.length) {
    return InfringementType.values[id - _limitIds];
  }
  if (id >= _restIds && id < _restIds + RestMilestone.values.length) {
    return RestMilestone.values[id - _restIds];
  }
  return null;
}

/// Водитель хочет знать о событии: категория включена в настройках
/// (экран 3). Справка («идёт продление») уведомлением не приходит —
/// она на главной. Недельный отдых и компенсация — вместе с концом
/// рабочего дня: это тоже обязательный отдых.
bool alertEnabled(Enum kind, NotificationSettings s) => switch (kind) {
  InfringementType(severity: InfringementSeverity.info) => false,
  InfringementType(:final category) => switch (category) {
    InfringementCategory.breaks => s.breaks,
    InfringementCategory.driving => s.driving,
    InfringementCategory.shiftEnd ||
    InfringementCategory.weeklyRest => s.shiftEnd,
    InfringementCategory.card => s.card,
  },
  RestMilestone.breakTaken => s.breaks,
  RestMilestone.dailyRestTaken ||
  RestMilestone.weeklyRestTaken ||
  RestMilestone.compensationTaken => s.shiftEnd,
  _ => false,
};

/// Уведомления по прогнозу: только включённые категории, тексты — на
/// момент уведомления («осталось 0:30» при пороге 30 мин). Время в
/// текстах — длительности: смена часового пояса их не портит.
List<ScheduledAlert> alertNotifications(
  List<UpcomingAlert> upcoming,
  NotificationSettings settings,
  AppLocalizations l,
) => [
  for (final a in upcoming)
    if (alertEnabled(a.kind, settings)) _notification(a, l),
];

ScheduledAlert _notification(UpcomingAlert a, AppLocalizations l) {
  switch (a) {
    case LimitAlert(:final infringement):
      final text = l.infringement(infringement);
      return (
        id: alertId(a.kind),
        at: a.at,
        channel: AlertChannel.limits,
        title: text.title,
        body: text.text,
        article: text.article,
      );
    case RestAlert(:final milestone, :final taken, :final drivingUntilBreak):
      final (title, body) = switch (milestone) {
        RestMilestone.breakTaken => (
          l.notifyBreakTakenTitle,
          l.notifyBreakTakenText(taken.inMinutes, formatHm(drivingUntilBreak)),
        ),
        RestMilestone.dailyRestTaken => (
          l.notifyDailyRestTakenTitle,
          l.notifyDailyRestTakenText(formatLimit(l, taken)),
        ),
        RestMilestone.weeklyRestTaken => (
          l.notifyWeeklyRestTakenTitle,
          l.notifyWeeklyRestTakenText(formatLimit(l, taken)),
        ),
        RestMilestone.compensationTaken => (
          l.notifyCompensationTakenTitle,
          l.notifyCompensationTakenText(formatHm(taken)),
        ),
      };
      return (
        id: alertId(a.kind),
        at: a.at,
        channel: AlertChannel.rest,
        title: title,
        body: body,
        article: null,
      );
  }
}

/// Названия каналов на языке интерфейса.
AlertChannelNames alertChannelNames(AppLocalizations l) => {
  AlertChannel.limits: (
    name: l.notifyChannelLimits,
    hint: l.notifyChannelLimitsHint,
  ),
  AlertChannel.rest: (name: l.notifyChannelRest, hint: l.notifyChannelRestHint),
};
