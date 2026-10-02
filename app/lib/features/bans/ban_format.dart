import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tacho_engine/driving_bans.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/l10n/app_localizations.dart';

// Тексты и цвета запретов движения. Время — местное время страны, как в
// её правилах и на дорожных знаках, а не время телефона.

/// Запреты считаются для грузовика больше 12 т: под него попадают все
/// правила стран. Выбора массы нет (решение владельца 2026-10-02).
const VehicleMass bansMass = VehicleMass.over12;

String _two(int n) => n.toString().padLeft(2, '0');

String _hm(DateTime local) => '${_two(local.hour)}:${_two(local.minute)}';

String _weekday(DateTime local, String locale) =>
    DateFormat('EEE', locale).format(local);

String _capitalize(String s) =>
    s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';

/// «22:00» сегодня по местному времени страны, иначе «вс 22:00».
String banMoment(DateTime utc, BanZone zone, DateTime now, String locale) {
  final local = zone.toLocal(utc);
  final today = zone.toLocal(now);
  final sameDay =
      local.year == today.year &&
      local.month == today.month &&
      local.day == today.day;
  return sameDay ? _hm(local) : '${_weekday(local, locale)} ${_hm(local)}';
}

/// «Сб 10.10 15:00 – вс 11.10 22:00», в один день — «Вс 11.10 9:00–22:00».
String banSpan(BanWindow w, BanZone zone, String locale) {
  final from = zone.toLocal(w.start);
  final to = zone.toLocal(w.end);
  String day(DateTime d) =>
      '${_weekday(d, locale)} ${_two(d.day)}.${_two(d.month)}';
  final sameDay =
      from.year == to.year && from.month == to.month && from.day == to.day;
  return _capitalize(
    sameDay
        ? '${day(from)} ${_hm(from)}–${_hm(to)}'
        : '${day(from)} ${_hm(from)} – ${day(to)} ${_hm(to)}',
  );
}

/// «7,5» / «7.5» — по локали.
String banTonnes(double tonnes, String locale) =>
    NumberFormat.decimalPattern(locale).format(tonnes);

/// Что с запретами страны сейчас — строка списка и экрана страны.
String banStatusText(
  AppLocalizations l,
  CountryBans country,
  BanStatus s,
  DateTime now,
  String locale,
) {
  String at(DateTime t) => banMoment(t, country.zone, now, locale);
  return switch (s.level) {
    BanLevel.active => l.bansActiveUntil(at(s.current!.end)),
    BanLevel.soon => l.bansSoonFrom(at(s.next!.start)),
    BanLevel.partial => l.bansPartialUntil(at(s.partial!.end)),
    BanLevel.clear =>
      s.next == null ? l.bansClearWeek : l.bansClearUntil(at(s.next!.start)),
    BanLevel.someRoads => l.bansSomeRoads,
    BanLevel.none => l.bansNone,
  };
}

/// Цвет страны на карте и точки в списке.
Color banColor(AppColors colors, BanLevel? level) => switch (level) {
  BanLevel.active => colors.errorText,
  BanLevel.soon => colors.warningText,
  BanLevel.partial => colors.warningBg,
  BanLevel.clear => colors.rest,
  BanLevel.someRoads => colors.textSecondary.withValues(alpha: 0.5),
  BanLevel.none => colors.restBg,
  null => colors.surface2,
};

/// Правило одной строкой: «Сб 22:00 – вс 22:00», «Праздники: накануне
/// 22:00 – 22:00», «Каждую ночь 22:00–05:00».
String banRuleText(AppLocalizations l, BanRule r, String locale) {
  String time(BanTime t) {
    final midnight = t.hour == 0 && t.minute == 0 && t.dayOffset > 0;
    return midnight ? '24:00' : '${_two(t.hour)}:${_two(t.minute)}';
  }

  final from = time(r.from);
  final to = time(r.to);
  final nextDayEnd = r.to.dayOffset > r.from.dayOffset && to != '24:00';
  // 1 января 2024 — понедельник: день недели по номеру
  DateTime weekday(int n) => DateTime.utc(2024, 1, n);
  switch (r.days) {
    case Weekdays(:final days):
      final names = [
        for (final d in days.toList()..sort()) _weekday(weekday(d), locale),
      ];
      final label = _capitalize(names.join(', '));
      if (!nextDayEnd || days.length != 1) return '$label $from–$to';
      final end = _weekday(weekday(days.single + r.to.dayOffset), locale);
      return '$label $from – $end $to';
    case HolidayDays():
      if (r.kind == BanKind.holidayEve) {
        return '${l.bansKind(BanKind.holidayEve.name)}: $from–$to';
      }
      final span = r.from.dayOffset < 0 ? l.bansSpanEve(from, to) : '$from–$to';
      return '${l.bansRuleHolidays}: $span';
    case EveryDay():
      return '${l.bansRuleNights} $from–$to';
    case CalendarDays(:final dates):
      final years = {for (final d in dates) d.year}.join(', ');
      return '${l.bansRuleCalendar(years)}: $from–$to';
  }
}

/// Подпись правила: где, для каких машин, в какую часть года.
String banRuleCaption(AppLocalizations l, BanRule r, String locale) {
  final season = r.season;
  return [
    l.bansScope(r.scope.name),
    l.bansOver(banTonnes(r.overTonnes, locale)),
    if (season != null)
      [
        l.bansSeason(
          '${_two(season.fromDay)}.${_two(season.fromMonth)}',
          '${_two(season.toDay)}.${_two(season.toMonth)}',
        ),
        if (season.year case final year?) '$year',
      ].join(' '),
  ].join(' · ');
}
