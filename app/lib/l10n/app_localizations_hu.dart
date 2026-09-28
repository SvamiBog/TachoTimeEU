// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class AppLocalizationsHu extends AppLocalizations {
  AppLocalizationsHu([String locale = 'hu']) : super(locale);

  @override
  String get appTitle => 'TachoGo';

  @override
  String get navHome => 'Kezdőlap';

  @override
  String get navJournal => 'Napló';

  @override
  String get navSettings => 'Beállítások';

  @override
  String get navMore => 'Egyebek';

  @override
  String get close => 'Bezárás';

  @override
  String get back => 'Vissza';

  @override
  String ofLimit(String limit) {
    return 'max. $limit';
  }

  @override
  String get premiumLock => 'Premiumban érhető el';

  @override
  String hoursShort(int hours) {
    return '$hours ó';
  }

  @override
  String daysShort(int days) {
    return '$days n';
  }

  @override
  String spokenHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count óra',
      one: '$count óra',
    );
    return '$_temp0';
  }

  @override
  String spokenMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count perc',
      one: '$count perc',
    );
    return '$_temp0';
  }

  @override
  String spokenOverrun(String duration) {
    return 'túllépés $duration';
  }

  @override
  String get modeDriving => 'Vezetés';

  @override
  String get modeRest => 'Pihenő';

  @override
  String get modeWork => 'Munka';

  @override
  String get modeWorkFull => 'Egyéb munka';

  @override
  String get modeAvailability => 'Rendelkezésre állás';

  @override
  String get modeNone => 'Nincs kiválasztott mód';

  @override
  String modeSince(String time) {
    return '$time óta';
  }

  @override
  String get switchFailed => 'A mód nem mentődött el. Próbálja újra.';

  @override
  String homeShiftSince(String date, String time) {
    return '$date · műszak $time óta';
  }

  @override
  String homeNoShift(String date) {
    return '$date · a műszak nem kezdődött el';
  }

  @override
  String get homeLoadError =>
      'A naplót nem sikerült megnyitni. Indítsa újra az alkalmazást — ha nem segít, írjon nekünk az „Egyebek” menüben.';

  @override
  String get heroUntilBreak => 'Szünetig';

  @override
  String get heroBreak => 'Szünet';

  @override
  String get heroDailyRest => 'Napi pihenő';

  @override
  String get heroWeeklyRest => 'Heti pihenő';

  @override
  String heroContinuousOf(String time, String limit) {
    return 'szünet nélkül $time / $limit';
  }

  @override
  String get heroOffDutyHint =>
      'A műszak véget ért. A következő az első, nem pihenő móddal kezdődik.';

  @override
  String get bannerBreakNeeded45 =>
      '45 perces szünet kell (vagy megosztva 15 + 30)';

  @override
  String get bannerBreakNeeded30 =>
      '30 perces szünet kell — a megosztott 15 + 30 második része';

  @override
  String bannerOnBreak(String time, int required) {
    return 'Szünet $time / $required perc';
  }

  @override
  String bannerBreakCounted(String limit) {
    return 'Szünet beszámítva — vezethet $limit';
  }

  @override
  String get sectionAlerts => 'Figyelmeztetések';

  @override
  String get sectionToday => 'Ma';

  @override
  String get sectionRest => 'Pihenő';

  @override
  String get sectionWeek => 'Hét';

  @override
  String get rowContinuous => 'Vezetés szünet nélkül';

  @override
  String get chipBreakSoon => 'hamarosan szünet';

  @override
  String get chipExceeded => 'túllépve';

  @override
  String get chipLimiting => 'korlátoz';

  @override
  String get chipShiftSoon => 'hamarosan vége';

  @override
  String get chipLimitSoon => 'hamarosan határ';

  @override
  String get chipRestSoon => 'hamarosan pihenő';

  @override
  String chipTimes(int hours, int count) {
    return '$hours ó ×$count';
  }

  @override
  String limitOf(String limit) {
    return 'határ $limit';
  }

  @override
  String leftUntil(String left, String time) {
    return 'még $left → $time';
  }

  @override
  String left(String left) {
    return 'még $left';
  }

  @override
  String limitLeft(int hours, String left) {
    return '$hours ó: még $left';
  }

  @override
  String limitLeftUntil(int hours, String left, String time) {
    return '$hours ó: még $left → $time';
  }

  @override
  String limitUntil(int hours, String time) {
    return '$hours ó → $time';
  }

  @override
  String get rowWorkday => 'Munkanap';

  @override
  String get workdayNoShift => 'A műszak nem kezdődött el';

  @override
  String get rowDailyDriving => 'Napi vezetés';

  @override
  String get rowBreak => 'Szünet';

  @override
  String breakTaken(int minutes, String time) {
    return '$minutes perc kivéve $time-kor';
  }

  @override
  String breakStillNeeded(int minutes) {
    return 'még $minutes perc';
  }

  @override
  String get breakNotTaken => 'Még nem volt szünet';

  @override
  String breakResting(String time, int required) {
    return 'Most szünet $time / $required perc';
  }

  @override
  String get rowDailyRest => 'Napi pihenő';

  @override
  String get dailyRestCaption => '11 ó rendes · 9 ó csökkentett';

  @override
  String get dailyRestSplit => '3 + 9';

  @override
  String get rowWeeklyRest => 'Heti pihenő';

  @override
  String get weeklyRestCaption => '45 ó rendes · 24 ó csökkentett';

  @override
  String get chipReducedAvailable => '24 ó lehetséges';

  @override
  String get chipReducedUnavailable => 'csak 45 ó';

  @override
  String get statusNotStarted => 'nem kezdődött el';

  @override
  String statusInProgress(String time) {
    return 'folyamatban $time';
  }

  @override
  String statusBy(String when) {
    return '$when-ig';
  }

  @override
  String get statusNoData => 'nincs adat';

  @override
  String get rowWeeklyDriving => 'Heti vezetés';

  @override
  String get rowFortnightDriving => 'Kétheti vezetés';

  @override
  String get rowWorkWeek => 'Munkahét';

  @override
  String workWeekSince(String since) {
    return '$since óta';
  }

  @override
  String get workWeekUnknown => 'Nincs adat az előző heti pihenőről';

  @override
  String get cardTitle => 'Kártya letöltése';

  @override
  String cardCaption(String last, String due) {
    return 'utoljára $last · határidő $due';
  }

  @override
  String get cardNever => 'Adja meg az utolsó letöltést';

  @override
  String cardSheetLast(String date) {
    return 'Utolsó letöltés: $date';
  }

  @override
  String get cardSheetNever => 'Még nincs megadott letöltés.';

  @override
  String get cardSheetRule =>
      'A járművezetői kártya adatait legalább 28 naponta le kell tölteni (581/2010/EU rendelet).';

  @override
  String get cardMarkToday => 'Ma letöltve';

  @override
  String get cardMarked => 'Letöltés megadva';

  @override
  String get workdayStart => 'A műszak kezdete';

  @override
  String workdayRegular(int hours) {
    return '$hours ó — rendes nap';
  }

  @override
  String workdayRegularHint(String left) {
    return 'utána 11 órás rendes pihenő · még $left';
  }

  @override
  String workdayExtended(int hours) {
    return '$hours ó — meghosszabbított nap';
  }

  @override
  String workdayExtendedHint(int count) {
    return 'utána 9 órás csökkentett pihenő · még ×$count';
  }

  @override
  String get workdayRule =>
      'A napi pihenőnek a műszak kezdetétől számított 24 órán belül véget kell érnie. A 9 órás csökkentett pihenő két heti pihenő között legfeljebb háromszor vehető ki.';

  @override
  String get workdayEndDay => 'Nap lezárása';

  @override
  String get workdayEndDayHint =>
      'A pihenő most kezdődik, és lezárja a műszakot, még ha 9 óránál rövidebb is.';

  @override
  String todayDate(String date) {
    return 'Ma, $date';
  }

  @override
  String infrArticle(String regulation, String article) {
    return 'EU $regulation · $article. cikk';
  }

  @override
  String get infrContinuousExceededTitle => 'Szünet nélküli vezetés túllépve';

  @override
  String infrContinuousExceededText(String limit, String time, int required) {
    return 'Szünet nélküli vezetés $limit fölött $time értékkel. Álljon meg, és tartson $required perc szünetet.';
  }

  @override
  String get infrBreakSoonTitle => 'Hamarosan szünet';

  @override
  String infrBreakSoonText(String limit, String time, int required) {
    return 'A $limit határig $time maradt. $required perces szünet kell.';
  }

  @override
  String get infrDailyDriveExceededTitle => 'Napi vezetési idő túllépve';

  @override
  String infrDailyDriveExceededText(String limit, String time) {
    return '$limit fölött $time értékkel. Kezdje meg a napi pihenőt.';
  }

  @override
  String get infrDailyDriveSoonTitle => 'Fogy a napi vezetési idő';

  @override
  String infrDailyDriveSoonText(String limit, String time) {
    return 'A $limit határig $time maradt.';
  }

  @override
  String get infrExtensionInUseTitle => '10 órás meghosszabbítás folyamatban';

  @override
  String infrExtensionInUseText(int count) {
    return 'A héten megmaradó meghosszabbítások: $count.';
  }

  @override
  String get infrShiftExceededTitle => 'Munkanap túllépve';

  @override
  String infrShiftExceededText(String limit, String time) {
    return 'A műszak $limit fölött $time értékkel. Kezdje meg a napi pihenőt.';
  }

  @override
  String get infrShiftSoonTitle => 'Hamarosan vége a munkanapnak';

  @override
  String infrShiftSoonText(String time) {
    return 'Kezdje meg a napi pihenőt $time múlva.';
  }

  @override
  String get infrWeeklyDriveExceededTitle => 'Heti vezetési idő túllépve';

  @override
  String infrWeeklyDriveExceededText(String limit, String time) {
    return '$limit fölött $time értékkel.';
  }

  @override
  String get infrWeeklyDriveSoonTitle => 'Fogy a heti vezetési idő';

  @override
  String infrWeeklyDriveSoonText(String limit, String time) {
    return '$limit-ig $time maradt.';
  }

  @override
  String get infrFortnightDriveExceededTitle => 'Kétheti vezetési idő túllépve';

  @override
  String infrFortnightDriveExceededText(String limit, String time) {
    return '$limit fölött $time értékkel.';
  }

  @override
  String get infrFortnightDriveSoonTitle => 'Fogy a kétheti vezetési idő';

  @override
  String infrFortnightDriveSoonText(String limit, String time) {
    return '$limit-ig $time maradt.';
  }

  @override
  String get infrWeeklyRestOverdueTitle => 'Heti pihenő késésben';

  @override
  String infrWeeklyRestOverdueText(String time) {
    return 'Az előző heti pihenő óta több mint 144 ó telt el — $time értékkel.';
  }

  @override
  String get infrWeeklyRestSoonTitle => 'Hamarosan heti pihenő';

  @override
  String infrWeeklyRestSoonText(String time) {
    return 'Kezdje meg a heti pihenőt $time múlva.';
  }

  @override
  String get infrWeeklyRestContinueTitle => 'Ne szakítsa meg a pihenőt';

  @override
  String infrWeeklyRestContinueText(String time) {
    return 'A heti pihenő határideje lejárt. Pihenjen még $time, hogy a pihenő hetinek számítson.';
  }

  @override
  String get infrCompensationSoonTitle => 'Közeleg a kiegyenlítés határideje';

  @override
  String infrCompensationSoonText(String time, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days nap',
      one: '$days nap',
    );
    return 'Csatoljon $time időt egy legalább 9 órás pihenőhöz. Határidőig $_temp0.';
  }

  @override
  String get infrCompensationOverdueTitle => 'Kiegyenlítés késésben';

  @override
  String infrCompensationOverdueText(String time, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days nap',
      one: '$days nap',
    );
    return 'A csökkentett heti pihenő miatti $time nem lett csatolva. Késés — $_temp0.';
  }

  @override
  String get infrReducedRestsExceededTitle => 'Túl sok csökkentett pihenő';

  @override
  String infrReducedRestsExceededText(int count) {
    return 'Csökkentett a heti pihenő óta: $count, megengedett 3.';
  }

  @override
  String get infrCardOverdueTitle => 'Kártyaletöltés késésben';

  @override
  String infrCardOverdueText(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days napja',
      one: '$days napja',
    );
    return 'A 28 napos határidő $_temp0 lejárt.';
  }

  @override
  String get infrCardSoonTitle => 'Hamarosan kártyaletöltés';

  @override
  String infrCardSoonText(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days nap',
      one: '$days nap',
    );
    return 'Még $_temp0.';
  }

  @override
  String get ferryTitle => 'Komp / vonat';

  @override
  String get ferryHint =>
      'A pihenő legfeljebb kétszer szakítható meg, összesen legfeljebb 1 órára (9. cikk). A komp mozgása nem kapcsolja be a vezetést.';

  @override
  String get ferryOn => 'komp';

  @override
  String breakHero(String limit) {
    return 'Szünet $limit vezetés után';
  }

  @override
  String breakPartDone(int minutes) {
    return '$minutes perc ✓';
  }

  @override
  String breakPart(int minutes) {
    return '$minutes perc';
  }

  @override
  String breakPartLeft(int minutes) {
    return '$minutes perc — hátravan';
  }

  @override
  String breakFirstTaken(String from, String to) {
    return 'Első rész kivéve $from–$to';
  }

  @override
  String get breakNone => '45 perc egyben vagy 15 + 30 perc szünet kell.';

  @override
  String get breakSplitTitle => 'Megosztott szünet 15 + 30';

  @override
  String get breakSplitText =>
      'Az első rész legalább 15 perc, a második legalább 30 perc, pontosan ebben a sorrendben. Az alkalmazás magától felismeri.';

  @override
  String get breakStart => 'Szünet kezdése';

  @override
  String get breakOngoing => 'Szünet folyamatban';

  @override
  String get weeklyStartBy => 'Legkésőbb kezdje';

  @override
  String weeklyInTime(String left) {
    return '$left múlva — a munkahét vége (144 ó)';
  }

  @override
  String weeklyOverdue(String time) {
    return 'késés $time';
  }

  @override
  String get weeklyOngoing => 'Heti pihenő folyamatban';

  @override
  String get weeklyUnknown =>
      'Nincs adat az előző heti pihenőről. A határidő egy legalább 24 órás pihenő után jelenik meg.';

  @override
  String get weeklyNext => 'Következő pihenő';

  @override
  String get weeklyFull => 'Rendes';

  @override
  String get weeklyFullHint => 'nem a fülkében';

  @override
  String get weeklyReduced => 'Csökkentett';

  @override
  String get weeklyReducedYes => 'lehetséges · kiegyenlítéssel';

  @override
  String get weeklyReducedNo => 'nem lehetséges — rendes kell';

  @override
  String get weeklyHistory => 'Előzmények';

  @override
  String weeklyPrevious(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'full': 'rendes',
      'reduced': 'csökkentett',
      'other': 'elégtelen',
    });
    return 'Előző · $_temp0';
  }

  @override
  String get weeklyNow => 'most';

  @override
  String get weeklyCompensation => 'Kiegyenlítési tartozás';

  @override
  String get weeklyCompensationNone => 'nincs';

  @override
  String weeklyCompensationValue(String time, String date) {
    return '$time $date-ig';
  }

  @override
  String get weeklyMobilityOn =>
      'Mobilitási csomag bekapcsolva: nemzetközi fuvarozásban két csökkentett pihenő vehető ki egymás után, ha a nyilvántartás szerinti országon kívül esnek. A csökkentést a harmadik hét végéig kell kiegyenlíteni.';

  @override
  String get weeklyMobilityOff =>
      'A csökkentett heti pihenőt a harmadik hét végéig kell kiegyenlíteni: a tartozást egy legalább 9 órás pihenőhöz kell csatolni.';

  @override
  String get weeklyStartRest => 'Pihenő kezdése';

  @override
  String get countryTitle => 'Ország kiválasztása';

  @override
  String countryChip(String start, String end) {
    return 'Kezdő ország $start, záró $end. Módosítás';
  }

  @override
  String countryChipNoEnd(String start) {
    return 'Kezdő ország $start, záró nincs kiválasztva. Módosítás';
  }

  @override
  String get countryChipNone =>
      'Nincs kiválasztva a műszak országa. Kiválasztás';

  @override
  String countryStartTab(String code) {
    return 'Kezdés · $code';
  }

  @override
  String countryEndTab(String code) {
    return 'Befejezés · $code';
  }

  @override
  String get countryNextShift => 'A következő műszak országa';

  @override
  String get countrySearch => 'Ország vagy kód';

  @override
  String get countryRecent => 'Legutóbbiak';

  @override
  String get countryClearEnd => 'Nem adom meg';

  @override
  String get countryNotFound => 'Nincs találat';

  @override
  String get countryFooter =>
      'A műszak kezdő és záró országát a járművezető viszi be a menetíróba (165/2014/EU rendelet, 34. cikk).';

  @override
  String countryName(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'A': 'Ausztria',
      'AL': 'Albánia',
      'AND': 'Andorra',
      'ARM': 'Örményország',
      'AZ': 'Azerbajdzsán',
      'B': 'Belgium',
      'BG': 'Bulgária',
      'BIH': 'Bosznia-Hercegovina',
      'BY': 'Fehéroroszország',
      'CH': 'Svájc',
      'CY': 'Ciprus',
      'CZ': 'Csehország',
      'D': 'Németország',
      'DK': 'Dánia',
      'E': 'Spanyolország',
      'EST': 'Észtország',
      'F': 'Franciaország',
      'FIN': 'Finnország',
      'FL': 'Liechtenstein',
      'GE': 'Grúzia',
      'GR': 'Görögország',
      'H': 'Magyarország',
      'HR': 'Horvátország',
      'I': 'Olaszország',
      'IRL': 'Írország',
      'IS': 'Izland',
      'KZ': 'Kazahsztán',
      'L': 'Luxemburg',
      'LT': 'Litvánia',
      'LV': 'Lettország',
      'M': 'Málta',
      'MC': 'Monaco',
      'MD': 'Moldova',
      'MK': 'Észak-Macedónia',
      'MNE': 'Montenegró',
      'N': 'Norvégia',
      'NL': 'Hollandia',
      'P': 'Portugália',
      'PL': 'Lengyelország',
      'RO': 'Románia',
      'RSM': 'San Marino',
      'RUS': 'Oroszország',
      'S': 'Svédország',
      'SK': 'Szlovákia',
      'SLO': 'Szlovénia',
      'SRB': 'Szerbia',
      'TJ': 'Tádzsikisztán',
      'TM': 'Türkmenisztán',
      'TR': 'Törökország',
      'UA': 'Ukrajna',
      'UK': 'Egyesült Királyság',
      'UZ': 'Üzbegisztán',
      'V': 'Vatikán',
      'other': '$code',
    });
    return '$_temp0';
  }

  @override
  String get journalExport => 'Jelentés exportálása';

  @override
  String get journalCurrent => 'aktuális';

  @override
  String get journalDriving => 'Vezetés';

  @override
  String get journalFortnight => '2 hét alatt';

  @override
  String journalOf(int limit) {
    return 'max. $limit';
  }

  @override
  String get journalCollapsedDriving => 'vezetés';

  @override
  String journalWeekSpoken(String range, String driving, String fortnight) {
    return '$range hét. Vezetés $driving / 56 ó, két hét alatt $fortnight / 90 ó';
  }

  @override
  String get journalShift => 'Műszak';

  @override
  String get journalWeeklyShort => 'heti';

  @override
  String get journalOngoing => 'folyamatban';

  @override
  String get journalManual => 'kézi';

  @override
  String get journalAddShift => 'Műszak';

  @override
  String get journalAddShiftSpoken => 'Műszak hozzáadása';

  @override
  String get journalEmpty =>
      'Még nincsenek műszakok. Akkor jelennek meg, amikor elkezdi váltani a módokat — vagy adjon hozzá műszakot kézzel.';

  @override
  String restStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'full': 'rendes',
      'reduced': 'csökkentett',
      'other': 'elégtelen',
    });
    return '$_temp0';
  }

  @override
  String journalWeeklyRest(String status) {
    return 'Heti pihenő · $status';
  }

  @override
  String journalShiftSpoken(
    String date,
    String route,
    String time,
    String driving,
    String span,
    String rest,
  ) {
    return '$date, $route, $time. Vezetés $driving, műszak $span, pihenő $rest';
  }

  @override
  String get journalRestNone => 'nincs';

  @override
  String get journalRestWeekly => 'heti';

  @override
  String get journalLoadError =>
      'A naplót nem sikerült megnyitni. Indítsa újra az alkalmazást — ha nem segít, írjon nekünk az „Egyebek” menüben.';

  @override
  String get dayTitle => 'Műszak';

  @override
  String get daySummary => 'Összesítés';

  @override
  String get dayModes => 'Módok';

  @override
  String get dayBreaks => 'Szünetek';

  @override
  String get dayContinuousAtEnd => 'Szünet nélkül a műszak végén';

  @override
  String get dayRestAfter => 'Pihenő a műszak után';

  @override
  String dayRestKind(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'daily': 'Napi',
      'weekly': 'Heti',
      'other': 'Nem kezdődött el',
    });
    return '$_temp0';
  }

  @override
  String get daySplitRest => 'megosztott 3 + 9';

  @override
  String get dayManualHint =>
      'A műszakot kézzel, összegként vitték be — módbejegyzések nincsenek.';

  @override
  String get dayNotes => 'Megjegyzések';

  @override
  String get dayEndMark => 'nap vége';

  @override
  String get dayEdit => 'Műszak szerkesztése';

  @override
  String get dayNotFound => 'Ez a műszak már nincs a naplóban.';

  @override
  String dayRestUntil(String time) {
    return '$time-ig';
  }

  @override
  String get save => 'Mentés';

  @override
  String get cancel => 'Mégse';

  @override
  String get done => 'Kész';

  @override
  String get delete => 'Törlés';

  @override
  String get unitHours => 'ó';

  @override
  String get unitMinutes => 'perc';

  @override
  String get pickerHours => 'Óra';

  @override
  String get pickerMinutes => 'Perc';

  @override
  String get pickerTime => 'Időpont';

  @override
  String get pickerPrevMonth => 'Előző hónap';

  @override
  String get pickerNextMonth => 'Következő hónap';

  @override
  String pickerRange(String min, String max) {
    return 'Lehetséges: $min – $max';
  }

  @override
  String get shiftNewTitle => 'Új műszak';

  @override
  String get shiftSection => 'Műszak';

  @override
  String get shiftStart => 'Kezdés';

  @override
  String get shiftEnd => 'Befejezés';

  @override
  String get shiftOnRoad => 'úton';

  @override
  String get shiftChoose => 'Kiválasztás';

  @override
  String get shiftNowOngoing => 'Most (folyamatban)';

  @override
  String get shiftDuration => 'Időtartam';

  @override
  String get shiftNowSuffix => 'most';

  @override
  String shiftCountrySpoken(String side, String code) {
    return '$side: $code ország. Módosítás';
  }

  @override
  String shiftDateSpoken(String side, String date, String time) {
    return '$side: $date, $time. Módosítás';
  }

  @override
  String get shiftDriving => 'Vezetés';

  @override
  String get shiftPerDay => 'Napi';

  @override
  String get shiftLiveContinuous => 'a szünetekből számolva';

  @override
  String get shiftRestNone => 'Nem kezdődött el';

  @override
  String get shiftRestDaily => 'Napi';

  @override
  String get shiftRestWeekly => 'Heti';

  @override
  String get shiftSplit => 'Megosztott pihenő 3 + 9';

  @override
  String get shiftSplitHint => 'Előbb 3 ó, aztán 9 ó';

  @override
  String shiftRestUntilNext(String when) {
    return 'A műszak kezdetéig: $when';
  }

  @override
  String get shiftRestAutoHint => 'A következő műszak kezdetéig tart';

  @override
  String get shiftRestCountsWeekly => '24 órától a pihenő hetinek számít';

  @override
  String get shiftNotesHint => 'Például: komp, rakodásra várakozás';

  @override
  String get shiftDelete => 'Műszak törlése';

  @override
  String get shiftDeleteTitle => 'Törli a műszakot?';

  @override
  String get shiftDeleteManual => 'A műszak törlődik a naplóból.';

  @override
  String get shiftDeleteRecorded =>
      'A műszak összes módbejegyzése törlődik. Ez nem vonható vissza.';

  @override
  String get shiftErrStartCountry => 'Válassza ki a műszak kezdő országát';

  @override
  String get shiftErrEndCountry => 'Adja meg a műszak záró országát';

  @override
  String get shiftErrEndBeforeStart => 'A műszak vége korábbi, mint a kezdete';

  @override
  String get shiftErrFuture => 'A műszak ideje nem lehet a jövőben';

  @override
  String get shiftErrTooLong =>
      '30 óránál hosszabb műszak — ellenőrizze a dátumokat';

  @override
  String get shiftErrDrivingTooLong => 'A vezetés hosszabb, mint a műszak';

  @override
  String get shiftErrContinuous =>
      'A szünet nélküli vezetés hosszabb, mint a napi';

  @override
  String shiftErrOverlap(String range) {
    return 'Átfedésben van ezzel a műszakkal: $range';
  }

  @override
  String get shiftErrNotLast =>
      'E műszak után vannak még mások — most nem lehet folyamatban';

  @override
  String get shiftSaveFailed => 'Nem sikerült menteni. Próbálja újra.';

  @override
  String get shiftSavedViolations => 'Műszak mentve. Vannak szabálysértések';

  @override
  String get shiftSavedViolationsText =>
      'Ellenőrizze az időpontokat. Ha minden stimmel, a szabálysértések megjelennek a naplóban és a jelentésben.';

  @override
  String get gotIt => 'Értem';

  @override
  String get shiftLiveHint =>
      'A műszak a módbejegyzéseket követi: a kezdés, a befejezés vagy a vezetés módosítása magukat a bejegyzéseket tolja el.';

  @override
  String get shiftConvertHint =>
      'Az idő, a vezetés vagy a pihenő módosult — a műszak kézi bejegyzésként mentődik a módbejegyzések helyett.';

  @override
  String shiftEndNowHint(String time) {
    return 'A műszak $time-kor ér véget, utána pihenő kezdődik.';
  }

  @override
  String get shiftResumeHint =>
      'A műszak utáni pihenő törlődik — a műszak folytatódik.';

  @override
  String shiftOngoingHint(String time, String mode) {
    return 'A műszak lesz az aktuális, és a kezdőképernyőn folytatódik $time-tól. „$mode” mód — ha most más érvényes, ott váltsa át.';
  }

  @override
  String get shiftUnsavedTitle => 'Menti a módosításokat?';

  @override
  String get shiftUnsavedText => 'A műszak módosításai még nincsenek mentve.';

  @override
  String get shiftDiscard => 'Nem mentem';

  @override
  String get shiftDateTimeTitle => 'A műszak dátuma és ideje';

  @override
  String driveEditSubtitle(String date) {
    return 'Kézi javítás · $date';
  }

  @override
  String get driveEditComputed => 'Az alkalmazás számítása';

  @override
  String driveEditDiff(String diff) {
    return '$diff a számításhoz képest.';
  }

  @override
  String get driveEditNoChange => 'Az idő nem változott.';

  @override
  String get driveEditHint =>
      'Használja, ha a módot rossz pillanatban váltotta — a határok újraszámolódnak.';

  @override
  String get driveEditNoDrive =>
      'Az aktuális műszakban még nem volt vezetés — nincs mit javítani.';

  @override
  String get breakCorrection => 'Javítás';

  @override
  String get breakCurrentDuration => 'Aktuális szünet';

  @override
  String get breakLastDuration => 'Utolsó szünet';

  @override
  String get breakNoBreak =>
      'A műszakban még nem volt szünet — nincs mit javítani.';

  @override
  String get breakEditHint =>
      'Az idő a szomszédos bejegyzésből jön — a határok újraszámolódnak.';

  @override
  String get workdayChangeStart => 'Műszakkezdés módosítása';

  @override
  String get weeklyAddManually => 'Megadás kézzel';

  @override
  String get exportPeriod => 'Időszak';

  @override
  String get exportWeek => 'Ez a hét';

  @override
  String get exportTwoWeeks => '2 hét';

  @override
  String get exportDays28 => '28 nap';

  @override
  String get exportCustom => 'Egyéni időszak';

  @override
  String get exportFrom => 'Ettől';

  @override
  String get exportTo => 'Eddig';

  @override
  String exportFromDay(String date) {
    return 'Ettől: $date';
  }

  @override
  String exportToDay(String date) {
    return 'Eddig: $date';
  }

  @override
  String get exportFormat => 'Formátum';

  @override
  String get exportPdf => 'PDF · ellenőrzéshez';

  @override
  String get exportCsv => 'CSV · táblázat';

  @override
  String get exportPdfHint =>
      'Nem hivatalos dokumentum: a jelentés nem helyettesíti a menetíró és a járművezetői kártya adatait.';

  @override
  String get exportCsvHint =>
      'Módbejegyzések soronként, idő UTC-ben — Excelhez és nyilvántartó programokhoz.';

  @override
  String get exportLanguage => 'A jelentés nyelve';

  @override
  String get exportNotes => 'Országok és megjegyzések';

  @override
  String get exportCreate => 'Jelentés készítése';

  @override
  String exportCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count műszak',
      one: '$count műszak',
    );
    return '$_temp0 a jelentésben';
  }

  @override
  String get exportEmpty => 'A kiválasztott időszakban nincs műszak.';

  @override
  String get exportFailed =>
      'Nem sikerült elkészíteni a jelentést. Próbálja újra.';

  @override
  String exportRangeSpoken(String from, String to) {
    return 'Időszak: $from – $to';
  }

  @override
  String get reportTitle => 'Jelentés a vezetési és pihenőidőkről';

  @override
  String get reportSubtitle => '561/2006/EK rendelet és AETR-megállapodás';

  @override
  String get reportDriver => 'Járművezető';

  @override
  String get reportCard => 'Járművezetői kártya';

  @override
  String get reportVehicle => 'Rendszám';

  @override
  String get reportCompany => 'Fuvarozó';

  @override
  String get reportPeriod => 'Időszak';

  @override
  String get reportGenerated => 'Készült';

  @override
  String reportTimezone(String zone) {
    return 'Időpontok a telefon időzónája szerint ($zone). A jelentés napjai és hetei UTC szerint, a hét hétfőn 00:00-kor kezdődik, mint a menetíróban.';
  }

  @override
  String get reportDate => 'Dátum';

  @override
  String get reportStart => 'Kezdés';

  @override
  String get reportEnd => 'Befejezés';

  @override
  String get reportCountries => 'Országok';

  @override
  String get reportDriving => 'Vezetés';

  @override
  String get reportWork => 'Munka';

  @override
  String get reportAvailability => 'Rend. áll.';

  @override
  String get reportBreaks => 'Szünetek';

  @override
  String get reportSpan => 'Műszak';

  @override
  String get reportRestAfter => 'Pihenő utána';

  @override
  String get reportNotes => 'Megjegyzések';

  @override
  String reportWeek(String range) {
    return '$range hét';
  }

  @override
  String reportWeekTotal(String driving, String fortnight) {
    return 'Összesen: vezetés $driving / 56 ó · 2 hét alatt $fortnight / 90 ó';
  }

  @override
  String get reportViolations => 'Szabálysértések';

  @override
  String get reportNoViolations => 'A napló szerint nincs szabálysértés.';

  @override
  String reportViolationDrive(String date, String time) {
    return '$date: napi vezetés $time — több mint 10 ó';
  }

  @override
  String reportViolationSpan(String date, String time, int limit) {
    return '$date: munkanap $time — több mint $limit ó';
  }

  @override
  String reportViolationRest(String date, String time) {
    return '$date: pihenő a műszak után $time — elégtelen';
  }

  @override
  String reportViolationWeek(String range, String time) {
    return '$range hét: vezetés $time — több mint 56 ó';
  }

  @override
  String reportViolationFortnight(String range, String time) {
    return '$range hét: két hét alatt $time — több mint 90 ó';
  }

  @override
  String get reportMarks => 'Jelölések';

  @override
  String get reportMarkWarn =>
      '! — 10 órára meghosszabbított vezetés, 13 óránál hosszabb munkanap vagy csökkentett pihenő';

  @override
  String get reportMarkBad => '!! — szabálysértés';

  @override
  String get reportMarkManual => '* — kézzel, összegként bevitt műszak';

  @override
  String get reportDisclaimer =>
      'A jelentés a járművezető TachoGo alkalmazásban tett bejegyzésein alapul. Nem hivatalos dokumentum: nem helyettesíti a menetíró és a járművezetői kártya adatait.';

  @override
  String get reportSignature => 'A járművezető aláírása';

  @override
  String reportPage(int page, int pages) {
    return '$page. oldal / $pages';
  }

  @override
  String get openSystemSettings => 'Beállítások megnyitása';

  @override
  String get settingsGeneral => 'Általános';

  @override
  String get settingsLanguage => 'Nyelv';

  @override
  String get settingsLanguageSystem => 'Mint a telefonon';

  @override
  String get settingsTheme => 'Megjelenés';

  @override
  String get themeSystem => 'Rendszer';

  @override
  String get themeLight => 'Világos';

  @override
  String get themeDark => 'Sötét';

  @override
  String get settingsRules => 'Szabályok';

  @override
  String get settingsTachograph => 'Menetíró a járműben';

  @override
  String get tachographDigital => 'Digitális';

  @override
  String get tachographAnalog => 'Analóg';

  @override
  String get settingsMobility => 'Mobilitási csomag';

  @override
  String get settingsMobilityHint =>
      'Két csökkentett heti pihenő egymás után nemzetközi fuvarozásban';

  @override
  String get settingsCrew => 'Kétfős személyzet';

  @override
  String get settingsCrewHint =>
      '9 órás napi pihenő a műszak kezdetétől számított 30 órán belül';

  @override
  String get settingsNotifications => 'Értesítések';

  @override
  String get settingsWarnLead => 'Figyelmeztetés a határokra';

  @override
  String get settingsWarnLeadHint => 'Szünet, nap vége, vezetés';

  @override
  String get settingsWarnLeadGroup => 'Előre figyelmeztessen';

  @override
  String leadMinutes(int minutes) {
    return '$minutes perc';
  }

  @override
  String leadHours(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours óra',
      one: '$hours óra',
    );
    return '$_temp0';
  }

  @override
  String get notifyBreak => 'Szünet';

  @override
  String get notifyShiftEnd => 'A munkanap vége';

  @override
  String get notifyShiftEndHint => 'Napi és heti pihenő';

  @override
  String get notifyDriving => 'Vezetési határ';

  @override
  String get notifyCard => 'Kártya letöltése';

  @override
  String get notifyCardHint => '28 naponta';

  @override
  String get notifyCardLead => 'Előre';

  @override
  String get notifyCardLeadGroup =>
      'Előzetes figyelmeztetés a kártyaletöltésre';

  @override
  String leadDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days nap',
      one: '$days nap',
    );
    return '$_temp0';
  }

  @override
  String get notifyAllow => 'Értesítések engedélyezése';

  @override
  String get notifyDenied => 'Az értesítések most le vannak tiltva a telefonon';

  @override
  String get notifyAllowed => 'Értesítések engedélyezve';

  @override
  String get notifyExact => 'Pontos értesítési idő';

  @override
  String get notifyExactHint =>
      'Engedélyezze az „Ébresztők és emlékeztetők” lehetőséget — különben a telefon késleltetheti a figyelmeztetést';

  @override
  String get notifyChannelLimits => 'Határok és szabálysértések';

  @override
  String get notifyChannelLimitsHint =>
      'Szünet, munkanap vége, vezetés, heti pihenő, kártya';

  @override
  String get notifyChannelRest => 'Pihenő beszámítva';

  @override
  String get notifyChannelRestHint =>
      'Szünet beszámítva, napi és heti pihenő beszámítva';

  @override
  String get notifyBreakTakenTitle => 'Szünet beszámítva';

  @override
  String notifyBreakTakenText(int required, String time) {
    return 'A $required perces szünet beszámítva. A következő szünetig $time vezethet.';
  }

  @override
  String get notifyDailyRestTakenTitle => 'Napi pihenő beszámítva';

  @override
  String notifyDailyRestTakenText(String limit) {
    return '$limit rendes pihenő — kezdheti a műszakot.';
  }

  @override
  String get notifyWeeklyRestTakenTitle => 'Heti pihenő beszámítva';

  @override
  String notifyWeeklyRestTakenText(String limit) {
    return '$limit rendes pihenő — kezdheti az új munkahetet.';
  }

  @override
  String get serviceChannel => 'Vezetés automatikus felismerése';

  @override
  String get serviceChannelHint =>
      'Aktuális mód és számlálók, amíg az automatikus felismerés működik';

  @override
  String get serviceStarted => 'A vezetés automatikus felismerése bekapcsolva';

  @override
  String serviceModeTitle(String mode, String time) {
    return '$mode · $time';
  }

  @override
  String get serviceTeamTitle => 'A jármű halad';

  @override
  String serviceTeamText(String time) {
    return 'Ön vezet? Vezetés $time óta';
  }

  @override
  String get serviceSuggestTitle => 'Úgy tűnik, vezet';

  @override
  String serviceSuggestText(String time) {
    return 'Kezdi a vezetést $time-tól? A pihenő megszakad';
  }

  @override
  String serviceDriving(String untilBreak, String dayLeft) {
    return 'Szünetig $untilBreak · ma még $dayLeft';
  }

  @override
  String serviceDrivingOver(String time) {
    return 'Szünet kell: túllépés $time';
  }

  @override
  String serviceBreakLeft(String time) {
    return 'A teljes szünetig $time';
  }

  @override
  String serviceBreakDone(String time) {
    return 'Szünet beszámítva, vezethet $time';
  }

  @override
  String serviceWorkday(String time, String limit) {
    return 'Munkanap $time / $limit';
  }

  @override
  String serviceRestLeft(String limit, String time) {
    return 'A teljes $limit pihenőig: $time';
  }

  @override
  String get serviceDailyRestDone => 'Rendes napi pihenő beszámítva';

  @override
  String get serviceWeeklyRestDone => 'Rendes heti pihenő beszámítva';

  @override
  String get serviceNotStartedText =>
      'A vezetés magától bekapcsol, amikor a jármű elindul';

  @override
  String get serviceNoModeText => 'Nyissa meg a TachoGo-t, és válasszon módot';

  @override
  String get autoTitle => 'Vezetés automatikus felismerése';

  @override
  String get autoSwitch => 'Vezetés felismerése GPS alapján';

  @override
  String get autoSwitchHint =>
      'Elindul — vezetés, megáll — egyéb munka. Csak a sebesség kell: a koordináták nem mentődnek.';

  @override
  String get autoAfterStop => 'Megállás után';

  @override
  String get autoAfterStopHint => '3 perc állás után';

  @override
  String get autoStartFromRest => 'Vezetés közvetlenül pihenő után';

  @override
  String get autoStartFromRestHint =>
      'Különben az alkalmazás előbb rákérdez: lehet, hogy utasként utazott';

  @override
  String get autoBattery => 'Akkumulátorkímélés';

  @override
  String get autoBatteryLimited =>
      'Leállíthatja a felismerést. Vegye ki a TachoGo-t a kímélési listából';

  @override
  String get autoBatteryOk => 'Nem zavarja a háttérben futást';

  @override
  String get autoAutostart => 'Automatikus indítás és háttérfutás';

  @override
  String get autoAutostartHint =>
      'Xiaomi, Huawei, Honor, Oppo, Vivo, Samsung: engedélyezze, különben a telefon leállítja a felismerést';

  @override
  String get autoBlockedService =>
      'A helymeghatározás ki van kapcsolva a telefonon. Kapcsolja be a vezetés felismeréséhez.';

  @override
  String get autoBlockedDenied =>
      'Helyhozzáférés nélkül a vezetés nem ismerhető fel. Az alkalmazásnak csak a sebesség kell, a koordináták nem mentődnek.';

  @override
  String get autoBlockedForever =>
      'A helyhozzáférés le van tiltva. Engedélyezze a telefon beállításaiban: Hely → „Az alkalmazás használata közben”.';

  @override
  String get autoNoAccess =>
      'Nincs helyhozzáférés — a felismerés nem működik. Engedélyezze a telefon beállításaiban.';

  @override
  String get autoEnable => 'Vezetésfelismerés bekapcsolása';

  @override
  String get autoEnabled => 'Vezetésfelismerés bekapcsolva';

  @override
  String get settingsData => 'Adatok';

  @override
  String get settingsExport => 'Jelentés exportálása';

  @override
  String get settingsExportFormats => 'PDF · CSV';

  @override
  String get settingsAnalytics => 'Névtelen statisztika';

  @override
  String get settingsAnalyticsHint =>
      'Mely képernyőket nyitják meg a járművezetők — az alkalmazás fejlesztéséhez. Koordináták, nevek és kártyaszámok nélkül.';

  @override
  String get settingsClear => 'Minden adat törlése';

  @override
  String get clearTitle => 'Törli az összes adatot?';

  @override
  String get clearText =>
      'Törlődik a módnapló, a műszakok, az országok, a megjegyzések és a kártyaletöltések. Ez nem vonható vissza. A beállítások megmaradnak.';

  @override
  String get clearConfirm => 'Törlés';

  @override
  String get clearDone => 'Adatok törölve';

  @override
  String onbStep(int step, int count) {
    return '$step. lépés / $count';
  }

  @override
  String get onbWelcomeTitle => 'A volán mögött töltött idő kézben';

  @override
  String get onbWelcomeText =>
      'Az EU 561/2006 és az AETR szabályai szerint számoljuk a vezetést, a szüneteket és a pihenőt, és előre figyelmeztetünk a határokra.';

  @override
  String get onbStart => 'Kezdés';

  @override
  String get onbNext => 'Tovább';

  @override
  String get onbDone => 'Kész';

  @override
  String get onbModesTitle => 'Négy mód — mint a menetíróban';

  @override
  String get onbModesText =>
      'A módot a kezdőképernyő gombjaival váltsa. A számlálók maguktól futnak — bezárt alkalmazás mellett is.';

  @override
  String get onbModeDriving =>
      'Volánnál. Számoljuk a szünet nélküli, napi és heti vezetést.';

  @override
  String get onbModeWork => 'Rakodás, jármű ellenőrzése, iratok.';

  @override
  String get onbModeAvailability =>
      'Várakozás: sor a rakodásnál, határ, második járművezető úton.';

  @override
  String get onbModeRest =>
      'Szünetek és pihenő. A „Nap lezárása” lezárja a műszakot.';

  @override
  String get onbSetupTitle => 'Beállítjuk Önnek';

  @override
  String get onbSetupText => 'Mindez később módosítható a beállításokban.';

  @override
  String get onbMobilityHint => 'Kapcsolja be, ha nemzetközi járatokon vezet';

  @override
  String onbNotifyText(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes perccel',
      one: '$minutes perccel',
    );
    return '$_temp0 a szünet és a munkanap vége előtt figyelmeztetünk — bezárt alkalmazás mellett is.';
  }

  @override
  String get onbAutoText =>
      'Elindul — az alkalmazás vezetést kapcsol, megáll — egyéb munkát. Pihenő után előbb rákérdez. Csak a GPS-sebesség kell: a koordináták nem mentődnek és nem kerülnek elküldésre.';

  @override
  String get onbAutoLater => 'Később bekapcsolható a beállításokban.';

  @override
  String languageButton(String language) {
    return 'Nyelv: $language';
  }

  @override
  String get settingsVehicle => 'Jármű';

  @override
  String get vehicleTruckOrBus => 'Teherautó vagy busz';

  @override
  String get vehicleVan => 'Kisteherautó 2,5–3,5 t';

  @override
  String settingsVanHint(String date) {
    return 'Szabályok — $date-tól nemzetközi fuvarozásban és bérelt vagy díjazás ellenében végzett kabotázsban';
  }

  @override
  String onbVanText(String date) {
    return 'Az EU kisteherautókra vonatkozó szabályai $date-tól érvényesek — nemzetközi fuvarozásban és bérelt vagy díjazás ellenében végzett kabotázsban. A kisteherautóban második generációs intelligens menetíró van, a járművezetőnek kártyája van.';
  }

  @override
  String get onbRulesTitle => 'A legfontosabb szabályok';

  @override
  String get onbRulesText =>
      'Ugyanazok teherautóra, buszra és kisteherautóra. Az alkalmazás maga számolja őket, és előre figyelmeztet.';

  @override
  String get onbRulesMore =>
      'Minden szabály magyarázattal — „Egyebek” → „Útmutató és szabályok”.';

  @override
  String get guideTitle => 'Útmutató és szabályok';

  @override
  String get guideHowTo => 'Használat';

  @override
  String get guideStep1 =>
      'A módot a kezdőképernyő gombjaival váltsa: vezetés, pihenő, munka vagy rendelkezésre állás.';

  @override
  String get guideStep2 =>
      'Adja meg a műszak kezdő és záró országát — mint a menetíróban.';

  @override
  String get guideStep3 =>
      'Figyelje a határokat. Az alkalmazás előre figyelmeztet a szünetre és a nap végére. Bármely idő kézzel javítható.';

  @override
  String get guideRules => 'Az EU 561/2006 és az AETR szabályai';

  @override
  String get guideContinuous => 'Vezetés szünet nélkül';

  @override
  String guideContinuousText(String full, String first, String second) {
    return 'Utána $full szünet. Megosztható: előbb $first, aztán $second.';
  }

  @override
  String get guideDailyDriving => 'Napi vezetés';

  @override
  String guideDailyDrivingText(String extended) {
    return 'Hetente kétszer legfeljebb $extended megengedett.';
  }

  @override
  String get guideWeeklyDriving => 'Heti vezetés';

  @override
  String guideWeeklyDrivingText(String fortnight) {
    return 'Bármely két egymást követő héten — legfeljebb $fortnight.';
  }

  @override
  String get guideDailyRest => 'Napi pihenő';

  @override
  String guideDailyRestText(String reduced, String first, String second) {
    return 'Két heti pihenő között legfeljebb háromszor $reduced időre csökkenthető. Megosztott változat — $first + $second.';
  }

  @override
  String get guideWorkday => 'Munkanap';

  @override
  String guideWorkdayText(String window, String regular, String reduced) {
    return 'A pihenőnek a műszak kezdetétől számított $window belül véget kell érnie: rendes pihenővel $regular, csökkentettel $reduced.';
  }

  @override
  String guideWorkdaySpoken(int first, int second) {
    String _temp0 = intl.Intl.pluralLogic(
      second,
      locale: localeName,
      other: '$second óra',
      one: '$second óra',
    );
    return '$first vagy $_temp0';
  }

  @override
  String get guideWeeklyRest => 'Heti pihenő';

  @override
  String guideWeeklyRestText(String reduced) {
    return 'Csökkentett — $reduced, kiegyenlítéssel a harmadik hét végéig. A rendes pihenő nem tölthető a fülkében.';
  }

  @override
  String get guideWorkWeek => 'Munkahét';

  @override
  String guideWorkWeekText(String period) {
    return 'A heti pihenő legkésőbb hat $period időszak után kezdődik az előzőtől számítva.';
  }

  @override
  String get guideCard => 'Járművezetői kártya';

  @override
  String guideCardText(String days) {
    return 'A kártya adatait legalább $days időnként le kell tölteni.';
  }

  @override
  String get guideModes => 'Színek és ikonok';

  @override
  String get guideNewbie => 'Először menetíróval';

  @override
  String get guideNewbieCard => 'A kártya az egész műszakban a menetíróban van';

  @override
  String get guideNewbieCardText =>
      'A kártyát a műszak elején helyezze be, és a végén vegye ki. Amit kártya nélkül csinált — munka, rendelkezésre állás vagy pihenő —, a következő behelyezéskor vigye be kézzel.';

  @override
  String get guideNewbieApp => 'Az alkalmazás nem helyettesíti a menetírót';

  @override
  String get guideNewbieAppText =>
      'A hivatalos rögzítés a menetíróban van. A módot ott is, itt is váltsa — így a számlálók egyezni fognak.';

  @override
  String get guideNewbieBreak => 'A szünet csak pihenő';

  @override
  String get guideNewbieBreakText =>
      'Szünet alatt nem szabad vezetni és dolgozni. A rakodás és a kirakodás egyéb munka, nem szünet.';

  @override
  String get guideNewbieRestPlace => 'Hol pihenjen';

  @override
  String get guideNewbieRestPlaceText =>
      'A napi és a csökkentett heti pihenő a járműben is tölthető, ha van benne fekhely, és áll. A rendes heti pihenő és a kiegyenlítés — csak a járművön kívül.';

  @override
  String get guideNewbieCountry => 'Országok';

  @override
  String get guideNewbieCountryText =>
      'Az országot a műszak elején és végén kell bevinni a menetíróba. A határátlépést a második generációs intelligens menetíró magától rögzíti, a régebbieknél az országot a határ utáni első megállóban kell bevinni.';

  @override
  String guideVanText(String date) {
    return 'A szabályok ugyanazok, mint a teherautókra. $date-tól a pótkocsival együtt 2,5 t-nál nehezebb kisteherautókra vonatkoznak — nemzetközi árufuvarozásban és kabotázsban. Az ilyen kisteherautóban második generációs intelligens menetíró van, a járművezetőnek kártyája van.';
  }

  @override
  String get guideVanCheck => 'Vonatkoznak-e a szabályok az útjára';

  @override
  String get guideVanTrip => 'Út';

  @override
  String get guideVanTripHint =>
      'Kabotázs — fuvarozás egy másik EU-országon belül';

  @override
  String get guideVanDomestic => 'Belföldi';

  @override
  String get guideVanCrossBorder => 'Külföldre vagy kabotázs';

  @override
  String get guideVanCarriage => 'Fuvarozás';

  @override
  String get guideVanHire => 'Bérelt vagy díjazás ellenében';

  @override
  String get guideVanOwn => 'Saját számlás';

  @override
  String get guideVanNonCommercial => 'Nem kereskedelmi';

  @override
  String get guideVanCarriageHint =>
      'Saját számlás — a cége áruja, anyaga vagy szerszáma. Nem kereskedelmi — fizetés és bevétel nélkül, a munkához nem kapcsolódik';

  @override
  String get guideVanMain => 'A vezetés a fő munkája?';

  @override
  String get yes => 'Igen';

  @override
  String get no => 'Nem';

  @override
  String get guideVanApplies => 'A szabályok vonatkoznak';

  @override
  String get guideVanNotApply => 'A szabályok nem vonatkoznak';

  @override
  String get guideVanAppliesText =>
      'Menetíró és járművezetői kártya kell, a határok olyanok, mint a teherautónál.';

  @override
  String guideVanNotYetText(String date) {
    return '$date-ig a kisteherautókra nem vonatkoztak a szabályok.';
  }

  @override
  String get guideVanDomesticText =>
      'Az uniós rendelet nem vonatkozik a belföldi fuvarozást végző kisteherautókra. Nézze meg az országa szabályait.';

  @override
  String get guideVanOwnText =>
      'Kivétel: saját célú fuvarozás, és a vezetés nem a fő munka.';

  @override
  String get guideVanNonCommercialText =>
      'Kivétel: fizetés és bevétel nélküli, a munkához nem kapcsolódó fuvarozás.';

  @override
  String guideArticle(String article) {
    return '561/2006 rendelet, $article. cikk';
  }

  @override
  String get guideVanNotes =>
      'A pótkocsival együtt 3,5 t-nál nehezebb — a szabályok olyanok, mint a teherautónál, belföldön is. Részben az EU-n kívüli út — Ukrajnába, Moldovába, Törökországba, a Balkánra — kérdezze meg a fuvarozót: egységes értelmezés nincs.';

  @override
  String get guideDisclaimer =>
      'A TachoGo segít az idő tervezésében, de nem helyettesíti a menetírót, és nem jogi tanácsadás. A szabályok hivatalos szövege — 561/2006/EK rendelet és AETR-megállapodás.';

  @override
  String get moreAbout => 'Az alkalmazásról';

  @override
  String get moreDisclaimer =>
      'A TachoGo segít a vezetési és pihenőidők tervezésében, de nem helyettesíti a menetírót, és nem jogi tanácsadás.';

  @override
  String get problemTitle => 'Probléma jelentése';

  @override
  String get problemHint =>
      'Béta verzió: a jelentés az alkalmazás fejlesztőihez kerül';

  @override
  String get problemText =>
      'A jelentés tartalmazza az alkalmazás verzióját, a telefon típusát, a beállításokat, az engedélyeket, az értesítések ütemezését és az utolsó két nap naplóbejegyzéseit. Koordinátákat nem tartalmaz. Válassza ki, hová küldi — e-mailbe vagy üzenetküldőbe —, és írja le, mi történt.';

  @override
  String get problemSend => 'Küldés';

  @override
  String get problemSubject => 'TachoGo — probléma a béta verzióban';

  @override
  String get problemPrompt => 'Mi történt és mikor (saját szavaival):';

  @override
  String get problemFailed =>
      'Nem sikerült megnyitni a küldést. Próbálja újra.';
}
