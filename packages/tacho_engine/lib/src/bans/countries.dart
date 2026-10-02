// Запреты движения грузовиков в странах Европы: данные и источники.
// Сверка — docs/domain/driving-bans.md. Время — местное, страна переводит
// часы по правилу ЕС. Меняются правила или выходит годовой календарь
// страны — обновить данные, checkedOn и тесты (BAN-…).

import 'package:tacho_engine/src/bans/ban_rule.dart';
import 'package:tacho_engine/src/bans/holidays.dart';
import 'package:tacho_engine/src/bans/zone_time.dart';

const _checked = BanDate(2026, 10, 1);
const _end2026 = BanDate(2026, 12, 31);

// Праздники
const _newYear = FixedHoliday(1, 1);
const _epiphany = FixedHoliday(1, 6);
const _goodFriday = EasterHoliday(-2);
const _easter = EasterHoliday(0);
const _easterMonday = EasterHoliday(1);
const _labourDay = FixedHoliday(5, 1);
const _ascension = EasterHoliday(39);
const _whitSunday = EasterHoliday(49);
const _whitMonday = EasterHoliday(50);
const _corpusChristi = EasterHoliday(60);
const _assumption = FixedHoliday(8, 15);
const _allSaints = FixedHoliday(11, 1);
const _christmasEve = FixedHoliday(12, 24);
const _christmas = FixedHoliday(12, 25);
const _boxingDay = FixedHoliday(12, 26);

const _sunday = Weekdays({DateTime.sunday});
const _saturday = Weekdays({DateTime.saturday});
const _friday = Weekdays({DateTime.friday});
const _julyAugust = BanSeason(7, 1, 8, 31);

/// Германия: StVO § 30 (3), (4) и Ferienreiseverordnung. Больше 7,5 т и
/// грузовики с прицепом.
const germany = CountryBans(
  code: 'D',
  zone: BanZone.cet,
  coverage: BanCoverage.rules,
  checkedOn: _checked,
  sources: [
    'https://www.gesetze-im-internet.de/stvo_2013/__30.html',
    'https://www.gesetze-im-internet.de/ferreisev/',
  ],
  rules: [
    BanRule(
      kind: BanKind.weekend,
      days: _sunday,
      from: BanTime(0),
      to: BanTime(22),
    ),
    BanRule(
      kind: BanKind.holiday,
      days: HolidayDays([
        _newYear,
        _goodFriday,
        _easterMonday,
        _labourDay,
        _ascension,
        _whitMonday,
        FixedHoliday(10, 3),
        _christmas,
        _boxingDay,
      ]),
      from: BanTime(0),
      to: BanTime(22),
    ),
    // Только в части земель: Тело Христово, День Реформации, Все Святые
    BanRule(
      kind: BanKind.holiday,
      days: HolidayDays([_corpusChristi, FixedHoliday(10, 31), _allSaints]),
      from: BanTime(0),
      to: BanTime(22),
      scope: BanScope.someRegions,
    ),
    // Ferienreiseverordnung: участки автобанов и федеральных дорог
    BanRule(
      kind: BanKind.summer,
      days: _saturday,
      from: BanTime(7),
      to: BanTime(20),
      scope: BanScope.someRoads,
      season: _julyAugust,
    ),
  ],
);

/// Австрия: StVO § 42, KDV § 8b. Больше 7,5 т; ночной — кроме малошумных
/// машин с табличкой «L».
const austria = CountryBans(
  code: 'A',
  zone: BanZone.cet,
  coverage: BanCoverage.rules,
  checkedOn: _checked,
  sources: [
    'https://www.usp.gv.at/umwelt-verkehr/verkehr/lkw-fahrverbote/allgemeines-nacht-wochenend-und-feiertagsfahrverbot.html',
  ],
  rules: [
    BanRule(
      kind: BanKind.weekend,
      days: _saturday,
      from: BanTime(15),
      to: BanTime(0, dayOffset: 1),
    ),
    BanRule(
      kind: BanKind.weekend,
      days: _sunday,
      from: BanTime(0),
      to: BanTime(22),
    ),
    BanRule(
      kind: BanKind.holiday,
      days: HolidayDays([
        _newYear,
        _epiphany,
        _easterMonday,
        _labourDay,
        _ascension,
        _whitMonday,
        _corpusChristi,
        _assumption,
        FixedHoliday(10, 26),
        _allSaints,
        FixedHoliday(12, 8),
        _christmas,
        _boxingDay,
      ]),
      from: BanTime(0),
      to: BanTime(22),
    ),
    BanRule(
      kind: BanKind.night,
      days: EveryDay(),
      from: BanTime(22),
      to: BanTime(5, dayOffset: 1),
      scope: BanScope.conditional,
    ),
  ],
);

const _swissRules = [
  BanRule(
    kind: BanKind.weekend,
    days: _sunday,
    from: BanTime(0),
    to: BanTime(0, dayOffset: 1),
    overTonnes: 3.5,
  ),
  BanRule(
    kind: BanKind.holiday,
    days: HolidayDays([
      _newYear,
      _goodFriday,
      _easterMonday,
      _ascension,
      _whitMonday,
      FixedHoliday(8, 1),
      _christmas,
      _boxingDay,
    ]),
    from: BanTime(0),
    to: BanTime(0, dayOffset: 1),
    overTonnes: 3.5,
  ),
  BanRule(
    kind: BanKind.night,
    days: EveryDay(),
    from: BanTime(22),
    to: BanTime(5, dayOffset: 1),
    overTonnes: 3.5,
  ),
];

/// Швейцария: SVG Art. 2, VRV Art. 91–92. Больше 3,5 т — и фургоны с
/// прицепом.
const switzerland = CountryBans(
  code: 'CH',
  zone: BanZone.cet,
  coverage: BanCoverage.rules,
  checkedOn: _checked,
  sources: ['https://www.fedlex.admin.ch/eli/cc/1962/1364_1409_1420/de'],
  rules: _swissRules,
);

/// Лихтенштейн — правила Швейцарии.
const liechtenstein = CountryBans(
  code: 'FL',
  zone: BanZone.cet,
  coverage: BanCoverage.rules,
  checkedOn: _checked,
  sources: ['https://www.gesetze.li'],
  rules: _swissRules,
);

const _czechHolidays = HolidayDays([
  _newYear,
  _goodFriday,
  _easterMonday,
  _labourDay,
  FixedHoliday(5, 8),
  FixedHoliday(7, 5),
  FixedHoliday(7, 6),
  FixedHoliday(9, 28),
  FixedHoliday(10, 28),
  FixedHoliday(11, 17),
  _christmasEve,
  _christmas,
  _boxingDay,
]);

/// Чехия: закон 361/2000 Sb., § 43. Больше 7,5 т, автомагистрали и
/// дороги I класса.
const czechia = CountryBans(
  code: 'CZ',
  zone: BanZone.cet,
  coverage: BanCoverage.rules,
  checkedOn: _checked,
  sources: ['https://www.zakonyprolidi.cz/cs/2000-361#p43'],
  rules: [
    BanRule(
      kind: BanKind.weekend,
      days: _sunday,
      from: BanTime(13),
      to: BanTime(22),
      scope: BanScope.mainRoads,
    ),
    BanRule(
      kind: BanKind.holiday,
      days: _czechHolidays,
      from: BanTime(13),
      to: BanTime(22),
      scope: BanScope.mainRoads,
    ),
    BanRule(
      kind: BanKind.summer,
      days: _friday,
      from: BanTime(17),
      to: BanTime(21),
      scope: BanScope.mainRoads,
      season: _julyAugust,
    ),
    BanRule(
      kind: BanKind.summer,
      days: _saturday,
      from: BanTime(7),
      to: BanTime(13),
      scope: BanScope.mainRoads,
      season: _julyAugust,
    ),
  ],
);

/// Словакия: закон 8/2009 Z. z., § 39. Больше 7,5 т и больше 3,5 т с
/// прицепом; автомагистрали, скоростные дороги и дороги I класса. Список
/// выходных праздников менялся в 2025–2026 — сверить.
const slovakia = CountryBans(
  code: 'SK',
  zone: BanZone.cet,
  coverage: BanCoverage.rules,
  checkedOn: _checked,
  needsCheck: true,
  sources: ['https://www.slov-lex.sk/pravne-predpisy/SK/ZZ/2009/8/'],
  rules: [
    BanRule(
      kind: BanKind.weekend,
      days: _sunday,
      from: BanTime(0),
      to: BanTime(22),
      scope: BanScope.mainRoads,
    ),
    BanRule(
      kind: BanKind.holiday,
      days: HolidayDays([
        _newYear,
        _epiphany,
        _goodFriday,
        _easterMonday,
        _labourDay,
        FixedHoliday(7, 5),
        FixedHoliday(8, 29),
        _allSaints,
        _christmasEve,
        _christmas,
        _boxingDay,
      ]),
      from: BanTime(0),
      to: BanTime(22),
      scope: BanScope.mainRoads,
    ),
    BanRule(
      kind: BanKind.summer,
      days: _saturday,
      from: BanTime(7),
      to: BanTime(19),
      scope: BanScope.mainRoads,
      season: _julyAugust,
    ),
  ],
);

/// Венгрия: больше 7,5 т, все дороги. Летом с 15:00 субботы; зимой
/// международные перевозки Euro 3+ освобождены — сверить.
const hungary = CountryBans(
  code: 'H',
  zone: BanZone.cet,
  coverage: BanCoverage.rules,
  checkedOn: _checked,
  needsCheck: true,
  sources: ['https://www.mkfe.hu/en'],
  rules: [
    BanRule(
      kind: BanKind.weekend,
      days: _saturday,
      from: BanTime(22),
      to: BanTime(22, dayOffset: 1),
    ),
    BanRule(
      kind: BanKind.summer,
      days: _saturday,
      from: BanTime(15),
      to: BanTime(22, dayOffset: 1),
      season: _julyAugust,
    ),
    BanRule(
      kind: BanKind.holiday,
      days: HolidayDays([
        _newYear,
        FixedHoliday(3, 15),
        _goodFriday,
        _easterMonday,
        _labourDay,
        _whitMonday,
        FixedHoliday(8, 20),
        FixedHoliday(10, 23),
        _allSaints,
        _christmas,
        _boxingDay,
      ]),
      from: BanTime(22, dayOffset: -1),
      to: BanTime(22),
    ),
  ],
);

const _polishSummer2026 = BanSeason(6, 26, 8, 30, year: 2026);

const _polishEves = HolidayDays([
  _easter,
  _labourDay,
  FixedHoliday(5, 3),
  _whitSunday,
  _corpusChristi,
  _assumption,
  _allSaints,
  FixedHoliday(11, 11),
]);

/// Польша: распоряжение Министра транспорта от 31.07.2007 (Dz.U. 2021
/// poz. 783). Больше 12 т, автомагистрали, скоростные и национальные
/// дороги. Летние даты объявляются по школьному календарю; список
/// праздников и канунов — сверить.
const poland = CountryBans(
  code: 'PL',
  zone: BanZone.cet,
  coverage: BanCoverage.rules,
  checkedOn: _checked,
  calendarUntil: _end2026,
  needsCheck: true,
  sources: [
    'https://www.gov.pl/web/infrastruktura/ograniczenia-w-ruchu',
    'https://isap.sejm.gov.pl/isap.nsf/DocDetails.xsp?id=WDU20210000783',
  ],
  rules: [
    BanRule(
      kind: BanKind.holiday,
      days: HolidayDays([
        _newYear,
        _easter,
        _easterMonday,
        _labourDay,
        FixedHoliday(5, 3),
        _whitSunday,
        _corpusChristi,
        _assumption,
        _allSaints,
        FixedHoliday(11, 11),
        _christmas,
        _boxingDay,
      ]),
      from: BanTime(8),
      to: BanTime(22),
      scope: BanScope.mainRoads,
      overTonnes: 12,
    ),
    BanRule(
      kind: BanKind.holidayEve,
      days: _polishEves,
      from: BanTime(18, dayOffset: -1),
      to: BanTime(22, dayOffset: -1),
      scope: BanScope.mainRoads,
      overTonnes: 12,
    ),
    BanRule(
      kind: BanKind.summer,
      days: _friday,
      from: BanTime(18),
      to: BanTime(22),
      scope: BanScope.mainRoads,
      overTonnes: 12,
      season: _polishSummer2026,
    ),
    BanRule(
      kind: BanKind.summer,
      days: _saturday,
      from: BanTime(8),
      to: BanTime(14),
      scope: BanScope.mainRoads,
      overTonnes: 12,
      season: _polishSummer2026,
    ),
    BanRule(
      kind: BanKind.summer,
      days: _sunday,
      from: BanTime(8),
      to: BanTime(22),
      scope: BanScope.mainRoads,
      overTonnes: 12,
      season: _polishSummer2026,
    ),
  ],
);

/// Словения: Odredba o omejitvi prometa (Ur. l. RS 75/11 и изм.). Больше
/// 7,5 т, автомагистрали и скоростные дороги; летом на дорогах к побережью
/// — с 6:00 до 16:00.
const slovenia = CountryBans(
  code: 'SLO',
  zone: BanZone.cet,
  coverage: BanCoverage.rules,
  checkedOn: _checked,
  calendarUntil: _end2026,
  sources: ['https://www.promet.si/sl/splosne-omejitve'],
  rules: [
    BanRule(
      kind: BanKind.weekend,
      days: _sunday,
      from: BanTime(8),
      to: BanTime(22),
      scope: BanScope.mainRoads,
    ),
    BanRule(
      kind: BanKind.holiday,
      days: HolidayDays([
        _newYear,
        FixedHoliday(1, 2),
        FixedHoliday(2, 8),
        _easter,
        _easterMonday,
        FixedHoliday(4, 27),
        _labourDay,
        FixedHoliday(5, 2),
        _whitSunday,
        FixedHoliday(6, 25),
        _assumption,
        FixedHoliday(10, 31),
        _allSaints,
        _christmas,
        _boxingDay,
      ]),
      from: BanTime(8),
      to: BanTime(22),
      scope: BanScope.mainRoads,
    ),
    BanRule(
      kind: BanKind.holiday,
      days: HolidayDays([_goodFriday]),
      from: BanTime(14),
      to: BanTime(22),
      scope: BanScope.mainRoads,
    ),
    BanRule(
      kind: BanKind.summer,
      days: _saturday,
      from: BanTime(8),
      to: BanTime(13),
      scope: BanScope.mainRoads,
      season: BanSeason(6, 27, 9, 6, year: 2026),
    ),
  ],
);

/// Франция: arrêté du 16 avril 2021 (общий режим) и arrêté du 26 décembre
/// 2025 (летние субботы 2026). Больше 7,5 т, все дороги.
const france = CountryBans(
  code: 'F',
  zone: BanZone.cet,
  coverage: BanCoverage.rules,
  checkedOn: _checked,
  calendarUntil: _end2026,
  sources: [
    'https://www.bison-fute.gouv.fr/regime-general,10852.html',
    'https://www.legifrance.gouv.fr/loda/id/JORFTEXT000043400460',
  ],
  rules: [
    BanRule(
      kind: BanKind.weekend,
      days: _saturday,
      from: BanTime(22),
      to: BanTime(22, dayOffset: 1),
    ),
    BanRule(
      kind: BanKind.holiday,
      days: HolidayDays([
        _newYear,
        _easterMonday,
        _labourDay,
        FixedHoliday(5, 8),
        _ascension,
        _whitMonday,
        FixedHoliday(7, 14),
        _assumption,
        _allSaints,
        FixedHoliday(11, 11),
        _christmas,
      ]),
      from: BanTime(22, dayOffset: -1),
      to: BanTime(22),
    ),
    BanRule(
      kind: BanKind.calendar,
      days: CalendarDays([
        BanDate(2026, 7, 11),
        BanDate(2026, 7, 18),
        BanDate(2026, 7, 25),
        BanDate(2026, 8, 1),
        BanDate(2026, 8, 8),
      ]),
      from: BanTime(7),
      to: BanTime(19),
    ),
  ],
);

const _italianHolidays = HolidayDays([
  _newYear,
  _epiphany,
  _easterMonday,
  FixedHoliday(4, 25),
  _labourDay,
  FixedHoliday(6, 2),
  _assumption,
  _allSaints,
  FixedHoliday(12, 8),
  _christmas,
  _boxingDay,
]);

const _italianSummer = BanSeason(6, 1, 9, 30);

/// Италия: годовой календарь Министерства (на 2026 — DM n. 325 от
/// 12.12.2025). Больше 7,5 т, дороги вне населённых пунктов. Воскресенья и
/// праздники: с 9:00, летом с 7:00, до 22:00; дни календаря сверх них —
/// по декрету.
const italy = CountryBans(
  code: 'I',
  zone: BanZone.cet,
  coverage: BanCoverage.rules,
  checkedOn: _checked,
  calendarUntil: _end2026,
  sources: ['https://mit.gov.it/node/21641'],
  rules: [
    BanRule(
      kind: BanKind.weekend,
      days: _sunday,
      from: BanTime(9),
      to: BanTime(22),
      scope: BanScope.mainRoads,
    ),
    BanRule(
      kind: BanKind.weekend,
      days: _sunday,
      from: BanTime(7),
      to: BanTime(22),
      scope: BanScope.mainRoads,
      season: _italianSummer,
    ),
    BanRule(
      kind: BanKind.holiday,
      days: _italianHolidays,
      from: BanTime(9),
      to: BanTime(22),
      scope: BanScope.mainRoads,
    ),
    BanRule(
      kind: BanKind.holiday,
      days: _italianHolidays,
      from: BanTime(7),
      to: BanTime(22),
      scope: BanScope.mainRoads,
      season: _italianSummer,
    ),
    BanRule(
      kind: BanKind.calendar,
      days: CalendarDays([BanDate(2026, 12, 23)]),
      from: BanTime(8),
      to: BanTime(14),
      scope: BanScope.mainRoads,
    ),
  ],
);

/// Люксембург: больше 7,5 т в транзите в сторону Франции и Германии —
/// не для всех рейсов. Сверить.
const luxembourg = CountryBans(
  code: 'L',
  zone: BanZone.cet,
  coverage: BanCoverage.rules,
  checkedOn: _checked,
  needsCheck: true,
  sources: [
    'https://www.bison-fute.gouv.fr/restrictions-pays-limitrophes.html',
  ],
  rules: [
    BanRule(
      kind: BanKind.weekend,
      days: _saturday,
      from: BanTime(21, minute: 30),
      to: BanTime(21, minute: 45, dayOffset: 1),
      scope: BanScope.conditional,
    ),
    BanRule(
      kind: BanKind.holiday,
      days: HolidayDays([
        _newYear,
        _easterMonday,
        _labourDay,
        FixedHoliday(5, 9),
        _ascension,
        _whitMonday,
        FixedHoliday(6, 23),
        _assumption,
        _allSaints,
        _christmas,
        _boxingDay,
      ]),
      from: BanTime(21, minute: 30, dayOffset: -1),
      to: BanTime(21, minute: 45),
      scope: BanScope.conditional,
    ),
  ],
);

CountryBans _roads(String code, BanZone zone, String source) => CountryBans(
  code: code,
  zone: zone,
  coverage: BanCoverage.someRoads,
  checkedOn: _checked,
  sources: [source],
);

CountryBans _none(String code, BanZone zone) => CountryBans(
  code: code,
  zone: zone,
  coverage: BanCoverage.none,
  checkedOn: _checked,
);

/// Страны Европы с данными о запретах, по отличительному знаку.
final Map<String, CountryBans> europeBans = {
  for (final c in [
    germany,
    austria,
    switzerland,
    liechtenstein,
    czechia,
    slovakia,
    hungary,
    poland,
    slovenia,
    france,
    italy,
    luxembourg,
    // Запреты на отдельных дорогах — по годовым решениям властей
    _roads('E', BanZone.cet, 'https://www.dgt.es'),
    _roads('HR', BanZone.cet, 'https://mup.gov.hr'),
    _roads('RO', BanZone.eet, 'https://www.cnair.ro'),
    _roads('BG', BanZone.eet, 'https://www.api.bg'),
    _roads('GR', BanZone.eet, 'https://www.yme.gov.gr'),
    // Общих запретов нет (бывают для опасных грузов)
    _none('B', BanZone.cet),
    _none('NL', BanZone.cet),
    _none('DK', BanZone.cet),
    _none('S', BanZone.cet),
    _none('N', BanZone.cet),
    _none('FIN', BanZone.eet),
    _none('EST', BanZone.eet),
    _none('LV', BanZone.eet),
    _none('LT', BanZone.eet),
    _none('P', BanZone.wet),
    _none('IRL', BanZone.wet),
    _none('UK', BanZone.wet),
    _none('CY', BanZone.eet),
    _none('M', BanZone.cet),
  ])
    c.code: c,
};
