// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Uzbek (`uz`).
class AppLocalizationsUz extends AppLocalizations {
  AppLocalizationsUz([String locale = 'uz']) : super(locale);

  @override
  String get appTitle => 'TachoGo';

  @override
  String get navHome => 'Asosiy';

  @override
  String get navJournal => 'Jurnal';

  @override
  String get navSettings => 'Sozlamalar';

  @override
  String get navMore => 'Yana';

  @override
  String get close => 'Yopish';

  @override
  String get back => 'Orqaga';

  @override
  String ofLimit(String limit) {
    return '$limit dan';
  }

  @override
  String get premiumLock => 'Premium’da mavjud';

  @override
  String hoursShort(int hours) {
    return '$hours soat';
  }

  @override
  String daysShort(int days) {
    return '$days kun';
  }

  @override
  String spokenHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count soat',
      one: '$count soat',
    );
    return '$_temp0';
  }

  @override
  String spokenMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count daqiqa',
      one: '$count daqiqa',
    );
    return '$_temp0';
  }

  @override
  String spokenOverrun(String duration) {
    return 'oshib ketdi $duration';
  }

  @override
  String get modeDriving => 'Haydash';

  @override
  String get modeRest => 'Dam olish';

  @override
  String get modeWork => 'Ish';

  @override
  String get modeWorkFull => 'Boshqa ish';

  @override
  String get modeAvailability => 'Tayyorlik';

  @override
  String get modeNone => 'Rejim tanlanmagan';

  @override
  String modeSince(String time) {
    return '$time dan';
  }

  @override
  String get switchFailed => 'Rejim yozilmadi. Qayta urinib koʻring.';

  @override
  String homeShiftSince(String date, String time) {
    return '$date · smena $time dan';
  }

  @override
  String homeNoShift(String date) {
    return '$date · smena boshlanmagan';
  }

  @override
  String get homeLoadError =>
      'Jurnalni ochib boʻlmadi. Ilovani qayta ishga tushiring — yordam bermasa, «Yana» orqali bizga yozing.';

  @override
  String get heroUntilBreak => 'Tanaffusgacha';

  @override
  String get heroBreak => 'Tanaffus';

  @override
  String get heroDailyRest => 'Kunlik dam olish';

  @override
  String get heroWeeklyRest => 'Haftalik dam olish';

  @override
  String heroContinuousOf(String time, String limit) {
    return 'uzluksiz $time / $limit';
  }

  @override
  String get heroOffDutyHint =>
      'Smena tugadi. Yangisi dam olishdan boshqa birinchi rejim bilan boshlanadi.';

  @override
  String get bannerBreakNeeded45 =>
      '45 daq tanaffus kerak (yoki boʻlingan 15 + 30)';

  @override
  String get bannerBreakNeeded30 =>
      '30 daq tanaffus kerak — boʻlingan 15 + 30 ning ikkinchi qismi';

  @override
  String bannerOnBreak(String time, int required) {
    return 'Tanaffus $time / $required daq';
  }

  @override
  String bannerBreakCounted(String limit) {
    return 'Tanaffus hisoblandi — yana $limit haydash mumkin';
  }

  @override
  String get sectionAlerts => 'Ogohlantirishlar';

  @override
  String get sectionToday => 'Bugun';

  @override
  String get sectionRest => 'Dam olish';

  @override
  String get sectionWeek => 'Hafta';

  @override
  String get rowContinuous => 'Uzluksiz haydash';

  @override
  String get chipBreakSoon => 'tez orada tanaffus';

  @override
  String get chipExceeded => 'oshib ketdi';

  @override
  String get chipLimiting => 'cheklaydi';

  @override
  String get chipShiftSoon => 'tez orada tugaydi';

  @override
  String get chipLimitSoon => 'tez orada limit';

  @override
  String get chipRestSoon => 'tez orada dam olish';

  @override
  String chipTimes(int hours, int count) {
    return '$hours soat ×$count';
  }

  @override
  String limitOf(String limit) {
    return 'limit $limit';
  }

  @override
  String leftUntil(String left, String time) {
    return 'yana $left → $time';
  }

  @override
  String left(String left) {
    return 'yana $left';
  }

  @override
  String limitLeft(int hours, String left) {
    return '$hours soat: yana $left';
  }

  @override
  String limitLeftUntil(int hours, String left, String time) {
    return '$hours soat: yana $left → $time';
  }

  @override
  String limitUntil(int hours, String time) {
    return '$hours soat → $time';
  }

  @override
  String get rowWorkday => 'Ish kuni';

  @override
  String get workdayNoShift => 'Smena boshlanmagan';

  @override
  String get rowDailyDriving => 'Kunlik haydash';

  @override
  String get rowBreak => 'Tanaffus';

  @override
  String breakTaken(int minutes, String time) {
    return '$minutes daq olindi, $time da';
  }

  @override
  String breakStillNeeded(int minutes) {
    return 'yana $minutes daq';
  }

  @override
  String get breakNotTaken => 'Tanaffus hali olinmagan';

  @override
  String breakResting(String time, int required) {
    return 'Hozir tanaffus $time / $required daq';
  }

  @override
  String get rowDailyRest => 'Kunlik dam olish';

  @override
  String get dailyRestCaption => '11 soat toʻliq · 9 soat qisqartirilgan';

  @override
  String get dailyRestSplit => '3 + 9';

  @override
  String get rowWeeklyRest => 'Haftalik dam olish';

  @override
  String get weeklyRestCaption => '45 soat toʻliq · 24 soat qisqartirilgan';

  @override
  String get chipReducedAvailable => '24 soat mumkin';

  @override
  String get chipReducedUnavailable => 'faqat 45 soat';

  @override
  String get statusNotStarted => 'boshlanmagan';

  @override
  String statusInProgress(String time) {
    return 'davom etmoqda $time';
  }

  @override
  String statusBy(String when) {
    return '$when gacha';
  }

  @override
  String get statusNoData => 'maʼlumot yoʻq';

  @override
  String get rowWeeklyDriving => 'Haftalik haydash';

  @override
  String get rowFortnightDriving => 'Ikki haftalik haydash';

  @override
  String get rowWorkWeek => 'Ish haftasi';

  @override
  String workWeekSince(String since) {
    return '$since dan';
  }

  @override
  String get workWeekUnknown =>
      'Oldingi haftalik dam olish haqida maʼlumot yoʻq';

  @override
  String get cardTitle => 'Kartani oʻqish';

  @override
  String cardCaption(String last, String due) {
    return 'oxirgisi $last · muddat $due';
  }

  @override
  String get cardNever => 'Oxirgi oʻqishni belgilang';

  @override
  String cardSheetLast(String date) {
    return 'Oxirgi oʻqish: $date';
  }

  @override
  String get cardSheetNever => 'Oʻqish hali belgilanmagan.';

  @override
  String get cardSheetRule =>
      'Haydovchi kartasi maʼlumotlarini kamida 28 kunda bir marta oʻqish kerak (YeI 581/2010 Reglamenti).';

  @override
  String get cardMarkToday => 'Bugun oʻqildi';

  @override
  String get cardMarked => 'Oʻqish belgilandi';

  @override
  String get workdayStart => 'Smena boshlanishi';

  @override
  String workdayRegular(int hours) {
    return '$hours soat — oddiy kun';
  }

  @override
  String workdayRegularHint(String left) {
    return 'keyin toʻliq dam olish 11 soat · yana $left';
  }

  @override
  String workdayExtended(int hours) {
    return '$hours soat — uzaytirilgan kun';
  }

  @override
  String workdayExtendedHint(int count) {
    return 'keyin qisqartirilgan dam olish 9 soat · qoldi ×$count';
  }

  @override
  String get workdayRule =>
      'Kunlik dam olish smena boshlanganidan 24 soat ichida tugashi kerak. 9 soatlik qisqartirilgan dam olishni haftalik dam olishlar orasida koʻpi bilan uch marta olish mumkin.';

  @override
  String get workdayEndDay => 'Kunni yakunlash';

  @override
  String get workdayEndDayHint =>
      'Dam olish hozir boshlanadi va smenani yakunlaydi, hatto 9 soatdan qisqa boʻlsa ham.';

  @override
  String get endDayDriving => 'Kun davomida haydash';

  @override
  String get endDayDrivingHint =>
      'Bugun qancha vaqt rul ortida bo‘ldingiz? Rejimlarning aniq vaqti kerak emas — faqat jami.';

  @override
  String todayDate(String date) {
    return 'Bugun, $date';
  }

  @override
  String infrArticle(String regulation, String article) {
    return 'YeI $regulation · $article-modda';
  }

  @override
  String get infrContinuousExceededTitle => 'Uzluksiz haydash oshib ketdi';

  @override
  String infrContinuousExceededText(String limit, String time, int required) {
    return 'Tanaffussiz haydash $limit dan $time ga oshdi. Toʻxtang va $required daq tanaffus qiling.';
  }

  @override
  String get infrBreakSoonTitle => 'Tez orada tanaffus';

  @override
  String infrBreakSoonText(String limit, String time, int required) {
    return '$limit limitigacha $time qoldi. $required daq tanaffus kerak.';
  }

  @override
  String get infrDailyDriveExceededTitle => 'Kunlik haydash oshib ketdi';

  @override
  String infrDailyDriveExceededText(String limit, String time) {
    return '$limit dan $time ga oshdi. Kunlik dam olishni boshlang.';
  }

  @override
  String get infrDailyDriveSoonTitle => 'Kunlik haydash tugamoqda';

  @override
  String infrDailyDriveSoonText(String limit, String time) {
    return '$limit limitigacha $time qoldi.';
  }

  @override
  String get infrExtensionInUseTitle => '10 soatgacha uzaytirish davom etmoqda';

  @override
  String infrExtensionInUseText(int count) {
    return 'Bu hafta qoladigan uzaytirishlar: $count.';
  }

  @override
  String get infrShiftExceededTitle => 'Ish kuni oshib ketdi';

  @override
  String infrShiftExceededText(String limit, String time) {
    return 'Smena $limit dan $time ga uzun. Kunlik dam olishni boshlang.';
  }

  @override
  String get infrShiftSoonTitle => 'Tez orada ish kuni tugaydi';

  @override
  String infrShiftSoonText(String time) {
    return 'Kunlik dam olishni $time dan keyin boshlang.';
  }

  @override
  String get infrWeeklyDriveExceededTitle => 'Haftalik haydash oshib ketdi';

  @override
  String infrWeeklyDriveExceededText(String limit, String time) {
    return '$limit dan $time ga oshdi.';
  }

  @override
  String get infrWeeklyDriveSoonTitle => 'Haftalik haydash tugamoqda';

  @override
  String infrWeeklyDriveSoonText(String limit, String time) {
    return '$limit gacha $time qoldi.';
  }

  @override
  String get infrFortnightDriveExceededTitle =>
      'Ikki haftalik haydash oshib ketdi';

  @override
  String infrFortnightDriveExceededText(String limit, String time) {
    return '$limit dan $time ga oshdi.';
  }

  @override
  String get infrFortnightDriveSoonTitle => 'Ikki haftalik haydash tugamoqda';

  @override
  String infrFortnightDriveSoonText(String limit, String time) {
    return '$limit gacha $time qoldi.';
  }

  @override
  String get infrWeeklyRestOverdueTitle => 'Haftalik dam olish kechikdi';

  @override
  String infrWeeklyRestOverdueText(String time) {
    return 'Oldingi haftalik dam olishdan 144 soatdan koʻp vaqt oʻtdi — $time ga.';
  }

  @override
  String get infrWeeklyRestSoonTitle => 'Tez orada haftalik dam olish';

  @override
  String infrWeeklyRestSoonText(String time) {
    return 'Haftalik dam olishni $time dan keyin boshlang.';
  }

  @override
  String get infrWeeklyRestContinueTitle => 'Dam olishni toʻxtatmang';

  @override
  String infrWeeklyRestContinueText(String time) {
    return 'Haftalik dam olish muddati oʻtdi. Dam olish haftalik boʻlishi uchun yana $time dam oling.';
  }

  @override
  String get infrCompensationSoonTitle => 'Tez orada kompensatsiya muddati';

  @override
  String infrCompensationSoonText(String time, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days kun',
      one: '$days kun',
    );
    return '$time ni kamida 9 soatlik dam olishga qoʻshing. Muddatgacha $_temp0.';
  }

  @override
  String get infrCompensationOverdueTitle => 'Kompensatsiya kechikdi';

  @override
  String infrCompensationOverdueText(String time, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days kun',
      one: '$days kun',
    );
    return 'Qisqartirilgan haftalik dam olish uchun $time qoʻshilmagan. Kechikish — $_temp0.';
  }

  @override
  String get infrReducedRestsExceededTitle =>
      'Qisqartirilgan dam olishlar juda koʻp';

  @override
  String infrReducedRestsExceededText(int count) {
    return 'Haftalik dam olishdan beri qisqartirilgan: $count, ruxsat — 3.';
  }

  @override
  String get infrCardOverdueTitle => 'Kartani oʻqish kechikdi';

  @override
  String infrCardOverdueText(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days kun',
      one: '$days kun',
    );
    return '28 kunlik muddat $_temp0 oldin oʻtdi.';
  }

  @override
  String get infrCardSoonTitle => 'Tez orada kartani oʻqish';

  @override
  String infrCardSoonText(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days kun',
      one: '$days kun',
    );
    return '$_temp0 qoldi.';
  }

  @override
  String get ferryTitle => 'Parom / poyezd';

  @override
  String get ferryHint =>
      'Dam olishni koʻpi bilan ikki marta, jami 1 soatgacha toʻxtatish mumkin (9-modda). Parom harakati haydashni yoqmaydi.';

  @override
  String get ferryOn => 'parom';

  @override
  String breakHero(String limit) {
    return '$limit haydashdan keyin tanaffus';
  }

  @override
  String breakPartDone(int minutes) {
    return '$minutes daq ✓';
  }

  @override
  String breakPart(int minutes) {
    return '$minutes daq';
  }

  @override
  String breakPartLeft(int minutes) {
    return '$minutes daq — qoldi';
  }

  @override
  String breakFirstTaken(String from, String to) {
    return 'Birinchi qism olindi: $from–$to';
  }

  @override
  String get breakNone => 'Ketma-ket 45 daq yoki 15 + 30 daq tanaffus kerak.';

  @override
  String get breakSplitTitle => 'Boʻlingan tanaffus 15 + 30';

  @override
  String get breakSplitText =>
      'Birinchi qism kamida 15 daq, ikkinchisi — kamida 30 daq, aynan shu tartibda. Ilova uni oʻzi taniydi.';

  @override
  String get breakStart => 'Tanaffusni boshlash';

  @override
  String get breakOngoing => 'Tanaffus davom etmoqda';

  @override
  String get weeklyStartBy => 'Kechiktirmay boshlang';

  @override
  String weeklyInTime(String left) {
    return '$left dan keyin — ish haftasi tugaydi (144 soat)';
  }

  @override
  String weeklyOverdue(String time) {
    return '$time ga kechikdi';
  }

  @override
  String get weeklyOngoing => 'Haftalik dam olish davom etmoqda';

  @override
  String get weeklyUnknown =>
      'Oldingi haftalik dam olish haqida maʼlumot yoʻq. Muddat 24 soatdan ortiq dam olishdan keyin paydo boʻladi.';

  @override
  String get weeklyNext => 'Keyingi dam olish';

  @override
  String get weeklyFull => 'Toʻliq';

  @override
  String get weeklyFullHint => 'kabinada emas';

  @override
  String get weeklyReduced => 'Qisqartirilgan';

  @override
  String get weeklyReducedYes => 'mumkin · kompensatsiya bilan';

  @override
  String get weeklyReducedNo => 'mumkin emas — toʻliq kerak';

  @override
  String get weeklyHistory => 'Tarix';

  @override
  String weeklyPrevious(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'full': 'toʻliq',
      'reduced': 'qisqartirilgan',
      'other': 'yetarli emas',
    });
    return 'Oldingi · $_temp0';
  }

  @override
  String get weeklyNow => 'hozir';

  @override
  String get weeklyCompensation => 'Kompensatsiya qarzi';

  @override
  String get weeklyCompensationNone => 'yoʻq';

  @override
  String weeklyCompensationValue(String time, String date) {
    return '$time, muddat $date';
  }

  @override
  String get weeklyMobilityOn =>
      'Mobillik paketi yoqilgan: xalqaro tashuvlarda roʻyxatdan oʻtgan mamlakatdan tashqarida boʻlsa, ketma-ket ikkita qisqartirilgan dam olish olish mumkin. Qisqartirish uchinchi hafta oxirigacha kompensatsiya qilinadi.';

  @override
  String get weeklyMobilityOff =>
      'Qisqartirilgan haftalik dam olish uchinchi hafta oxirigacha kompensatsiya qilinadi: qarz kamida 9 soatlik dam olishga qoʻshiladi.';

  @override
  String get weeklyStartRest => 'Dam olishni boshlash';

  @override
  String get countryTitle => 'Mamlakatni tanlash';

  @override
  String countryChip(String start, String end) {
    return 'Boshlanish mamlakati $start, yakuniy $end. Oʻzgartirish';
  }

  @override
  String countryChipNoEnd(String start) {
    return 'Boshlanish mamlakati $start, yakuniy tanlanmagan. Oʻzgartirish';
  }

  @override
  String get countryChipNone => 'Smena mamlakati tanlanmagan. Tanlash';

  @override
  String countryStartTab(String code) {
    return 'Boshlanish · $code';
  }

  @override
  String countryEndTab(String code) {
    return 'Yakun · $code';
  }

  @override
  String get countryNextShift => 'Keyingi smena mamlakati';

  @override
  String get countrySearch => 'Mamlakat yoki kod';

  @override
  String get countryFrequent => 'Koʻp ishlatiladigan';

  @override
  String get countryClearEnd => 'Koʻrsatmaslik';

  @override
  String get countryNotFound => 'Hech narsa topilmadi';

  @override
  String get countryFooter =>
      'Smena boshlanishi va yakuni mamlakatini haydovchi taxografga kiritadi (YeI 165/2014 Reglamenti, 34-modda).';

  @override
  String countryName(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'A': 'Avstriya',
      'AL': 'Albaniya',
      'AND': 'Andorra',
      'ARM': 'Armaniston',
      'AZ': 'Ozarbayjon',
      'B': 'Belgiya',
      'BG': 'Bolgariya',
      'BIH': 'Bosniya va Gersegovina',
      'BY': 'Belarus',
      'CH': 'Shveysariya',
      'CY': 'Kipr',
      'CZ': 'Chexiya',
      'D': 'Germaniya',
      'DK': 'Daniya',
      'E': 'Ispaniya',
      'EST': 'Estoniya',
      'F': 'Fransiya',
      'FIN': 'Finlyandiya',
      'FL': 'Lixtenshteyn',
      'GE': 'Gruziya',
      'GR': 'Gretsiya',
      'H': 'Vengriya',
      'HR': 'Xorvatiya',
      'I': 'Italiya',
      'IRL': 'Irlandiya',
      'IS': 'Islandiya',
      'KZ': 'Qozogʻiston',
      'L': 'Lyuksemburg',
      'LT': 'Litva',
      'LV': 'Latviya',
      'M': 'Malta',
      'MC': 'Monako',
      'MD': 'Moldova',
      'MK': 'Shimoliy Makedoniya',
      'MNE': 'Chernogoriya',
      'N': 'Norvegiya',
      'NL': 'Niderlandiya',
      'P': 'Portugaliya',
      'PL': 'Polsha',
      'RO': 'Ruminiya',
      'RSM': 'San-Marino',
      'RUS': 'Rossiya',
      'S': 'Shvetsiya',
      'SK': 'Slovakiya',
      'SLO': 'Sloveniya',
      'SRB': 'Serbiya',
      'TJ': 'Tojikiston',
      'TM': 'Turkmaniston',
      'TR': 'Turkiya',
      'UA': 'Ukraina',
      'UK': 'Buyuk Britaniya',
      'UZ': 'Oʻzbekiston',
      'V': 'Vatikan',
      'other': '$code',
    });
    return '$_temp0';
  }

  @override
  String get journalExport => 'Hisobotni eksport qilish';

  @override
  String get journalCurrent => 'joriy';

  @override
  String get journalDriving => 'Haydash';

  @override
  String get journalFortnight => '2 haftada';

  @override
  String journalOf(int limit) {
    return '$limit dan';
  }

  @override
  String get journalCollapsedDriving => 'haydash';

  @override
  String journalWeekSpoken(String range, String driving, String fortnight) {
    return 'Hafta $range. Haydash $driving, limit 56 soat, ikki haftada $fortnight, limit 90 soat';
  }

  @override
  String get journalShift => 'Smena';

  @override
  String get journalWeeklyShort => 'haft.';

  @override
  String get journalOngoing => 'davom etmoqda';

  @override
  String get journalManual => 'qoʻlda';

  @override
  String get journalAddShift => 'Smena';

  @override
  String get journalAddShiftSpoken => 'Smena qoʻshish';

  @override
  String get journalEmpty =>
      'Hozircha smenalar yoʻq. Rejimlarni almashtirishni boshlaganingizda paydo boʻladi yoki smenani qoʻlda qoʻshing.';

  @override
  String restStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'full': 'toʻliq',
      'reduced': 'qisqartirilgan',
      'other': 'yetarli emas',
    });
    return '$_temp0';
  }

  @override
  String journalWeeklyRest(String status) {
    return 'Haftalik dam olish · $status';
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
    return '$date, $route, $time. Haydash $driving, smena $span, dam olish $rest';
  }

  @override
  String get journalRestNone => 'yoʻq';

  @override
  String get journalRestWeekly => 'haftalik';

  @override
  String get journalLoadError =>
      'Jurnalni ochib boʻlmadi. Ilovani qayta ishga tushiring — yordam bermasa, «Yana» orqali bizga yozing.';

  @override
  String get dayTitle => 'Smena';

  @override
  String get daySummary => 'Yakunlar';

  @override
  String get dayBreaks => 'Tanaffuslar';

  @override
  String get dayContinuousAtEnd => 'Smena oxirida uzluksiz';

  @override
  String get dayRestAfter => 'Smenadan keyingi dam olish';

  @override
  String dayRestKind(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'daily': 'Kunlik',
      'weekly': 'Haftalik',
      'other': 'Boshlanmagan',
    });
    return '$_temp0';
  }

  @override
  String get daySplitRest => 'boʻlingan 3 + 9';

  @override
  String get dayNotes => 'Izohlar';

  @override
  String get dayEdit => 'Smenani oʻzgartirish';

  @override
  String get dayNotFound => 'Bu smena jurnalda endi yoʻq.';

  @override
  String dayRestUntil(String time) {
    return '$time gacha';
  }

  @override
  String get save => 'Saqlash';

  @override
  String get cancel => 'Bekor qilish';

  @override
  String get done => 'Tayyor';

  @override
  String get delete => 'Oʻchirish';

  @override
  String get unitHours => 'soat';

  @override
  String get unitMinutes => 'daq';

  @override
  String get pickerHours => 'Soatlar';

  @override
  String get pickerMinutes => 'Daqiqalar';

  @override
  String get pickerTime => 'Vaqt';

  @override
  String get pickerPrevMonth => 'Oldingi oy';

  @override
  String get pickerNextMonth => 'Keyingi oy';

  @override
  String pickerRange(String min, String max) {
    return '$min dan $max gacha mumkin';
  }

  @override
  String get shiftNewTitle => 'Yangi smena';

  @override
  String get shiftSection => 'Smena';

  @override
  String get shiftStart => 'Boshlanish';

  @override
  String get shiftEnd => 'Yakun';

  @override
  String get shiftOnRoad => 'yoʻlda';

  @override
  String get shiftChoose => 'Tanlash';

  @override
  String get shiftNowOngoing => 'Hozir (davom etmoqda)';

  @override
  String get shiftDuration => 'Davomiylik';

  @override
  String get shiftNowSuffix => 'hozir';

  @override
  String shiftCountrySpoken(String side, String code) {
    return '$side: mamlakat $code. Oʻzgartirish';
  }

  @override
  String shiftDateSpoken(String side, String date, String time) {
    return '$side: $date, $time. Oʻzgartirish';
  }

  @override
  String get shiftDriving => 'Haydash';

  @override
  String get shiftPerDay => 'Kun davomida';

  @override
  String get shiftLiveContinuous => 'tanaffuslar boʻyicha hisoblanadi';

  @override
  String get shiftRestNone => 'Boshlanmagan';

  @override
  String get shiftRestDaily => 'Kunlik';

  @override
  String get shiftRestWeekly => 'Haftalik';

  @override
  String get shiftSplit => 'Boʻlingan dam olish 3 + 9';

  @override
  String get shiftSplitHint => 'Avval 3 soat, keyin 9 soat';

  @override
  String shiftRestUntilNext(String when) {
    return 'Smena boshlanishigacha: $when';
  }

  @override
  String get shiftRestAutoHint => 'Keyingi smena boshlanguncha davom etadi';

  @override
  String get shiftRestCountsWeekly =>
      '24 soatdan boshlab dam olish haftalik hisoblanadi';

  @override
  String get shiftNotesHint => 'Masalan: parom, yuklashni kutish';

  @override
  String get shiftDelete => 'Smenani oʻchirish';

  @override
  String get shiftDeleteTitle => 'Smena oʻchirilsinmi?';

  @override
  String get shiftDeleteManual => 'Smena jurnaldan oʻchiriladi.';

  @override
  String get shiftDeleteRecorded =>
      'Bu smenaning barcha rejim yozuvlari oʻchiriladi. Buni bekor qilib boʻlmaydi.';

  @override
  String get shiftErrStartCountry => 'Smena boshlanish mamlakatini tanlang';

  @override
  String get shiftErrEndCountry => 'Smena yakuniy mamlakatini koʻrsating';

  @override
  String get shiftErrEndBeforeStart => 'Smena yakuni boshlanishidan oldin';

  @override
  String get shiftErrFuture => 'Smena vaqti kelajakda boʻlishi mumkin emas';

  @override
  String get shiftErrTooLong => 'Smena 30 soatdan uzun — sanalarni tekshiring';

  @override
  String get shiftErrDrivingTooLong => 'Haydash smena davomiyligidan koʻp';

  @override
  String get shiftErrContinuous => 'Uzluksiz haydash kunlikdan koʻp';

  @override
  String shiftErrOverlap(String range) {
    return '$range smenasi bilan ustma-ust tushadi';
  }

  @override
  String get shiftErrNotLast =>
      'Bu smenadan keyin boshqalari bor — hozir davom eta olmaydi';

  @override
  String get shiftSaveFailed => 'Saqlab boʻlmadi. Qayta urinib koʻring.';

  @override
  String get shiftSavedViolations => 'Smena saqlandi. Qoidabuzarliklar bor';

  @override
  String get shiftSavedViolationsText =>
      'Vaqtni tekshiring. Agar hammasi shunday boʻlgan boʻlsa, qoidabuzarliklar jurnal va hisobotga tushadi.';

  @override
  String get gotIt => 'Tushunarli';

  @override
  String get shiftLiveHint =>
      'Smena rejim yozuvlari boʻyicha boradi: boshlanish, yakun va haydashni oʻzgartirish yozuvlarning oʻzini suradi.';

  @override
  String get shiftConvertHint =>
      'Vaqt, haydash yoki dam olish oʻzgartirildi — smena rejim yozuvlari oʻrniga qoʻlda kiritilgan yozuv sifatida saqlanadi.';

  @override
  String shiftEndNowHint(String time) {
    return 'Smena $time da tugaydi, keyin dam olish boshlanadi.';
  }

  @override
  String get shiftResumeHint =>
      'Smenadan keyingi dam olish oʻchiriladi — smena davom etadi.';

  @override
  String shiftOngoingHint(String time, String mode) {
    return 'Smena joriy boʻladi va asosiy ekranda $time dan davom etadi. «$mode» rejimi — hozir boshqasi boʻlsa, uni oʻsha yerda almashtiring.';
  }

  @override
  String get shiftUnsavedTitle => 'Oʻzgarishlar saqlansinmi?';

  @override
  String get shiftUnsavedText => 'Smenadagi oʻzgarishlar hali saqlanmagan.';

  @override
  String get shiftDiscard => 'Saqlamaslik';

  @override
  String get shiftDateTimeTitle => 'Smena sanasi va vaqti';

  @override
  String driveEditSubtitle(String date) {
    return 'Qoʻlda tuzatish · $date';
  }

  @override
  String get driveEditComputed => 'Ilova hisoblagan';

  @override
  String driveEditDiff(String diff) {
    return 'Hisobga nisbatan $diff.';
  }

  @override
  String get driveEditNoChange => 'Vaqt oʻzgarmagan.';

  @override
  String get driveEditHint =>
      'Rejim vaqtida almashtirilmagan boʻlsa foydalaning — limitlar qayta hisoblanadi.';

  @override
  String get driveEditNoDrive =>
      'Joriy smenada hali haydash yoʻq — tuzatadigan narsa yoʻq.';

  @override
  String get breakCorrection => 'Tuzatish';

  @override
  String get breakCurrentDuration => 'Joriy tanaffus';

  @override
  String get breakLastDuration => 'Oxirgi tanaffus';

  @override
  String get breakNoBreak =>
      'Smenada hali tanaffus yoʻq — tuzatadigan narsa yoʻq.';

  @override
  String get breakEditHint =>
      'Vaqt qoʻshni yozuvdan olinadi — limitlar qayta hisoblanadi.';

  @override
  String get workdayChangeStart => 'Smena boshlanishini oʻzgartirish';

  @override
  String get weeklyAddManually => 'Qoʻlda koʻrsatish';

  @override
  String get exportPeriod => 'Davr';

  @override
  String get exportWeek => 'Shu hafta';

  @override
  String get exportTwoWeeks => '2 hafta';

  @override
  String get exportDays28 => '28 kun';

  @override
  String get exportCustom => 'Oʻz davringiz';

  @override
  String get exportFrom => 'Boshlanish kuni';

  @override
  String get exportTo => 'Oxirgi kun';

  @override
  String exportFromDay(String date) {
    return '$date dan';
  }

  @override
  String exportToDay(String date) {
    return '$date gacha';
  }

  @override
  String get exportFormat => 'Format';

  @override
  String get exportPdf => 'PDF · tekshiruv uchun';

  @override
  String get exportCsv => 'CSV · jadval';

  @override
  String get exportPdfHint =>
      'Rasmiy yozuv emas: hisobot taxograf va haydovchi kartasi maʼlumotlari oʻrnini bosmaydi.';

  @override
  String get exportCsvHint =>
      'Rejim yozuvlari qatorma-qator, vaqt UTC boʻyicha — Excel va hisob dasturlari uchun.';

  @override
  String get exportLanguage => 'Hisobot tili';

  @override
  String get exportNotes => 'Mamlakatlar va izohlar';

  @override
  String get exportCreate => 'Hisobot yaratish';

  @override
  String exportCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count smena',
      one: '$count smena',
    );
    return 'Hisobotda $_temp0';
  }

  @override
  String get exportEmpty => 'Tanlangan davrda smenalar yoʻq.';

  @override
  String get exportFailed =>
      'Hisobotni yaratib boʻlmadi. Qayta urinib koʻring.';

  @override
  String exportRangeSpoken(String from, String to) {
    return 'Davr $from dan $to gacha';
  }

  @override
  String get reportTitle => 'Haydash va dam olish vaqti hisoboti';

  @override
  String get reportSubtitle => 'YeI 561/2006 Reglamenti va AETR Kelishuvi';

  @override
  String get reportDriver => 'Haydovchi';

  @override
  String get reportCard => 'Haydovchi kartasi';

  @override
  String get reportVehicle => 'Davlat raqami';

  @override
  String get reportCompany => 'Tashuvchi';

  @override
  String get reportPeriod => 'Davr';

  @override
  String get reportGenerated => 'Yaratildi';

  @override
  String reportTimezone(String zone) {
    return 'Vaqt — telefon vaqt mintaqasi boʻyicha ($zone). Hisobot kunlari va haftalari — UTC boʻyicha, hafta dushanba 00:00 dan, taxografdagidek.';
  }

  @override
  String get reportDate => 'Sana';

  @override
  String get reportStart => 'Boshlanish';

  @override
  String get reportEnd => 'Yakun';

  @override
  String get reportCountries => 'Mamlakatlar';

  @override
  String get reportDriving => 'Haydash';

  @override
  String get reportWork => 'Ish';

  @override
  String get reportAvailability => 'Tayyor.';

  @override
  String get reportBreaks => 'Tanaffuslar';

  @override
  String get reportSpan => 'Smena';

  @override
  String get reportRestAfter => 'Keyin dam olish';

  @override
  String get reportNotes => 'Izohlar';

  @override
  String reportWeek(String range) {
    return 'Hafta $range';
  }

  @override
  String reportWeekTotal(String driving, String fortnight) {
    return 'Jami: haydash $driving, limit 56 soat · 2 haftada $fortnight, limit 90 soat';
  }

  @override
  String get reportViolations => 'Qoidabuzarliklar';

  @override
  String get reportNoViolations => 'Jurnal boʻyicha qoidabuzarliklar yoʻq.';

  @override
  String reportViolationDrive(String date, String time) {
    return '$date: kunlik haydash $time — 10 soatdan koʻp';
  }

  @override
  String reportViolationSpan(String date, String time, int limit) {
    return '$date: ish kuni $time — $limit soatdan koʻp';
  }

  @override
  String reportViolationRest(String date, String time) {
    return '$date: smenadan keyingi dam olish $time — yetarli emas';
  }

  @override
  String reportViolationWeek(String range, String time) {
    return 'Hafta $range: haydash $time — 56 soatdan koʻp';
  }

  @override
  String reportViolationFortnight(String range, String time) {
    return 'Hafta $range: ikki haftada $time — 90 soatdan koʻp';
  }

  @override
  String get reportMarks => 'Belgilar';

  @override
  String get reportMarkWarn =>
      '! — haydashni 10 soatgacha uzaytirish, 13 soatdan uzun ish kuni yoki qisqartirilgan dam olish';

  @override
  String get reportMarkBad => '!! — qoidabuzarlik';

  @override
  String get reportMarkManual => '* — smena qoʻlda yakunlar bilan kiritilgan';

  @override
  String get reportDisclaimer =>
      'Hisobot haydovchining TachoGo ilovasidagi yozuvlari asosida tuzilgan. Bu rasmiy yozuv emas: taxograf va haydovchi kartasi maʼlumotlari oʻrnini bosmaydi.';

  @override
  String get reportSignature => 'Haydovchi imzosi';

  @override
  String reportPage(int page, int pages) {
    return '$page-bet / $pages';
  }

  @override
  String get openSystemSettings => 'Sozlamalarni ochish';

  @override
  String get settingsGeneral => 'Umumiy';

  @override
  String get settingsLanguage => 'Til';

  @override
  String get settingsLanguageSystem => 'Telefondagidek';

  @override
  String get settingsTheme => 'Koʻrinish';

  @override
  String get themeSystem => 'Tizim';

  @override
  String get themeLight => 'Yorugʻ';

  @override
  String get themeDark => 'Qorongʻi';

  @override
  String get settingsRules => 'Qoidalar';

  @override
  String get settingsTachograph => 'Mashinadagi taxograf';

  @override
  String get tachographDigital => 'Raqamli';

  @override
  String get tachographAnalog => 'Analog';

  @override
  String get settingsMobility => 'Mobillik paketi';

  @override
  String get settingsMobilityHint =>
      'Xalqaro tashuvlarda ketma-ket ikkita qisqartirilgan haftalik dam olish';

  @override
  String get settingsCrew => 'Ikki haydovchili ekipaj';

  @override
  String get settingsCrewHint =>
      'Smena boshlanganidan 30 soat ichida 9 soatlik kunlik dam olish';

  @override
  String get settingsNotifications => 'Bildirishnomalar';

  @override
  String get settingsWarnLead => 'Limitlar haqida ogohlantirish';

  @override
  String get settingsWarnLeadHint => 'Tanaffus, kun oxiri, haydash';

  @override
  String get settingsWarnLeadGroup => 'Oldindan ogohlantirish';

  @override
  String leadMinutes(int minutes) {
    return '$minutes daq';
  }

  @override
  String leadHours(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours soat',
      one: '$hours soat',
    );
    return '$_temp0';
  }

  @override
  String get notifyBreak => 'Tanaffus';

  @override
  String get notifyShiftEnd => 'Ish kuni oxiri';

  @override
  String get notifyShiftEndHint => 'Kunlik va haftalik dam olish';

  @override
  String get notifyDriving => 'Haydash limiti';

  @override
  String get notifyCard => 'Kartani oʻqish';

  @override
  String get notifyCardHint => 'Har 28 kunda';

  @override
  String get notifyCardLead => 'Oldindan ogohlantirish';

  @override
  String get notifyCardLeadGroup =>
      'Kartani oʻqish haqida oldindan ogohlantirish';

  @override
  String leadDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days kun',
      one: '$days kun',
    );
    return '$_temp0';
  }

  @override
  String get notifyAllow => 'Bildirishnomalarga ruxsat berish';

  @override
  String get notifyDenied => 'Hozir bildirishnomalar telefonda taqiqlangan';

  @override
  String get notifyAllowed => 'Bildirishnomalarga ruxsat berilgan';

  @override
  String get notifyExact => 'Bildirishnomalarning aniq vaqti';

  @override
  String get notifyExactHint =>
      '«Signallar va eslatmalar»ga ruxsat bering — aks holda telefon ogohlantirishni kechiktirishi mumkin';

  @override
  String get notifyChannelLimits => 'Limitlar va qoidabuzarliklar';

  @override
  String get notifyChannelLimitsHint =>
      'Tanaffus, ish kuni oxiri, haydash, haftalik dam olish, karta';

  @override
  String get notifyChannelRest => 'Dam olish toʻldi';

  @override
  String get notifyChannelRestHint =>
      'Tanaffus hisoblandi, kunlik va haftalik dam olish toʻldi';

  @override
  String get notifyBreakTakenTitle => 'Tanaffus hisoblandi';

  @override
  String notifyBreakTakenText(int required, String time) {
    return '$required daq tanaffus toʻldi. Keyingi tanaffusgacha $time haydash mumkin.';
  }

  @override
  String get notifyDailyRestTakenTitle => 'Kunlik dam olish toʻldi';

  @override
  String notifyDailyRestTakenText(String limit) {
    return 'Toʻliq dam olish $limit — smenani boshlash mumkin.';
  }

  @override
  String get notifyWeeklyRestTakenTitle => 'Haftalik dam olish toʻldi';

  @override
  String notifyWeeklyRestTakenText(String limit) {
    return 'Toʻliq dam olish $limit — yangi ish haftasini boshlash mumkin.';
  }

  @override
  String get serviceChannel => 'Haydashni avtoaniqlash';

  @override
  String get serviceChannelHint =>
      'Avtoaniqlash ishlayotganda joriy rejim va taymerlar';

  @override
  String get serviceStarted => 'Haydashni avtoaniqlash yoqilgan';

  @override
  String serviceModeTitle(String mode, String time) {
    return '$mode · $time';
  }

  @override
  String get serviceTeamTitle => 'Mashina ketmoqda';

  @override
  String serviceTeamText(String time) {
    return 'Rulda sizmisiz? Haydash $time dan';
  }

  @override
  String get serviceSuggestTitle => 'Ketayotganga oʻxshaysiz';

  @override
  String serviceSuggestText(String time) {
    return 'Haydashni $time dan boshlaymizmi? Dam olish toʻxtatiladi';
  }

  @override
  String serviceDriving(String untilBreak, String dayLeft) {
    return 'Tanaffusgacha $untilBreak · bugunga $dayLeft qoldi';
  }

  @override
  String serviceDrivingOver(String time) {
    return 'Tanaffus kerak: $time ga oshdi';
  }

  @override
  String serviceBreakLeft(String time) {
    return 'Toʻliq tanaffusgacha $time';
  }

  @override
  String serviceBreakDone(String time) {
    return 'Tanaffus hisoblandi, $time haydash mumkin';
  }

  @override
  String serviceWorkday(String time, String limit) {
    return 'Ish kuni $time / $limit';
  }

  @override
  String serviceRestLeft(String limit, String time) {
    return 'Toʻliq dam olishgacha ($limit): $time';
  }

  @override
  String get serviceDailyRestDone => 'Toʻliq kunlik dam olish toʻldi';

  @override
  String get serviceWeeklyRestDone => 'Toʻliq haftalik dam olish toʻldi';

  @override
  String get serviceNotStartedText => 'Mashina yurganda haydash oʻzi yoqiladi';

  @override
  String get serviceNoModeText => 'TachoGo’ni oching va rejimni tanlang';

  @override
  String get autoTitle => 'Haydashni avtoaniqlash';

  @override
  String get autoSwitch => 'Haydashni GPS orqali aniqlash';

  @override
  String get autoSwitchHint =>
      'Yurdingiz — haydash, toʻxtadingiz — boshqa ish. Faqat tezlik kerak: koordinatalar saqlanmaydi.';

  @override
  String get autoAfterStop => 'Toʻxtagandan keyin';

  @override
  String get autoAfterStopHint => '3 daqiqa turgandan keyin';

  @override
  String get autoStartFromRest => 'Dam olishdan keyin darhol haydash';

  @override
  String get autoStartFromRestHint =>
      'Aks holda ilova avval soʻraydi: siz yoʻlovchi boʻlib ketayotgan boʻlishingiz mumkin';

  @override
  String get autoBattery => 'Batareyani tejash';

  @override
  String get autoBatteryLimited =>
      'Avtoaniqlashni toʻxtatishi mumkin. TachoGo’ni tejash roʻyxatidan chiqaring';

  @override
  String get autoBatteryOk => 'Fonda ishlashga xalal bermaydi';

  @override
  String get autoAutostart => 'Avtoishga tushirish va fonda ishlash';

  @override
  String get autoAutostartHint =>
      'Xiaomi, Huawei, Honor, Oppo, Vivo, Samsung: ruxsat bering, aks holda telefon avtoaniqlashni toʻxtatadi';

  @override
  String get autoBlockedService =>
      'Telefonda geolokatsiya oʻchirilgan. Haydashni aniqlash uchun uni yoqing.';

  @override
  String get autoBlockedDenied =>
      'Geolokatsiyaga ruxsatsiz haydashni aniqlab boʻlmaydi. Ilovaga faqat tezlik kerak, koordinatalar saqlanmaydi.';

  @override
  String get autoBlockedForever =>
      'Geolokatsiyaga ruxsat taqiqlangan. Uni telefon sozlamalarida bering: Geolokatsiya → «Ilovadan foydalanganda».';

  @override
  String get autoNoAccess =>
      'Geolokatsiyaga ruxsat yoʻq — avtoaniqlash ishlamaydi. Uni telefon sozlamalarida bering.';

  @override
  String get autoEnable => 'Avtoaniqlashni yoqish';

  @override
  String get autoEnabled => 'Avtoaniqlash yoqilgan';

  @override
  String get settingsData => 'Maʼlumotlar';

  @override
  String get settingsExport => 'Hisobotni eksport qilish';

  @override
  String get settingsExportFormats => 'PDF · CSV';

  @override
  String get settingsAnalytics => 'Anonim statistika';

  @override
  String get settingsAnalyticsHint =>
      'Haydovchilar qaysi ekranlarni ochadi — ilovani yaxshilash uchun. Koordinatalar, ismlar va karta raqamlarisiz.';

  @override
  String get settingsClear => 'Barcha maʼlumotlarni tozalash';

  @override
  String get clearTitle => 'Barcha maʼlumotlar tozalansinmi?';

  @override
  String get clearText =>
      'Rejimlar jurnali, smenalar, mamlakatlar, izohlar va karta oʻqishlari oʻchiriladi. Buni bekor qilib boʻlmaydi. Sozlamalar qoladi.';

  @override
  String get clearConfirm => 'Tozalash';

  @override
  String get clearDone => 'Maʼlumotlar oʻchirildi';

  @override
  String onbStep(int step, int count) {
    return '$step-qadam / $count';
  }

  @override
  String get onbWelcomeTitle => 'Rul ortidagi vaqt — nazorat ostida';

  @override
  String get onbWelcomeText =>
      'Haydash, tanaffus va dam olishni YeI 561/2006 va AETR qoidalari boʻyicha hisoblaymiz va limitlar haqida oldindan ogohlantiramiz.';

  @override
  String get onbStart => 'Boshlash';

  @override
  String get onbNext => 'Keyingi';

  @override
  String get onbDone => 'Tayyor';

  @override
  String get onbModesTitle => 'Toʻrt rejim — taxografdagidek';

  @override
  String get onbModesText =>
      'Rejimni asosiy ekrandagi tugmalar bilan almashtiring. Taymerlar oʻzi hisoblaydi — ilova yopiq boʻlsa ham.';

  @override
  String get onbModeDriving =>
      'Rulda. Uzluksiz, kunlik va haftalik haydashni hisoblaymiz.';

  @override
  String get onbModeWork =>
      'Yuklash, mashinani koʻrikdan oʻtkazish, hujjatlar.';

  @override
  String get onbModeAvailability =>
      'Kutish: yuklash navbati, chegara, yoʻldagi ikkinchi haydovchi.';

  @override
  String get onbModeRest =>
      'Tanaffus va dam olish. «Kunni yakunlash» smenani yopadi.';

  @override
  String get onbSetupTitle => 'Sizga moslaymiz';

  @override
  String get onbSetupText =>
      'Bularning hammasini keyinroq sozlamalarda oʻzgartirish mumkin.';

  @override
  String get onbMobilityHint => 'Xalqaro reyslarda yursangiz, yoqing';

  @override
  String onbNotifyText(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes daqiqa',
      one: '$minutes daqiqa',
    );
    return 'Tanaffus va ish kuni oxiridan $_temp0 oldin ogohlantiramiz — ilova yopiq boʻlsa ham.';
  }

  @override
  String get onbAutoText =>
      'Yurdingiz — ilova haydashni yoqadi, toʻxtadingiz — boshqa ishni. Dam olishdan keyin avval soʻraydi. Faqat GPS tezligi kerak: koordinatalar saqlanmaydi va hech qayerga yuborilmaydi.';

  @override
  String get onbAutoLater => 'Keyinroq sozlamalarda yoqish mumkin.';

  @override
  String languageButton(String language) {
    return 'Til: $language';
  }

  @override
  String get vehicleVan => 'Furgon 2,5–3,5 t';

  @override
  String get onbRulesTitle => 'Asosiy qoidalar';

  @override
  String get onbRulesText =>
      'Yuk mashinalari, avtobuslar va furgonlar uchun bir xil. Ilova ularni oʻzi hisoblaydi va oldindan ogohlantiradi.';

  @override
  String get onbRulesMore =>
      'Barcha qoidalar izohlar bilan — «Yana» → «Yoʻriqnoma va qoidalar».';

  @override
  String get guideTitle => 'Yoʻriqnoma va qoidalar';

  @override
  String get guideHowTo => 'Qanday foydalanish';

  @override
  String get guideStep1 =>
      'Rejimni asosiy ekrandagi tugmalar bilan almashtiring: haydash, dam olish, ish yoki tayyorlik.';

  @override
  String get guideStep2 =>
      'Smena boshlanishi va yakuni mamlakatini koʻrsating — taxografdagidek.';

  @override
  String get guideStep3 =>
      'Limitlarni kuzating. Ilova tanaffus va kun oxiri haqida oldindan ogohlantiradi. Istalgan vaqtni qoʻlda tuzatish mumkin.';

  @override
  String get guideRules => 'YeI 561/2006 va AETR qoidalari';

  @override
  String get guideContinuous => 'Uzluksiz haydash';

  @override
  String guideContinuousText(String full, String first, String second) {
    return 'Keyin $full tanaffus. Boʻlish mumkin: avval $first, keyin $second.';
  }

  @override
  String get guideDailyDriving => 'Kunlik haydash';

  @override
  String guideDailyDrivingText(String extended) {
    return 'Haftada ikki marta $extended gacha mumkin.';
  }

  @override
  String get guideWeeklyDriving => 'Haftalik haydash';

  @override
  String guideWeeklyDrivingText(String fortnight) {
    return 'Istalgan ketma-ket ikki haftada — koʻpi bilan $fortnight.';
  }

  @override
  String get guideDailyRest => 'Kunlik dam olish';

  @override
  String guideDailyRestText(String reduced, String first, String second) {
    return 'Haftalik dam olishlar orasida uch martagacha $reduced gacha qisqartirish mumkin. Boʻlingan variant — $first + $second.';
  }

  @override
  String get guideWorkday => 'Ish kuni';

  @override
  String guideWorkdayText(String window, String regular, String reduced) {
    return 'Dam olish smena boshlanganidan $window ichida tugashi kerak: toʻliq dam olishda $regular, qisqartirilganda $reduced.';
  }

  @override
  String guideWorkdaySpoken(int first, int second) {
    String _temp0 = intl.Intl.pluralLogic(
      second,
      locale: localeName,
      other: '$second soat',
      one: '$second soat',
    );
    return '$first yoki $_temp0';
  }

  @override
  String get guideWeeklyRest => 'Haftalik dam olish';

  @override
  String guideWeeklyRestText(String reduced) {
    return 'Qisqartirilgani — $reduced, uchinchi hafta oxirigacha kompensatsiya bilan. Toʻliq dam olishni kabinada oʻtkazib boʻlmaydi.';
  }

  @override
  String get guideWorkWeek => 'Ish haftasi';

  @override
  String guideWorkWeekText(String period) {
    return 'Haftalik dam olish oldingisidan keyin koʻpi bilan 6 × $period oʻtgach boshlanadi.';
  }

  @override
  String get guideCard => 'Haydovchi kartasi';

  @override
  String guideCardText(String days) {
    return 'Karta maʼlumotlarini kamida ${days}da bir marta oʻqish kerak.';
  }

  @override
  String get guideModes => 'Ranglar va belgilar';

  @override
  String get guideNewbie => 'Taxograf bilan birinchi marta';

  @override
  String get guideNewbieCard => 'Karta — butun smena taxografda';

  @override
  String get guideNewbieCardText =>
      'Kartani smena boshida qoʻying va oxirida chiqaring. Kartasiz nima qilganingizni — ish, tayyorlik yoki dam olishni — keyingi qoʻyishda qoʻlda kiriting.';

  @override
  String get guideNewbieApp => 'Ilova taxograf oʻrnini bosmaydi';

  @override
  String get guideNewbieAppText =>
      'Rasmiy yozuv — taxografda. Rejimni u yerda ham, bu yerda ham almashtiring — shunda taymerlar mos keladi.';

  @override
  String get guideNewbieBreak => 'Tanaffus — faqat dam olish';

  @override
  String get guideNewbieBreakText =>
      'Tanaffus vaqtida haydash va ishlash mumkin emas. Yuklash va tushirish — boshqa ish, tanaffus emas.';

  @override
  String get guideNewbieRestPlace => 'Qayerda dam olish';

  @override
  String get guideNewbieRestPlaceText =>
      'Kunlik va qisqartirilgan haftalik dam olishni mashinada oʻtkazish mumkin, agar unda yotoq joyi boʻlsa va u turgan boʻlsa. Muntazam haftalik dam olish va kompensatsiya — faqat mashinadan tashqarida.';

  @override
  String get guideNewbieCountry => 'Mamlakatlar';

  @override
  String get guideNewbieCountryText =>
      'Mamlakat taxografga smena boshida va oxirida kiritiladi. Chegarani kesib oʻtishni ikkinchi avlod aqlli taxografi oʻzi yozadi, eskilarida mamlakat chegaradan keyingi birinchi toʻxtashda kiritiladi.';

  @override
  String guideVanText(String date) {
    return 'Qoidalar yuk mashinalari bilan bir xil. $date dan ular tirkama bilan birga 2,5 t dan ogʻir furgonlarga amal qiladi — xalqaro yuk tashish va kabotajda. Bunday furgonda — ikkinchi avlod aqlli taxografi, haydovchida — karta.';
  }

  @override
  String get guideVanCheck => 'Qoidalar reysingizga tegishlimi';

  @override
  String get guideVanTrip => 'Reys';

  @override
  String get guideVanTripHint =>
      'Kabotaj — boshqa YeI mamlakati ichida tashish';

  @override
  String get guideVanDomestic => 'Mamlakat ichida';

  @override
  String get guideVanCrossBorder => 'Chet elga yoki kabotaj';

  @override
  String get guideVanCarriage => 'Tashish';

  @override
  String get guideVanHire => 'Yollanma';

  @override
  String get guideVanOwn => 'Oʻz yuki';

  @override
  String get guideVanNonCommercial => 'Notijorat';

  @override
  String get guideVanCarriageHint =>
      'Oʻz yuki — firmangizning tovari, materiallari yoki asboblari. Notijorat — toʻlov va daromadsiz, ish bilan bogʻliq emas';

  @override
  String get guideVanMain => 'Haydash — asosiy ishingizmi?';

  @override
  String get yes => 'Ha';

  @override
  String get no => 'Yoʻq';

  @override
  String get guideVanApplies => 'Qoidalar amal qiladi';

  @override
  String get guideVanNotApply => 'Qoidalar amal qilmaydi';

  @override
  String get guideVanAppliesText =>
      'Taxograf va haydovchi kartasi kerak, limitlar — yuk mashinasidagidek.';

  @override
  String guideVanNotYetText(String date) {
    return '$date gacha furgonlar qoidalarga kirmagan.';
  }

  @override
  String get guideVanDomesticText =>
      'YeI Reglamenti mamlakat ichida furgonlarga tegishli emas. Oʻz mamlakatingiz qoidalarini tekshiring.';

  @override
  String get guideVanOwnText =>
      'Istisno: oʻz yukini tashish va haydash asosiy ish emas.';

  @override
  String get guideVanNonCommercialText =>
      'Istisno: toʻlov va daromadsiz, ish bilan bogʻliq boʻlmagan tashish.';

  @override
  String guideArticle(String article) {
    return '561/2006 Reglamenti, $article-modda';
  }

  @override
  String get guideVanNotes =>
      'Tirkama bilan birga 3,5 t dan ogʻir — qoidalar yuk mashinasidagidek, mamlakat ichida ham. Reys qisman YeI dan tashqarida — Ukraina, Moldova, Turkiya, Bolqonga — tashuvchidan aniqlang: yagona talqin yoʻq.';

  @override
  String get guideDisclaimer =>
      'TachoGo vaqtni rejalashtirishga yordam beradi, lekin taxograf oʻrnini bosmaydi va yuridik maslahat emas. Qoidalarning rasmiy matni — YeI 561/2006 Reglamenti va AETR Kelishuvi.';

  @override
  String get moreAbout => 'Ilova haqida';

  @override
  String get moreDisclaimer =>
      'TachoGo rul ortidagi vaqt va dam olishni rejalashtirishga yordam beradi, lekin taxograf oʻrnini bosmaydi va yuridik maslahat emas.';

  @override
  String get problemTitle => 'Muammo haqida xabar berish';

  @override
  String get problemHint =>
      'Beta versiya: hisobot ishlab chiquvchilarga yuboriladi';

  @override
  String get problemText =>
      'Hisobotga ilova versiyasi, telefon modeli, sozlamalar, ruxsatlar, bildirishnomalar jadvali va oxirgi ikki sutkadagi jurnal yozuvlari kiradi. Unda koordinatalar yoʻq. Qayerga yuborishni tanlang — pochta yoki messenjer — va nima boʻlganini yozing.';

  @override
  String get problemSend => 'Yuborish';

  @override
  String get problemSubject => 'TachoGo — beta versiyadagi muammo';

  @override
  String get problemPrompt =>
      'Nima boʻldi va qachon (oʻz soʻzlaringiz bilan yozing):';

  @override
  String get problemFailed =>
      'Yuborishni ochib boʻlmadi. Qayta urinib koʻring.';

  @override
  String get transferTitle => 'Boshqa telefonga koʻchirish';

  @override
  String get transferHint =>
      'Jurnal fayl koʻrinishida — messenjer yoki pochta orqali';

  @override
  String get transferText =>
      'Eski telefonda jurnalni faylga saqlang va oʻzingizga yuboring — messenjerga, pochtaga yoki bulutga. Yangi telefonda xuddi shu ekranni oching va faylni yuklang: jurnal, karta oʻqishlari va hisob sozlamalari eski telefondagidek boʻladi.';

  @override
  String get transferSave => 'Jurnalni faylga saqlash';

  @override
  String get transferLoad => 'Jurnalni fayldan yuklash';

  @override
  String get transferConfirmTitle => 'Jurnal yuklansinmi?';

  @override
  String transferConfirmRange(String from, String to) {
    return 'Faylda $from dan $to gacha boʻlgan jurnal bor.';
  }

  @override
  String get transferConfirmReplace =>
      'Bu telefondagi jurnal fayldagi jurnal bilan almashtiriladi.';

  @override
  String get transferConfirm => 'Yuklash';

  @override
  String get transferDone => 'Jurnal yuklandi';

  @override
  String get transferEmpty => 'Faylda jurnal yozuvlari yoʻq';

  @override
  String get transferNotBackup =>
      'Bu TachoGo jurnali fayli emas — tachogo-journal faylini tanlang';

  @override
  String get transferNewer =>
      'Fayl TachoGo ning yangiroq versiyasida saqlangan — ilovani yangilang';

  @override
  String get transferDamaged =>
      'Jurnal fayli buzilgan — uni eski telefonda qaytadan saqlang';

  @override
  String get transferFailed =>
      'Jurnalni yuklab boʻlmadi. Telefondagi jurnal oʻzgarmadi';

  @override
  String get transferSaveFailed =>
      'Faylni saqlab boʻlmadi. Qayta urinib koʻring.';
}
