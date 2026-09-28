// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Maltese (`mt`).
class AppLocalizationsMt extends AppLocalizations {
  AppLocalizationsMt([String locale = 'mt']) : super(locale);

  @override
  String get appTitle => 'TachoGo';

  @override
  String get navHome => 'Dar';

  @override
  String get navJournal => 'Reġistru';

  @override
  String get navSettings => 'Settings';

  @override
  String get navMore => 'Aktar';

  @override
  String get close => 'Agħlaq';

  @override
  String get back => 'Lura';

  @override
  String ofLimit(String limit) {
    return 'minn $limit';
  }

  @override
  String get premiumLock => 'Disponibbli fil-Premium';

  @override
  String hoursShort(int hours) {
    return '$hours h';
  }

  @override
  String daysShort(int days) {
    return '$days j';
  }

  @override
  String spokenHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count siegħa',
      many: '$count-il siegħa',
      few: '$count sigħat',
      two: '$count sigħat',
      one: '$count siegħa',
    );
    return '$_temp0';
  }

  @override
  String spokenMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minuta',
      many: '$count-il minuta',
      few: '$count minuti',
      two: '$count minuti',
      one: '$count minuta',
    );
    return '$_temp0';
  }

  @override
  String spokenOverrun(String duration) {
    return 'il-limitu nqabeż b’$duration';
  }

  @override
  String get modeDriving => 'Sewqan';

  @override
  String get modeRest => 'Mistrieħ';

  @override
  String get modeWork => 'Xogħol';

  @override
  String get modeWorkFull => 'Xogħol ieħor';

  @override
  String get modeAvailability => 'Disponibbiltà';

  @override
  String get modeNone => 'L-ebda mod magħżul';

  @override
  String modeSince(String time) {
    return 'minn $time';
  }

  @override
  String get switchFailed => 'Il-mod ma ġiex salvat. Erġa’ pprova.';

  @override
  String homeShiftSince(String date, String time) {
    return '$date · xift minn $time';
  }

  @override
  String homeNoShift(String date) {
    return '$date · ix-xift ma bediex';
  }

  @override
  String get homeLoadError =>
      'Ma setax jinfetaħ ir-reġistru. Erġa’ ibda l-app — jekk ma jgħinx, iktbilna minn “Aktar”.';

  @override
  String get heroUntilBreak => 'Sal-waqfa';

  @override
  String get heroBreak => 'Waqfa';

  @override
  String get heroDailyRest => 'Mistrieħ ta’ kuljum';

  @override
  String get heroWeeklyRest => 'Mistrieħ ta’ kull ġimgħa';

  @override
  String heroContinuousOf(String time, String limit) {
    return 'mingħajr waqfa $time minn $limit';
  }

  @override
  String get heroOffDutyHint =>
      'Ix-xift spiċċa. Li jmiss jibda bl-ewwel mod li mhuwiex mistrieħ.';

  @override
  String get bannerBreakNeeded45 =>
      'Hemm bżonn waqfa ta’ 45 min (jew maqsuma 15 + 30)';

  @override
  String get bannerBreakNeeded30 =>
      'Hemm bżonn waqfa ta’ 30 min — it-tieni parti tal-waqfa maqsuma 15 + 30';

  @override
  String bannerOnBreak(String time, int required) {
    return 'Waqfa $time minn $required min';
  }

  @override
  String bannerBreakCounted(String limit) {
    return 'Il-waqfa tgħodd — tista’ ssuq $limit';
  }

  @override
  String get sectionAlerts => 'Twissijiet';

  @override
  String get sectionToday => 'Illum';

  @override
  String get sectionRest => 'Mistrieħ';

  @override
  String get sectionWeek => 'Ġimgħa';

  @override
  String get rowContinuous => 'Sewqan mingħajr waqfa';

  @override
  String get chipBreakSoon => 'waqfa dalwaqt';

  @override
  String get chipExceeded => 'maqbuż';

  @override
  String get chipLimiting => 'jillimita';

  @override
  String get chipShiftSoon => 'jispiċċa dalwaqt';

  @override
  String get chipLimitSoon => 'limitu dalwaqt';

  @override
  String get chipRestSoon => 'mistrieħ dalwaqt';

  @override
  String chipTimes(int hours, int count) {
    return '$hours h ×$count';
  }

  @override
  String limitOf(String limit) {
    return 'limitu $limit';
  }

  @override
  String leftUntil(String left, String time) {
    return 'fadal $left → $time';
  }

  @override
  String left(String left) {
    return 'fadal $left';
  }

  @override
  String limitLeft(int hours, String left) {
    return '$hours h: fadal $left';
  }

  @override
  String limitLeftUntil(int hours, String left, String time) {
    return '$hours h: fadal $left → $time';
  }

  @override
  String limitUntil(int hours, String time) {
    return '$hours h → $time';
  }

  @override
  String get rowWorkday => 'Jum tax-xogħol';

  @override
  String get workdayNoShift => 'Ix-xift ma bediex';

  @override
  String get rowDailyDriving => 'Sewqan ta’ kuljum';

  @override
  String get rowBreak => 'Waqfa';

  @override
  String breakTaken(int minutes, String time) {
    return 'Meħuda $minutes min fil-$time';
  }

  @override
  String breakStillNeeded(int minutes) {
    return '$minutes min oħra';
  }

  @override
  String get breakNotTaken => 'L-ebda waqfa s’issa';

  @override
  String breakResting(String time, int required) {
    return 'Waqfa issa $time minn $required min';
  }

  @override
  String get rowDailyRest => 'Mistrieħ ta’ kuljum';

  @override
  String get dailyRestCaption => '11 h regolari · 9 h imnaqqas';

  @override
  String get dailyRestSplit => '3 + 9';

  @override
  String get rowWeeklyRest => 'Mistrieħ ta’ kull ġimgħa';

  @override
  String get weeklyRestCaption => '45 h regolari · 24 h imnaqqas';

  @override
  String get chipReducedAvailable => '24 h permessi';

  @override
  String get chipReducedUnavailable => '45 h biss';

  @override
  String get statusNotStarted => 'ma bediex';

  @override
  String statusInProgress(String time) {
    return 'għaddej $time';
  }

  @override
  String statusBy(String when) {
    return 'sa $when';
  }

  @override
  String get statusNoData => 'l-ebda data';

  @override
  String get rowWeeklyDriving => 'Sewqan ta’ kull ġimgħa';

  @override
  String get rowFortnightDriving => 'Sewqan ta’ ġimagħtejn';

  @override
  String get rowWorkWeek => 'Ġimgħa tax-xogħol';

  @override
  String workWeekSince(String since) {
    return 'minn $since';
  }

  @override
  String get workWeekUnknown =>
      'L-ebda data dwar il-mistrieħ ta’ kull ġimgħa ta’ qabel';

  @override
  String get cardTitle => 'Tniżżil tal-karta';

  @override
  String cardCaption(String last, String due) {
    return 'l-aħħar $last · skadenza $due';
  }

  @override
  String get cardNever => 'Immarka l-aħħar tniżżil';

  @override
  String cardSheetLast(String date) {
    return 'L-aħħar tniżżil: $date';
  }

  @override
  String get cardSheetNever => 'L-ebda tniżżil immarkat s’issa.';

  @override
  String get cardSheetRule =>
      'Id-data tal-karta tas-sewwieq trid titniżżel mill-inqas kull 28 jum (Regolament (UE) Nru 581/2010).';

  @override
  String get cardMarkToday => 'Imniżżla llum';

  @override
  String get cardMarked => 'Tniżżil immarkat';

  @override
  String get workdayStart => 'Bidu tax-xift';

  @override
  String workdayRegular(int hours) {
    return '$hours h — jum normali';
  }

  @override
  String workdayRegularHint(String left) {
    return 'imbagħad mistrieħ regolari ta’ 11 h · fadal $left';
  }

  @override
  String workdayExtended(int hours) {
    return '$hours h — jum imtawwal';
  }

  @override
  String workdayExtendedHint(int count) {
    return 'imbagħad mistrieħ imnaqqas ta’ 9 h · fadal ×$count';
  }

  @override
  String get workdayRule =>
      'Il-mistrieħ ta’ kuljum irid jispiċċa fi żmien 24 siegħa mill-bidu tax-xift. Il-mistrieħ imnaqqas ta’ 9 h jista’ jittieħed l-aktar tliet darbiet bejn żewġ mistrieħ ta’ kull ġimgħa.';

  @override
  String get workdayEndDay => 'Agħlaq il-jum';

  @override
  String get workdayEndDayHint =>
      'Il-mistrieħ jibda issa u jagħlaq ix-xift, anki jekk ikun iqsar minn 9 h.';

  @override
  String todayDate(String date) {
    return 'Illum, $date';
  }

  @override
  String infrArticle(String regulation, String article) {
    return 'UE $regulation · Art. $article';
  }

  @override
  String get infrContinuousExceededTitle => 'Sewqan kontinwu maqbuż';

  @override
  String infrContinuousExceededText(String limit, String time, int required) {
    return 'Sewqan mingħajr waqfa itwal minn $limit b’$time. Waqqaf u ħu waqfa ta’ $required min.';
  }

  @override
  String get infrBreakSoonTitle => 'Waqfa dalwaqt';

  @override
  String infrBreakSoonText(String limit, String time, int required) {
    return 'Fadal $time sal-limitu ta’ $limit. Hemm bżonn waqfa ta’ $required min.';
  }

  @override
  String get infrDailyDriveExceededTitle => 'Sewqan ta’ kuljum maqbuż';

  @override
  String infrDailyDriveExceededText(String limit, String time) {
    return 'Aktar minn $limit b’$time. Ibda l-mistrieħ ta’ kuljum.';
  }

  @override
  String get infrDailyDriveSoonTitle => 'Is-sewqan ta’ kuljum qed jispiċċa';

  @override
  String infrDailyDriveSoonText(String limit, String time) {
    return 'Fadal $time sal-limitu ta’ $limit.';
  }

  @override
  String get infrExtensionInUseTitle => 'Estensjoni għal 10 h qed tintuża';

  @override
  String infrExtensionInUseText(int count) {
    return 'Estensjonijiet li fadal din il-ġimgħa: $count.';
  }

  @override
  String get infrShiftExceededTitle => 'Jum tax-xogħol maqbuż';

  @override
  String infrShiftExceededText(String limit, String time) {
    return 'Ix-xift itwal minn $limit b’$time. Ibda l-mistrieħ ta’ kuljum.';
  }

  @override
  String get infrShiftSoonTitle => 'Il-jum tax-xogħol jispiċċa dalwaqt';

  @override
  String infrShiftSoonText(String time) {
    return 'Ibda l-mistrieħ ta’ kuljum fi żmien $time.';
  }

  @override
  String get infrWeeklyDriveExceededTitle => 'Sewqan ta’ kull ġimgħa maqbuż';

  @override
  String infrWeeklyDriveExceededText(String limit, String time) {
    return 'Aktar minn $limit b’$time.';
  }

  @override
  String get infrWeeklyDriveSoonTitle =>
      'Is-sewqan ta’ kull ġimgħa qed jispiċċa';

  @override
  String infrWeeklyDriveSoonText(String limit, String time) {
    return 'Fadal $time sa $limit.';
  }

  @override
  String get infrFortnightDriveExceededTitle => 'Sewqan ta’ ġimagħtejn maqbuż';

  @override
  String infrFortnightDriveExceededText(String limit, String time) {
    return 'Aktar minn $limit b’$time.';
  }

  @override
  String get infrFortnightDriveSoonTitle =>
      'Is-sewqan ta’ ġimagħtejn qed jispiċċa';

  @override
  String infrFortnightDriveSoonText(String limit, String time) {
    return 'Fadal $time sa $limit.';
  }

  @override
  String get infrWeeklyRestOverdueTitle => 'Mistrieħ ta’ kull ġimgħa tard';

  @override
  String infrWeeklyRestOverdueText(String time) {
    return 'Għaddew aktar minn 144 h mill-mistrieħ ta’ kull ġimgħa ta’ qabel — b’$time.';
  }

  @override
  String get infrWeeklyRestSoonTitle => 'Mistrieħ ta’ kull ġimgħa dalwaqt';

  @override
  String infrWeeklyRestSoonText(String time) {
    return 'Ibda l-mistrieħ ta’ kull ġimgħa fi żmien $time.';
  }

  @override
  String get infrWeeklyRestContinueTitle => 'Tinterrompix il-mistrieħ';

  @override
  String infrWeeklyRestContinueText(String time) {
    return 'L-iskadenza tal-mistrieħ ta’ kull ġimgħa għaddiet. Istrieħ $time oħra biex jgħodd bħala mistrieħ ta’ kull ġimgħa.';
  }

  @override
  String get infrCompensationSoonTitle => 'Kumpens dovut dalwaqt';

  @override
  String infrCompensationSoonText(String time, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days jum',
      many: '$days-il jum',
      few: '$days jiem',
      two: '$days jiem',
      one: '$days jum',
    );
    return 'Żid $time ma’ mistrieħ ta’ mill-inqas 9 h. Skadenza fi $_temp0.';
  }

  @override
  String get infrCompensationOverdueTitle => 'Kumpens tard';

  @override
  String infrCompensationOverdueText(String time, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days jum',
      many: '$days-il jum',
      few: '$days jiem',
      two: '$days jiem',
      one: '$days jum',
    );
    return '$time għall-mistrieħ imnaqqas ta’ kull ġimgħa ma żdidux. Tard b’$_temp0.';
  }

  @override
  String get infrReducedRestsExceededTitle => 'Wisq mistrieħ imnaqqas';

  @override
  String infrReducedRestsExceededText(int count) {
    return 'Mistrieħ imnaqqas mill-mistrieħ ta’ kull ġimgħa: $count, permessi 3.';
  }

  @override
  String get infrCardOverdueTitle => 'Tniżżil tal-karta tard';

  @override
  String infrCardOverdueText(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days jum',
      many: '$days-il jum',
      few: '$days jiem',
      two: '$days jiem',
      one: '$days jum',
    );
    return 'L-iskadenza ta’ 28 jum għaddiet $_temp0 ilu.';
  }

  @override
  String get infrCardSoonTitle => 'Tniżżil tal-karta dalwaqt';

  @override
  String infrCardSoonText(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days jum',
      many: '$days-il jum',
      few: '$days jiem',
      two: '$days jiem',
      one: '$days jum',
    );
    return 'Fadal $_temp0.';
  }

  @override
  String get ferryTitle => 'Lanċa / ferrovija';

  @override
  String get ferryHint =>
      'Il-mistrieħ jista’ jiġi interrott l-aktar darbtejn, b’kollox sa siegħa (Art. 9). Il-moviment tal-lanċa ma jixgħelx is-sewqan.';

  @override
  String get ferryOn => 'lanċa';

  @override
  String breakHero(String limit) {
    return 'Waqfa wara $limit sewqan';
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
    return '$minutes min — fadal';
  }

  @override
  String breakFirstTaken(String from, String to) {
    return 'L-ewwel parti meħuda $from–$to';
  }

  @override
  String get breakNone =>
      'Hemm bżonn waqfa ta’ 45 min f’daqqa jew 15 + 30 min.';

  @override
  String get breakSplitTitle => 'Waqfa maqsuma 15 + 30';

  @override
  String get breakSplitText =>
      'L-ewwel parti mill-inqas 15 min, it-tieni mill-inqas 30 min, eżatt f’din l-ordni. L-app tagħrafha waħedha.';

  @override
  String get breakStart => 'Ibda waqfa';

  @override
  String get breakOngoing => 'Waqfa għaddejja';

  @override
  String get weeklyStartBy => 'Ibda sa mhux aktar tard minn';

  @override
  String weeklyInTime(String left) {
    return 'fi żmien $left — tmiem il-ġimgħa tax-xogħol (144 h)';
  }

  @override
  String weeklyOverdue(String time) {
    return 'tard $time';
  }

  @override
  String get weeklyOngoing => 'Mistrieħ ta’ kull ġimgħa għaddej';

  @override
  String get weeklyUnknown =>
      'L-ebda data dwar il-mistrieħ ta’ kull ġimgħa ta’ qabel. L-iskadenza tidher wara mistrieħ ta’ mill-inqas 24 h.';

  @override
  String get weeklyNext => 'Il-mistrieħ li jmiss';

  @override
  String get weeklyFull => 'Regolari';

  @override
  String get weeklyFullHint => 'mhux fil-kabina';

  @override
  String get weeklyReduced => 'Imnaqqas';

  @override
  String get weeklyReducedYes => 'permess · b’kumpens';

  @override
  String get weeklyReducedNo => 'mhux permess — hemm bżonn regolari';

  @override
  String get weeklyHistory => 'Storja';

  @override
  String weeklyPrevious(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'full': 'regolari',
      'reduced': 'imnaqqas',
      'other': 'insuffiċjenti',
    });
    return 'Ta’ qabel · $_temp0';
  }

  @override
  String get weeklyNow => 'issa';

  @override
  String get weeklyCompensation => 'Dejn ta’ kumpens';

  @override
  String get weeklyCompensationNone => 'xejn';

  @override
  String weeklyCompensationValue(String time, String date) {
    return '$time sa $date';
  }

  @override
  String get weeklyMobilityOn =>
      'Pakkett tal-Mobbiltà mixgħul: fit-trasport internazzjonali żewġ mistrieħ imnaqqsa wieħed wara l-ieħor huma permessi jekk jittieħdu barra l-pajjiż tar-reġistrazzjoni. It-tnaqqis jiġi kkumpensat sa tmiem it-tielet ġimgħa.';

  @override
  String get weeklyMobilityOff =>
      'Mistrieħ imnaqqas ta’ kull ġimgħa jiġi kkumpensat sa tmiem it-tielet ġimgħa: id-dejn jiżdied ma’ mistrieħ ta’ mill-inqas 9 h.';

  @override
  String get weeklyStartRest => 'Ibda mistrieħ';

  @override
  String get countryTitle => 'Agħżel pajjiż';

  @override
  String countryChip(String start, String end) {
    return 'Pajjiż tal-bidu $start, tmiem $end. Ibdel';
  }

  @override
  String countryChipNoEnd(String start) {
    return 'Pajjiż tal-bidu $start, tmiem mhux magħżul. Ibdel';
  }

  @override
  String get countryChipNone => 'L-ebda pajjiż tax-xift magħżul. Agħżel';

  @override
  String countryStartTab(String code) {
    return 'Bidu · $code';
  }

  @override
  String countryEndTab(String code) {
    return 'Tmiem · $code';
  }

  @override
  String get countryNextShift => 'Pajjiż tax-xift li jmiss';

  @override
  String get countrySearch => 'Pajjiż jew kodiċi';

  @override
  String get countryRecent => 'Riċenti';

  @override
  String get countryClearEnd => 'Tindikax';

  @override
  String get countryNotFound => 'Ma nstab xejn';

  @override
  String get countryFooter =>
      'Is-sewwieq idaħħal il-pajjiż fit-takografu fil-bidu u fit-tmiem tax-xift (Regolament (UE) Nru 165/2014, Art. 34).';

  @override
  String countryName(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'A': 'L-Awstrija',
      'AL': 'L-Albanija',
      'AND': 'Andorra',
      'ARM': 'L-Armenja',
      'AZ': 'L-Ażerbajġan',
      'B': 'Il-Belġju',
      'BG': 'Il-Bulgarija',
      'BIH': 'Il-Bożnija-Ħerzegovina',
      'BY': 'Il-Belarussja',
      'CH': 'L-Iżvizzera',
      'CY': 'Ċipru',
      'CZ': 'Iċ-Ċekja',
      'D': 'Il-Ġermanja',
      'DK': 'Id-Danimarka',
      'E': 'Spanja',
      'EST': 'L-Estonja',
      'F': 'Franza',
      'FIN': 'Il-Finlandja',
      'FL': 'Il-Liechtenstein',
      'GE': 'Il-Georgia',
      'GR': 'Il-Greċja',
      'H': 'L-Ungerija',
      'HR': 'Il-Kroazja',
      'I': 'L-Italja',
      'IRL': 'L-Irlanda',
      'IS': 'L-Iżlanda',
      'KZ': 'Il-Każakistan',
      'L': 'Il-Lussemburgu',
      'LT': 'Il-Litwanja',
      'LV': 'Il-Latvja',
      'M': 'Malta',
      'MC': 'Monaco',
      'MD': 'Il-Moldova',
      'MK': 'Il-Maċedonja ta’ Fuq',
      'MNE': 'Il-Montenegro',
      'N': 'In-Norveġja',
      'NL': 'In-Netherlands',
      'P': 'Il-Portugall',
      'PL': 'Il-Polonja',
      'RO': 'Ir-Rumanija',
      'RSM': 'San Marino',
      'RUS': 'Ir-Russja',
      'S': 'L-Iżvezja',
      'SK': 'Is-Slovakkja',
      'SLO': 'Is-Slovenja',
      'SRB': 'Is-Serbja',
      'TJ': 'It-Taġikistan',
      'TM': 'It-Turkmenistan',
      'TR': 'It-Turkija',
      'UA': 'L-Ukrajna',
      'UK': 'Ir-Renju Unit',
      'UZ': 'L-Użbekistan',
      'V': 'Il-Belt tal-Vatikan',
      'other': '$code',
    });
    return '$_temp0';
  }

  @override
  String get journalExport => 'Esporta rapport';

  @override
  String get journalCurrent => 'attwali';

  @override
  String get journalDriving => 'Sewqan';

  @override
  String get journalFortnight => 'Ġimagħtejn';

  @override
  String journalOf(int limit) {
    return 'minn $limit';
  }

  @override
  String get journalCollapsedDriving => 'sewqan';

  @override
  String journalWeekSpoken(String range, String driving, String fortnight) {
    return 'Ġimgħa $range. Sewqan $driving minn 56 siegħa, f’ġimagħtejn $fortnight minn 90 siegħa';
  }

  @override
  String get journalShift => 'Xift';

  @override
  String get journalWeeklyShort => 'ġimgħa';

  @override
  String get journalOngoing => 'għaddej';

  @override
  String get journalManual => 'manwali';

  @override
  String get journalAddShift => 'Xift';

  @override
  String get journalAddShiftSpoken => 'Żid xift';

  @override
  String get journalEmpty =>
      'Għad m’hemmx xiftijiet. Jidhru meta tibda tibdel il-modi — jew żid xift manwalment.';

  @override
  String restStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'full': 'regolari',
      'reduced': 'imnaqqas',
      'other': 'insuffiċjenti',
    });
    return '$_temp0';
  }

  @override
  String journalWeeklyRest(String status) {
    return 'Mistrieħ ta’ kull ġimgħa · $status';
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
    return '$date, $route, $time. Sewqan $driving, xift $span, mistrieħ $rest';
  }

  @override
  String get journalRestNone => 'xejn';

  @override
  String get journalRestWeekly => 'ta’ kull ġimgħa';

  @override
  String get journalLoadError =>
      'Ma setax jinfetaħ ir-reġistru. Erġa’ ibda l-app — jekk ma jgħinx, iktbilna minn “Aktar”.';

  @override
  String get dayTitle => 'Xift';

  @override
  String get daySummary => 'Sommarju';

  @override
  String get dayModes => 'Modi';

  @override
  String get dayBreaks => 'Waqfiet';

  @override
  String get dayContinuousAtEnd => 'Mingħajr waqfa fit-tmiem tax-xift';

  @override
  String get dayRestAfter => 'Mistrieħ wara x-xift';

  @override
  String dayRestKind(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'daily': 'Ta’ kuljum',
      'weekly': 'Ta’ kull ġimgħa',
      'other': 'Ma bediex',
    });
    return '$_temp0';
  }

  @override
  String get daySplitRest => 'maqsum 3 + 9';

  @override
  String get dayManualHint =>
      'Ix-xift iddaħħal manwalment bħala totali — m’hemmx reġistrazzjonijiet tal-modi.';

  @override
  String get dayNotes => 'Noti';

  @override
  String get dayEndMark => 'tmiem il-jum';

  @override
  String get dayEdit => 'Editja x-xift';

  @override
  String get dayNotFound => 'Dan ix-xift m’għadux fir-reġistru.';

  @override
  String dayRestUntil(String time) {
    return 'sa $time';
  }

  @override
  String get save => 'Issejvja';

  @override
  String get cancel => 'Ikkanċella';

  @override
  String get done => 'Lest';

  @override
  String get delete => 'Ħassar';

  @override
  String get unitHours => 'h';

  @override
  String get unitMinutes => 'min';

  @override
  String get pickerHours => 'Sigħat';

  @override
  String get pickerMinutes => 'Minuti';

  @override
  String get pickerTime => 'Ħin';

  @override
  String get pickerPrevMonth => 'Ix-xahar ta’ qabel';

  @override
  String get pickerNextMonth => 'Ix-xahar li jmiss';

  @override
  String pickerRange(String min, String max) {
    return 'Permess minn $min sa $max';
  }

  @override
  String get shiftNewTitle => 'Xift ġdid';

  @override
  String get shiftSection => 'Xift';

  @override
  String get shiftStart => 'Bidu';

  @override
  String get shiftEnd => 'Tmiem';

  @override
  String get shiftOnRoad => 'fit-triq';

  @override
  String get shiftChoose => 'Agħżel';

  @override
  String get shiftNowOngoing => 'Issa (għaddej)';

  @override
  String get shiftDuration => 'Tul';

  @override
  String get shiftNowSuffix => 'issa';

  @override
  String shiftCountrySpoken(String side, String code) {
    return '$side: pajjiż $code. Ibdel';
  }

  @override
  String shiftDateSpoken(String side, String date, String time) {
    return '$side: $date, $time. Ibdel';
  }

  @override
  String get shiftDriving => 'Sewqan';

  @override
  String get shiftPerDay => 'Kuljum';

  @override
  String get shiftLiveContinuous => 'ikkalkulat mill-waqfiet';

  @override
  String get shiftRestNone => 'Ma bediex';

  @override
  String get shiftRestDaily => 'Ta’ kuljum';

  @override
  String get shiftRestWeekly => 'Ta’ kull ġimgħa';

  @override
  String get shiftSplit => 'Mistrieħ maqsum 3 + 9';

  @override
  String get shiftSplitHint => 'L-ewwel 3 h, imbagħad 9 h';

  @override
  String shiftRestUntilNext(String when) {
    return 'Sal-bidu tax-xift: $when';
  }

  @override
  String get shiftRestAutoHint => 'Idum sal-bidu tax-xift li jmiss';

  @override
  String get shiftRestCountsWeekly =>
      'Minn 24 h il-mistrieħ jgħodd bħala ta’ kull ġimgħa';

  @override
  String get shiftNotesHint => 'Pereżempju: lanċa, stennija għat-tagħbija';

  @override
  String get shiftDelete => 'Ħassar ix-xift';

  @override
  String get shiftDeleteTitle => 'Tħassar ix-xift?';

  @override
  String get shiftDeleteManual => 'Ix-xift jitneħħa mir-reġistru.';

  @override
  String get shiftDeleteRecorded =>
      'Ir-reġistrazzjonijiet kollha tal-modi ta’ dan ix-xift jitħassru. Dan ma jistax jitreġġa’ lura.';

  @override
  String get shiftErrStartCountry => 'Agħżel il-pajjiż fejn jibda x-xift';

  @override
  String get shiftErrEndCountry => 'Indika l-pajjiż fejn jispiċċa x-xift';

  @override
  String get shiftErrEndBeforeStart => 'Ix-xift jispiċċa qabel ma jibda';

  @override
  String get shiftErrFuture => 'Il-ħin tax-xift ma jistax ikun fil-futur';

  @override
  String get shiftErrTooLong => 'Xift itwal minn 30 h — iċċekkja d-dati';

  @override
  String get shiftErrDrivingTooLong => 'Is-sewqan itwal mix-xift';

  @override
  String get shiftErrContinuous =>
      'Sewqan kontinwu itwal mis-sewqan ta’ kuljum';

  @override
  String shiftErrOverlap(String range) {
    return 'Jikkoinċidi max-xift $range';
  }

  @override
  String get shiftErrNotLast =>
      'Hemm xiftijiet oħra wara dan — ma jistax ikun għaddej issa';

  @override
  String get shiftSaveFailed => 'Ma setax jiġi ssejvjat. Erġa’ pprova.';

  @override
  String get shiftSavedViolations => 'Ix-xift ġie ssejvjat. Hemm ksur';

  @override
  String get shiftSavedViolationsText =>
      'Iċċekkja l-ħinijiet. Jekk kollox tajjeb, il-ksur jidher fir-reġistru u fir-rapport.';

  @override
  String get gotIt => 'Fhimt';

  @override
  String get shiftLiveHint =>
      'Ix-xift isegwi r-reġistrazzjonijiet tal-modi: bidla fil-bidu, fit-tmiem jew fis-sewqan iċċaqlaq ir-reġistrazzjonijiet infushom.';

  @override
  String get shiftConvertHint =>
      'Il-ħin, is-sewqan jew il-mistrieħ inbidel — ix-xift jiġi ssejvjat bħala daħla manwali minflok ir-reġistrazzjonijiet tal-modi.';

  @override
  String shiftEndNowHint(String time) {
    return 'Ix-xift jispiċċa fil-$time, imbagħad jibda l-mistrieħ.';
  }

  @override
  String get shiftResumeHint =>
      'Il-mistrieħ wara x-xift jitħassar — ix-xift ikompli.';

  @override
  String shiftOngoingHint(String time, String mode) {
    return 'Ix-xift isir dak attwali u jkompli fuq l-iskrin ewlieni minn $time. Mod “$mode” — jekk issa japplika ieħor, ibdlu hemm.';
  }

  @override
  String get shiftUnsavedTitle => 'Tissejvja l-bidliet?';

  @override
  String get shiftUnsavedText =>
      'Il-bidliet f’dan ix-xift għadhom mhumiex issejvjati.';

  @override
  String get shiftDiscard => 'Tissejvjax';

  @override
  String get shiftDateTimeTitle => 'Data u ħin tax-xift';

  @override
  String driveEditSubtitle(String date) {
    return 'Korrezzjoni manwali · $date';
  }

  @override
  String get driveEditComputed => 'Ikkalkulat mill-app';

  @override
  String driveEditDiff(String diff) {
    return '$diff meta mqabbel mal-kalkolu.';
  }

  @override
  String get driveEditNoChange => 'Il-ħin ma nbidilx.';

  @override
  String get driveEditHint =>
      'Uża dan jekk il-mod inbidel fil-ħin il-ħażin — il-limiti jerġgħu jiġu kkalkulati.';

  @override
  String get driveEditNoDrive =>
      'Għad m’hemmx sewqan fix-xift attwali — m’hemm xejn x’jiġi kkoreġut.';

  @override
  String get breakCorrection => 'Korrezzjoni';

  @override
  String get breakCurrentDuration => 'Il-waqfa attwali';

  @override
  String get breakLastDuration => 'L-aħħar waqfa';

  @override
  String get breakNoBreak =>
      'Għad m’hemmx waqfa fix-xift — m’hemm xejn x’jiġi kkoreġut.';

  @override
  String get breakEditHint =>
      'Il-ħin jittieħed mir-reġistrazzjoni ta’ ħdejha — il-limiti jerġgħu jiġu kkalkulati.';

  @override
  String get workdayChangeStart => 'Ibdel il-bidu tax-xift';

  @override
  String get weeklyAddManually => 'Daħħal manwalment';

  @override
  String get exportPeriod => 'Perjodu';

  @override
  String get exportWeek => 'Din il-ġimgħa';

  @override
  String get exportTwoWeeks => 'Ġimagħtejn';

  @override
  String get exportDays28 => '28 jum';

  @override
  String get exportCustom => 'Perjodu personalizzat';

  @override
  String get exportFrom => 'Minn';

  @override
  String get exportTo => 'Sa';

  @override
  String exportFromDay(String date) {
    return 'Minn $date';
  }

  @override
  String exportToDay(String date) {
    return 'Sa $date';
  }

  @override
  String get exportFormat => 'Format';

  @override
  String get exportPdf => 'PDF · għall-ispezzjoni';

  @override
  String get exportCsv => 'CSV · spreadsheet';

  @override
  String get exportPdfHint =>
      'Mhux dokument uffiċjali: ir-rapport ma jissostitwixxix id-data tat-takografu u tal-karta tas-sewwieq.';

  @override
  String get exportCsvHint =>
      'Reġistrazzjonijiet tal-modi linja b’linja, ħin f’UTC — għal Excel u programmi tal-kontabilità.';

  @override
  String get exportLanguage => 'Lingwa tar-rapport';

  @override
  String get exportNotes => 'Pajjiżi u noti';

  @override
  String get exportCreate => 'Oħloq rapport';

  @override
  String exportCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count xift',
      many: '$count-il xift',
      few: '$count xiftijiet',
      two: '$count xiftijiet',
      one: '$count xift',
    );
    return '$_temp0 fir-rapport';
  }

  @override
  String get exportEmpty => 'M’hemmx xiftijiet fil-perjodu magħżul.';

  @override
  String get exportFailed => 'Ir-rapport ma setax jinħoloq. Erġa’ pprova.';

  @override
  String exportRangeSpoken(String from, String to) {
    return 'Perjodu minn $from sa $to';
  }

  @override
  String get reportTitle => 'Rapport tal-ħinijiet tas-sewqan u tal-mistrieħ';

  @override
  String get reportSubtitle => 'Regolament (KE) Nru 561/2006 u l-Ftehim AETR';

  @override
  String get reportDriver => 'Sewwieq';

  @override
  String get reportCard => 'Karta tas-sewwieq';

  @override
  String get reportVehicle => 'Numru tar-reġistrazzjoni';

  @override
  String get reportCompany => 'Trasportatur';

  @override
  String get reportPeriod => 'Perjodu';

  @override
  String get reportGenerated => 'Maħluq';

  @override
  String reportTimezone(String zone) {
    return 'Ħinijiet fiż-żona tal-ħin tat-telefon ($zone). Il-jiem u l-ġimgħat tar-rapport f’UTC, il-ġimgħa tibda t-Tnejn fl-00:00, bħal fit-takografu.';
  }

  @override
  String get reportDate => 'Data';

  @override
  String get reportStart => 'Bidu';

  @override
  String get reportEnd => 'Tmiem';

  @override
  String get reportCountries => 'Pajjiżi';

  @override
  String get reportDriving => 'Sewqan';

  @override
  String get reportWork => 'Xogħol';

  @override
  String get reportAvailability => 'Disp.';

  @override
  String get reportBreaks => 'Waqfiet';

  @override
  String get reportSpan => 'Xift';

  @override
  String get reportRestAfter => 'Mistrieħ wara';

  @override
  String get reportNotes => 'Noti';

  @override
  String reportWeek(String range) {
    return 'Ġimgħa $range';
  }

  @override
  String reportWeekTotal(String driving, String fortnight) {
    return 'Total: sewqan $driving minn 56 h · f’ġimagħtejn $fortnight minn 90 h';
  }

  @override
  String get reportViolations => 'Ksur';

  @override
  String get reportNoViolations => 'L-ebda ksur skont ir-reġistru.';

  @override
  String reportViolationDrive(String date, String time) {
    return '$date: sewqan ta’ kuljum $time — aktar minn 10 h';
  }

  @override
  String reportViolationSpan(String date, String time, int limit) {
    return '$date: jum tax-xogħol $time — aktar minn $limit h';
  }

  @override
  String reportViolationRest(String date, String time) {
    return '$date: mistrieħ wara x-xift $time — insuffiċjenti';
  }

  @override
  String reportViolationWeek(String range, String time) {
    return 'Ġimgħa $range: sewqan $time — aktar minn 56 h';
  }

  @override
  String reportViolationFortnight(String range, String time) {
    return 'Ġimgħa $range: f’ġimagħtejn $time — aktar minn 90 h';
  }

  @override
  String get reportMarks => 'Marki';

  @override
  String get reportMarkWarn =>
      '! — sewqan imtawwal għal 10 h, jum tax-xogħol aktar minn 13 h jew mistrieħ imnaqqas';

  @override
  String get reportMarkBad => '!! — ksur';

  @override
  String get reportMarkManual => '* — xift imdaħħal manwalment bħala totali';

  @override
  String get reportDisclaimer =>
      'Ir-rapport huwa bbażat fuq id-daħliet tas-sewwieq fl-app TachoGo. Mhux dokument uffiċjali: ma jissostitwixxix id-data tat-takografu u tal-karta tas-sewwieq.';

  @override
  String get reportSignature => 'Firma tas-sewwieq';

  @override
  String reportPage(int page, int pages) {
    return 'Paġna $page minn $pages';
  }

  @override
  String get openSystemSettings => 'Iftaħ is-settings';

  @override
  String get settingsGeneral => 'Ġenerali';

  @override
  String get settingsLanguage => 'Lingwa';

  @override
  String get settingsLanguageSystem => 'Bħat-telefon';

  @override
  String get settingsTheme => 'Dehra';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Ċar';

  @override
  String get themeDark => 'Skur';

  @override
  String get settingsRules => 'Regoli';

  @override
  String get settingsTachograph => 'Takografu fil-vettura';

  @override
  String get tachographDigital => 'Diġitali';

  @override
  String get tachographAnalog => 'Analogu';

  @override
  String get settingsMobility => 'Pakkett tal-Mobbiltà';

  @override
  String get settingsMobilityHint =>
      'Żewġ mistrieħ imnaqqsa ta’ kull ġimgħa wieħed wara l-ieħor fit-trasport internazzjonali';

  @override
  String get settingsCrew => 'Ekwipaġġ ta’ żewġ sewwieqa';

  @override
  String get settingsCrewHint =>
      'Mistrieħ ta’ kuljum ta’ 9 h fi żmien 30 h mill-bidu tax-xift';

  @override
  String get settingsNotifications => 'Notifiki';

  @override
  String get settingsWarnLead => 'Wissi dwar il-limiti';

  @override
  String get settingsWarnLeadHint => 'Waqfa, tmiem il-jum, sewqan';

  @override
  String get settingsWarnLeadGroup => 'Wissi minn qabel';

  @override
  String leadMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String leadHours(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours siegħa',
      many: '$hours-il siegħa',
      few: '$hours sigħat',
      two: '$hours sigħat',
      one: '$hours siegħa',
    );
    return '$_temp0';
  }

  @override
  String get notifyBreak => 'Waqfa';

  @override
  String get notifyShiftEnd => 'Tmiem il-jum tax-xogħol';

  @override
  String get notifyShiftEndHint => 'Mistrieħ ta’ kuljum u ta’ kull ġimgħa';

  @override
  String get notifyDriving => 'Limitu tas-sewqan';

  @override
  String get notifyCard => 'Tniżżil tal-karta';

  @override
  String get notifyCardHint => 'Kull 28 jum';

  @override
  String get notifyCardLead => 'Minn qabel';

  @override
  String get notifyCardLeadGroup =>
      'Twissija dwar it-tniżżil tal-karta minn qabel';

  @override
  String leadDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days jum',
      many: '$days-il jum',
      few: '$days jiem',
      two: '$days jiem',
      one: '$days jum',
    );
    return '$_temp0';
  }

  @override
  String get notifyAllow => 'Ippermetti n-notifiki';

  @override
  String get notifyDenied =>
      'In-notifiki bħalissa huma mblukkati fuq it-telefon';

  @override
  String get notifyAllowed => 'Notifiki permessi';

  @override
  String get notifyExact => 'Ħin eżatt tan-notifiki';

  @override
  String get notifyExactHint =>
      'Ippermetti “Allarmi u tfakkiriet” — inkella t-telefon jista’ jdewwem twissija';

  @override
  String get notifyChannelLimits => 'Limiti u ksur';

  @override
  String get notifyChannelLimitsHint =>
      'Waqfa, tmiem il-jum tax-xogħol, sewqan, mistrieħ ta’ kull ġimgħa, karta';

  @override
  String get notifyChannelRest => 'Mistrieħ jgħodd';

  @override
  String get notifyChannelRestHint =>
      'Waqfa tgħodd, mistrieħ ta’ kuljum u ta’ kull ġimgħa jgħodd';

  @override
  String get notifyBreakTakenTitle => 'Il-waqfa tgħodd';

  @override
  String notifyBreakTakenText(int required, String time) {
    return 'Il-waqfa ta’ $required min tgħodd. Tista’ ssuq $time sal-waqfa li jmiss.';
  }

  @override
  String get notifyDailyRestTakenTitle => 'Il-mistrieħ ta’ kuljum jgħodd';

  @override
  String notifyDailyRestTakenText(String limit) {
    return 'Mistrieħ regolari ta’ $limit — tista’ tibda xift.';
  }

  @override
  String get notifyWeeklyRestTakenTitle => 'Il-mistrieħ ta’ kull ġimgħa jgħodd';

  @override
  String notifyWeeklyRestTakenText(String limit) {
    return 'Mistrieħ regolari ta’ $limit — tista’ tibda ġimgħa tax-xogħol ġdida.';
  }

  @override
  String get serviceChannel => 'Sejbien awtomatiku tas-sewqan';

  @override
  String get serviceChannelHint =>
      'Il-mod attwali u l-counters waqt li s-sejbien awtomatiku jkun mixgħul';

  @override
  String get serviceStarted => 'Is-sejbien awtomatiku tas-sewqan huwa mixgħul';

  @override
  String serviceModeTitle(String mode, String time) {
    return '$mode · $time';
  }

  @override
  String get serviceTeamTitle => 'Il-vettura qed timxi';

  @override
  String serviceTeamText(String time) {
    return 'Int qed issuq? Sewqan minn $time';
  }

  @override
  String get serviceSuggestTitle => 'Jidher li qed issuq';

  @override
  String serviceSuggestText(String time) {
    return 'Tibda s-sewqan minn $time? Il-mistrieħ jiġi interrott';
  }

  @override
  String serviceDriving(String untilBreak, String dayLeft) {
    return 'Sal-waqfa $untilBreak · fadal $dayLeft illum';
  }

  @override
  String serviceDrivingOver(String time) {
    return 'Hemm bżonn waqfa: il-limitu nqabeż b’$time';
  }

  @override
  String serviceBreakLeft(String time) {
    return 'Sal-waqfa sħiħa $time';
  }

  @override
  String serviceBreakDone(String time) {
    return 'Il-waqfa tgħodd, tista’ ssuq $time';
  }

  @override
  String serviceWorkday(String time, String limit) {
    return 'Jum tax-xogħol $time minn $limit';
  }

  @override
  String serviceRestLeft(String limit, String time) {
    return 'Sal-mistrieħ sħiħ ta’ $limit: $time';
  }

  @override
  String get serviceDailyRestDone => 'Il-mistrieħ regolari ta’ kuljum jgħodd';

  @override
  String get serviceWeeklyRestDone =>
      'Il-mistrieħ regolari ta’ kull ġimgħa jgħodd';

  @override
  String get serviceNotStartedText =>
      'Is-sewqan jixgħel meta l-vettura tibda timxi';

  @override
  String get serviceNoModeText => 'Iftaħ TachoGo u agħżel mod';

  @override
  String get autoTitle => 'Sejbien awtomatiku tas-sewqan';

  @override
  String get autoSwitch => 'Sib is-sewqan bil-GPS';

  @override
  String get autoSwitchHint =>
      'Titlaq — sewqan; tieqaf — xogħol ieħor. Hemm bżonn il-veloċità biss: il-koordinati ma jiġux issejvjati.';

  @override
  String get autoAfterStop => 'Wara waqfien';

  @override
  String get autoAfterStopHint => 'Wara 3 minuti wieqfa';

  @override
  String get autoStartFromRest => 'Sewqan dritt wara l-mistrieħ';

  @override
  String get autoStartFromRestHint =>
      'Inkella l-app tistaqsi l-ewwel: forsi kont passiġġier';

  @override
  String get autoBattery => 'Iffrankar tal-batterija';

  @override
  String get autoBatteryLimited =>
      'Jista’ jwaqqaf is-sejbien. Neħħi TachoGo mil-lista tal-iffrankar';

  @override
  String get autoBatteryOk => 'Ma jfixkilx ix-xogħol fl-isfond';

  @override
  String get autoAutostart => 'Bidu awtomatiku u xogħol fl-isfond';

  @override
  String get autoAutostartHint =>
      'Xiaomi, Huawei, Honor, Oppo, Vivo, Samsung: ippermetti, inkella t-telefon iwaqqaf is-sejbien';

  @override
  String get autoBlockedService =>
      'Il-post huwa mitfi fuq it-telefon. Ixgħlu biex jinstab is-sewqan.';

  @override
  String get autoBlockedDenied =>
      'Mingħajr aċċess għall-post is-sewqan ma jistax jinstab. L-app għandha bżonn il-veloċità biss, il-koordinati ma jiġux issejvjati.';

  @override
  String get autoBlockedForever =>
      'L-aċċess għall-post huwa mblukkat. Ippermettih fis-settings tat-telefon: Post → “Waqt l-użu tal-app”.';

  @override
  String get autoNoAccess =>
      'L-ebda aċċess għall-post — is-sejbien ma jaħdimx. Ippermettih fis-settings tat-telefon.';

  @override
  String get autoEnable => 'Ixgħel is-sejbien tas-sewqan';

  @override
  String get autoEnabled => 'Is-sejbien tas-sewqan huwa mixgħul';

  @override
  String get settingsData => 'Data';

  @override
  String get settingsExport => 'Esporta rapport';

  @override
  String get settingsExportFormats => 'PDF · CSV';

  @override
  String get settingsAnalytics => 'Statistika anonima';

  @override
  String get settingsAnalyticsHint =>
      'Liema skrins jiftħu s-sewwieqa — biex titjieb l-app. Mingħajr koordinati, ismijiet jew numri tal-karti.';

  @override
  String get settingsClear => 'Ħassar id-data kollha';

  @override
  String get clearTitle => 'Tħassar id-data kollha?';

  @override
  String get clearText =>
      'Jitħassru r-reġistru tal-modi, ix-xiftijiet, il-pajjiżi, in-noti u t-tniżżil tal-karta. Dan ma jistax jitreġġa’ lura. Is-settings jibqgħu.';

  @override
  String get clearConfirm => 'Ħassar';

  @override
  String get clearDone => 'Id-data tħassret';

  @override
  String onbStep(int step, int count) {
    return 'Pass $step minn $count';
  }

  @override
  String get onbWelcomeTitle => 'Il-ħin fuq ir-rota taħt kontroll';

  @override
  String get onbWelcomeText =>
      'Ngħoddu s-sewqan, il-waqfiet u l-mistrieħ skont ir-regoli tal-UE 561/2006 u l-AETR u nwissuk minn qabel dwar il-limiti.';

  @override
  String get onbStart => 'Ibda';

  @override
  String get onbNext => 'Li jmiss';

  @override
  String get onbDone => 'Lest';

  @override
  String get onbModesTitle => 'Erba’ modi — bħal fuq it-takografu';

  @override
  String get onbModesText =>
      'Ibdel il-mod bil-buttuni fuq l-iskrin ewlieni. Il-counters jimxu waħedhom — anki meta l-app tkun magħluqa.';

  @override
  String get onbModeDriving =>
      'Fuq ir-rota. Ngħoddu s-sewqan kontinwu, ta’ kuljum u ta’ kull ġimgħa.';

  @override
  String get onbModeWork => 'Tagħbija, kontroll tal-vettura, dokumenti.';

  @override
  String get onbModeAvailability =>
      'Stennija: kju għat-tagħbija, fruntiera, it-tieni sewwieq qed isuq.';

  @override
  String get onbModeRest =>
      'Waqfiet u mistrieħ. “Agħlaq il-jum” jagħlaq ix-xift.';

  @override
  String get onbSetupTitle => 'Ejja nissettjawha għalik';

  @override
  String get onbSetupText =>
      'Dan kollu jista’ jinbidel aktar tard fis-settings.';

  @override
  String get onbMobilityHint => 'Ixgħlu jekk issuq rotot internazzjonali';

  @override
  String onbNotifyText(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minuta',
      many: '$minutes-il minuta',
      few: '$minutes minuti',
      two: '$minutes minuti',
      one: '$minutes minuta',
    );
    return 'Inwissuk $_temp0 qabel il-waqfa u t-tmiem tal-jum tax-xogħol — anki meta l-app tkun magħluqa.';
  }

  @override
  String get onbAutoText =>
      'Titlaq — l-app tixgħel is-sewqan; tieqaf — xogħol ieħor. Wara l-mistrieħ tistaqsi l-ewwel. Hemm bżonn il-veloċità tal-GPS biss: il-koordinati la jiġu ssejvjati u lanqas mibgħuta mkien.';

  @override
  String get onbAutoLater => 'Tista’ tixgħelha aktar tard fis-settings.';

  @override
  String languageButton(String language) {
    return 'Lingwa: $language';
  }

  @override
  String get settingsVehicle => 'Vettura';

  @override
  String get vehicleTruckOrBus => 'Trakk jew xarabank';

  @override
  String get vehicleVan => 'Van 2,5–3,5 t';

  @override
  String settingsVanHint(String date) {
    return 'Regoli — minn $date fit-trasport internazzjonali u l-kabotaġġ bi ħlas';
  }

  @override
  String onbVanText(String date) {
    return 'Ir-regoli tal-UE japplikaw għall-vans minn $date — fit-trasport internazzjonali u l-kabotaġġ bi ħlas. Il-van għandu takografu intelliġenti tat-tieni ġenerazzjoni, is-sewwieq għandu karta.';
  }

  @override
  String get onbRulesTitle => 'Ir-regoli ewlenin';

  @override
  String get onbRulesText =>
      'L-istess għat-trakkijiet, ix-xarabanks u l-vans. L-app tikkalkulahom waħedha u twissik minn qabel.';

  @override
  String get onbRulesMore =>
      'Ir-regoli kollha bi spjegazzjonijiet — “Aktar” → “Gwida u regoli”.';

  @override
  String get guideTitle => 'Gwida u regoli';

  @override
  String get guideHowTo => 'Kif tużaha';

  @override
  String get guideStep1 =>
      'Ibdel il-mod bil-buttuni fuq l-iskrin ewlieni: sewqan, mistrieħ, xogħol jew disponibbiltà.';

  @override
  String get guideStep2 =>
      'Indika l-pajjiż fil-bidu u fit-tmiem tax-xift — bħal fuq it-takografu.';

  @override
  String get guideStep3 =>
      'Segwi l-limiti. L-app twissik minn qabel dwar il-waqfa u t-tmiem tal-jum. Kull ħin jista’ jiġi kkoreġut manwalment.';

  @override
  String get guideRules => 'Ir-regoli tal-UE 561/2006 u l-AETR';

  @override
  String get guideContinuous => 'Sewqan mingħajr waqfa';

  @override
  String guideContinuousText(String full, String first, String second) {
    return 'Imbagħad waqfa ta’ $full. Tista’ tinqasam: l-ewwel $first, imbagħad $second.';
  }

  @override
  String get guideDailyDriving => 'Sewqan kuljum';

  @override
  String guideDailyDrivingText(String extended) {
    return 'Darbtejn fil-ġimgħa huwa permess sa $extended.';
  }

  @override
  String get guideWeeklyDriving => 'Sewqan fil-ġimgħa';

  @override
  String guideWeeklyDrivingText(String fortnight) {
    return 'F’kull żewġ ġimgħat konsekuttivi — l-aktar $fortnight.';
  }

  @override
  String get guideDailyRest => 'Mistrieħ ta’ kuljum';

  @override
  String guideDailyRestText(String reduced, String first, String second) {
    return 'Sa tliet darbiet bejn żewġ mistrieħ ta’ kull ġimgħa jista’ jitnaqqas għal $reduced. Għażla maqsuma — $first + $second.';
  }

  @override
  String get guideWorkday => 'Jum tax-xogħol';

  @override
  String guideWorkdayText(String window, String regular, String reduced) {
    return 'Il-mistrieħ irid jispiċċa fi żmien $window mill-bidu tax-xift: $regular b’mistrieħ regolari, $reduced b’wieħed imnaqqas.';
  }

  @override
  String guideWorkdaySpoken(int first, int second) {
    String _temp0 = intl.Intl.pluralLogic(
      second,
      locale: localeName,
      other: '$second siegħa',
      many: '$second-il siegħa',
      few: '$second sigħat',
      two: '$second sigħat',
      one: '$second siegħa',
    );
    return '$first jew $_temp0';
  }

  @override
  String get guideWeeklyRest => 'Mistrieħ ta’ kull ġimgħa';

  @override
  String guideWeeklyRestText(String reduced) {
    return 'Imnaqqas — $reduced, b’kumpens sa tmiem it-tielet ġimgħa. Il-mistrieħ regolari ma jistax jittieħed fil-kabina.';
  }

  @override
  String get guideWorkWeek => 'Ġimgħa tax-xogħol';

  @override
  String guideWorkWeekText(String period) {
    return 'Il-mistrieħ ta’ kull ġimgħa jibda mhux aktar tard minn wara sitt perjodi ta’ $period minn dak ta’ qabel.';
  }

  @override
  String get guideCard => 'Karta tas-sewwieq';

  @override
  String guideCardText(String days) {
    return 'Id-data tal-karta trid titniżżel mill-inqas darba kull $days.';
  }

  @override
  String get guideModes => 'Kuluri u ikoni';

  @override
  String get guideNewbie => 'L-ewwel darba bit-takografu';

  @override
  String get guideNewbieCard =>
      'Il-karta tibqa’ fit-takografu tul ix-xift kollu';

  @override
  String get guideNewbieCardText =>
      'Daħħal il-karta fil-bidu tax-xift u oħroġha fit-tmiem. Dak li għamilt mingħajr il-karta — xogħol, disponibbiltà jew mistrieħ — daħħlu manwalment id-darba li jmiss li ddaħħalha.';

  @override
  String get guideNewbieApp => 'L-app ma tissostitwixxix it-takografu';

  @override
  String get guideNewbieAppText =>
      'Ir-reġistrazzjoni uffiċjali hija fit-takografu. Ibdel il-mod kemm hemm kif ukoll hawn — imbagħad il-counters jaqblu.';

  @override
  String get guideNewbieBreak => 'Waqfa tfisser mistrieħ biss';

  @override
  String get guideNewbieBreakText =>
      'Waqt il-waqfa ma tistax la ssuq u lanqas taħdem. It-tagħbija u l-ħatt huma xogħol ieħor, mhux waqfa.';

  @override
  String get guideNewbieRestPlace => 'Fejn tistrieħ';

  @override
  String get guideNewbieRestPlaceText =>
      'Il-mistrieħ ta’ kuljum u l-mistrieħ imnaqqas ta’ kull ġimgħa jistgħu jittieħdu fil-vettura jekk ikollha post għall-irqad u tkun wieqfa. Il-mistrieħ regolari ta’ kull ġimgħa u l-kumpens — barra l-vettura biss.';

  @override
  String get guideNewbieCountry => 'Pajjiżi';

  @override
  String get guideNewbieCountryText =>
      'Il-pajjiż jiddaħħal fit-takografu fil-bidu u fit-tmiem tax-xift. Takografu intelliġenti tat-tieni ġenerazzjoni jirreġistra l-qsim tal-fruntiera waħdu; f’dawk eqdem il-pajjiż jiddaħħal fl-ewwel waqfa wara l-fruntiera.';

  @override
  String guideVanText(String date) {
    return 'Ir-regoli huma l-istess bħal għat-trakkijiet. Minn $date japplikaw għall-vans ta’ aktar minn 2,5 t inkluż it-trejler — fit-trasport internazzjonali tal-merkanzija u l-kabotaġġ. Van bħal dan għandu takografu intelliġenti tat-tieni ġenerazzjoni, is-sewwieq għandu karta.';
  }

  @override
  String get guideVanCheck => 'Ir-regoli japplikaw għall-vjaġġ tiegħek';

  @override
  String get guideVanTrip => 'Vjaġġ';

  @override
  String get guideVanTripHint =>
      'Kabotaġġ — trasport ġewwa pajjiż ieħor tal-UE';

  @override
  String get guideVanDomestic => 'Domestiku';

  @override
  String get guideVanCrossBorder => 'Barra l-pajjiż jew kabotaġġ';

  @override
  String get guideVanCarriage => 'Trasport';

  @override
  String get guideVanHire => 'Bi ħlas';

  @override
  String get guideVanOwn => 'Għall-kont proprju';

  @override
  String get guideVanNonCommercial => 'Mhux kummerċjali';

  @override
  String get guideVanCarriageHint =>
      'Għall-kont proprju — merkanzija, materjali jew għodod tal-kumpanija tiegħek. Mhux kummerċjali — mingħajr ħlas jew dħul, mhux relatat max-xogħol';

  @override
  String get guideVanMain => 'Is-sewqan huwa x-xogħol ewlieni tiegħek?';

  @override
  String get yes => 'Iva';

  @override
  String get no => 'Le';

  @override
  String get guideVanApplies => 'Ir-regoli japplikaw';

  @override
  String get guideVanNotApply => 'Ir-regoli ma japplikawx';

  @override
  String get guideVanAppliesText =>
      'Hemm bżonn takografu u karta tas-sewwieq, il-limiti huma l-istess bħal għal trakk.';

  @override
  String guideVanNotYetText(String date) {
    return 'Qabel $date il-vans ma kinux koperti mir-regoli.';
  }

  @override
  String get guideVanDomesticText =>
      'Ir-regolament tal-UE ma japplikax għall-vans fit-trasport domestiku. Iċċekkja r-regoli ta’ pajjiżek.';

  @override
  String get guideVanOwnText =>
      'Eċċezzjoni: trasport għall-bżonnijiet tiegħek, u s-sewqan mhuwiex ix-xogħol ewlieni tiegħek.';

  @override
  String get guideVanNonCommercialText =>
      'Eċċezzjoni: trasport mingħajr ħlas jew dħul, mhux relatat max-xogħol.';

  @override
  String guideArticle(String article) {
    return 'Regolament 561/2006, Art. $article';
  }

  @override
  String get guideVanNotes =>
      'Itqal minn 3,5 t flimkien mat-trejler — ir-regoli bħal għal trakk, anki fil-pajjiż. Vjaġġ parzjalment barra l-UE — lejn l-Ukrajna, il-Moldova, it-Turkija, il-Balkani — iċċekkja mat-trasportatur: m’hemmx interpretazzjoni waħda.';

  @override
  String get guideDisclaimer =>
      'TachoGo jgħin biex tippjana l-ħin, iżda ma jissostitwixxix it-takografu u mhuwiex parir legali. It-test uffiċjali tar-regoli huwa r-Regolament (KE) Nru 561/2006 u l-Ftehim AETR.';

  @override
  String get moreAbout => 'Dwar l-app';

  @override
  String get moreDisclaimer =>
      'TachoGo jgħin biex tippjana l-ħinijiet tas-sewqan u tal-mistrieħ, iżda ma jissostitwixxix it-takografu u mhuwiex parir legali.';

  @override
  String get problemTitle => 'Irrapporta problema';

  @override
  String get problemHint =>
      'Verżjoni beta: ir-rapport imur għand l-iżviluppaturi tal-app';

  @override
  String get problemText =>
      'Ir-rapport fih il-verżjoni tal-app, il-mudell tat-telefon, is-settings, il-permessi, l-iskeda tan-notifiki u d-daħliet tar-reġistru tal-aħħar jumejn. Ma fihx koordinati. Agħżel fejn tibagħtu — email jew app tal-messaġġi — u ddeskrivi x’ġara.';

  @override
  String get problemSend => 'Ibgħat';

  @override
  String get problemSubject => 'TachoGo — problema fil-beta';

  @override
  String get problemPrompt => 'X’ġara u meta (bi kliemek):';

  @override
  String get problemFailed => 'Il-bgħit ma setax jinfetaħ. Erġa’ pprova.';
}
