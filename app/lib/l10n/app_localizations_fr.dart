// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'TachoGo';

  @override
  String get navHome => 'Accueil';

  @override
  String get navJournal => 'Journal';

  @override
  String get navSettings => 'Réglages';

  @override
  String get navMore => 'Plus';

  @override
  String get close => 'Fermer';

  @override
  String get back => 'Retour';

  @override
  String ofLimit(String limit) {
    return 'sur $limit';
  }

  @override
  String get premiumLock => 'Disponible en Premium';

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
      other: '$count heures',
      one: '$count heure',
    );
    return '$_temp0';
  }

  @override
  String spokenMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes',
      one: '$count minute',
    );
    return '$_temp0';
  }

  @override
  String spokenOverrun(String duration) {
    return 'dépassement de $duration';
  }

  @override
  String get modeDriving => 'Conduite';

  @override
  String get modeRest => 'Repos';

  @override
  String get modeWork => 'Travail';

  @override
  String get modeWorkFull => 'Autre travail';

  @override
  String get modeAvailability => 'Disponibilité';

  @override
  String get modeNone => 'Aucune activité choisie';

  @override
  String modeSince(String time) {
    return 'depuis $time';
  }

  @override
  String get switchFailed => 'L’activité n’a pas été enregistrée. Réessayez.';

  @override
  String homeShiftSince(String date, String time) {
    return '$date · poste depuis $time';
  }

  @override
  String homeNoShift(String date) {
    return '$date · poste non commencé';
  }

  @override
  String get homeLoadError =>
      'Impossible d’ouvrir le journal. Redémarrez l’application — si cela ne suffit pas, écrivez-nous via « Plus ».';

  @override
  String get heroUntilBreak => 'Avant la pause';

  @override
  String get heroBreak => 'Pause';

  @override
  String get heroDailyRest => 'Repos journalier';

  @override
  String get heroWeeklyRest => 'Repos hebdomadaire';

  @override
  String heroContinuousOf(String time, String limit) {
    return 'sans pause $time sur $limit';
  }

  @override
  String get heroOffDutyHint =>
      'Poste terminé. Le suivant commencera avec la première activité autre que le repos.';

  @override
  String get bannerBreakNeeded45 =>
      'Pause de 45 min nécessaire (ou fractionnée 15 + 30)';

  @override
  String get bannerBreakNeeded30 =>
      'Pause de 30 min nécessaire — deuxième partie de la pause 15 + 30';

  @override
  String bannerOnBreak(String time, int required) {
    return 'Pause $time sur $required min';
  }

  @override
  String bannerBreakCounted(String limit) {
    return 'Pause validée — vous pouvez conduire $limit';
  }

  @override
  String get sectionAlerts => 'Alertes';

  @override
  String get sectionToday => 'Aujourd’hui';

  @override
  String get sectionRest => 'Repos';

  @override
  String get sectionWeek => 'Semaine';

  @override
  String get rowContinuous => 'Conduite sans pause';

  @override
  String get chipBreakSoon => 'pause bientôt';

  @override
  String get chipExceeded => 'dépassé';

  @override
  String get chipLimiting => 'limite';

  @override
  String get chipShiftSoon => 'fin bientôt';

  @override
  String get chipLimitSoon => 'limite bientôt';

  @override
  String get chipRestSoon => 'repos bientôt';

  @override
  String chipTimes(int hours, int count) {
    return '$hours h ×$count';
  }

  @override
  String limitOf(String limit) {
    return 'limite $limit';
  }

  @override
  String leftUntil(String left, String time) {
    return 'encore $left → $time';
  }

  @override
  String left(String left) {
    return 'encore $left';
  }

  @override
  String limitLeft(int hours, String left) {
    return '$hours h : encore $left';
  }

  @override
  String limitLeftUntil(int hours, String left, String time) {
    return '$hours h : encore $left → $time';
  }

  @override
  String limitUntil(int hours, String time) {
    return '$hours h → $time';
  }

  @override
  String get rowWorkday => 'Journée de travail';

  @override
  String get workdayNoShift => 'Poste non commencé';

  @override
  String get rowDailyDriving => 'Conduite journalière';

  @override
  String get rowBreak => 'Pause';

  @override
  String breakTaken(int minutes, String time) {
    return '$minutes min prises à $time';
  }

  @override
  String breakStillNeeded(int minutes) {
    return 'encore $minutes min';
  }

  @override
  String get breakNotTaken => 'Pas encore de pause';

  @override
  String breakResting(String time, int required) {
    return 'Pause en cours $time sur $required min';
  }

  @override
  String get rowDailyRest => 'Repos journalier';

  @override
  String get dailyRestCaption => '11 h normal · 9 h réduit';

  @override
  String get dailyRestSplit => '3 + 9';

  @override
  String get rowWeeklyRest => 'Repos hebdomadaire';

  @override
  String get weeklyRestCaption => '45 h normal · 24 h réduit';

  @override
  String get chipReducedAvailable => '24 h possible';

  @override
  String get chipReducedUnavailable => '45 h seulement';

  @override
  String get statusNotStarted => 'non commencé';

  @override
  String statusInProgress(String time) {
    return 'en cours $time';
  }

  @override
  String statusBy(String when) {
    return 'avant $when';
  }

  @override
  String get statusNoData => 'pas de données';

  @override
  String get rowWeeklyDriving => 'Conduite hebdomadaire';

  @override
  String get rowFortnightDriving => 'Conduite sur deux semaines';

  @override
  String get rowWorkWeek => 'Semaine de travail';

  @override
  String workWeekSince(String since) {
    return 'depuis $since';
  }

  @override
  String get workWeekUnknown =>
      'Pas de données sur le repos hebdomadaire précédent';

  @override
  String get cardTitle => 'Téléchargement de la carte';

  @override
  String cardCaption(String last, String due) {
    return 'dernier $last · avant $due';
  }

  @override
  String get cardNever => 'Indiquer le dernier téléchargement';

  @override
  String cardSheetLast(String date) {
    return 'Dernier téléchargement : $date';
  }

  @override
  String get cardSheetNever => 'Aucun téléchargement indiqué.';

  @override
  String get cardSheetRule =>
      'Les données de la carte conducteur doivent être téléchargées au moins tous les 28 jours (règlement (UE) nº 581/2010).';

  @override
  String get cardMarkToday => 'Téléchargée aujourd’hui';

  @override
  String get cardMarked => 'Téléchargement indiqué';

  @override
  String get workdayStart => 'Début du poste';

  @override
  String workdayRegular(int hours) {
    return '$hours h — journée normale';
  }

  @override
  String workdayRegularHint(String left) {
    return 'puis repos normal de 11 h · encore $left';
  }

  @override
  String workdayExtended(int hours) {
    return '$hours h — journée prolongée';
  }

  @override
  String workdayExtendedHint(int count) {
    return 'puis repos réduit de 9 h · reste ×$count';
  }

  @override
  String get workdayRule =>
      'Le repos journalier doit se terminer dans les 24 heures suivant le début du poste. Le repos réduit de 9 h est permis au plus trois fois entre deux repos hebdomadaires.';

  @override
  String get dailyRestOngoing => 'Repos en cours';

  @override
  String get dailyRestStartBy => 'Commencer le repos au plus tard';

  @override
  String dailyRestReducedBy(int hours, String time) {
    return 'réduit $hours h — avant $time';
  }

  @override
  String get dailyRestOptions => 'Combien de repos';

  @override
  String dailyRestMilestone(int hours, String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'split': 'première partie du repos fractionné',
      'reduced': 'réduit',
      'other': 'normal',
    });
    return '$hours h — $_temp0';
  }

  @override
  String get dailyRestReached => 'atteint';

  @override
  String dailyRestLeftCount(String left, int count) {
    return 'encore $left · reste ×$count';
  }

  @override
  String get dailyRestNoReduced =>
      'plus de réductions avant le repos hebdomadaire';

  @override
  String get dailyRestSplitHint =>
      'puis un repos d’au moins 9 h — au moins 12 h au total';

  @override
  String get dailyRestStartLatest => 'commencer au plus tard';

  @override
  String dailyRestStartLatestCount(int count) {
    return 'commencer au plus tard · reste ×$count';
  }

  @override
  String get dailyRestInShift =>
      'Tant que le repos dure moins de 9 h, c’est une pause dans le poste. À partir de 9 h, il devient repos journalier et termine le poste. Travail terminé ? « Terminer la journée ».';

  @override
  String get dailyRestRule =>
      'Repos journalier : 11 h d’affilée. Réduit : 9 h, au plus trois fois entre deux repos hebdomadaires. Fractionné : d’abord au moins 3 h, puis au moins 9 h. Le repos doit se terminer dans les 24 heures suivant le début du poste.';

  @override
  String get workdayEndDay => 'Terminer la journée';

  @override
  String get workdayEndDayHint =>
      'Le repos commence maintenant et termine le poste, même s’il dure moins de 9 h.';

  @override
  String get endDayDriving => 'Conduite du jour';

  @override
  String get endDayDrivingHint =>
      'Combien de temps avez-vous conduit aujourd’hui ? Les heures exactes des modes ne sont pas nécessaires — seulement le total.';

  @override
  String todayDate(String date) {
    return 'Aujourd’hui, $date';
  }

  @override
  String infrArticle(String regulation, String article) {
    return 'UE $regulation · art. $article';
  }

  @override
  String get infrContinuousExceededTitle => 'Conduite sans pause dépassée';

  @override
  String infrContinuousExceededText(String limit, String time, int required) {
    return 'Conduite sans pause supérieure à $limit de $time. Arrêtez-vous et faites une pause de $required min.';
  }

  @override
  String get infrBreakSoonTitle => 'Pause bientôt';

  @override
  String infrBreakSoonText(String limit, String time, int required) {
    return 'Il reste $time avant la limite de $limit. Une pause de $required min est nécessaire.';
  }

  @override
  String get infrDailyDriveExceededTitle => 'Conduite journalière dépassée';

  @override
  String infrDailyDriveExceededText(String limit, String time) {
    return 'Plus de $limit de $time. Commencez le repos journalier.';
  }

  @override
  String get infrDailyDriveSoonTitle => 'Conduite journalière bientôt épuisée';

  @override
  String infrDailyDriveSoonText(String limit, String time) {
    return 'Il reste $time avant la limite de $limit.';
  }

  @override
  String get infrExtensionInUseTitle => 'Prolongation à 10 h en cours';

  @override
  String infrExtensionInUseText(int count) {
    return 'Prolongations restantes cette semaine : $count.';
  }

  @override
  String get infrShiftExceededTitle => 'Journée de travail dépassée';

  @override
  String infrShiftExceededText(String limit, String time) {
    return 'Poste supérieur à $limit de $time. Commencez le repos journalier.';
  }

  @override
  String get infrShiftSoonTitle => 'Fin de la journée de travail bientôt';

  @override
  String infrShiftSoonText(String time) {
    return 'Commencez le repos journalier dans $time.';
  }

  @override
  String get infrWeeklyDriveExceededTitle => 'Conduite hebdomadaire dépassée';

  @override
  String infrWeeklyDriveExceededText(String limit, String time) {
    return 'Plus de $limit de $time.';
  }

  @override
  String get infrWeeklyDriveSoonTitle =>
      'Conduite hebdomadaire bientôt épuisée';

  @override
  String infrWeeklyDriveSoonText(String limit, String time) {
    return 'Il reste $time avant $limit.';
  }

  @override
  String get infrFortnightDriveExceededTitle =>
      'Conduite sur deux semaines dépassée';

  @override
  String infrFortnightDriveExceededText(String limit, String time) {
    return 'Plus de $limit de $time.';
  }

  @override
  String get infrFortnightDriveSoonTitle =>
      'Conduite sur deux semaines bientôt épuisée';

  @override
  String infrFortnightDriveSoonText(String limit, String time) {
    return 'Il reste $time avant $limit.';
  }

  @override
  String get infrWeeklyRestOverdueTitle => 'Repos hebdomadaire en retard';

  @override
  String infrWeeklyRestOverdueText(String time) {
    return 'Plus de 144 h se sont écoulées depuis le repos hebdomadaire précédent — de $time.';
  }

  @override
  String get infrWeeklyRestSoonTitle => 'Repos hebdomadaire bientôt';

  @override
  String infrWeeklyRestSoonText(String time) {
    return 'Commencez le repos hebdomadaire dans $time.';
  }

  @override
  String get infrWeeklyRestContinueTitle => 'N’interrompez pas le repos';

  @override
  String infrWeeklyRestContinueText(String time) {
    return 'Le délai du repos hebdomadaire est dépassé. Reposez-vous encore $time pour que ce repos compte comme hebdomadaire.';
  }

  @override
  String get infrCompensationSoonTitle => 'Échéance de compensation proche';

  @override
  String infrCompensationSoonText(String time, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days jours',
      one: '$days jour',
    );
    return 'Ajoutez $time à un repos d’au moins 9 h. Échéance dans $_temp0.';
  }

  @override
  String get infrCompensationOverdueTitle => 'Compensation en retard';

  @override
  String infrCompensationOverdueText(String time, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days jours',
      one: '$days jour',
    );
    return '$time du repos hebdomadaire réduit n’ont pas été ajoutées. Retard — $_temp0.';
  }

  @override
  String get infrReducedRestsExceededTitle => 'Trop de repos réduits';

  @override
  String infrReducedRestsExceededText(int count) {
    return 'Repos réduits depuis le repos hebdomadaire : $count, 3 autorisés.';
  }

  @override
  String get infrCardOverdueTitle => 'Téléchargement de la carte en retard';

  @override
  String infrCardOverdueText(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days jours',
      one: '$days jour',
    );
    return 'Le délai de 28 jours est dépassé depuis $_temp0.';
  }

  @override
  String get infrCardSoonTitle => 'Téléchargement de la carte bientôt';

  @override
  String infrCardSoonText(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days jours',
      one: '$days jour',
    );
    return 'Il reste $_temp0.';
  }

  @override
  String get ferryTitle => 'Ferry / train';

  @override
  String get ferryHint =>
      'Le repos peut être interrompu deux fois au plus, pour 1 h au total (art. 9). Le mouvement du ferry ne déclenche pas la conduite.';

  @override
  String get ferryOn => 'ferry';

  @override
  String breakHero(String limit) {
    return 'Pause après $limit de conduite';
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
    return '$minutes min — reste';
  }

  @override
  String breakFirstTaken(String from, String to) {
    return 'Première partie prise $from–$to';
  }

  @override
  String get breakNone =>
      'Pause de 45 min d’affilée ou de 15 + 30 min nécessaire.';

  @override
  String get breakSplitTitle => 'Pause fractionnée 15 + 30';

  @override
  String get breakSplitText =>
      'La première partie d’au moins 15 min, la seconde d’au moins 30 min, dans cet ordre. L’application la reconnaît toute seule.';

  @override
  String get breakStart => 'Commencer la pause';

  @override
  String get breakOngoing => 'Pause en cours';

  @override
  String get weeklyStartBy => 'Commencer au plus tard';

  @override
  String weeklyInTime(String left) {
    return 'dans $left — fin de la semaine de travail (144 h)';
  }

  @override
  String weeklyOverdue(String time) {
    return 'retard $time';
  }

  @override
  String get weeklyOngoing => 'Repos hebdomadaire en cours';

  @override
  String get weeklyUnknown =>
      'Pas de données sur le repos hebdomadaire précédent. L’échéance apparaîtra après un repos de 24 h ou plus.';

  @override
  String get weeklyNext => 'Prochain repos';

  @override
  String get weeklyFull => 'Normal';

  @override
  String get weeklyFullHint => 'pas dans la cabine';

  @override
  String get weeklyReduced => 'Réduit';

  @override
  String get weeklyReducedYes => 'possible · avec compensation';

  @override
  String get weeklyReducedNo => 'impossible — repos normal nécessaire';

  @override
  String get weeklyHistory => 'Historique';

  @override
  String weeklyPrevious(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'full': 'normal',
      'reduced': 'réduit',
      'other': 'insuffisant',
    });
    return 'Précédent · $_temp0';
  }

  @override
  String get weeklyNow => 'maintenant';

  @override
  String get weeklyCompensation => 'Compensation due';

  @override
  String get weeklyCompensationNone => 'aucune';

  @override
  String weeklyCompensationValue(String time, String date) {
    return '$time avant le $date';
  }

  @override
  String get weeklyMobilityOn =>
      'Paquet mobilité activé : en transport international, deux repos réduits consécutifs sont permis s’ils sont pris hors du pays d’immatriculation. La réduction est compensée avant la fin de la troisième semaine.';

  @override
  String get weeklyMobilityOff =>
      'Un repos hebdomadaire réduit est compensé avant la fin de la troisième semaine : la dette s’ajoute à un repos d’au moins 9 h.';

  @override
  String get weeklyStartRest => 'Commencer le repos';

  @override
  String get countryTitle => 'Choix du pays';

  @override
  String countryChip(String start, String end) {
    return 'Pays de départ $start, d’arrivée $end. Modifier';
  }

  @override
  String countryChipNoEnd(String start) {
    return 'Pays de départ $start, d’arrivée non choisi. Modifier';
  }

  @override
  String get countryChipNone => 'Pays du poste non choisi. Choisir';

  @override
  String countryStartTab(String code) {
    return 'Début · $code';
  }

  @override
  String countryEndTab(String code) {
    return 'Fin · $code';
  }

  @override
  String get countryNextShift => 'Pays du prochain poste';

  @override
  String get countrySearch => 'Pays ou code';

  @override
  String get countryFrequent => 'Fréquemment utilisés';

  @override
  String get countryClearEnd => 'Ne pas indiquer';

  @override
  String get countryNotFound => 'Aucun résultat';

  @override
  String get countryFooter =>
      'Le conducteur saisit le pays de début et de fin du poste dans le tachygraphe (règlement (UE) nº 165/2014, art. 34).';

  @override
  String countryName(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'A': 'Autriche',
      'AL': 'Albanie',
      'AND': 'Andorre',
      'ARM': 'Arménie',
      'AZ': 'Azerbaïdjan',
      'B': 'Belgique',
      'BG': 'Bulgarie',
      'BIH': 'Bosnie-Herzégovine',
      'BY': 'Biélorussie',
      'CH': 'Suisse',
      'CY': 'Chypre',
      'CZ': 'Tchéquie',
      'D': 'Allemagne',
      'DK': 'Danemark',
      'E': 'Espagne',
      'EST': 'Estonie',
      'F': 'France',
      'FIN': 'Finlande',
      'FL': 'Liechtenstein',
      'GE': 'Géorgie',
      'GR': 'Grèce',
      'H': 'Hongrie',
      'HR': 'Croatie',
      'I': 'Italie',
      'IRL': 'Irlande',
      'IS': 'Islande',
      'KZ': 'Kazakhstan',
      'L': 'Luxembourg',
      'LT': 'Lituanie',
      'LV': 'Lettonie',
      'M': 'Malte',
      'MC': 'Monaco',
      'MD': 'Moldavie',
      'MK': 'Macédoine du Nord',
      'MNE': 'Monténégro',
      'N': 'Norvège',
      'NL': 'Pays-Bas',
      'P': 'Portugal',
      'PL': 'Pologne',
      'RO': 'Roumanie',
      'RSM': 'Saint-Marin',
      'RUS': 'Russie',
      'S': 'Suède',
      'SK': 'Slovaquie',
      'SLO': 'Slovénie',
      'SRB': 'Serbie',
      'TJ': 'Tadjikistan',
      'TM': 'Turkménistan',
      'TR': 'Turquie',
      'UA': 'Ukraine',
      'UK': 'Royaume-Uni',
      'UZ': 'Ouzbékistan',
      'V': 'Vatican',
      'other': '$code',
    });
    return '$_temp0';
  }

  @override
  String get journalExport => 'Exporter le rapport';

  @override
  String get journalCurrent => 'en cours';

  @override
  String get journalDriving => 'Conduite';

  @override
  String get journalFortnight => 'Sur 2 sem.';

  @override
  String journalOf(int limit) {
    return 'sur $limit';
  }

  @override
  String get journalCollapsedDriving => 'conduite';

  @override
  String journalWeekSpoken(String range, String driving, String fortnight) {
    return 'Semaine $range. Conduite $driving sur 56 h, sur deux semaines $fortnight sur 90 h';
  }

  @override
  String get journalShift => 'Poste';

  @override
  String get journalWeeklyShort => 'hebdo';

  @override
  String get journalOngoing => 'en cours';

  @override
  String get journalManual => 'manuel';

  @override
  String get journalAddShift => 'Poste';

  @override
  String get journalAddShiftSpoken => 'Ajouter un poste';

  @override
  String get journalEmpty =>
      'Pas encore de postes. Ils apparaîtront quand vous changerez d’activité — ou ajoutez un poste manuellement.';

  @override
  String restStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'full': 'normal',
      'reduced': 'réduit',
      'other': 'insuffisant',
    });
    return '$_temp0';
  }

  @override
  String journalWeeklyRest(String status) {
    return 'Repos hebdomadaire · $status';
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
    return '$date, $route, $time. Conduite $driving, poste $span, repos $rest';
  }

  @override
  String get journalRestNone => 'aucun';

  @override
  String get journalRestWeekly => 'hebdomadaire';

  @override
  String get journalLoadError =>
      'Impossible d’ouvrir le journal. Redémarrez l’application — si cela ne suffit pas, écrivez-nous via « Plus ».';

  @override
  String get dayTitle => 'Poste';

  @override
  String get daySummary => 'Bilan';

  @override
  String get dayBreaks => 'Pauses';

  @override
  String get dayContinuousAtEnd => 'Sans pause en fin de poste';

  @override
  String get dayRestAfter => 'Repos après le poste';

  @override
  String dayRestKind(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'daily': 'Journalier',
      'weekly': 'Hebdomadaire',
      'other': 'Non commencé',
    });
    return '$_temp0';
  }

  @override
  String get daySplitRest => 'fractionné 3 + 9';

  @override
  String get dayNotes => 'Notes';

  @override
  String get dayEdit => 'Modifier le poste';

  @override
  String get dayNotFound => 'Ce poste n’est plus dans le journal.';

  @override
  String dayRestUntil(String time) {
    return 'jusqu’à $time';
  }

  @override
  String get save => 'Enregistrer';

  @override
  String get cancel => 'Annuler';

  @override
  String get done => 'Terminé';

  @override
  String get delete => 'Supprimer';

  @override
  String get unitHours => 'h';

  @override
  String get unitMinutes => 'min';

  @override
  String get pickerHours => 'Heures';

  @override
  String get pickerMinutes => 'Minutes';

  @override
  String get pickerTime => 'Heure';

  @override
  String get pickerPrevMonth => 'Mois précédent';

  @override
  String get pickerNextMonth => 'Mois suivant';

  @override
  String pickerRange(String min, String max) {
    return 'Possible de $min à $max';
  }

  @override
  String get shiftNewTitle => 'Nouveau poste';

  @override
  String get shiftSection => 'Poste';

  @override
  String get shiftStart => 'Début';

  @override
  String get shiftEnd => 'Fin';

  @override
  String get shiftOnRoad => 'en route';

  @override
  String get shiftChoose => 'Choisir';

  @override
  String get shiftNowOngoing => 'Maintenant (en cours)';

  @override
  String get shiftDuration => 'Durée';

  @override
  String get shiftNowSuffix => 'maintenant';

  @override
  String shiftCountrySpoken(String side, String code) {
    return '$side : pays $code. Modifier';
  }

  @override
  String shiftDateSpoken(String side, String date, String time) {
    return '$side : $date, $time. Modifier';
  }

  @override
  String get shiftDriving => 'Conduite';

  @override
  String get shiftPerDay => 'Par jour';

  @override
  String get shiftLiveContinuous => 'calculée d’après les pauses';

  @override
  String get shiftDrivingAfterRest =>
      'se saisit une fois le repos après le poste choisi';

  @override
  String get shiftRestNone => 'Non commencé';

  @override
  String get shiftRestDaily => 'Journalier';

  @override
  String get shiftRestWeekly => 'Hebdomadaire';

  @override
  String get shiftSplit => 'Repos fractionné 3 + 9';

  @override
  String get shiftSplitHint => 'D’abord 3 h, puis 9 h';

  @override
  String shiftRestUntilNext(String when) {
    return 'Jusqu’au début du poste : $when';
  }

  @override
  String get shiftRestAutoHint => 'Dure jusqu’au début du poste suivant';

  @override
  String get shiftRestCountsWeekly =>
      'À partir de 24 h, le repos compte comme hebdomadaire';

  @override
  String get shiftNotesHint => 'Par exemple : ferry, attente de chargement';

  @override
  String get shiftDelete => 'Supprimer le poste';

  @override
  String get shiftDeleteTitle => 'Supprimer le poste ?';

  @override
  String get shiftDeleteManual => 'Le poste sera supprimé du journal.';

  @override
  String get shiftDeleteRecorded =>
      'Tous les enregistrements d’activités de ce poste seront supprimés. Impossible d’annuler.';

  @override
  String get shiftErrStartCountry => 'Choisissez le pays de début du poste';

  @override
  String get shiftErrEndCountry => 'Indiquez le pays de fin du poste';

  @override
  String get shiftErrEndBeforeStart => 'La fin du poste est avant le début';

  @override
  String get shiftErrFuture =>
      'L’heure du poste ne peut pas être dans le futur';

  @override
  String get shiftErrTooLong => 'Poste de plus de 30 h — vérifiez les dates';

  @override
  String get shiftErrDrivingTooLong => 'Conduite plus longue que le poste';

  @override
  String get shiftErrContinuous =>
      'Conduite sans pause plus longue que la conduite journalière';

  @override
  String shiftErrOverlap(String range) {
    return 'Chevauche le poste $range';
  }

  @override
  String get shiftErrNotLast =>
      'D’autres postes suivent celui-ci — il ne peut pas être en cours';

  @override
  String get shiftSaveFailed => 'Échec de l’enregistrement. Réessayez.';

  @override
  String get shiftSavedViolations => 'Poste enregistré. Il y a des infractions';

  @override
  String get shiftSavedViolationsText =>
      'Vérifiez les heures. Si tout est exact, les infractions figureront dans le journal et le rapport.';

  @override
  String get gotIt => 'Compris';

  @override
  String get shiftLiveHint =>
      'Le poste suit les enregistrements d’activités : modifier le début, la fin ou la conduite déplace les enregistrements eux-mêmes.';

  @override
  String get shiftConvertHint =>
      'Heure, conduite ou repos modifiés — le poste sera enregistré comme saisie manuelle à la place des enregistrements d’activités.';

  @override
  String get shiftLiveConvertHint =>
      'Conduite du jour saisie en total — le poste sera enregistré comme saisie manuelle à la place des enregistrements d’activités, le repos qui suit continue.';

  @override
  String shiftEndNowHint(String time) {
    return 'Le poste se terminera à $time, puis le repos commencera.';
  }

  @override
  String get shiftResumeHint =>
      'Le repos après le poste sera supprimé — le poste continuera.';

  @override
  String shiftOngoingHint(String time, String mode) {
    return 'Le poste deviendra le poste en cours et continuera sur l’écran d’accueil à partir de $time. Activité « $mode » — si une autre s’applique maintenant, changez-la là-bas.';
  }

  @override
  String get shiftUnsavedTitle => 'Enregistrer les modifications ?';

  @override
  String get shiftUnsavedText =>
      'Les modifications de ce poste ne sont pas encore enregistrées.';

  @override
  String get shiftDiscard => 'Ne pas enregistrer';

  @override
  String get shiftDateTimeTitle => 'Date et heure du poste';

  @override
  String driveEditSubtitle(String date) {
    return 'Correction manuelle · $date';
  }

  @override
  String get driveEditComputed => 'Calculé par l’application';

  @override
  String driveEditDiff(String diff) {
    return '$diff par rapport au calcul.';
  }

  @override
  String get driveEditNoChange => 'Durée inchangée.';

  @override
  String get driveEditHint =>
      'À utiliser si l’activité a été changée au mauvais moment — les limites seront recalculées.';

  @override
  String get driveEditNoDrive =>
      'Pas encore de conduite dans le poste en cours — rien à corriger.';

  @override
  String get breakCorrection => 'Correction';

  @override
  String get breakCurrentDuration => 'Pause en cours';

  @override
  String get breakLastDuration => 'Dernière pause';

  @override
  String get breakNoBreak =>
      'Pas encore de pause dans le poste — rien à corriger.';

  @override
  String get breakEditHint =>
      'Le temps est pris sur l’enregistrement voisin — les limites seront recalculées.';

  @override
  String get workdayChangeStart => 'Modifier le début du poste';

  @override
  String get weeklyAddManually => 'Saisir manuellement';

  @override
  String get exportPeriod => 'Période';

  @override
  String get exportWeek => 'Cette semaine';

  @override
  String get exportTwoWeeks => '2 semaines';

  @override
  String get exportDays28 => '28 jours';

  @override
  String get exportCustom => 'Période libre';

  @override
  String get exportFrom => 'Du';

  @override
  String get exportTo => 'Au';

  @override
  String exportFromDay(String date) {
    return 'Du $date';
  }

  @override
  String exportToDay(String date) {
    return 'Au $date';
  }

  @override
  String get exportFormat => 'Format';

  @override
  String get exportPdf => 'PDF · pour le contrôle';

  @override
  String get exportCsv => 'CSV · tableau';

  @override
  String get exportPdfHint =>
      'Ce n’est pas un document officiel : le rapport ne remplace pas les données du tachygraphe et de la carte conducteur.';

  @override
  String get exportCsvHint =>
      'Enregistrements d’activités ligne par ligne, heure en UTC — pour Excel et les logiciels de gestion.';

  @override
  String get exportLanguage => 'Langue du rapport';

  @override
  String get exportNotes => 'Pays et notes';

  @override
  String get exportCreate => 'Créer le rapport';

  @override
  String exportCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count postes',
      one: '$count poste',
    );
    return '$_temp0 dans le rapport';
  }

  @override
  String get exportEmpty => 'Aucun poste sur la période choisie.';

  @override
  String get exportFailed => 'Impossible de créer le rapport. Réessayez.';

  @override
  String exportRangeSpoken(String from, String to) {
    return 'Période du $from au $to';
  }

  @override
  String get reportTitle => 'Rapport des temps de conduite et de repos';

  @override
  String get reportSubtitle => 'Règlement (CE) nº 561/2006 et accord AETR';

  @override
  String get reportDriver => 'Conducteur';

  @override
  String get reportCard => 'Carte conducteur';

  @override
  String get reportVehicle => 'Immatriculation';

  @override
  String get reportCompany => 'Transporteur';

  @override
  String get reportPeriod => 'Période';

  @override
  String get reportGenerated => 'Créé le';

  @override
  String reportTimezone(String zone) {
    return 'Heures selon le fuseau horaire du téléphone ($zone). Jours et semaines du rapport en UTC, la semaine commence le lundi à 00:00, comme dans le tachygraphe.';
  }

  @override
  String get reportDate => 'Date';

  @override
  String get reportStart => 'Début';

  @override
  String get reportEnd => 'Fin';

  @override
  String get reportCountries => 'Pays';

  @override
  String get reportDriving => 'Conduite';

  @override
  String get reportWork => 'Travail';

  @override
  String get reportAvailability => 'Dispo.';

  @override
  String get reportBreaks => 'Pauses';

  @override
  String get reportSpan => 'Poste';

  @override
  String get reportRestAfter => 'Repos après';

  @override
  String get reportNotes => 'Notes';

  @override
  String reportWeek(String range) {
    return 'Semaine $range';
  }

  @override
  String reportWeekTotal(String driving, String fortnight) {
    return 'Total : conduite $driving sur 56 h · sur 2 semaines $fortnight sur 90 h';
  }

  @override
  String get reportViolations => 'Infractions';

  @override
  String get reportNoViolations => 'Aucune infraction d’après le journal.';

  @override
  String reportViolationDrive(String date, String time) {
    return '$date : conduite journalière $time — plus de 10 h';
  }

  @override
  String reportViolationSpan(String date, String time, int limit) {
    return '$date : journée de travail $time — plus de $limit h';
  }

  @override
  String reportViolationRest(String date, String time) {
    return '$date : repos après le poste $time — insuffisant';
  }

  @override
  String reportViolationWeek(String range, String time) {
    return 'Semaine $range : conduite $time — plus de 56 h';
  }

  @override
  String reportViolationFortnight(String range, String time) {
    return 'Semaine $range : sur deux semaines $time — plus de 90 h';
  }

  @override
  String get reportMarks => 'Légende';

  @override
  String get reportMarkWarn =>
      '! — conduite prolongée à 10 h, journée de travail de plus de 13 h ou repos réduit';

  @override
  String get reportMarkBad => '!! — infraction';

  @override
  String get reportMarkManual => '* — poste saisi manuellement en totaux';

  @override
  String get reportDisclaimer =>
      'Le rapport est établi d’après les saisies du conducteur dans l’application TachoGo. Ce n’est pas un document officiel : il ne remplace pas les données du tachygraphe et de la carte conducteur.';

  @override
  String get reportSignature => 'Signature du conducteur';

  @override
  String reportPage(int page, int pages) {
    return 'Page $page sur $pages';
  }

  @override
  String get openSystemSettings => 'Ouvrir les réglages';

  @override
  String get settingsGeneral => 'Général';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsLanguageSystem => 'Comme le téléphone';

  @override
  String get settingsTheme => 'Apparence';

  @override
  String get themeSystem => 'Système';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get settingsRules => 'Règles';

  @override
  String get settingsTachograph => 'Tachygraphe du véhicule';

  @override
  String get tachographDigital => 'Numérique';

  @override
  String get tachographAnalog => 'Analogique';

  @override
  String get settingsMobility => 'Paquet mobilité';

  @override
  String get settingsMobilityHint =>
      'Deux repos hebdomadaires réduits consécutifs en transport international';

  @override
  String get settingsCrew => 'Équipage double';

  @override
  String get settingsCrewHint =>
      'Repos journalier de 9 h dans les 30 h suivant le début du poste';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsWarnLead => 'Avertir des limites';

  @override
  String get settingsWarnLeadHint => 'Pause, fin de journée, conduite';

  @override
  String get settingsWarnLeadGroup => 'Avertir à l’avance';

  @override
  String leadMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String leadHours(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours heures',
      one: '$hours heure',
    );
    return '$_temp0';
  }

  @override
  String get notifyBreak => 'Pause';

  @override
  String get notifyShiftEnd => 'Fin de la journée de travail';

  @override
  String get notifyShiftEndHint => 'Repos journalier et hebdomadaire';

  @override
  String get notifyDriving => 'Limite de conduite';

  @override
  String get notifyCard => 'Téléchargement de la carte';

  @override
  String get notifyCardHint => 'Tous les 28 jours';

  @override
  String get notifyCardLead => 'À l’avance';

  @override
  String get notifyCardLeadGroup =>
      'Alerte de téléchargement de la carte à l’avance';

  @override
  String leadDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days jours',
      one: '$days jour',
    );
    return '$_temp0';
  }

  @override
  String get notifyAllow => 'Autoriser les notifications';

  @override
  String get notifyDenied => 'Les notifications sont bloquées sur le téléphone';

  @override
  String get notifyAllowed => 'Notifications autorisées';

  @override
  String get notifyExact => 'Heure exacte des notifications';

  @override
  String get notifyExactHint =>
      'Autorisez « Alarmes et rappels » — sinon le téléphone peut retarder l’alerte';

  @override
  String get notifyChannelLimits => 'Limites et infractions';

  @override
  String get notifyChannelLimitsHint =>
      'Pause, fin de la journée de travail, conduite, repos hebdomadaire, carte';

  @override
  String get notifyChannelRest => 'Repos validé';

  @override
  String get notifyChannelRestHint =>
      'Pause validée, repos journalier et hebdomadaire validés';

  @override
  String get notifyBreakTakenTitle => 'Pause validée';

  @override
  String notifyBreakTakenText(int required, String time) {
    return 'Pause de $required min validée. Vous pouvez conduire $time jusqu’à la prochaine pause.';
  }

  @override
  String get notifyDailyRestTakenTitle => 'Repos journalier validé';

  @override
  String notifyDailyRestTakenText(String limit) {
    return 'Repos normal de $limit — vous pouvez commencer le poste.';
  }

  @override
  String get notifyWeeklyRestTakenTitle => 'Repos hebdomadaire validé';

  @override
  String notifyWeeklyRestTakenText(String limit) {
    return 'Repos normal de $limit — vous pouvez commencer une nouvelle semaine de travail.';
  }

  @override
  String get serviceChannel => 'Détection automatique de la conduite';

  @override
  String get serviceChannelHint =>
      'Activité en cours et compteurs pendant la détection automatique';

  @override
  String get serviceStarted => 'Détection automatique de la conduite activée';

  @override
  String serviceModeTitle(String mode, String time) {
    return '$mode · $time';
  }

  @override
  String get serviceTeamTitle => 'Le véhicule roule';

  @override
  String serviceTeamText(String time) {
    return 'Vous conduisez ? Conduite depuis $time';
  }

  @override
  String get serviceSuggestTitle => 'Vous semblez rouler';

  @override
  String serviceSuggestText(String time) {
    return 'Commencer la conduite à $time ? Le repos sera interrompu';
  }

  @override
  String serviceDriving(String untilBreak, String dayLeft) {
    return 'Avant la pause $untilBreak · reste aujourd’hui $dayLeft';
  }

  @override
  String serviceDrivingOver(String time) {
    return 'Pause nécessaire : dépassement de $time';
  }

  @override
  String serviceBreakLeft(String time) {
    return 'Avant la pause complète $time';
  }

  @override
  String serviceBreakDone(String time) {
    return 'Pause validée, vous pouvez conduire $time';
  }

  @override
  String serviceWorkday(String time, String limit) {
    return 'Journée de travail $time sur $limit';
  }

  @override
  String serviceRestLeft(String limit, String time) {
    return 'Avant le repos complet de $limit : $time';
  }

  @override
  String get serviceDailyRestDone => 'Repos journalier normal validé';

  @override
  String get serviceWeeklyRestDone => 'Repos hebdomadaire normal validé';

  @override
  String get serviceNotStartedText =>
      'La conduite s’activera d’elle-même au démarrage du véhicule';

  @override
  String get serviceNoModeText => 'Ouvrez TachoGo et choisissez une activité';

  @override
  String get autoTitle => 'Détection automatique de la conduite';

  @override
  String get autoSwitch => 'Détecter la conduite par GPS';

  @override
  String get autoSwitchHint =>
      'Vous démarrez — conduite, vous vous arrêtez — autre travail. Seule la vitesse est utilisée : les coordonnées ne sont pas enregistrées.';

  @override
  String get autoAfterStop => 'Après l’arrêt';

  @override
  String get autoAfterStopHint => 'Après 3 minutes d’arrêt';

  @override
  String get autoStartFromRest => 'Conduite dès la fin du repos';

  @override
  String get autoStartFromRestHint =>
      'Sinon l’application demande d’abord : vous étiez peut-être passager';

  @override
  String get autoBattery => 'Économie de batterie';

  @override
  String get autoBatteryLimited =>
      'Peut arrêter la détection. Retirez TachoGo de la liste d’économie';

  @override
  String get autoBatteryOk => 'Ne gêne pas le fonctionnement en arrière-plan';

  @override
  String get autoAutostart => 'Démarrage auto et arrière-plan';

  @override
  String get autoAutostartHint =>
      'Xiaomi, Huawei, Honor, Oppo, Vivo, Samsung : autorisez-le, sinon le téléphone arrêtera la détection';

  @override
  String get autoBlockedService =>
      'La localisation est désactivée sur le téléphone. Activez-la pour détecter la conduite.';

  @override
  String get autoBlockedDenied =>
      'Sans accès à la position, la conduite ne peut pas être détectée. L’application n’utilise que la vitesse, les coordonnées ne sont pas enregistrées.';

  @override
  String get autoBlockedForever =>
      'L’accès à la position est bloqué. Autorisez-le dans les réglages du téléphone : Position → « Pendant l’utilisation de l’application ».';

  @override
  String get autoNoAccess =>
      'Pas d’accès à la position — la détection ne fonctionne pas. Autorisez-le dans les réglages du téléphone.';

  @override
  String get autoEnable => 'Activer la détection de la conduite';

  @override
  String get autoEnabled => 'Détection de la conduite activée';

  @override
  String get settingsData => 'Données';

  @override
  String get settingsExport => 'Exporter le rapport';

  @override
  String get settingsExportFormats => 'PDF · CSV';

  @override
  String get settingsAnalytics => 'Statistiques anonymes';

  @override
  String get settingsAnalyticsHint =>
      'Quels écrans les conducteurs ouvrent — pour améliorer l’application. Sans coordonnées, noms ni numéros de carte.';

  @override
  String get settingsClear => 'Effacer toutes les données';

  @override
  String get clearTitle => 'Effacer toutes les données ?';

  @override
  String get clearText =>
      'Le journal des activités, les postes, les pays, les notes et les téléchargements de carte seront supprimés. Impossible d’annuler. Les réglages seront conservés.';

  @override
  String get clearConfirm => 'Effacer';

  @override
  String get clearDone => 'Données supprimées';

  @override
  String onbStep(int step, int count) {
    return 'Étape $step sur $count';
  }

  @override
  String get onbWelcomeTitle => 'Le temps au volant sous contrôle';

  @override
  String get onbWelcomeText =>
      'Nous calculons la conduite, les pauses et le repos selon les règles UE 561/2006 et AETR et avertissons des limites à l’avance.';

  @override
  String get onbStart => 'Commencer';

  @override
  String get onbNext => 'Suivant';

  @override
  String get onbDone => 'Terminé';

  @override
  String get onbModesTitle => 'Quatre activités — comme sur le tachygraphe';

  @override
  String get onbModesText =>
      'Changez d’activité avec les boutons de l’écran d’accueil. Les compteurs tournent tout seuls — même application fermée.';

  @override
  String get onbModeDriving =>
      'Au volant. Nous comptons la conduite sans pause, journalière et hebdomadaire.';

  @override
  String get onbModeWork => 'Chargement, contrôle du véhicule, documents.';

  @override
  String get onbModeAvailability =>
      'Attente : file au chargement, frontière, second conducteur en route.';

  @override
  String get onbModeRest =>
      'Pauses et repos. « Terminer la journée » clôt le poste.';

  @override
  String get onbSetupTitle => 'Réglons l’application pour vous';

  @override
  String get onbSetupText =>
      'Tout cela peut être modifié plus tard dans les réglages.';

  @override
  String get onbMobilityHint =>
      'Activez si vous faites des trajets internationaux';

  @override
  String onbNotifyText(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutes',
      one: '$minutes minute',
    );
    return 'Nous vous avertirons $_temp0 avant la pause et la fin de la journée de travail — même application fermée.';
  }

  @override
  String get onbAutoText =>
      'Vous démarrez — l’application passe en conduite, vous vous arrêtez — en autre travail. Après un repos, elle demande d’abord. Seule la vitesse GPS est utilisée : les coordonnées ne sont ni enregistrées ni envoyées.';

  @override
  String get onbAutoLater =>
      'Vous pourrez l’activer plus tard dans les réglages.';

  @override
  String languageButton(String language) {
    return 'Langue : $language';
  }

  @override
  String get vehicleVan => 'Utilitaire 2,5–3,5 t';

  @override
  String get onbRulesTitle => 'Les règles essentielles';

  @override
  String get onbRulesText =>
      'Les mêmes pour camions, autocars et utilitaires. L’application les calcule elle-même et avertit à l’avance.';

  @override
  String get onbRulesMore =>
      'Toutes les règles expliquées — « Plus » → « Guide et règles ».';

  @override
  String get guideTitle => 'Guide et règles';

  @override
  String get guideHowTo => 'Mode d’emploi';

  @override
  String get guideStep1 =>
      'Changez d’activité avec les boutons de l’écran d’accueil : conduite, repos, travail ou disponibilité.';

  @override
  String get guideStep2 =>
      'Indiquez le pays de début et de fin du poste — comme sur le tachygraphe.';

  @override
  String get guideStep3 =>
      'Surveillez les limites. L’application avertit à l’avance de la pause et de la fin de journée. Toute durée peut être corrigée manuellement.';

  @override
  String get guideRules => 'Règles UE 561/2006 et AETR';

  @override
  String get guideContinuous => 'Conduite sans pause';

  @override
  String guideContinuousText(String full, String first, String second) {
    return 'Puis une pause de $full. Elle peut être fractionnée : d’abord $first, puis $second.';
  }

  @override
  String get guideDailyDriving => 'Conduite par jour';

  @override
  String guideDailyDrivingText(String extended) {
    return 'Deux fois par semaine, jusqu’à $extended est permis.';
  }

  @override
  String get guideWeeklyDriving => 'Conduite par semaine';

  @override
  String guideWeeklyDrivingText(String fortnight) {
    return 'Sur deux semaines consécutives quelconques — pas plus de $fortnight.';
  }

  @override
  String get guideDailyRest => 'Repos journalier';

  @override
  String guideDailyRestText(String reduced, String first, String second) {
    return 'Jusqu’à trois fois entre deux repos hebdomadaires, il peut être réduit à $reduced. Variante fractionnée — $first + $second.';
  }

  @override
  String get guideWorkday => 'Journée de travail';

  @override
  String guideWorkdayText(String window, String regular, String reduced) {
    return 'Le repos doit se terminer dans les $window suivant le début du poste : $regular avec un repos normal, $reduced avec un repos réduit.';
  }

  @override
  String guideWorkdaySpoken(int first, int second) {
    String _temp0 = intl.Intl.pluralLogic(
      second,
      locale: localeName,
      other: '$second heures',
      one: '$second heure',
    );
    return '$first ou $_temp0';
  }

  @override
  String get guideWeeklyRest => 'Repos hebdomadaire';

  @override
  String guideWeeklyRestText(String reduced) {
    return 'Réduit — $reduced, avec compensation avant la fin de la troisième semaine. Le repos normal ne peut pas être pris dans la cabine.';
  }

  @override
  String get guideWorkWeek => 'Semaine de travail';

  @override
  String guideWorkWeekText(String period) {
    return 'Le repos hebdomadaire commence au plus tard après six périodes de $period depuis le précédent.';
  }

  @override
  String get guideCard => 'Carte conducteur';

  @override
  String guideCardText(String days) {
    return 'Les données de la carte doivent être téléchargées au moins tous les $days.';
  }

  @override
  String get guideModes => 'Couleurs et icônes';

  @override
  String get guideNewbie => 'Premier tachygraphe';

  @override
  String get guideNewbieCard =>
      'La carte reste dans le tachygraphe tout le poste';

  @override
  String get guideNewbieCardText =>
      'Insérez la carte au début du poste et retirez-la à la fin. Ce que vous avez fait sans carte — travail, disponibilité ou repos — saisissez-le manuellement à la prochaine insertion.';

  @override
  String get guideNewbieApp => 'L’application ne remplace pas le tachygraphe';

  @override
  String get guideNewbieAppText =>
      'L’enregistrement officiel est dans le tachygraphe. Changez d’activité là-bas et ici — ainsi les compteurs concorderont.';

  @override
  String get guideNewbieBreak => 'La pause, c’est seulement du repos';

  @override
  String get guideNewbieBreakText =>
      'Pendant la pause, vous ne pouvez ni conduire ni travailler. Le chargement et le déchargement sont un autre travail, pas une pause.';

  @override
  String get guideNewbieRestPlace => 'Où se reposer';

  @override
  String get guideNewbieRestPlaceText =>
      'Le repos journalier et le repos hebdomadaire réduit peuvent être pris dans le véhicule s’il dispose d’une couchette et est à l’arrêt. Le repos hebdomadaire normal et la compensation — uniquement hors du véhicule.';

  @override
  String get guideNewbieCountry => 'Pays';

  @override
  String get guideNewbieCountryText =>
      'Le pays est saisi dans le tachygraphe au début et à la fin du poste. Le tachygraphe intelligent de deuxième génération enregistre seul le passage de frontière ; sur les plus anciens, le pays est saisi au premier arrêt après la frontière.';

  @override
  String guideVanText(String date) {
    return 'Les règles sont les mêmes que pour les camions. Depuis le $date, elles s’appliquent aux utilitaires de plus de 2,5 t remorque comprise — en transport international de marchandises et en cabotage. Un tel utilitaire a un tachygraphe intelligent de deuxième génération, le conducteur a une carte.';
  }

  @override
  String get guideVanCheck => 'Les règles s’appliquent-elles à votre trajet';

  @override
  String get guideVanTrip => 'Trajet';

  @override
  String get guideVanTripHint =>
      'Cabotage — transport à l’intérieur d’un autre pays de l’UE';

  @override
  String get guideVanDomestic => 'National';

  @override
  String get guideVanCrossBorder => 'À l’étranger ou cabotage';

  @override
  String get guideVanCarriage => 'Transport';

  @override
  String get guideVanHire => 'Pour compte d’autrui';

  @override
  String get guideVanOwn => 'Pour compte propre';

  @override
  String get guideVanNonCommercial => 'Non commercial';

  @override
  String get guideVanCarriageHint =>
      'Compte propre — marchandises, matériaux ou outils de votre entreprise. Non commercial — sans paiement ni revenu, sans lien avec le travail';

  @override
  String get guideVanMain => 'La conduite est-elle votre activité principale ?';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get guideVanApplies => 'Les règles s’appliquent';

  @override
  String get guideVanNotApply => 'Les règles ne s’appliquent pas';

  @override
  String get guideVanAppliesText =>
      'Un tachygraphe et une carte conducteur sont nécessaires, les limites sont celles d’un camion.';

  @override
  String guideVanNotYetText(String date) {
    return 'Avant le $date, les utilitaires n’étaient pas concernés par les règles.';
  }

  @override
  String get guideVanDomesticText =>
      'Le règlement de l’UE ne s’applique pas aux utilitaires en transport national. Vérifiez les règles de votre pays.';

  @override
  String get guideVanOwnText =>
      'Exception : transport pour vos propres besoins, et la conduite n’est pas votre activité principale.';

  @override
  String get guideVanNonCommercialText =>
      'Exception : transport sans paiement ni revenu, sans lien avec le travail.';

  @override
  String guideArticle(String article) {
    return 'Règlement 561/2006, art. $article';
  }

  @override
  String get guideVanNotes =>
      'Plus de 3,5 t avec la remorque — mêmes règles qu’un camion, y compris en national. Trajet en partie hors de l’UE — vers l’Ukraine, la Moldavie, la Turquie, les Balkans — renseignez-vous auprès du transporteur : il n’y a pas d’interprétation uniforme.';

  @override
  String get guideDisclaimer =>
      'TachoGo aide à planifier le temps, mais ne remplace pas le tachygraphe et n’est pas un conseil juridique. Texte officiel des règles — règlement (CE) nº 561/2006 et accord AETR.';

  @override
  String get moreAbout => 'À propos';

  @override
  String get moreDisclaimer =>
      'TachoGo aide à planifier les temps de conduite et de repos, mais ne remplace pas le tachygraphe et n’est pas un conseil juridique.';

  @override
  String get morePrivacy => 'Politique de confidentialité';

  @override
  String linkFailed(String url) {
    return 'Impossible d’ouvrir le navigateur. Adresse de la page : $url';
  }

  @override
  String get problemTitle => 'Signaler un problème';

  @override
  String get problemHint =>
      'Version bêta : le rapport est envoyé aux développeurs';

  @override
  String get problemText =>
      'Le rapport contient la version de l’application, le modèle du téléphone, les réglages, les autorisations, le planning des notifications et les entrées du journal des deux derniers jours. Il ne contient pas de coordonnées. Choisissez où l’envoyer — e-mail ou messagerie — et décrivez ce qui s’est passé.';

  @override
  String get problemSend => 'Envoyer';

  @override
  String get problemSubject => 'TachoGo — problème en version bêta';

  @override
  String get problemPrompt => 'Que s’est-il passé et quand (avec vos mots) :';

  @override
  String get problemFailed => 'Impossible d’ouvrir l’envoi. Réessayez.';

  @override
  String get transferTitle => 'Transférer vers un autre téléphone';

  @override
  String get transferHint => 'Journal en fichier par messagerie ou e-mail';

  @override
  String get transferText =>
      'Sur l’ancien téléphone, enregistrez le journal dans un fichier et envoyez-le-vous — par messagerie, e-mail ou dans le cloud. Sur le nouveau téléphone, ouvrez ce même écran et chargez le fichier : le journal, les téléchargements de carte et les réglages de calcul seront comme sur l’ancien.';

  @override
  String get transferSave => 'Enregistrer le journal dans un fichier';

  @override
  String get transferLoad => 'Charger le journal depuis un fichier';

  @override
  String get transferConfirmTitle => 'Charger le journal ?';

  @override
  String transferConfirmRange(String from, String to) {
    return 'Le fichier contient le journal du $from au $to.';
  }

  @override
  String get transferConfirmReplace =>
      'Le journal de ce téléphone sera remplacé par celui du fichier.';

  @override
  String get transferConfirm => 'Charger';

  @override
  String get transferDone => 'Journal chargé';

  @override
  String get transferEmpty => 'Le fichier ne contient aucune entrée de journal';

  @override
  String get transferNotBackup =>
      'Ce n’est pas un fichier de journal TachoGo — choisissez le fichier tachogo-journal';

  @override
  String get transferNewer =>
      'Le fichier provient d’une version plus récente de TachoGo — mettez l’application à jour';

  @override
  String get transferDamaged =>
      'Le fichier de journal est endommagé — enregistrez-le à nouveau sur l’ancien téléphone';

  @override
  String get transferFailed =>
      'Impossible de charger le journal. Le journal du téléphone n’a pas changé';

  @override
  String get transferSaveFailed =>
      'Impossible d’enregistrer le fichier. Réessayez.';

  @override
  String get rowCompensation => 'Compensation';

  @override
  String get compensationAttach => 'à rattacher à un repos d’au moins 9 h';

  @override
  String compensationRestUntil(String time) {
    return 'repos jusqu’à $time';
  }

  @override
  String get compensationTooLate => 'délai impossible à tenir';

  @override
  String get compensationTakenHere => 'rattachée à ce repos';

  @override
  String get chipCompensationDone => 'soldée';

  @override
  String get chipCompensationSoon => 'échéance proche';

  @override
  String get chipCompensationOverdue => 'en retard';

  @override
  String compensationDebt(String time) {
    return 'dette $time';
  }

  @override
  String compensationRepaidOn(String date) {
    return 'soldée le $date';
  }

  @override
  String compensationAttachBy(String date) {
    return 'à rattacher avant le $date';
  }

  @override
  String compensationTakenValue(String time) {
    return 'compensation $time';
  }

  @override
  String get notifyCompensationTakenTitle => 'Compensation prise';

  @override
  String notifyCompensationTakenText(String time) {
    return 'Ce repos couvre les $time dus pour un repos hebdomadaire réduit — la dette est soldée.';
  }
}
