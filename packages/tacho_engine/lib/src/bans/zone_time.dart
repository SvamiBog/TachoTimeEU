/// Часовой пояс страны для запретов движения. Запреты задаются по местному
/// времени страны («воскресенье 00:00–22:00»), а приложение и движок живут
/// в UTC. Все страны с запретами — в поясах WET, CET и EET и переводят часы
/// по правилу ЕС (Директива 2000/84/ЕС), Швейцария и Лихтенштейн — так же.
enum BanZone {
  wet(0),
  cet(1),
  eet(2);

  new(this.standardHours);

  /// Смещение зимнего времени от UTC, часы.
  final int standardHours;

  /// Смещение местного времени от UTC в момент [utc].
  Duration offsetAt(DateTime utc) =>
      Duration(hours: standardHours + (isEuSummerTime(utc) ? 1 : 0));

  /// Местное время в момент [utc]: числа местного времени в `DateTime.utc`.
  DateTime toLocal(DateTime utc) => utc.toUtc().add(offsetAt(utc));

  /// Момент UTC для местного времени [local] (числа — в `DateTime.utc`).
  /// Несуществующий час весной считается зимним временем, повторяющийся
  /// осенью — первым из двух.
  DateTime toUtc(DateTime local) {
    final summer = local.subtract(Duration(hours: standardHours + 1));
    return isEuSummerTime(summer)
        ? summer
        : local.subtract(Duration(hours: standardHours));
  }
}

/// Летнее время ЕС: с последнего воскресенья марта 01:00 UTC до последнего
/// воскресенья октября 01:00 UTC.
bool isEuSummerTime(DateTime at) {
  final t = at.toUtc();
  final start = _lastSunday(t.year, 3).add(const Duration(hours: 1));
  final end = _lastSunday(t.year, 10).add(const Duration(hours: 1));
  return !t.isBefore(start) && t.isBefore(end);
}

DateTime _lastSunday(int year, int month) {
  final last = DateTime.utc(year, month + 1, 0);
  return DateTime.utc(year, month, last.day - last.weekday % 7);
}
