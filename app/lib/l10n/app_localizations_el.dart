// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Modern Greek (`el`).
class AppLocalizationsEl extends AppLocalizations {
  AppLocalizationsEl([String locale = 'el']) : super(locale);

  @override
  String get appTitle => 'TachoGo';

  @override
  String get navHome => 'Αρχική';

  @override
  String get navJournal => 'Ημερολόγιο';

  @override
  String get navSettings => 'Ρυθμίσεις';

  @override
  String get navMore => 'Περισσότερα';

  @override
  String get close => 'Κλείσιμο';

  @override
  String get back => 'Πίσω';

  @override
  String ofLimit(String limit) {
    return 'από $limit';
  }

  @override
  String get premiumLock => 'Διαθέσιμο στο Premium';

  @override
  String hoursShort(int hours) {
    return '$hours ώ';
  }

  @override
  String daysShort(int days) {
    return '$days ημ.';
  }

  @override
  String spokenHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ώρες',
      one: '$count ώρα',
    );
    return '$_temp0';
  }

  @override
  String spokenMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count λεπτά',
      one: '$count λεπτό',
    );
    return '$_temp0';
  }

  @override
  String spokenOverrun(String duration) {
    return 'υπέρβαση κατά $duration';
  }

  @override
  String get modeDriving => 'Οδήγηση';

  @override
  String get modeRest => 'Ανάπαυση';

  @override
  String get modeWork => 'Εργασία';

  @override
  String get modeWorkFull => 'Άλλη εργασία';

  @override
  String get modeAvailability => 'Διαθεσιμότητα';

  @override
  String get modeNone => 'Δεν επιλέχθηκε κατάσταση';

  @override
  String modeSince(String time) {
    return 'από $time';
  }

  @override
  String get switchFailed => 'Η κατάσταση δεν αποθηκεύτηκε. Δοκιμάστε ξανά.';

  @override
  String homeShiftSince(String date, String time) {
    return '$date · βάρδια από $time';
  }

  @override
  String homeNoShift(String date) {
    return '$date · η βάρδια δεν έχει αρχίσει';
  }

  @override
  String get homeLoadError =>
      'Δεν ήταν δυνατό να ανοίξει το ημερολόγιο. Επανεκκινήστε την εφαρμογή — αν δεν βοηθήσει, γράψτε μας από το «Περισσότερα».';

  @override
  String get heroUntilBreak => 'Έως το διάλειμμα';

  @override
  String get heroBreak => 'Διάλειμμα';

  @override
  String get heroDailyRest => 'Ημερήσια ανάπαυση';

  @override
  String get heroWeeklyRest => 'Εβδομαδιαία ανάπαυση';

  @override
  String heroContinuousOf(String time, String limit) {
    return 'χωρίς διάλειμμα $time από $limit';
  }

  @override
  String get heroOffDutyHint =>
      'Η βάρδια τελείωσε. Η επόμενη αρχίζει με την πρώτη κατάσταση που δεν είναι ανάπαυση.';

  @override
  String get bannerBreakNeeded45 =>
      'Χρειάζεται διάλειμμα 45 λεπτών (ή χωρισμένο 15 + 30)';

  @override
  String get bannerBreakNeeded30 =>
      'Χρειάζεται διάλειμμα 30 λεπτών — το δεύτερο μέρος του χωρισμένου 15 + 30';

  @override
  String bannerOnBreak(String time, int required) {
    return 'Διάλειμμα $time από $required λεπ.';
  }

  @override
  String bannerBreakCounted(String limit) {
    return 'Το διάλειμμα μετρήθηκε — μπορείτε να οδηγήσετε $limit';
  }

  @override
  String get sectionAlerts => 'Προειδοποιήσεις';

  @override
  String get sectionToday => 'Σήμερα';

  @override
  String get sectionRest => 'Ανάπαυση';

  @override
  String get sectionWeek => 'Εβδομάδα';

  @override
  String get rowContinuous => 'Οδήγηση χωρίς διάλειμμα';

  @override
  String get chipBreakSoon => 'σύντομα διάλειμμα';

  @override
  String get chipExceeded => 'υπέρβαση';

  @override
  String get chipLimiting => 'περιορίζει';

  @override
  String get chipShiftSoon => 'λήγει σύντομα';

  @override
  String get chipLimitSoon => 'σύντομα όριο';

  @override
  String get chipRestSoon => 'σύντομα ανάπαυση';

  @override
  String chipTimes(int hours, int count) {
    return '$hours ώ ×$count';
  }

  @override
  String limitOf(String limit) {
    return 'όριο $limit';
  }

  @override
  String leftUntil(String left, String time) {
    return 'απομένουν $left → $time';
  }

  @override
  String left(String left) {
    return 'απομένουν $left';
  }

  @override
  String limitLeft(int hours, String left) {
    return '$hours ώ: απομένουν $left';
  }

  @override
  String limitLeftUntil(int hours, String left, String time) {
    return '$hours ώ: απομένουν $left → $time';
  }

  @override
  String limitUntil(int hours, String time) {
    return '$hours ώ → $time';
  }

  @override
  String get rowWorkday => 'Εργάσιμη ημέρα';

  @override
  String get workdayNoShift => 'Η βάρδια δεν έχει αρχίσει';

  @override
  String get rowDailyDriving => 'Ημερήσιος χρόνος οδήγησης';

  @override
  String get rowBreak => 'Διάλειμμα';

  @override
  String breakTaken(int minutes, String time) {
    return 'Έγινε $minutes λεπ. στις $time';
  }

  @override
  String breakStillNeeded(int minutes) {
    return 'Ακόμη $minutes λεπ.';
  }

  @override
  String get breakNotTaken => 'Δεν έχει γίνει διάλειμμα ακόμη';

  @override
  String breakResting(String time, int required) {
    return 'Διάλειμμα τώρα $time από $required λεπ.';
  }

  @override
  String get rowDailyRest => 'Ημερήσια ανάπαυση';

  @override
  String get dailyRestCaption => '11 ώ κανονική · 9 ώ μειωμένη';

  @override
  String get dailyRestSplit => '3 + 9';

  @override
  String get rowWeeklyRest => 'Εβδομαδιαία ανάπαυση';

  @override
  String get weeklyRestCaption => '45 ώ κανονική · 24 ώ μειωμένη';

  @override
  String get chipReducedAvailable => 'επιτρέπονται 24 ώ';

  @override
  String get chipReducedUnavailable => 'μόνο 45 ώ';

  @override
  String get statusNotStarted => 'δεν άρχισε';

  @override
  String statusInProgress(String time) {
    return 'σε εξέλιξη $time';
  }

  @override
  String statusBy(String when) {
    return 'έως $when';
  }

  @override
  String get statusNoData => 'χωρίς δεδομένα';

  @override
  String get rowWeeklyDriving => 'Εβδομαδιαίος χρόνος οδήγησης';

  @override
  String get rowFortnightDriving => 'Χρόνος οδήγησης δύο εβδομάδων';

  @override
  String get rowWorkWeek => 'Εργάσιμη εβδομάδα';

  @override
  String workWeekSince(String since) {
    return 'από $since';
  }

  @override
  String get workWeekUnknown =>
      'Δεν υπάρχουν δεδομένα για την προηγούμενη εβδομαδιαία ανάπαυση';

  @override
  String get cardTitle => 'Μεταφόρτωση κάρτας';

  @override
  String cardCaption(String last, String due) {
    return 'τελευταία $last · προθεσμία $due';
  }

  @override
  String get cardNever => 'Σημειώστε την τελευταία μεταφόρτωση';

  @override
  String cardSheetLast(String date) {
    return 'Τελευταία μεταφόρτωση: $date';
  }

  @override
  String get cardSheetNever => 'Δεν έχει σημειωθεί μεταφόρτωση ακόμη.';

  @override
  String get cardSheetRule =>
      'Τα δεδομένα της κάρτας οδηγού πρέπει να μεταφορτώνονται τουλάχιστον κάθε 28 ημέρες (κανονισμός (ΕΕ) αριθ. 581/2010).';

  @override
  String get cardMarkToday => 'Μεταφορτώθηκε σήμερα';

  @override
  String get cardMarked => 'Η μεταφόρτωση σημειώθηκε';

  @override
  String get workdayStart => 'Έναρξη βάρδιας';

  @override
  String workdayRegular(int hours) {
    return '$hours ώ — κανονική ημέρα';
  }

  @override
  String workdayRegularHint(String left) {
    return 'μετά κανονική ανάπαυση 11 ώ · απομένουν $left';
  }

  @override
  String workdayExtended(int hours) {
    return '$hours ώ — παρατεταμένη ημέρα';
  }

  @override
  String workdayExtendedHint(int count) {
    return 'μετά μειωμένη ανάπαυση 9 ώ · απομένουν ×$count';
  }

  @override
  String get workdayRule =>
      'Η ημερήσια ανάπαυση πρέπει να λήξει εντός 24 ωρών από την έναρξη της βάρδιας. Η μειωμένη ανάπαυση 9 ωρών επιτρέπεται έως τρεις φορές μεταξύ δύο εβδομαδιαίων αναπαύσεων.';

  @override
  String get workdayEndDay => 'Τέλος ημέρας';

  @override
  String get workdayEndDayHint =>
      'Η ανάπαυση αρχίζει τώρα και κλείνει τη βάρδια, ακόμη κι αν είναι μικρότερη από 9 ώ.';

  @override
  String todayDate(String date) {
    return 'Σήμερα, $date';
  }

  @override
  String infrArticle(String regulation, String article) {
    return 'ΕΕ $regulation · άρθρο $article';
  }

  @override
  String get infrContinuousExceededTitle => 'Υπέρβαση συνεχούς οδήγησης';

  @override
  String infrContinuousExceededText(String limit, String time, int required) {
    return 'Οδήγηση χωρίς διάλειμμα πέραν των $limit κατά $time. Σταματήστε και κάντε διάλειμμα $required λεπτών.';
  }

  @override
  String get infrBreakSoonTitle => 'Σύντομα διάλειμμα';

  @override
  String infrBreakSoonText(String limit, String time, int required) {
    return 'Απομένουν $time έως το όριο των $limit. Χρειάζεται διάλειμμα $required λεπτών.';
  }

  @override
  String get infrDailyDriveExceededTitle => 'Υπέρβαση ημερήσιας οδήγησης';

  @override
  String infrDailyDriveExceededText(String limit, String time) {
    return 'Πέραν των $limit κατά $time. Αρχίστε την ημερήσια ανάπαυση.';
  }

  @override
  String get infrDailyDriveSoonTitle => 'Η ημερήσια οδήγηση τελειώνει';

  @override
  String infrDailyDriveSoonText(String limit, String time) {
    return 'Απομένουν $time έως το όριο των $limit.';
  }

  @override
  String get infrExtensionInUseTitle => 'Σε χρήση παράταση έως 10 ώ';

  @override
  String infrExtensionInUseText(int count) {
    return 'Παρατάσεις που απομένουν αυτή την εβδομάδα: $count.';
  }

  @override
  String get infrShiftExceededTitle => 'Υπέρβαση εργάσιμης ημέρας';

  @override
  String infrShiftExceededText(String limit, String time) {
    return 'Η βάρδια ξεπερνά τις $limit κατά $time. Αρχίστε την ημερήσια ανάπαυση.';
  }

  @override
  String get infrShiftSoonTitle => 'Η εργάσιμη ημέρα λήγει σύντομα';

  @override
  String infrShiftSoonText(String time) {
    return 'Αρχίστε την ημερήσια ανάπαυση σε $time.';
  }

  @override
  String get infrWeeklyDriveExceededTitle => 'Υπέρβαση εβδομαδιαίας οδήγησης';

  @override
  String infrWeeklyDriveExceededText(String limit, String time) {
    return 'Πέραν των $limit κατά $time.';
  }

  @override
  String get infrWeeklyDriveSoonTitle => 'Η εβδομαδιαία οδήγηση τελειώνει';

  @override
  String infrWeeklyDriveSoonText(String limit, String time) {
    return 'Απομένουν $time έως τις $limit.';
  }

  @override
  String get infrFortnightDriveExceededTitle =>
      'Υπέρβαση οδήγησης δύο εβδομάδων';

  @override
  String infrFortnightDriveExceededText(String limit, String time) {
    return 'Πέραν των $limit κατά $time.';
  }

  @override
  String get infrFortnightDriveSoonTitle => 'Η οδήγηση δύο εβδομάδων τελειώνει';

  @override
  String infrFortnightDriveSoonText(String limit, String time) {
    return 'Απομένουν $time έως τις $limit.';
  }

  @override
  String get infrWeeklyRestOverdueTitle => 'Καθυστέρηση εβδομαδιαίας ανάπαυσης';

  @override
  String infrWeeklyRestOverdueText(String time) {
    return 'Από την προηγούμενη εβδομαδιαία ανάπαυση πέρασαν πάνω από 144 ώ — κατά $time.';
  }

  @override
  String get infrWeeklyRestSoonTitle => 'Σύντομα εβδομαδιαία ανάπαυση';

  @override
  String infrWeeklyRestSoonText(String time) {
    return 'Αρχίστε την εβδομαδιαία ανάπαυση σε $time.';
  }

  @override
  String get infrWeeklyRestContinueTitle => 'Μη διακόψετε την ανάπαυση';

  @override
  String infrWeeklyRestContinueText(String time) {
    return 'Η προθεσμία της εβδομαδιαίας ανάπαυσης έληξε. Αναπαυθείτε ακόμη $time ώστε να μετρηθεί ως εβδομαδιαία.';
  }

  @override
  String get infrCompensationSoonTitle => 'Σύντομα προθεσμία αντιστάθμισης';

  @override
  String infrCompensationSoonText(String time, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days ημέρες',
      one: '$days ημέρα',
    );
    return 'Προσθέστε $time σε ανάπαυση τουλάχιστον 9 ώ. Προθεσμία σε $_temp0.';
  }

  @override
  String get infrCompensationOverdueTitle => 'Καθυστέρηση αντιστάθμισης';

  @override
  String infrCompensationOverdueText(String time, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days ημέρες',
      one: '$days ημέρα',
    );
    return 'Δεν προστέθηκαν $time για τη μειωμένη εβδομαδιαία ανάπαυση. Καθυστέρηση $_temp0.';
  }

  @override
  String get infrReducedRestsExceededTitle =>
      'Πάρα πολλές μειωμένες αναπαύσεις';

  @override
  String infrReducedRestsExceededText(int count) {
    return 'Μειωμένες αναπαύσεις μετά την εβδομαδιαία: $count, επιτρέπονται 3.';
  }

  @override
  String get infrCardOverdueTitle => 'Καθυστέρηση μεταφόρτωσης κάρτας';

  @override
  String infrCardOverdueText(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days ημέρες',
      one: '$days ημέρα',
    );
    return 'Η προθεσμία των 28 ημερών έληξε πριν από $_temp0.';
  }

  @override
  String get infrCardSoonTitle => 'Σύντομα μεταφόρτωση κάρτας';

  @override
  String infrCardSoonText(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days ημέρες',
      one: '$days ημέρα',
    );
    return 'Απομένουν $_temp0.';
  }

  @override
  String get ferryTitle => 'Πλοίο / τρένο';

  @override
  String get ferryHint =>
      'Η ανάπαυση μπορεί να διακοπεί το πολύ δύο φορές, συνολικά έως 1 ώ (άρθρο 9). Η κίνηση του πλοίου δεν ενεργοποιεί την οδήγηση.';

  @override
  String get ferryOn => 'πλοίο';

  @override
  String breakHero(String limit) {
    return 'Διάλειμμα μετά από $limit οδήγησης';
  }

  @override
  String breakPartDone(int minutes) {
    return '$minutes λεπ. ✓';
  }

  @override
  String breakPart(int minutes) {
    return '$minutes λεπ.';
  }

  @override
  String breakPartLeft(int minutes) {
    return '$minutes λεπ. — απομένουν';
  }

  @override
  String breakFirstTaken(String from, String to) {
    return 'Το πρώτο μέρος έγινε $from–$to';
  }

  @override
  String get breakNone =>
      'Χρειάζεται διάλειμμα 45 λεπτών συνεχόμενα ή 15 + 30 λεπτά.';

  @override
  String get breakSplitTitle => 'Χωρισμένο διάλειμμα 15 + 30';

  @override
  String get breakSplitText =>
      'Το πρώτο μέρος τουλάχιστον 15 λεπ., το δεύτερο τουλάχιστον 30 λεπ., ακριβώς με αυτή τη σειρά. Η εφαρμογή το αναγνωρίζει μόνη της.';

  @override
  String get breakStart => 'Έναρξη διαλείμματος';

  @override
  String get breakOngoing => 'Διάλειμμα σε εξέλιξη';

  @override
  String get weeklyStartBy => 'Αρχίστε το αργότερο';

  @override
  String weeklyInTime(String left) {
    return 'σε $left — τέλος εργάσιμης εβδομάδας (144 ώ)';
  }

  @override
  String weeklyOverdue(String time) {
    return 'καθυστέρηση $time';
  }

  @override
  String get weeklyOngoing => 'Εβδομαδιαία ανάπαυση σε εξέλιξη';

  @override
  String get weeklyUnknown =>
      'Δεν υπάρχουν δεδομένα για την προηγούμενη εβδομαδιαία ανάπαυση. Η προθεσμία θα εμφανιστεί μετά από ανάπαυση τουλάχιστον 24 ωρών.';

  @override
  String get weeklyNext => 'Επόμενη ανάπαυση';

  @override
  String get weeklyFull => 'Κανονική';

  @override
  String get weeklyFullHint => 'όχι στην καμπίνα';

  @override
  String get weeklyReduced => 'Μειωμένη';

  @override
  String get weeklyReducedYes => 'επιτρέπεται · με αντιστάθμιση';

  @override
  String get weeklyReducedNo => 'δεν επιτρέπεται — χρειάζεται κανονική';

  @override
  String get weeklyHistory => 'Ιστορικό';

  @override
  String weeklyPrevious(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'full': 'κανονική',
      'reduced': 'μειωμένη',
      'other': 'ανεπαρκής',
    });
    return 'Προηγούμενη · $_temp0';
  }

  @override
  String get weeklyNow => 'τώρα';

  @override
  String get weeklyCompensation => 'Οφειλή αντιστάθμισης';

  @override
  String get weeklyCompensationNone => 'καμία';

  @override
  String weeklyCompensationValue(String time, String date) {
    return '$time έως $date';
  }

  @override
  String get weeklyMobilityOn =>
      'Δέσμη για την κινητικότητα ενεργή: στις διεθνείς μεταφορές επιτρέπονται δύο συνεχόμενες μειωμένες αναπαύσεις, αν γίνονται εκτός της χώρας ταξινόμησης. Η μείωση αντισταθμίζεται έως το τέλος της τρίτης εβδομάδας.';

  @override
  String get weeklyMobilityOff =>
      'Η μειωμένη εβδομαδιαία ανάπαυση αντισταθμίζεται έως το τέλος της τρίτης εβδομάδας: η οφειλή προστίθεται σε ανάπαυση τουλάχιστον 9 ωρών.';

  @override
  String get weeklyStartRest => 'Έναρξη ανάπαυσης';

  @override
  String get countryTitle => 'Επιλογή χώρας';

  @override
  String countryChip(String start, String end) {
    return 'Χώρα έναρξης $start, λήξης $end. Αλλαγή';
  }

  @override
  String countryChipNoEnd(String start) {
    return 'Χώρα έναρξης $start, λήξη χωρίς επιλογή. Αλλαγή';
  }

  @override
  String get countryChipNone => 'Δεν επιλέχθηκε χώρα βάρδιας. Επιλογή';

  @override
  String countryStartTab(String code) {
    return 'Έναρξη · $code';
  }

  @override
  String countryEndTab(String code) {
    return 'Λήξη · $code';
  }

  @override
  String get countryNextShift => 'Χώρα της επόμενης βάρδιας';

  @override
  String get countrySearch => 'Χώρα ή κωδικός';

  @override
  String get countryRecent => 'Πρόσφατες';

  @override
  String get countryClearEnd => 'Χωρίς ένδειξη';

  @override
  String get countryNotFound => 'Δεν βρέθηκε τίποτα';

  @override
  String get countryFooter =>
      'Ο οδηγός καταχωρίζει τη χώρα στον ταχογράφο στην αρχή και στο τέλος της βάρδιας (κανονισμός (ΕΕ) αριθ. 165/2014, άρθρο 34).';

  @override
  String countryName(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'A': 'Αυστρία',
      'AL': 'Αλβανία',
      'AND': 'Ανδόρα',
      'ARM': 'Αρμενία',
      'AZ': 'Αζερμπαϊτζάν',
      'B': 'Βέλγιο',
      'BG': 'Βουλγαρία',
      'BIH': 'Βοσνία-Ερζεγοβίνη',
      'BY': 'Λευκορωσία',
      'CH': 'Ελβετία',
      'CY': 'Κύπρος',
      'CZ': 'Τσεχία',
      'D': 'Γερμανία',
      'DK': 'Δανία',
      'E': 'Ισπανία',
      'EST': 'Εσθονία',
      'F': 'Γαλλία',
      'FIN': 'Φινλανδία',
      'FL': 'Λιχτενστάιν',
      'GE': 'Γεωργία',
      'GR': 'Ελλάδα',
      'H': 'Ουγγαρία',
      'HR': 'Κροατία',
      'I': 'Ιταλία',
      'IRL': 'Ιρλανδία',
      'IS': 'Ισλανδία',
      'KZ': 'Καζακστάν',
      'L': 'Λουξεμβούργο',
      'LT': 'Λιθουανία',
      'LV': 'Λετονία',
      'M': 'Μάλτα',
      'MC': 'Μονακό',
      'MD': 'Μολδαβία',
      'MK': 'Βόρεια Μακεδονία',
      'MNE': 'Μαυροβούνιο',
      'N': 'Νορβηγία',
      'NL': 'Κάτω Χώρες',
      'P': 'Πορτογαλία',
      'PL': 'Πολωνία',
      'RO': 'Ρουμανία',
      'RSM': 'Άγιος Μαρίνος',
      'RUS': 'Ρωσία',
      'S': 'Σουηδία',
      'SK': 'Σλοβακία',
      'SLO': 'Σλοβενία',
      'SRB': 'Σερβία',
      'TJ': 'Τατζικιστάν',
      'TM': 'Τουρκμενιστάν',
      'TR': 'Τουρκία',
      'UA': 'Ουκρανία',
      'UK': 'Ηνωμένο Βασίλειο',
      'UZ': 'Ουζμπεκιστάν',
      'V': 'Βατικανό',
      'other': '$code',
    });
    return '$_temp0';
  }

  @override
  String get journalExport => 'Εξαγωγή αναφοράς';

  @override
  String get journalCurrent => 'τρέχουσα';

  @override
  String get journalDriving => 'Οδήγηση';

  @override
  String get journalFortnight => '2 εβδομάδες';

  @override
  String journalOf(int limit) {
    return 'από $limit';
  }

  @override
  String get journalCollapsedDriving => 'οδήγηση';

  @override
  String journalWeekSpoken(String range, String driving, String fortnight) {
    return 'Εβδομάδα $range. Οδήγηση $driving από 56 ώρες, σε δύο εβδομάδες $fortnight από 90 ώρες';
  }

  @override
  String get journalShift => 'Βάρδια';

  @override
  String get journalWeeklyShort => 'εβδ.';

  @override
  String get journalOngoing => 'σε εξέλιξη';

  @override
  String get journalManual => 'χειροκίνητα';

  @override
  String get journalAddShift => 'Βάρδια';

  @override
  String get journalAddShiftSpoken => 'Προσθήκη βάρδιας';

  @override
  String get journalEmpty =>
      'Δεν υπάρχουν βάρδιες ακόμη. Θα εμφανιστούν όταν αρχίσετε να αλλάζετε καταστάσεις — ή προσθέστε βάρδια χειροκίνητα.';

  @override
  String restStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'full': 'κανονική',
      'reduced': 'μειωμένη',
      'other': 'ανεπαρκής',
    });
    return '$_temp0';
  }

  @override
  String journalWeeklyRest(String status) {
    return 'Εβδομαδιαία ανάπαυση · $status';
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
    return '$date, $route, $time. Οδήγηση $driving, βάρδια $span, ανάπαυση $rest';
  }

  @override
  String get journalRestNone => 'καμία';

  @override
  String get journalRestWeekly => 'εβδομαδιαία';

  @override
  String get journalLoadError =>
      'Δεν ήταν δυνατό να ανοίξει το ημερολόγιο. Επανεκκινήστε την εφαρμογή — αν δεν βοηθήσει, γράψτε μας από το «Περισσότερα».';

  @override
  String get dayTitle => 'Βάρδια';

  @override
  String get daySummary => 'Σύνοψη';

  @override
  String get dayModes => 'Καταστάσεις';

  @override
  String get dayBreaks => 'Διαλείμματα';

  @override
  String get dayContinuousAtEnd => 'Χωρίς διάλειμμα στο τέλος της βάρδιας';

  @override
  String get dayRestAfter => 'Ανάπαυση μετά τη βάρδια';

  @override
  String dayRestKind(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'daily': 'Ημερήσια',
      'weekly': 'Εβδομαδιαία',
      'other': 'Δεν άρχισε',
    });
    return '$_temp0';
  }

  @override
  String get daySplitRest => 'χωρισμένη 3 + 9';

  @override
  String get dayManualHint =>
      'Η βάρδια καταχωρίστηκε χειροκίνητα ως σύνολα — δεν υπάρχουν εγγραφές καταστάσεων.';

  @override
  String get dayNotes => 'Σημειώσεις';

  @override
  String get dayEndMark => 'τέλος ημέρας';

  @override
  String get dayEdit => 'Επεξεργασία βάρδιας';

  @override
  String get dayNotFound => 'Αυτή η βάρδια δεν υπάρχει πλέον στο ημερολόγιο.';

  @override
  String dayRestUntil(String time) {
    return 'έως $time';
  }

  @override
  String get save => 'Αποθήκευση';

  @override
  String get cancel => 'Ακύρωση';

  @override
  String get done => 'Τέλος';

  @override
  String get delete => 'Διαγραφή';

  @override
  String get unitHours => 'ώ';

  @override
  String get unitMinutes => 'λεπ.';

  @override
  String get pickerHours => 'Ώρες';

  @override
  String get pickerMinutes => 'Λεπτά';

  @override
  String get pickerTime => 'Ώρα';

  @override
  String get pickerPrevMonth => 'Προηγούμενος μήνας';

  @override
  String get pickerNextMonth => 'Επόμενος μήνας';

  @override
  String pickerRange(String min, String max) {
    return 'Επιτρέπεται από $min έως $max';
  }

  @override
  String get shiftNewTitle => 'Νέα βάρδια';

  @override
  String get shiftSection => 'Βάρδια';

  @override
  String get shiftStart => 'Έναρξη';

  @override
  String get shiftEnd => 'Λήξη';

  @override
  String get shiftOnRoad => 'στον δρόμο';

  @override
  String get shiftChoose => 'Επιλογή';

  @override
  String get shiftNowOngoing => 'Τώρα (σε εξέλιξη)';

  @override
  String get shiftDuration => 'Διάρκεια';

  @override
  String get shiftNowSuffix => 'τώρα';

  @override
  String shiftCountrySpoken(String side, String code) {
    return '$side: χώρα $code. Αλλαγή';
  }

  @override
  String shiftDateSpoken(String side, String date, String time) {
    return '$side: $date, $time. Αλλαγή';
  }

  @override
  String get shiftDriving => 'Οδήγηση';

  @override
  String get shiftPerDay => 'Ανά ημέρα';

  @override
  String get shiftLiveContinuous => 'υπολογίζεται από τα διαλείμματα';

  @override
  String get shiftRestNone => 'Δεν άρχισε';

  @override
  String get shiftRestDaily => 'Ημερήσια';

  @override
  String get shiftRestWeekly => 'Εβδομαδιαία';

  @override
  String get shiftSplit => 'Χωρισμένη ανάπαυση 3 + 9';

  @override
  String get shiftSplitHint => 'Πρώτα 3 ώ, μετά 9 ώ';

  @override
  String shiftRestUntilNext(String when) {
    return 'Έως την έναρξη της βάρδιας: $when';
  }

  @override
  String get shiftRestAutoHint => 'Διαρκεί έως την έναρξη της επόμενης βάρδιας';

  @override
  String get shiftRestCountsWeekly =>
      'Από 24 ώ η ανάπαυση μετρά ως εβδομαδιαία';

  @override
  String get shiftNotesHint => 'Για παράδειγμα: πλοίο, αναμονή φόρτωσης';

  @override
  String get shiftDelete => 'Διαγραφή βάρδιας';

  @override
  String get shiftDeleteTitle => 'Διαγραφή της βάρδιας;';

  @override
  String get shiftDeleteManual => 'Η βάρδια θα αφαιρεθεί από το ημερολόγιο.';

  @override
  String get shiftDeleteRecorded =>
      'Όλες οι εγγραφές καταστάσεων αυτής της βάρδιας θα διαγραφούν. Δεν είναι δυνατή η αναίρεση.';

  @override
  String get shiftErrStartCountry => 'Επιλέξτε τη χώρα όπου αρχίζει η βάρδια';

  @override
  String get shiftErrEndCountry => 'Ορίστε τη χώρα όπου λήγει η βάρδια';

  @override
  String get shiftErrEndBeforeStart => 'Η βάρδια λήγει πριν αρχίσει';

  @override
  String get shiftErrFuture =>
      'Ο χρόνος της βάρδιας δεν μπορεί να είναι στο μέλλον';

  @override
  String get shiftErrTooLong =>
      'Βάρδια πάνω από 30 ώ — ελέγξτε τις ημερομηνίες';

  @override
  String get shiftErrDrivingTooLong =>
      'Η οδήγηση είναι μεγαλύτερη από τη βάρδια';

  @override
  String get shiftErrContinuous =>
      'Η συνεχής οδήγηση είναι μεγαλύτερη από την ημερήσια';

  @override
  String shiftErrOverlap(String range) {
    return 'Επικαλύπτεται με τη βάρδια $range';
  }

  @override
  String get shiftErrNotLast =>
      'Υπάρχουν άλλες βάρδιες μετά από αυτή — δεν μπορεί να είναι σε εξέλιξη τώρα';

  @override
  String get shiftSaveFailed => 'Η αποθήκευση απέτυχε. Δοκιμάστε ξανά.';

  @override
  String get shiftSavedViolations =>
      'Η βάρδια αποθηκεύτηκε. Υπάρχουν παραβάσεις';

  @override
  String get shiftSavedViolationsText =>
      'Ελέγξτε τους χρόνους. Αν όλα είναι σωστά, οι παραβάσεις θα εμφανιστούν στο ημερολόγιο και στην αναφορά.';

  @override
  String get gotIt => 'Κατάλαβα';

  @override
  String get shiftLiveHint =>
      'Η βάρδια ακολουθεί τις εγγραφές καταστάσεων: η αλλαγή έναρξης, λήξης ή οδήγησης μετακινεί τις ίδιες τις εγγραφές.';

  @override
  String get shiftConvertHint =>
      'Άλλαξε ο χρόνος, η οδήγηση ή η ανάπαυση — η βάρδια θα αποθηκευτεί ως χειροκίνητη εγγραφή αντί για τις εγγραφές καταστάσεων.';

  @override
  String shiftEndNowHint(String time) {
    return 'Η βάρδια θα λήξει στις $time, μετά αρχίζει η ανάπαυση.';
  }

  @override
  String get shiftResumeHint =>
      'Η ανάπαυση μετά τη βάρδια θα διαγραφεί — η βάρδια συνεχίζεται.';

  @override
  String shiftOngoingHint(String time, String mode) {
    return 'Η βάρδια θα γίνει η τρέχουσα και θα συνεχιστεί στην αρχική οθόνη από $time. Κατάσταση «$mode» — αν τώρα ισχύει άλλη, αλλάξτε την εκεί.';
  }

  @override
  String get shiftUnsavedTitle => 'Αποθήκευση αλλαγών;';

  @override
  String get shiftUnsavedText =>
      'Οι αλλαγές σε αυτή τη βάρδια δεν έχουν αποθηκευτεί ακόμη.';

  @override
  String get shiftDiscard => 'Χωρίς αποθήκευση';

  @override
  String get shiftDateTimeTitle => 'Ημερομηνία και ώρα βάρδιας';

  @override
  String driveEditSubtitle(String date) {
    return 'Χειροκίνητη διόρθωση · $date';
  }

  @override
  String get driveEditComputed => 'Υπολογισμός της εφαρμογής';

  @override
  String driveEditDiff(String diff) {
    return '$diff σε σύγκριση με τον υπολογισμό.';
  }

  @override
  String get driveEditNoChange => 'Ο χρόνος δεν άλλαξε.';

  @override
  String get driveEditHint =>
      'Χρησιμοποιήστε το αν η κατάσταση άλλαξε σε λάθος ώρα — τα όρια θα υπολογιστούν ξανά.';

  @override
  String get driveEditNoDrive =>
      'Στην τρέχουσα βάρδια δεν υπάρχει ακόμη οδήγηση — δεν υπάρχει κάτι να διορθωθεί.';

  @override
  String get breakCorrection => 'Διόρθωση';

  @override
  String get breakCurrentDuration => 'Τρέχον διάλειμμα';

  @override
  String get breakLastDuration => 'Τελευταίο διάλειμμα';

  @override
  String get breakNoBreak =>
      'Στη βάρδια δεν υπάρχει ακόμη διάλειμμα — δεν υπάρχει κάτι να διορθωθεί.';

  @override
  String get breakEditHint =>
      'Ο χρόνος λαμβάνεται από τη γειτονική εγγραφή — τα όρια θα υπολογιστούν ξανά.';

  @override
  String get workdayChangeStart => 'Αλλαγή έναρξης βάρδιας';

  @override
  String get weeklyAddManually => 'Χειροκίνητη καταχώριση';

  @override
  String get exportPeriod => 'Περίοδος';

  @override
  String get exportWeek => 'Αυτή η εβδομάδα';

  @override
  String get exportTwoWeeks => '2 εβδομάδες';

  @override
  String get exportDays28 => '28 ημέρες';

  @override
  String get exportCustom => 'Δική σας περίοδος';

  @override
  String get exportFrom => 'Από';

  @override
  String get exportTo => 'Έως';

  @override
  String exportFromDay(String date) {
    return 'Από $date';
  }

  @override
  String exportToDay(String date) {
    return 'Έως $date';
  }

  @override
  String get exportFormat => 'Μορφή';

  @override
  String get exportPdf => 'PDF · για έλεγχο';

  @override
  String get exportCsv => 'CSV · υπολογιστικό φύλλο';

  @override
  String get exportPdfHint =>
      'Δεν είναι επίσημο έγγραφο: η αναφορά δεν αντικαθιστά τα δεδομένα του ταχογράφου και της κάρτας οδηγού.';

  @override
  String get exportCsvHint =>
      'Εγγραφές καταστάσεων ανά γραμμή, ώρα σε UTC — για Excel και λογιστικά προγράμματα.';

  @override
  String get exportLanguage => 'Γλώσσα αναφοράς';

  @override
  String get exportNotes => 'Χώρες και σημειώσεις';

  @override
  String get exportCreate => 'Δημιουργία αναφοράς';

  @override
  String exportCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count βάρδιες',
      one: '$count βάρδια',
    );
    return '$_temp0 στην αναφορά';
  }

  @override
  String get exportEmpty => 'Δεν υπάρχουν βάρδιες στην επιλεγμένη περίοδο.';

  @override
  String get exportFailed =>
      'Δεν ήταν δυνατή η δημιουργία της αναφοράς. Δοκιμάστε ξανά.';

  @override
  String exportRangeSpoken(String from, String to) {
    return 'Περίοδος από $from έως $to';
  }

  @override
  String get reportTitle => 'Αναφορά χρόνων οδήγησης και ανάπαυσης';

  @override
  String get reportSubtitle =>
      'Κανονισμός (ΕΚ) αριθ. 561/2006 και Συμφωνία AETR';

  @override
  String get reportDriver => 'Οδηγός';

  @override
  String get reportCard => 'Κάρτα οδηγού';

  @override
  String get reportVehicle => 'Αριθμός κυκλοφορίας';

  @override
  String get reportCompany => 'Μεταφορέας';

  @override
  String get reportPeriod => 'Περίοδος';

  @override
  String get reportGenerated => 'Δημιουργήθηκε';

  @override
  String reportTimezone(String zone) {
    return 'Ώρες στη ζώνη ώρας του τηλεφώνου ($zone). Ημέρες και εβδομάδες της αναφοράς σε UTC, η εβδομάδα αρχίζει τη Δευτέρα στις 00:00, όπως στον ταχογράφο.';
  }

  @override
  String get reportDate => 'Ημερομηνία';

  @override
  String get reportStart => 'Έναρξη';

  @override
  String get reportEnd => 'Λήξη';

  @override
  String get reportCountries => 'Χώρες';

  @override
  String get reportDriving => 'Οδήγηση';

  @override
  String get reportWork => 'Εργασία';

  @override
  String get reportAvailability => 'Διαθ.';

  @override
  String get reportBreaks => 'Διαλείμματα';

  @override
  String get reportSpan => 'Βάρδια';

  @override
  String get reportRestAfter => 'Ανάπαυση μετά';

  @override
  String get reportNotes => 'Σημειώσεις';

  @override
  String reportWeek(String range) {
    return 'Εβδομάδα $range';
  }

  @override
  String reportWeekTotal(String driving, String fortnight) {
    return 'Σύνολο: οδήγηση $driving από 56 ώ · σε 2 εβδομάδες $fortnight από 90 ώ';
  }

  @override
  String get reportViolations => 'Παραβάσεις';

  @override
  String get reportNoViolations => 'Καμία παράβαση σύμφωνα με το ημερολόγιο.';

  @override
  String reportViolationDrive(String date, String time) {
    return '$date: ημερήσια οδήγηση $time — πάνω από 10 ώ';
  }

  @override
  String reportViolationSpan(String date, String time, int limit) {
    return '$date: εργάσιμη ημέρα $time — πάνω από $limit ώ';
  }

  @override
  String reportViolationRest(String date, String time) {
    return '$date: ανάπαυση μετά τη βάρδια $time — ανεπαρκής';
  }

  @override
  String reportViolationWeek(String range, String time) {
    return 'Εβδομάδα $range: οδήγηση $time — πάνω από 56 ώ';
  }

  @override
  String reportViolationFortnight(String range, String time) {
    return 'Εβδομάδα $range: σε δύο εβδομάδες $time — πάνω από 90 ώ';
  }

  @override
  String get reportMarks => 'Σημάνσεις';

  @override
  String get reportMarkWarn =>
      '! — οδήγηση παρατεταμένη έως 10 ώ, εργάσιμη ημέρα πάνω από 13 ώ ή μειωμένη ανάπαυση';

  @override
  String get reportMarkBad => '!! — παράβαση';

  @override
  String get reportMarkManual =>
      '* — βάρδια καταχωρισμένη χειροκίνητα ως σύνολα';

  @override
  String get reportDisclaimer =>
      'Η αναφορά βασίζεται στις καταχωρίσεις του οδηγού στην εφαρμογή TachoGo. Δεν είναι επίσημο έγγραφο: δεν αντικαθιστά τα δεδομένα του ταχογράφου και της κάρτας οδηγού.';

  @override
  String get reportSignature => 'Υπογραφή οδηγού';

  @override
  String reportPage(int page, int pages) {
    return 'Σελίδα $page από $pages';
  }

  @override
  String get openSystemSettings => 'Άνοιγμα ρυθμίσεων';

  @override
  String get settingsGeneral => 'Γενικά';

  @override
  String get settingsLanguage => 'Γλώσσα';

  @override
  String get settingsLanguageSystem => 'Όπως στο τηλέφωνο';

  @override
  String get settingsTheme => 'Εμφάνιση';

  @override
  String get themeSystem => 'Σύστημα';

  @override
  String get themeLight => 'Φωτεινή';

  @override
  String get themeDark => 'Σκοτεινή';

  @override
  String get settingsRules => 'Κανόνες';

  @override
  String get settingsTachograph => 'Ταχογράφος στο όχημα';

  @override
  String get tachographDigital => 'Ψηφιακός';

  @override
  String get tachographAnalog => 'Αναλογικός';

  @override
  String get settingsMobility => 'Δέσμη για την κινητικότητα';

  @override
  String get settingsMobilityHint =>
      'Δύο συνεχόμενες μειωμένες εβδομαδιαίες αναπαύσεις στις διεθνείς μεταφορές';

  @override
  String get settingsCrew => 'Πλήρωμα δύο οδηγών';

  @override
  String get settingsCrewHint =>
      'Ημερήσια ανάπαυση 9 ωρών εντός 30 ωρών από την έναρξη της βάρδιας';

  @override
  String get settingsNotifications => 'Ειδοποιήσεις';

  @override
  String get settingsWarnLead => 'Προειδοποίηση για όρια';

  @override
  String get settingsWarnLeadHint => 'Διάλειμμα, τέλος ημέρας, οδήγηση';

  @override
  String get settingsWarnLeadGroup => 'Προειδοποίηση εκ των προτέρων';

  @override
  String leadMinutes(int minutes) {
    return '$minutes λεπ.';
  }

  @override
  String leadHours(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours ώρες',
      one: '$hours ώρα',
    );
    return '$_temp0';
  }

  @override
  String get notifyBreak => 'Διάλειμμα';

  @override
  String get notifyShiftEnd => 'Τέλος εργάσιμης ημέρας';

  @override
  String get notifyShiftEndHint => 'Ημερήσια και εβδομαδιαία ανάπαυση';

  @override
  String get notifyDriving => 'Όριο οδήγησης';

  @override
  String get notifyCard => 'Μεταφόρτωση κάρτας';

  @override
  String get notifyCardHint => 'Κάθε 28 ημέρες';

  @override
  String get notifyCardLead => 'Εκ των προτέρων';

  @override
  String get notifyCardLeadGroup =>
      'Προειδοποίηση για μεταφόρτωση κάρτας εκ των προτέρων';

  @override
  String leadDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days ημέρες',
      one: '$days ημέρα',
    );
    return '$_temp0';
  }

  @override
  String get notifyAllow => 'Να επιτρέπονται οι ειδοποιήσεις';

  @override
  String get notifyDenied =>
      'Οι ειδοποιήσεις είναι αυτή τη στιγμή αποκλεισμένες στο τηλέφωνο';

  @override
  String get notifyAllowed => 'Οι ειδοποιήσεις επιτρέπονται';

  @override
  String get notifyExact => 'Ακριβής ώρα ειδοποιήσεων';

  @override
  String get notifyExactHint =>
      'Επιτρέψτε «Ξυπνητήρια και υπενθυμίσεις» — αλλιώς το τηλέφωνο μπορεί να καθυστερήσει μια προειδοποίηση';

  @override
  String get notifyChannelLimits => 'Όρια και παραβάσεις';

  @override
  String get notifyChannelLimitsHint =>
      'Διάλειμμα, τέλος εργάσιμης ημέρας, οδήγηση, εβδομαδιαία ανάπαυση, κάρτα';

  @override
  String get notifyChannelRest => 'Η ανάπαυση μετρήθηκε';

  @override
  String get notifyChannelRestHint =>
      'Διάλειμμα, ημερήσια και εβδομαδιαία ανάπαυση μετρήθηκαν';

  @override
  String get notifyBreakTakenTitle => 'Το διάλειμμα μετρήθηκε';

  @override
  String notifyBreakTakenText(int required, String time) {
    return 'Το διάλειμμα $required λεπτών μετρήθηκε. Μπορείτε να οδηγήσετε $time έως το επόμενο διάλειμμα.';
  }

  @override
  String get notifyDailyRestTakenTitle => 'Η ημερήσια ανάπαυση μετρήθηκε';

  @override
  String notifyDailyRestTakenText(String limit) {
    return 'Κανονική ανάπαυση $limit — μπορείτε να αρχίσετε βάρδια.';
  }

  @override
  String get notifyWeeklyRestTakenTitle => 'Η εβδομαδιαία ανάπαυση μετρήθηκε';

  @override
  String notifyWeeklyRestTakenText(String limit) {
    return 'Κανονική ανάπαυση $limit — μπορείτε να αρχίσετε νέα εργάσιμη εβδομάδα.';
  }

  @override
  String get serviceChannel => 'Αυτόματη αναγνώριση οδήγησης';

  @override
  String get serviceChannelHint =>
      'Τρέχουσα κατάσταση και μετρητές όσο η αυτόματη αναγνώριση είναι ενεργή';

  @override
  String get serviceStarted => 'Η αυτόματη αναγνώριση οδήγησης είναι ενεργή';

  @override
  String serviceModeTitle(String mode, String time) {
    return '$mode · $time';
  }

  @override
  String get serviceTeamTitle => 'Το όχημα κινείται';

  @override
  String serviceTeamText(String time) {
    return 'Οδηγείτε εσείς; Οδήγηση από $time';
  }

  @override
  String get serviceSuggestTitle => 'Φαίνεται ότι οδηγείτε';

  @override
  String serviceSuggestText(String time) {
    return 'Έναρξη οδήγησης από $time; Η ανάπαυση θα διακοπεί';
  }

  @override
  String serviceDriving(String untilBreak, String dayLeft) {
    return 'Έως το διάλειμμα $untilBreak · σήμερα απομένουν $dayLeft';
  }

  @override
  String serviceDrivingOver(String time) {
    return 'Χρειάζεται διάλειμμα: υπέρβαση κατά $time';
  }

  @override
  String serviceBreakLeft(String time) {
    return 'Έως πλήρες διάλειμμα $time';
  }

  @override
  String serviceBreakDone(String time) {
    return 'Το διάλειμμα μετρήθηκε, μπορείτε να οδηγήσετε $time';
  }

  @override
  String serviceWorkday(String time, String limit) {
    return 'Εργάσιμη ημέρα $time από $limit';
  }

  @override
  String serviceRestLeft(String limit, String time) {
    return 'Έως πλήρη ανάπαυση $limit: $time';
  }

  @override
  String get serviceDailyRestDone => 'Η κανονική ημερήσια ανάπαυση μετρήθηκε';

  @override
  String get serviceWeeklyRestDone =>
      'Η κανονική εβδομαδιαία ανάπαυση μετρήθηκε';

  @override
  String get serviceNotStartedText =>
      'Η οδήγηση ενεργοποιείται όταν το όχημα ξεκινήσει';

  @override
  String get serviceNoModeText => 'Ανοίξτε το TachoGo και επιλέξτε κατάσταση';

  @override
  String get autoTitle => 'Αυτόματη αναγνώριση οδήγησης';

  @override
  String get autoSwitch => 'Αναγνώριση οδήγησης μέσω GPS';

  @override
  String get autoSwitchHint =>
      'Ξεκινάτε — οδήγηση· σταματάτε — άλλη εργασία. Χρειάζεται μόνο η ταχύτητα: οι συντεταγμένες δεν αποθηκεύονται.';

  @override
  String get autoAfterStop => 'Μετά τη στάση';

  @override
  String get autoAfterStopHint => 'Μετά από 3 λεπτά ακινησίας';

  @override
  String get autoStartFromRest => 'Οδήγηση αμέσως μετά την ανάπαυση';

  @override
  String get autoStartFromRestHint =>
      'Αλλιώς η εφαρμογή ρωτά πρώτα: μπορεί να ήσασταν συνοδηγός';

  @override
  String get autoBattery => 'Εξοικονόμηση μπαταρίας';

  @override
  String get autoBatteryLimited =>
      'Μπορεί να σταματήσει την αναγνώριση. Αφαιρέστε το TachoGo από τη λίστα εξοικονόμησης';

  @override
  String get autoBatteryOk => 'Δεν εμποδίζει τη λειτουργία στο παρασκήνιο';

  @override
  String get autoAutostart => 'Αυτόματη εκκίνηση και λειτουργία στο παρασκήνιο';

  @override
  String get autoAutostartHint =>
      'Xiaomi, Huawei, Honor, Oppo, Vivo, Samsung: επιτρέψτε, αλλιώς το τηλέφωνο θα σταματήσει την αναγνώριση';

  @override
  String get autoBlockedService =>
      'Η τοποθεσία είναι απενεργοποιημένη στο τηλέφωνο. Ενεργοποιήστε την για αναγνώριση οδήγησης.';

  @override
  String get autoBlockedDenied =>
      'Χωρίς πρόσβαση στην τοποθεσία η οδήγηση δεν αναγνωρίζεται. Η εφαρμογή χρειάζεται μόνο την ταχύτητα, οι συντεταγμένες δεν αποθηκεύονται.';

  @override
  String get autoBlockedForever =>
      'Η πρόσβαση στην τοποθεσία είναι αποκλεισμένη. Επιτρέψτε την στις ρυθμίσεις του τηλεφώνου: Τοποθεσία → «Κατά τη χρήση της εφαρμογής».';

  @override
  String get autoNoAccess =>
      'Χωρίς πρόσβαση στην τοποθεσία — η αναγνώριση δεν λειτουργεί. Επιτρέψτε την στις ρυθμίσεις του τηλεφώνου.';

  @override
  String get autoEnable => 'Ενεργοποίηση αναγνώρισης οδήγησης';

  @override
  String get autoEnabled => 'Η αναγνώριση οδήγησης είναι ενεργή';

  @override
  String get settingsData => 'Δεδομένα';

  @override
  String get settingsExport => 'Εξαγωγή αναφοράς';

  @override
  String get settingsExportFormats => 'PDF · CSV';

  @override
  String get settingsAnalytics => 'Ανώνυμα στατιστικά';

  @override
  String get settingsAnalyticsHint =>
      'Ποιες οθόνες ανοίγουν οι οδηγοί — για βελτίωση της εφαρμογής. Χωρίς συντεταγμένες, ονόματα και αριθμούς καρτών.';

  @override
  String get settingsClear => 'Διαγραφή όλων των δεδομένων';

  @override
  String get clearTitle => 'Διαγραφή όλων των δεδομένων;';

  @override
  String get clearText =>
      'Θα διαγραφούν το ημερολόγιο καταστάσεων, οι βάρδιες, οι χώρες, οι σημειώσεις και οι μεταφορτώσεις κάρτας. Δεν είναι δυνατή η αναίρεση. Οι ρυθμίσεις θα παραμείνουν.';

  @override
  String get clearConfirm => 'Διαγραφή';

  @override
  String get clearDone => 'Τα δεδομένα διαγράφηκαν';

  @override
  String onbStep(int step, int count) {
    return 'Βήμα $step από $count';
  }

  @override
  String get onbWelcomeTitle => 'Ο χρόνος στο τιμόνι υπό έλεγχο';

  @override
  String get onbWelcomeText =>
      'Μετράμε οδήγηση, διαλείμματα και ανάπαυση σύμφωνα με τους κανόνες ΕΕ 561/2006 και AETR και προειδοποιούμε εκ των προτέρων για τα όρια.';

  @override
  String get onbStart => 'Έναρξη';

  @override
  String get onbNext => 'Επόμενο';

  @override
  String get onbDone => 'Τέλος';

  @override
  String get onbModesTitle => 'Τέσσερις καταστάσεις — όπως στον ταχογράφο';

  @override
  String get onbModesText =>
      'Αλλάξτε κατάσταση με τα κουμπιά της αρχικής οθόνης. Οι μετρητές τρέχουν μόνοι τους — ακόμη κι όταν η εφαρμογή είναι κλειστή.';

  @override
  String get onbModeDriving =>
      'Στο τιμόνι. Μετράμε συνεχή, ημερήσια και εβδομαδιαία οδήγηση.';

  @override
  String get onbModeWork => 'Φόρτωση, έλεγχος οχήματος, έγγραφα.';

  @override
  String get onbModeAvailability =>
      'Αναμονή: ουρά φόρτωσης, σύνορα, ο δεύτερος οδηγός οδηγεί.';

  @override
  String get onbModeRest =>
      'Διαλείμματα και ανάπαυση. Το «Τέλος ημέρας» κλείνει τη βάρδια.';

  @override
  String get onbSetupTitle => 'Ας το ρυθμίσουμε για εσάς';

  @override
  String get onbSetupText => 'Όλα αυτά αλλάζουν αργότερα στις ρυθμίσεις.';

  @override
  String get onbMobilityHint => 'Ενεργοποιήστε το αν κάνετε διεθνή δρομολόγια';

  @override
  String onbNotifyText(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes λεπτά',
      one: '$minutes λεπτό',
    );
    return 'Θα σας προειδοποιούμε $_temp0 πριν από το διάλειμμα και το τέλος της εργάσιμης ημέρας — ακόμη κι όταν η εφαρμογή είναι κλειστή.';
  }

  @override
  String get onbAutoText =>
      'Ξεκινάτε — η εφαρμογή ενεργοποιεί την οδήγηση· σταματάτε — άλλη εργασία. Μετά την ανάπαυση ρωτά πρώτα. Χρειάζεται μόνο η ταχύτητα GPS: οι συντεταγμένες ούτε αποθηκεύονται ούτε αποστέλλονται πουθενά.';

  @override
  String get onbAutoLater =>
      'Μπορείτε να το ενεργοποιήσετε αργότερα στις ρυθμίσεις.';

  @override
  String languageButton(String language) {
    return 'Γλώσσα: $language';
  }

  @override
  String get settingsVehicle => 'Όχημα';

  @override
  String get vehicleTruckOrBus => 'Φορτηγό ή λεωφορείο';

  @override
  String get vehicleVan => 'Βαν 2,5–3,5 τ';

  @override
  String settingsVanHint(String date) {
    return 'Κανόνες — από $date στις διεθνείς μεταφορές και τις ενδομεταφορές για λογαριασμό τρίτων';
  }

  @override
  String onbVanText(String date) {
    return 'Οι κανόνες της ΕΕ ισχύουν για τα βαν από $date — στις διεθνείς μεταφορές και τις ενδομεταφορές για λογαριασμό τρίτων. Το βαν έχει έξυπνο ταχογράφο δεύτερης γενιάς, ο οδηγός έχει κάρτα.';
  }

  @override
  String get onbRulesTitle => 'Βασικοί κανόνες';

  @override
  String get onbRulesText =>
      'Ίδιοι για φορτηγά, λεωφορεία και βαν. Η εφαρμογή τους υπολογίζει μόνη της και προειδοποιεί εκ των προτέρων.';

  @override
  String get onbRulesMore =>
      'Όλοι οι κανόνες με εξηγήσεις — «Περισσότερα» → «Οδηγός και κανόνες».';

  @override
  String get guideTitle => 'Οδηγός και κανόνες';

  @override
  String get guideHowTo => 'Πώς να τη χρησιμοποιήσετε';

  @override
  String get guideStep1 =>
      'Αλλάξτε κατάσταση με τα κουμπιά της αρχικής οθόνης: οδήγηση, ανάπαυση, εργασία ή διαθεσιμότητα.';

  @override
  String get guideStep2 =>
      'Ορίστε τη χώρα στην αρχή και στο τέλος της βάρδιας — όπως στον ταχογράφο.';

  @override
  String get guideStep3 =>
      'Παρακολουθείτε τα όρια. Η εφαρμογή θα σας προειδοποιήσει εκ των προτέρων για το διάλειμμα και το τέλος της ημέρας. Κάθε χρόνος διορθώνεται χειροκίνητα.';

  @override
  String get guideRules => 'Κανόνες ΕΕ 561/2006 και AETR';

  @override
  String get guideContinuous => 'Οδήγηση χωρίς διάλειμμα';

  @override
  String guideContinuousText(String full, String first, String second) {
    return 'Μετά διάλειμμα $full. Μπορεί να χωριστεί: πρώτα $first, μετά $second.';
  }

  @override
  String get guideDailyDriving => 'Οδήγηση ανά ημέρα';

  @override
  String guideDailyDrivingText(String extended) {
    return 'Δύο φορές την εβδομάδα επιτρέπονται έως $extended.';
  }

  @override
  String get guideWeeklyDriving => 'Οδήγηση ανά εβδομάδα';

  @override
  String guideWeeklyDrivingText(String fortnight) {
    return 'Σε οποιεσδήποτε δύο συνεχόμενες εβδομάδες — το πολύ $fortnight.';
  }

  @override
  String get guideDailyRest => 'Ημερήσια ανάπαυση';

  @override
  String guideDailyRestText(String reduced, String first, String second) {
    return 'Έως τρεις φορές μεταξύ δύο εβδομαδιαίων αναπαύσεων μπορεί να μειωθεί σε $reduced. Χωρισμένη εκδοχή — $first + $second.';
  }

  @override
  String get guideWorkday => 'Εργάσιμη ημέρα';

  @override
  String guideWorkdayText(String window, String regular, String reduced) {
    return 'Η ανάπαυση πρέπει να λήξει εντός $window από την έναρξη της βάρδιας: $regular με κανονική ανάπαυση, $reduced με μειωμένη.';
  }

  @override
  String guideWorkdaySpoken(int first, int second) {
    String _temp0 = intl.Intl.pluralLogic(
      second,
      locale: localeName,
      other: '$second ώρες',
      one: '$second ώρα',
    );
    return '$first ή $_temp0';
  }

  @override
  String get guideWeeklyRest => 'Εβδομαδιαία ανάπαυση';

  @override
  String guideWeeklyRestText(String reduced) {
    return 'Μειωμένη — $reduced, με αντιστάθμιση έως το τέλος της τρίτης εβδομάδας. Η κανονική δεν επιτρέπεται στην καμπίνα.';
  }

  @override
  String get guideWorkWeek => 'Εργάσιμη εβδομάδα';

  @override
  String guideWorkWeekText(String period) {
    return 'Η εβδομαδιαία ανάπαυση αρχίζει το αργότερο μετά από έξι περιόδους των $period από την προηγούμενη.';
  }

  @override
  String get guideCard => 'Κάρτα οδηγού';

  @override
  String guideCardText(String days) {
    return 'Τα δεδομένα της κάρτας μεταφορτώνονται τουλάχιστον μία φορά ανά $days.';
  }

  @override
  String get guideModes => 'Χρώματα και εικονίδια';

  @override
  String get guideNewbie => 'Πρώτη φορά με ταχογράφο';

  @override
  String get guideNewbieCard => 'Η κάρτα μένει στον ταχογράφο όλη τη βάρδια';

  @override
  String get guideNewbieCardText =>
      'Τοποθετήστε την κάρτα στην αρχή της βάρδιας και αφαιρέστε τη στο τέλος. Ό,τι κάνατε χωρίς κάρτα — εργασία, διαθεσιμότητα ή ανάπαυση — καταχωρίστε το χειροκίνητα την επόμενη φορά που θα την τοποθετήσετε.';

  @override
  String get guideNewbieApp => 'Η εφαρμογή δεν αντικαθιστά τον ταχογράφο';

  @override
  String get guideNewbieAppText =>
      'Η επίσημη καταγραφή είναι στον ταχογράφο. Αλλάζετε κατάσταση κι εκεί κι εδώ — τότε οι μετρητές συμφωνούν.';

  @override
  String get guideNewbieBreak => 'Διάλειμμα σημαίνει μόνο ανάπαυση';

  @override
  String get guideNewbieBreakText =>
      'Στο διάλειμμα δεν επιτρέπεται ούτε οδήγηση ούτε εργασία. Η φόρτωση και η εκφόρτωση είναι άλλη εργασία, όχι διάλειμμα.';

  @override
  String get guideNewbieRestPlace => 'Πού να αναπαυθείτε';

  @override
  String get guideNewbieRestPlaceText =>
      'Η ημερήσια και η μειωμένη εβδομαδιαία ανάπαυση επιτρέπονται στο όχημα, αν έχει κουκέτα και είναι σταθμευμένο. Η κανονική εβδομαδιαία ανάπαυση και η αντιστάθμιση — μόνο εκτός οχήματος.';

  @override
  String get guideNewbieCountry => 'Χώρες';

  @override
  String get guideNewbieCountryText =>
      'Η χώρα καταχωρίζεται στον ταχογράφο στην αρχή και στο τέλος της βάρδιας. Ο έξυπνος ταχογράφος δεύτερης γενιάς καταγράφει μόνος του τη διέλευση των συνόρων· στους παλαιότερους η χώρα καταχωρίζεται στην πρώτη στάση μετά τα σύνορα.';

  @override
  String guideVanText(String date) {
    return 'Οι κανόνες είναι ίδιοι με των φορτηγών. Από $date ισχύουν για βαν άνω των 2,5 τ μαζί με το ρυμουλκούμενο — στις διεθνείς οδικές εμπορευματικές μεταφορές και τις ενδομεταφορές. Ένα τέτοιο βαν έχει έξυπνο ταχογράφο δεύτερης γενιάς, ο οδηγός έχει κάρτα.';
  }

  @override
  String get guideVanCheck => 'Ισχύουν οι κανόνες για το δρομολόγιό σας';

  @override
  String get guideVanTrip => 'Δρομολόγιο';

  @override
  String get guideVanTripHint =>
      'Ενδομεταφορά — μεταφορά εντός άλλης χώρας της ΕΕ';

  @override
  String get guideVanDomestic => 'Εσωτερικό';

  @override
  String get guideVanCrossBorder => 'Εξωτερικό ή ενδομεταφορά';

  @override
  String get guideVanCarriage => 'Μεταφορά';

  @override
  String get guideVanHire => 'Για λογαριασμό τρίτων';

  @override
  String get guideVanOwn => 'Για ίδιο λογαριασμό';

  @override
  String get guideVanNonCommercial => 'Μη εμπορική';

  @override
  String get guideVanCarriageHint =>
      'Για ίδιο λογαριασμό — εμπορεύματα, υλικά ή εργαλεία της επιχείρησής σας. Μη εμπορική — χωρίς αμοιβή ή έσοδο, χωρίς σχέση με την εργασία';

  @override
  String get guideVanMain => 'Είναι η οδήγηση η κύρια εργασία σας;';

  @override
  String get yes => 'Ναι';

  @override
  String get no => 'Όχι';

  @override
  String get guideVanApplies => 'Οι κανόνες ισχύουν';

  @override
  String get guideVanNotApply => 'Οι κανόνες δεν ισχύουν';

  @override
  String get guideVanAppliesText =>
      'Χρειάζονται ταχογράφος και κάρτα οδηγού, τα όρια είναι ίδια με του φορτηγού.';

  @override
  String guideVanNotYetText(String date) {
    return 'Πριν από $date τα βαν δεν καλύπτονταν από τους κανόνες.';
  }

  @override
  String get guideVanDomesticText =>
      'Ο κανονισμός της ΕΕ δεν ισχύει για βαν στις εσωτερικές μεταφορές. Ελέγξτε τους κανόνες της χώρας σας.';

  @override
  String get guideVanOwnText =>
      'Εξαίρεση: μεταφορά για ίδιες ανάγκες, και η οδήγηση δεν είναι η κύρια εργασία σας.';

  @override
  String get guideVanNonCommercialText =>
      'Εξαίρεση: μεταφορά χωρίς αμοιβή ή έσοδο, χωρίς σχέση με την εργασία.';

  @override
  String guideArticle(String article) {
    return 'Κανονισμός 561/2006, άρθρο $article';
  }

  @override
  String get guideVanNotes =>
      'Βαρύτερο από 3,5 τ μαζί με ρυμουλκούμενο — κανόνες όπως για φορτηγό, και στο εσωτερικό. Δρομολόγιο εν μέρει εκτός ΕΕ — προς Ουκρανία, Μολδαβία, Τουρκία, Βαλκάνια — ελέγξτε με τον μεταφορέα: δεν υπάρχει ενιαία ερμηνεία.';

  @override
  String get guideDisclaimer =>
      'Το TachoGo βοηθά στον προγραμματισμό του χρόνου, αλλά δεν αντικαθιστά τον ταχογράφο και δεν αποτελεί νομική συμβουλή. Το επίσημο κείμενο των κανόνων είναι ο κανονισμός (ΕΚ) αριθ. 561/2006 και η Συμφωνία AETR.';

  @override
  String get moreAbout => 'Σχετικά με την εφαρμογή';

  @override
  String get moreDisclaimer =>
      'Το TachoGo βοηθά στον προγραμματισμό των χρόνων οδήγησης και ανάπαυσης, αλλά δεν αντικαθιστά τον ταχογράφο και δεν αποτελεί νομική συμβουλή.';

  @override
  String get problemTitle => 'Αναφορά προβλήματος';

  @override
  String get problemHint =>
      'Έκδοση beta: η αναφορά πηγαίνει στους προγραμματιστές της εφαρμογής';

  @override
  String get problemText =>
      'Η αναφορά περιέχει την έκδοση της εφαρμογής, το μοντέλο τηλεφώνου, τις ρυθμίσεις, τις άδειες, το πρόγραμμα ειδοποιήσεων και τις εγγραφές του ημερολογίου για τις δύο τελευταίες ημέρες. Δεν περιέχει συντεταγμένες. Επιλέξτε πού θα την στείλετε — email ή εφαρμογή μηνυμάτων — και περιγράψτε τι συνέβη.';

  @override
  String get problemSend => 'Αποστολή';

  @override
  String get problemSubject => 'TachoGo — πρόβλημα στη beta';

  @override
  String get problemPrompt => 'Τι συνέβη και πότε (με δικά σας λόγια):';

  @override
  String get problemFailed =>
      'Δεν ήταν δυνατό να ανοίξει η αποστολή. Δοκιμάστε ξανά.';
}
