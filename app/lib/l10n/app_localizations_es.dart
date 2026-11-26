// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'TachoGo';

  @override
  String get navHome => 'Inicio';

  @override
  String get navJournal => 'Registro';

  @override
  String get navSettings => 'Ajustes';

  @override
  String get navMore => 'Más';

  @override
  String get close => 'Cerrar';

  @override
  String get back => 'Atrás';

  @override
  String ofLimit(String limit) {
    return 'de $limit';
  }

  @override
  String get premiumLock => 'Disponible en Premium';

  @override
  String hoursShort(int hours) {
    return '$hours h';
  }

  @override
  String daysShort(int days) {
    return '$days d';
  }

  @override
  String spokenHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count horas',
      one: '$count hora',
    );
    return '$_temp0';
  }

  @override
  String spokenMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutos',
      one: '$count minuto',
    );
    return '$_temp0';
  }

  @override
  String spokenOverrun(String duration) {
    return 'exceso de $duration';
  }

  @override
  String get modeDriving => 'Conducción';

  @override
  String get modeRest => 'Descanso';

  @override
  String get modeWork => 'Trabajo';

  @override
  String get modeWorkFull => 'Otros trabajos';

  @override
  String get modeAvailability => 'Disponibilidad';

  @override
  String get modeNone => 'Ninguna actividad elegida';

  @override
  String modeSince(String time) {
    return 'desde las $time';
  }

  @override
  String get switchFailed => 'La actividad no cambió. Inténtelo de nuevo.';

  @override
  String homeShiftSince(String date, String time) {
    return '$date · jornada desde las $time';
  }

  @override
  String homeNoShift(String date) {
    return '$date · jornada no iniciada';
  }

  @override
  String get homeLoadError =>
      'No se pudo abrir el registro. Reinicie la aplicación; si no ayuda, escríbanos desde «Más».';

  @override
  String get heroUntilBreak => 'Hasta la pausa';

  @override
  String get heroBreak => 'Pausa';

  @override
  String get heroDailyRest => 'Descanso diario';

  @override
  String get heroWeeklyRest => 'Descanso semanal';

  @override
  String heroContinuousOf(String time, String limit) {
    return 'sin pausa $time de $limit';
  }

  @override
  String get heroOffDutyHint =>
      'Jornada terminada. La siguiente empezará con cualquier actividad salvo el descanso.';

  @override
  String get bannerBreakNeeded45 => 'Necesita una pausa de 45 min o 15 + 30';

  @override
  String get bannerBreakNeeded30 =>
      'Necesita la segunda parte de la pausa: 30 min';

  @override
  String bannerOnBreak(String time, int required) {
    return 'Pausa $time de $required min';
  }

  @override
  String bannerBreakCounted(String limit) {
    return 'Pausa cumplida — puede conducir $limit';
  }

  @override
  String get sectionAlerts => 'Avisos';

  @override
  String get sectionToday => 'Hoy';

  @override
  String get sectionRest => 'Descanso';

  @override
  String get sectionWeek => 'Semana';

  @override
  String get rowContinuous => 'Conducción sin pausa';

  @override
  String get chipBreakSoon => 'pausa pronto';

  @override
  String get chipExceeded => 'superado';

  @override
  String get chipLimiting => 'se acaba antes';

  @override
  String get chipShiftSoon => 'fin pronto';

  @override
  String get chipLimitSoon => 'límite pronto';

  @override
  String get chipRestSoon => 'descanso pronto';

  @override
  String chipTimes(int hours, int count) {
    return '$hours h ×$count';
  }

  @override
  String limitOf(String limit) {
    return 'límite $limit';
  }

  @override
  String leftUntil(String left, String time) {
    return 'quedan $left → $time';
  }

  @override
  String left(String left) {
    return 'quedan $left';
  }

  @override
  String limitLeft(int hours, String left) {
    return '$hours h: quedan $left';
  }

  @override
  String limitLeftUntil(int hours, String left, String time) {
    return '$hours h: quedan $left → $time';
  }

  @override
  String limitUntil(int hours, String time) {
    return '$hours h → $time';
  }

  @override
  String get rowWorkday => 'Jornada de trabajo';

  @override
  String get workdayNoShift => 'Jornada no iniciada';

  @override
  String workdayElapsed(String time) {
    return 'transcurrido $time';
  }

  @override
  String workdayLeftTo(int hours) {
    return 'quedan hasta $hours h';
  }

  @override
  String get rowDailyDriving => 'Conducción diaria';

  @override
  String get rowBreak => 'Pausa';

  @override
  String breakTaken(int minutes, String time) {
    return '$minutes min tomados a las $time';
  }

  @override
  String breakStillNeeded(int minutes) {
    return 'faltan $minutes min';
  }

  @override
  String get breakNotTaken => 'Aún no hay pausa';

  @override
  String breakResting(String time, int required) {
    return 'Pausa ahora $time de $required min';
  }

  @override
  String get rowDailyRest => 'Descanso diario';

  @override
  String get dailyRestCaption => '11 h normal · 9 h reducido';

  @override
  String get dailyRestSplit => '3 + 9';

  @override
  String get rowWeeklyRest => 'Descanso semanal';

  @override
  String get weeklyRestCaption => '45 h normal · 24 h reducido';

  @override
  String get chipReducedAvailable => '24 h posible';

  @override
  String get chipReducedUnavailable => 'solo 45 h';

  @override
  String get statusNotStarted => 'no iniciado';

  @override
  String statusInProgress(String time) {
    return 'en curso $time';
  }

  @override
  String statusBy(String when) {
    return 'antes de $when';
  }

  @override
  String get statusNoData => 'sin datos';

  @override
  String get rowWeeklyDriving => 'Conducción semanal';

  @override
  String get rowFortnightDriving => 'Conducción en dos semanas';

  @override
  String get rowWorkWeek => 'Semana de trabajo';

  @override
  String workWeekSince(String since) {
    return 'desde $since';
  }

  @override
  String get workWeekUnknown => 'No hay datos del descanso semanal anterior';

  @override
  String get workWeekRestEnd => 'Fin del descanso semanal';

  @override
  String workWeekDeadline(int hours) {
    return '$hours h — empezar el descanso semanal';
  }

  @override
  String get workWeekOnRest =>
      'Descanso semanal en curso: la nueva semana de trabajo empieza después.';

  @override
  String get workWeekShifts => 'Jornadas de la semana de trabajo';

  @override
  String get workWeekNoShifts =>
      'Aún no hay jornadas desde el descanso semanal';

  @override
  String get workWeekRule =>
      'Empiece el descanso semanal como muy tarde 144 h (6 días) después del final del anterior. Art. 8, apdo. 6, del Reglamento 561/2006.';

  @override
  String get cardTitle => 'Descarga de la tarjeta';

  @override
  String cardCaption(String last, String due) {
    return 'última $last · antes de $due';
  }

  @override
  String get cardNever => 'Indicar la última descarga';

  @override
  String cardSheetLast(String date) {
    return 'Última descarga: $date';
  }

  @override
  String get cardSheetNever => 'Todavía no se ha indicado ninguna descarga.';

  @override
  String get cardSheetRule =>
      'La tarjeta debe descargarse al menos cada 28 días. Reglamento (UE) n.º 581/2010.';

  @override
  String get cardMarkToday => 'Descargada hoy';

  @override
  String get cardMarked => 'Descarga indicada';

  @override
  String get workdayStart => 'Inicio de la jornada';

  @override
  String workdayRegular(int hours) {
    return '$hours h — jornada normal';
  }

  @override
  String workdayRegularHint(String left) {
    return 'después descanso normal de 11 h · quedan $left';
  }

  @override
  String workdayExtended(int hours) {
    return '$hours h — jornada ampliada';
  }

  @override
  String workdayExtendedHint(int count) {
    return 'después descanso reducido de 9 h · quedan ×$count';
  }

  @override
  String get workdayRule =>
      'El descanso debe terminar como muy tarde 24 h después del inicio de la jornada. Puede reducirlo a 9 h como máximo tres veces entre dos descansos semanales.';

  @override
  String get dailyRestOngoing => 'Descanso en curso';

  @override
  String get dailyRestStartBy => 'Empezar el descanso como muy tarde';

  @override
  String dailyRestReducedBy(int hours, String time) {
    return 'reducido $hours h — hasta las $time';
  }

  @override
  String get dailyRestOptions => 'Cuánto descansar';

  @override
  String dailyRestMilestone(int hours, String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'split': 'primera parte del descanso fraccionado',
      'reduced': 'reducido',
      'other': 'normal',
    });
    return '$hours h — $_temp0';
  }

  @override
  String get dailyRestReached => 'cumplido';

  @override
  String dailyRestLeftCount(String left, int count) {
    return 'quedan $left · quedan ×$count';
  }

  @override
  String get dailyRestNoReduced =>
      'no quedan reducciones hasta el descanso semanal';

  @override
  String get dailyRestSplitHint =>
      'después un descanso de al menos 9 h — en total al menos 12 h';

  @override
  String get dailyRestStartLatest => 'empezar como muy tarde';

  @override
  String dailyRestStartLatestCount(int count) {
    return 'empezar como muy tarde · quedan ×$count';
  }

  @override
  String get dailyRestInShift =>
      'Por debajo de 9 h es una pausa en la jornada; desde 9 h, descanso diario. ¿Ha terminado de trabajar? Pulse «Terminar el día».';

  @override
  String get dailyRestRule =>
      'Descanso normal: 11 h seguidas. Reducido: 9 h, hasta tres veces entre dos descansos semanales. Fraccionado: 3 + 9 h. El descanso debe terminar como muy tarde 24 h después del inicio de la jornada.';

  @override
  String get drivingCorrect => 'Corregir la conducción del día';

  @override
  String get drivingUsedUp => 'agotado';

  @override
  String drivingExtensionsLeft(int count) {
    return 'dos veces por semana · quedan ×$count';
  }

  @override
  String get drivingNoExtensions => 'ampliaciones de esta semana agotadas';

  @override
  String get drivingDailyRule =>
      'Entre dos descansos diarios: como máximo 9 h al volante, 10 h dos veces por semana. La semana empieza el lunes a las 00:00.';

  @override
  String drivingWeekSince(String date) {
    return 'semana desde el $date';
  }

  @override
  String drivingWeekLimit(int hours) {
    return '$hours h — por semana';
  }

  @override
  String drivingFortnightLimit(int hours) {
    return '$hours h — en dos semanas';
  }

  @override
  String drivingFortnightHint(String previous, String left) {
    return 'semana pasada $previous · quedan $left';
  }

  @override
  String drivingFortnightLimits(String left) {
    return 'El límite de dos semanas se agota antes: esta semana quedan $left.';
  }

  @override
  String get drivingWeekShifts => 'Jornadas de la semana';

  @override
  String get drivingNoShifts => 'Aún no hay jornadas esta semana';

  @override
  String get drivingWeekRule =>
      'Hasta 56 h de conducción por semana y 90 h en dos semanas seguidas. La semana va del lunes 00:00 al domingo 24:00.';

  @override
  String get drivingCanDrive => 'Aún puede conducir';

  @override
  String drivingStop(String stop) {
    String _temp0 = intl.Intl.selectLogic(stop, {
      'breakDue': 'hasta la pausa',
      'workday': 'hasta el final de la jornada',
      'daily': 'hasta el límite de conducción diaria',
      'weekly': 'hasta el límite semanal',
      'fortnight': 'hasta el límite de dos semanas',
      'other': 'hasta el límite',
    });
    return '$_temp0';
  }

  @override
  String drivingStopped(String stop) {
    String _temp0 = intl.Intl.selectLogic(stop, {
      'breakDue': 'pausa necesaria',
      'workday': 'la jornada ha terminado',
      'daily': 'conducción diaria agotada',
      'weekly': 'conducción semanal agotada',
      'fortnight': 'conducción de dos semanas agotada',
      'other': 'límite agotado',
    });
    return '$_temp0';
  }

  @override
  String get drivingContinuousNow => 'Al volante sin pausa';

  @override
  String drivingBreakDue(String time) {
    return '$time — pausa obligatoria';
  }

  @override
  String get drivingThisShift => 'En esta jornada';

  @override
  String get drivingThisWeek => 'Esta semana';

  @override
  String get workdayEndDay => 'Terminar el día';

  @override
  String get workdayEndDayHint =>
      'El descanso empieza ahora y cierra la jornada, aunque dure menos de 9 h.';

  @override
  String get endDayDriving => 'Conducción del día';

  @override
  String get endDayDrivingHint =>
      '¿Cuánto tiempo condujo hoy en total? Basta con el total.';

  @override
  String todayDate(String date) {
    return 'Hoy, $date';
  }

  @override
  String infrArticle(String regulation, String article) {
    return 'UE $regulation · art. $article';
  }

  @override
  String get infrContinuousExceededTitle => 'Conducción sin pausa superada';

  @override
  String infrContinuousExceededText(String limit, String time, int required) {
    return 'Conducción sin pausa superior a $limit en $time. Deténgase y haga una pausa de $required min.';
  }

  @override
  String get infrBreakSoonTitle => 'Pausa pronto';

  @override
  String infrBreakSoonText(String limit, String time, int required) {
    return 'Quedan $time hasta el límite de $limit. Se necesita una pausa de $required min.';
  }

  @override
  String get infrDailyDriveExceededTitle => 'Conducción diaria superada';

  @override
  String infrDailyDriveExceededText(String limit, String time) {
    return 'Más de $limit en $time. Empiece el descanso diario.';
  }

  @override
  String get infrDailyDriveSoonTitle => 'Se acaba la conducción diaria';

  @override
  String infrDailyDriveSoonText(String limit, String time) {
    return 'Quedan $time hasta el límite de $limit.';
  }

  @override
  String get infrExtensionInUseTitle => 'Ampliación a 10 h en curso';

  @override
  String infrExtensionInUseText(int count) {
    return 'Ampliaciones restantes esta semana: $count.';
  }

  @override
  String get infrShiftExceededTitle => 'Jornada de trabajo superada';

  @override
  String infrShiftExceededText(String limit, String time) {
    return 'Jornada superior a $limit en $time. Empiece el descanso diario.';
  }

  @override
  String get infrShiftSoonTitle => 'Pronto termina la jornada';

  @override
  String infrShiftSoonText(String time) {
    return 'Empiece el descanso diario como máximo dentro de $time.';
  }

  @override
  String get infrWeeklyDriveExceededTitle => 'Conducción semanal superada';

  @override
  String infrWeeklyDriveExceededText(String limit, String time) {
    return 'Más de $limit en $time.';
  }

  @override
  String get infrWeeklyDriveSoonTitle => 'Se acaba la conducción semanal';

  @override
  String infrWeeklyDriveSoonText(String limit, String time) {
    return 'Quedan $time hasta $limit.';
  }

  @override
  String get infrFortnightDriveExceededTitle =>
      'Conducción en dos semanas superada';

  @override
  String infrFortnightDriveExceededText(String limit, String time) {
    return 'Más de $limit en $time.';
  }

  @override
  String get infrFortnightDriveSoonTitle =>
      'Se acaba la conducción en dos semanas';

  @override
  String infrFortnightDriveSoonText(String limit, String time) {
    return 'Quedan $time hasta $limit.';
  }

  @override
  String get infrWeeklyRestOverdueTitle => 'Descanso semanal atrasado';

  @override
  String infrWeeklyRestOverdueText(String time) {
    return 'Han pasado más de 144 h desde el descanso semanal anterior, en $time.';
  }

  @override
  String get infrWeeklyRestSoonTitle => 'Descanso semanal pronto';

  @override
  String infrWeeklyRestSoonText(String time) {
    return 'Empiece el descanso semanal como máximo dentro de $time.';
  }

  @override
  String get infrWeeklyRestContinueTitle => 'No interrumpa el descanso';

  @override
  String infrWeeklyRestContinueText(String time) {
    return 'El plazo del descanso semanal ha vencido. Descanse $time más para que cuente como descanso semanal.';
  }

  @override
  String get infrCompensationSoonTitle => 'Plazo de compensación próximo';

  @override
  String infrCompensationSoonText(String time, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days días',
      one: '$days día',
    );
    return 'Añada $time a un descanso de al menos 9 h. Plazo: $_temp0.';
  }

  @override
  String get infrCompensationOverdueTitle => 'Compensación atrasada';

  @override
  String infrCompensationOverdueText(String time, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days días',
      one: '$days día',
    );
    return 'No se tomó la compensación de $time por el descanso semanal reducido. Retraso: $_temp0.';
  }

  @override
  String get infrReducedRestsExceededTitle => 'Demasiados descansos reducidos';

  @override
  String infrReducedRestsExceededText(int count) {
    return 'Descansos reducidos desde el semanal: $count, y se permiten 3.';
  }

  @override
  String get infrReducedWeeklyRestWithoutRightTitle =>
      'Este descanso no se podía reducir';

  @override
  String infrReducedWeeklyRestWithoutRightText(String time) {
    return 'El último descanso semanal tenía que ser normal: 45 h. Faltaron $time.';
  }

  @override
  String get infrFullWeeklyRestRequiredTitle =>
      'Hace falta descanso semanal normal';

  @override
  String infrFullWeeklyRestRequiredText(String time) {
    return 'Esta vez no se puede reducir: descanse las 45 h completas. Quedan $time.';
  }

  @override
  String get infrCardOverdueTitle => 'Descarga de la tarjeta atrasada';

  @override
  String infrCardOverdueText(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days días',
      one: '$days día',
    );
    return 'El plazo de 28 días venció hace $_temp0.';
  }

  @override
  String get infrCardSoonTitle => 'Descarga de la tarjeta pronto';

  @override
  String infrCardSoonText(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days días',
      one: '$days día',
    );
    return 'Quedan $_temp0.';
  }

  @override
  String get ferryTitle => 'Ferry / tren';

  @override
  String get ferryHint =>
      'El descanso puede interrumpirse hasta dos veces, 1 h en total como máximo (art. 9). Mientras el ferry navega, la conducción no se activa sola.';

  @override
  String get ferryOn => 'ferry';

  @override
  String breakHero(String limit) {
    return 'Pausa tras $limit de conducción';
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
    return '$minutes min — pendiente';
  }

  @override
  String breakFirstTaken(String from, String to) {
    return 'Primera parte tomada $from–$to';
  }

  @override
  String get breakNone =>
      'Se necesita una pausa de 45 min seguidos o de 15 + 30 min.';

  @override
  String get breakSplitTitle => 'Pausa dividida 15 + 30';

  @override
  String get breakSplitText =>
      'Primero al menos 15 min, luego al menos 30 min, solo en este orden. Las dos partes se cuentan solas.';

  @override
  String get breakStart => 'Empezar pausa';

  @override
  String get breakOngoing => 'Pausa en curso';

  @override
  String get weeklyStartBy => 'Empezar como muy tarde';

  @override
  String weeklyInTime(String left) {
    return 'dentro de $left — fin de la semana de trabajo (144 h)';
  }

  @override
  String weeklyOverdue(String time) {
    return 'retraso $time';
  }

  @override
  String get weeklyOngoing => 'Descanso semanal en curso';

  @override
  String get weeklyUnknown =>
      'No hay datos del descanso semanal anterior. El plazo aparecerá tras un descanso de 24 h o más.';

  @override
  String get weeklyNext => 'Próximo descanso';

  @override
  String get weeklyFull => 'Normal';

  @override
  String get weeklyFullHint => 'no en la cabina';

  @override
  String get weeklyReduced => 'Reducido';

  @override
  String get weeklyReducedYes => 'posible · con compensación';

  @override
  String get weeklyReducedNo => 'no posible — hace falta normal';

  @override
  String get weeklyHistory => 'Historial';

  @override
  String weeklyPrevious(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'full': 'normal',
      'reduced': 'reducido',
      'other': 'insuficiente',
    });
    return 'Anterior · $_temp0';
  }

  @override
  String get weeklyNow => 'ahora';

  @override
  String get weeklyCompensation => 'Compensación pendiente';

  @override
  String get weeklyCompensationNone => 'ninguna';

  @override
  String weeklyCompensationValue(String time, String date) {
    return '$time antes del $date';
  }

  @override
  String weeklyCompensationFor(String date) {
    return 'por el descanso del $date';
  }

  @override
  String weeklyTwoReducedNote(String debt, String total) {
    return 'Dos reducidos seguidos generan una sola deuda de $debt. Se toma de una vez, justo antes del siguiente descanso semanal: en total, $total de descanso seguido.';
  }

  @override
  String weeklyCompensationForTwo(String first, String second) {
    return 'por los descansos del $first y del $second';
  }

  @override
  String compensationTogetherWith(String date) {
    return 'junto con el descanso del $date';
  }

  @override
  String get weeklyMobilityOn =>
      'Paquete de movilidad: en transporte internacional puede tomar dos descansos semanales reducidos seguidos si ambos son fuera del país de la empresa. La compensación se toma antes del final de la tercera semana.';

  @override
  String get weeklyMobilityOff =>
      'La compensación de un descanso semanal reducido se añade a un descanso de al menos 9 h antes del final de la tercera semana.';

  @override
  String get weeklyStartRest => 'Empezar descanso';

  @override
  String get countryTitle => 'Elegir país';

  @override
  String countryChip(String start, String end) {
    return 'País de inicio $start, de fin $end. Cambiar';
  }

  @override
  String countryChipNoEnd(String start) {
    return 'País de inicio $start, de fin sin elegir. Cambiar';
  }

  @override
  String get countryChipNone => 'No se ha elegido país de la jornada. Elegir';

  @override
  String countryStartTab(String code) {
    return 'Inicio · $code';
  }

  @override
  String countryEndTab(String code) {
    return 'Fin · $code';
  }

  @override
  String get countryNextShift => 'País de la próxima jornada';

  @override
  String get countrySearch => 'País o código';

  @override
  String get countryFrequent => 'Usados con frecuencia';

  @override
  String get countryClearEnd => 'No indicar';

  @override
  String get countryNotFound => 'No se encontró nada';

  @override
  String get countryFooter =>
      'El conductor introduce en el tacógrafo el país de inicio y de fin de la jornada (Reglamento (UE) n.º 165/2014, art. 34).';

  @override
  String countryName(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'A': 'Austria',
      'AL': 'Albania',
      'AND': 'Andorra',
      'ARM': 'Armenia',
      'AZ': 'Azerbaiyán',
      'B': 'Bélgica',
      'BG': 'Bulgaria',
      'BIH': 'Bosnia y Herzegovina',
      'BY': 'Bielorrusia',
      'CH': 'Suiza',
      'CY': 'Chipre',
      'CZ': 'Chequia',
      'D': 'Alemania',
      'DK': 'Dinamarca',
      'E': 'España',
      'EST': 'Estonia',
      'F': 'Francia',
      'FIN': 'Finlandia',
      'FL': 'Liechtenstein',
      'GE': 'Georgia',
      'GR': 'Grecia',
      'H': 'Hungría',
      'HR': 'Croacia',
      'I': 'Italia',
      'IRL': 'Irlanda',
      'IS': 'Islandia',
      'KZ': 'Kazajistán',
      'L': 'Luxemburgo',
      'LT': 'Lituania',
      'LV': 'Letonia',
      'M': 'Malta',
      'MC': 'Mónaco',
      'MD': 'Moldavia',
      'MK': 'Macedonia del Norte',
      'MNE': 'Montenegro',
      'N': 'Noruega',
      'NL': 'Países Bajos',
      'P': 'Portugal',
      'PL': 'Polonia',
      'RO': 'Rumanía',
      'RSM': 'San Marino',
      'RUS': 'Rusia',
      'S': 'Suecia',
      'SK': 'Eslovaquia',
      'SLO': 'Eslovenia',
      'SRB': 'Serbia',
      'TJ': 'Tayikistán',
      'TM': 'Turkmenistán',
      'TR': 'Turquía',
      'UA': 'Ucrania',
      'UK': 'Reino Unido',
      'UZ': 'Uzbekistán',
      'V': 'Ciudad del Vaticano',
      'other': '$code',
    });
    return '$_temp0';
  }

  @override
  String get journalExport => 'Exportar informe';

  @override
  String get journalCurrent => 'actual';

  @override
  String get journalDriving => 'Conducción';

  @override
  String get journalFortnight => 'En 2 sem.';

  @override
  String journalOf(int limit) {
    return 'de $limit';
  }

  @override
  String get journalCollapsedDriving => 'conducción';

  @override
  String journalWeekSpoken(String range, String driving, String fortnight) {
    return 'Semana $range. Conducción $driving de 56 h, en dos semanas $fortnight de 90 h';
  }

  @override
  String get journalShift => 'Jornada';

  @override
  String get journalWeeklyShort => 'sem.';

  @override
  String get journalOngoing => 'en curso';

  @override
  String get journalManual => 'manual';

  @override
  String get journalAddShift => 'Jornada';

  @override
  String get journalAddShiftSpoken => 'Añadir jornada';

  @override
  String get journalEmpty =>
      'Todavía no hay jornadas. Cambie de actividad en la pantalla de inicio o añada una jornada a mano.';

  @override
  String restStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'full': 'normal',
      'reduced': 'reducido',
      'other': 'insuficiente',
    });
    return '$_temp0';
  }

  @override
  String journalWeeklyRest(String status) {
    return 'Descanso semanal · $status';
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
    return '$date, $route, $time. Conducción $driving, jornada $span, descanso $rest';
  }

  @override
  String get journalRestNone => 'ninguno';

  @override
  String get journalRestWeekly => 'semanal';

  @override
  String get journalLoadError =>
      'No se pudo abrir el registro. Reinicie la aplicación; si no ayuda, escríbanos desde «Más».';

  @override
  String get dayTitle => 'Jornada';

  @override
  String get daySummary => 'Resumen';

  @override
  String get dayBreaks => 'Pausas';

  @override
  String get dayContinuousAtEnd => 'Sin pausa al final de la jornada';

  @override
  String get dayRestAfter => 'Descanso tras la jornada';

  @override
  String dayRestKind(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'daily': 'Diario',
      'weekly': 'Semanal',
      'other': 'No iniciado',
    });
    return '$_temp0';
  }

  @override
  String get daySplitRest => 'dividido 3 + 9';

  @override
  String get dayNotes => 'Notas';

  @override
  String get dayEdit => 'Editar jornada';

  @override
  String get dayNotFound => 'Esta jornada ya no está en el registro.';

  @override
  String dayRestUntil(String time) {
    return 'hasta $time';
  }

  @override
  String get save => 'Guardar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get done => 'Listo';

  @override
  String get delete => 'Eliminar';

  @override
  String get unitHours => 'h';

  @override
  String get unitMinutes => 'min';

  @override
  String get pickerHours => 'Horas';

  @override
  String get pickerMinutes => 'Minutos';

  @override
  String get pickerTime => 'Hora';

  @override
  String get pickerPrevMonth => 'Mes anterior';

  @override
  String get pickerNextMonth => 'Mes siguiente';

  @override
  String pickerRange(String min, String max) {
    return 'Posible de $min a $max';
  }

  @override
  String get shiftNewTitle => 'Nueva jornada';

  @override
  String get shiftSection => 'Jornada';

  @override
  String get shiftStart => 'Inicio';

  @override
  String get shiftEnd => 'Fin';

  @override
  String get shiftOnRoad => 'en ruta';

  @override
  String get shiftChoose => 'Elegir';

  @override
  String get shiftNowOngoing => 'Ahora (en curso)';

  @override
  String get shiftDuration => 'Duración';

  @override
  String get shiftNowSuffix => 'ahora';

  @override
  String shiftCountrySpoken(String side, String code) {
    return '$side: país $code. Cambiar';
  }

  @override
  String shiftDateSpoken(String side, String date, String time) {
    return '$side: $date, $time. Cambiar';
  }

  @override
  String get shiftDriving => 'Conducción';

  @override
  String get shiftPerDay => 'Por día';

  @override
  String get shiftLiveContinuous => 'calculada por las pausas';

  @override
  String get shiftDrivingAfterRest =>
      'elija primero el descanso tras la jornada';

  @override
  String get shiftRestNone => 'No iniciado';

  @override
  String get shiftRestDaily => 'Diario';

  @override
  String get shiftRestWeekly => 'Semanal';

  @override
  String get shiftSplit => 'Descanso dividido 3 + 9';

  @override
  String get shiftSplitHint => 'Primero 3 h, luego 9 h';

  @override
  String shiftRestUntilNext(String when) {
    return 'Hasta el inicio de la jornada: $when';
  }

  @override
  String get shiftRestAutoHint =>
      'Dura hasta el inicio de la jornada siguiente';

  @override
  String get shiftRestCountsWeekly =>
      'Desde 24 h el descanso cuenta como semanal';

  @override
  String get shiftNotesHint => 'Por ejemplo: ferry, espera de carga';

  @override
  String get shiftDelete => 'Eliminar jornada';

  @override
  String get shiftDeleteTitle => '¿Eliminar la jornada?';

  @override
  String get shiftDeleteManual => 'La jornada se eliminará del registro.';

  @override
  String get shiftDeleteRecorded =>
      'Se borrarán todas las actividades de esta jornada. No se podrán recuperar.';

  @override
  String get shiftErrStartCountry => 'Elija el país de inicio de la jornada';

  @override
  String get shiftErrEndCountry => 'Indique el país de fin de la jornada';

  @override
  String get shiftErrEndBeforeStart =>
      'El fin de la jornada es anterior al inicio';

  @override
  String get shiftErrFuture =>
      'La hora de la jornada no puede estar en el futuro';

  @override
  String get shiftErrTooLong => 'Jornada de más de 30 h: revise las fechas';

  @override
  String get shiftErrDrivingTooLong => 'Conducción más larga que la jornada';

  @override
  String get shiftErrContinuous =>
      'Conducción sin pausa más larga que la diaria';

  @override
  String shiftErrOverlap(String range) {
    return 'Se solapa con la jornada $range';
  }

  @override
  String get shiftErrNotLast =>
      'Después de esta jornada ya hay otras: elija el descanso posterior';

  @override
  String get shiftSaveFailed => 'No se pudo guardar. Inténtelo de nuevo.';

  @override
  String get shiftSavedViolations => 'Jornada guardada. Hay infracciones';

  @override
  String get shiftSavedViolationsText =>
      'Revise las horas. Si todo es correcto, las infracciones aparecerán en el registro y en el informe.';

  @override
  String get gotIt => 'Entendido';

  @override
  String get shiftLiveHint =>
      'Esta jornada se compone de sus actividades. Cambie el inicio, el fin o la conducción y las actividades se moverán.';

  @override
  String get shiftConvertHint =>
      'Ha cambiado la hora, la conducción o el descanso: la jornada se guardará como totales, sin actividades con hora.';

  @override
  String get shiftLiveConvertHint =>
      'Conducción introducida como total: la jornada se guardará sin actividades con hora. El descanso posterior continúa.';

  @override
  String shiftEndNowHint(String time) {
    return 'La jornada terminará a las $time, luego empezará el descanso.';
  }

  @override
  String get shiftResumeHint =>
      'El descanso tras la jornada se eliminará y la jornada continuará.';

  @override
  String shiftOngoingHint(String time, String mode) {
    return 'La jornada pasa a ser la actual desde las $time, actividad «$mode». Si ahora está en otra, cámbiela en la pantalla de inicio.';
  }

  @override
  String get shiftUnsavedTitle => '¿Guardar los cambios?';

  @override
  String get shiftUnsavedText => 'Sin guardar, los cambios se perderán.';

  @override
  String get shiftDiscard => 'No guardar';

  @override
  String get shiftDateTimeTitle => 'Fecha y hora de la jornada';

  @override
  String driveEditSubtitle(String date) {
    return 'Corrección · $date';
  }

  @override
  String get driveEditComputed => 'Calculado a partir de las actividades';

  @override
  String driveEditDiff(String diff) {
    return '$diff respecto al cálculo.';
  }

  @override
  String get driveEditNoChange => 'Tiempo sin cambios.';

  @override
  String get driveEditHint =>
      '¿Cambió la actividad a destiempo? Corríjalo aquí: los límites se recalcularán.';

  @override
  String get driveEditNoDrive =>
      'Aún no hubo conducción en esta jornada: nada que corregir.';

  @override
  String get breakCorrection => 'Corrección';

  @override
  String get breakCurrentDuration => 'Pausa actual';

  @override
  String get breakLastDuration => 'Última pausa';

  @override
  String get breakNoBreak =>
      'Aún no hubo pausa en esta jornada: nada que corregir.';

  @override
  String get breakEditHint =>
      'La actividad vecina asume la diferencia; los límites se recalculan.';

  @override
  String get workdayChangeStart => 'Cambiar el inicio de la jornada';

  @override
  String get weeklyAddManually => 'Indicar a mano';

  @override
  String get exportPeriod => 'Periodo';

  @override
  String get exportWeek => 'Esta semana';

  @override
  String get exportTwoWeeks => '2 semanas';

  @override
  String get exportDays28 => '28 días';

  @override
  String get exportDays56 => '56 días';

  @override
  String get exportCustom => 'Periodo propio';

  @override
  String get exportFrom => 'Desde';

  @override
  String get exportTo => 'Hasta';

  @override
  String exportFromDay(String date) {
    return 'Desde $date';
  }

  @override
  String exportToDay(String date) {
    return 'Hasta $date';
  }

  @override
  String get exportFormat => 'Formato';

  @override
  String get exportPdf => 'PDF';

  @override
  String get exportCsv => 'CSV · tabla';

  @override
  String get exportPdfHint =>
      'El informe no sustituye los datos del tacógrafo ni de la tarjeta del conductor.';

  @override
  String get exportCsvHint =>
      'Registros de actividades por filas, hora en UTC: para Excel y programas de gestión.';

  @override
  String get exportLanguage => 'Idioma del informe';

  @override
  String get exportNotes => 'Países y notas';

  @override
  String get exportCreate => 'Crear informe';

  @override
  String exportCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jornadas',
      one: '$count jornada',
    );
    return '$_temp0 en el informe';
  }

  @override
  String get exportEmpty => 'No hay jornadas en el periodo elegido.';

  @override
  String get exportFailed => 'No se pudo crear el informe. Inténtelo de nuevo.';

  @override
  String exportRangeSpoken(String from, String to) {
    return 'Periodo del $from al $to';
  }

  @override
  String get reportTitle => 'Informe de tiempos de conducción y descanso';

  @override
  String get reportSubtitle => 'Reglamento (CE) n.º 561/2006 y Acuerdo AETR';

  @override
  String get reportDriver => 'Conductor';

  @override
  String get reportCard => 'Tarjeta del conductor';

  @override
  String get reportVehicle => 'Matrícula';

  @override
  String get reportCompany => 'Transportista';

  @override
  String get reportPeriod => 'Periodo';

  @override
  String get reportGenerated => 'Creado';

  @override
  String reportTimezone(String zone) {
    return 'Horas según la zona horaria del teléfono ($zone). Días y semanas del informe en UTC, la semana empieza el lunes a las 00:00, como en el tacógrafo.';
  }

  @override
  String get reportDate => 'Fecha';

  @override
  String get reportStart => 'Inicio';

  @override
  String get reportEnd => 'Fin';

  @override
  String get reportCountries => 'Países';

  @override
  String get reportDriving => 'Conducción';

  @override
  String get reportWork => 'Trabajo';

  @override
  String get reportAvailability => 'Disp.';

  @override
  String get reportBreaks => 'Pausas';

  @override
  String get reportSpan => 'Jornada';

  @override
  String get reportRestAfter => 'Descanso tras';

  @override
  String get reportNotes => 'Notas';

  @override
  String reportWeek(String range) {
    return 'Semana $range';
  }

  @override
  String reportWeekTotal(String driving, String fortnight) {
    return 'Total: conducción $driving de 56 h · en 2 semanas $fortnight de 90 h';
  }

  @override
  String get reportViolations => 'Infracciones';

  @override
  String get reportNoViolations => 'Según el registro no hay infracciones.';

  @override
  String reportViolationDrive(String date, String time) {
    return '$date: conducción diaria $time — más de 10 h';
  }

  @override
  String reportViolationSpan(String date, String time, int limit) {
    return '$date: jornada de trabajo $time — más de $limit h';
  }

  @override
  String reportViolationRest(String date, String time) {
    return '$date: descanso tras la jornada $time — insuficiente';
  }

  @override
  String reportViolationWeek(String range, String time) {
    return 'Semana $range: conducción $time — más de 56 h';
  }

  @override
  String reportViolationFortnight(String range, String time) {
    return 'Semana $range: en dos semanas $time — más de 90 h';
  }

  @override
  String get reportMarks => 'Signos';

  @override
  String get reportMarkWarn =>
      '! — conducción ampliada a 10 h, jornada de más de 13 h o descanso reducido';

  @override
  String get reportMarkBad => '!! — infracción';

  @override
  String get reportMarkManual => '* — jornada introducida a mano como totales';

  @override
  String get reportDisclaimer =>
      'El informe se basa en las anotaciones del conductor en la aplicación TachoGo. No es un documento oficial: no sustituye los datos del tacógrafo ni de la tarjeta del conductor.';

  @override
  String get reportSignature => 'Firma del conductor';

  @override
  String reportPage(int page, int pages) {
    return 'Página $page de $pages';
  }

  @override
  String get openSystemSettings => 'Abrir ajustes';

  @override
  String get settingsGeneral => 'General';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsLanguageSystem => 'Como en el teléfono';

  @override
  String get settingsTheme => 'Apariencia';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get settingsRules => 'Normas';

  @override
  String get settingsTachograph => 'Tacógrafo del vehículo';

  @override
  String get tachographDigital => 'Digital';

  @override
  String get tachographAnalog => 'Analógico';

  @override
  String get settingsMobility => 'Paquete de movilidad';

  @override
  String get settingsMobilityHint =>
      'Dos descansos semanales reducidos seguidos en transporte internacional';

  @override
  String get settingsCrew => 'Conducción en equipo';

  @override
  String get settingsCrewHint =>
      'Descanso diario de 9 h dentro de las 30 h desde el inicio de la jornada';

  @override
  String get settingsNotifications => 'Notificaciones';

  @override
  String get settingsWarnLead => 'Avisar de los límites';

  @override
  String get settingsWarnLeadHint => 'Pausa, fin del día, conducción';

  @override
  String get settingsWarnLeadGroup => 'Avisar con antelación';

  @override
  String leadMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String leadHours(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours horas',
      one: '$hours hora',
    );
    return '$_temp0';
  }

  @override
  String get notifyBreak => 'Pausa';

  @override
  String get notifyShiftEnd => 'Fin de la jornada de trabajo';

  @override
  String get notifyShiftEndHint => 'Descanso diario y semanal';

  @override
  String get notifyDriving => 'Límite de conducción';

  @override
  String get notifyCard => 'Descarga de la tarjeta';

  @override
  String get notifyCardHint => 'Cada 28 días';

  @override
  String get notifyCardLead => 'Con antelación';

  @override
  String get notifyCardLeadGroup =>
      'Aviso de descarga de la tarjeta con antelación';

  @override
  String leadDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days días',
      one: '$days día',
    );
    return '$_temp0';
  }

  @override
  String get notifyAllow => 'Permitir notificaciones';

  @override
  String get notifyDenied =>
      'Las notificaciones están desactivadas en los ajustes del teléfono';

  @override
  String get notifyAllowed => 'Notificaciones permitidas';

  @override
  String get notifyChannelLimits => 'Límites e infracciones';

  @override
  String get notifyChannelLimitsHint =>
      'Pausa, fin de la jornada, conducción, descanso semanal, tarjeta';

  @override
  String get notifyChannelRest => 'Descanso cumplido';

  @override
  String get notifyChannelRestHint =>
      'Pausa cumplida, descanso diario y semanal cumplidos';

  @override
  String get notifyBreakTakenTitle => 'Pausa cumplida';

  @override
  String notifyBreakTakenText(int required, String time) {
    return '$required min cumplidos: puede conducir $time más.';
  }

  @override
  String get notifyDailyRestTakenTitle => 'Descanso diario cumplido';

  @override
  String notifyDailyRestTakenText(String limit) {
    return 'Descanso normal de $limit: puede empezar la jornada.';
  }

  @override
  String get notifyWeeklyRestTakenTitle => 'Descanso semanal cumplido';

  @override
  String notifyWeeklyRestTakenText(String limit) {
    return 'Descanso normal de $limit: puede empezar una nueva semana de trabajo.';
  }

  @override
  String get serviceChannel => 'Detección automática de la conducción';

  @override
  String get serviceChannelHint =>
      'Actividad actual y contadores mientras funciona la detección automática';

  @override
  String get serviceStarted => 'Detección automática de la conducción activada';

  @override
  String serviceModeTitle(String mode, String time) {
    return '$mode · $time';
  }

  @override
  String get serviceTeamTitle => 'El vehículo está en marcha';

  @override
  String serviceTeamText(String time) {
    return '¿Conduce usted? Conducción desde las $time';
  }

  @override
  String get serviceSuggestTitle => 'Parece que está conduciendo';

  @override
  String serviceSuggestText(String time) {
    return '¿Activar la conducción desde las $time? El descanso se interrumpirá';
  }

  @override
  String serviceDriving(String untilBreak, String dayLeft) {
    return 'Hasta la pausa $untilBreak · quedan hoy $dayLeft';
  }

  @override
  String serviceDrivingOver(String time) {
    return 'Se necesita pausa: exceso de $time';
  }

  @override
  String serviceBreakLeft(String time) {
    return 'Hasta la pausa completa $time';
  }

  @override
  String serviceBreakDone(String time) {
    return 'Pausa cumplida, puede conducir $time';
  }

  @override
  String serviceWorkday(String time, String limit) {
    return 'Jornada $time de $limit';
  }

  @override
  String serviceRestLeft(String limit, String time) {
    return 'Hasta el descanso completo de $limit: $time';
  }

  @override
  String get serviceDailyRestDone => 'Descanso diario normal cumplido';

  @override
  String get serviceWeeklyRestDone => 'Descanso semanal normal cumplido';

  @override
  String get serviceNotStartedText =>
      'La conducción se activará sola cuando el vehículo arranque';

  @override
  String get serviceNoModeText => 'Abra TachoGo y elija una actividad';

  @override
  String get autoTitle => 'Detección automática de la conducción';

  @override
  String get autoSwitch => 'Detectar la conducción por GPS';

  @override
  String get autoSwitchHint =>
      'Arranca: conducción; para: otros trabajos. Solo se necesita la velocidad: las coordenadas no se guardan.';

  @override
  String get autoAfterStop => 'Tras detenerse';

  @override
  String get autoAfterStopHint => 'Tras 3 minutos parado';

  @override
  String get autoStartFromRest => 'Conducción justo después del descanso';

  @override
  String get autoStartFromRestHint =>
      'Si no, preguntaremos primero: quizá vaya de pasajero';

  @override
  String get autoBattery => 'Ahorro de batería';

  @override
  String get autoBatteryLimited =>
      'Puede detener la detección. Quite TachoGo de la lista de ahorro';

  @override
  String get autoBatteryOk => 'No impide el funcionamiento en segundo plano';

  @override
  String get autoAutostart => 'Inicio automático y segundo plano';

  @override
  String get autoAutostartHint =>
      'Xiaomi, Huawei, Honor, Oppo, Vivo, Samsung: permítalo; si no, el teléfono detendrá la detección';

  @override
  String get autoBlockedService =>
      'La ubicación está desactivada en el teléfono. Actívela para detectar la conducción.';

  @override
  String get autoBlockedDenied =>
      'Sin acceso a la ubicación no se puede detectar la conducción. Solo se necesita la velocidad: las coordenadas no se guardan.';

  @override
  String get autoBlockedForever =>
      'El acceso a la ubicación está bloqueado. Permítalo en los ajustes del teléfono: Ubicación → «Mientras se usa la aplicación».';

  @override
  String get autoNoAccess =>
      'Sin acceso a la ubicación: la detección no funciona. Permítalo en los ajustes del teléfono.';

  @override
  String get autoEnable => 'Activar la detección de la conducción';

  @override
  String get autoEnabled => 'Detección de la conducción activada';

  @override
  String get settingsData => 'Datos';

  @override
  String get settingsExport => 'Exportar informe';

  @override
  String get settingsExportFormats => 'PDF · CSV';

  @override
  String get settingsAnalytics => 'Estadísticas anónimas';

  @override
  String get settingsAnalyticsHint =>
      'Qué pantallas abren los conductores, para mejorar la aplicación. Sin coordenadas, nombres ni números de tarjeta.';

  @override
  String get settingsClear => 'Borrar todos los datos';

  @override
  String get clearTitle => '¿Borrar todos los datos?';

  @override
  String get clearText =>
      'Se borrarán el registro de actividades, las jornadas, los países, las notas y las descargas de la tarjeta. No se podrán recuperar. Los ajustes se conservarán.';

  @override
  String get clearConfirm => 'Borrar';

  @override
  String get clearDone => 'Datos eliminados';

  @override
  String onbStep(int step, int count) {
    return 'Paso $step de $count';
  }

  @override
  String get onbWelcomeTitle => 'Sepa cuánto puede conducir todavía';

  @override
  String get onbWelcomeText =>
      'Calculamos la conducción, las pausas y el descanso según las normas UE 561/2006 y AETR y avisamos de los límites con antelación.';

  @override
  String get onbStart => 'Empezar';

  @override
  String get onbNext => 'Siguiente';

  @override
  String get onbDone => 'Listo';

  @override
  String get onbModesTitle => 'Cuatro actividades, como en el tacógrafo';

  @override
  String get onbModesText =>
      'Cambie la actividad con los botones de la pantalla de inicio. Los contadores funcionan solos, incluso con la aplicación cerrada.';

  @override
  String get onbModeDriving => 'El vehículo se mueve y usted conduce.';

  @override
  String get onbModeWork => 'Carga, revisión del vehículo, documentos.';

  @override
  String get onbModeAvailability =>
      'Espera: cola de carga, frontera, segundo conductor al volante.';

  @override
  String get onbModeRest =>
      'Pausas y descanso. Al final de la jornada: «Terminar el día».';

  @override
  String get onbSetupTitle => 'Un par de ajustes';

  @override
  String get onbSetupText => 'Podrá cambiarlos después en los ajustes.';

  @override
  String get onbMobilityHint => 'Actívelo si hace rutas internacionales';

  @override
  String onbNotifyText(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutos',
      one: '$minutes minuto',
    );
    return 'Le avisaremos $_temp0 antes de la pausa y del fin de la jornada, incluso con la aplicación cerrada.';
  }

  @override
  String get onbAutoText =>
      'Arranca: activamos la conducción; para: otros trabajos. Tras un descanso preguntamos primero. Solo usamos la velocidad del GPS: las coordenadas no se guardan ni se envían.';

  @override
  String get onbAutoLater => 'Puede activarlo más tarde en los ajustes.';

  @override
  String languageButton(String language) {
    return 'Idioma: $language';
  }

  @override
  String get vehicleVan => 'Furgoneta 2,5–3,5 t';

  @override
  String get onbRulesTitle => 'Normas principales';

  @override
  String get onbRulesText => 'Iguales para camiones, autobuses y furgonetas.';

  @override
  String get onbRulesMore =>
      'Todas las normas explicadas: «Más» → «Guía y normas».';

  @override
  String get guideTitle => 'Guía y normas';

  @override
  String get guideHowTo => 'Cómo usarla';

  @override
  String get guideStep1 =>
      'Cambie la actividad con los botones de la pantalla de inicio: conducción, descanso, trabajo o disponibilidad.';

  @override
  String get guideStep2 =>
      'Indique el país de inicio y de fin de la jornada, como en el tacógrafo.';

  @override
  String get guideStep3 =>
      'Le avisamos con antelación de la pausa y del fin del día. ¿Se equivocó? La hora se puede corregir.';

  @override
  String get guideRules => 'Normas UE 561/2006 y AETR';

  @override
  String get guideContinuous => 'Conducción sin pausa';

  @override
  String guideContinuousText(String full, String first, String second) {
    return 'Después, una pausa de $full. Se puede dividir: primero $first, luego $second.';
  }

  @override
  String get guideDailyDriving => 'Conducción al día';

  @override
  String guideDailyDrivingText(String extended) {
    return 'Dos veces por semana se permite hasta $extended.';
  }

  @override
  String get guideWeeklyDriving => 'Conducción a la semana';

  @override
  String guideWeeklyDrivingText(String fortnight) {
    return 'En dos semanas consecutivas cualesquiera, no más de $fortnight.';
  }

  @override
  String get guideDailyRest => 'Descanso diario';

  @override
  String guideDailyRestText(String reduced, String first, String second) {
    return 'Entre descansos semanales puede reducirse a $reduced, hasta tres veces. También puede dividirse: $first + $second.';
  }

  @override
  String get guideWorkday => 'Jornada de trabajo';

  @override
  String guideWorkdayText(String window, String regular, String reduced) {
    return 'La jornada y su descanso caben en $window: $regular antes de un descanso normal, $reduced antes de uno reducido.';
  }

  @override
  String guideWorkdaySpoken(int first, int second) {
    String _temp0 = intl.Intl.pluralLogic(
      second,
      locale: localeName,
      other: '$second horas',
      one: '$second hora',
    );
    return '$first o $_temp0';
  }

  @override
  String get guideWeeklyRest => 'Descanso semanal';

  @override
  String guideWeeklyRestText(String reduced) {
    return 'Reducido: $reduced, con compensación antes del final de la tercera semana. El descanso normal no se puede pasar en la cabina.';
  }

  @override
  String get guideWorkWeek => 'Semana de trabajo';

  @override
  String guideWorkWeekText(String period) {
    return 'El siguiente descanso semanal empieza como muy tarde 6 × $period después del final del anterior.';
  }

  @override
  String get guideCard => 'Tarjeta del conductor';

  @override
  String guideCardText(String days) {
    return 'La tarjeta se descarga al menos cada $days.';
  }

  @override
  String get guideModes => 'Colores e iconos';

  @override
  String get guideNewbie => 'Primera vez con tacógrafo';

  @override
  String get guideNewbieCard => 'La tarjeta, en el tacógrafo toda la jornada';

  @override
  String get guideNewbieCardText =>
      'Inserte la tarjeta al inicio de la jornada y retírela al final. Lo que hizo sin tarjeta —trabajo, disponibilidad o descanso— introdúzcalo a mano en la siguiente inserción.';

  @override
  String get guideNewbieApp => 'La aplicación no sustituye al tacógrafo';

  @override
  String get guideNewbieAppText =>
      'El registro oficial está en el tacógrafo. Cambie la actividad allí y aquí: así los contadores coincidirán.';

  @override
  String get guideNewbieBreak => 'La pausa es solo descanso';

  @override
  String get guideNewbieBreakText =>
      'Durante la pausa no se puede conducir ni trabajar. La carga y descarga son otros trabajos, no pausa.';

  @override
  String get guideNewbieRestPlace => 'Dónde descansar';

  @override
  String get guideNewbieRestPlaceText =>
      'El descanso diario y el semanal reducido pueden hacerse en el vehículo si tiene litera y está parado. El descanso semanal normal y la compensación, solo fuera del vehículo.';

  @override
  String get guideNewbieCountry => 'Países';

  @override
  String get guideNewbieCountryText =>
      'El país se introduce en el tacógrafo al inicio y al final de la jornada. El tacógrafo inteligente de segunda generación registra solo el cruce de frontera; en los más antiguos el país se introduce en la primera parada tras la frontera.';

  @override
  String guideVanText(String date) {
    return 'Las normas son las mismas que para camiones. Desde el $date se aplican a furgonetas de más de 2,5 t incluido el remolque, en transporte internacional de mercancías y cabotaje. Esa furgoneta lleva un tacógrafo inteligente de segunda generación y el conductor tiene tarjeta.';
  }

  @override
  String get guideVanCheck => '¿Se aplican las normas a su trayecto?';

  @override
  String get guideVanTrip => 'Trayecto';

  @override
  String get guideVanTripHint =>
      'Cabotaje: transporte dentro de otro país de la UE';

  @override
  String get guideVanDomestic => 'Nacional';

  @override
  String get guideVanCrossBorder => 'Al extranjero o cabotaje';

  @override
  String get guideVanCarriage => 'Transporte';

  @override
  String get guideVanHire => 'Por cuenta ajena';

  @override
  String get guideVanOwn => 'Por cuenta propia';

  @override
  String get guideVanNonCommercial => 'No comercial';

  @override
  String get guideVanCarriageHint =>
      'Cuenta propia: mercancías, materiales o herramientas de su empresa. No comercial: sin pago ni ingresos, sin relación con el trabajo';

  @override
  String get guideVanMain => '¿Conducir es su trabajo principal?';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get guideVanApplies => 'Las normas se aplican';

  @override
  String get guideVanNotApply => 'Las normas no se aplican';

  @override
  String get guideVanAppliesText =>
      'Se necesitan tacógrafo y tarjeta del conductor, los límites son los de un camión.';

  @override
  String guideVanNotYetText(String date) {
    return 'Hasta el $date las furgonetas no estaban sujetas a las normas.';
  }

  @override
  String get guideVanDomesticText =>
      'El reglamento de la UE no se aplica a furgonetas en transporte nacional. Consulte las normas de su país.';

  @override
  String get guideVanOwnText =>
      'Excepción: transporte para necesidades propias, y conducir no es su trabajo principal.';

  @override
  String get guideVanNonCommercialText =>
      'Excepción: transporte sin pago ni ingresos, sin relación con el trabajo.';

  @override
  String guideArticle(String article) {
    return 'Reglamento 561/2006, art. $article';
  }

  @override
  String get guideVanNotes =>
      'Con el remolque, más de 3,5 t: normas de camión, también en nacional. Trayecto en parte fuera de la UE —a Ucrania, Moldavia, Turquía, los Balcanes—: consúltelo con el transportista, no hay una interpretación única.';

  @override
  String get guideDisclaimer =>
      'TachoGo ayuda a planificar el tiempo, pero no sustituye al tacógrafo ni es asesoramiento jurídico. La aplicación no está vinculada a las autoridades de la UE ni de los países europeos. Texto oficial de las normas: Reglamento (CE) n.º 561/2006 y Acuerdo AETR.';

  @override
  String get guideSources => 'Dónde comprobar';

  @override
  String get guideOfficialText => 'Texto oficial del Reglamento 561/2006';

  @override
  String get moreAbout => 'Acerca de la aplicación';

  @override
  String get aboutLicenses => 'Licencias de código abierto';

  @override
  String get aboutLicensesHint =>
      'Bibliotecas y fuentes con las que está hecha la aplicación';

  @override
  String get moreDisclaimer =>
      'TachoGo ayuda a planificar los tiempos de conducción y descanso, pero no sustituye al tacógrafo ni es asesoramiento jurídico. La aplicación no está vinculada a las autoridades de la UE ni de los países europeos.';

  @override
  String get morePrivacy => 'Política de privacidad';

  @override
  String get moreTerms => 'Condiciones de uso';

  @override
  String linkFailed(String url) {
    return 'No se pudo abrir el navegador. Dirección de la página: $url';
  }

  @override
  String get problemTitle => 'Informar de un problema';

  @override
  String get problemHint =>
      'Versión beta: el informe llega a los desarrolladores';

  @override
  String get problemText =>
      'El informe incluye la versión de la aplicación, el modelo del teléfono, los ajustes, los permisos, el calendario de notificaciones y el registro de los dos últimos días. No incluye coordenadas. Elija correo o mensajería y describa qué pasó.';

  @override
  String get problemSend => 'Enviar';

  @override
  String get problemSubject => 'TachoGo — problema en la beta';

  @override
  String get problemPrompt => 'Qué pasó y cuándo (con sus palabras):';

  @override
  String get problemFailed => 'No se pudo abrir el envío. Inténtelo de nuevo.';

  @override
  String get transferTitle => 'Pasar a otro teléfono';

  @override
  String get transferHint =>
      'El registro en un archivo por mensajería o correo';

  @override
  String get transferText =>
      'En el teléfono antiguo, guarde el registro en un archivo y envíeselo a usted mismo: por mensajería, correo o a la nube. En el nuevo, abra esta pantalla y cargue el archivo: el registro, las descargas de la tarjeta y los ajustes de cálculo se transferirán.';

  @override
  String get transferSave => 'Guardar registro en archivo';

  @override
  String get transferLoad => 'Cargar registro desde archivo';

  @override
  String get transferConfirmTitle => '¿Cargar el registro?';

  @override
  String transferConfirmRange(String from, String to) {
    return 'El archivo contiene el registro del $from al $to.';
  }

  @override
  String get transferConfirmReplace =>
      'El registro de este teléfono se sustituirá por el del archivo.';

  @override
  String get transferConfirm => 'Cargar';

  @override
  String get transferDone => 'Registro cargado';

  @override
  String get transferEmpty => 'El archivo no tiene entradas de registro';

  @override
  String get transferNotBackup =>
      'No es un archivo de registro de TachoGo: elija el archivo tachogo-journal';

  @override
  String get transferNewer =>
      'El archivo se guardó en una versión más nueva de TachoGo: actualice la aplicación';

  @override
  String get transferDamaged =>
      'El archivo de registro está dañado: guárdelo de nuevo en el teléfono antiguo';

  @override
  String get transferFailed =>
      'El registro no se cargó. En el teléfono todo sigue igual';

  @override
  String get transferSaveFailed =>
      'No se pudo guardar el archivo. Inténtelo de nuevo.';

  @override
  String get rowCompensation => 'Compensación';

  @override
  String get compensationAttach => 'añadir a un descanso de al menos 9 h';

  @override
  String compensationRestUntil(String time) {
    return 'descansar hasta $time';
  }

  @override
  String get compensationTooLate => 'no llega al plazo';

  @override
  String get compensationTakenHere => 'añadida a este descanso';

  @override
  String get chipCompensationDone => 'saldada';

  @override
  String get chipCompensationSoon => 'plazo próximo';

  @override
  String get chipCompensationOverdue => 'vencida';

  @override
  String compensationDebt(String time) {
    return 'deuda $time';
  }

  @override
  String compensationRepaidOn(String date) {
    return 'saldada el $date';
  }

  @override
  String compensationAttachBy(String date) {
    return 'añadir antes del $date';
  }

  @override
  String compensationTakenValue(String time) {
    return 'compensación $time';
  }

  @override
  String get notifyCompensationTakenTitle => 'Compensación tomada';

  @override
  String notifyCompensationTakenText(String time) {
    return 'La deuda de $time por un descanso semanal reducido está saldada.';
  }

  @override
  String get bansTitle => 'Prohibiciones de circulación';

  @override
  String get bansHint => 'Dónde y cuándo no pueden circular los camiones';

  @override
  String get bansForTrucks => 'Para camiones de más de 12 t';

  @override
  String get bansMapLabel => 'Mapa de prohibiciones de circulación en Europa';

  @override
  String get bansLegendActive => 'Prohibido ahora';

  @override
  String get bansLegendSoon => 'Prohibición pronto';

  @override
  String get bansLegendPartial => 'Parcial';

  @override
  String get bansLegendClear => 'Se puede circular';

  @override
  String get bansLegendRoads => 'Algunas carreteras';

  @override
  String get bansLegendNoData => 'Sin datos';

  @override
  String bansActiveUntil(String time) {
    return 'Prohibido hasta $time';
  }

  @override
  String bansSoonFrom(String time) {
    return 'Prohibido desde $time';
  }

  @override
  String bansClearUntil(String time) {
    return 'Se puede circular hasta $time';
  }

  @override
  String get bansClearWeek => 'Sin prohibiciones en los próximos 7 días';

  @override
  String bansPartialUntil(String time) {
    return 'Prohibición parcial hasta $time';
  }

  @override
  String get bansSomeRoads => 'Prohibiciones en algunas carreteras';

  @override
  String get bansNone => 'Sin prohibiciones generales';

  @override
  String get bansNowTitle => 'Ahora';

  @override
  String get bansRules => 'Normas';

  @override
  String get bansUpcoming => 'Próximas prohibiciones';

  @override
  String get bansNoUpcoming => 'Sin prohibiciones en las próximas dos semanas';

  @override
  String get bansSources => 'Dónde comprobar';

  @override
  String bansUpdated(String date, String time) {
    return 'Normas actualizadas el $date a las $time, se comprueban una vez al día.';
  }

  @override
  String bansNotUpdated(String date) {
    return 'Normas del $date: se actualizarán cuando haya internet.';
  }

  @override
  String get bansLocalTime => 'Horas locales del país.';

  @override
  String get bansNeedsCheck =>
      'Las fuentes difieren: compruebe la oficial antes del viaje.';

  @override
  String get bansDisclaimer =>
      'Información orientativa, no fuente oficial: hay excepciones (mercancías perecederas, permisos) y prohibiciones locales. Compruebe la ruta en la fuente del país.';

  @override
  String get bansProvisional =>
      'Provisional: el calendario del país para este año aún no se ha publicado';

  @override
  String bansKind(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'weekend': 'Fin de semana',
      'holiday': 'Festivo',
      'holidayEve': 'Víspera de festivo',
      'summer': 'Prohibición de verano',
      'night': 'Prohibición nocturna',
      'other': 'Según el calendario del país',
    });
    return '$_temp0';
  }

  @override
  String bansScope(String scope) {
    String _temp0 = intl.Intl.selectLogic(scope, {
      'allRoads': 'todas las carreteras',
      'mainRoads': 'autopistas y carreteras principales',
      'someRoads': 'algunas carreteras',
      'someRegions': 'algunas regiones',
      'other': 'no para todos los vehículos',
    });
    return '$_temp0';
  }

  @override
  String bansOver(String tonnes) {
    return 'más de $tonnes t';
  }

  @override
  String get bansRuleHolidays => 'Festivos';

  @override
  String get bansRuleNights => 'Cada noche';

  @override
  String bansRuleCalendar(String year) {
    return 'Días del calendario $year';
  }

  @override
  String bansSeason(String from, String to) {
    return 'del $from al $to';
  }

  @override
  String bansSpanEve(String from, String to) {
    return 'la víspera $from – $to';
  }

  @override
  String get bansRoadsText =>
      'Los horarios dependen de la carretera y cambian cada año: consulte la fuente del país.';

  @override
  String get bansNoneText =>
      'No hay prohibiciones generales para camiones. Puede haber restricciones para mercancías peligrosas y en algunos tramos.';

  @override
  String get bansCountries => 'Países';

  @override
  String get bansCurrentCountry => 'Está aquí';

  @override
  String get settingsBaseCountry => 'País de la empresa';

  @override
  String get settingsBaseCountryHint =>
      'Donde está establecida la empresa: allí no se pueden tomar dos descansos semanales reducidos seguidos';

  @override
  String get baseCountryNotSet => 'Sin elegir';

  @override
  String get baseCountryCardTitle => 'Indique el país de la empresa';

  @override
  String get baseCountryCardText =>
      'Sin él no se puede comprobar si se permiten dos descansos semanales reducidos seguidos ni contar los días de trabajo';

  @override
  String get onbBaseCountryRequired =>
      'Elija el país de la empresa para continuar';

  @override
  String get weeklyReducedNoBase =>
      'en el país de la empresa — hace falta normal';

  @override
  String get workDaysTitle => 'Días de trabajo';

  @override
  String get workDaysHint =>
      'Días de trabajo y de descanso — en el país de la empresa y en el extranjero';

  @override
  String workDaysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'días de trabajo',
      one: 'día de trabajo',
    );
    return '$_temp0';
  }

  @override
  String get workDaysWorking => 'Día de trabajo';

  @override
  String get workDaysWeekendsAbroad => 'Días de descanso en el extranjero';

  @override
  String get workDaysWeekendsAbroadHint =>
      'Sin trabajo, al menos parte del día en el extranjero';

  @override
  String get workDaysWeekendAbroad => 'Día de descanso en el extranjero';

  @override
  String get workDaysWeekendsHome =>
      'Días de descanso en el país de la empresa';

  @override
  String get workDaysWeekendsHomeHint =>
      'Sin trabajo, todo el día en el país de la empresa';

  @override
  String get workDaysWeekendHome => 'Día de descanso en el país de la empresa';

  @override
  String get workDaysNoData => 'Sin datos';

  @override
  String get workDaysPrevMonth => 'Mes anterior';

  @override
  String get workDaysNextMonth => 'Mes siguiente';

  @override
  String get workDaysNoBase =>
      'Indique el país de la empresa: sin él no se pueden contar los días.';

  @override
  String get workDaysRule =>
      'Un día de trabajo tiene conducción u otro trabajo, y en el extranjero también disponibilidad. Los demás días son de descanso. Los países salen de las jornadas de la pantalla de inicio. Los días de trabajo están rellenos y el gris significa sin datos.';

  @override
  String get violationsTitle => 'Infracciones';

  @override
  String get violationsHint => 'Los últimos 56 días, con sus explicaciones';

  @override
  String violationsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'infracciones en 56 días',
      one: 'infracción en 56 días',
    );
    return '$_temp0';
  }

  @override
  String get violationsPeriod => 'Periodo de control';

  @override
  String get violationsUnexplained => 'Sin explicación';

  @override
  String get violationsEmpty => 'Sin infracciones en 56 días';

  @override
  String get violationsEmptyText =>
      'Las infracciones del registro aparecerán aquí solas.';

  @override
  String get violationsRule =>
      'En un control en carretera se revisan los registros de 56 días: ese es el tiempo que una infracción sigue en la lista. Añada una explicación mientras recuerde el motivo: atasco, sin plaza de aparcamiento, retraso en la carga. Es una nota para usted: el inspector revisa el tacógrafo y el motivo oficial se escribe a mano en una impresión.';

  @override
  String violationsDaysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Aún $days días en el periodo de control',
      one: 'Aún $days día en el periodo de control',
    );
    return '$_temp0';
  }

  @override
  String get violationsActive => 'ahora';

  @override
  String violationsOver(String time) {
    return 'Exceso de $time';
  }

  @override
  String violationsLate(String time) {
    return 'Retraso de $time';
  }

  @override
  String violationsShort(String time) {
    return 'Descanso que faltó: $time';
  }

  @override
  String get violationsNoNote => 'sin explicación';

  @override
  String get violationsNoteAdd => 'Añadir una explicación';

  @override
  String get violationsNoteTitle => 'Explicación de la infracción';

  @override
  String get violationsNoteHint =>
      'Por ejemplo: atasco, sin plaza de aparcamiento';

  @override
  String get violationsNote => 'Explicación';

  @override
  String get tachoTitle => 'Tacógrafo por Bluetooth';

  @override
  String get tachoHint =>
      'Beta: actividad y tiempos directamente del tacógrafo';

  @override
  String get tachoBeta => 'Beta · solo lectura';

  @override
  String get tachoLead =>
      'La aplicación lee la actividad y los tiempos de un tacógrafo Smart 2 (VDO DTCO 4.1a o posterior). No guarda nada ni cambia nada en el tacógrafo.';

  @override
  String get tachoStepCard =>
      'Introduzca la tarjeta del conductor en el tacógrafo.';

  @override
  String get tachoStepConsent =>
      'En el menú del tacógrafo, permita la transmisión de datos ITS: sin ella, el Bluetooth del tacógrafo no se activa.';

  @override
  String get tachoStepPair =>
      'En el tacógrafo, abra Bluetooth → emparejamiento. Después, en los ajustes de Bluetooth del teléfono, elija el tacógrafo y confirme los mismos 6 dígitos en el teléfono y en el tacógrafo.';

  @override
  String get tachoFind => 'Buscar tacógrafo';

  @override
  String get tachoSearching => 'Buscando un tacógrafo cerca…';

  @override
  String get tachoSearchHint =>
      '¿El tacógrafo no aparece? Abra el menú Bluetooth del tacógrafo e inicie la conexión.';

  @override
  String get tachoShowAll => 'Todos los dispositivos Bluetooth';

  @override
  String get tachoUnnamed => 'Sin nombre';

  @override
  String get tachoStop => 'Detener';

  @override
  String tachoConnecting(String name) {
    return 'Conectando con $name…';
  }

  @override
  String get tachoPairHint =>
      '¿Aparecen 6 dígitos? Compruebe que son iguales en el teléfono y el tacógrafo y confirme en ambos.';

  @override
  String get tachoWaiting => 'Esperando datos del tacógrafo…';

  @override
  String get tachoNoConsent =>
      'El tacógrafo no comparte los datos del conductor. Active la transmisión de datos (ITS) en su menú.';

  @override
  String get tachoNoDriverData =>
      'El tacógrafo aún no ha enviado los datos del conductor.';

  @override
  String get tachoMoving => 'en marcha';

  @override
  String get tachoStanding => 'parado';

  @override
  String get tachoModeUnknown => 'Actividad desconocida';

  @override
  String get tachoCoDriver => 'Segundo conductor';

  @override
  String get tachoCurrentActivity => 'Actividad en curso';

  @override
  String get tachoLeftSection => 'Restante';

  @override
  String get tachoUntilDailyRest => 'Hasta el descanso diario';

  @override
  String get tachoUntilWeeklyRest => 'Hasta el descanso semanal';

  @override
  String get tachoShiftLeft => 'Conducción en la jornada';

  @override
  String get tachoWeekLeft => 'Conducción en la semana';

  @override
  String get tachoNote =>
      'Las cifras vienen del tacógrafo y se actualizan cada pocos segundos. Mientras haya conexión, la actividad del registro de TachoGo sigue al tacógrafo.';

  @override
  String get tachoDisconnect => 'Desconectar';

  @override
  String get tachoNoPermission =>
      'Permita el acceso a dispositivos cercanos: sin él, el teléfono no encuentra el tacógrafo.';

  @override
  String get tachoAllow => 'Permitir';

  @override
  String get tachoBluetoothOff => 'El Bluetooth del teléfono está desactivado.';

  @override
  String get tachoTurnOn => 'Activar Bluetooth';

  @override
  String get tachoLocationOff =>
      'En este teléfono, la búsqueda Bluetooth solo funciona con la ubicación activada.';

  @override
  String get tachoUnsupported =>
      'Este teléfono no admite Bluetooth LE: no puede conectarse al tacógrafo.';

  @override
  String get tachoRetry => 'Reintentar';

  @override
  String get tachoFailScan => 'La búsqueda no se ha iniciado.';

  @override
  String get tachoFailConnect =>
      'No se pudo conectar. Acérquese al tacógrafo e inténtelo de nuevo.';

  @override
  String get tachoFailNotTacho =>
      'No es un tacógrafo Smart 2. Elija otro dispositivo.';

  @override
  String get tachoFailNoAnswer =>
      'El tacógrafo no responde. Compruebe que la conexión está confirmada en el tacógrafo y que no hay otro teléfono conectado.';

  @override
  String get tachoFailLost => 'Se ha perdido la conexión con el tacógrafo.';

  @override
  String get tachoLogTitle => 'Registro de intercambio · versión de desarrollo';

  @override
  String get tachoLogEmpty =>
      'Vacío por ahora: inicie la búsqueda del tacógrafo.';

  @override
  String get tachoLogCopy => 'Copiar registro';

  @override
  String get tachoLogCopied => 'Registro copiado: péguelo en un mensaje.';

  @override
  String get tachoFailRefused =>
      'El tacógrafo no deja que el teléfono lea los datos. Con el vehículo parado, compruebe en el menú del tacógrafo que el Bluetooth y la transmisión de datos (ITS) están activados, cierre otras apps de tacógrafo e inténtelo de nuevo.';

  @override
  String get tachoFailPairing =>
      'El emparejamiento no terminó. Elimine el tacógrafo en los ajustes de Bluetooth del teléfono, vuelva a abrir Bluetooth → emparejamiento en el tacógrafo y elíjalo en el teléfono. No lo repita enseguida: si falla, espere unos minutos.';

  @override
  String get tachoStepConnect =>
      'Cuando aparezca el símbolo de Bluetooth en la pantalla del tacógrafo, pulse el botón de abajo y elija el tacógrafo.';

  @override
  String get tachoFailNotBonded =>
      'El teléfono aún no está emparejado con el tacógrafo. En el tacógrafo, abra Bluetooth → emparejamiento; después elija el tacógrafo en los ajustes de Bluetooth del teléfono y confirme los 6 dígitos en ambos. Luego vuelva aquí.';

  @override
  String get tachoOpenBluetooth => 'Ajustes de Bluetooth';

  @override
  String get tachoLinkTitle => 'Actividad desde el tacógrafo';

  @override
  String tachoLinkHint(String name) {
    return '$name: cambie la actividad en el tacógrafo; la app la sigue sola.';
  }
}
