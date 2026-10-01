import 'package:meta/meta.dart';

/// Праздник для запретов движения: число месяца или сдвиг от Пасхи. Дата —
/// местная, в `DateTime.utc` (полночь).
@immutable
sealed class Holiday {
  const new();

  DateTime dateIn(int year);
}

/// Праздник в одно и то же число каждый год.
final class FixedHoliday extends Holiday {
  const new(this.month, this.day);

  final int month;
  final int day;

  @override
  DateTime dateIn(int year) => DateTime.utc(year, month, day);
}

/// Праздник от Пасхи: Страстная пятница −2, Пасхальный понедельник +1,
/// Вознесение +39, Троица +49, Духов день +50, Тело Христово +60.
/// [orthodox] — от православной Пасхи (Болгария, Румыния, Греция).
final class EasterHoliday extends Holiday {
  const new(this.offset, {this.orthodox = false});

  final int offset;
  final bool orthodox;

  @override
  DateTime dateIn(int year) {
    final easter = orthodox ? orthodoxEaster(year) : westernEaster(year);
    return DateTime.utc(easter.year, easter.month, easter.day + offset);
  }
}

/// Западная (григорианская) Пасха: анонимный алгоритм Гаусса — Мииса.
DateTime westernEaster(int year) {
  final a = year % 19;
  final b = year ~/ 100;
  final c = year % 100;
  final d = b ~/ 4;
  final e = b % 4;
  final f = (b + 8) ~/ 25;
  final g = (b - f + 1) ~/ 3;
  final h = (19 * a + b - d - g + 15) % 30;
  final i = c ~/ 4;
  final k = c % 4;
  final l = (32 + 2 * e + 2 * i - h - k) % 7;
  final m = (a + 11 * h + 22 * l) ~/ 451;
  final month = (h + l - 7 * m + 114) ~/ 31;
  final day = (h + l - 7 * m + 114) % 31 + 1;
  return DateTime.utc(year, month, day);
}

/// Православная Пасха по юлианскому алгоритму Мииса, в григорианском
/// календаре (+13 дней — верно для 1900–2099).
DateTime orthodoxEaster(int year) {
  final a = year % 4;
  final b = year % 7;
  final c = year % 19;
  final d = (19 * c + 15) % 30;
  final e = (2 * a + 4 * b - d + 34) % 7;
  final month = (d + e + 114) ~/ 31;
  final day = (d + e + 114) % 31 + 1;
  return DateTime.utc(year, month, day + 13);
}
