/// Неделя по ст. 4(i) Регламента 561/2006.
const week = Duration(days: 7);

/// Начало недели по ст. 4(i): понедельник 00:00. Считаем в UTC, как
/// цифровой тахограф, — часовой пояс устройства на границу недели не влияет.
DateTime weekStartUtc(DateTime at) {
  final t = at.toUtc();
  return DateTime.utc(t.year, t.month, t.day - (t.weekday - DateTime.monday));
}

/// Длительность от [from] до [to]; не бывает отрицательной.
Duration durationBetween(DateTime from, DateTime to) {
  final d = to.difference(from);
  return d.isNegative ? Duration.zero : d;
}

/// Длина пересечения отрезка [start, end) с окном [from, to).
Duration overlap(DateTime start, DateTime end, DateTime from, DateTime to) =>
    durationBetween(later(start, from), earlier(end, to));

DateTime earlier(DateTime a, DateTime b) => a.isBefore(b) ? a : b;

DateTime later(DateTime a, DateTime b) => a.isAfter(b) ? a : b;

Duration shorter(Duration a, Duration b) => a < b ? a : b;

Duration longer(Duration a, Duration b) => a > b ? a : b;

/// Длительность без отрицательных значений: остаток до лимита.
Duration clampToZero(Duration d) => d.isNegative ? Duration.zero : d;

/// Округление вниз до целой минуты.
Duration floorToMinute(Duration d) =>
    Duration(minutes: _floorDiv(d.inMicroseconds, _usPerMinute));

/// Момент, округлённый вниз до целой минуты (UTC).
DateTime floorTimeToMinute(DateTime t) => DateTime.fromMicrosecondsSinceEpoch(
  _floorDiv(t.microsecondsSinceEpoch, _usPerMinute) * _usPerMinute,
  isUtc: true,
);

/// Целых суток в [d] с округлением вниз (для отрицательных — к −∞).
int floorDays(Duration d) =>
    _floorDiv(d.inMicroseconds, Duration.microsecondsPerDay);

const int _usPerMinute = Duration.microsecondsPerMinute;

/// Деление с округлением к −∞; `%` в Dart для b > 0 всегда неотрицателен.
int _floorDiv(int a, int b) => (a - a % b) ~/ b;
