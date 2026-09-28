// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Lithuanian (`lt`).
class AppLocalizationsLt extends AppLocalizations {
  AppLocalizationsLt([String locale = 'lt']) : super(locale);

  @override
  String get appTitle => 'TachoGo';

  @override
  String get navHome => 'Pradžia';

  @override
  String get navJournal => 'Žurnalas';

  @override
  String get navSettings => 'Nustatymai';

  @override
  String get navMore => 'Daugiau';

  @override
  String get close => 'Uždaryti';

  @override
  String get back => 'Atgal';

  @override
  String ofLimit(String limit) {
    return 'iš $limit';
  }

  @override
  String get premiumLock => 'Galima su Premium';

  @override
  String hoursShort(int hours) {
    return '$hours val.';
  }

  @override
  String daysShort(int days) {
    return '$days d.';
  }

  @override
  String spokenHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count valandų',
      many: '$count valandos',
      few: '$count valandos',
      one: '$count valanda',
    );
    return '$_temp0';
  }

  @override
  String spokenMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minučių',
      many: '$count minutės',
      few: '$count minutės',
      one: '$count minutė',
    );
    return '$_temp0';
  }

  @override
  String spokenOverrun(String duration) {
    return 'viršyta $duration';
  }

  @override
  String get modeDriving => 'Vairavimas';

  @override
  String get modeRest => 'Poilsis';

  @override
  String get modeWork => 'Darbas';

  @override
  String get modeWorkFull => 'Kitas darbas';

  @override
  String get modeAvailability => 'Budėjimas';

  @override
  String get modeNone => 'Režimas nepasirinktas';

  @override
  String modeSince(String time) {
    return 'nuo $time';
  }

  @override
  String get switchFailed => 'Režimas neišsaugotas. Bandykite dar kartą.';

  @override
  String homeShiftSince(String date, String time) {
    return '$date · pamaina nuo $time';
  }

  @override
  String homeNoShift(String date) {
    return '$date · pamaina nepradėta';
  }

  @override
  String get homeLoadError =>
      'Nepavyko atidaryti žurnalo. Paleiskite programėlę iš naujo — jei nepadės, parašykite mums per „Daugiau“.';

  @override
  String get heroUntilBreak => 'Iki pertraukos';

  @override
  String get heroBreak => 'Pertrauka';

  @override
  String get heroDailyRest => 'Kasdienis poilsis';

  @override
  String get heroWeeklyRest => 'Savaitės poilsis';

  @override
  String heroContinuousOf(String time, String limit) {
    return 'be pertraukos $time iš $limit';
  }

  @override
  String get heroOffDutyHint =>
      'Pamaina baigta. Kita prasidės nuo pirmo režimo, kuris nėra poilsis.';

  @override
  String get bannerBreakNeeded45 =>
      'Reikia 45 min pertraukos (arba padalytos 15 + 30)';

  @override
  String get bannerBreakNeeded30 =>
      'Reikia 30 min pertraukos — antroji padalytos 15 + 30 dalis';

  @override
  String bannerOnBreak(String time, int required) {
    return 'Pertrauka $time iš $required min';
  }

  @override
  String bannerBreakCounted(String limit) {
    return 'Pertrauka įskaityta — galite vairuoti $limit';
  }

  @override
  String get sectionAlerts => 'Įspėjimai';

  @override
  String get sectionToday => 'Šiandien';

  @override
  String get sectionRest => 'Poilsis';

  @override
  String get sectionWeek => 'Savaitė';

  @override
  String get rowContinuous => 'Vairavimas be pertraukos';

  @override
  String get chipBreakSoon => 'netrukus pertrauka';

  @override
  String get chipExceeded => 'viršyta';

  @override
  String get chipLimiting => 'riboja';

  @override
  String get chipShiftSoon => 'netrukus pabaiga';

  @override
  String get chipLimitSoon => 'netrukus riba';

  @override
  String get chipRestSoon => 'netrukus poilsis';

  @override
  String chipTimes(int hours, int count) {
    return '$hours val. ×$count';
  }

  @override
  String limitOf(String limit) {
    return 'riba $limit';
  }

  @override
  String leftUntil(String left, String time) {
    return 'liko $left → $time';
  }

  @override
  String left(String left) {
    return 'liko $left';
  }

  @override
  String limitLeft(int hours, String left) {
    return '$hours val.: liko $left';
  }

  @override
  String limitLeftUntil(int hours, String left, String time) {
    return '$hours val.: liko $left → $time';
  }

  @override
  String limitUntil(int hours, String time) {
    return '$hours val. → $time';
  }

  @override
  String get rowWorkday => 'Darbo diena';

  @override
  String get workdayNoShift => 'Pamaina nepradėta';

  @override
  String get rowDailyDriving => 'Dienos vairavimas';

  @override
  String get rowBreak => 'Pertrauka';

  @override
  String breakTaken(int minutes, String time) {
    return 'Išnaudota $minutes min $time';
  }

  @override
  String breakStillNeeded(int minutes) {
    return 'dar $minutes min';
  }

  @override
  String get breakNotTaken => 'Pertraukos dar nebuvo';

  @override
  String breakResting(String time, int required) {
    return 'Dabar pertrauka $time iš $required min';
  }

  @override
  String get rowDailyRest => 'Kasdienis poilsis';

  @override
  String get dailyRestCaption => '11 val. įprastinis · 9 val. sutrumpintas';

  @override
  String get dailyRestSplit => '3 + 9';

  @override
  String get rowWeeklyRest => 'Savaitės poilsis';

  @override
  String get weeklyRestCaption => '45 val. įprastinis · 24 val. sutrumpintas';

  @override
  String get chipReducedAvailable => '24 val. galima';

  @override
  String get chipReducedUnavailable => 'tik 45 val.';

  @override
  String get statusNotStarted => 'nepradėtas';

  @override
  String statusInProgress(String time) {
    return 'vyksta $time';
  }

  @override
  String statusBy(String when) {
    return 'iki $when';
  }

  @override
  String get statusNoData => 'nėra duomenų';

  @override
  String get rowWeeklyDriving => 'Savaitės vairavimas';

  @override
  String get rowFortnightDriving => 'Vairavimas per dvi savaites';

  @override
  String get rowWorkWeek => 'Darbo savaitė';

  @override
  String workWeekSince(String since) {
    return 'nuo $since';
  }

  @override
  String get workWeekUnknown => 'Nėra duomenų apie ankstesnį savaitės poilsį';

  @override
  String get cardTitle => 'Kortelės nuskaitymas';

  @override
  String cardCaption(String last, String due) {
    return 'paskutinis $last · iki $due';
  }

  @override
  String get cardNever => 'Pažymėkite paskutinį nuskaitymą';

  @override
  String cardSheetLast(String date) {
    return 'Paskutinis nuskaitymas: $date';
  }

  @override
  String get cardSheetNever => 'Nuskaitymas dar nepažymėtas.';

  @override
  String get cardSheetRule =>
      'Vairuotojo kortelės duomenis reikia atsisiųsti bent kas 28 dienas (Reglamentas (ES) Nr. 581/2010).';

  @override
  String get cardMarkToday => 'Nuskaityta šiandien';

  @override
  String get cardMarked => 'Nuskaitymas pažymėtas';

  @override
  String get workdayStart => 'Pamainos pradžia';

  @override
  String workdayRegular(int hours) {
    return '$hours val. — įprasta diena';
  }

  @override
  String workdayRegularHint(String left) {
    return 'po to įprastinis 11 val. poilsis · liko $left';
  }

  @override
  String workdayExtended(int hours) {
    return '$hours val. — pailginta diena';
  }

  @override
  String workdayExtendedHint(int count) {
    return 'po to sutrumpintas 9 val. poilsis · liko ×$count';
  }

  @override
  String get workdayRule =>
      'Kasdienis poilsis turi baigtis per 24 valandas nuo pamainos pradžios. Sutrumpintas 9 val. poilsis leidžiamas ne daugiau kaip tris kartus tarp dviejų savaitės poilsių.';

  @override
  String get workdayEndDay => 'Baigti dieną';

  @override
  String get workdayEndDayHint =>
      'Poilsis prasidės dabar ir užbaigs pamainą, net jei bus trumpesnis nei 9 val.';

  @override
  String todayDate(String date) {
    return 'Šiandien, $date';
  }

  @override
  String infrArticle(String regulation, String article) {
    return 'ES $regulation · $article str.';
  }

  @override
  String get infrContinuousExceededTitle => 'Viršytas vairavimas be pertraukos';

  @override
  String infrContinuousExceededText(String limit, String time, int required) {
    return 'Vairavimas be pertraukos ilgesnis nei $limit $time. Sustokite ir padarykite $required min pertrauką.';
  }

  @override
  String get infrBreakSoonTitle => 'Netrukus pertrauka';

  @override
  String infrBreakSoonText(String limit, String time, int required) {
    return 'Iki $limit ribos liko $time. Reikia $required min pertraukos.';
  }

  @override
  String get infrDailyDriveExceededTitle => 'Viršytas dienos vairavimo laikas';

  @override
  String infrDailyDriveExceededText(String limit, String time) {
    return 'Daugiau nei $limit $time. Pradėkite kasdienį poilsį.';
  }

  @override
  String get infrDailyDriveSoonTitle => 'Baigiasi dienos vairavimo laikas';

  @override
  String infrDailyDriveSoonText(String limit, String time) {
    return 'Iki $limit ribos liko $time.';
  }

  @override
  String get infrExtensionInUseTitle => 'Vyksta pailginimas iki 10 val.';

  @override
  String infrExtensionInUseText(int count) {
    return 'Liko pailginimų šią savaitę: $count.';
  }

  @override
  String get infrShiftExceededTitle => 'Viršyta darbo diena';

  @override
  String infrShiftExceededText(String limit, String time) {
    return 'Pamaina ilgesnė nei $limit $time. Pradėkite kasdienį poilsį.';
  }

  @override
  String get infrShiftSoonTitle => 'Netrukus darbo dienos pabaiga';

  @override
  String infrShiftSoonText(String time) {
    return 'Pradėkite kasdienį poilsį po $time.';
  }

  @override
  String get infrWeeklyDriveExceededTitle =>
      'Viršytas savaitės vairavimo laikas';

  @override
  String infrWeeklyDriveExceededText(String limit, String time) {
    return 'Daugiau nei $limit $time.';
  }

  @override
  String get infrWeeklyDriveSoonTitle => 'Baigiasi savaitės vairavimo laikas';

  @override
  String infrWeeklyDriveSoonText(String limit, String time) {
    return 'Iki $limit liko $time.';
  }

  @override
  String get infrFortnightDriveExceededTitle =>
      'Viršytas vairavimas per dvi savaites';

  @override
  String infrFortnightDriveExceededText(String limit, String time) {
    return 'Daugiau nei $limit $time.';
  }

  @override
  String get infrFortnightDriveSoonTitle =>
      'Baigiasi vairavimas per dvi savaites';

  @override
  String infrFortnightDriveSoonText(String limit, String time) {
    return 'Iki $limit liko $time.';
  }

  @override
  String get infrWeeklyRestOverdueTitle => 'Savaitės poilsis vėluoja';

  @override
  String infrWeeklyRestOverdueText(String time) {
    return 'Nuo ankstesnio savaitės poilsio praėjo daugiau nei 144 val. — $time.';
  }

  @override
  String get infrWeeklyRestSoonTitle => 'Netrukus savaitės poilsis';

  @override
  String infrWeeklyRestSoonText(String time) {
    return 'Pradėkite savaitės poilsį po $time.';
  }

  @override
  String get infrWeeklyRestContinueTitle => 'Nenutraukite poilsio';

  @override
  String infrWeeklyRestContinueText(String time) {
    return 'Savaitės poilsio terminas praėjo. Ilsėkitės dar $time, kad poilsis būtų įskaitytas kaip savaitės.';
  }

  @override
  String get infrCompensationSoonTitle => 'Artėja kompensacijos terminas';

  @override
  String infrCompensationSoonText(String time, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dienų',
      many: '$days dienos',
      few: '$days dienos',
      one: '$days diena',
    );
    return 'Pridėkite $time prie bent 9 val. poilsio. Iki termino liko $_temp0.';
  }

  @override
  String get infrCompensationOverdueTitle => 'Kompensacija vėluoja';

  @override
  String infrCompensationOverdueText(String time, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dienų',
      many: '$days dienos',
      few: '$days dienos',
      one: '$days diena',
    );
    return 'Už sutrumpintą savaitės poilsį nepridėta $time. Vėluojama — $_temp0.';
  }

  @override
  String get infrReducedRestsExceededTitle => 'Per daug sutrumpintų poilsių';

  @override
  String infrReducedRestsExceededText(int count) {
    return 'Sutrumpintų nuo savaitės poilsio: $count, leidžiama 3.';
  }

  @override
  String get infrCardOverdueTitle => 'Kortelės nuskaitymas vėluoja';

  @override
  String infrCardOverdueText(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dienų',
      many: '$days dienos',
      few: '$days dienas',
      one: '$days dieną',
    );
    return '28 dienų terminas praėjo prieš $_temp0.';
  }

  @override
  String get infrCardSoonTitle => 'Netrukus kortelės nuskaitymas';

  @override
  String infrCardSoonText(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dienų',
      many: '$days dienos',
      few: '$days dienos',
      one: '$days diena',
    );
    return 'Liko $_temp0.';
  }

  @override
  String get ferryTitle => 'Keltas / traukinys';

  @override
  String get ferryHint =>
      'Poilsį galima nutraukti ne daugiau kaip du kartus, iš viso iki 1 val. (9 str.). Kelto judėjimas neįjungia vairavimo.';

  @override
  String get ferryOn => 'keltas';

  @override
  String breakHero(String limit) {
    return 'Pertrauka po $limit vairavimo';
  }

  @override
  String breakPartDone(int minutes) {
    return '$minutes min ✓';
  }

  @override
  String breakPart(int minutes) {
    return '$minutes min';
  }

  @override
  String breakPartLeft(int minutes) {
    return '$minutes min — liko';
  }

  @override
  String breakFirstTaken(String from, String to) {
    return 'Pirma dalis išnaudota $from–$to';
  }

  @override
  String get breakNone => 'Reikia 45 min pertraukos iš karto arba 15 + 30 min.';

  @override
  String get breakSplitTitle => 'Padalyta pertrauka 15 + 30';

  @override
  String get breakSplitText =>
      'Pirma dalis ne trumpesnė nei 15 min, antra — ne trumpesnė nei 30 min, būtent tokia tvarka. Programėlė ją atpažįsta pati.';

  @override
  String get breakStart => 'Pradėti pertrauką';

  @override
  String get breakOngoing => 'Pertrauka vyksta';

  @override
  String get weeklyStartBy => 'Pradėkite ne vėliau kaip';

  @override
  String weeklyInTime(String left) {
    return 'po $left — darbo savaitės pabaiga (144 val.)';
  }

  @override
  String weeklyOverdue(String time) {
    return 'vėluojama $time';
  }

  @override
  String get weeklyOngoing => 'Savaitės poilsis vyksta';

  @override
  String get weeklyUnknown =>
      'Nėra duomenų apie ankstesnį savaitės poilsį. Terminas atsiras po bent 24 val. poilsio.';

  @override
  String get weeklyNext => 'Kitas poilsis';

  @override
  String get weeklyFull => 'Įprastinis';

  @override
  String get weeklyFullHint => 'ne kabinoje';

  @override
  String get weeklyReduced => 'Sutrumpintas';

  @override
  String get weeklyReducedYes => 'galimas · su kompensacija';

  @override
  String get weeklyReducedNo => 'negalimas — reikia įprastinio';

  @override
  String get weeklyHistory => 'Istorija';

  @override
  String weeklyPrevious(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'full': 'įprastinis',
      'reduced': 'sutrumpintas',
      'other': 'nepakankamas',
    });
    return 'Ankstesnis · $_temp0';
  }

  @override
  String get weeklyNow => 'dabar';

  @override
  String get weeklyCompensation => 'Kompensacijos skola';

  @override
  String get weeklyCompensationNone => 'nėra';

  @override
  String weeklyCompensationValue(String time, String date) {
    return '$time iki $date';
  }

  @override
  String get weeklyMobilityOn =>
      'Mobilumo paketas įjungtas: tarptautiniame vežime leidžiami du sutrumpinti poilsiai iš eilės, jei jie vyksta ne registracijos valstybėje. Sutrumpinimas kompensuojamas iki trečios savaitės pabaigos.';

  @override
  String get weeklyMobilityOff =>
      'Sutrumpintas savaitės poilsis kompensuojamas iki trečios savaitės pabaigos: skola pridedama prie bent 9 val. poilsio.';

  @override
  String get weeklyStartRest => 'Pradėti poilsį';

  @override
  String get countryTitle => 'Šalies pasirinkimas';

  @override
  String countryChip(String start, String end) {
    return 'Pradžios šalis $start, pabaigos $end. Keisti';
  }

  @override
  String countryChipNoEnd(String start) {
    return 'Pradžios šalis $start, pabaigos nepasirinkta. Keisti';
  }

  @override
  String get countryChipNone => 'Pamainos šalis nepasirinkta. Pasirinkti';

  @override
  String countryStartTab(String code) {
    return 'Pradžia · $code';
  }

  @override
  String countryEndTab(String code) {
    return 'Pabaiga · $code';
  }

  @override
  String get countryNextShift => 'Kitos pamainos šalis';

  @override
  String get countrySearch => 'Šalis arba kodas';

  @override
  String get countryRecent => 'Neseniai';

  @override
  String get countryClearEnd => 'Nenurodyti';

  @override
  String get countryNotFound => 'Nieko nerasta';

  @override
  String get countryFooter =>
      'Pamainos pradžios ir pabaigos šalį vairuotojas įveda į tachografą (Reglamentas (ES) Nr. 165/2014, 34 str.).';

  @override
  String countryName(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'A': 'Austrija',
      'AL': 'Albanija',
      'AND': 'Andora',
      'ARM': 'Armėnija',
      'AZ': 'Azerbaidžanas',
      'B': 'Belgija',
      'BG': 'Bulgarija',
      'BIH': 'Bosnija ir Hercegovina',
      'BY': 'Baltarusija',
      'CH': 'Šveicarija',
      'CY': 'Kipras',
      'CZ': 'Čekija',
      'D': 'Vokietija',
      'DK': 'Danija',
      'E': 'Ispanija',
      'EST': 'Estija',
      'F': 'Prancūzija',
      'FIN': 'Suomija',
      'FL': 'Lichtenšteinas',
      'GE': 'Sakartvelas',
      'GR': 'Graikija',
      'H': 'Vengrija',
      'HR': 'Kroatija',
      'I': 'Italija',
      'IRL': 'Airija',
      'IS': 'Islandija',
      'KZ': 'Kazachstanas',
      'L': 'Liuksemburgas',
      'LT': 'Lietuva',
      'LV': 'Latvija',
      'M': 'Malta',
      'MC': 'Monakas',
      'MD': 'Moldova',
      'MK': 'Šiaurės Makedonija',
      'MNE': 'Juodkalnija',
      'N': 'Norvegija',
      'NL': 'Nyderlandai',
      'P': 'Portugalija',
      'PL': 'Lenkija',
      'RO': 'Rumunija',
      'RSM': 'San Marinas',
      'RUS': 'Rusija',
      'S': 'Švedija',
      'SK': 'Slovakija',
      'SLO': 'Slovėnija',
      'SRB': 'Serbija',
      'TJ': 'Tadžikistanas',
      'TM': 'Turkmėnistanas',
      'TR': 'Turkija',
      'UA': 'Ukraina',
      'UK': 'Jungtinė Karalystė',
      'UZ': 'Uzbekistanas',
      'V': 'Vatikanas',
      'other': '$code',
    });
    return '$_temp0';
  }

  @override
  String get journalExport => 'Ataskaitos eksportas';

  @override
  String get journalCurrent => 'dabartinė';

  @override
  String get journalDriving => 'Vairavimas';

  @override
  String get journalFortnight => 'Per 2 sav.';

  @override
  String journalOf(int limit) {
    return 'iš $limit';
  }

  @override
  String get journalCollapsedDriving => 'vairavimas';

  @override
  String journalWeekSpoken(String range, String driving, String fortnight) {
    return 'Savaitė $range. Vairavimas $driving iš 56 val., per dvi savaites $fortnight iš 90 val.';
  }

  @override
  String get journalShift => 'Pamaina';

  @override
  String get journalWeeklyShort => 'sav.';

  @override
  String get journalOngoing => 'vyksta';

  @override
  String get journalManual => 'rankiniu būdu';

  @override
  String get journalAddShift => 'Pamaina';

  @override
  String get journalAddShiftSpoken => 'Pridėti pamainą';

  @override
  String get journalEmpty =>
      'Pamainų dar nėra. Jos atsiras, kai pradėsite perjungti režimus, — arba pridėkite pamainą rankiniu būdu.';

  @override
  String restStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'full': 'įprastinis',
      'reduced': 'sutrumpintas',
      'other': 'nepakankamas',
    });
    return '$_temp0';
  }

  @override
  String journalWeeklyRest(String status) {
    return 'Savaitės poilsis · $status';
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
    return '$date, $route, $time. Vairavimas $driving, pamaina $span, poilsis $rest';
  }

  @override
  String get journalRestNone => 'nėra';

  @override
  String get journalRestWeekly => 'savaitės';

  @override
  String get journalLoadError =>
      'Nepavyko atidaryti žurnalo. Paleiskite programėlę iš naujo — jei nepadės, parašykite mums per „Daugiau“.';

  @override
  String get dayTitle => 'Pamaina';

  @override
  String get daySummary => 'Suvestinė';

  @override
  String get dayModes => 'Režimai';

  @override
  String get dayBreaks => 'Pertraukos';

  @override
  String get dayContinuousAtEnd => 'Be pertraukos pamainos pabaigoje';

  @override
  String get dayRestAfter => 'Poilsis po pamainos';

  @override
  String dayRestKind(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'daily': 'Kasdienis',
      'weekly': 'Savaitės',
      'other': 'Nepradėtas',
    });
    return '$_temp0';
  }

  @override
  String get daySplitRest => 'padalytas 3 + 9';

  @override
  String get dayManualHint =>
      'Pamaina įvesta rankiniu būdu kaip suma — režimų įrašų nėra.';

  @override
  String get dayNotes => 'Pastabos';

  @override
  String get dayEndMark => 'dienos pabaiga';

  @override
  String get dayEdit => 'Redaguoti pamainą';

  @override
  String get dayNotFound => 'Šios pamainos žurnale nebėra.';

  @override
  String dayRestUntil(String time) {
    return 'iki $time';
  }

  @override
  String get save => 'Išsaugoti';

  @override
  String get cancel => 'Atšaukti';

  @override
  String get done => 'Atlikta';

  @override
  String get delete => 'Ištrinti';

  @override
  String get unitHours => 'val.';

  @override
  String get unitMinutes => 'min';

  @override
  String get pickerHours => 'Valandos';

  @override
  String get pickerMinutes => 'Minutės';

  @override
  String get pickerTime => 'Laikas';

  @override
  String get pickerPrevMonth => 'Ankstesnis mėnuo';

  @override
  String get pickerNextMonth => 'Kitas mėnuo';

  @override
  String pickerRange(String min, String max) {
    return 'Galima nuo $min iki $max';
  }

  @override
  String get shiftNewTitle => 'Nauja pamaina';

  @override
  String get shiftSection => 'Pamaina';

  @override
  String get shiftStart => 'Pradžia';

  @override
  String get shiftEnd => 'Pabaiga';

  @override
  String get shiftOnRoad => 'kelyje';

  @override
  String get shiftChoose => 'Pasirinkti';

  @override
  String get shiftNowOngoing => 'Dabar (vyksta)';

  @override
  String get shiftDuration => 'Trukmė';

  @override
  String get shiftNowSuffix => 'dabar';

  @override
  String shiftCountrySpoken(String side, String code) {
    return '$side: šalis $code. Keisti';
  }

  @override
  String shiftDateSpoken(String side, String date, String time) {
    return '$side: $date, $time. Keisti';
  }

  @override
  String get shiftDriving => 'Vairavimas';

  @override
  String get shiftPerDay => 'Per dieną';

  @override
  String get shiftLiveContinuous => 'skaičiuojama pagal pertraukas';

  @override
  String get shiftRestNone => 'Nepradėtas';

  @override
  String get shiftRestDaily => 'Kasdienis';

  @override
  String get shiftRestWeekly => 'Savaitės';

  @override
  String get shiftSplit => 'Padalytas poilsis 3 + 9';

  @override
  String get shiftSplitHint => 'Pirma 3 val., paskui 9 val.';

  @override
  String shiftRestUntilNext(String when) {
    return 'Iki pamainos pradžios: $when';
  }

  @override
  String get shiftRestAutoHint => 'Trunka iki kitos pamainos pradžios';

  @override
  String get shiftRestCountsWeekly => 'Nuo 24 val. poilsis laikomas savaitės';

  @override
  String get shiftNotesHint => 'Pavyzdžiui: keltas, pakrovimo laukimas';

  @override
  String get shiftDelete => 'Ištrinti pamainą';

  @override
  String get shiftDeleteTitle => 'Ištrinti pamainą?';

  @override
  String get shiftDeleteManual => 'Pamaina bus ištrinta iš žurnalo.';

  @override
  String get shiftDeleteRecorded =>
      'Bus ištrinti visi šios pamainos režimų įrašai. To atšaukti negalima.';

  @override
  String get shiftErrStartCountry => 'Pasirinkite pamainos pradžios šalį';

  @override
  String get shiftErrEndCountry => 'Nurodykite pamainos pabaigos šalį';

  @override
  String get shiftErrEndBeforeStart => 'Pamainos pabaiga ankstesnė nei pradžia';

  @override
  String get shiftErrFuture => 'Pamainos laikas negali būti ateityje';

  @override
  String get shiftErrTooLong =>
      'Pamaina ilgesnė nei 30 val. — patikrinkite datas';

  @override
  String get shiftErrDrivingTooLong => 'Vairavimas ilgesnis nei pamaina';

  @override
  String get shiftErrContinuous =>
      'Vairavimas be pertraukos ilgesnis nei dienos';

  @override
  String shiftErrOverlap(String range) {
    return 'Sutampa su pamaina $range';
  }

  @override
  String get shiftErrNotLast =>
      'Po šios pamainos yra kitų — ji negali vykti dabar';

  @override
  String get shiftSaveFailed => 'Nepavyko išsaugoti. Bandykite dar kartą.';

  @override
  String get shiftSavedViolations => 'Pamaina išsaugota. Yra pažeidimų';

  @override
  String get shiftSavedViolationsText =>
      'Patikrinkite laiką. Jei viskas teisinga, pažeidimai atsiras žurnale ir ataskaitoje.';

  @override
  String get gotIt => 'Supratau';

  @override
  String get shiftLiveHint =>
      'Pamaina seka režimų įrašus: pakeitus pradžią, pabaigą ar vairavimą, pasislinks patys įrašai.';

  @override
  String get shiftConvertHint =>
      'Pakeistas laikas, vairavimas ar poilsis — pamaina bus išsaugota kaip rankinis įrašas vietoje režimų įrašų.';

  @override
  String shiftEndNowHint(String time) {
    return 'Pamaina baigsis $time, paskui prasidės poilsis.';
  }

  @override
  String get shiftResumeHint =>
      'Poilsis po pamainos bus ištrintas — pamaina tęsis.';

  @override
  String shiftOngoingHint(String time, String mode) {
    return 'Pamaina taps dabartine ir tęsis pradžios ekrane nuo $time. Režimas „$mode“ — jei dabar kitas, perjunkite jį ten.';
  }

  @override
  String get shiftUnsavedTitle => 'Išsaugoti pakeitimus?';

  @override
  String get shiftUnsavedText => 'Šios pamainos pakeitimai dar neišsaugoti.';

  @override
  String get shiftDiscard => 'Neišsaugoti';

  @override
  String get shiftDateTimeTitle => 'Pamainos data ir laikas';

  @override
  String driveEditSubtitle(String date) {
    return 'Rankinis taisymas · $date';
  }

  @override
  String get driveEditComputed => 'Apskaičiavo programėlė';

  @override
  String driveEditDiff(String diff) {
    return '$diff palyginti su apskaičiavimu.';
  }

  @override
  String get driveEditNoChange => 'Laikas nepakitęs.';

  @override
  String get driveEditHint =>
      'Naudokite, jei režimas perjungtas netinkamu metu — ribos bus perskaičiuotos.';

  @override
  String get driveEditNoDrive =>
      'Dabartinėje pamainoje dar nėra vairavimo — nėra ko taisyti.';

  @override
  String get breakCorrection => 'Taisymas';

  @override
  String get breakCurrentDuration => 'Dabartinė pertrauka';

  @override
  String get breakLastDuration => 'Paskutinė pertrauka';

  @override
  String get breakNoBreak => 'Pamainoje dar nėra pertraukos — nėra ko taisyti.';

  @override
  String get breakEditHint =>
      'Laikas paimamas iš gretimo įrašo — ribos bus perskaičiuotos.';

  @override
  String get workdayChangeStart => 'Keisti pamainos pradžią';

  @override
  String get weeklyAddManually => 'Įvesti rankiniu būdu';

  @override
  String get exportPeriod => 'Laikotarpis';

  @override
  String get exportWeek => 'Ši savaitė';

  @override
  String get exportTwoWeeks => '2 savaitės';

  @override
  String get exportDays28 => '28 dienos';

  @override
  String get exportCustom => 'Savas laikotarpis';

  @override
  String get exportFrom => 'Nuo';

  @override
  String get exportTo => 'Iki';

  @override
  String exportFromDay(String date) {
    return 'Nuo $date';
  }

  @override
  String exportToDay(String date) {
    return 'Iki $date';
  }

  @override
  String get exportFormat => 'Formatas';

  @override
  String get exportPdf => 'PDF · patikrinimui';

  @override
  String get exportCsv => 'CSV · lentelė';

  @override
  String get exportPdfHint =>
      'Tai nėra oficialus įrašas: ataskaita nepakeičia tachografo ir vairuotojo kortelės duomenų.';

  @override
  String get exportCsvHint =>
      'Režimų įrašai eilutėmis, laikas pagal UTC — Excel ir apskaitos programoms.';

  @override
  String get exportLanguage => 'Ataskaitos kalba';

  @override
  String get exportNotes => 'Šalys ir pastabos';

  @override
  String get exportCreate => 'Sukurti ataskaitą';

  @override
  String exportCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pamainų',
      many: '$count pamainos',
      few: '$count pamainos',
      one: '$count pamaina',
    );
    return '$_temp0 ataskaitoje';
  }

  @override
  String get exportEmpty => 'Pasirinktame laikotarpyje pamainų nėra.';

  @override
  String get exportFailed =>
      'Nepavyko sukurti ataskaitos. Bandykite dar kartą.';

  @override
  String exportRangeSpoken(String from, String to) {
    return 'Laikotarpis nuo $from iki $to';
  }

  @override
  String get reportTitle => 'Vairavimo ir poilsio laiko ataskaita';

  @override
  String get reportSubtitle =>
      'Reglamentas (EB) Nr. 561/2006 ir AETR susitarimas';

  @override
  String get reportDriver => 'Vairuotojas';

  @override
  String get reportCard => 'Vairuotojo kortelė';

  @override
  String get reportVehicle => 'Valst. numeris';

  @override
  String get reportCompany => 'Vežėjas';

  @override
  String get reportPeriod => 'Laikotarpis';

  @override
  String get reportGenerated => 'Sukurta';

  @override
  String reportTimezone(String zone) {
    return 'Laikas pagal telefono laiko juostą ($zone). Ataskaitos dienos ir savaitės pagal UTC, savaitė prasideda pirmadienį 00:00, kaip tachografe.';
  }

  @override
  String get reportDate => 'Data';

  @override
  String get reportStart => 'Pradžia';

  @override
  String get reportEnd => 'Pabaiga';

  @override
  String get reportCountries => 'Šalys';

  @override
  String get reportDriving => 'Vairavimas';

  @override
  String get reportWork => 'Darbas';

  @override
  String get reportAvailability => 'Budėj.';

  @override
  String get reportBreaks => 'Pertraukos';

  @override
  String get reportSpan => 'Pamaina';

  @override
  String get reportRestAfter => 'Poilsis po';

  @override
  String get reportNotes => 'Pastabos';

  @override
  String reportWeek(String range) {
    return 'Savaitė $range';
  }

  @override
  String reportWeekTotal(String driving, String fortnight) {
    return 'Iš viso: vairavimas $driving iš 56 val. · per 2 savaites $fortnight iš 90 val.';
  }

  @override
  String get reportViolations => 'Pažeidimai';

  @override
  String get reportNoViolations => 'Pagal žurnalą pažeidimų nėra.';

  @override
  String reportViolationDrive(String date, String time) {
    return '$date: dienos vairavimas $time — daugiau nei 10 val.';
  }

  @override
  String reportViolationSpan(String date, String time, int limit) {
    return '$date: darbo diena $time — daugiau nei $limit val.';
  }

  @override
  String reportViolationRest(String date, String time) {
    return '$date: poilsis po pamainos $time — nepakankamas';
  }

  @override
  String reportViolationWeek(String range, String time) {
    return 'Savaitė $range: vairavimas $time — daugiau nei 56 val.';
  }

  @override
  String reportViolationFortnight(String range, String time) {
    return 'Savaitė $range: per dvi savaites $time — daugiau nei 90 val.';
  }

  @override
  String get reportMarks => 'Žymėjimai';

  @override
  String get reportMarkWarn =>
      '! — vairavimas pailgintas iki 10 val., darbo diena ilgesnė nei 13 val. arba sutrumpintas poilsis';

  @override
  String get reportMarkBad => '!! — pažeidimas';

  @override
  String get reportMarkManual => '* — pamaina įvesta rankiniu būdu kaip suma';

  @override
  String get reportDisclaimer =>
      'Ataskaita sudaryta pagal vairuotojo įrašus programėlėje TachoGo. Tai nėra oficialus įrašas: ji nepakeičia tachografo ir vairuotojo kortelės duomenų.';

  @override
  String get reportSignature => 'Vairuotojo parašas';

  @override
  String reportPage(int page, int pages) {
    return '$page psl. iš $pages';
  }

  @override
  String get openSystemSettings => 'Atidaryti nustatymus';

  @override
  String get settingsGeneral => 'Bendrieji';

  @override
  String get settingsLanguage => 'Kalba';

  @override
  String get settingsLanguageSystem => 'Kaip telefone';

  @override
  String get settingsTheme => 'Išvaizda';

  @override
  String get themeSystem => 'Sistemos';

  @override
  String get themeLight => 'Šviesi';

  @override
  String get themeDark => 'Tamsi';

  @override
  String get settingsRules => 'Taisyklės';

  @override
  String get settingsTachograph => 'Tachografas transporto priemonėje';

  @override
  String get tachographDigital => 'Skaitmeninis';

  @override
  String get tachographAnalog => 'Analoginis';

  @override
  String get settingsMobility => 'Mobilumo paketas';

  @override
  String get settingsMobilityHint =>
      'Du sutrumpinti savaitės poilsiai iš eilės tarptautiniame vežime';

  @override
  String get settingsCrew => 'Dviejų vairuotojų įgula';

  @override
  String get settingsCrewHint =>
      'Kasdienis 9 val. poilsis per 30 val. nuo pamainos pradžios';

  @override
  String get settingsNotifications => 'Pranešimai';

  @override
  String get settingsWarnLead => 'Įspėti apie ribas';

  @override
  String get settingsWarnLeadHint => 'Pertrauka, dienos pabaiga, vairavimas';

  @override
  String get settingsWarnLeadGroup => 'Įspėti iš anksto';

  @override
  String leadMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String leadHours(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours valandų',
      many: '$hours valandos',
      few: '$hours valandos',
      one: '$hours valanda',
    );
    return '$_temp0';
  }

  @override
  String get notifyBreak => 'Pertrauka';

  @override
  String get notifyShiftEnd => 'Darbo dienos pabaiga';

  @override
  String get notifyShiftEndHint => 'Kasdienis ir savaitės poilsis';

  @override
  String get notifyDriving => 'Vairavimo riba';

  @override
  String get notifyCard => 'Kortelės nuskaitymas';

  @override
  String get notifyCardHint => 'Kas 28 dienas';

  @override
  String get notifyCardLead => 'Iš anksto';

  @override
  String get notifyCardLeadGroup =>
      'Įspėjimas apie kortelės nuskaitymą iš anksto';

  @override
  String leadDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dienų',
      many: '$days dienos',
      few: '$days dienos',
      one: '$days diena',
    );
    return '$_temp0';
  }

  @override
  String get notifyAllow => 'Leisti pranešimus';

  @override
  String get notifyDenied => 'Pranešimai telefone dabar užblokuoti';

  @override
  String get notifyAllowed => 'Pranešimai leidžiami';

  @override
  String get notifyExact => 'Tikslus pranešimų laikas';

  @override
  String get notifyExactHint =>
      'Leiskite „Žadintuvai ir priminimai“ — kitaip telefonas gali įspėjimą uždelsti';

  @override
  String get notifyChannelLimits => 'Ribos ir pažeidimai';

  @override
  String get notifyChannelLimitsHint =>
      'Pertrauka, darbo dienos pabaiga, vairavimas, savaitės poilsis, kortelė';

  @override
  String get notifyChannelRest => 'Poilsis įskaitytas';

  @override
  String get notifyChannelRestHint =>
      'Pertrauka įskaityta, kasdienis ir savaitės poilsis įskaitytas';

  @override
  String get notifyBreakTakenTitle => 'Pertrauka įskaityta';

  @override
  String notifyBreakTakenText(int required, String time) {
    return '$required min pertrauka įskaityta. Iki kitos pertraukos galite vairuoti $time.';
  }

  @override
  String get notifyDailyRestTakenTitle => 'Kasdienis poilsis įskaitytas';

  @override
  String notifyDailyRestTakenText(String limit) {
    return 'Įprastinis poilsis $limit — galite pradėti pamainą.';
  }

  @override
  String get notifyWeeklyRestTakenTitle => 'Savaitės poilsis įskaitytas';

  @override
  String notifyWeeklyRestTakenText(String limit) {
    return 'Įprastinis poilsis $limit — galite pradėti naują darbo savaitę.';
  }

  @override
  String get serviceChannel => 'Automatinis vairavimo atpažinimas';

  @override
  String get serviceChannelHint =>
      'Dabartinis režimas ir skaitikliai, kol veikia automatinis atpažinimas';

  @override
  String get serviceStarted => 'Automatinis vairavimo atpažinimas įjungtas';

  @override
  String serviceModeTitle(String mode, String time) {
    return '$mode · $time';
  }

  @override
  String get serviceTeamTitle => 'Transporto priemonė važiuoja';

  @override
  String serviceTeamText(String time) {
    return 'Ar vairuojate jūs? Vairavimas nuo $time';
  }

  @override
  String get serviceSuggestTitle => 'Panašu, kad važiuojate';

  @override
  String serviceSuggestText(String time) {
    return 'Pradėti vairavimą nuo $time? Poilsis bus nutrauktas';
  }

  @override
  String serviceDriving(String untilBreak, String dayLeft) {
    return 'Iki pertraukos $untilBreak · šiandien liko $dayLeft';
  }

  @override
  String serviceDrivingOver(String time) {
    return 'Reikia pertraukos: viršyta $time';
  }

  @override
  String serviceBreakLeft(String time) {
    return 'Iki pilnos pertraukos $time';
  }

  @override
  String serviceBreakDone(String time) {
    return 'Pertrauka įskaityta, galite vairuoti $time';
  }

  @override
  String serviceWorkday(String time, String limit) {
    return 'Darbo diena $time iš $limit';
  }

  @override
  String serviceRestLeft(String limit, String time) {
    return 'Iki pilno $limit poilsio: $time';
  }

  @override
  String get serviceDailyRestDone => 'Įprastinis kasdienis poilsis įskaitytas';

  @override
  String get serviceWeeklyRestDone => 'Įprastinis savaitės poilsis įskaitytas';

  @override
  String get serviceNotStartedText =>
      'Vairavimas įsijungs pats, kai transporto priemonė pajudės';

  @override
  String get serviceNoModeText => 'Atidarykite TachoGo ir pasirinkite režimą';

  @override
  String get autoTitle => 'Automatinis vairavimo atpažinimas';

  @override
  String get autoSwitch => 'Atpažinti vairavimą pagal GPS';

  @override
  String get autoSwitchHint =>
      'Pajudate — vairavimas, sustojate — kitas darbas. Reikia tik greičio: koordinatės nesaugomos.';

  @override
  String get autoAfterStop => 'Sustojus';

  @override
  String get autoAfterStopHint => 'Po 3 minučių stovėjimo';

  @override
  String get autoStartFromRest => 'Vairavimas iškart po poilsio';

  @override
  String get autoStartFromRestHint =>
      'Kitaip programėlė pirmiausia paklaus: galėjote važiuoti kaip keleivis';

  @override
  String get autoBattery => 'Akumuliatoriaus taupymas';

  @override
  String get autoBatteryLimited =>
      'Gali sustabdyti atpažinimą. Išimkite TachoGo iš taupymo sąrašo';

  @override
  String get autoBatteryOk => 'Netrukdo veikti fone';

  @override
  String get autoAutostart => 'Automatinis paleidimas ir fonas';

  @override
  String get autoAutostartHint =>
      'Xiaomi, Huawei, Honor, Oppo, Vivo, Samsung: leiskite, kitaip telefonas sustabdys atpažinimą';

  @override
  String get autoBlockedService =>
      'Vietos nustatymas telefone išjungtas. Įjunkite jį, kad būtų atpažįstamas vairavimas.';

  @override
  String get autoBlockedDenied =>
      'Be prieigos prie vietos vairavimo atpažinti negalima. Programėlei reikia tik greičio, koordinatės nesaugomos.';

  @override
  String get autoBlockedForever =>
      'Prieiga prie vietos užblokuota. Leiskite ją telefono nustatymuose: Vieta → „Kai naudojama programa“.';

  @override
  String get autoNoAccess =>
      'Nėra prieigos prie vietos — atpažinimas neveikia. Leiskite ją telefono nustatymuose.';

  @override
  String get autoEnable => 'Įjungti vairavimo atpažinimą';

  @override
  String get autoEnabled => 'Vairavimo atpažinimas įjungtas';

  @override
  String get settingsData => 'Duomenys';

  @override
  String get settingsExport => 'Ataskaitos eksportas';

  @override
  String get settingsExportFormats => 'PDF · CSV';

  @override
  String get settingsAnalytics => 'Anoniminė statistika';

  @override
  String get settingsAnalyticsHint =>
      'Kuriuos ekranus atidaro vairuotojai — programėlei tobulinti. Be koordinačių, vardų ir kortelių numerių.';

  @override
  String get settingsClear => 'Išvalyti visus duomenis';

  @override
  String get clearTitle => 'Išvalyti visus duomenis?';

  @override
  String get clearText =>
      'Bus ištrinti režimų žurnalas, pamainos, šalys, pastabos ir kortelės nuskaitymai. To atšaukti negalima. Nustatymai liks.';

  @override
  String get clearConfirm => 'Išvalyti';

  @override
  String get clearDone => 'Duomenys ištrinti';

  @override
  String onbStep(int step, int count) {
    return '$step žingsnis iš $count';
  }

  @override
  String get onbWelcomeTitle => 'Laikas prie vairo kontroliuojamas';

  @override
  String get onbWelcomeText =>
      'Skaičiuojame vairavimą, pertraukas ir poilsį pagal ES 561/2006 ir AETR taisykles ir iš anksto įspėjame apie ribas.';

  @override
  String get onbStart => 'Pradėti';

  @override
  String get onbNext => 'Toliau';

  @override
  String get onbDone => 'Atlikta';

  @override
  String get onbModesTitle => 'Keturi režimai — kaip tachografe';

  @override
  String get onbModesText =>
      'Režimą perjunkite pradžios ekrano mygtukais. Skaitikliai veikia patys — net kai programėlė uždaryta.';

  @override
  String get onbModeDriving =>
      'Prie vairo. Skaičiuojame vairavimą be pertraukos, per dieną ir per savaitę.';

  @override
  String get onbModeWork =>
      'Pakrovimas, transporto priemonės patikra, dokumentai.';

  @override
  String get onbModeAvailability =>
      'Laukimas: eilė pakrovimui, pasienis, antrasis vairuotojas kelyje.';

  @override
  String get onbModeRest =>
      'Pertraukos ir poilsis. „Baigti dieną“ užbaigia pamainą.';

  @override
  String get onbSetupTitle => 'Pritaikykime jums';

  @override
  String get onbSetupText => 'Visa tai vėliau galima pakeisti nustatymuose.';

  @override
  String get onbMobilityHint =>
      'Įjunkite, jei važinėjate tarptautiniais maršrutais';

  @override
  String onbNotifyText(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minučių',
      many: '$minutes minutės',
      few: '$minutes minutes',
      one: '$minutes minutę',
    );
    return 'Įspėsime prieš $_temp0 iki pertraukos ir darbo dienos pabaigos — net kai programėlė uždaryta.';
  }

  @override
  String get onbAutoText =>
      'Pajudate — programėlė įjungia vairavimą, sustojate — kitą darbą. Po poilsio pirmiausia paklaus. Reikia tik GPS greičio: koordinatės nesaugomos ir niekur nesiunčiamos.';

  @override
  String get onbAutoLater => 'Galite įjungti vėliau nustatymuose.';

  @override
  String languageButton(String language) {
    return 'Kalba: $language';
  }

  @override
  String get settingsVehicle => 'Transporto priemonė';

  @override
  String get vehicleTruckOrBus => 'Sunkvežimis arba autobusas';

  @override
  String get vehicleVan => 'Furgonas 2,5–3,5 t';

  @override
  String settingsVanHint(String date) {
    return 'Taisyklės — nuo $date tarptautiniame vežime ir kabotaže už atlygį';
  }

  @override
  String onbVanText(String date) {
    return 'ES taisyklės furgonams galioja nuo $date — tarptautiniame vežime ir kabotaže už atlygį. Furgone įrengtas antrosios kartos išmanusis tachografas, vairuotojas turi kortelę.';
  }

  @override
  String get onbRulesTitle => 'Svarbiausios taisyklės';

  @override
  String get onbRulesText =>
      'Tos pačios sunkvežimiams, autobusams ir furgonams. Programėlė jas skaičiuoja pati ir įspėja iš anksto.';

  @override
  String get onbRulesMore =>
      'Visos taisyklės su paaiškinimais — „Daugiau“ → „Instrukcija ir taisyklės“.';

  @override
  String get guideTitle => 'Instrukcija ir taisyklės';

  @override
  String get guideHowTo => 'Kaip naudotis';

  @override
  String get guideStep1 =>
      'Režimą perjunkite pradžios ekrano mygtukais: vairavimas, poilsis, darbas arba budėjimas.';

  @override
  String get guideStep2 =>
      'Nurodykite pamainos pradžios ir pabaigos šalį — kaip tachografe.';

  @override
  String get guideStep3 =>
      'Sekite ribas. Programėlė iš anksto įspės apie pertrauką ir dienos pabaigą. Bet kurį laiką galima pataisyti rankiniu būdu.';

  @override
  String get guideRules => 'ES 561/2006 ir AETR taisyklės';

  @override
  String get guideContinuous => 'Vairavimas be pertraukos';

  @override
  String guideContinuousText(String full, String first, String second) {
    return 'Po to — $full pertrauka. Ją galima padalyti: pirma $first, paskui $second.';
  }

  @override
  String get guideDailyDriving => 'Vairavimas per dieną';

  @override
  String guideDailyDrivingText(String extended) {
    return 'Du kartus per savaitę leidžiama iki $extended.';
  }

  @override
  String get guideWeeklyDriving => 'Vairavimas per savaitę';

  @override
  String guideWeeklyDrivingText(String fortnight) {
    return 'Per bet kurias dvi iš eilės einančias savaites — ne daugiau kaip $fortnight.';
  }

  @override
  String get guideDailyRest => 'Kasdienis poilsis';

  @override
  String guideDailyRestText(String reduced, String first, String second) {
    return 'Iki trijų kartų tarp savaitės poilsių galima sutrumpinti iki $reduced. Padalytas variantas — $first + $second.';
  }

  @override
  String get guideWorkday => 'Darbo diena';

  @override
  String guideWorkdayText(String window, String regular, String reduced) {
    return 'Poilsis turi baigtis per $window nuo pamainos pradžios: $regular esant įprastiniam poilsiui, $reduced — sutrumpintam.';
  }

  @override
  String guideWorkdaySpoken(int first, int second) {
    String _temp0 = intl.Intl.pluralLogic(
      second,
      locale: localeName,
      other: '$second valandų',
      many: '$second valandos',
      few: '$second valandos',
      one: '$second valanda',
    );
    return '$first arba $_temp0';
  }

  @override
  String get guideWeeklyRest => 'Savaitės poilsis';

  @override
  String guideWeeklyRestText(String reduced) {
    return 'Sutrumpintas — $reduced, su kompensacija iki trečios savaitės pabaigos. Įprastinio poilsio negalima praleisti kabinoje.';
  }

  @override
  String get guideWorkWeek => 'Darbo savaitė';

  @override
  String guideWorkWeekText(String period) {
    return 'Savaitės poilsis prasideda ne vėliau kaip po šešių $period laikotarpių nuo ankstesnio.';
  }

  @override
  String get guideCard => 'Vairuotojo kortelė';

  @override
  String guideCardText(String days) {
    return 'Kortelės duomenis reikia atsisiųsti bent kas $days.';
  }

  @override
  String get guideModes => 'Spalvos ir piktogramos';

  @override
  String get guideNewbie => 'Pirmą kartą su tachografu';

  @override
  String get guideNewbieCard => 'Kortelė — tachografe visą pamainą';

  @override
  String get guideNewbieCardText =>
      'Įdėkite kortelę pamainos pradžioje ir išimkite pabaigoje. Ką veikėte be kortelės — darbą, budėjimą ar poilsį — įveskite rankiniu būdu kitą kartą įdėdami.';

  @override
  String get guideNewbieApp => 'Programėlė nepakeičia tachografo';

  @override
  String get guideNewbieAppText =>
      'Oficialus įrašas yra tachografe. Perjunkite režimą ir ten, ir čia — tada skaitikliai sutaps.';

  @override
  String get guideNewbieBreak => 'Pertrauka — tik poilsis';

  @override
  String get guideNewbieBreakText =>
      'Per pertrauką negalima vairuoti ir dirbti. Pakrovimas ir iškrovimas — kitas darbas, ne pertrauka.';

  @override
  String get guideNewbieRestPlace => 'Kur ilsėtis';

  @override
  String get guideNewbieRestPlaceText =>
      'Kasdienį ir sutrumpintą savaitės poilsį galima praleisti transporto priemonėje, jei joje yra miegamoji vieta ir ji stovi. Įprastinį savaitės poilsį ir kompensaciją — tik už transporto priemonės ribų.';

  @override
  String get guideNewbieCountry => 'Šalys';

  @override
  String get guideNewbieCountryText =>
      'Šalis įvedama į tachografą pamainos pradžioje ir pabaigoje. Sienos kirtimą antrosios kartos išmanusis tachografas užfiksuoja pats, senesniuose šalis įvedama pirmame sustojime už sienos.';

  @override
  String guideVanText(String date) {
    return 'Taisyklės tokios pat kaip sunkvežimiams. Nuo $date jos taikomos furgonams, sunkesniems nei 2,5 t kartu su priekaba, — tarptautiniame krovinių vežime ir kabotaže. Tokiame furgone įrengtas antrosios kartos išmanusis tachografas, vairuotojas turi kortelę.';
  }

  @override
  String get guideVanCheck => 'Ar taisyklės taikomos jūsų reisui';

  @override
  String get guideVanTrip => 'Reisas';

  @override
  String get guideVanTripHint => 'Kabotažas — vežimas kitos ES šalies viduje';

  @override
  String get guideVanDomestic => 'Šalies viduje';

  @override
  String get guideVanCrossBorder => 'Į užsienį arba kabotažas';

  @override
  String get guideVanCarriage => 'Vežimas';

  @override
  String get guideVanHire => 'Už atlygį';

  @override
  String get guideVanOwn => 'Savo reikmėms';

  @override
  String get guideVanNonCommercial => 'Nekomercinis';

  @override
  String get guideVanCarriageHint =>
      'Savo reikmėms — jūsų įmonės prekės, medžiagos ar įrankiai. Nekomercinis — be užmokesčio ir pajamų, nesusijęs su darbu';

  @override
  String get guideVanMain => 'Ar vairavimas — jūsų pagrindinis darbas?';

  @override
  String get yes => 'Taip';

  @override
  String get no => 'Ne';

  @override
  String get guideVanApplies => 'Taisyklės taikomos';

  @override
  String get guideVanNotApply => 'Taisyklės netaikomos';

  @override
  String get guideVanAppliesText =>
      'Reikia tachografo ir vairuotojo kortelės, ribos — kaip sunkvežimiui.';

  @override
  String guideVanNotYetText(String date) {
    return 'Iki $date taisyklės furgonams nebuvo taikomos.';
  }

  @override
  String get guideVanDomesticText =>
      'ES reglamentas netaikomas furgonams, vežantiems šalies viduje. Pasitikrinkite savo šalies taisykles.';

  @override
  String get guideVanOwnText =>
      'Išimtis: vežimas savo reikmėms, o vairavimas nėra pagrindinis darbas.';

  @override
  String get guideVanNonCommercialText =>
      'Išimtis: vežimas be užmokesčio ir pajamų, nesusijęs su darbu.';

  @override
  String guideArticle(String article) {
    return 'Reglamentas 561/2006, $article str.';
  }

  @override
  String get guideVanNotes =>
      'Kartu su priekaba sunkesnis nei 3,5 t — taisyklės kaip sunkvežimiui, ir šalies viduje. Reisas iš dalies už ES ribų — į Ukrainą, Moldovą, Turkiją, Balkanus — pasitikslinkite pas vežėją: vieningo aiškinimo nėra.';

  @override
  String get guideDisclaimer =>
      'TachoGo padeda planuoti laiką, bet nepakeičia tachografo ir nėra teisinė konsultacija. Oficialus taisyklių tekstas — Reglamentas (EB) Nr. 561/2006 ir AETR susitarimas.';

  @override
  String get moreAbout => 'Apie programėlę';

  @override
  String get moreDisclaimer =>
      'TachoGo padeda planuoti vairavimo ir poilsio laiką, bet nepakeičia tachografo ir nėra teisinė konsultacija.';

  @override
  String get problemTitle => 'Pranešti apie problemą';

  @override
  String get problemHint =>
      'Beta versija: pranešimas pasieks programėlės kūrėjus';

  @override
  String get problemText =>
      'Pranešime yra programėlės versija, telefono modelis, nustatymai, leidimai, pranešimų grafikas ir žurnalo įrašai už paskutines dvi paras. Koordinačių nėra. Pasirinkite, kur siųsti — el. paštu ar per pokalbių programą — ir aprašykite, kas nutiko.';

  @override
  String get problemSend => 'Siųsti';

  @override
  String get problemSubject => 'TachoGo — problema beta versijoje';

  @override
  String get problemPrompt => 'Kas nutiko ir kada (savais žodžiais):';

  @override
  String get problemFailed =>
      'Nepavyko atidaryti siuntimo. Bandykite dar kartą.';
}
