// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class AppLocalizationsFi extends AppLocalizations {
  AppLocalizationsFi([String locale = 'fi']) : super(locale);

  @override
  String get appTitle => 'TachoGo';

  @override
  String get navHome => 'Koti';

  @override
  String get navJournal => 'Päiväkirja';

  @override
  String get navSettings => 'Asetukset';

  @override
  String get navMore => 'Lisää';

  @override
  String get close => 'Sulje';

  @override
  String get back => 'Takaisin';

  @override
  String ofLimit(String limit) {
    return 'enint. $limit';
  }

  @override
  String get premiumLock => 'Saatavilla Premiumissa';

  @override
  String hoursShort(int hours) {
    return '$hours h';
  }

  @override
  String daysShort(int days) {
    return '$days pv';
  }

  @override
  String spokenHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tuntia',
      one: '$count tunti',
    );
    return '$_temp0';
  }

  @override
  String spokenMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minuuttia',
      one: '$count minuutti',
    );
    return '$_temp0';
  }

  @override
  String spokenOverrun(String duration) {
    return 'ylitys $duration';
  }

  @override
  String get modeDriving => 'Ajo';

  @override
  String get modeRest => 'Lepo';

  @override
  String get modeWork => 'Työ';

  @override
  String get modeWorkFull => 'Muu työ';

  @override
  String get modeAvailability => 'Valmius';

  @override
  String get modeNone => 'Tilaa ei valittu';

  @override
  String modeSince(String time) {
    return 'klo $time alkaen';
  }

  @override
  String get switchFailed => 'Tilaa ei tallennettu. Yritä uudelleen.';

  @override
  String homeShiftSince(String date, String time) {
    return '$date · vuoro klo $time alkaen';
  }

  @override
  String homeNoShift(String date) {
    return '$date · vuoro ei ole alkanut';
  }

  @override
  String get homeLoadError =>
      'Päiväkirjaa ei voitu avata. Käynnistä sovellus uudelleen — jos se ei auta, kirjoita meille kohdasta ”Lisää”.';

  @override
  String get heroUntilBreak => 'Taukoon';

  @override
  String get heroBreak => 'Tauko';

  @override
  String get heroDailyRest => 'Vuorokautinen lepo';

  @override
  String get heroWeeklyRest => 'Viikoittainen lepo';

  @override
  String heroContinuousOf(String time, String limit) {
    return 'ilman taukoa $time / $limit';
  }

  @override
  String get heroOffDutyHint =>
      'Vuoro päättyi. Seuraava alkaa ensimmäisestä tilasta, joka ei ole lepo.';

  @override
  String get bannerBreakNeeded45 =>
      'Tarvitaan 45 min tauko (tai jaettuna 15 + 30)';

  @override
  String get bannerBreakNeeded30 =>
      'Tarvitaan 30 min tauko — jaetun tauon 15 + 30 toinen osa';

  @override
  String bannerOnBreak(String time, int required) {
    return 'Tauko $time / $required min';
  }

  @override
  String bannerBreakCounted(String limit) {
    return 'Tauko hyväksytty — voit ajaa $limit';
  }

  @override
  String get sectionAlerts => 'Varoitukset';

  @override
  String get sectionToday => 'Tänään';

  @override
  String get sectionRest => 'Lepo';

  @override
  String get sectionWeek => 'Viikko';

  @override
  String get rowContinuous => 'Ajo ilman taukoa';

  @override
  String get chipBreakSoon => 'tauko pian';

  @override
  String get chipExceeded => 'ylitetty';

  @override
  String get chipLimiting => 'rajoittaa';

  @override
  String get chipShiftSoon => 'päättyy pian';

  @override
  String get chipLimitSoon => 'raja pian';

  @override
  String get chipRestSoon => 'lepo pian';

  @override
  String chipTimes(int hours, int count) {
    return '$hours h ×$count';
  }

  @override
  String limitOf(String limit) {
    return 'raja $limit';
  }

  @override
  String leftUntil(String left, String time) {
    return 'jäljellä $left → $time';
  }

  @override
  String left(String left) {
    return 'jäljellä $left';
  }

  @override
  String limitLeft(int hours, String left) {
    return '$hours h: jäljellä $left';
  }

  @override
  String limitLeftUntil(int hours, String left, String time) {
    return '$hours h: jäljellä $left → $time';
  }

  @override
  String limitUntil(int hours, String time) {
    return '$hours h → $time';
  }

  @override
  String get rowWorkday => 'Työpäivä';

  @override
  String get workdayNoShift => 'Vuoro ei ole alkanut';

  @override
  String get rowDailyDriving => 'Vuorokautinen ajoaika';

  @override
  String get rowBreak => 'Tauko';

  @override
  String breakTaken(int minutes, String time) {
    return 'Pidetty $minutes min klo $time';
  }

  @override
  String breakStillNeeded(int minutes) {
    return 'Vielä $minutes min';
  }

  @override
  String get breakNotTaken => 'Taukoa ei ole vielä pidetty';

  @override
  String breakResting(String time, int required) {
    return 'Tauko nyt $time / $required min';
  }

  @override
  String get rowDailyRest => 'Vuorokautinen lepo';

  @override
  String get dailyRestCaption => '11 h säännöllinen · 9 h lyhennetty';

  @override
  String get dailyRestSplit => '3 + 9';

  @override
  String get rowWeeklyRest => 'Viikoittainen lepo';

  @override
  String get weeklyRestCaption => '45 h säännöllinen · 24 h lyhennetty';

  @override
  String get chipReducedAvailable => '24 h sallittu';

  @override
  String get chipReducedUnavailable => 'vain 45 h';

  @override
  String get statusNotStarted => 'ei alkanut';

  @override
  String statusInProgress(String time) {
    return 'käynnissä $time';
  }

  @override
  String statusBy(String when) {
    return 'viimeistään $when';
  }

  @override
  String get statusNoData => 'ei tietoja';

  @override
  String get rowWeeklyDriving => 'Viikoittainen ajoaika';

  @override
  String get rowFortnightDriving => 'Kahden viikon ajoaika';

  @override
  String get rowWorkWeek => 'Työviikko';

  @override
  String workWeekSince(String since) {
    return 'alkaen $since';
  }

  @override
  String get workWeekUnknown => 'Edellisestä viikkolevosta ei ole tietoja';

  @override
  String get cardTitle => 'Kortin lataus';

  @override
  String cardCaption(String last, String due) {
    return 'viimeksi $last · määräaika $due';
  }

  @override
  String get cardNever => 'Merkitse viimeisin lataus';

  @override
  String cardSheetLast(String date) {
    return 'Viimeisin lataus: $date';
  }

  @override
  String get cardSheetNever => 'Latausta ei ole vielä merkitty.';

  @override
  String get cardSheetRule =>
      'Kuljettajakortin tiedot on ladattava vähintään 28 päivän välein (asetus (EU) N:o 581/2010).';

  @override
  String get cardMarkToday => 'Ladattu tänään';

  @override
  String get cardMarked => 'Lataus merkitty';

  @override
  String get workdayStart => 'Vuoron alku';

  @override
  String workdayRegular(int hours) {
    return '$hours h — tavallinen päivä';
  }

  @override
  String workdayRegularHint(String left) {
    return 'sitten säännöllinen 11 h lepo · jäljellä $left';
  }

  @override
  String workdayExtended(int hours) {
    return '$hours h — pidennetty päivä';
  }

  @override
  String workdayExtendedHint(int count) {
    return 'sitten lyhennetty 9 h lepo · jäljellä ×$count';
  }

  @override
  String get workdayRule =>
      'Vuorokautisen levon on päätyttävä 24 tunnin kuluessa vuoron alusta. Lyhennetyn 9 h levon voi pitää enintään kolme kertaa viikkolepojen välillä.';

  @override
  String get workdayEndDay => 'Päätä päivä';

  @override
  String get workdayEndDayHint =>
      'Lepo alkaa heti ja päättää vuoron, vaikka se olisi alle 9 h.';

  @override
  String todayDate(String date) {
    return 'Tänään, $date';
  }

  @override
  String infrArticle(String regulation, String article) {
    return 'EU $regulation · $article art.';
  }

  @override
  String get infrContinuousExceededTitle => 'Yhtäjaksoinen ajo ylitetty';

  @override
  String infrContinuousExceededText(String limit, String time, int required) {
    return 'Ajo ilman taukoa ylittää rajan $limit ajalla $time. Pysähdy ja pidä $required min tauko.';
  }

  @override
  String get infrBreakSoonTitle => 'Tauko pian';

  @override
  String infrBreakSoonText(String limit, String time, int required) {
    return 'Rajaan $limit on $time. Tarvitaan $required min tauko.';
  }

  @override
  String get infrDailyDriveExceededTitle => 'Vuorokautinen ajoaika ylitetty';

  @override
  String infrDailyDriveExceededText(String limit, String time) {
    return 'Raja $limit ylitetty ajalla $time. Aloita vuorokautinen lepo.';
  }

  @override
  String get infrDailyDriveSoonTitle => 'Vuorokautinen ajoaika loppumassa';

  @override
  String infrDailyDriveSoonText(String limit, String time) {
    return 'Rajaan $limit on $time.';
  }

  @override
  String get infrExtensionInUseTitle => 'Pidennys 10 tuntiin käytössä';

  @override
  String infrExtensionInUseText(int count) {
    return 'Pidennyksiä jäljellä tällä viikolla: $count.';
  }

  @override
  String get infrShiftExceededTitle => 'Työpäivä ylitetty';

  @override
  String infrShiftExceededText(String limit, String time) {
    return 'Vuoro ylittää rajan $limit ajalla $time. Aloita vuorokautinen lepo.';
  }

  @override
  String get infrShiftSoonTitle => 'Työpäivä päättyy pian';

  @override
  String infrShiftSoonText(String time) {
    return 'Aloita vuorokautinen lepo $time kuluttua.';
  }

  @override
  String get infrWeeklyDriveExceededTitle => 'Viikoittainen ajoaika ylitetty';

  @override
  String infrWeeklyDriveExceededText(String limit, String time) {
    return 'Raja $limit ylitetty ajalla $time.';
  }

  @override
  String get infrWeeklyDriveSoonTitle => 'Viikoittainen ajoaika loppumassa';

  @override
  String infrWeeklyDriveSoonText(String limit, String time) {
    return 'Rajaan $limit on $time.';
  }

  @override
  String get infrFortnightDriveExceededTitle =>
      'Kahden viikon ajoaika ylitetty';

  @override
  String infrFortnightDriveExceededText(String limit, String time) {
    return 'Raja $limit ylitetty ajalla $time.';
  }

  @override
  String get infrFortnightDriveSoonTitle => 'Kahden viikon ajoaika loppumassa';

  @override
  String infrFortnightDriveSoonText(String limit, String time) {
    return 'Rajaan $limit on $time.';
  }

  @override
  String get infrWeeklyRestOverdueTitle => 'Viikkolepo myöhässä';

  @override
  String infrWeeklyRestOverdueText(String time) {
    return 'Edellisestä viikkolevosta on kulunut yli 144 h — $time.';
  }

  @override
  String get infrWeeklyRestSoonTitle => 'Viikkolepo pian';

  @override
  String infrWeeklyRestSoonText(String time) {
    return 'Aloita viikkolepo $time kuluttua.';
  }

  @override
  String get infrWeeklyRestContinueTitle => 'Älä keskeytä lepoa';

  @override
  String infrWeeklyRestContinueText(String time) {
    return 'Viikkolevon määräaika on ohi. Lepää vielä $time, jotta lepo lasketaan viikkolevoksi.';
  }

  @override
  String get infrCompensationSoonTitle => 'Korvauksen määräaika pian';

  @override
  String infrCompensationSoonText(String time, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days päivän',
      one: '$days päivän',
    );
    return 'Liitä $time vähintään 9 h lepoon. Määräaika $_temp0 kuluttua.';
  }

  @override
  String get infrCompensationOverdueTitle => 'Korvaus myöhässä';

  @override
  String infrCompensationOverdueText(String time, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days päivää',
      one: '$days päivä',
    );
    return 'Lyhennetyn viikkolevon $time jäi liittämättä. Myöhässä $_temp0.';
  }

  @override
  String get infrReducedRestsExceededTitle => 'Liian monta lyhennettyä lepoa';

  @override
  String infrReducedRestsExceededText(int count) {
    return 'Lyhennettyjä lepoja viikkolevon jälkeen: $count, sallittu 3.';
  }

  @override
  String get infrCardOverdueTitle => 'Kortin lataus myöhässä';

  @override
  String infrCardOverdueText(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days päivää',
      one: '$days päivä',
    );
    return '28 päivän määräaika umpeutui $_temp0 sitten.';
  }

  @override
  String get infrCardSoonTitle => 'Kortin lataus pian';

  @override
  String infrCardSoonText(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days päivää',
      one: '$days päivä',
    );
    return 'Jäljellä $_temp0.';
  }

  @override
  String get ferryTitle => 'Lautta / juna';

  @override
  String get ferryHint =>
      'Lepoa saa keskeyttää enintään kaksi kertaa, yhteensä enintään 1 h (9 art.). Lautan liike ei kytke ajoa päälle.';

  @override
  String get ferryOn => 'lautta';

  @override
  String breakHero(String limit) {
    return 'Tauko $limit ajon jälkeen';
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
    return '$minutes min — jäljellä';
  }

  @override
  String breakFirstTaken(String from, String to) {
    return 'Ensimmäinen osa pidetty $from–$to';
  }

  @override
  String get breakNone => 'Tarvitaan 45 min tauko kerralla tai 15 + 30 min.';

  @override
  String get breakSplitTitle => 'Jaettu tauko 15 + 30';

  @override
  String get breakSplitText =>
      'Ensimmäinen osa vähintään 15 min, toinen vähintään 30 min, juuri tässä järjestyksessä. Sovellus tunnistaa sen itse.';

  @override
  String get breakStart => 'Aloita tauko';

  @override
  String get breakOngoing => 'Tauko käynnissä';

  @override
  String get weeklyStartBy => 'Aloita viimeistään';

  @override
  String weeklyInTime(String left) {
    return '$left kuluttua — työviikon loppu (144 h)';
  }

  @override
  String weeklyOverdue(String time) {
    return 'myöhässä $time';
  }

  @override
  String get weeklyOngoing => 'Viikkolepo käynnissä';

  @override
  String get weeklyUnknown =>
      'Edellisestä viikkolevosta ei ole tietoja. Määräaika näkyy vähintään 24 h levon jälkeen.';

  @override
  String get weeklyNext => 'Seuraava lepo';

  @override
  String get weeklyFull => 'Säännöllinen';

  @override
  String get weeklyFullHint => 'ei ohjaamossa';

  @override
  String get weeklyReduced => 'Lyhennetty';

  @override
  String get weeklyReducedYes => 'sallittu · korvauksella';

  @override
  String get weeklyReducedNo => 'ei sallittu — tarvitaan säännöllinen';

  @override
  String get weeklyHistory => 'Historia';

  @override
  String weeklyPrevious(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'full': 'säännöllinen',
      'reduced': 'lyhennetty',
      'other': 'riittämätön',
    });
    return 'Edellinen · $_temp0';
  }

  @override
  String get weeklyNow => 'nyt';

  @override
  String get weeklyCompensation => 'Korvausvelka';

  @override
  String get weeklyCompensationNone => 'ei ole';

  @override
  String weeklyCompensationValue(String time, String date) {
    return '$time viimeistään $date';
  }

  @override
  String get weeklyMobilityOn =>
      'Liikkuvuuspaketti käytössä: kansainvälisessä liikenteessä kaksi lyhennettyä lepoa peräkkäin on sallittu, jos ne pidetään rekisteröintimaan ulkopuolella. Lyhennys korvataan kolmannen viikon loppuun mennessä.';

  @override
  String get weeklyMobilityOff =>
      'Lyhennetty viikkolepo korvataan kolmannen viikon loppuun mennessä: velka liitetään vähintään 9 h lepoon.';

  @override
  String get weeklyStartRest => 'Aloita lepo';

  @override
  String get countryTitle => 'Valitse maa';

  @override
  String countryChip(String start, String end) {
    return 'Aloitusmaa $start, loppu $end. Muuta';
  }

  @override
  String countryChipNoEnd(String start) {
    return 'Aloitusmaa $start, loppua ei valittu. Muuta';
  }

  @override
  String get countryChipNone => 'Vuoron maata ei valittu. Valitse';

  @override
  String countryStartTab(String code) {
    return 'Alku · $code';
  }

  @override
  String countryEndTab(String code) {
    return 'Loppu · $code';
  }

  @override
  String get countryNextShift => 'Seuraavan vuoron maa';

  @override
  String get countrySearch => 'Maa tai tunnus';

  @override
  String get countryRecent => 'Viimeisimmät';

  @override
  String get countryClearEnd => 'Älä merkitse';

  @override
  String get countryNotFound => 'Ei tuloksia';

  @override
  String get countryFooter =>
      'Kuljettaja syöttää maan ajopiirturiin vuoron alussa ja lopussa (asetus (EU) N:o 165/2014, 34 art.).';

  @override
  String countryName(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'A': 'Itävalta',
      'AL': 'Albania',
      'AND': 'Andorra',
      'ARM': 'Armenia',
      'AZ': 'Azerbaidžan',
      'B': 'Belgia',
      'BG': 'Bulgaria',
      'BIH': 'Bosnia ja Hertsegovina',
      'BY': 'Valko-Venäjä',
      'CH': 'Sveitsi',
      'CY': 'Kypros',
      'CZ': 'Tšekki',
      'D': 'Saksa',
      'DK': 'Tanska',
      'E': 'Espanja',
      'EST': 'Viro',
      'F': 'Ranska',
      'FIN': 'Suomi',
      'FL': 'Liechtenstein',
      'GE': 'Georgia',
      'GR': 'Kreikka',
      'H': 'Unkari',
      'HR': 'Kroatia',
      'I': 'Italia',
      'IRL': 'Irlanti',
      'IS': 'Islanti',
      'KZ': 'Kazakstan',
      'L': 'Luxemburg',
      'LT': 'Liettua',
      'LV': 'Latvia',
      'M': 'Malta',
      'MC': 'Monaco',
      'MD': 'Moldova',
      'MK': 'Pohjois-Makedonia',
      'MNE': 'Montenegro',
      'N': 'Norja',
      'NL': 'Alankomaat',
      'P': 'Portugali',
      'PL': 'Puola',
      'RO': 'Romania',
      'RSM': 'San Marino',
      'RUS': 'Venäjä',
      'S': 'Ruotsi',
      'SK': 'Slovakia',
      'SLO': 'Slovenia',
      'SRB': 'Serbia',
      'TJ': 'Tadžikistan',
      'TM': 'Turkmenistan',
      'TR': 'Turkki',
      'UA': 'Ukraina',
      'UK': 'Yhdistynyt kuningaskunta',
      'UZ': 'Uzbekistan',
      'V': 'Vatikaani',
      'other': '$code',
    });
    return '$_temp0';
  }

  @override
  String get journalExport => 'Vie raportti';

  @override
  String get journalCurrent => 'nykyinen';

  @override
  String get journalDriving => 'Ajo';

  @override
  String get journalFortnight => '2 viikkoa';

  @override
  String journalOf(int limit) {
    return 'enint. $limit';
  }

  @override
  String get journalCollapsedDriving => 'ajo';

  @override
  String journalWeekSpoken(String range, String driving, String fortnight) {
    return 'Viikko $range. Ajoa $driving / 56 h, kahden viikon aikana $fortnight / 90 h';
  }

  @override
  String get journalShift => 'Vuoro';

  @override
  String get journalWeeklyShort => 'vko';

  @override
  String get journalOngoing => 'käynnissä';

  @override
  String get journalManual => 'käsin';

  @override
  String get journalAddShift => 'Vuoro';

  @override
  String get journalAddShiftSpoken => 'Lisää vuoro';

  @override
  String get journalEmpty =>
      'Vuoroja ei vielä ole. Ne ilmestyvät, kun alat vaihtaa tiloja — tai lisää vuoro käsin.';

  @override
  String restStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'full': 'säännöllinen',
      'reduced': 'lyhennetty',
      'other': 'riittämätön',
    });
    return '$_temp0';
  }

  @override
  String journalWeeklyRest(String status) {
    return 'Viikkolepo · $status';
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
    return '$date, $route, $time. Ajo $driving, vuoro $span, lepo $rest';
  }

  @override
  String get journalRestNone => 'ei ole';

  @override
  String get journalRestWeekly => 'viikkolepo';

  @override
  String get journalLoadError =>
      'Päiväkirjaa ei voitu avata. Käynnistä sovellus uudelleen — jos se ei auta, kirjoita meille kohdasta ”Lisää”.';

  @override
  String get dayTitle => 'Vuoro';

  @override
  String get daySummary => 'Yhteenveto';

  @override
  String get dayModes => 'Tilat';

  @override
  String get dayBreaks => 'Tauot';

  @override
  String get dayContinuousAtEnd => 'Ilman taukoa vuoron lopussa';

  @override
  String get dayRestAfter => 'Lepo vuoron jälkeen';

  @override
  String dayRestKind(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'daily': 'Vuorokautinen',
      'weekly': 'Viikoittainen',
      'other': 'Ei alkanut',
    });
    return '$_temp0';
  }

  @override
  String get daySplitRest => 'jaettu 3 + 9';

  @override
  String get dayManualHint =>
      'Vuoro syötetty käsin yhteenvetona — tilamerkintöjä ei ole.';

  @override
  String get dayNotes => 'Muistiinpanot';

  @override
  String get dayEndMark => 'päivän loppu';

  @override
  String get dayEdit => 'Muokkaa vuoroa';

  @override
  String get dayNotFound => 'Tätä vuoroa ei ole enää päiväkirjassa.';

  @override
  String dayRestUntil(String time) {
    return 'klo $time asti';
  }

  @override
  String get save => 'Tallenna';

  @override
  String get cancel => 'Peruuta';

  @override
  String get done => 'Valmis';

  @override
  String get delete => 'Poista';

  @override
  String get unitHours => 'h';

  @override
  String get unitMinutes => 'min';

  @override
  String get pickerHours => 'Tunnit';

  @override
  String get pickerMinutes => 'Minuutit';

  @override
  String get pickerTime => 'Aika';

  @override
  String get pickerPrevMonth => 'Edellinen kuukausi';

  @override
  String get pickerNextMonth => 'Seuraava kuukausi';

  @override
  String pickerRange(String min, String max) {
    return 'Sallittu $min–$max';
  }

  @override
  String get shiftNewTitle => 'Uusi vuoro';

  @override
  String get shiftSection => 'Vuoro';

  @override
  String get shiftStart => 'Alku';

  @override
  String get shiftEnd => 'Loppu';

  @override
  String get shiftOnRoad => 'tiellä';

  @override
  String get shiftChoose => 'Valitse';

  @override
  String get shiftNowOngoing => 'Nyt (käynnissä)';

  @override
  String get shiftDuration => 'Kesto';

  @override
  String get shiftNowSuffix => 'nyt';

  @override
  String shiftCountrySpoken(String side, String code) {
    return '$side: maa $code. Muuta';
  }

  @override
  String shiftDateSpoken(String side, String date, String time) {
    return '$side: $date, $time. Muuta';
  }

  @override
  String get shiftDriving => 'Ajo';

  @override
  String get shiftPerDay => 'Päivässä';

  @override
  String get shiftLiveContinuous => 'lasketaan taukojen mukaan';

  @override
  String get shiftRestNone => 'Ei alkanut';

  @override
  String get shiftRestDaily => 'Vuorokautinen';

  @override
  String get shiftRestWeekly => 'Viikoittainen';

  @override
  String get shiftSplit => 'Jaettu lepo 3 + 9';

  @override
  String get shiftSplitHint => 'Ensin 3 h, sitten 9 h';

  @override
  String shiftRestUntilNext(String when) {
    return 'Vuoron alkuun: $when';
  }

  @override
  String get shiftRestAutoHint => 'Kestää seuraavan vuoron alkuun';

  @override
  String get shiftRestCountsWeekly =>
      '24 tunnista alkaen lepo lasketaan viikkolevoksi';

  @override
  String get shiftNotesHint => 'Esimerkiksi: lautta, lastauksen odotus';

  @override
  String get shiftDelete => 'Poista vuoro';

  @override
  String get shiftDeleteTitle => 'Poistetaanko vuoro?';

  @override
  String get shiftDeleteManual => 'Vuoro poistetaan päiväkirjasta.';

  @override
  String get shiftDeleteRecorded =>
      'Kaikki tämän vuoron tilamerkinnät poistetaan. Tätä ei voi perua.';

  @override
  String get shiftErrStartCountry => 'Valitse maa, jossa vuoro alkaa';

  @override
  String get shiftErrEndCountry => 'Merkitse maa, jossa vuoro päättyy';

  @override
  String get shiftErrEndBeforeStart => 'Vuoro päättyy ennen kuin alkaa';

  @override
  String get shiftErrFuture => 'Vuoron aika ei voi olla tulevaisuudessa';

  @override
  String get shiftErrTooLong => 'Vuoro yli 30 h — tarkista päivämäärät';

  @override
  String get shiftErrDrivingTooLong => 'Ajo on vuoroa pidempi';

  @override
  String get shiftErrContinuous =>
      'Yhtäjaksoinen ajo on vuorokautista ajoa pidempi';

  @override
  String shiftErrOverlap(String range) {
    return 'Menee päällekkäin vuoron $range kanssa';
  }

  @override
  String get shiftErrNotLast =>
      'Tämän jälkeen on muita vuoroja — se ei voi olla käynnissä nyt';

  @override
  String get shiftSaveFailed => 'Tallennus epäonnistui. Yritä uudelleen.';

  @override
  String get shiftSavedViolations => 'Vuoro tallennettu. Rikkomuksia on';

  @override
  String get shiftSavedViolationsText =>
      'Tarkista ajat. Jos kaikki on oikein, rikkomukset näkyvät päiväkirjassa ja raportissa.';

  @override
  String get gotIt => 'Selvä';

  @override
  String get shiftLiveHint =>
      'Vuoro seuraa tilamerkintöjä: alun, lopun tai ajon muuttaminen siirtää itse merkintöjä.';

  @override
  String get shiftConvertHint =>
      'Aika, ajo tai lepo muuttui — vuoro tallennetaan käsin syötettynä tilamerkintöjen sijaan.';

  @override
  String shiftEndNowHint(String time) {
    return 'Vuoro päättyy klo $time, sitten alkaa lepo.';
  }

  @override
  String get shiftResumeHint =>
      'Vuoron jälkeinen lepo poistetaan — vuoro jatkuu.';

  @override
  String shiftOngoingHint(String time, String mode) {
    return 'Vuorosta tulee nykyinen, ja se jatkuu kotinäytöllä klo $time alkaen. Tila ”$mode” — jos nyt on toinen, vaihda se siellä.';
  }

  @override
  String get shiftUnsavedTitle => 'Tallennetaanko muutokset?';

  @override
  String get shiftUnsavedText =>
      'Tämän vuoron muutoksia ei ole vielä tallennettu.';

  @override
  String get shiftDiscard => 'Älä tallenna';

  @override
  String get shiftDateTimeTitle => 'Vuoron päivä ja aika';

  @override
  String driveEditSubtitle(String date) {
    return 'Käsin korjaus · $date';
  }

  @override
  String get driveEditComputed => 'Sovelluksen laskema';

  @override
  String driveEditDiff(String diff) {
    return '$diff laskelmaan verrattuna.';
  }

  @override
  String get driveEditNoChange => 'Aika ei muuttunut.';

  @override
  String get driveEditHint =>
      'Käytä, jos tila vaihdettiin väärään aikaan — rajat lasketaan uudelleen.';

  @override
  String get driveEditNoDrive =>
      'Nykyisessä vuorossa ei vielä ole ajoa — ei korjattavaa.';

  @override
  String get breakCorrection => 'Korjaus';

  @override
  String get breakCurrentDuration => 'Nykyinen tauko';

  @override
  String get breakLastDuration => 'Viimeisin tauko';

  @override
  String get breakNoBreak => 'Vuorossa ei vielä ole taukoa — ei korjattavaa.';

  @override
  String get breakEditHint =>
      'Aika otetaan viereisestä merkinnästä — rajat lasketaan uudelleen.';

  @override
  String get workdayChangeStart => 'Muuta vuoron alkua';

  @override
  String get weeklyAddManually => 'Syötä käsin';

  @override
  String get exportPeriod => 'Jakso';

  @override
  String get exportWeek => 'Tämä viikko';

  @override
  String get exportTwoWeeks => '2 viikkoa';

  @override
  String get exportDays28 => '28 päivää';

  @override
  String get exportCustom => 'Oma jakso';

  @override
  String get exportFrom => 'Alkaen';

  @override
  String get exportTo => 'Päättyen';

  @override
  String exportFromDay(String date) {
    return 'Alkaen $date';
  }

  @override
  String exportToDay(String date) {
    return '$date asti';
  }

  @override
  String get exportFormat => 'Muoto';

  @override
  String get exportPdf => 'PDF · tarkastukseen';

  @override
  String get exportCsv => 'CSV · taulukko';

  @override
  String get exportPdfHint =>
      'Ei virallinen asiakirja: raportti ei korvaa ajopiirturin ja kuljettajakortin tietoja.';

  @override
  String get exportCsvHint =>
      'Tilamerkinnät riveittäin, aika UTC:nä — Exceliin ja kirjanpito-ohjelmiin.';

  @override
  String get exportLanguage => 'Raportin kieli';

  @override
  String get exportNotes => 'Maat ja muistiinpanot';

  @override
  String get exportCreate => 'Luo raportti';

  @override
  String exportCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vuoroa',
      one: '$count vuoro',
    );
    return 'Raportissa $_temp0';
  }

  @override
  String get exportEmpty => 'Valitulla jaksolla ei ole vuoroja.';

  @override
  String get exportFailed => 'Raporttia ei voitu luoda. Yritä uudelleen.';

  @override
  String exportRangeSpoken(String from, String to) {
    return 'Jakso $from–$to';
  }

  @override
  String get reportTitle => 'Ajo- ja lepoaikaraportti';

  @override
  String get reportSubtitle => 'Asetus (EY) N:o 561/2006 ja AETR-sopimus';

  @override
  String get reportDriver => 'Kuljettaja';

  @override
  String get reportCard => 'Kuljettajakortti';

  @override
  String get reportVehicle => 'Rekisterinumero';

  @override
  String get reportCompany => 'Liikenteenharjoittaja';

  @override
  String get reportPeriod => 'Jakso';

  @override
  String get reportGenerated => 'Luotu';

  @override
  String reportTimezone(String zone) {
    return 'Ajat puhelimen aikavyöhykkeellä ($zone). Raportin päivät ja viikot UTC:nä, viikko alkaa maanantaina klo 00:00, kuten ajopiirturissa.';
  }

  @override
  String get reportDate => 'Päivä';

  @override
  String get reportStart => 'Alku';

  @override
  String get reportEnd => 'Loppu';

  @override
  String get reportCountries => 'Maat';

  @override
  String get reportDriving => 'Ajo';

  @override
  String get reportWork => 'Työ';

  @override
  String get reportAvailability => 'Valm.';

  @override
  String get reportBreaks => 'Tauot';

  @override
  String get reportSpan => 'Vuoro';

  @override
  String get reportRestAfter => 'Lepo jälkeen';

  @override
  String get reportNotes => 'Muistiinpanot';

  @override
  String reportWeek(String range) {
    return 'Viikko $range';
  }

  @override
  String reportWeekTotal(String driving, String fortnight) {
    return 'Yhteensä: ajo $driving / 56 h · 2 viikon aikana $fortnight / 90 h';
  }

  @override
  String get reportViolations => 'Rikkomukset';

  @override
  String get reportNoViolations => 'Päiväkirjan mukaan ei rikkomuksia.';

  @override
  String reportViolationDrive(String date, String time) {
    return '$date: vuorokautinen ajo $time — yli 10 h';
  }

  @override
  String reportViolationSpan(String date, String time, int limit) {
    return '$date: työpäivä $time — yli $limit h';
  }

  @override
  String reportViolationRest(String date, String time) {
    return '$date: lepo vuoron jälkeen $time — riittämätön';
  }

  @override
  String reportViolationWeek(String range, String time) {
    return 'Viikko $range: ajo $time — yli 56 h';
  }

  @override
  String reportViolationFortnight(String range, String time) {
    return 'Viikko $range: kahden viikon aikana $time — yli 90 h';
  }

  @override
  String get reportMarks => 'Merkinnät';

  @override
  String get reportMarkWarn =>
      '! — ajo pidennetty 10 tuntiin, työpäivä yli 13 h tai lyhennetty lepo';

  @override
  String get reportMarkBad => '!! — rikkomus';

  @override
  String get reportMarkManual => '* — vuoro syötetty käsin yhteenvetona';

  @override
  String get reportDisclaimer =>
      'Raportti perustuu kuljettajan merkintöihin TachoGo-sovelluksessa. Ei virallinen asiakirja: ei korvaa ajopiirturin ja kuljettajakortin tietoja.';

  @override
  String get reportSignature => 'Kuljettajan allekirjoitus';

  @override
  String reportPage(int page, int pages) {
    return 'Sivu $page / $pages';
  }

  @override
  String get openSystemSettings => 'Avaa asetukset';

  @override
  String get settingsGeneral => 'Yleiset';

  @override
  String get settingsLanguage => 'Kieli';

  @override
  String get settingsLanguageSystem => 'Kuten puhelimessa';

  @override
  String get settingsTheme => 'Ulkoasu';

  @override
  String get themeSystem => 'Järjestelmä';

  @override
  String get themeLight => 'Vaalea';

  @override
  String get themeDark => 'Tumma';

  @override
  String get settingsRules => 'Säännöt';

  @override
  String get settingsTachograph => 'Ajoneuvon ajopiirturi';

  @override
  String get tachographDigital => 'Digitaalinen';

  @override
  String get tachographAnalog => 'Analoginen';

  @override
  String get settingsMobility => 'Liikkuvuuspaketti';

  @override
  String get settingsMobilityHint =>
      'Kaksi lyhennettyä viikkolepoa peräkkäin kansainvälisessä liikenteessä';

  @override
  String get settingsCrew => 'Kahden kuljettajan miehistö';

  @override
  String get settingsCrewHint =>
      'Vuorokautinen lepo 9 h 30 tunnin kuluessa vuoron alusta';

  @override
  String get settingsNotifications => 'Ilmoitukset';

  @override
  String get settingsWarnLead => 'Varoita rajoista';

  @override
  String get settingsWarnLeadHint => 'Tauko, päivän loppu, ajo';

  @override
  String get settingsWarnLeadGroup => 'Varoita etukäteen';

  @override
  String leadMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String leadHours(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours tuntia',
      one: '$hours tunti',
    );
    return '$_temp0';
  }

  @override
  String get notifyBreak => 'Tauko';

  @override
  String get notifyShiftEnd => 'Työpäivän loppu';

  @override
  String get notifyShiftEndHint => 'Vuorokautinen ja viikoittainen lepo';

  @override
  String get notifyDriving => 'Ajoaikaraja';

  @override
  String get notifyCard => 'Kortin lataus';

  @override
  String get notifyCardHint => '28 päivän välein';

  @override
  String get notifyCardLead => 'Etukäteen';

  @override
  String get notifyCardLeadGroup => 'Varoita kortin latauksesta etukäteen';

  @override
  String leadDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days päivää',
      one: '$days päivä',
    );
    return '$_temp0';
  }

  @override
  String get notifyAllow => 'Salli ilmoitukset';

  @override
  String get notifyDenied => 'Ilmoitukset on nyt estetty puhelimessa';

  @override
  String get notifyAllowed => 'Ilmoitukset sallittu';

  @override
  String get notifyExact => 'Tarkka ilmoitusaika';

  @override
  String get notifyExactHint =>
      'Salli ”Hälytykset ja muistutukset” — muuten puhelin voi viivästyttää varoitusta';

  @override
  String get notifyChannelLimits => 'Rajat ja rikkomukset';

  @override
  String get notifyChannelLimitsHint =>
      'Tauko, työpäivän loppu, ajo, viikkolepo, kortti';

  @override
  String get notifyChannelRest => 'Lepo hyväksytty';

  @override
  String get notifyChannelRestHint =>
      'Tauko hyväksytty, vuorokautinen ja viikoittainen lepo hyväksytty';

  @override
  String get notifyBreakTakenTitle => 'Tauko hyväksytty';

  @override
  String notifyBreakTakenText(int required, String time) {
    return '$required min tauko on hyväksytty. Voit ajaa $time seuraavaan taukoon.';
  }

  @override
  String get notifyDailyRestTakenTitle => 'Vuorokautinen lepo hyväksytty';

  @override
  String notifyDailyRestTakenText(String limit) {
    return 'Säännöllinen lepo $limit — voit aloittaa vuoron.';
  }

  @override
  String get notifyWeeklyRestTakenTitle => 'Viikkolepo hyväksytty';

  @override
  String notifyWeeklyRestTakenText(String limit) {
    return 'Säännöllinen lepo $limit — voit aloittaa uuden työviikon.';
  }

  @override
  String get serviceChannel => 'Ajon automaattinen tunnistus';

  @override
  String get serviceChannelHint =>
      'Nykyinen tila ja laskurit, kun automaattinen tunnistus on päällä';

  @override
  String get serviceStarted => 'Ajon automaattinen tunnistus on päällä';

  @override
  String serviceModeTitle(String mode, String time) {
    return '$mode · $time';
  }

  @override
  String get serviceTeamTitle => 'Ajoneuvo liikkuu';

  @override
  String serviceTeamText(String time) {
    return 'Ajatko sinä? Ajo klo $time alkaen';
  }

  @override
  String get serviceSuggestTitle => 'Näyttää siltä, että ajat';

  @override
  String serviceSuggestText(String time) {
    return 'Aloitetaanko ajo klo $time alkaen? Lepo keskeytyy';
  }

  @override
  String serviceDriving(String untilBreak, String dayLeft) {
    return 'Taukoon $untilBreak · tänään jäljellä $dayLeft';
  }

  @override
  String serviceDrivingOver(String time) {
    return 'Tarvitaan tauko: ylitys $time';
  }

  @override
  String serviceBreakLeft(String time) {
    return 'Täyteen taukoon $time';
  }

  @override
  String serviceBreakDone(String time) {
    return 'Tauko hyväksytty, voit ajaa $time';
  }

  @override
  String serviceWorkday(String time, String limit) {
    return 'Työpäivä $time / $limit';
  }

  @override
  String serviceRestLeft(String limit, String time) {
    return 'Täyteen $limit lepoon: $time';
  }

  @override
  String get serviceDailyRestDone =>
      'Säännöllinen vuorokautinen lepo hyväksytty';

  @override
  String get serviceWeeklyRestDone => 'Säännöllinen viikkolepo hyväksytty';

  @override
  String get serviceNotStartedText =>
      'Ajo kytkeytyy päälle, kun ajoneuvo lähtee liikkeelle';

  @override
  String get serviceNoModeText => 'Avaa TachoGo ja valitse tila';

  @override
  String get autoTitle => 'Ajon automaattinen tunnistus';

  @override
  String get autoSwitch => 'Tunnista ajo GPS:n avulla';

  @override
  String get autoSwitchHint =>
      'Lähdet liikkeelle — ajo; pysähdyt — muu työ. Vain nopeus tarvitaan: sijaintia ei tallenneta.';

  @override
  String get autoAfterStop => 'Pysähdyksen jälkeen';

  @override
  String get autoAfterStopHint => '3 minuutin paikallaanolon jälkeen';

  @override
  String get autoStartFromRest => 'Ajo heti levon jälkeen';

  @override
  String get autoStartFromRestHint =>
      'Muuten sovellus kysyy ensin: olit ehkä matkustaja';

  @override
  String get autoBattery => 'Virransäästö';

  @override
  String get autoBatteryLimited =>
      'Voi pysäyttää tunnistuksen. Poista TachoGo säästöluettelosta';

  @override
  String get autoBatteryOk => 'Ei häiritse taustatoimintaa';

  @override
  String get autoAutostart => 'Automaattinen käynnistys ja taustatoiminta';

  @override
  String get autoAutostartHint =>
      'Xiaomi, Huawei, Honor, Oppo, Vivo, Samsung: salli, muuten puhelin pysäyttää tunnistuksen';

  @override
  String get autoBlockedService =>
      'Sijainti on pois päältä puhelimessa. Kytke se päälle ajon tunnistamiseksi.';

  @override
  String get autoBlockedDenied =>
      'Ajoa ei voi tunnistaa ilman sijaintilupaa. Sovellus tarvitsee vain nopeuden, sijaintia ei tallenneta.';

  @override
  String get autoBlockedForever =>
      'Sijaintilupa on estetty. Salli se puhelimen asetuksissa: Sijainti → ”Kun sovellusta käytetään”.';

  @override
  String get autoNoAccess =>
      'Ei sijaintilupaa — tunnistus ei toimi. Salli se puhelimen asetuksissa.';

  @override
  String get autoEnable => 'Kytke ajon tunnistus päälle';

  @override
  String get autoEnabled => 'Ajon tunnistus on päällä';

  @override
  String get settingsData => 'Tiedot';

  @override
  String get settingsExport => 'Vie raportti';

  @override
  String get settingsExportFormats => 'PDF · CSV';

  @override
  String get settingsAnalytics => 'Anonyymit tilastot';

  @override
  String get settingsAnalyticsHint =>
      'Mitä näyttöjä kuljettajat avaavat — sovelluksen parantamiseksi. Ei sijainteja, nimiä eikä korttinumeroita.';

  @override
  String get settingsClear => 'Poista kaikki tiedot';

  @override
  String get clearTitle => 'Poistetaanko kaikki tiedot?';

  @override
  String get clearText =>
      'Tilapäiväkirja, vuorot, maat, muistiinpanot ja kortin lataukset poistetaan. Tätä ei voi perua. Asetukset säilyvät.';

  @override
  String get clearConfirm => 'Poista';

  @override
  String get clearDone => 'Tiedot poistettu';

  @override
  String onbStep(int step, int count) {
    return 'Vaihe $step / $count';
  }

  @override
  String get onbWelcomeTitle => 'Ajoaika hallinnassa';

  @override
  String get onbWelcomeText =>
      'Laskemme ajon, tauot ja levon EU 561/2006- ja AETR-sääntöjen mukaan ja varoitamme rajoista etukäteen.';

  @override
  String get onbStart => 'Aloita';

  @override
  String get onbNext => 'Seuraava';

  @override
  String get onbDone => 'Valmis';

  @override
  String get onbModesTitle => 'Neljä tilaa — kuten ajopiirturissa';

  @override
  String get onbModesText =>
      'Vaihda tilaa kotinäytön painikkeilla. Laskurit käyvät itsestään — myös kun sovellus on suljettu.';

  @override
  String get onbModeDriving =>
      'Ratissa. Laskemme yhtäjaksoisen, vuorokautisen ja viikoittaisen ajon.';

  @override
  String get onbModeWork => 'Lastaus, ajoneuvon tarkastus, paperityöt.';

  @override
  String get onbModeAvailability =>
      'Odotus: lastausjono, raja, toinen kuljettaja ajaa.';

  @override
  String get onbModeRest => 'Tauot ja lepo. ”Päätä päivä” sulkee vuoron.';

  @override
  String get onbSetupTitle => 'Määritetään sinulle sopivaksi';

  @override
  String get onbSetupText => 'Kaiken tämän voi muuttaa myöhemmin asetuksissa.';

  @override
  String get onbMobilityHint =>
      'Kytke päälle, jos ajat kansainvälisiä reittejä';

  @override
  String onbNotifyText(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minuuttia',
      one: '$minutes minuutti',
    );
    return 'Varoitamme $_temp0 ennen taukoa ja työpäivän loppua — myös kun sovellus on suljettu.';
  }

  @override
  String get onbAutoText =>
      'Lähdet liikkeelle — sovellus kytkee ajon päälle; pysähdyt — muu työ. Levon jälkeen se kysyy ensin. Vain GPS-nopeus tarvitaan: sijaintia ei tallenneta eikä lähetetä minnekään.';

  @override
  String get onbAutoLater => 'Voit kytkeä sen päälle myöhemmin asetuksissa.';

  @override
  String languageButton(String language) {
    return 'Kieli: $language';
  }

  @override
  String get settingsVehicle => 'Ajoneuvo';

  @override
  String get vehicleTruckOrBus => 'Kuorma-auto tai linja-auto';

  @override
  String get vehicleVan => 'Pakettiauto 2,5–3,5 t';

  @override
  String settingsVanHint(String date) {
    return 'Säännöt — $date alkaen kansainvälisissä kuljetuksissa ja kabotaasissa korvausta vastaan';
  }

  @override
  String onbVanText(String date) {
    return 'EU-säännöt koskevat pakettiautoja $date alkaen — kansainvälisissä kuljetuksissa ja kabotaasissa korvausta vastaan. Pakettiautossa on toisen sukupolven älykäs ajopiirturi, kuljettajalla on kortti.';
  }

  @override
  String get onbRulesTitle => 'Tärkeimmät säännöt';

  @override
  String get onbRulesText =>
      'Samat kuorma-autoille, linja-autoille ja pakettiautoille. Sovellus laskee ne itse ja varoittaa etukäteen.';

  @override
  String get onbRulesMore =>
      'Kaikki säännöt selityksineen — ”Lisää” → ”Opas ja säännöt”.';

  @override
  String get guideTitle => 'Opas ja säännöt';

  @override
  String get guideHowTo => 'Käyttöohje';

  @override
  String get guideStep1 =>
      'Vaihda tilaa kotinäytön painikkeilla: ajo, lepo, työ tai valmius.';

  @override
  String get guideStep2 =>
      'Merkitse maa vuoron alussa ja lopussa — kuten ajopiirturissa.';

  @override
  String get guideStep3 =>
      'Seuraa rajoja. Sovellus varoittaa etukäteen tauosta ja päivän lopusta. Minkä tahansa ajan voi korjata käsin.';

  @override
  String get guideRules => 'EU 561/2006- ja AETR-säännöt';

  @override
  String get guideContinuous => 'Ajo ilman taukoa';

  @override
  String guideContinuousText(String full, String first, String second) {
    return 'Sitten tauko $full. Sen voi jakaa: ensin $first, sitten $second.';
  }

  @override
  String get guideDailyDriving => 'Ajo päivässä';

  @override
  String guideDailyDrivingText(String extended) {
    return 'Kahdesti viikossa sallitaan enintään $extended.';
  }

  @override
  String get guideWeeklyDriving => 'Ajo viikossa';

  @override
  String guideWeeklyDrivingText(String fortnight) {
    return 'Minä tahansa kahtena peräkkäisenä viikkona — enintään $fortnight.';
  }

  @override
  String get guideDailyRest => 'Vuorokautinen lepo';

  @override
  String guideDailyRestText(String reduced, String first, String second) {
    return 'Viikkolepojen välillä enintään kolme kertaa sallitaan lyhennetty lepo $reduced. Jaettu vaihtoehto — $first + $second.';
  }

  @override
  String get guideWorkday => 'Työpäivä';

  @override
  String guideWorkdayText(String window, String regular, String reduced) {
    return 'Levon on päätyttävä $window kuluessa vuoron alusta: säännöllisellä levolla $regular, lyhennetyllä $reduced.';
  }

  @override
  String guideWorkdaySpoken(int first, int second) {
    String _temp0 = intl.Intl.pluralLogic(
      second,
      locale: localeName,
      other: '$second tuntia',
      one: '$second tunti',
    );
    return '$first tai $_temp0';
  }

  @override
  String get guideWeeklyRest => 'Viikoittainen lepo';

  @override
  String guideWeeklyRestText(String reduced) {
    return 'Lyhennetty — $reduced, korvauksella kolmannen viikon loppuun mennessä. Säännöllistä lepoa ei saa viettää ohjaamossa.';
  }

  @override
  String get guideWorkWeek => 'Työviikko';

  @override
  String guideWorkWeekText(String period) {
    return 'Viikkolepo alkaa viimeistään kuuden $period jakson jälkeen edellisestä.';
  }

  @override
  String get guideCard => 'Kuljettajakortti';

  @override
  String guideCardText(String days) {
    return 'Kortin tiedot on ladattava viimeistään, kun edellisestä latauksesta on kulunut $days.';
  }

  @override
  String get guideModes => 'Värit ja kuvakkeet';

  @override
  String get guideNewbie => 'Ensimmäistä kertaa ajopiirturin kanssa';

  @override
  String get guideNewbieCard => 'Kortti on ajopiirturissa koko vuoron ajan';

  @override
  String get guideNewbieCardText =>
      'Aseta kortti vuoron alussa ja poista se lopussa. Mitä teit ilman korttia — työ, valmius tai lepo — syötä käsin, kun asetat sen seuraavan kerran.';

  @override
  String get guideNewbieApp => 'Sovellus ei korvaa ajopiirturia';

  @override
  String get guideNewbieAppText =>
      'Virallinen tallenne on ajopiirturissa. Vaihda tilaa sekä siellä että täällä — silloin laskurit täsmäävät.';

  @override
  String get guideNewbieBreak => 'Tauko tarkoittaa vain lepoa';

  @override
  String get guideNewbieBreakText =>
      'Tauon aikana ei saa ajaa eikä tehdä töitä. Lastaus ja purku ovat muuta työtä, eivät taukoa.';

  @override
  String get guideNewbieRestPlace => 'Missä levätä';

  @override
  String get guideNewbieRestPlaceText =>
      'Vuorokautisen levon ja lyhennetyn viikkolevon voi pitää ajoneuvossa, jos siinä on makuupaikka ja se on paikallaan. Säännöllisen viikkolevon ja korvauksen — vain ajoneuvon ulkopuolella.';

  @override
  String get guideNewbieCountry => 'Maat';

  @override
  String get guideNewbieCountryText =>
      'Maa syötetään ajopiirturiin vuoron alussa ja lopussa. Toisen sukupolven älykäs ajopiirturi tallentaa rajanylityksen itse; vanhemmissa maa syötetään ensimmäisellä pysähdyksellä rajan jälkeen.';

  @override
  String guideVanText(String date) {
    return 'Säännöt ovat samat kuin kuorma-autoille. $date alkaen ne koskevat yli 2,5 t pakettiautoja perävaunu mukaan lukien — kansainvälisissä tavarakuljetuksissa ja kabotaasissa. Tällaisessa pakettiautossa on toisen sukupolven älykäs ajopiirturi, kuljettajalla on kortti.';
  }

  @override
  String get guideVanCheck => 'Koskevatko säännöt matkaasi';

  @override
  String get guideVanTrip => 'Matka';

  @override
  String get guideVanTripHint => 'Kabotaasi — kuljetus toisen EU-maan sisällä';

  @override
  String get guideVanDomestic => 'Kotimaan';

  @override
  String get guideVanCrossBorder => 'Ulkomaille tai kabotaasi';

  @override
  String get guideVanCarriage => 'Kuljetus';

  @override
  String get guideVanHire => 'Korvausta vastaan';

  @override
  String get guideVanOwn => 'Omaan lukuun';

  @override
  String get guideVanNonCommercial => 'Ei-kaupallinen';

  @override
  String get guideVanCarriageHint =>
      'Omaan lukuun — yrityksesi tavarat, materiaalit tai työkalut. Ei-kaupallinen — ilman maksua tai tuloa, ei liity työhön';

  @override
  String get guideVanMain => 'Onko ajaminen päätyösi?';

  @override
  String get yes => 'Kyllä';

  @override
  String get no => 'Ei';

  @override
  String get guideVanApplies => 'Säännöt koskevat';

  @override
  String get guideVanNotApply => 'Säännöt eivät koske';

  @override
  String get guideVanAppliesText =>
      'Tarvitaan ajopiirturi ja kuljettajakortti, rajat ovat samat kuin kuorma-autolla.';

  @override
  String guideVanNotYetText(String date) {
    return 'Ennen $date säännöt eivät koskeneet pakettiautoja.';
  }

  @override
  String get guideVanDomesticText =>
      'EU-asetus ei koske pakettiautoja kotimaan liikenteessä. Tarkista oman maasi säännöt.';

  @override
  String get guideVanOwnText =>
      'Poikkeus: kuljetus omiin tarpeisiin, eikä ajaminen ole päätyösi.';

  @override
  String get guideVanNonCommercialText =>
      'Poikkeus: kuljetus ilman maksua tai tuloa, ei liity työhön.';

  @override
  String guideArticle(String article) {
    return 'Asetus 561/2006, $article art.';
  }

  @override
  String get guideVanNotes =>
      'Yhdessä perävaunun kanssa yli 3,5 t — säännöt kuten kuorma-autolla, myös kotimaassa. Matka osittain EU:n ulkopuolella — Ukrainaan, Moldovaan, Turkkiin, Balkanille — tarkista liikenteenharjoittajalta: yhtenäistä tulkintaa ei ole.';

  @override
  String get guideDisclaimer =>
      'TachoGo auttaa suunnittelemaan aikaa, mutta ei korvaa ajopiirturia eikä ole oikeudellista neuvontaa. Sääntöjen virallinen teksti on asetus (EY) N:o 561/2006 ja AETR-sopimus.';

  @override
  String get moreAbout => 'Tietoa sovelluksesta';

  @override
  String get moreDisclaimer =>
      'TachoGo auttaa suunnittelemaan ajo- ja lepoaikoja, mutta ei korvaa ajopiirturia eikä ole oikeudellista neuvontaa.';

  @override
  String get problemTitle => 'Ilmoita ongelmasta';

  @override
  String get problemHint =>
      'Beetaversio: ilmoitus menee sovelluksen kehittäjille';

  @override
  String get problemText =>
      'Ilmoituksessa on sovelluksen versio, puhelimen malli, asetukset, luvat, ilmoitusten aikataulu ja päiväkirjamerkinnät kahdelta viimeiseltä päivältä. Sijainteja siinä ei ole. Valitse, minne lähetät sen — sähköposti tai viestisovellus — ja kuvaa, mitä tapahtui.';

  @override
  String get problemSend => 'Lähetä';

  @override
  String get problemSubject => 'TachoGo — ongelma beetassa';

  @override
  String get problemPrompt => 'Mitä tapahtui ja milloin (omin sanoin):';

  @override
  String get problemFailed => 'Lähetystä ei voitu avata. Yritä uudelleen.';
}
