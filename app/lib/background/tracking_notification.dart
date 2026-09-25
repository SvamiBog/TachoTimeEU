import 'package:tacho_engine/tacho_engine.dart';

/// Текст постоянного уведомления сервиса: текущий режим и главный таймер.
/// Строки на русском до локализации (Фаза 3, ARB).
({String title, String text}) trackingNotification(
  ComplianceSnapshot m, {
  AutoSwitch? suggestion,
}) {
  if (suggestion case AutoSwitch(:final at?)) {
    final since = _clock(at);
    return switch (suggestion.reason) {
      AutoSwitchReason.team => (
        title: 'Машина едет',
        text: 'Вы за рулём? Вождение с $since',
      ),
      _ => (
        title: 'Похоже, вы едете',
        text: 'Начать вождение с $since? Отдых будет прерван',
      ),
    };
  }

  final inMode = _hm(m.currentModeDuration);
  switch (m.status) {
    case DriverStatus.driving:
      final over = m.continuousDriving - EuLimits.continuousDriving;
      return (
        title: 'Вождение · $inMode',
        text: over > Duration.zero
            ? 'Нужен перерыв: превышение ${_hm(over)}'
            : 'До перерыва ${_hm(m.drivingUntilBreak)} · '
                  'за день осталось ${_hm(m.dailyDrivingRemaining)}',
      );
    case DriverStatus.onBreak:
      final b = m.currentBreak;
      final left = b == null ? Duration.zero : b.required - b.duration;
      return (
        title: 'Перерыв · $inMode',
        text: left > Duration.zero
            ? 'До полного перерыва ${_hm(left)}'
            : 'Перерыв засчитан, можно ехать ${_hm(m.drivingUntilBreak)}',
      );
    case DriverStatus.otherWork:
    case DriverStatus.availability:
      final mode = m.status == DriverStatus.otherWork
          ? 'Другая работа'
          : 'Готовность';
      return (
        title: '$mode · $inMode',
        text: 'Рабочий день ${_hm(m.shiftDuration)} из ${_hm(m.shiftLimit)}',
      );
    case DriverStatus.dailyRest:
      final left = m.dailyRestRemaining ?? Duration.zero;
      return (
        title: 'Суточный отдых · $inMode',
        text: left > Duration.zero
            ? 'До полного отдыха 11 ч: ${_hm(left)}'
            : 'Полный суточный отдых набран',
      );
    case DriverStatus.weeklyRest:
      final left = m.weeklyRestRemaining ?? Duration.zero;
      return (
        title: 'Недельный отдых · $inMode',
        text: left > Duration.zero
            ? 'До полного отдыха 45 ч: ${_hm(left)}'
            : 'Полный недельный отдых набран',
      );
    case DriverStatus.notStarted:
      return (
        title: 'Смена не начата',
        text: 'Вождение включится само, когда машина поедет',
      );
    case DriverStatus.unknown:
      return (
        title: 'Режим не выбран',
        text: 'Откройте TachoGo и выберите режим',
      );
  }
}

/// «4:05»: часы без ограничения, минуты с округлением вниз.
String _hm(Duration d) {
  final total = d.isNegative ? 0 : d.inMinutes;
  return '${total ~/ 60}:${(total % 60).toString().padLeft(2, '0')}';
}

/// Местное время устройства «06:05».
String _clock(DateTime t) {
  final local = t.toLocal();
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(local.hour)}:${two(local.minute)}';
}
