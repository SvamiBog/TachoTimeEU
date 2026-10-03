import 'dart:convert';

import 'package:tacho_engine/src/bans/ban_rule.dart';
import 'package:tacho_engine/src/bans/holidays.dart';
import 'package:tacho_engine/src/bans/zone_time.dart';

/// Версия формата файла с правилами запретов. Меняется, когда приложение
/// старой версии прочитало бы новый файл неверно: новый вид дней или
/// праздника, поле, которое меняет смысл правила. Файл новой версии
/// публикуется рядом со старым (`bans/v2.json`), старые версии приложения
/// читают свой. Поля, которых формат не знает, читатель пропускает —
/// поэтому новое поле, без которого правило читается неверно, — только с
/// новой версией.
const banDataFormat = 1;

/// Правила стран [countries] — текстом JSON формата [banDataFormat].
/// Одни и те же правила — всегда один и тот же текст.
String encodeBanData(Iterable<CountryBans> countries) => jsonEncode({
  'format': banDataFormat,
  'countries': [for (final c in countries) _country(c)],
});

/// Правила стран из текста [encodeBanData] по отличительному знаку.
/// Файл другой версии, неизвестное значение, невозможная дата или время,
/// правило без дней, адрес источника не `https` — [FormatException]:
/// такой файл не используется целиком.
Map<String, CountryBans> decodeBanData(String text) {
  final Object? json;
  try {
    json = jsonDecode(text);
  } on FormatException {
    throw const FormatException('Файл запретов — не JSON');
  }
  final root = _Obj(json, 'файл');
  final format = root.integer('format');
  if (format != banDataFormat) {
    throw FormatException(
      'Формат файла запретов $format, нужен $banDataFormat',
    );
  }
  final countries = <String, CountryBans>{};
  for (final c in root.objects('countries', _readCountry)) {
    if (countries.containsKey(c.code)) {
      throw FormatException('Страна ${c.code} — дважды');
    }
    countries[c.code] = c;
  }
  return countries;
}

/// Самая свежая сверка среди [countries]: по ней приложение выбирает,
/// какие правила новее — встроенные или скачанные.
BanDate latestCheck(Iterable<CountryBans> countries) => countries
    .map((c) => c.checkedOn)
    .reduce((a, b) => a.compareTo(b) >= 0 ? a : b);

Map<String, Object?> _country(CountryBans c) => {
  'code': c.code,
  'zone': c.zone.name,
  'coverage': c.coverage.name,
  'checkedOn': _date(c.checkedOn),
  if (c.calendarUntil case final until?) 'calendarUntil': _date(until),
  if (c.needsCheck) 'needsCheck': true,
  'sources': c.sources,
  'rules': [for (final r in c.rules) _rule(r)],
};

Map<String, Object?> _rule(BanRule r) => {
  'kind': r.kind.name,
  'days': _days(r.days),
  'from': _time(r.from),
  'to': _time(r.to),
  'scope': r.scope.name,
  'overTonnes': r.overTonnes,
  if (r.season case final s?)
    'season': {
      'from': _monthDay(s.fromMonth, s.fromDay),
      'to': _monthDay(s.toMonth, s.toDay),
      'year': ?s.year,
    },
};

Map<String, Object?> _days(BanDays days) => switch (days) {
  Weekdays(:final days) => {
    'type': 'weekdays',
    'weekdays': days.toList()..sort(),
  },
  HolidayDays(:final holidays) => {
    'type': 'holidays',
    'holidays': [for (final h in holidays) _holiday(h)],
  },
  EveryDay() => {'type': 'everyDay'},
  CalendarDays(:final dates) => {
    'type': 'dates',
    'dates': [for (final d in dates) _date(d)],
  },
};

Map<String, Object?> _holiday(Holiday h) => switch (h) {
  FixedHoliday(:final month, :final day) => {
    'type': 'fixed',
    'date': _monthDay(month, day),
  },
  EasterHoliday(:final offset, :final orthodox) => {
    'type': 'easter',
    'offset': offset,
    if (orthodox) 'orthodox': true,
  },
};

String _two(int n) => n.toString().padLeft(2, '0');

String _date(BanDate d) =>
    '${d.year.toString().padLeft(4, '0')}-${_two(d.month)}-${_two(d.day)}';

String _monthDay(int month, int day) => '${_two(month)}-${_two(day)}';

/// «22:00», «05:00+1», «18:00-1»: время и сдвиг в днях от опорного дня.
String _time(BanTime t) {
  final offset = switch (t.dayOffset) {
    0 => '',
    > 0 => '+${t.dayOffset}',
    _ => '${t.dayOffset}',
  };
  return '${_two(t.hour)}:${_two(t.minute)}$offset';
}

final _datePattern = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$');
final _monthDayPattern = RegExp(r'^(\d{2})-(\d{2})$');
final _timePattern = RegExp(r'^(\d{2}):(\d{2})([+-]\d)?$');
final _codePattern = RegExp(r'^[A-Z]{1,3}$');

CountryBans _readCountry(_Obj o) {
  final code = o.string('code');
  if (!_codePattern.hasMatch(code)) {
    throw FormatException('Неверный знак страны «$code»');
  }
  final coverage = o.choice('coverage', BanCoverage.values);
  final rules = o.objects('rules', _readRule, optional: true);
  if ((coverage == BanCoverage.rules) != rules.isNotEmpty) {
    throw FormatException('$code: правила не по охвату ${coverage.name}');
  }
  return CountryBans(
    code: code,
    zone: o.choice('zone', BanZone.values),
    coverage: coverage,
    checkedOn: _readDate(o.string('checkedOn')),
    calendarUntil: switch (o.optionalString('calendarUntil')) {
      final until? => _readDate(until),
      null => null,
    },
    needsCheck: o.flag('needsCheck'),
    sources: o.list('sources', _readSource, optional: true),
    rules: rules,
  );
}

String _readSource(Object? json) {
  final source = _Obj.stringOf(json, 'источник');
  final uri = Uri.tryParse(source);
  if (uri == null || uri.scheme != 'https' || uri.host.isEmpty) {
    throw FormatException('Источник не https: $source');
  }
  return source;
}

BanRule _readRule(_Obj o) {
  final from = _readTime(o.string('from'));
  final to = _readTime(o.string('to'));
  final day = DateTime.utc(2026);
  if (!to.on(day).isAfter(from.on(day))) {
    throw FormatException('Запрет кончается раньше начала: ${o.string('to')}');
  }
  final overTonnes = o.number('overTonnes');
  if (overTonnes <= 0 || overTonnes > 100) {
    throw FormatException('Неверный порог массы $overTonnes');
  }
  return BanRule(
    kind: o.choice('kind', BanKind.values),
    days: _readDays(o.object('days')),
    from: from,
    to: to,
    scope: o.choice('scope', BanScope.values),
    overTonnes: overTonnes,
    season: switch (o.optionalObject('season')) {
      final s? => _readSeason(s),
      null => null,
    },
  );
}

BanDays _readDays(_Obj o) => switch (o.string('type')) {
  'weekdays' => Weekdays(
    o.list('weekdays', (json) {
      final day = _Obj.intOf(json, 'день недели');
      if (day < DateTime.monday || day > DateTime.sunday) {
        throw FormatException('Неверный день недели $day');
      }
      return day;
    }).toSet(),
  ),
  'holidays' => HolidayDays(o.list('holidays', _readHoliday)),
  'everyDay' => const EveryDay(),
  'dates' => CalendarDays(
    o.list('dates', (json) => _readDate(_Obj.stringOf(json, 'дата'))),
  ),
  final type => throw FormatException('Неизвестный вид дней «$type»'),
};

Holiday _readHoliday(Object? json) {
  final o = _Obj(json, 'праздник');
  switch (o.string('type')) {
    case 'fixed':
      final (month, day) = _readMonthDay(o.string('date'));
      return FixedHoliday(month, day);
    case 'easter':
      final offset = o.integer('offset');
      if (offset.abs() > 100) {
        throw FormatException('Неверный сдвиг от Пасхи $offset');
      }
      return EasterHoliday(offset, orthodox: o.flag('orthodox'));
    case final type:
      throw FormatException('Неизвестный вид праздника «$type»');
  }
}

BanSeason _readSeason(_Obj o) {
  final (fromMonth, fromDay) = _readMonthDay(o.string('from'));
  final (toMonth, toDay) = _readMonthDay(o.string('to'));
  final year = o.optionalInteger('year');
  if (year != null && (year < 2000 || year > 2100)) {
    throw FormatException('Неверный год сезона $year');
  }
  return BanSeason(fromMonth, fromDay, toMonth, toDay, year: year);
}

BanDate _readDate(String text) {
  final m = _datePattern.firstMatch(text);
  if (m == null) throw FormatException('Неверная дата «$text»');
  final year = int.parse(m.group(1)!);
  final month = int.parse(m.group(2)!);
  final day = int.parse(m.group(3)!);
  _checkDate(year, month, day, text);
  return BanDate(year, month, day);
}

(int, int) _readMonthDay(String text) {
  final m = _monthDayPattern.firstMatch(text);
  if (m == null) throw FormatException('Неверная дата «$text»');
  final month = int.parse(m.group(1)!);
  final day = int.parse(m.group(2)!);
  // Високосный год: 29 февраля бывает
  _checkDate(2024, month, day, text);
  return (month, day);
}

void _checkDate(int year, int month, int day, String text) {
  final d = DateTime.utc(year, month, day);
  if (d.year != year || d.month != month || d.day != day) {
    throw FormatException('Неверная дата «$text»');
  }
}

BanTime _readTime(String text) {
  final m = _timePattern.firstMatch(text);
  if (m == null) throw FormatException('Неверное время «$text»');
  final hour = int.parse(m.group(1)!);
  final minute = int.parse(m.group(2)!);
  if (hour > 23 || minute > 59) {
    throw FormatException('Неверное время «$text»');
  }
  return BanTime(hour, minute: minute, dayOffset: int.parse(m.group(3) ?? '0'));
}

/// Объект JSON с проверкой типов: неверный тип или нет поля —
/// [FormatException] с названием поля.
extension type _Obj._(Map<String, Object?> _map) {
  factory(Object? json, String what) => json is Map<String, Object?>
      ? _Obj._(json)
      : throw FormatException('$what — не объект JSON');

  static String stringOf(Object? json, String what) =>
      json is String ? json : throw FormatException('$what — не строка');

  static int intOf(Object? json, String what) =>
      json is int ? json : throw FormatException('$what — не целое число');

  Object? _field(String key) => _map.containsKey(key)
      ? _map[key]
      : throw FormatException('Нет поля «$key»');

  String string(String key) => stringOf(_field(key), key);

  String? optionalString(String key) => _map[key] == null ? null : string(key);

  int integer(String key) => intOf(_field(key), key);

  int? optionalInteger(String key) => _map[key] == null ? null : integer(key);

  double number(String key) => switch (_field(key)) {
    final num n => n.toDouble(),
    _ => throw FormatException('$key — не число'),
  };

  bool flag(String key) => switch (_map[key]) {
    null => false,
    final bool b => b,
    _ => throw FormatException('$key — не true / false'),
  };

  _Obj object(String key) => _Obj(_field(key), key);

  _Obj? optionalObject(String key) => _map[key] == null ? null : object(key);

  T choice<T extends Enum>(String key, List<T> values) {
    final name = string(key);
    for (final v in values) {
      if (v.name == name) return v;
    }
    throw FormatException('Неизвестное значение $key «$name»');
  }

  /// Список [key], каждый элемент читает [read]. [optional] — нет поля —
  /// пустой список.
  List<T> list<T>(
    String key,
    T Function(Object? json) read, {
    bool optional = false,
  }) {
    final json = optional ? _map[key] ?? const <Object?>[] : _field(key);
    if (json is! List<Object?>) throw FormatException('$key — не список');
    return [for (final item in json) read(item)];
  }

  /// Список объектов [key], каждый читает [read].
  List<T> objects<T>(
    String key,
    T Function(_Obj o) read, {
    bool optional = false,
  }) => list(key, (json) => read(_Obj(json, key)), optional: optional);
}
