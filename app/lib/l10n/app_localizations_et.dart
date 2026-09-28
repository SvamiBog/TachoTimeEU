// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Estonian (`et`).
class AppLocalizationsEt extends AppLocalizations {
  AppLocalizationsEt([String locale = 'et']) : super(locale);

  @override
  String get appTitle => 'TachoGo';

  @override
  String get navHome => 'Avaleht';

  @override
  String get navJournal => 'Päevik';

  @override
  String get navSettings => 'Seaded';

  @override
  String get navMore => 'Veel';

  @override
  String get close => 'Sulge';

  @override
  String get back => 'Tagasi';

  @override
  String ofLimit(String limit) {
    return 'max $limit';
  }

  @override
  String get premiumLock => 'Saadaval Premiumis';

  @override
  String hoursShort(int hours) {
    return '$hours t';
  }

  @override
  String daysShort(int days) {
    return '$days p';
  }

  @override
  String spokenHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tundi',
      one: '$count tund',
    );
    return '$_temp0';
  }

  @override
  String spokenMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutit',
      one: '$count minut',
    );
    return '$_temp0';
  }

  @override
  String spokenOverrun(String duration) {
    return 'ületatud $duration võrra';
  }

  @override
  String get modeDriving => 'Sõit';

  @override
  String get modeRest => 'Puhkus';

  @override
  String get modeWork => 'Töö';

  @override
  String get modeWorkFull => 'Muu töö';

  @override
  String get modeAvailability => 'Valmisolek';

  @override
  String get modeNone => 'Režiim valimata';

  @override
  String modeSince(String time) {
    return 'alates $time';
  }

  @override
  String get switchFailed => 'Režiimi ei salvestatud. Proovige uuesti.';

  @override
  String homeShiftSince(String date, String time) {
    return '$date · vahetus alates $time';
  }

  @override
  String homeNoShift(String date) {
    return '$date · vahetus pole alanud';
  }

  @override
  String get homeLoadError =>
      'Päevikut ei õnnestunud avada. Taaskäivitage rakendus — kui see ei aita, kirjutage meile menüü „Veel“ kaudu.';

  @override
  String get heroUntilBreak => 'Vaheajani';

  @override
  String get heroBreak => 'Vaheaeg';

  @override
  String get heroDailyRest => 'Igapäevane puhkeaeg';

  @override
  String get heroWeeklyRest => 'Iganädalane puhkeaeg';

  @override
  String heroContinuousOf(String time, String limit) {
    return 'vaheajata $time / $limit';
  }

  @override
  String get heroOffDutyHint =>
      'Vahetus on lõppenud. Järgmine algab esimese režiimiga, mis pole puhkus.';

  @override
  String get bannerBreakNeeded45 =>
      'Vaja on 45-minutilist vaheaega (või jagatult 15 + 30)';

  @override
  String get bannerBreakNeeded30 =>
      'Vaja on 30-minutilist vaheaega — jagatud 15 + 30 teine osa';

  @override
  String bannerOnBreak(String time, int required) {
    return 'Vaheaeg $time / $required min';
  }

  @override
  String bannerBreakCounted(String limit) {
    return 'Vaheaeg arvestatud — võite sõita $limit';
  }

  @override
  String get sectionAlerts => 'Hoiatused';

  @override
  String get sectionToday => 'Täna';

  @override
  String get sectionRest => 'Puhkus';

  @override
  String get sectionWeek => 'Nädal';

  @override
  String get rowContinuous => 'Sõit vaheajata';

  @override
  String get chipBreakSoon => 'varsti vaheaeg';

  @override
  String get chipExceeded => 'ületatud';

  @override
  String get chipLimiting => 'piirab';

  @override
  String get chipShiftSoon => 'varsti lõpp';

  @override
  String get chipLimitSoon => 'varsti piir';

  @override
  String get chipRestSoon => 'varsti puhkus';

  @override
  String chipTimes(int hours, int count) {
    return '$hours t ×$count';
  }

  @override
  String limitOf(String limit) {
    return 'piir $limit';
  }

  @override
  String leftUntil(String left, String time) {
    return 'jäänud $left → $time';
  }

  @override
  String left(String left) {
    return 'jäänud $left';
  }

  @override
  String limitLeft(int hours, String left) {
    return '$hours t: jäänud $left';
  }

  @override
  String limitLeftUntil(int hours, String left, String time) {
    return '$hours t: jäänud $left → $time';
  }

  @override
  String limitUntil(int hours, String time) {
    return '$hours t → $time';
  }

  @override
  String get rowWorkday => 'Tööpäev';

  @override
  String get workdayNoShift => 'Vahetus pole alanud';

  @override
  String get rowDailyDriving => 'Igapäevane sõiduaeg';

  @override
  String get rowBreak => 'Vaheaeg';

  @override
  String breakTaken(int minutes, String time) {
    return 'Peetud $minutes min kell $time';
  }

  @override
  String breakStillNeeded(int minutes) {
    return 'Veel $minutes min';
  }

  @override
  String get breakNotTaken => 'Vaheaega pole veel olnud';

  @override
  String breakResting(String time, int required) {
    return 'Praegu vaheaeg $time / $required min';
  }

  @override
  String get rowDailyRest => 'Igapäevane puhkeaeg';

  @override
  String get dailyRestCaption => '11 t regulaarne · 9 t vähendatud';

  @override
  String get dailyRestSplit => '3 + 9';

  @override
  String get rowWeeklyRest => 'Iganädalane puhkeaeg';

  @override
  String get weeklyRestCaption => '45 t regulaarne · 24 t vähendatud';

  @override
  String get chipReducedAvailable => '24 t lubatud';

  @override
  String get chipReducedUnavailable => 'ainult 45 t';

  @override
  String get statusNotStarted => 'pole alanud';

  @override
  String statusInProgress(String time) {
    return 'käib $time';
  }

  @override
  String statusBy(String when) {
    return 'hiljemalt $when';
  }

  @override
  String get statusNoData => 'andmed puuduvad';

  @override
  String get rowWeeklyDriving => 'Iganädalane sõiduaeg';

  @override
  String get rowFortnightDriving => 'Kahe nädala sõiduaeg';

  @override
  String get rowWorkWeek => 'Töönädal';

  @override
  String workWeekSince(String since) {
    return 'alates $since';
  }

  @override
  String get workWeekUnknown => 'Eelmise iganädalase puhkeaja andmed puuduvad';

  @override
  String get cardTitle => 'Kaardi allalaadimine';

  @override
  String cardCaption(String last, String due) {
    return 'viimati $last · tähtaeg $due';
  }

  @override
  String get cardNever => 'Märkige viimane allalaadimine';

  @override
  String cardSheetLast(String date) {
    return 'Viimane allalaadimine: $date';
  }

  @override
  String get cardSheetNever => 'Allalaadimist pole veel märgitud.';

  @override
  String get cardSheetRule =>
      'Juhikaardi andmed tuleb alla laadida vähemalt iga 28 päeva järel (määrus (EL) nr 581/2010).';

  @override
  String get cardMarkToday => 'Laaditud täna';

  @override
  String get cardMarked => 'Allalaadimine märgitud';

  @override
  String get workdayStart => 'Vahetuse algus';

  @override
  String workdayRegular(int hours) {
    return '$hours t — tavaline päev';
  }

  @override
  String workdayRegularHint(String left) {
    return 'siis regulaarne 11 t puhkeaeg · jäänud $left';
  }

  @override
  String workdayExtended(int hours) {
    return '$hours t — pikendatud päev';
  }

  @override
  String workdayExtendedHint(int count) {
    return 'siis vähendatud 9 t puhkeaeg · jäänud ×$count';
  }

  @override
  String get workdayRule =>
      'Igapäevane puhkeaeg peab lõppema 24 tunni jooksul vahetuse algusest. Vähendatud 9 t puhkeaega võib iganädalaste puhkeaegade vahel võtta kõige rohkem kolm korda.';

  @override
  String get workdayEndDay => 'Lõpeta päev';

  @override
  String get workdayEndDayHint =>
      'Puhkeaeg algab kohe ja lõpetab vahetuse, isegi kui see on lühem kui 9 t.';

  @override
  String todayDate(String date) {
    return 'Täna, $date';
  }

  @override
  String infrArticle(String regulation, String article) {
    return 'EL $regulation · art $article';
  }

  @override
  String get infrContinuousExceededTitle => 'Pidev sõit ületatud';

  @override
  String infrContinuousExceededText(String limit, String time, int required) {
    return 'Sõit vaheajata on $limit piirist $time võrra pikem. Peatuge ja pidage $required-minutiline vaheaeg.';
  }

  @override
  String get infrBreakSoonTitle => 'Varsti vaheaeg';

  @override
  String infrBreakSoonText(String limit, String time, int required) {
    return '$limit piirini on jäänud $time. Vaja on $required-minutilist vaheaega.';
  }

  @override
  String get infrDailyDriveExceededTitle => 'Igapäevane sõiduaeg ületatud';

  @override
  String infrDailyDriveExceededText(String limit, String time) {
    return '$limit piirist üle $time võrra. Alustage igapäevast puhkeaega.';
  }

  @override
  String get infrDailyDriveSoonTitle => 'Igapäevane sõiduaeg saab otsa';

  @override
  String infrDailyDriveSoonText(String limit, String time) {
    return '$limit piirini on jäänud $time.';
  }

  @override
  String get infrExtensionInUseTitle => 'Kasutusel pikendus 10 tunnini';

  @override
  String infrExtensionInUseText(int count) {
    return 'Sel nädalal on pikendusi jäänud: $count.';
  }

  @override
  String get infrShiftExceededTitle => 'Tööpäev ületatud';

  @override
  String infrShiftExceededText(String limit, String time) {
    return 'Vahetus on $limit piirist $time võrra pikem. Alustage igapäevast puhkeaega.';
  }

  @override
  String get infrShiftSoonTitle => 'Tööpäev lõpeb varsti';

  @override
  String infrShiftSoonText(String time) {
    return 'Alustage igapäevast puhkeaega $time pärast.';
  }

  @override
  String get infrWeeklyDriveExceededTitle => 'Iganädalane sõiduaeg ületatud';

  @override
  String infrWeeklyDriveExceededText(String limit, String time) {
    return '$limit piirist üle $time võrra.';
  }

  @override
  String get infrWeeklyDriveSoonTitle => 'Iganädalane sõiduaeg saab otsa';

  @override
  String infrWeeklyDriveSoonText(String limit, String time) {
    return '$limit piirini on jäänud $time.';
  }

  @override
  String get infrFortnightDriveExceededTitle => 'Kahe nädala sõiduaeg ületatud';

  @override
  String infrFortnightDriveExceededText(String limit, String time) {
    return '$limit piirist üle $time võrra.';
  }

  @override
  String get infrFortnightDriveSoonTitle => 'Kahe nädala sõiduaeg saab otsa';

  @override
  String infrFortnightDriveSoonText(String limit, String time) {
    return '$limit piirini on jäänud $time.';
  }

  @override
  String get infrWeeklyRestOverdueTitle => 'Iganädalane puhkeaeg hilinenud';

  @override
  String infrWeeklyRestOverdueText(String time) {
    return 'Eelmisest iganädalasest puhkeajast on möödunud üle 144 t — $time võrra.';
  }

  @override
  String get infrWeeklyRestSoonTitle => 'Varsti iganädalane puhkeaeg';

  @override
  String infrWeeklyRestSoonText(String time) {
    return 'Alustage iganädalast puhkeaega $time pärast.';
  }

  @override
  String get infrWeeklyRestContinueTitle => 'Ärge katkestage puhkeaega';

  @override
  String infrWeeklyRestContinueText(String time) {
    return 'Iganädalase puhkeaja tähtaeg on möödunud. Puhake veel $time, et see arvestataks iganädalaseks.';
  }

  @override
  String get infrCompensationSoonTitle => 'Varsti hüvitamise tähtaeg';

  @override
  String infrCompensationSoonText(String time, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days päeva',
      one: '$days päeva',
    );
    return 'Lisage $time vähemalt 9 t puhkeajale. Tähtaeg $_temp0 pärast.';
  }

  @override
  String get infrCompensationOverdueTitle => 'Hüvitamine hilinenud';

  @override
  String infrCompensationOverdueText(String time, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days päeva',
      one: '$days päev',
    );
    return 'Vähendatud iganädalase puhkeaja eest jäi $time lisamata. Hilinenud $_temp0.';
  }

  @override
  String get infrReducedRestsExceededTitle =>
      'Liiga palju vähendatud puhkeaegu';

  @override
  String infrReducedRestsExceededText(int count) {
    return 'Vähendatud puhkeaegu pärast iganädalast: $count, lubatud 3.';
  }

  @override
  String get infrCardOverdueTitle => 'Kaardi allalaadimine hilinenud';

  @override
  String infrCardOverdueText(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days päeva',
      one: '$days päev',
    );
    return '28 päeva tähtaeg möödus $_temp0 tagasi.';
  }

  @override
  String get infrCardSoonTitle => 'Varsti kaardi allalaadimine';

  @override
  String infrCardSoonText(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days päeva',
      one: '$days päev',
    );
    return 'Jäänud $_temp0.';
  }

  @override
  String get ferryTitle => 'Parvlaev / rong';

  @override
  String get ferryHint =>
      'Puhkeaega võib katkestada kõige rohkem kaks korda, kokku kuni 1 t (art 9). Parvlaeva liikumine sõitu sisse ei lülita.';

  @override
  String get ferryOn => 'parvlaev';

  @override
  String breakHero(String limit) {
    return 'Vaheaeg pärast $limit sõitu';
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
    return '$minutes min — jäänud';
  }

  @override
  String breakFirstTaken(String from, String to) {
    return 'Esimene osa peetud $from–$to';
  }

  @override
  String get breakNone =>
      'Vaja on 45-minutilist vaheaega korraga või 15 + 30 min.';

  @override
  String get breakSplitTitle => 'Jagatud vaheaeg 15 + 30';

  @override
  String get breakSplitText =>
      'Esimene osa vähemalt 15 min, teine vähemalt 30 min, just selles järjekorras. Rakendus tunneb selle ise ära.';

  @override
  String get breakStart => 'Alusta vaheaega';

  @override
  String get breakOngoing => 'Vaheaeg käib';

  @override
  String get weeklyStartBy => 'Alustage hiljemalt';

  @override
  String weeklyInTime(String left) {
    return '$left pärast — töönädala lõpp (144 t)';
  }

  @override
  String weeklyOverdue(String time) {
    return 'hilinenud $time';
  }

  @override
  String get weeklyOngoing => 'Iganädalane puhkeaeg käib';

  @override
  String get weeklyUnknown =>
      'Eelmise iganädalase puhkeaja andmed puuduvad. Tähtaeg ilmub pärast vähemalt 24 t puhkeaega.';

  @override
  String get weeklyNext => 'Järgmine puhkeaeg';

  @override
  String get weeklyFull => 'Regulaarne';

  @override
  String get weeklyFullHint => 'mitte kabiinis';

  @override
  String get weeklyReduced => 'Vähendatud';

  @override
  String get weeklyReducedYes => 'lubatud · hüvitamisega';

  @override
  String get weeklyReducedNo => 'pole lubatud — vaja regulaarset';

  @override
  String get weeklyHistory => 'Ajalugu';

  @override
  String weeklyPrevious(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'full': 'regulaarne',
      'reduced': 'vähendatud',
      'other': 'ebapiisav',
    });
    return 'Eelmine · $_temp0';
  }

  @override
  String get weeklyNow => 'praegu';

  @override
  String get weeklyCompensation => 'Hüvitamise võlg';

  @override
  String get weeklyCompensationNone => 'puudub';

  @override
  String weeklyCompensationValue(String time, String date) {
    return '$time hiljemalt $date';
  }

  @override
  String get weeklyMobilityOn =>
      'Liikuvuspakett sees: rahvusvahelisel veol on lubatud kaks vähendatud puhkeaega järjest, kui need võetakse väljaspool registreerimisriiki. Vähendamine hüvitatakse kolmanda nädala lõpuks.';

  @override
  String get weeklyMobilityOff =>
      'Vähendatud iganädalane puhkeaeg hüvitatakse kolmanda nädala lõpuks: võlg lisatakse vähemalt 9 t puhkeajale.';

  @override
  String get weeklyStartRest => 'Alusta puhkeaega';

  @override
  String get countryTitle => 'Valige riik';

  @override
  String countryChip(String start, String end) {
    return 'Algusriik $start, lõpp $end. Muuda';
  }

  @override
  String countryChipNoEnd(String start) {
    return 'Algusriik $start, lõpp valimata. Muuda';
  }

  @override
  String get countryChipNone => 'Vahetuse riik valimata. Vali';

  @override
  String countryStartTab(String code) {
    return 'Algus · $code';
  }

  @override
  String countryEndTab(String code) {
    return 'Lõpp · $code';
  }

  @override
  String get countryNextShift => 'Järgmise vahetuse riik';

  @override
  String get countrySearch => 'Riik või kood';

  @override
  String get countryRecent => 'Viimased';

  @override
  String get countryClearEnd => 'Ära märgi';

  @override
  String get countryNotFound => 'Midagi ei leitud';

  @override
  String get countryFooter =>
      'Juht sisestab riigi sõidumeerikusse vahetuse alguses ja lõpus (määrus (EL) nr 165/2014, art 34).';

  @override
  String countryName(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'A': 'Austria',
      'AL': 'Albaania',
      'AND': 'Andorra',
      'ARM': 'Armeenia',
      'AZ': 'Aserbaidžaan',
      'B': 'Belgia',
      'BG': 'Bulgaaria',
      'BIH': 'Bosnia ja Hertsegoviina',
      'BY': 'Valgevene',
      'CH': 'Šveits',
      'CY': 'Küpros',
      'CZ': 'Tšehhi',
      'D': 'Saksamaa',
      'DK': 'Taani',
      'E': 'Hispaania',
      'EST': 'Eesti',
      'F': 'Prantsusmaa',
      'FIN': 'Soome',
      'FL': 'Liechtenstein',
      'GE': 'Gruusia',
      'GR': 'Kreeka',
      'H': 'Ungari',
      'HR': 'Horvaatia',
      'I': 'Itaalia',
      'IRL': 'Iirimaa',
      'IS': 'Island',
      'KZ': 'Kasahstan',
      'L': 'Luksemburg',
      'LT': 'Leedu',
      'LV': 'Läti',
      'M': 'Malta',
      'MC': 'Monaco',
      'MD': 'Moldova',
      'MK': 'Põhja-Makedoonia',
      'MNE': 'Montenegro',
      'N': 'Norra',
      'NL': 'Madalmaad',
      'P': 'Portugal',
      'PL': 'Poola',
      'RO': 'Rumeenia',
      'RSM': 'San Marino',
      'RUS': 'Venemaa',
      'S': 'Rootsi',
      'SK': 'Slovakkia',
      'SLO': 'Sloveenia',
      'SRB': 'Serbia',
      'TJ': 'Tadžikistan',
      'TM': 'Türkmenistan',
      'TR': 'Türgi',
      'UA': 'Ukraina',
      'UK': 'Suurbritannia',
      'UZ': 'Usbekistan',
      'V': 'Vatikan',
      'other': '$code',
    });
    return '$_temp0';
  }

  @override
  String get journalExport => 'Aruande eksport';

  @override
  String get journalCurrent => 'praegune';

  @override
  String get journalDriving => 'Sõiduaeg';

  @override
  String get journalFortnight => '2 nädalat';

  @override
  String journalOf(int limit) {
    return 'max $limit';
  }

  @override
  String get journalCollapsedDriving => 'sõit';

  @override
  String journalWeekSpoken(String range, String driving, String fortnight) {
    return 'Nädal $range. Sõiduaeg $driving 56 tunnist, kahe nädala jooksul $fortnight 90 tunnist';
  }

  @override
  String get journalShift => 'Vahetus';

  @override
  String get journalWeeklyShort => 'näd.';

  @override
  String get journalOngoing => 'käib';

  @override
  String get journalManual => 'käsitsi';

  @override
  String get journalAddShift => 'Vahetus';

  @override
  String get journalAddShiftSpoken => 'Lisa vahetus';

  @override
  String get journalEmpty =>
      'Vahetusi pole veel. Need ilmuvad, kui hakkate režiime vahetama — või lisage vahetus käsitsi.';

  @override
  String restStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'full': 'regulaarne',
      'reduced': 'vähendatud',
      'other': 'ebapiisav',
    });
    return '$_temp0';
  }

  @override
  String journalWeeklyRest(String status) {
    return 'Iganädalane puhkeaeg · $status';
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
    return '$date, $route, $time. Sõiduaeg $driving, vahetus $span, puhkeaeg $rest';
  }

  @override
  String get journalRestNone => 'puudub';

  @override
  String get journalRestWeekly => 'iganädalane';

  @override
  String get journalLoadError =>
      'Päevikut ei õnnestunud avada. Taaskäivitage rakendus — kui see ei aita, kirjutage meile menüü „Veel“ kaudu.';

  @override
  String get dayTitle => 'Vahetus';

  @override
  String get daySummary => 'Kokkuvõte';

  @override
  String get dayModes => 'Režiimid';

  @override
  String get dayBreaks => 'Vaheajad';

  @override
  String get dayContinuousAtEnd => 'Vaheajata vahetuse lõpus';

  @override
  String get dayRestAfter => 'Puhkeaeg pärast vahetust';

  @override
  String dayRestKind(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'daily': 'Igapäevane',
      'weekly': 'Iganädalane',
      'other': 'Pole alanud',
    });
    return '$_temp0';
  }

  @override
  String get daySplitRest => 'jagatud 3 + 9';

  @override
  String get dayManualHint =>
      'Vahetus on sisestatud käsitsi kokkuvõttena — režiimide kirjeid pole.';

  @override
  String get dayNotes => 'Märkused';

  @override
  String get dayEndMark => 'päeva lõpp';

  @override
  String get dayEdit => 'Muuda vahetust';

  @override
  String get dayNotFound => 'Seda vahetust päevikus enam pole.';

  @override
  String dayRestUntil(String time) {
    return 'kuni $time';
  }

  @override
  String get save => 'Salvesta';

  @override
  String get cancel => 'Tühista';

  @override
  String get done => 'Valmis';

  @override
  String get delete => 'Kustuta';

  @override
  String get unitHours => 't';

  @override
  String get unitMinutes => 'min';

  @override
  String get pickerHours => 'Tunnid';

  @override
  String get pickerMinutes => 'Minutid';

  @override
  String get pickerTime => 'Kellaaeg';

  @override
  String get pickerPrevMonth => 'Eelmine kuu';

  @override
  String get pickerNextMonth => 'Järgmine kuu';

  @override
  String pickerRange(String min, String max) {
    return 'Lubatud $min kuni $max';
  }

  @override
  String get shiftNewTitle => 'Uus vahetus';

  @override
  String get shiftSection => 'Vahetus';

  @override
  String get shiftStart => 'Algus';

  @override
  String get shiftEnd => 'Lõpp';

  @override
  String get shiftOnRoad => 'teel';

  @override
  String get shiftChoose => 'Vali';

  @override
  String get shiftNowOngoing => 'Praegu (käib)';

  @override
  String get shiftDuration => 'Kestus';

  @override
  String get shiftNowSuffix => 'praegu';

  @override
  String shiftCountrySpoken(String side, String code) {
    return '$side: riik $code. Muuda';
  }

  @override
  String shiftDateSpoken(String side, String date, String time) {
    return '$side: $date, $time. Muuda';
  }

  @override
  String get shiftDriving => 'Sõiduaeg';

  @override
  String get shiftPerDay => 'Päevas';

  @override
  String get shiftLiveContinuous => 'arvutatakse vaheaegade järgi';

  @override
  String get shiftRestNone => 'Pole alanud';

  @override
  String get shiftRestDaily => 'Igapäevane';

  @override
  String get shiftRestWeekly => 'Iganädalane';

  @override
  String get shiftSplit => 'Jagatud puhkeaeg 3 + 9';

  @override
  String get shiftSplitHint => 'Kõigepealt 3 t, siis 9 t';

  @override
  String shiftRestUntilNext(String when) {
    return 'Vahetuse alguseni: $when';
  }

  @override
  String get shiftRestAutoHint => 'Kestab järgmise vahetuse alguseni';

  @override
  String get shiftRestCountsWeekly =>
      'Alates 24 tunnist arvestatakse puhkeaeg iganädalaseks';

  @override
  String get shiftNotesHint => 'Näiteks: parvlaev, laadimise ootamine';

  @override
  String get shiftDelete => 'Kustuta vahetus';

  @override
  String get shiftDeleteTitle => 'Kustutada vahetus?';

  @override
  String get shiftDeleteManual => 'Vahetus eemaldatakse päevikust.';

  @override
  String get shiftDeleteRecorded =>
      'Kõik selle vahetuse režiimide kirjed kustutatakse. Seda ei saa tagasi võtta.';

  @override
  String get shiftErrStartCountry => 'Valige riik, kus vahetus algab';

  @override
  String get shiftErrEndCountry => 'Märkige riik, kus vahetus lõpeb';

  @override
  String get shiftErrEndBeforeStart => 'Vahetus lõpeb enne, kui algab';

  @override
  String get shiftErrFuture => 'Vahetuse aeg ei saa olla tulevikus';

  @override
  String get shiftErrTooLong => 'Vahetus on üle 30 t — kontrollige kuupäevi';

  @override
  String get shiftErrDrivingTooLong => 'Sõiduaeg on vahetusest pikem';

  @override
  String get shiftErrContinuous =>
      'Pidev sõit on igapäevasest sõiduajast pikem';

  @override
  String shiftErrOverlap(String range) {
    return 'Kattub vahetusega $range';
  }

  @override
  String get shiftErrNotLast =>
      'Pärast seda on teisi vahetusi — see ei saa praegu kesta';

  @override
  String get shiftSaveFailed => 'Salvestamine ebaõnnestus. Proovige uuesti.';

  @override
  String get shiftSavedViolations => 'Vahetus salvestatud. On rikkumisi';

  @override
  String get shiftSavedViolationsText =>
      'Kontrollige aegu. Kui kõik on õige, ilmuvad rikkumised päevikusse ja aruandesse.';

  @override
  String get gotIt => 'Selge';

  @override
  String get shiftLiveHint =>
      'Vahetus järgib režiimide kirjeid: alguse, lõpu või sõiduaja muutmine nihutab kirjeid endid.';

  @override
  String get shiftConvertHint =>
      'Aeg, sõiduaeg või puhkeaeg muutus — vahetus salvestatakse režiimide kirjete asemel käsitsi kirjena.';

  @override
  String shiftEndNowHint(String time) {
    return 'Vahetus lõpeb kell $time, seejärel algab puhkeaeg.';
  }

  @override
  String get shiftResumeHint =>
      'Vahetusejärgne puhkeaeg kustutatakse — vahetus jätkub.';

  @override
  String shiftOngoingHint(String time, String mode) {
    return 'Vahetus muutub praeguseks ja jätkub avalehel alates $time. Režiim „$mode“ — kui praegu kehtib muu, vahetage see seal.';
  }

  @override
  String get shiftUnsavedTitle => 'Salvestada muudatused?';

  @override
  String get shiftUnsavedText =>
      'Selle vahetuse muudatused pole veel salvestatud.';

  @override
  String get shiftDiscard => 'Ära salvesta';

  @override
  String get shiftDateTimeTitle => 'Vahetuse kuupäev ja kellaaeg';

  @override
  String driveEditSubtitle(String date) {
    return 'Käsitsi parandus · $date';
  }

  @override
  String get driveEditComputed => 'Rakenduse arvutus';

  @override
  String driveEditDiff(String diff) {
    return '$diff võrreldes arvutusega.';
  }

  @override
  String get driveEditNoChange => 'Aeg ei muutunud.';

  @override
  String get driveEditHint =>
      'Kasutage, kui režiim vahetati valel ajal — piirid arvutatakse ümber.';

  @override
  String get driveEditNoDrive =>
      'Praeguses vahetuses pole veel sõitu — pole midagi parandada.';

  @override
  String get breakCorrection => 'Parandus';

  @override
  String get breakCurrentDuration => 'Praegune vaheaeg';

  @override
  String get breakLastDuration => 'Viimane vaheaeg';

  @override
  String get breakNoBreak =>
      'Vahetuses pole veel vaheaega — pole midagi parandada.';

  @override
  String get breakEditHint =>
      'Aeg võetakse naaberkirjest — piirid arvutatakse ümber.';

  @override
  String get workdayChangeStart => 'Muuda vahetuse algust';

  @override
  String get weeklyAddManually => 'Sisesta käsitsi';

  @override
  String get exportPeriod => 'Periood';

  @override
  String get exportWeek => 'See nädal';

  @override
  String get exportTwoWeeks => '2 nädalat';

  @override
  String get exportDays28 => '28 päeva';

  @override
  String get exportCustom => 'Oma periood';

  @override
  String get exportFrom => 'Alates';

  @override
  String get exportTo => 'Kuni';

  @override
  String exportFromDay(String date) {
    return 'Alates $date';
  }

  @override
  String exportToDay(String date) {
    return 'Kuni $date';
  }

  @override
  String get exportFormat => 'Vorming';

  @override
  String get exportPdf => 'PDF · kontrolliks';

  @override
  String get exportCsv => 'CSV · tabel';

  @override
  String get exportPdfHint =>
      'Pole ametlik dokument: aruanne ei asenda sõidumeeriku ja juhikaardi andmeid.';

  @override
  String get exportCsvHint =>
      'Režiimide kirjed rida-realt, aeg UTC-s — Exceli ja raamatupidamistarkvara jaoks.';

  @override
  String get exportLanguage => 'Aruande keel';

  @override
  String get exportNotes => 'Riigid ja märkused';

  @override
  String get exportCreate => 'Koosta aruanne';

  @override
  String exportCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vahetust',
      one: '$count vahetus',
    );
    return 'Aruandes $_temp0';
  }

  @override
  String get exportEmpty => 'Valitud perioodil pole vahetusi.';

  @override
  String get exportFailed =>
      'Aruannet ei õnnestunud koostada. Proovige uuesti.';

  @override
  String exportRangeSpoken(String from, String to) {
    return 'Periood $from kuni $to';
  }

  @override
  String get reportTitle => 'Sõidu- ja puhkeaja aruanne';

  @override
  String get reportSubtitle => 'Määrus (EÜ) nr 561/2006 ja AETR-kokkulepe';

  @override
  String get reportDriver => 'Juht';

  @override
  String get reportCard => 'Juhikaart';

  @override
  String get reportVehicle => 'Registreerimisnumber';

  @override
  String get reportCompany => 'Vedaja';

  @override
  String get reportPeriod => 'Periood';

  @override
  String get reportGenerated => 'Koostatud';

  @override
  String reportTimezone(String zone) {
    return 'Kellaajad telefoni ajavööndis ($zone). Aruande päevad ja nädalad UTC-s, nädal algab esmaspäeval kell 00:00, nagu sõidumeerikus.';
  }

  @override
  String get reportDate => 'Kuupäev';

  @override
  String get reportStart => 'Algus';

  @override
  String get reportEnd => 'Lõpp';

  @override
  String get reportCountries => 'Riigid';

  @override
  String get reportDriving => 'Sõiduaeg';

  @override
  String get reportWork => 'Töö';

  @override
  String get reportAvailability => 'Valm.';

  @override
  String get reportBreaks => 'Vaheajad';

  @override
  String get reportSpan => 'Vahetus';

  @override
  String get reportRestAfter => 'Puhkeaeg pärast';

  @override
  String get reportNotes => 'Märkused';

  @override
  String reportWeek(String range) {
    return 'Nädal $range';
  }

  @override
  String reportWeekTotal(String driving, String fortnight) {
    return 'Kokku: sõiduaeg $driving 56 tunnist · 2 nädala jooksul $fortnight 90 tunnist';
  }

  @override
  String get reportViolations => 'Rikkumised';

  @override
  String get reportNoViolations => 'Päeviku järgi rikkumisi pole.';

  @override
  String reportViolationDrive(String date, String time) {
    return '$date: igapäevane sõiduaeg $time — üle 10 t';
  }

  @override
  String reportViolationSpan(String date, String time, int limit) {
    return '$date: tööpäev $time — üle $limit t';
  }

  @override
  String reportViolationRest(String date, String time) {
    return '$date: puhkeaeg pärast vahetust $time — ebapiisav';
  }

  @override
  String reportViolationWeek(String range, String time) {
    return 'Nädal $range: sõiduaeg $time — üle 56 t';
  }

  @override
  String reportViolationFortnight(String range, String time) {
    return 'Nädal $range: kahe nädala jooksul $time — üle 90 t';
  }

  @override
  String get reportMarks => 'Tähised';

  @override
  String get reportMarkWarn =>
      '! — sõiduaeg pikendatud 10 tunnini, tööpäev üle 13 t või vähendatud puhkeaeg';

  @override
  String get reportMarkBad => '!! — rikkumine';

  @override
  String get reportMarkManual => '* — vahetus sisestatud käsitsi kokkuvõttena';

  @override
  String get reportDisclaimer =>
      'Aruanne põhineb juhi sisestustel rakenduses TachoGo. Pole ametlik dokument: ei asenda sõidumeeriku ja juhikaardi andmeid.';

  @override
  String get reportSignature => 'Juhi allkiri';

  @override
  String reportPage(int page, int pages) {
    return 'Lehekülg $page / $pages';
  }

  @override
  String get openSystemSettings => 'Ava seaded';

  @override
  String get settingsGeneral => 'Üldine';

  @override
  String get settingsLanguage => 'Keel';

  @override
  String get settingsLanguageSystem => 'Nagu telefonis';

  @override
  String get settingsTheme => 'Välimus';

  @override
  String get themeSystem => 'Süsteemne';

  @override
  String get themeLight => 'Hele';

  @override
  String get themeDark => 'Tume';

  @override
  String get settingsRules => 'Reeglid';

  @override
  String get settingsTachograph => 'Sõidumeerik sõidukis';

  @override
  String get tachographDigital => 'Digitaalne';

  @override
  String get tachographAnalog => 'Analoog';

  @override
  String get settingsMobility => 'Liikuvuspakett';

  @override
  String get settingsMobilityHint =>
      'Kaks vähendatud iganädalast puhkeaega järjest rahvusvahelisel veol';

  @override
  String get settingsCrew => 'Kahe juhiga meeskond';

  @override
  String get settingsCrewHint =>
      'Igapäevane puhkeaeg 9 t 30 tunni jooksul vahetuse algusest';

  @override
  String get settingsNotifications => 'Teavitused';

  @override
  String get settingsWarnLead => 'Hoiata piiridest';

  @override
  String get settingsWarnLeadHint => 'Vaheaeg, päeva lõpp, sõiduaeg';

  @override
  String get settingsWarnLeadGroup => 'Hoiata ette';

  @override
  String leadMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String leadHours(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours tundi',
      one: '$hours tund',
    );
    return '$_temp0';
  }

  @override
  String get notifyBreak => 'Vaheaeg';

  @override
  String get notifyShiftEnd => 'Tööpäeva lõpp';

  @override
  String get notifyShiftEndHint => 'Igapäevane ja iganädalane puhkeaeg';

  @override
  String get notifyDriving => 'Sõiduaja piir';

  @override
  String get notifyCard => 'Kaardi allalaadimine';

  @override
  String get notifyCardHint => 'Iga 28 päeva järel';

  @override
  String get notifyCardLead => 'Ette';

  @override
  String get notifyCardLeadGroup => 'Kaardi allalaadimisest hoiatada ette';

  @override
  String leadDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days päeva',
      one: '$days päev',
    );
    return '$_temp0';
  }

  @override
  String get notifyAllow => 'Luba teavitused';

  @override
  String get notifyDenied => 'Teavitused on telefonis praegu keelatud';

  @override
  String get notifyAllowed => 'Teavitused lubatud';

  @override
  String get notifyExact => 'Täpne teavituse aeg';

  @override
  String get notifyExactHint =>
      'Lubage „Alarmid ja meeldetuletused“ — muidu võib telefon hoiatust edasi lükata';

  @override
  String get notifyChannelLimits => 'Piirid ja rikkumised';

  @override
  String get notifyChannelLimitsHint =>
      'Vaheaeg, tööpäeva lõpp, sõiduaeg, iganädalane puhkeaeg, kaart';

  @override
  String get notifyChannelRest => 'Puhkeaeg arvestatud';

  @override
  String get notifyChannelRestHint =>
      'Vaheaeg arvestatud, igapäevane ja iganädalane puhkeaeg arvestatud';

  @override
  String get notifyBreakTakenTitle => 'Vaheaeg arvestatud';

  @override
  String notifyBreakTakenText(int required, String time) {
    return '$required-minutiline vaheaeg on arvestatud. Järgmise vaheajani võite sõita $time.';
  }

  @override
  String get notifyDailyRestTakenTitle => 'Igapäevane puhkeaeg arvestatud';

  @override
  String notifyDailyRestTakenText(String limit) {
    return 'Regulaarne puhkeaeg $limit — võite alustada vahetust.';
  }

  @override
  String get notifyWeeklyRestTakenTitle => 'Iganädalane puhkeaeg arvestatud';

  @override
  String notifyWeeklyRestTakenText(String limit) {
    return 'Regulaarne puhkeaeg $limit — võite alustada uut töönädalat.';
  }

  @override
  String get serviceChannel => 'Sõidu automaatne tuvastamine';

  @override
  String get serviceChannelHint =>
      'Praegune režiim ja loendurid, kui automaatne tuvastamine on sees';

  @override
  String get serviceStarted => 'Sõidu automaatne tuvastamine on sees';

  @override
  String serviceModeTitle(String mode, String time) {
    return '$mode · $time';
  }

  @override
  String get serviceTeamTitle => 'Sõiduk liigub';

  @override
  String serviceTeamText(String time) {
    return 'Kas juhite teie? Sõit alates $time';
  }

  @override
  String get serviceSuggestTitle => 'Tundub, et sõidate';

  @override
  String serviceSuggestText(String time) {
    return 'Alustada sõitu alates $time? Puhkeaeg katkeb';
  }

  @override
  String serviceDriving(String untilBreak, String dayLeft) {
    return 'Vaheajani $untilBreak · täna jäänud $dayLeft';
  }

  @override
  String serviceDrivingOver(String time) {
    return 'Vaja on vaheaega: ületatud $time';
  }

  @override
  String serviceBreakLeft(String time) {
    return 'Täieliku vaheajani $time';
  }

  @override
  String serviceBreakDone(String time) {
    return 'Vaheaeg arvestatud, võite sõita $time';
  }

  @override
  String serviceWorkday(String time, String limit) {
    return 'Tööpäev $time / $limit';
  }

  @override
  String serviceRestLeft(String limit, String time) {
    return 'Täieliku $limit puhkeajani: $time';
  }

  @override
  String get serviceDailyRestDone =>
      'Regulaarne igapäevane puhkeaeg arvestatud';

  @override
  String get serviceWeeklyRestDone =>
      'Regulaarne iganädalane puhkeaeg arvestatud';

  @override
  String get serviceNotStartedText =>
      'Sõit lülitub sisse, kui sõiduk hakkab liikuma';

  @override
  String get serviceNoModeText => 'Avage TachoGo ja valige režiim';

  @override
  String get autoTitle => 'Sõidu automaatne tuvastamine';

  @override
  String get autoSwitch => 'Tuvasta sõit GPS-i järgi';

  @override
  String get autoSwitchHint =>
      'Hakkate liikuma — sõit; peatute — muu töö. Vaja on ainult kiirust: koordinaate ei salvestata.';

  @override
  String get autoAfterStop => 'Pärast peatumist';

  @override
  String get autoAfterStopHint => 'Pärast 3-minutilist seisu';

  @override
  String get autoStartFromRest => 'Sõit kohe pärast puhkeaega';

  @override
  String get autoStartFromRestHint =>
      'Muidu rakendus küsib enne: võisite olla kaassõitja';

  @override
  String get autoBattery => 'Aku säästmine';

  @override
  String get autoBatteryLimited =>
      'Võib tuvastamise peatada. Eemaldage TachoGo säästmise loendist';

  @override
  String get autoBatteryOk => 'Ei sega taustatööd';

  @override
  String get autoAutostart => 'Automaatne käivitus ja taustatöö';

  @override
  String get autoAutostartHint =>
      'Xiaomi, Huawei, Honor, Oppo, Vivo, Samsung: lubage, muidu peatab telefon tuvastamise';

  @override
  String get autoBlockedService =>
      'Asukoht on telefonis välja lülitatud. Lülitage see sisse, et sõitu tuvastada.';

  @override
  String get autoBlockedDenied =>
      'Ilma asukohaloata ei saa sõitu tuvastada. Rakendusele on vaja ainult kiirust, koordinaate ei salvestata.';

  @override
  String get autoBlockedForever =>
      'Asukohaluba on blokeeritud. Lubage see telefoni seadetes: Asukoht → „Rakenduse kasutamise ajal“.';

  @override
  String get autoNoAccess =>
      'Asukohaluba puudub — tuvastamine ei tööta. Lubage see telefoni seadetes.';

  @override
  String get autoEnable => 'Lülita sõidu tuvastamine sisse';

  @override
  String get autoEnabled => 'Sõidu tuvastamine on sees';

  @override
  String get settingsData => 'Andmed';

  @override
  String get settingsExport => 'Aruande eksport';

  @override
  String get settingsExportFormats => 'PDF · CSV';

  @override
  String get settingsAnalytics => 'Anonüümne statistika';

  @override
  String get settingsAnalyticsHint =>
      'Milliseid ekraane juhid avavad — rakenduse parandamiseks. Ilma koordinaatide, nimede ja kaardinumbriteta.';

  @override
  String get settingsClear => 'Kustuta kõik andmed';

  @override
  String get clearTitle => 'Kustutada kõik andmed?';

  @override
  String get clearText =>
      'Režiimide päevik, vahetused, riigid, märkused ja kaardi allalaadimised kustutatakse. Seda ei saa tagasi võtta. Seaded jäävad alles.';

  @override
  String get clearConfirm => 'Kustuta';

  @override
  String get clearDone => 'Andmed kustutatud';

  @override
  String onbStep(int step, int count) {
    return 'Samm $step / $count';
  }

  @override
  String get onbWelcomeTitle => 'Roolis veedetud aeg kontrolli all';

  @override
  String get onbWelcomeText =>
      'Arvestame sõidu-, vahe- ja puhkeaega EL 561/2006 ja AETR reeglite järgi ning hoiatame piiridest ette.';

  @override
  String get onbStart => 'Alusta';

  @override
  String get onbNext => 'Edasi';

  @override
  String get onbDone => 'Valmis';

  @override
  String get onbModesTitle => 'Neli režiimi — nagu sõidumeerikus';

  @override
  String get onbModesText =>
      'Vahetage režiimi avalehe nuppudega. Loendurid töötavad ise — ka siis, kui rakendus on suletud.';

  @override
  String get onbModeDriving =>
      'Roolis. Arvestame pidevat, igapäevast ja iganädalast sõiduaega.';

  @override
  String get onbModeWork => 'Laadimine, sõiduki kontroll, dokumendid.';

  @override
  String get onbModeAvailability =>
      'Ootamine: laadimisjärjekord, piir, teine juht teel.';

  @override
  String get onbModeRest =>
      'Vaheajad ja puhkus. „Lõpeta päev“ sulgeb vahetuse.';

  @override
  String get onbSetupTitle => 'Seadistame teie jaoks';

  @override
  String get onbSetupText => 'Kõike seda saab hiljem seadetes muuta.';

  @override
  String get onbMobilityHint =>
      'Lülitage sisse, kui sõidate rahvusvahelistel liinidel';

  @override
  String onbNotifyText(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutit',
      one: '$minutes minut',
    );
    return 'Hoiatame $_temp0 enne vaheaega ja tööpäeva lõppu — ka siis, kui rakendus on suletud.';
  }

  @override
  String get onbAutoText =>
      'Hakkate liikuma — rakendus lülitab sisse sõidu; peatute — muu töö. Pärast puhkeaega küsib see enne. Vaja on ainult GPS-i kiirust: koordinaate ei salvestata ega saadeta kuhugi.';

  @override
  String get onbAutoLater => 'Saate selle hiljem seadetes sisse lülitada.';

  @override
  String languageButton(String language) {
    return 'Keel: $language';
  }

  @override
  String get settingsVehicle => 'Sõiduk';

  @override
  String get vehicleTruckOrBus => 'Veoauto või buss';

  @override
  String get vehicleVan => 'Kaubik 2,5–3,5 t';

  @override
  String settingsVanHint(String date) {
    return 'Reeglid — alates $date rahvusvahelisel veol ja kabotaažil tasu eest';
  }

  @override
  String onbVanText(String date) {
    return 'Kaubikutele kehtivad EL reeglid alates $date — rahvusvahelisel veol ja kabotaažil tasu eest. Kaubikus on teise põlvkonna nutikas sõidumeerik, juhil on kaart.';
  }

  @override
  String get onbRulesTitle => 'Peamised reeglid';

  @override
  String get onbRulesText =>
      'Samad veoautodele, bussidele ja kaubikutele. Rakendus arvutab need ise ja hoiatab ette.';

  @override
  String get onbRulesMore =>
      'Kõik reeglid selgitustega — „Veel“ → „Juhend ja reeglid“.';

  @override
  String get guideTitle => 'Juhend ja reeglid';

  @override
  String get guideHowTo => 'Kuidas kasutada';

  @override
  String get guideStep1 =>
      'Vahetage režiimi avalehe nuppudega: sõit, puhkus, töö või valmisolek.';

  @override
  String get guideStep2 =>
      'Märkige riik vahetuse alguses ja lõpus — nagu sõidumeerikus.';

  @override
  String get guideStep3 =>
      'Jälgige piire. Rakendus hoiatab ette vaheajast ja päeva lõpust. Iga aega saab käsitsi parandada.';

  @override
  String get guideRules => 'EL 561/2006 ja AETR reeglid';

  @override
  String get guideContinuous => 'Sõit vaheajata';

  @override
  String guideContinuousText(String full, String first, String second) {
    return 'Seejärel vaheaeg $full. Selle võib jagada: kõigepealt $first, siis $second.';
  }

  @override
  String get guideDailyDriving => 'Sõiduaeg päevas';

  @override
  String guideDailyDrivingText(String extended) {
    return 'Kaks korda nädalas on lubatud kuni $extended.';
  }

  @override
  String get guideWeeklyDriving => 'Sõiduaeg nädalas';

  @override
  String guideWeeklyDrivingText(String fortnight) {
    return 'Mis tahes kahe järjestikuse nädala jooksul — kõige rohkem $fortnight.';
  }

  @override
  String get guideDailyRest => 'Igapäevane puhkeaeg';

  @override
  String guideDailyRestText(String reduced, String first, String second) {
    return 'Iganädalaste puhkeaegade vahel võib seda kuni kolm korda vähendada $reduced-ni. Jagatud variant — $first + $second.';
  }

  @override
  String get guideWorkday => 'Tööpäev';

  @override
  String guideWorkdayText(String window, String regular, String reduced) {
    return 'Puhkeaeg peab lõppema $window jooksul vahetuse algusest: regulaarse puhkeajaga $regular, vähendatuga $reduced.';
  }

  @override
  String guideWorkdaySpoken(int first, int second) {
    String _temp0 = intl.Intl.pluralLogic(
      second,
      locale: localeName,
      other: '$second tundi',
      one: '$second tund',
    );
    return '$first või $_temp0';
  }

  @override
  String get guideWeeklyRest => 'Iganädalane puhkeaeg';

  @override
  String guideWeeklyRestText(String reduced) {
    return 'Vähendatud — $reduced, hüvitamisega kolmanda nädala lõpuks. Regulaarset puhkeaega ei tohi veeta kabiinis.';
  }

  @override
  String get guideWorkWeek => 'Töönädal';

  @override
  String guideWorkWeekText(String period) {
    return 'Iganädalane puhkeaeg algab hiljemalt pärast kuut $period perioodi eelmisest.';
  }

  @override
  String get guideCard => 'Juhikaart';

  @override
  String guideCardText(String days) {
    return 'Kaardi andmed tuleb alla laadida vähemalt iga $days järel.';
  }

  @override
  String get guideModes => 'Värvid ja ikoonid';

  @override
  String get guideNewbie => 'Esimest korda sõidumeerikuga';

  @override
  String get guideNewbieCard => 'Kaart on sõidumeerikus kogu vahetuse';

  @override
  String get guideNewbieCardText =>
      'Sisestage kaart vahetuse alguses ja võtke välja lõpus. Mida tegite ilma kaardita — töö, valmisolek või puhkus — sisestage käsitsi järgmisel sisestamisel.';

  @override
  String get guideNewbieApp => 'Rakendus ei asenda sõidumeerikut';

  @override
  String get guideNewbieAppText =>
      'Ametlik kirje on sõidumeerikus. Vahetage režiimi nii seal kui ka siin — siis loendurid kattuvad.';

  @override
  String get guideNewbieBreak => 'Vaheaeg tähendab ainult puhkust';

  @override
  String get guideNewbieBreakText =>
      'Vaheajal ei tohi sõita ega töötada. Laadimine ja mahalaadimine on muu töö, mitte vaheaeg.';

  @override
  String get guideNewbieRestPlace => 'Kus puhata';

  @override
  String get guideNewbieRestPlaceText =>
      'Igapäevast ja vähendatud iganädalast puhkeaega võib veeta sõidukis, kui seal on magamiskoht ja sõiduk seisab. Regulaarset iganädalast puhkeaega ja hüvitamist — ainult väljaspool sõidukit.';

  @override
  String get guideNewbieCountry => 'Riigid';

  @override
  String get guideNewbieCountryText =>
      'Riik sisestatakse sõidumeerikusse vahetuse alguses ja lõpus. Teise põlvkonna nutikas sõidumeerik salvestab piiriületuse ise; vanemates sisestatakse riik esimeses peatuses pärast piiri.';

  @override
  String guideVanText(String date) {
    return 'Reeglid on samad mis veoautodele. Alates $date kehtivad need üle 2,5 t kaubikutele koos haagisega — rahvusvahelisel kaubaveol ja kabotaažil. Sellisel kaubikul on teise põlvkonna nutikas sõidumeerik, juhil on kaart.';
  }

  @override
  String get guideVanCheck => 'Kas reeglid kehtivad teie reisile';

  @override
  String get guideVanTrip => 'Reis';

  @override
  String get guideVanTripHint => 'Kabotaaž — vedu teise EL riigi sees';

  @override
  String get guideVanDomestic => 'Riigisisene';

  @override
  String get guideVanCrossBorder => 'Välismaale või kabotaaž';

  @override
  String get guideVanCarriage => 'Vedu';

  @override
  String get guideVanHire => 'Tasu eest';

  @override
  String get guideVanOwn => 'Omal kulul';

  @override
  String get guideVanNonCommercial => 'Mitteäriline';

  @override
  String get guideVanCarriageHint =>
      'Omal kulul — teie ettevõtte kaubad, materjalid või tööriistad. Mitteäriline — ilma tasu või tuluta, pole tööga seotud';

  @override
  String get guideVanMain => 'Kas juhtimine on teie põhitöö?';

  @override
  String get yes => 'Jah';

  @override
  String get no => 'Ei';

  @override
  String get guideVanApplies => 'Reeglid kehtivad';

  @override
  String get guideVanNotApply => 'Reeglid ei kehti';

  @override
  String get guideVanAppliesText =>
      'Vaja on sõidumeerikut ja juhikaarti, piirid on samad mis veoautol.';

  @override
  String guideVanNotYetText(String date) {
    return 'Kuni $date kaubikutele reeglid ei kehtinud.';
  }

  @override
  String get guideVanDomesticText =>
      'EL määrus ei kehti kaubikutele riigisisesel veol. Kontrollige oma riigi reegleid.';

  @override
  String get guideVanOwnText =>
      'Erand: vedu oma tarbeks ja juhtimine pole teie põhitöö.';

  @override
  String get guideVanNonCommercialText =>
      'Erand: vedu ilma tasu või tuluta, pole tööga seotud.';

  @override
  String guideArticle(String article) {
    return 'Määrus 561/2006, art $article';
  }

  @override
  String get guideVanNotes =>
      'Koos haagisega raskem kui 3,5 t — reeglid nagu veoautol, ka riigisiseselt. Reis osaliselt väljaspool ELi — Ukrainasse, Moldovasse, Türki, Balkanile — täpsustage vedajaga: ühtset tõlgendust pole.';

  @override
  String get guideDisclaimer =>
      'TachoGo aitab aega planeerida, kuid ei asenda sõidumeerikut ega ole õigusnõustamine. Reeglite ametlik tekst on määrus (EÜ) nr 561/2006 ja AETR-kokkulepe.';

  @override
  String get moreAbout => 'Rakendusest';

  @override
  String get moreDisclaimer =>
      'TachoGo aitab planeerida sõidu- ja puhkeaega, kuid ei asenda sõidumeerikut ega ole õigusnõustamine.';

  @override
  String get problemTitle => 'Teata probleemist';

  @override
  String get problemHint => 'Beetaversioon: teade läheb rakenduse arendajatele';

  @override
  String get problemText =>
      'Teates on rakenduse versioon, telefoni mudel, seaded, load, teavituste ajakava ja päeviku kirjed viimase kahe päeva kohta. Koordinaate selles pole. Valige, kuhu saata — e-post või sõnumirakendus — ja kirjeldage, mis juhtus.';

  @override
  String get problemSend => 'Saada';

  @override
  String get problemSubject => 'TachoGo — probleem beetas';

  @override
  String get problemPrompt => 'Mis juhtus ja millal (oma sõnadega):';

  @override
  String get problemFailed => 'Saatmist ei õnnestunud avada. Proovige uuesti.';
}
