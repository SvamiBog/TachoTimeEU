/// Public holidays for driving bans: fixed dates and dates relative to Western
/// or Orthodox Easter.
library;

import 'package:meta/meta.dart';

/// A holiday for driving bans: a day of the month or an offset from Easter. The
/// date is local, as `DateTime.utc` at midnight.
@immutable
sealed class Holiday {
  const new();

  DateTime dateIn(int year);
}

/// A holiday on the same date every year.
final class FixedHoliday extends Holiday {
  const new(this.month, this.day);

  final int month;
  final int day;

  @override
  DateTime dateIn(int year) => DateTime.utc(year, month, day);
}

/// A holiday relative to Easter: Good Friday −2, Easter Monday +1, Ascension
/// +39, Whit Sunday +49, Whit Monday +50, Corpus Christi +60. [orthodox] counts
/// from Orthodox Easter (Bulgaria, Romania, Greece).
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
