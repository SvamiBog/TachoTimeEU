// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Irish (`ga`).
class AppLocalizationsGa extends AppLocalizations {
  AppLocalizationsGa([String locale = 'ga']) : super(locale);

  @override
  String get appTitle => 'TachoGo';

  @override
  String get navHome => 'Baile';

  @override
  String get navJournal => 'Logleabhar';

  @override
  String get navSettings => 'Socruithe';

  @override
  String get navMore => 'Tuilleadh';

  @override
  String get close => 'Dún';

  @override
  String get back => 'Siar';

  @override
  String ofLimit(String limit) {
    return 'as $limit';
  }

  @override
  String get premiumLock => 'Ar fáil in Premium';

  @override
  String hoursShort(int hours) {
    return '$hours u';
  }

  @override
  String daysShort(int days) {
    return '$days l';
  }

  @override
  String spokenHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count uair an chloig',
      many: '$count n-uaire an chloig',
      few: '$count huaire an chloig',
      two: '$count uair an chloig',
      one: '$count uair an chloig',
    );
    return '$_temp0';
  }

  @override
  String spokenMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nóiméad',
      many: '$count nóiméad',
      few: '$count nóiméad',
      two: '$count nóiméad',
      one: '$count nóiméad',
    );
    return '$_temp0';
  }

  @override
  String spokenOverrun(String duration) {
    return 'thar an teorainn le $duration';
  }

  @override
  String get modeDriving => 'Tiomáint';

  @override
  String get modeRest => 'Scíth';

  @override
  String get modeWork => 'Obair';

  @override
  String get modeWorkFull => 'Obair eile';

  @override
  String get modeAvailability => 'Infhaighteacht';

  @override
  String get modeNone => 'Níl mód roghnaithe';

  @override
  String modeSince(String time) {
    return 'ó $time';
  }

  @override
  String get switchFailed => 'Níor sábháladh an mód. Bain triail eile as.';

  @override
  String homeShiftSince(String date, String time) {
    return '$date · seal ó $time';
  }

  @override
  String homeNoShift(String date) {
    return '$date · níor thosaigh an seal';
  }

  @override
  String get homeLoadError =>
      'Níorbh fhéidir an logleabhar a oscailt. Atosaigh an aip — mura gcabhraíonn sé sin, scríobh chugainn trí “Tuilleadh”.';

  @override
  String get heroUntilBreak => 'Go dtí an sos';

  @override
  String get heroBreak => 'Sos';

  @override
  String get heroDailyRest => 'Scíth laethúil';

  @override
  String get heroWeeklyRest => 'Scíth sheachtainiúil';

  @override
  String heroContinuousOf(String time, String limit) {
    return 'gan sos $time as $limit';
  }

  @override
  String get heroOffDutyHint =>
      'Tá an seal thart. Tosaíonn an chéad cheann eile leis an gcéad mhód nach scíth é.';

  @override
  String get bannerBreakNeeded45 =>
      'Tá sos 45 nóim. ag teastáil (nó roinnte 15 + 30)';

  @override
  String get bannerBreakNeeded30 =>
      'Tá sos 30 nóim. ag teastáil — an dara cuid den sos roinnte 15 + 30';

  @override
  String bannerOnBreak(String time, int required) {
    return 'Sos $time as $required nóim.';
  }

  @override
  String bannerBreakCounted(String limit) {
    return 'Áirítear an sos — is féidir leat tiomáint $limit';
  }

  @override
  String get sectionAlerts => 'Rabhaidh';

  @override
  String get sectionToday => 'Inniu';

  @override
  String get sectionRest => 'Scíth';

  @override
  String get sectionWeek => 'Seachtain';

  @override
  String get rowContinuous => 'Tiomáint gan sos';

  @override
  String get chipBreakSoon => 'sos go luath';

  @override
  String get chipExceeded => 'sáraithe';

  @override
  String get chipLimiting => 'ag teorannú';

  @override
  String get chipShiftSoon => 'críochnaíonn go luath';

  @override
  String get chipLimitSoon => 'teorainn go luath';

  @override
  String get chipRestSoon => 'scíth go luath';

  @override
  String chipTimes(int hours, int count) {
    return '$hours u ×$count';
  }

  @override
  String limitOf(String limit) {
    return 'teorainn $limit';
  }

  @override
  String leftUntil(String left, String time) {
    return '$left fágtha → $time';
  }

  @override
  String left(String left) {
    return '$left fágtha';
  }

  @override
  String limitLeft(int hours, String left) {
    return '$hours u: $left fágtha';
  }

  @override
  String limitLeftUntil(int hours, String left, String time) {
    return '$hours u: $left fágtha → $time';
  }

  @override
  String limitUntil(int hours, String time) {
    return '$hours u → $time';
  }

  @override
  String get rowWorkday => 'Lá oibre';

  @override
  String get workdayNoShift => 'Níor thosaigh an seal';

  @override
  String get rowDailyDriving => 'Tiomáint laethúil';

  @override
  String get rowBreak => 'Sos';

  @override
  String breakTaken(int minutes, String time) {
    return 'Glacadh $minutes nóim. ag $time';
  }

  @override
  String breakStillNeeded(int minutes) {
    return '$minutes nóim. eile';
  }

  @override
  String get breakNotTaken => 'Níor glacadh sos fós';

  @override
  String breakResting(String time, int required) {
    return 'Sos anois $time as $required nóim.';
  }

  @override
  String get rowDailyRest => 'Scíth laethúil';

  @override
  String get dailyRestCaption => '11 u rialta · 9 u laghdaithe';

  @override
  String get dailyRestSplit => '3 + 9';

  @override
  String get rowWeeklyRest => 'Scíth sheachtainiúil';

  @override
  String get weeklyRestCaption => '45 u rialta · 24 u laghdaithe';

  @override
  String get chipReducedAvailable => '24 u ceadaithe';

  @override
  String get chipReducedUnavailable => '45 u amháin';

  @override
  String get statusNotStarted => 'níor thosaigh';

  @override
  String statusInProgress(String time) {
    return 'ar siúl $time';
  }

  @override
  String statusBy(String when) {
    return 'faoi $when';
  }

  @override
  String get statusNoData => 'gan sonraí';

  @override
  String get rowWeeklyDriving => 'Tiomáint sheachtainiúil';

  @override
  String get rowFortnightDriving => 'Tiomáint coicíse';

  @override
  String get rowWorkWeek => 'Seachtain oibre';

  @override
  String workWeekSince(String since) {
    return 'ó $since';
  }

  @override
  String get workWeekUnknown =>
      'Níl sonraí ann faoin scíth sheachtainiúil roimhe seo';

  @override
  String get cardTitle => 'Íoslódáil an chárta';

  @override
  String cardCaption(String last, String due) {
    return 'an uair dheireanach $last · spriocdháta $due';
  }

  @override
  String get cardNever => 'Marcáil an íoslódáil dheireanach';

  @override
  String cardSheetLast(String date) {
    return 'An íoslódáil dheireanach: $date';
  }

  @override
  String get cardSheetNever => 'Níl aon íoslódáil marcáilte fós.';

  @override
  String get cardSheetRule =>
      'Ní mór sonraí an chárta tiománaí a íoslódáil ar a laghad gach 28 lá (Rialachán (AE) Uimh. 581/2010).';

  @override
  String get cardMarkToday => 'Íoslódáladh inniu';

  @override
  String get cardMarked => 'Íoslódáil marcáilte';

  @override
  String get workdayStart => 'Tús an tseala';

  @override
  String workdayRegular(int hours) {
    return '$hours u — gnáthlá';
  }

  @override
  String workdayRegularHint(String left) {
    return 'ansin scíth rialta 11 u · $left fágtha';
  }

  @override
  String workdayExtended(int hours) {
    return '$hours u — lá fadaithe';
  }

  @override
  String workdayExtendedHint(int count) {
    return 'ansin scíth laghdaithe 9 u · ×$count fágtha';
  }

  @override
  String get workdayRule =>
      'Ní mór don scíth laethúil críochnú laistigh de 24 uair an chloig ó thús an tseala. Is féidir an scíth laghdaithe 9 u a ghlacadh trí huaire ar a mhéad idir scíthe seachtainiúla.';

  @override
  String get workdayEndDay => 'Críochnaigh an lá';

  @override
  String get workdayEndDayHint =>
      'Tosaíonn an scíth anois agus críochnaíonn sí an seal, fiú má tá sí níos giorra ná 9 u.';

  @override
  String todayDate(String date) {
    return 'Inniu, $date';
  }

  @override
  String infrArticle(String regulation, String article) {
    return 'AE $regulation · Airt. $article';
  }

  @override
  String get infrContinuousExceededTitle => 'Tiomáint leanúnach sáraithe';

  @override
  String infrContinuousExceededText(String limit, String time, int required) {
    return 'Tiomáint gan sos níos faide ná $limit le $time. Stad agus glac sos $required nóim.';
  }

  @override
  String get infrBreakSoonTitle => 'Sos go luath';

  @override
  String infrBreakSoonText(String limit, String time, int required) {
    return '$time fágtha go dtí an teorainn $limit. Tá sos $required nóim. ag teastáil.';
  }

  @override
  String get infrDailyDriveExceededTitle => 'Tiomáint laethúil sáraithe';

  @override
  String infrDailyDriveExceededText(String limit, String time) {
    return 'Thar $limit le $time. Tosaigh do scíth laethúil.';
  }

  @override
  String get infrDailyDriveSoonTitle => 'Tiomáint laethúil ag rith amach';

  @override
  String infrDailyDriveSoonText(String limit, String time) {
    return '$time fágtha go dtí an teorainn $limit.';
  }

  @override
  String get infrExtensionInUseTitle => 'Síneadh go 10 u in úsáid';

  @override
  String infrExtensionInUseText(int count) {
    return 'Síntí fágtha an tseachtain seo: $count.';
  }

  @override
  String get infrShiftExceededTitle => 'Lá oibre sáraithe';

  @override
  String infrShiftExceededText(String limit, String time) {
    return 'Seal níos faide ná $limit le $time. Tosaigh do scíth laethúil.';
  }

  @override
  String get infrShiftSoonTitle => 'Críochnaíonn an lá oibre go luath';

  @override
  String infrShiftSoonText(String time) {
    return 'Tosaigh do scíth laethúil i gceann $time.';
  }

  @override
  String get infrWeeklyDriveExceededTitle => 'Tiomáint sheachtainiúil sáraithe';

  @override
  String infrWeeklyDriveExceededText(String limit, String time) {
    return 'Thar $limit le $time.';
  }

  @override
  String get infrWeeklyDriveSoonTitle =>
      'Tiomáint sheachtainiúil ag rith amach';

  @override
  String infrWeeklyDriveSoonText(String limit, String time) {
    return '$time fágtha go dtí $limit.';
  }

  @override
  String get infrFortnightDriveExceededTitle => 'Tiomáint coicíse sáraithe';

  @override
  String infrFortnightDriveExceededText(String limit, String time) {
    return 'Thar $limit le $time.';
  }

  @override
  String get infrFortnightDriveSoonTitle => 'Tiomáint coicíse ag rith amach';

  @override
  String infrFortnightDriveSoonText(String limit, String time) {
    return '$time fágtha go dtí $limit.';
  }

  @override
  String get infrWeeklyRestOverdueTitle => 'Scíth sheachtainiúil thar téarma';

  @override
  String infrWeeklyRestOverdueText(String time) {
    return 'Tá níos mó ná 144 u caite ón scíth sheachtainiúil roimhe seo — le $time.';
  }

  @override
  String get infrWeeklyRestSoonTitle => 'Scíth sheachtainiúil go luath';

  @override
  String infrWeeklyRestSoonText(String time) {
    return 'Tosaigh do scíth sheachtainiúil i gceann $time.';
  }

  @override
  String get infrWeeklyRestContinueTitle => 'Ná bris do scíth';

  @override
  String infrWeeklyRestContinueText(String time) {
    return 'Tá spriocdháta na scíthe seachtainiúla caite. Glac scíth $time eile ionas go n-áireofar í mar scíth sheachtainiúil.';
  }

  @override
  String get infrCompensationSoonTitle => 'Cúiteamh dlite go luath';

  @override
  String infrCompensationSoonText(String time, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days lá',
      many: '$days lá',
      few: '$days lá',
      two: '$days lá',
      one: '$days lá',
    );
    return 'Ceangail $time le scíth 9 u ar a laghad. Spriocdháta i gceann $_temp0.';
  }

  @override
  String get infrCompensationOverdueTitle => 'Cúiteamh thar téarma';

  @override
  String infrCompensationOverdueText(String time, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days lá',
      many: '$days lá',
      few: '$days lá',
      two: '$days lá',
      one: '$days lá',
    );
    return 'Níor ceanglaíodh $time don scíth sheachtainiúil laghdaithe. Thar téarma le $_temp0.';
  }

  @override
  String get infrReducedRestsExceededTitle => 'An iomarca scíthe laghdaithe';

  @override
  String infrReducedRestsExceededText(int count) {
    return 'Scíthe laghdaithe ón scíth sheachtainiúil: $count, 3 ceadaithe.';
  }

  @override
  String get infrCardOverdueTitle => 'Íoslódáil an chárta thar téarma';

  @override
  String infrCardOverdueText(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days lá',
      many: '$days lá',
      few: '$days lá',
      two: '$days lá',
      one: '$days lá',
    );
    return 'Chuaigh an spriocdháta 28 lá thart $_temp0 ó shin.';
  }

  @override
  String get infrCardSoonTitle => 'Íoslódáil an chárta go luath';

  @override
  String infrCardSoonText(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days lá',
      many: '$days lá',
      few: '$days lá',
      two: '$days lá',
      one: '$days lá',
    );
    return '$_temp0 fágtha.';
  }

  @override
  String get ferryTitle => 'Bád farantóireachta / traein';

  @override
  String get ferryHint =>
      'Ní féidir an scíth a bhriseadh ach dhá uair ar a mhéad, suas le 1 u san iomlán (Airt. 9). Ní chuireann gluaiseacht an bháid an tiomáint ar siúl.';

  @override
  String get ferryOn => 'bád';

  @override
  String breakHero(String limit) {
    return 'Sos tar éis $limit tiomána';
  }

  @override
  String breakPartDone(int minutes) {
    return '$minutes nóim. ✓';
  }

  @override
  String breakPart(int minutes) {
    return '$minutes nóim.';
  }

  @override
  String breakPartLeft(int minutes) {
    return '$minutes nóim. — fágtha';
  }

  @override
  String breakFirstTaken(String from, String to) {
    return 'An chéad chuid glactha $from–$to';
  }

  @override
  String get breakNone =>
      'Tá sos 45 nóim. d’aon iarraidh nó 15 + 30 nóim. ag teastáil.';

  @override
  String get breakSplitTitle => 'Sos roinnte 15 + 30';

  @override
  String get breakSplitText =>
      'An chéad chuid 15 nóim. ar a laghad, an dara cuid 30 nóim. ar a laghad, san ord sin go díreach. Aithníonn an aip é léi féin.';

  @override
  String get breakStart => 'Tosaigh sos';

  @override
  String get breakOngoing => 'Sos ar siúl';

  @override
  String get weeklyStartBy => 'Tosaigh faoi';

  @override
  String weeklyInTime(String left) {
    return 'i gceann $left — deireadh na seachtaine oibre (144 u)';
  }

  @override
  String weeklyOverdue(String time) {
    return 'thar téarma $time';
  }

  @override
  String get weeklyOngoing => 'Scíth sheachtainiúil ar siúl';

  @override
  String get weeklyUnknown =>
      'Níl sonraí ann faoin scíth sheachtainiúil roimhe seo. Taispeánfar an spriocdháta tar éis scíthe 24 u ar a laghad.';

  @override
  String get weeklyNext => 'An chéad scíth eile';

  @override
  String get weeklyFull => 'Rialta';

  @override
  String get weeklyFullHint => 'ní sa chab';

  @override
  String get weeklyReduced => 'Laghdaithe';

  @override
  String get weeklyReducedYes => 'ceadaithe · le cúiteamh';

  @override
  String get weeklyReducedNo =>
      'níl sé ceadaithe — tá scíth rialta ag teastáil';

  @override
  String get weeklyHistory => 'Stair';

  @override
  String weeklyPrevious(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'full': 'rialta',
      'reduced': 'laghdaithe',
      'other': 'easnamhach',
    });
    return 'Roimhe seo · $_temp0';
  }

  @override
  String get weeklyNow => 'anois';

  @override
  String get weeklyCompensation => 'Fiachas cúitimh';

  @override
  String get weeklyCompensationNone => 'níl aon cheann';

  @override
  String weeklyCompensationValue(String time, String date) {
    return '$time faoi $date';
  }

  @override
  String get weeklyMobilityOn =>
      'Pacáiste Soghluaisteachta ar siúl: in iompar idirnáisiúnta ceadaítear dhá scíth laghdaithe as a chéile má ghlactar iad lasmuigh de thír an chláraithe. Cúitítear an laghdú faoi dheireadh an tríú seachtain.';

  @override
  String get weeklyMobilityOff =>
      'Cúitítear scíth sheachtainiúil laghdaithe faoi dheireadh an tríú seachtain: ceanglaítear an fiachas le scíth 9 u ar a laghad.';

  @override
  String get weeklyStartRest => 'Tosaigh scíth';

  @override
  String get countryTitle => 'Roghnaigh tír';

  @override
  String countryChip(String start, String end) {
    return 'Tír tosaigh $start, deireadh $end. Athraigh';
  }

  @override
  String countryChipNoEnd(String start) {
    return 'Tír tosaigh $start, deireadh gan roghnú. Athraigh';
  }

  @override
  String get countryChipNone => 'Níl tír an tseala roghnaithe. Roghnaigh';

  @override
  String countryStartTab(String code) {
    return 'Tús · $code';
  }

  @override
  String countryEndTab(String code) {
    return 'Deireadh · $code';
  }

  @override
  String get countryNextShift => 'Tír an chéad seal eile';

  @override
  String get countrySearch => 'Tír nó cód';

  @override
  String get countryRecent => 'Le déanaí';

  @override
  String get countryClearEnd => 'Ná sonraigh';

  @override
  String get countryNotFound => 'Níor aimsíodh aon rud';

  @override
  String get countryFooter =>
      'Cuireann an tiománaí an tír isteach sa tacagraf ag tús agus ag deireadh an tseala (Rialachán (AE) Uimh. 165/2014, Airt. 34).';

  @override
  String countryName(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'A': 'An Ostair',
      'AL': 'An Albáin',
      'AND': 'Andóra',
      'ARM': 'An Airméin',
      'AZ': 'An Asarbaiseáin',
      'B': 'An Bheilg',
      'BG': 'An Bhulgáir',
      'BIH': 'An Bhoisnia agus an Heirseagaivéin',
      'BY': 'An Bhealarúis',
      'CH': 'An Eilvéis',
      'CY': 'An Chipir',
      'CZ': 'An tSeicia',
      'D': 'An Ghearmáin',
      'DK': 'An Danmhairg',
      'E': 'An Spáinn',
      'EST': 'An Eastóin',
      'F': 'An Fhrainc',
      'FIN': 'An Fhionlainn',
      'FL': 'Lichtinstéin',
      'GE': 'An tSeoirsia',
      'GR': 'An Ghréig',
      'H': 'An Ungáir',
      'HR': 'An Chróit',
      'I': 'An Iodáil',
      'IRL': 'Éire',
      'IS': 'An Íoslainn',
      'KZ': 'An Chasacstáin',
      'L': 'Lucsamburg',
      'LT': 'An Liotuáin',
      'LV': 'An Laitvia',
      'M': 'Málta',
      'MC': 'Monacó',
      'MD': 'An Mholdóiv',
      'MK': 'An Mhacadóin Thuaidh',
      'MNE': 'Montainéagró',
      'N': 'An Iorua',
      'NL': 'An Ísiltír',
      'P': 'An Phortaingéil',
      'PL': 'An Pholainn',
      'RO': 'An Rómáin',
      'RSM': 'San Mairíne',
      'RUS': 'An Rúis',
      'S': 'An tSualainn',
      'SK': 'An tSlóvaic',
      'SLO': 'An tSlóivéin',
      'SRB': 'An tSeirbia',
      'TJ': 'An Táidsíceastáin',
      'TM': 'An Tuircméanastáin',
      'TR': 'An Tuirc',
      'UA': 'An Úcráin',
      'UK': 'An Ríocht Aontaithe',
      'UZ': 'An Úisbéiceastáin',
      'V': 'Cathair na Vatacáine',
      'other': '$code',
    });
    return '$_temp0';
  }

  @override
  String get journalExport => 'Easpórtáil tuarascáil';

  @override
  String get journalCurrent => 'reatha';

  @override
  String get journalDriving => 'Tiomáint';

  @override
  String get journalFortnight => '2 sheachtain';

  @override
  String journalOf(int limit) {
    return 'as $limit';
  }

  @override
  String get journalCollapsedDriving => 'tiomáint';

  @override
  String journalWeekSpoken(String range, String driving, String fortnight) {
    return 'Seachtain $range. Tiomáint $driving as 56 u, thar dhá sheachtain $fortnight as 90 u';
  }

  @override
  String get journalShift => 'Seal';

  @override
  String get journalWeeklyShort => 'seacht.';

  @override
  String get journalOngoing => 'ar siúl';

  @override
  String get journalManual => 'de láimh';

  @override
  String get journalAddShift => 'Seal';

  @override
  String get journalAddShiftSpoken => 'Cuir seal leis';

  @override
  String get journalEmpty =>
      'Níl aon sealanna ann fós. Taispeánfar iad nuair a thosaíonn tú ag athrú modhanna — nó cuir seal leis de láimh.';

  @override
  String restStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'full': 'rialta',
      'reduced': 'laghdaithe',
      'other': 'easnamhach',
    });
    return '$_temp0';
  }

  @override
  String journalWeeklyRest(String status) {
    return 'Scíth sheachtainiúil · $status';
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
    return '$date, $route, $time. Tiomáint $driving, seal $span, scíth $rest';
  }

  @override
  String get journalRestNone => 'níl aon cheann';

  @override
  String get journalRestWeekly => 'seachtainiúil';

  @override
  String get journalLoadError =>
      'Níorbh fhéidir an logleabhar a oscailt. Atosaigh an aip — mura gcabhraíonn sé sin, scríobh chugainn trí “Tuilleadh”.';

  @override
  String get dayTitle => 'Seal';

  @override
  String get daySummary => 'Achoimre';

  @override
  String get dayModes => 'Modhanna';

  @override
  String get dayBreaks => 'Sosanna';

  @override
  String get dayContinuousAtEnd => 'Gan sos ag deireadh an tseala';

  @override
  String get dayRestAfter => 'Scíth tar éis an tseala';

  @override
  String dayRestKind(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'daily': 'Laethúil',
      'weekly': 'Seachtainiúil',
      'other': 'Níor thosaigh',
    });
    return '$_temp0';
  }

  @override
  String get daySplitRest => 'roinnte 3 + 9';

  @override
  String get dayManualHint =>
      'Cuireadh an seal isteach de láimh mar iomláin — níl aon taifid mhodhanna ann.';

  @override
  String get dayNotes => 'Nótaí';

  @override
  String get dayEndMark => 'deireadh an lae';

  @override
  String get dayEdit => 'Cuir an seal in eagar';

  @override
  String get dayNotFound => 'Níl an seal seo sa logleabhar a thuilleadh.';

  @override
  String dayRestUntil(String time) {
    return 'go dtí $time';
  }

  @override
  String get save => 'Sábháil';

  @override
  String get cancel => 'Cealaigh';

  @override
  String get done => 'Déanta';

  @override
  String get delete => 'Scrios';

  @override
  String get unitHours => 'u';

  @override
  String get unitMinutes => 'nóim.';

  @override
  String get pickerHours => 'Uaireanta';

  @override
  String get pickerMinutes => 'Nóiméid';

  @override
  String get pickerTime => 'Am';

  @override
  String get pickerPrevMonth => 'An mhí roimhe';

  @override
  String get pickerNextMonth => 'An chéad mhí eile';

  @override
  String pickerRange(String min, String max) {
    return 'Ceadaithe ó $min go $max';
  }

  @override
  String get shiftNewTitle => 'Seal nua';

  @override
  String get shiftSection => 'Seal';

  @override
  String get shiftStart => 'Tús';

  @override
  String get shiftEnd => 'Deireadh';

  @override
  String get shiftOnRoad => 'ar an mbóthar';

  @override
  String get shiftChoose => 'Roghnaigh';

  @override
  String get shiftNowOngoing => 'Anois (ar siúl)';

  @override
  String get shiftDuration => 'Fad';

  @override
  String get shiftNowSuffix => 'anois';

  @override
  String shiftCountrySpoken(String side, String code) {
    return '$side: tír $code. Athraigh';
  }

  @override
  String shiftDateSpoken(String side, String date, String time) {
    return '$side: $date, $time. Athraigh';
  }

  @override
  String get shiftDriving => 'Tiomáint';

  @override
  String get shiftPerDay => 'In aghaidh an lae';

  @override
  String get shiftLiveContinuous => 'ríomhtar ó na sosanna';

  @override
  String get shiftRestNone => 'Níor thosaigh';

  @override
  String get shiftRestDaily => 'Laethúil';

  @override
  String get shiftRestWeekly => 'Seachtainiúil';

  @override
  String get shiftSplit => 'Scíth roinnte 3 + 9';

  @override
  String get shiftSplitHint => 'Ar dtús 3 u, ansin 9 u';

  @override
  String shiftRestUntilNext(String when) {
    return 'Go dtí tús an tseala: $when';
  }

  @override
  String get shiftRestAutoHint =>
      'Maireann sí go dtí go dtosaíonn an chéad seal eile';

  @override
  String get shiftRestCountsWeekly =>
      'Ó 24 u áirítear an scíth mar scíth sheachtainiúil';

  @override
  String get shiftNotesHint =>
      'Mar shampla: bád farantóireachta, ag fanacht le lódáil';

  @override
  String get shiftDelete => 'Scrios an seal';

  @override
  String get shiftDeleteTitle => 'An seal a scriosadh?';

  @override
  String get shiftDeleteManual => 'Bainfear an seal den logleabhar.';

  @override
  String get shiftDeleteRecorded =>
      'Scriosfar gach taifead modha den seal seo. Ní féidir é seo a chealú.';

  @override
  String get shiftErrStartCountry => 'Roghnaigh an tír ina dtosaíonn an seal';

  @override
  String get shiftErrEndCountry => 'Sonraigh an tír ina gcríochnaíonn an seal';

  @override
  String get shiftErrEndBeforeStart => 'Críochnaíonn an seal sula dtosaíonn sé';

  @override
  String get shiftErrFuture => 'Ní féidir am an tseala a bheith sa todhchaí';

  @override
  String get shiftErrTooLong => 'Seal níos faide ná 30 u — seiceáil na dátaí';

  @override
  String get shiftErrDrivingTooLong => 'Tá an tiomáint níos faide ná an seal';

  @override
  String get shiftErrContinuous =>
      'Tiomáint leanúnach níos faide ná an tiomáint laethúil';

  @override
  String shiftErrOverlap(String range) {
    return 'Forluíonn sé leis an seal $range';
  }

  @override
  String get shiftErrNotLast =>
      'Tá sealanna eile ann ina dhiaidh seo — ní féidir leis a bheith ar siúl anois';

  @override
  String get shiftSaveFailed => 'Níorbh fhéidir sábháil. Bain triail eile as.';

  @override
  String get shiftSavedViolations => 'Sábháladh an seal. Tá sáruithe ann';

  @override
  String get shiftSavedViolationsText =>
      'Seiceáil na hamanna. Má tá gach rud ceart, taispeánfar na sáruithe sa logleabhar agus sa tuarascáil.';

  @override
  String get gotIt => 'Tuigim';

  @override
  String get shiftLiveHint =>
      'Leanann an seal na taifid mhodhanna: bogann athrú ar an tús, ar an deireadh nó ar an tiomáint na taifid féin.';

  @override
  String get shiftConvertHint =>
      'Athraíodh an t-am, an tiomáint nó an scíth — sábhálfar an seal mar iontráil de láimh in ionad na dtaifead modhanna.';

  @override
  String shiftEndNowHint(String time) {
    return 'Críochnóidh an seal ag $time, ansin tosaíonn an scíth.';
  }

  @override
  String get shiftResumeHint =>
      'Scriosfar an scíth tar éis an tseala — leanfaidh an seal ar aghaidh.';

  @override
  String shiftOngoingHint(String time, String mode) {
    return 'Beidh an seal ina sheal reatha agus leanfaidh sé ar aghaidh ar an scáileán baile ó $time. Mód “$mode” — má tá mód eile i bhfeidhm anois, athraigh ansin é.';
  }

  @override
  String get shiftUnsavedTitle => 'Na hathruithe a shábháil?';

  @override
  String get shiftUnsavedText =>
      'Níl na hathruithe ar an seal seo sábháilte fós.';

  @override
  String get shiftDiscard => 'Ná sábháil';

  @override
  String get shiftDateTimeTitle => 'Dáta agus am an tseala';

  @override
  String driveEditSubtitle(String date) {
    return 'Ceartú de láimh · $date';
  }

  @override
  String get driveEditComputed => 'Ríofa ag an aip';

  @override
  String driveEditDiff(String diff) {
    return '$diff i gcomparáid leis an ríomh.';
  }

  @override
  String get driveEditNoChange => 'Níor athraíodh an t-am.';

  @override
  String get driveEditHint =>
      'Úsáid é seo má athraíodh an mód ag an am mícheart — ríomhfar na teorainneacha arís.';

  @override
  String get driveEditNoDrive =>
      'Níl aon tiomáint sa seal reatha fós — níl aon rud le ceartú.';

  @override
  String get breakCorrection => 'Ceartú';

  @override
  String get breakCurrentDuration => 'An sos reatha';

  @override
  String get breakLastDuration => 'An sos deireanach';

  @override
  String get breakNoBreak => 'Níl aon sos sa seal fós — níl aon rud le ceartú.';

  @override
  String get breakEditHint =>
      'Tógtar an t-am ón taifead in aice láimhe — ríomhfar na teorainneacha arís.';

  @override
  String get workdayChangeStart => 'Athraigh tús an tseala';

  @override
  String get weeklyAddManually => 'Cuir isteach de láimh';

  @override
  String get exportPeriod => 'Tréimhse';

  @override
  String get exportWeek => 'An tseachtain seo';

  @override
  String get exportTwoWeeks => '2 sheachtain';

  @override
  String get exportDays28 => '28 lá';

  @override
  String get exportCustom => 'Tréimhse shaincheaptha';

  @override
  String get exportFrom => 'Ó';

  @override
  String get exportTo => 'Go';

  @override
  String exportFromDay(String date) {
    return 'Ó $date';
  }

  @override
  String exportToDay(String date) {
    return 'Go $date';
  }

  @override
  String get exportFormat => 'Formáid';

  @override
  String get exportPdf => 'PDF · don iniúchadh';

  @override
  String get exportCsv => 'CSV · scarbhileog';

  @override
  String get exportPdfHint =>
      'Ní taifead oifigiúil é: ní ghlacann an tuarascáil áit shonraí an tacagraif ná an chárta tiománaí.';

  @override
  String get exportCsvHint =>
      'Taifid mhodhanna líne ar líne, am in UTC — do Excel agus do bhogearraí cuntasaíochta.';

  @override
  String get exportLanguage => 'Teanga na tuarascála';

  @override
  String get exportNotes => 'Tíortha agus nótaí';

  @override
  String get exportCreate => 'Cruthaigh tuarascáil';

  @override
  String exportCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count seal',
      many: '$count seal',
      few: '$count sheal',
      two: '$count sheal',
      one: '$count seal',
    );
    return '$_temp0 sa tuarascáil';
  }

  @override
  String get exportEmpty => 'Níl aon sealanna sa tréimhse roghnaithe.';

  @override
  String get exportFailed =>
      'Níorbh fhéidir an tuarascáil a chruthú. Bain triail eile as.';

  @override
  String exportRangeSpoken(String from, String to) {
    return 'Tréimhse ó $from go $to';
  }

  @override
  String get reportTitle => 'Tuarascáil ar amanna tiomána agus scíthe';

  @override
  String get reportSubtitle =>
      'Rialachán (CE) Uimh. 561/2006 agus Comhaontú AETR';

  @override
  String get reportDriver => 'Tiománaí';

  @override
  String get reportCard => 'Cárta tiománaí';

  @override
  String get reportVehicle => 'Uimhir chlárúcháin';

  @override
  String get reportCompany => 'Iompróir';

  @override
  String get reportPeriod => 'Tréimhse';

  @override
  String get reportGenerated => 'Cruthaithe';

  @override
  String reportTimezone(String zone) {
    return 'Amanna i gcrios ama an fhóin ($zone). Laethanta agus seachtainí na tuarascála in UTC, tosaíonn an tseachtain Dé Luain ag 00:00, mar a bhíonn sa tacagraf.';
  }

  @override
  String get reportDate => 'Dáta';

  @override
  String get reportStart => 'Tús';

  @override
  String get reportEnd => 'Deireadh';

  @override
  String get reportCountries => 'Tíortha';

  @override
  String get reportDriving => 'Tiomáint';

  @override
  String get reportWork => 'Obair';

  @override
  String get reportAvailability => 'Infhaigh.';

  @override
  String get reportBreaks => 'Sosanna';

  @override
  String get reportSpan => 'Seal';

  @override
  String get reportRestAfter => 'Scíth ina dhiaidh';

  @override
  String get reportNotes => 'Nótaí';

  @override
  String reportWeek(String range) {
    return 'Seachtain $range';
  }

  @override
  String reportWeekTotal(String driving, String fortnight) {
    return 'Iomlán: tiomáint $driving as 56 u · thar 2 sheachtain $fortnight as 90 u';
  }

  @override
  String get reportViolations => 'Sáruithe';

  @override
  String get reportNoViolations => 'Gan sáruithe de réir an logleabhair.';

  @override
  String reportViolationDrive(String date, String time) {
    return '$date: tiomáint laethúil $time — thar 10 u';
  }

  @override
  String reportViolationSpan(String date, String time, int limit) {
    return '$date: lá oibre $time — thar $limit u';
  }

  @override
  String reportViolationRest(String date, String time) {
    return '$date: scíth tar éis an tseala $time — easnamhach';
  }

  @override
  String reportViolationWeek(String range, String time) {
    return 'Seachtain $range: tiomáint $time — thar 56 u';
  }

  @override
  String reportViolationFortnight(String range, String time) {
    return 'Seachtain $range: thar dhá sheachtain $time — thar 90 u';
  }

  @override
  String get reportMarks => 'Marcanna';

  @override
  String get reportMarkWarn =>
      '! — tiomáint sínte go 10 u, lá oibre thar 13 u nó scíth laghdaithe';

  @override
  String get reportMarkBad => '!! — sárú';

  @override
  String get reportMarkManual => '* — seal curtha isteach de láimh mar iomláin';

  @override
  String get reportDisclaimer =>
      'Tá an tuarascáil bunaithe ar iontrálacha an tiománaí san aip TachoGo. Ní taifead oifigiúil é: ní ghlacann sí áit shonraí an tacagraif ná an chárta tiománaí.';

  @override
  String get reportSignature => 'Síniú an tiománaí';

  @override
  String reportPage(int page, int pages) {
    return 'Leathanach $page as $pages';
  }

  @override
  String get openSystemSettings => 'Oscail na socruithe';

  @override
  String get settingsGeneral => 'Ginearálta';

  @override
  String get settingsLanguage => 'Teanga';

  @override
  String get settingsLanguageSystem => 'Mar atá ar an bhfón';

  @override
  String get settingsTheme => 'Cuma';

  @override
  String get themeSystem => 'Córas';

  @override
  String get themeLight => 'Geal';

  @override
  String get themeDark => 'Dorcha';

  @override
  String get settingsRules => 'Rialacha';

  @override
  String get settingsTachograph => 'Tacagraf san fheithicil';

  @override
  String get tachographDigital => 'Digiteach';

  @override
  String get tachographAnalog => 'Analógach';

  @override
  String get settingsMobility => 'Pacáiste Soghluaisteachta';

  @override
  String get settingsMobilityHint =>
      'Dhá scíth sheachtainiúla laghdaithe as a chéile in iompar idirnáisiúnta';

  @override
  String get settingsCrew => 'Criú beirt tiománaithe';

  @override
  String get settingsCrewHint =>
      'Scíth laethúil 9 u laistigh de 30 u ó thús an tseala';

  @override
  String get settingsNotifications => 'Fógraí';

  @override
  String get settingsWarnLead => 'Tabhair rabhadh faoi theorainneacha';

  @override
  String get settingsWarnLeadHint => 'Sos, deireadh an lae, tiomáint';

  @override
  String get settingsWarnLeadGroup => 'Tabhair rabhadh roimh ré';

  @override
  String leadMinutes(int minutes) {
    return '$minutes nóim.';
  }

  @override
  String leadHours(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours uair an chloig',
      many: '$hours n-uaire an chloig',
      few: '$hours huaire an chloig',
      two: '$hours uair an chloig',
      one: '$hours uair an chloig',
    );
    return '$_temp0';
  }

  @override
  String get notifyBreak => 'Sos';

  @override
  String get notifyShiftEnd => 'Deireadh an lae oibre';

  @override
  String get notifyShiftEndHint => 'Scíth laethúil agus seachtainiúil';

  @override
  String get notifyDriving => 'Teorainn tiomána';

  @override
  String get notifyCard => 'Íoslódáil an chárta';

  @override
  String get notifyCardHint => 'Gach 28 lá';

  @override
  String get notifyCardLead => 'Roimh ré';

  @override
  String get notifyCardLeadGroup => 'Rabhadh faoi íoslódáil an chárta roimh ré';

  @override
  String leadDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days lá',
      many: '$days lá',
      few: '$days lá',
      two: '$days lá',
      one: '$days lá',
    );
    return '$_temp0';
  }

  @override
  String get notifyAllow => 'Ceadaigh fógraí';

  @override
  String get notifyDenied => 'Tá fógraí blocáilte ar an bhfón faoi láthair';

  @override
  String get notifyAllowed => 'Fógraí ceadaithe';

  @override
  String get notifyExact => 'Am cruinn na bhfógraí';

  @override
  String get notifyExactHint =>
      'Ceadaigh “Aláraim agus meabhrúcháin” — seachas sin d’fhéadfadh an fón moill a chur ar rabhadh';

  @override
  String get notifyChannelLimits => 'Teorainneacha agus sáruithe';

  @override
  String get notifyChannelLimitsHint =>
      'Sos, deireadh an lae oibre, tiomáint, scíth sheachtainiúil, cárta';

  @override
  String get notifyChannelRest => 'Scíth áirithe';

  @override
  String get notifyChannelRestHint =>
      'Sos áirithe, scíth laethúil agus seachtainiúil áirithe';

  @override
  String get notifyBreakTakenTitle => 'Sos áirithe';

  @override
  String notifyBreakTakenText(int required, String time) {
    return 'Áirítear an sos $required nóim. Is féidir leat tiomáint $time go dtí an chéad sos eile.';
  }

  @override
  String get notifyDailyRestTakenTitle => 'Scíth laethúil áirithe';

  @override
  String notifyDailyRestTakenText(String limit) {
    return 'Scíth rialta $limit — is féidir leat seal a thosú.';
  }

  @override
  String get notifyWeeklyRestTakenTitle => 'Scíth sheachtainiúil áirithe';

  @override
  String notifyWeeklyRestTakenText(String limit) {
    return 'Scíth rialta $limit — is féidir leat seachtain oibre nua a thosú.';
  }

  @override
  String get serviceChannel => 'Brath uathoibríoch tiomána';

  @override
  String get serviceChannelHint =>
      'An mód reatha agus na háiritheoirí fad atá an brath uathoibríoch ar siúl';

  @override
  String get serviceStarted => 'Tá brath uathoibríoch tiomána ar siúl';

  @override
  String serviceModeTitle(String mode, String time) {
    return '$mode · $time';
  }

  @override
  String get serviceTeamTitle => 'Tá an fheithicil ag gluaiseacht';

  @override
  String serviceTeamText(String time) {
    return 'An tusa atá ag tiomáint? Tiomáint ó $time';
  }

  @override
  String get serviceSuggestTitle => 'Is cosúil go bhfuil tú ag tiomáint';

  @override
  String serviceSuggestText(String time) {
    return 'Tosú ag tiomáint ó $time? Brisfear do scíth';
  }

  @override
  String serviceDriving(String untilBreak, String dayLeft) {
    return 'Go dtí an sos $untilBreak · $dayLeft fágtha inniu';
  }

  @override
  String serviceDrivingOver(String time) {
    return 'Tá sos ag teastáil: thar an teorainn le $time';
  }

  @override
  String serviceBreakLeft(String time) {
    return 'Go dtí sos iomlán $time';
  }

  @override
  String serviceBreakDone(String time) {
    return 'Sos áirithe, is féidir leat tiomáint $time';
  }

  @override
  String serviceWorkday(String time, String limit) {
    return 'Lá oibre $time as $limit';
  }

  @override
  String serviceRestLeft(String limit, String time) {
    return 'Go dtí scíth iomlán $limit: $time';
  }

  @override
  String get serviceDailyRestDone => 'Scíth laethúil rialta áirithe';

  @override
  String get serviceWeeklyRestDone => 'Scíth sheachtainiúil rialta áirithe';

  @override
  String get serviceNotStartedText =>
      'Cuirfear an tiomáint ar siúl nuair a imeoidh an fheithicil';

  @override
  String get serviceNoModeText => 'Oscail TachoGo agus roghnaigh mód';

  @override
  String get autoTitle => 'Brath uathoibríoch tiomána';

  @override
  String get autoSwitch => 'Braith tiomáint le GPS';

  @override
  String get autoSwitchHint =>
      'Imíonn tú — tiomáint; stadann tú — obair eile. Níl ag teastáil ach an luas: ní shábháiltear comhordanáidí.';

  @override
  String get autoAfterStop => 'Tar éis stad';

  @override
  String get autoAfterStopHint => 'Tar éis 3 nóiméad ina stad';

  @override
  String get autoStartFromRest => 'Tiomáint díreach tar éis scíthe';

  @override
  String get autoStartFromRestHint =>
      'Seachas sin fiafraíonn an aip ar dtús: b’fhéidir gur paisinéir a bhí ionat';

  @override
  String get autoBattery => 'Coigilt ceallraí';

  @override
  String get autoBatteryLimited =>
      'D’fhéadfadh sé an brath a stopadh. Bain TachoGo den liosta coigilte';

  @override
  String get autoBatteryOk => 'Ní chuireann sé isteach ar obair sa chúlra';

  @override
  String get autoAutostart => 'Uath-thosú agus obair sa chúlra';

  @override
  String get autoAutostartHint =>
      'Xiaomi, Huawei, Honor, Oppo, Vivo, Samsung: ceadaigh, seachas sin stopfaidh an fón an brath';

  @override
  String get autoBlockedService =>
      'Tá suíomh múchta ar an bhfón. Cuir ar siúl é chun tiomáint a bhrath.';

  @override
  String get autoBlockedDenied =>
      'Ní féidir tiomáint a bhrath gan rochtain ar shuíomh. Níl ag teastáil ón aip ach an luas, ní shábháiltear comhordanáidí.';

  @override
  String get autoBlockedForever =>
      'Tá rochtain ar shuíomh blocáilte. Ceadaigh í i socruithe an fhóin: Suíomh → “Agus an aip á húsáid”.';

  @override
  String get autoNoAccess =>
      'Gan rochtain ar shuíomh — ní oibríonn an brath. Ceadaigh í i socruithe an fhóin.';

  @override
  String get autoEnable => 'Cuir brath tiomána ar siúl';

  @override
  String get autoEnabled => 'Tá brath tiomána ar siúl';

  @override
  String get settingsData => 'Sonraí';

  @override
  String get settingsExport => 'Easpórtáil tuarascáil';

  @override
  String get settingsExportFormats => 'PDF · CSV';

  @override
  String get settingsAnalytics => 'Staitisticí gan ainm';

  @override
  String get settingsAnalyticsHint =>
      'Na scáileáin a osclaíonn tiománaithe — chun an aip a fheabhsú. Gan comhordanáidí, ainmneacha ná uimhreacha cárta.';

  @override
  String get settingsClear => 'Glan na sonraí go léir';

  @override
  String get clearTitle => 'Na sonraí go léir a ghlanadh?';

  @override
  String get clearText =>
      'Scriosfar logleabhar na modhanna, na sealanna, na tíortha, na nótaí agus íoslódálacha an chárta. Ní féidir é seo a chealú. Fanfaidh na socruithe.';

  @override
  String get clearConfirm => 'Glan';

  @override
  String get clearDone => 'Sonraí scriosta';

  @override
  String onbStep(int step, int count) {
    return 'Céim $step as $count';
  }

  @override
  String get onbWelcomeTitle => 'Am ag an roth faoi smacht';

  @override
  String get onbWelcomeText =>
      'Áirímid tiomáint, sosanna agus scíth de réir rialacha AE 561/2006 agus AETR agus tugaimid rabhadh roimh ré faoi theorainneacha.';

  @override
  String get onbStart => 'Tosaigh';

  @override
  String get onbNext => 'Ar aghaidh';

  @override
  String get onbDone => 'Déanta';

  @override
  String get onbModesTitle => 'Ceithre mhód — mar atá ar an tacagraf';

  @override
  String get onbModesText =>
      'Athraigh an mód leis na cnaipí ar an scáileán baile. Ritheann na háiritheoirí leo féin — fiú nuair atá an aip dúnta.';

  @override
  String get onbModeDriving =>
      'Ag an roth. Áirímid tiomáint leanúnach, laethúil agus sheachtainiúil.';

  @override
  String get onbModeWork => 'Lódáil, seiceáil na feithicle, páipéarachas.';

  @override
  String get onbModeAvailability =>
      'Ag fanacht: scuaine lódála, teorainn, an dara tiománaí ag tiomáint.';

  @override
  String get onbModeRest =>
      'Sosanna agus scíth. Dúnann “Críochnaigh an lá” an seal.';

  @override
  String get onbSetupTitle => 'Socróimid duit é';

  @override
  String get onbSetupText =>
      'Is féidir é seo go léir a athrú níos déanaí sna socruithe.';

  @override
  String get onbMobilityHint =>
      'Cuir ar siúl é má thiománann tú bealaí idirnáisiúnta';

  @override
  String onbNotifyText(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes nóiméad',
      many: '$minutes nóiméad',
      few: '$minutes nóiméad',
      two: '$minutes nóiméad',
      one: '$minutes nóiméad',
    );
    return 'Tabharfaimid rabhadh duit $_temp0 roimh shos agus roimh dheireadh an lae oibre — fiú nuair atá an aip dúnta.';
  }

  @override
  String get onbAutoText =>
      'Imíonn tú — cuireann an aip an tiomáint ar siúl; stadann tú — obair eile. Tar éis scíthe fiafraíonn sí ar dtús. Níl ag teastáil ach luas an GPS: ní shábháiltear comhordanáidí ná ní sheoltar áit ar bith iad.';

  @override
  String get onbAutoLater =>
      'Is féidir leat é a chur ar siúl níos déanaí sna socruithe.';

  @override
  String languageButton(String language) {
    return 'Teanga: $language';
  }

  @override
  String get settingsVehicle => 'Feithicil';

  @override
  String get vehicleTruckOrBus => 'Leoraí nó bus';

  @override
  String get vehicleVan => 'Veain 2,5–3,5 t';

  @override
  String settingsVanHint(String date) {
    return 'Rialacha — ó $date in iompar idirnáisiúnta agus cabatáiste ar fruili nó ar luach saothair';
  }

  @override
  String onbVanText(String date) {
    return 'Tá rialacha an AE i bhfeidhm do veaineanna ó $date — in iompar idirnáisiúnta agus cabatáiste ar fruili nó ar luach saothair. Tá tacagraf cliste dara glúin sa veain, agus tá cárta ag an tiománaí.';
  }

  @override
  String get onbRulesTitle => 'Príomhrialacha';

  @override
  String get onbRulesText =>
      'Mar an gcéanna do leoraithe, busanna agus veaineanna. Ríomhann an aip iad léi féin agus tugann sí rabhadh roimh ré.';

  @override
  String get onbRulesMore =>
      'Na rialacha go léir le mínithe — “Tuilleadh” → “Treoir agus rialacha”.';

  @override
  String get guideTitle => 'Treoir agus rialacha';

  @override
  String get guideHowTo => 'Conas é a úsáid';

  @override
  String get guideStep1 =>
      'Athraigh an mód leis na cnaipí ar an scáileán baile: tiomáint, scíth, obair nó infhaighteacht.';

  @override
  String get guideStep2 =>
      'Sonraigh an tír ag tús agus ag deireadh an tseala — mar a dhéantar ar an tacagraf.';

  @override
  String get guideStep3 =>
      'Coinnigh súil ar na teorainneacha. Tabharfaidh an aip rabhadh duit roimh ré faoi shos agus faoi dheireadh an lae. Is féidir aon am a cheartú de láimh.';

  @override
  String get guideRules => 'Rialacha AE 561/2006 agus AETR';

  @override
  String get guideContinuous => 'Tiomáint gan sos';

  @override
  String guideContinuousText(String full, String first, String second) {
    return 'Ansin sos $full. Is féidir é a roinnt: ar dtús $first, ansin $second.';
  }

  @override
  String get guideDailyDriving => 'Tiomáint in aghaidh an lae';

  @override
  String guideDailyDrivingText(String extended) {
    return 'Dhá uair sa tseachtain ceadaítear suas le $extended.';
  }

  @override
  String get guideWeeklyDriving => 'Tiomáint in aghaidh na seachtaine';

  @override
  String guideWeeklyDrivingText(String fortnight) {
    return 'In aon dá sheachtain as a chéile — $fortnight ar a mhéad.';
  }

  @override
  String get guideDailyRest => 'Scíth laethúil';

  @override
  String guideDailyRestText(String reduced, String first, String second) {
    return 'Suas le trí huaire idir scíthe seachtainiúla is féidir í a laghdú go $reduced. Rogha roinnte — $first + $second.';
  }

  @override
  String get guideWorkday => 'Lá oibre';

  @override
  String guideWorkdayText(String window, String regular, String reduced) {
    return 'Ní mór don scíth críochnú laistigh de $window ó thús an tseala: $regular le scíth rialta, $reduced le scíth laghdaithe.';
  }

  @override
  String guideWorkdaySpoken(int first, int second) {
    String _temp0 = intl.Intl.pluralLogic(
      second,
      locale: localeName,
      other: '$second uair an chloig',
      many: '$second n-uaire an chloig',
      few: '$second huaire an chloig',
      two: '$second uair an chloig',
      one: '$second uair an chloig',
    );
    return '$first nó $_temp0';
  }

  @override
  String get guideWeeklyRest => 'Scíth sheachtainiúil';

  @override
  String guideWeeklyRestText(String reduced) {
    return 'Laghdaithe — $reduced, le cúiteamh faoi dheireadh an tríú seachtain. Ní féidir an scíth rialta a chaitheamh sa chab.';
  }

  @override
  String get guideWorkWeek => 'Seachtain oibre';

  @override
  String guideWorkWeekText(String period) {
    return 'Tosaíonn an scíth sheachtainiúil tráth nach déanaí ná tar éis sé thréimhse $period ón gceann roimhe.';
  }

  @override
  String get guideCard => 'Cárta tiománaí';

  @override
  String guideCardText(String days) {
    return 'Ní mór sonraí an chárta a íoslódáil uair amháin ar a laghad gach $days.';
  }

  @override
  String get guideModes => 'Dathanna agus deilbhíní';

  @override
  String get guideNewbie => 'An chéad uair le tacagraf';

  @override
  String get guideNewbieCard =>
      'Fanann an cárta sa tacagraf ar feadh an tseala ar fad';

  @override
  String get guideNewbieCardText =>
      'Cuir isteach an cárta ag tús an tseala agus bain amach é ag an deireadh. An méid a rinne tú gan an cárta — obair, infhaighteacht nó scíth — cuir isteach de láimh é an chéad uair eile a chuireann tú isteach é.';

  @override
  String get guideNewbieApp => 'Ní ghlacann an aip áit an tacagraif';

  @override
  String get guideNewbieAppText =>
      'Tá an taifead oifigiúil sa tacagraf. Athraigh an mód ansin agus anseo — ansin beidh na háiritheoirí ag teacht le chéile.';

  @override
  String get guideNewbieBreak => 'Ciallaíonn sos scíth amháin';

  @override
  String get guideNewbieBreakText =>
      'Le linn sosa ní cheadaítear tiomáint ná obair. Is obair eile í an lódáil agus an díluchtú, ní sos.';

  @override
  String get guideNewbieRestPlace => 'Cá háit le scíth a ghlacadh';

  @override
  String get guideNewbieRestPlaceText =>
      'Is féidir scíth laethúil agus scíth sheachtainiúil laghdaithe a ghlacadh san fheithicil má tá áit chodlata inti agus í ina stad. Scíth sheachtainiúil rialta agus cúiteamh — lasmuigh den fheithicil amháin.';

  @override
  String get guideNewbieCountry => 'Tíortha';

  @override
  String get guideNewbieCountryText =>
      'Cuirtear an tír isteach sa tacagraf ag tús agus ag deireadh an tseala. Taifeadann tacagraf cliste dara glúin trasnú na teorann leis féin; i seancheanna cuirtear an tír isteach ag an gcéad stad tar éis na teorann.';

  @override
  String guideVanText(String date) {
    return 'Tá na rialacha mar an gcéanna le leoraithe. Ó $date tá siad i bhfeidhm do veaineanna os cionn 2,5 t lena n-áirítear leantóir — in iompar idirnáisiúnta earraí agus cabatáiste. Tá tacagraf cliste dara glúin i veain den sórt sin, agus tá cárta ag an tiománaí.';
  }

  @override
  String get guideVanCheck => 'An bhfuil na rialacha i bhfeidhm do do thuras';

  @override
  String get guideVanTrip => 'Turas';

  @override
  String get guideVanTripHint =>
      'Cabatáiste — iompar laistigh de thír eile san AE';

  @override
  String get guideVanDomestic => 'Intíre';

  @override
  String get guideVanCrossBorder => 'Thar lear nó cabatáiste';

  @override
  String get guideVanCarriage => 'Iompar';

  @override
  String get guideVanHire => 'Ar fruili nó ar luach saothair';

  @override
  String get guideVanOwn => 'Ar do chuntas féin';

  @override
  String get guideVanNonCommercial => 'Neamhthráchtálach';

  @override
  String get guideVanCarriageHint =>
      'Ar do chuntas féin — earraí, ábhair nó uirlisí do chomhlachta. Neamhthráchtálach — gan íocaíocht ná ioncam, gan baint le hobair';

  @override
  String get guideVanMain => 'An é an tiomáint do phríomhphost?';

  @override
  String get yes => 'Tá';

  @override
  String get no => 'Níl';

  @override
  String get guideVanApplies => 'Tá na rialacha i bhfeidhm';

  @override
  String get guideVanNotApply => 'Níl na rialacha i bhfeidhm';

  @override
  String get guideVanAppliesText =>
      'Tá tacagraf agus cárta tiománaí ag teastáil, agus is ionann na teorainneacha agus do leoraí.';

  @override
  String guideVanNotYetText(String date) {
    return 'Roimh $date ní raibh veaineanna faoi na rialacha.';
  }

  @override
  String get guideVanDomesticText =>
      'Níl rialachán an AE i bhfeidhm do veaineanna in iompar intíre. Seiceáil rialacha do thíre.';

  @override
  String get guideVanOwnText =>
      'Eisceacht: iompar do do riachtanais féin, agus ní hé an tiomáint do phríomhphost.';

  @override
  String get guideVanNonCommercialText =>
      'Eisceacht: iompar gan íocaíocht ná ioncam, gan baint le hobair.';

  @override
  String guideArticle(String article) {
    return 'Rialachán 561/2006, Airt. $article';
  }

  @override
  String get guideVanNotes =>
      'Níos troime ná 3,5 t le leantóir — na rialacha mar a bhíonn do leoraí, fiú go hintíre. Turas go páirteach lasmuigh den AE — go dtí an Úcráin, an Mholdóiv, an Tuirc, na Balcáin — seiceáil leis an iompróir: níl léiriú aonfhoirmeach ann.';

  @override
  String get guideDisclaimer =>
      'Cabhraíonn TachoGo le do chuid ama a phleanáil, ach ní ghlacann sé áit an tacagraif agus ní comhairle dlí é. Is é téacs oifigiúil na rialacha Rialachán (CE) Uimh. 561/2006 agus Comhaontú AETR.';

  @override
  String get moreAbout => 'Faoin aip';

  @override
  String get moreDisclaimer =>
      'Cabhraíonn TachoGo le hamanna tiomána agus scíthe a phleanáil, ach ní ghlacann sé áit an tacagraif agus ní comhairle dlí é.';

  @override
  String get problemTitle => 'Tuairiscigh fadhb';

  @override
  String get problemHint =>
      'Leagan béite: téann an tuairisc chuig forbróirí na haipe';

  @override
  String get problemText =>
      'Tá leagan na haipe, samhail an fhóin, na socruithe, na ceadanna, sceideal na bhfógraí agus iontrálacha an logleabhair don dá lá dheireanacha sa tuairisc. Níl aon chomhordanáidí inti. Roghnaigh cá seolfar í — ríomhphost nó aip teachtaireachtaí — agus déan cur síos ar a tharla.';

  @override
  String get problemSend => 'Seol';

  @override
  String get problemSubject => 'TachoGo — fadhb sa bhéite';

  @override
  String get problemPrompt => 'Cad a tharla agus cathain (i d’fhocail féin):';

  @override
  String get problemFailed =>
      'Níorbh fhéidir an seoladh a oscailt. Bain triail eile as.';
}
