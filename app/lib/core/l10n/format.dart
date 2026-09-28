// Форматы времени на экранах. Движок считает в UTC, водитель видит
// местное время телефона; длительности от часового пояса не зависят.

import 'package:intl/intl.dart';
import 'package:tachogo/l10n/app_localizations.dart';

/// Длительность как на тахографе: «4:30», «56:00», «−0:15». Неполная минута
/// отбрасывается — таймер меняется, когда минута прошла целиком.
String formatHm(Duration d) {
  final minutes = d.inMinutes;
  final m = minutes.abs();
  final sign = minutes < 0 ? '−' : '';
  return '$sign${m ~/ 60}:${(m % 60).toString().padLeft(2, '0')}';
}

/// Лимит: целые часы — «56 ч», иначе «4:30».
String formatLimit(AppLocalizations l, Duration d) =>
    d.inMinutes % 60 == 0 ? l.hoursShort(d.inHours) : formatHm(d);

/// Местное время «06:49».
String formatClock(DateTime t) {
  final local = t.toLocal();
  return '${_two(local.hour)}:${_two(local.minute)}';
}

/// «Ср, 23 сентября» — в шапке главной.
String formatWeekdayDate(DateTime t, String locale) =>
    _capitalize(DateFormat('EEE, d MMMM', locale).format(t.toLocal()));

/// «вс 06:10» — срок в пределах недели.
String formatWeekdayClock(DateTime t, String locale) =>
    '${DateFormat('EEE', locale).format(t.toLocal())} ${formatClock(t)}';

/// «пн 21.09, 06:10».
String formatWeekdayDayClock(DateTime t, String locale) =>
    '${formatWeekdayDay(t, locale)}, ${formatClock(t)}';

/// «ср 23.09».
String formatWeekdayDay(DateTime t, String locale) =>
    '${DateFormat('EEE', locale).format(t.toLocal())} ${formatDayMonth(t)}';

/// «02.09».
String formatDayMonth(DateTime t) {
  final local = t.toLocal();
  return '${_two(local.day)}.${_two(local.month)}';
}

/// Длительность для TalkBack / VoiceOver: «4 часа 30 минут», а не «4:30».
String spokenDuration(AppLocalizations l, Duration d) {
  final total = d.inMinutes.abs();
  final hours = total ~/ 60;
  final minutes = total % 60;
  final text = [
    if (hours > 0) l.spokenHours(hours),
    if (minutes > 0 || hours == 0) l.spokenMinutes(minutes),
  ].join(' ');
  return d.inMinutes < 0 ? l.spokenOverrun(text) : text;
}

/// Тот же день по местному времени.
bool isSameLocalDay(DateTime a, DateTime b) {
  final x = a.toLocal();
  final y = b.toLocal();
  return x.year == y.year && x.month == y.month && x.day == y.day;
}

String _two(int n) => n.toString().padLeft(2, '0');

String _capitalize(String s) =>
    s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';

/// «01.07.2026» — дата из регламента: день по UTC, без перевода в местное
/// время, иначе западнее Гринвича 1 июля показалось бы 30 июня.
String formatUtcDate(DateTime t) {
  final u = t.toUtc();
  return '${_two(u.day)}.${_two(u.month)}.${u.year}';
}

/// «02.09.2026».
String formatDayMonthYear(DateTime t) =>
    '${formatDayMonth(t)}.${t.toLocal().year}';

/// «Вс 27.09 · 06:10» — срок недельного отдыха.
String formatDeadline(DateTime t, String locale) =>
    '${_capitalize(formatWeekdayDay(t, locale))} · ${formatClock(t)}';

/// «Сентябрь 2026» — месяц в шапке журнала.
String formatMonthYear(DateTime t, String locale) =>
    _capitalize(DateFormat('LLLL y', locale).format(t.toLocal()));

/// «21–27 сентября», «28 сентября – 4 октября» — неделя журнала. Неделя
/// считается в UTC (ст. 4(i), как на тахографе), поэтому и даты — UTC:
/// в любом поясе это понедельник–воскресенье.
String formatWeekRange(DateTime weekStart, String locale) {
  final start = weekStart.toUtc();
  final end = start.add(const Duration(days: 6));
  final dayMonth = DateFormat('d MMMM', locale);
  return start.month == end.month
      ? '${start.day}–${dayMonth.format(end)}'
      : '${dayMonth.format(start)} – ${dayMonth.format(end)}';
}

/// «Ср» — день недели в строке журнала.
String formatWeekdayShort(DateTime t, String locale) =>
    _capitalize(DateFormat('EEE', locale).format(t.toLocal()));

/// «Вторник, 22 сентября» — под заголовком смены.
String formatWeekdayFull(DateTime t, String locale) =>
    _capitalize(DateFormat('EEEE, d MMMM', locale).format(t.toLocal()));

/// «18.09 11:20».
String formatDayMonthClock(DateTime t) =>
    '${formatDayMonth(t)} ${formatClock(t)}';
