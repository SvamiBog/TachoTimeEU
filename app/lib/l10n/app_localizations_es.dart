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
  String get switchFailed => 'La actividad no se guardó. Inténtelo de nuevo.';

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
      'Jornada terminada. La siguiente empezará con la primera actividad que no sea descanso.';

  @override
  String get bannerBreakNeeded45 =>
      'Se necesita una pausa de 45 min (o dividida 15 + 30)';

  @override
  String get bannerBreakNeeded30 =>
      'Se necesita una pausa de 30 min — segunda parte de la dividida 15 + 30';

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
  String get chipLimiting => 'limita';

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
      'Los datos de la tarjeta del conductor deben descargarse al menos cada 28 días (Reglamento (UE) n.º 581/2010).';

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
      'El descanso diario debe terminar dentro de las 24 horas siguientes al inicio de la jornada. El descanso reducido de 9 h se permite como máximo tres veces entre dos descansos semanales.';

  @override
  String get workdayEndDay => 'Terminar el día';

  @override
  String get workdayEndDayHint =>
      'El descanso empieza ahora y cierra la jornada, aunque dure menos de 9 h.';

  @override
  String get endDayDriving => 'Conducción del día';

  @override
  String get endDayDrivingHint =>
      '¿Cuánto tiempo condujo hoy? No hacen falta las horas exactas de los modos, solo el total.';

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
    return 'Empiece el descanso diario dentro de $time.';
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
    return 'Empiece el descanso semanal dentro de $time.';
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
    return 'No se añadieron $time por el descanso semanal reducido. Retraso: $_temp0.';
  }

  @override
  String get infrReducedRestsExceededTitle => 'Demasiados descansos reducidos';

  @override
  String infrReducedRestsExceededText(int count) {
    return 'Reducidos desde el descanso semanal: $count, se permiten 3.';
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
      'El descanso puede interrumpirse dos veces como máximo, hasta 1 h en total (art. 9). El movimiento del ferry no activa la conducción.';

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
      'La primera parte de al menos 15 min, la segunda de al menos 30 min, justo en este orden. La aplicación la reconoce sola.';

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
  String get weeklyMobilityOn =>
      'Paquete de movilidad activado: en transporte internacional se permiten dos descansos reducidos seguidos si se toman fuera del país de matriculación. La reducción se compensa antes del final de la tercera semana.';

  @override
  String get weeklyMobilityOff =>
      'Un descanso semanal reducido se compensa antes del final de la tercera semana: la deuda se añade a un descanso de al menos 9 h.';

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
  String get countryRecent => 'Recientes';

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
      'Todavía no hay jornadas. Aparecerán cuando empiece a cambiar de actividad, o añada una jornada a mano.';

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
      'Se eliminarán todos los registros de actividades de esta jornada. No se puede deshacer.';

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
      'Después de esta jornada hay otras: no puede estar en curso';

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
      'La jornada sigue los registros de actividades: cambiar el inicio, el fin o la conducción moverá los propios registros.';

  @override
  String get shiftConvertHint =>
      'Hora, conducción o descanso cambiados: la jornada se guardará como entrada manual en lugar de los registros de actividades.';

  @override
  String shiftEndNowHint(String time) {
    return 'La jornada terminará a las $time, luego empezará el descanso.';
  }

  @override
  String get shiftResumeHint =>
      'Se eliminará el descanso tras la jornada: la jornada continuará.';

  @override
  String shiftOngoingHint(String time, String mode) {
    return 'La jornada pasará a ser la actual y continuará en la pantalla de inicio desde las $time. Actividad «$mode»: si ahora es otra, cámbiela allí.';
  }

  @override
  String get shiftUnsavedTitle => '¿Guardar los cambios?';

  @override
  String get shiftUnsavedText =>
      'Los cambios de esta jornada aún no están guardados.';

  @override
  String get shiftDiscard => 'No guardar';

  @override
  String get shiftDateTimeTitle => 'Fecha y hora de la jornada';

  @override
  String driveEditSubtitle(String date) {
    return 'Corrección manual · $date';
  }

  @override
  String get driveEditComputed => 'Calculado por la aplicación';

  @override
  String driveEditDiff(String diff) {
    return '$diff respecto al cálculo.';
  }

  @override
  String get driveEditNoChange => 'Tiempo sin cambios.';

  @override
  String get driveEditHint =>
      'Úselo si la actividad se cambió en mal momento: los límites se recalcularán.';

  @override
  String get driveEditNoDrive =>
      'Aún no hay conducción en la jornada actual: nada que corregir.';

  @override
  String get breakCorrection => 'Corrección';

  @override
  String get breakCurrentDuration => 'Pausa actual';

  @override
  String get breakLastDuration => 'Última pausa';

  @override
  String get breakNoBreak =>
      'Aún no hay pausa en la jornada: nada que corregir.';

  @override
  String get breakEditHint =>
      'El tiempo se toma del registro vecino: los límites se recalcularán.';

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
  String get exportPdf => 'PDF · para inspección';

  @override
  String get exportCsv => 'CSV · tabla';

  @override
  String get exportPdfHint =>
      'No es un documento oficial: el informe no sustituye los datos del tacógrafo ni de la tarjeta del conductor.';

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
      'Las notificaciones están bloqueadas en el teléfono';

  @override
  String get notifyAllowed => 'Notificaciones permitidas';

  @override
  String get notifyExact => 'Hora exacta de las notificaciones';

  @override
  String get notifyExactHint =>
      'Permita «Alarmas y recordatorios»; si no, el teléfono puede retrasar el aviso';

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
    return 'Pausa de $required min cumplida. Puede conducir $time hasta la próxima pausa.';
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
    return '¿Empezar la conducción desde las $time? El descanso se interrumpirá';
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
      'Si no, la aplicación preguntará primero: podía ir de pasajero';

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
      'Sin acceso a la ubicación no se puede detectar la conducción. La aplicación solo necesita la velocidad, las coordenadas no se guardan.';

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
      'Se eliminarán el registro de actividades, las jornadas, los países, las notas y las descargas de la tarjeta. No se puede deshacer. Los ajustes se conservarán.';

  @override
  String get clearConfirm => 'Borrar';

  @override
  String get clearDone => 'Datos eliminados';

  @override
  String onbStep(int step, int count) {
    return 'Paso $step de $count';
  }

  @override
  String get onbWelcomeTitle => 'El tiempo al volante bajo control';

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
  String get onbModeDriving =>
      'Al volante. Contamos la conducción sin pausa, diaria y semanal.';

  @override
  String get onbModeWork => 'Carga, revisión del vehículo, documentos.';

  @override
  String get onbModeAvailability =>
      'Espera: cola de carga, frontera, segundo conductor en ruta.';

  @override
  String get onbModeRest =>
      'Pausas y descanso. «Terminar el día» cierra la jornada.';

  @override
  String get onbSetupTitle => 'Vamos a ajustarla para usted';

  @override
  String get onbSetupText =>
      'Todo esto se puede cambiar después en los ajustes.';

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
      'Arranca: la aplicación activa la conducción; para: otros trabajos. Tras un descanso pregunta primero. Solo se necesita la velocidad del GPS: las coordenadas no se guardan ni se envían.';

  @override
  String get onbAutoLater => 'Puede activarlo más tarde en los ajustes.';

  @override
  String languageButton(String language) {
    return 'Idioma: $language';
  }

  @override
  String get settingsVehicle => 'Vehículo';

  @override
  String get vehicleTruckOrBus => 'Camión o autobús';

  @override
  String get vehicleVan => 'Furgoneta 2,5–3,5 t';

  @override
  String settingsVanHint(String date) {
    return 'Normas: desde el $date en transporte internacional y cabotaje por cuenta ajena';
  }

  @override
  String onbVanText(String date) {
    return 'Las normas de la UE para furgonetas se aplican desde el $date, en transporte internacional y cabotaje por cuenta ajena. La furgoneta lleva un tacógrafo inteligente de segunda generación y el conductor tiene tarjeta.';
  }

  @override
  String get onbRulesTitle => 'Normas principales';

  @override
  String get onbRulesText =>
      'Iguales para camiones, autobuses y furgonetas. La aplicación las calcula sola y avisa con antelación.';

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
      'Vigile los límites. La aplicación avisará con antelación de la pausa y del fin del día. Cualquier tiempo se puede corregir a mano.';

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
    return 'Hasta tres veces entre descansos semanales puede reducirse a $reduced. Opción dividida: $first + $second.';
  }

  @override
  String get guideWorkday => 'Jornada de trabajo';

  @override
  String guideWorkdayText(String window, String regular, String reduced) {
    return 'El descanso debe terminar dentro de las $window desde el inicio de la jornada: $regular con descanso normal, $reduced con reducido.';
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
    return 'El descanso semanal empieza como muy tarde tras seis periodos de $period desde el anterior.';
  }

  @override
  String get guideCard => 'Tarjeta del conductor';

  @override
  String guideCardText(String days) {
    return 'Los datos de la tarjeta deben descargarse al menos cada $days.';
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
      'TachoGo ayuda a planificar el tiempo, pero no sustituye al tacógrafo ni es asesoramiento jurídico. Texto oficial de las normas: Reglamento (CE) n.º 561/2006 y Acuerdo AETR.';

  @override
  String get moreAbout => 'Acerca de la aplicación';

  @override
  String get moreDisclaimer =>
      'TachoGo ayuda a planificar los tiempos de conducción y descanso, pero no sustituye al tacógrafo ni es asesoramiento jurídico.';

  @override
  String get problemTitle => 'Informar de un problema';

  @override
  String get problemHint =>
      'Versión beta: el informe llega a los desarrolladores';

  @override
  String get problemText =>
      'El informe incluye la versión de la aplicación, el modelo del teléfono, los ajustes, los permisos, el calendario de notificaciones y las entradas del registro de los dos últimos días. No incluye coordenadas. Elija dónde enviarlo —correo o mensajería— y describa qué pasó.';

  @override
  String get problemSend => 'Enviar';

  @override
  String get problemSubject => 'TachoGo — problema en la beta';

  @override
  String get problemPrompt => 'Qué pasó y cuándo (con sus palabras):';

  @override
  String get problemFailed => 'No se pudo abrir el envío. Inténtelo de nuevo.';
}
