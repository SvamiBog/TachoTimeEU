// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'TachoGo';

  @override
  String get navHome => 'Início';

  @override
  String get navJournal => 'Registo';

  @override
  String get navSettings => 'Definições';

  @override
  String get navMore => 'Mais';

  @override
  String get close => 'Fechar';

  @override
  String get back => 'Voltar';

  @override
  String ofLimit(String limit) {
    return 'de $limit';
  }

  @override
  String get premiumLock => 'Disponível no Premium';

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
    return 'excesso de $duration';
  }

  @override
  String get modeDriving => 'Condução';

  @override
  String get modeRest => 'Repouso';

  @override
  String get modeWork => 'Trabalho';

  @override
  String get modeWorkFull => 'Outro trabalho';

  @override
  String get modeAvailability => 'Disponibilidade';

  @override
  String get modeNone => 'Nenhuma atividade escolhida';

  @override
  String modeSince(String time) {
    return 'desde as $time';
  }

  @override
  String get switchFailed => 'A atividade não foi guardada. Tente novamente.';

  @override
  String homeShiftSince(String date, String time) {
    return '$date · turno desde as $time';
  }

  @override
  String homeNoShift(String date) {
    return '$date · turno não iniciado';
  }

  @override
  String get homeLoadError =>
      'Não foi possível abrir o registo. Reinicie a aplicação — se não ajudar, escreva-nos em «Mais».';

  @override
  String get heroUntilBreak => 'Até à pausa';

  @override
  String get heroBreak => 'Pausa';

  @override
  String get heroDailyRest => 'Repouso diário';

  @override
  String get heroWeeklyRest => 'Repouso semanal';

  @override
  String heroContinuousOf(String time, String limit) {
    return 'sem pausa $time de $limit';
  }

  @override
  String get heroOffDutyHint =>
      'Turno terminado. O seguinte começa com a primeira atividade que não seja repouso.';

  @override
  String get bannerBreakNeeded45 =>
      'É precisa uma pausa de 45 min (ou repartida 15 + 30)';

  @override
  String get bannerBreakNeeded30 =>
      'É precisa uma pausa de 30 min — segunda parte da repartida 15 + 30';

  @override
  String bannerOnBreak(String time, int required) {
    return 'Pausa $time de $required min';
  }

  @override
  String bannerBreakCounted(String limit) {
    return 'Pausa cumprida — pode conduzir $limit';
  }

  @override
  String get sectionAlerts => 'Avisos';

  @override
  String get sectionToday => 'Hoje';

  @override
  String get sectionRest => 'Repouso';

  @override
  String get sectionWeek => 'Semana';

  @override
  String get rowContinuous => 'Condução sem pausa';

  @override
  String get chipBreakSoon => 'pausa em breve';

  @override
  String get chipExceeded => 'excedido';

  @override
  String get chipLimiting => 'limita';

  @override
  String get chipShiftSoon => 'fim em breve';

  @override
  String get chipLimitSoon => 'limite em breve';

  @override
  String get chipRestSoon => 'repouso em breve';

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
    return 'faltam $left → $time';
  }

  @override
  String left(String left) {
    return 'faltam $left';
  }

  @override
  String limitLeft(int hours, String left) {
    return '$hours h: faltam $left';
  }

  @override
  String limitLeftUntil(int hours, String left, String time) {
    return '$hours h: faltam $left → $time';
  }

  @override
  String limitUntil(int hours, String time) {
    return '$hours h → $time';
  }

  @override
  String get rowWorkday => 'Dia de trabalho';

  @override
  String get workdayNoShift => 'Turno não iniciado';

  @override
  String get rowDailyDriving => 'Condução diária';

  @override
  String get rowBreak => 'Pausa';

  @override
  String breakTaken(int minutes, String time) {
    return 'Feitos $minutes min às $time';
  }

  @override
  String breakStillNeeded(int minutes) {
    return 'faltam $minutes min';
  }

  @override
  String get breakNotTaken => 'Ainda sem pausa';

  @override
  String breakResting(String time, int required) {
    return 'Em pausa $time de $required min';
  }

  @override
  String get rowDailyRest => 'Repouso diário';

  @override
  String get dailyRestCaption => '11 h regular · 9 h reduzido';

  @override
  String get dailyRestSplit => '3 + 9';

  @override
  String get rowWeeklyRest => 'Repouso semanal';

  @override
  String get weeklyRestCaption => '45 h regular · 24 h reduzido';

  @override
  String get chipReducedAvailable => '24 h possível';

  @override
  String get chipReducedUnavailable => 'só 45 h';

  @override
  String get statusNotStarted => 'não iniciado';

  @override
  String statusInProgress(String time) {
    return 'em curso $time';
  }

  @override
  String statusBy(String when) {
    return 'até $when';
  }

  @override
  String get statusNoData => 'sem dados';

  @override
  String get rowWeeklyDriving => 'Condução semanal';

  @override
  String get rowFortnightDriving => 'Condução em duas semanas';

  @override
  String get rowWorkWeek => 'Semana de trabalho';

  @override
  String workWeekSince(String since) {
    return 'desde $since';
  }

  @override
  String get workWeekUnknown => 'Sem dados sobre o repouso semanal anterior';

  @override
  String get cardTitle => 'Descarga do cartão';

  @override
  String cardCaption(String last, String due) {
    return 'última $last · até $due';
  }

  @override
  String get cardNever => 'Indicar a última descarga';

  @override
  String cardSheetLast(String date) {
    return 'Última descarga: $date';
  }

  @override
  String get cardSheetNever => 'Ainda não foi indicada nenhuma descarga.';

  @override
  String get cardSheetRule =>
      'Os dados do cartão de condutor têm de ser descarregados pelo menos de 28 em 28 dias (Regulamento (UE) n.º 581/2010).';

  @override
  String get cardMarkToday => 'Descarregado hoje';

  @override
  String get cardMarked => 'Descarga indicada';

  @override
  String get workdayStart => 'Início do turno';

  @override
  String workdayRegular(int hours) {
    return '$hours h — dia normal';
  }

  @override
  String workdayRegularHint(String left) {
    return 'depois repouso regular de 11 h · faltam $left';
  }

  @override
  String workdayExtended(int hours) {
    return '$hours h — dia alargado';
  }

  @override
  String workdayExtendedHint(int count) {
    return 'depois repouso reduzido de 9 h · restam ×$count';
  }

  @override
  String get workdayRule =>
      'O repouso diário tem de terminar nas 24 horas após o início do turno. O repouso reduzido de 9 h é permitido no máximo três vezes entre dois repousos semanais.';

  @override
  String get workdayEndDay => 'Terminar o dia';

  @override
  String get workdayEndDayHint =>
      'O repouso começa agora e termina o turno, mesmo que dure menos de 9 h.';

  @override
  String todayDate(String date) {
    return 'Hoje, $date';
  }

  @override
  String infrArticle(String regulation, String article) {
    return 'UE $regulation · art. $article';
  }

  @override
  String get infrContinuousExceededTitle => 'Condução sem pausa excedida';

  @override
  String infrContinuousExceededText(String limit, String time, int required) {
    return 'Condução sem pausa acima de $limit em $time. Pare e faça uma pausa de $required min.';
  }

  @override
  String get infrBreakSoonTitle => 'Pausa em breve';

  @override
  String infrBreakSoonText(String limit, String time, int required) {
    return 'Faltam $time para o limite de $limit. É precisa uma pausa de $required min.';
  }

  @override
  String get infrDailyDriveExceededTitle => 'Condução diária excedida';

  @override
  String infrDailyDriveExceededText(String limit, String time) {
    return 'Mais de $limit em $time. Comece o repouso diário.';
  }

  @override
  String get infrDailyDriveSoonTitle => 'A condução diária está a acabar';

  @override
  String infrDailyDriveSoonText(String limit, String time) {
    return 'Faltam $time para o limite de $limit.';
  }

  @override
  String get infrExtensionInUseTitle => 'Extensão para 10 h em curso';

  @override
  String infrExtensionInUseText(int count) {
    return 'Extensões restantes esta semana: $count.';
  }

  @override
  String get infrShiftExceededTitle => 'Dia de trabalho excedido';

  @override
  String infrShiftExceededText(String limit, String time) {
    return 'Turno acima de $limit em $time. Comece o repouso diário.';
  }

  @override
  String get infrShiftSoonTitle => 'O dia de trabalho termina em breve';

  @override
  String infrShiftSoonText(String time) {
    return 'Comece o repouso diário dentro de $time.';
  }

  @override
  String get infrWeeklyDriveExceededTitle => 'Condução semanal excedida';

  @override
  String infrWeeklyDriveExceededText(String limit, String time) {
    return 'Mais de $limit em $time.';
  }

  @override
  String get infrWeeklyDriveSoonTitle => 'A condução semanal está a acabar';

  @override
  String infrWeeklyDriveSoonText(String limit, String time) {
    return 'Faltam $time para $limit.';
  }

  @override
  String get infrFortnightDriveExceededTitle =>
      'Condução em duas semanas excedida';

  @override
  String infrFortnightDriveExceededText(String limit, String time) {
    return 'Mais de $limit em $time.';
  }

  @override
  String get infrFortnightDriveSoonTitle =>
      'A condução em duas semanas está a acabar';

  @override
  String infrFortnightDriveSoonText(String limit, String time) {
    return 'Faltam $time para $limit.';
  }

  @override
  String get infrWeeklyRestOverdueTitle => 'Repouso semanal em atraso';

  @override
  String infrWeeklyRestOverdueText(String time) {
    return 'Passaram mais de 144 h desde o repouso semanal anterior — em $time.';
  }

  @override
  String get infrWeeklyRestSoonTitle => 'Repouso semanal em breve';

  @override
  String infrWeeklyRestSoonText(String time) {
    return 'Comece o repouso semanal dentro de $time.';
  }

  @override
  String get infrWeeklyRestContinueTitle => 'Não interrompa o repouso';

  @override
  String infrWeeklyRestContinueText(String time) {
    return 'O prazo do repouso semanal terminou. Descanse mais $time para que conte como repouso semanal.';
  }

  @override
  String get infrCompensationSoonTitle => 'Prazo de compensação próximo';

  @override
  String infrCompensationSoonText(String time, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dias',
      one: '$days dia',
    );
    return 'Junte $time a um repouso de pelo menos 9 h. Prazo: $_temp0.';
  }

  @override
  String get infrCompensationOverdueTitle => 'Compensação em atraso';

  @override
  String infrCompensationOverdueText(String time, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dias',
      one: '$days dia',
    );
    return 'Não foram juntas $time pelo repouso semanal reduzido. Atraso — $_temp0.';
  }

  @override
  String get infrReducedRestsExceededTitle => 'Demasiados repousos reduzidos';

  @override
  String infrReducedRestsExceededText(int count) {
    return 'Reduzidos desde o repouso semanal: $count, permitidos 3.';
  }

  @override
  String get infrCardOverdueTitle => 'Descarga do cartão em atraso';

  @override
  String infrCardOverdueText(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dias',
      one: '$days dia',
    );
    return 'O prazo de 28 dias terminou há $_temp0.';
  }

  @override
  String get infrCardSoonTitle => 'Descarga do cartão em breve';

  @override
  String infrCardSoonText(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dias',
      one: '$days dia',
    );
    return 'Faltam $_temp0.';
  }

  @override
  String get ferryTitle => 'Ferry / comboio';

  @override
  String get ferryHint =>
      'O repouso pode ser interrompido no máximo duas vezes, até 1 h no total (art. 9). O movimento do ferry não ativa a condução.';

  @override
  String get ferryOn => 'ferry';

  @override
  String breakHero(String limit) {
    return 'Pausa após $limit de condução';
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
    return '$minutes min — falta';
  }

  @override
  String breakFirstTaken(String from, String to) {
    return 'Primeira parte feita $from–$to';
  }

  @override
  String get breakNone =>
      'É precisa uma pausa de 45 min seguidos ou de 15 + 30 min.';

  @override
  String get breakSplitTitle => 'Pausa repartida 15 + 30';

  @override
  String get breakSplitText =>
      'A primeira parte com pelo menos 15 min, a segunda com pelo menos 30 min, exatamente por esta ordem. A aplicação reconhece-a sozinha.';

  @override
  String get breakStart => 'Começar pausa';

  @override
  String get breakOngoing => 'Pausa em curso';

  @override
  String get weeklyStartBy => 'Começar o mais tardar';

  @override
  String weeklyInTime(String left) {
    return 'dentro de $left — fim da semana de trabalho (144 h)';
  }

  @override
  String weeklyOverdue(String time) {
    return 'atraso $time';
  }

  @override
  String get weeklyOngoing => 'Repouso semanal em curso';

  @override
  String get weeklyUnknown =>
      'Sem dados sobre o repouso semanal anterior. O prazo aparece após um repouso de 24 h ou mais.';

  @override
  String get weeklyNext => 'Próximo repouso';

  @override
  String get weeklyFull => 'Regular';

  @override
  String get weeklyFullHint => 'não na cabina';

  @override
  String get weeklyReduced => 'Reduzido';

  @override
  String get weeklyReducedYes => 'possível · com compensação';

  @override
  String get weeklyReducedNo => 'impossível — é preciso regular';

  @override
  String get weeklyHistory => 'Histórico';

  @override
  String weeklyPrevious(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'full': 'regular',
      'reduced': 'reduzido',
      'other': 'insuficiente',
    });
    return 'Anterior · $_temp0';
  }

  @override
  String get weeklyNow => 'agora';

  @override
  String get weeklyCompensation => 'Compensação em dívida';

  @override
  String get weeklyCompensationNone => 'nenhuma';

  @override
  String weeklyCompensationValue(String time, String date) {
    return '$time até $date';
  }

  @override
  String get weeklyMobilityOn =>
      'Pacote de mobilidade ativo: no transporte internacional são permitidos dois repousos reduzidos seguidos, se gozados fora do país de matrícula. A redução é compensada até ao fim da terceira semana.';

  @override
  String get weeklyMobilityOff =>
      'Um repouso semanal reduzido é compensado até ao fim da terceira semana: a dívida junta-se a um repouso de pelo menos 9 h.';

  @override
  String get weeklyStartRest => 'Começar repouso';

  @override
  String get countryTitle => 'Escolher país';

  @override
  String countryChip(String start, String end) {
    return 'País de início $start, de fim $end. Alterar';
  }

  @override
  String countryChipNoEnd(String start) {
    return 'País de início $start, de fim não escolhido. Alterar';
  }

  @override
  String get countryChipNone => 'País do turno não escolhido. Escolher';

  @override
  String countryStartTab(String code) {
    return 'Início · $code';
  }

  @override
  String countryEndTab(String code) {
    return 'Fim · $code';
  }

  @override
  String get countryNextShift => 'País do próximo turno';

  @override
  String get countrySearch => 'País ou código';

  @override
  String get countryRecent => 'Recentes';

  @override
  String get countryClearEnd => 'Não indicar';

  @override
  String get countryNotFound => 'Nada encontrado';

  @override
  String get countryFooter =>
      'O país de início e de fim do turno é introduzido pelo condutor no tacógrafo (Regulamento (UE) n.º 165/2014, art. 34).';

  @override
  String countryName(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'A': 'Áustria',
      'AL': 'Albânia',
      'AND': 'Andorra',
      'ARM': 'Arménia',
      'AZ': 'Azerbaijão',
      'B': 'Bélgica',
      'BG': 'Bulgária',
      'BIH': 'Bósnia e Herzegovina',
      'BY': 'Bielorrússia',
      'CH': 'Suíça',
      'CY': 'Chipre',
      'CZ': 'Chéquia',
      'D': 'Alemanha',
      'DK': 'Dinamarca',
      'E': 'Espanha',
      'EST': 'Estónia',
      'F': 'França',
      'FIN': 'Finlândia',
      'FL': 'Listenstaine',
      'GE': 'Geórgia',
      'GR': 'Grécia',
      'H': 'Hungria',
      'HR': 'Croácia',
      'I': 'Itália',
      'IRL': 'Irlanda',
      'IS': 'Islândia',
      'KZ': 'Cazaquistão',
      'L': 'Luxemburgo',
      'LT': 'Lituânia',
      'LV': 'Letónia',
      'M': 'Malta',
      'MC': 'Mónaco',
      'MD': 'Moldávia',
      'MK': 'Macedónia do Norte',
      'MNE': 'Montenegro',
      'N': 'Noruega',
      'NL': 'Países Baixos',
      'P': 'Portugal',
      'PL': 'Polónia',
      'RO': 'Roménia',
      'RSM': 'São Marinho',
      'RUS': 'Rússia',
      'S': 'Suécia',
      'SK': 'Eslováquia',
      'SLO': 'Eslovénia',
      'SRB': 'Sérvia',
      'TJ': 'Tajiquistão',
      'TM': 'Turquemenistão',
      'TR': 'Turquia',
      'UA': 'Ucrânia',
      'UK': 'Reino Unido',
      'UZ': 'Usbequistão',
      'V': 'Vaticano',
      'other': '$code',
    });
    return '$_temp0';
  }

  @override
  String get journalExport => 'Exportar relatório';

  @override
  String get journalCurrent => 'atual';

  @override
  String get journalDriving => 'Condução';

  @override
  String get journalFortnight => 'Em 2 sem.';

  @override
  String journalOf(int limit) {
    return 'de $limit';
  }

  @override
  String get journalCollapsedDriving => 'condução';

  @override
  String journalWeekSpoken(String range, String driving, String fortnight) {
    return 'Semana $range. Condução $driving de 56 h, em duas semanas $fortnight de 90 h';
  }

  @override
  String get journalShift => 'Turno';

  @override
  String get journalWeeklyShort => 'sem.';

  @override
  String get journalOngoing => 'em curso';

  @override
  String get journalManual => 'manual';

  @override
  String get journalAddShift => 'Turno';

  @override
  String get journalAddShiftSpoken => 'Adicionar turno';

  @override
  String get journalEmpty =>
      'Ainda não há turnos. Aparecem quando começar a mudar de atividade — ou adicione um turno manualmente.';

  @override
  String restStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'full': 'regular',
      'reduced': 'reduzido',
      'other': 'insuficiente',
    });
    return '$_temp0';
  }

  @override
  String journalWeeklyRest(String status) {
    return 'Repouso semanal · $status';
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
    return '$date, $route, $time. Condução $driving, turno $span, repouso $rest';
  }

  @override
  String get journalRestNone => 'nenhum';

  @override
  String get journalRestWeekly => 'semanal';

  @override
  String get journalLoadError =>
      'Não foi possível abrir o registo. Reinicie a aplicação — se não ajudar, escreva-nos em «Mais».';

  @override
  String get dayTitle => 'Turno';

  @override
  String get daySummary => 'Resumo';

  @override
  String get dayModes => 'Atividades';

  @override
  String get dayBreaks => 'Pausas';

  @override
  String get dayContinuousAtEnd => 'Sem pausa no fim do turno';

  @override
  String get dayRestAfter => 'Repouso após o turno';

  @override
  String dayRestKind(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'daily': 'Diário',
      'weekly': 'Semanal',
      'other': 'Não iniciado',
    });
    return '$_temp0';
  }

  @override
  String get daySplitRest => 'repartido 3 + 9';

  @override
  String get dayManualHint =>
      'Turno introduzido manualmente em totais — não há registos de atividades.';

  @override
  String get dayNotes => 'Notas';

  @override
  String get dayEndMark => 'fim do dia';

  @override
  String get dayEdit => 'Editar turno';

  @override
  String get dayNotFound => 'Este turno já não está no registo.';

  @override
  String dayRestUntil(String time) {
    return 'até $time';
  }

  @override
  String get save => 'Guardar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get done => 'Concluído';

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
  String get pickerPrevMonth => 'Mês anterior';

  @override
  String get pickerNextMonth => 'Mês seguinte';

  @override
  String pickerRange(String min, String max) {
    return 'Possível de $min a $max';
  }

  @override
  String get shiftNewTitle => 'Novo turno';

  @override
  String get shiftSection => 'Turno';

  @override
  String get shiftStart => 'Início';

  @override
  String get shiftEnd => 'Fim';

  @override
  String get shiftOnRoad => 'em viagem';

  @override
  String get shiftChoose => 'Escolher';

  @override
  String get shiftNowOngoing => 'Agora (em curso)';

  @override
  String get shiftDuration => 'Duração';

  @override
  String get shiftNowSuffix => 'agora';

  @override
  String shiftCountrySpoken(String side, String code) {
    return '$side: país $code. Alterar';
  }

  @override
  String shiftDateSpoken(String side, String date, String time) {
    return '$side: $date, $time. Alterar';
  }

  @override
  String get shiftDriving => 'Condução';

  @override
  String get shiftPerDay => 'No dia';

  @override
  String get shiftLiveContinuous => 'calculada pelas pausas';

  @override
  String get shiftRestNone => 'Não iniciado';

  @override
  String get shiftRestDaily => 'Diário';

  @override
  String get shiftRestWeekly => 'Semanal';

  @override
  String get shiftSplit => 'Repouso repartido 3 + 9';

  @override
  String get shiftSplitHint => 'Primeiro 3 h, depois 9 h';

  @override
  String shiftRestUntilNext(String when) {
    return 'Até ao início do turno: $when';
  }

  @override
  String get shiftRestAutoHint => 'Dura até ao início do turno seguinte';

  @override
  String get shiftRestCountsWeekly =>
      'A partir de 24 h o repouso conta como semanal';

  @override
  String get shiftNotesHint => 'Por exemplo: ferry, espera pela carga';

  @override
  String get shiftDelete => 'Eliminar turno';

  @override
  String get shiftDeleteTitle => 'Eliminar o turno?';

  @override
  String get shiftDeleteManual => 'O turno será eliminado do registo.';

  @override
  String get shiftDeleteRecorded =>
      'Todos os registos de atividades deste turno serão eliminados. Não é possível anular.';

  @override
  String get shiftErrStartCountry => 'Escolha o país de início do turno';

  @override
  String get shiftErrEndCountry => 'Indique o país de fim do turno';

  @override
  String get shiftErrEndBeforeStart => 'O fim do turno é anterior ao início';

  @override
  String get shiftErrFuture => 'A hora do turno não pode estar no futuro';

  @override
  String get shiftErrTooLong => 'Turno com mais de 30 h — verifique as datas';

  @override
  String get shiftErrDrivingTooLong => 'Condução mais longa do que o turno';

  @override
  String get shiftErrContinuous =>
      'Condução sem pausa mais longa do que a diária';

  @override
  String shiftErrOverlap(String range) {
    return 'Sobrepõe-se ao turno $range';
  }

  @override
  String get shiftErrNotLast =>
      'Há outros turnos depois deste — não pode estar em curso';

  @override
  String get shiftSaveFailed => 'Não foi possível guardar. Tente novamente.';

  @override
  String get shiftSavedViolations => 'Turno guardado. Há infrações';

  @override
  String get shiftSavedViolationsText =>
      'Verifique as horas. Se estiver tudo certo, as infrações aparecerão no registo e no relatório.';

  @override
  String get gotIt => 'Entendi';

  @override
  String get shiftLiveHint =>
      'O turno segue os registos de atividades: alterar o início, o fim ou a condução desloca os próprios registos.';

  @override
  String get shiftConvertHint =>
      'Hora, condução ou repouso alterados — o turno será guardado como entrada manual em vez dos registos de atividades.';

  @override
  String shiftEndNowHint(String time) {
    return 'O turno termina às $time, depois começa o repouso.';
  }

  @override
  String get shiftResumeHint =>
      'O repouso após o turno será eliminado — o turno continua.';

  @override
  String shiftOngoingHint(String time, String mode) {
    return 'O turno passará a ser o atual e continuará no ecrã inicial a partir das $time. Atividade «$mode» — se agora for outra, mude-a lá.';
  }

  @override
  String get shiftUnsavedTitle => 'Guardar as alterações?';

  @override
  String get shiftUnsavedText =>
      'As alterações a este turno ainda não foram guardadas.';

  @override
  String get shiftDiscard => 'Não guardar';

  @override
  String get shiftDateTimeTitle => 'Data e hora do turno';

  @override
  String driveEditSubtitle(String date) {
    return 'Correção manual · $date';
  }

  @override
  String get driveEditComputed => 'Calculado pela aplicação';

  @override
  String driveEditDiff(String diff) {
    return '$diff em relação ao cálculo.';
  }

  @override
  String get driveEditNoChange => 'Tempo sem alterações.';

  @override
  String get driveEditHint =>
      'Use se a atividade foi mudada na hora errada — os limites serão recalculados.';

  @override
  String get driveEditNoDrive =>
      'Ainda não há condução no turno atual — nada a corrigir.';

  @override
  String get breakCorrection => 'Correção';

  @override
  String get breakCurrentDuration => 'Pausa atual';

  @override
  String get breakLastDuration => 'Última pausa';

  @override
  String get breakNoBreak => 'Ainda não há pausa no turno — nada a corrigir.';

  @override
  String get breakEditHint =>
      'O tempo é retirado do registo vizinho — os limites serão recalculados.';

  @override
  String get workdayChangeStart => 'Alterar início do turno';

  @override
  String get weeklyAddManually => 'Indicar manualmente';

  @override
  String get exportPeriod => 'Período';

  @override
  String get exportWeek => 'Esta semana';

  @override
  String get exportTwoWeeks => '2 semanas';

  @override
  String get exportDays28 => '28 dias';

  @override
  String get exportCustom => 'Período próprio';

  @override
  String get exportFrom => 'De';

  @override
  String get exportTo => 'Até';

  @override
  String exportFromDay(String date) {
    return 'De $date';
  }

  @override
  String exportToDay(String date) {
    return 'Até $date';
  }

  @override
  String get exportFormat => 'Formato';

  @override
  String get exportPdf => 'PDF · para fiscalização';

  @override
  String get exportCsv => 'CSV · tabela';

  @override
  String get exportPdfHint =>
      'Não é um documento oficial: o relatório não substitui os dados do tacógrafo nem do cartão de condutor.';

  @override
  String get exportCsvHint =>
      'Registos de atividades por linhas, hora em UTC — para Excel e programas de gestão.';

  @override
  String get exportLanguage => 'Idioma do relatório';

  @override
  String get exportNotes => 'Países e notas';

  @override
  String get exportCreate => 'Criar relatório';

  @override
  String exportCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count turnos',
      one: '$count turno',
    );
    return '$_temp0 no relatório';
  }

  @override
  String get exportEmpty => 'Não há turnos no período escolhido.';

  @override
  String get exportFailed =>
      'Não foi possível criar o relatório. Tente novamente.';

  @override
  String exportRangeSpoken(String from, String to) {
    return 'Período de $from a $to';
  }

  @override
  String get reportTitle => 'Relatório dos tempos de condução e repouso';

  @override
  String get reportSubtitle => 'Regulamento (CE) n.º 561/2006 e Acordo AETR';

  @override
  String get reportDriver => 'Condutor';

  @override
  String get reportCard => 'Cartão de condutor';

  @override
  String get reportVehicle => 'Matrícula';

  @override
  String get reportCompany => 'Transportador';

  @override
  String get reportPeriod => 'Período';

  @override
  String get reportGenerated => 'Criado';

  @override
  String reportTimezone(String zone) {
    return 'Horas no fuso horário do telemóvel ($zone). Dias e semanas do relatório em UTC, a semana começa à segunda-feira às 00:00, como no tacógrafo.';
  }

  @override
  String get reportDate => 'Data';

  @override
  String get reportStart => 'Início';

  @override
  String get reportEnd => 'Fim';

  @override
  String get reportCountries => 'Países';

  @override
  String get reportDriving => 'Condução';

  @override
  String get reportWork => 'Trabalho';

  @override
  String get reportAvailability => 'Disp.';

  @override
  String get reportBreaks => 'Pausas';

  @override
  String get reportSpan => 'Turno';

  @override
  String get reportRestAfter => 'Repouso após';

  @override
  String get reportNotes => 'Notas';

  @override
  String reportWeek(String range) {
    return 'Semana $range';
  }

  @override
  String reportWeekTotal(String driving, String fortnight) {
    return 'Total: condução $driving de 56 h · em 2 semanas $fortnight de 90 h';
  }

  @override
  String get reportViolations => 'Infrações';

  @override
  String get reportNoViolations => 'Segundo o registo, não há infrações.';

  @override
  String reportViolationDrive(String date, String time) {
    return '$date: condução diária $time — mais de 10 h';
  }

  @override
  String reportViolationSpan(String date, String time, int limit) {
    return '$date: dia de trabalho $time — mais de $limit h';
  }

  @override
  String reportViolationRest(String date, String time) {
    return '$date: repouso após o turno $time — insuficiente';
  }

  @override
  String reportViolationWeek(String range, String time) {
    return 'Semana $range: condução $time — mais de 56 h';
  }

  @override
  String reportViolationFortnight(String range, String time) {
    return 'Semana $range: em duas semanas $time — mais de 90 h';
  }

  @override
  String get reportMarks => 'Sinais';

  @override
  String get reportMarkWarn =>
      '! — condução alargada para 10 h, dia de trabalho acima de 13 h ou repouso reduzido';

  @override
  String get reportMarkBad => '!! — infração';

  @override
  String get reportMarkManual => '* — turno introduzido manualmente em totais';

  @override
  String get reportDisclaimer =>
      'O relatório baseia-se nos registos do condutor na aplicação TachoGo. Não é um documento oficial: não substitui os dados do tacógrafo nem do cartão de condutor.';

  @override
  String get reportSignature => 'Assinatura do condutor';

  @override
  String reportPage(int page, int pages) {
    return 'Pág. $page de $pages';
  }

  @override
  String get openSystemSettings => 'Abrir definições';

  @override
  String get settingsGeneral => 'Geral';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsLanguageSystem => 'Como no telemóvel';

  @override
  String get settingsTheme => 'Aspeto';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Escuro';

  @override
  String get settingsRules => 'Regras';

  @override
  String get settingsTachograph => 'Tacógrafo do veículo';

  @override
  String get tachographDigital => 'Digital';

  @override
  String get tachographAnalog => 'Analógico';

  @override
  String get settingsMobility => 'Pacote de mobilidade';

  @override
  String get settingsMobilityHint =>
      'Dois repousos semanais reduzidos seguidos no transporte internacional';

  @override
  String get settingsCrew => 'Tripulação múltipla';

  @override
  String get settingsCrewHint =>
      'Repouso diário de 9 h nas 30 h após o início do turno';

  @override
  String get settingsNotifications => 'Notificações';

  @override
  String get settingsWarnLead => 'Avisar dos limites';

  @override
  String get settingsWarnLeadHint => 'Pausa, fim do dia, condução';

  @override
  String get settingsWarnLeadGroup => 'Avisar com antecedência';

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
  String get notifyShiftEnd => 'Fim do dia de trabalho';

  @override
  String get notifyShiftEndHint => 'Repouso diário e semanal';

  @override
  String get notifyDriving => 'Limite de condução';

  @override
  String get notifyCard => 'Descarga do cartão';

  @override
  String get notifyCardHint => 'De 28 em 28 dias';

  @override
  String get notifyCardLead => 'Com antecedência';

  @override
  String get notifyCardLeadGroup =>
      'Aviso de descarga do cartão com antecedência';

  @override
  String leadDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dias',
      one: '$days dia',
    );
    return '$_temp0';
  }

  @override
  String get notifyAllow => 'Permitir notificações';

  @override
  String get notifyDenied => 'As notificações estão bloqueadas no telemóvel';

  @override
  String get notifyAllowed => 'Notificações permitidas';

  @override
  String get notifyExact => 'Hora exata das notificações';

  @override
  String get notifyExactHint =>
      'Permita «Alarmes e lembretes» — caso contrário o telemóvel pode atrasar o aviso';

  @override
  String get notifyChannelLimits => 'Limites e infrações';

  @override
  String get notifyChannelLimitsHint =>
      'Pausa, fim do dia de trabalho, condução, repouso semanal, cartão';

  @override
  String get notifyChannelRest => 'Repouso cumprido';

  @override
  String get notifyChannelRestHint =>
      'Pausa cumprida, repouso diário e semanal cumpridos';

  @override
  String get notifyBreakTakenTitle => 'Pausa cumprida';

  @override
  String notifyBreakTakenText(int required, String time) {
    return 'Pausa de $required min cumprida. Pode conduzir $time até à próxima pausa.';
  }

  @override
  String get notifyDailyRestTakenTitle => 'Repouso diário cumprido';

  @override
  String notifyDailyRestTakenText(String limit) {
    return 'Repouso regular de $limit — pode começar o turno.';
  }

  @override
  String get notifyWeeklyRestTakenTitle => 'Repouso semanal cumprido';

  @override
  String notifyWeeklyRestTakenText(String limit) {
    return 'Repouso regular de $limit — pode começar uma nova semana de trabalho.';
  }

  @override
  String get serviceChannel => 'Deteção automática da condução';

  @override
  String get serviceChannelHint =>
      'Atividade atual e contadores enquanto a deteção automática funciona';

  @override
  String get serviceStarted => 'Deteção automática da condução ativada';

  @override
  String serviceModeTitle(String mode, String time) {
    return '$mode · $time';
  }

  @override
  String get serviceTeamTitle => 'O veículo está em andamento';

  @override
  String serviceTeamText(String time) {
    return 'Está a conduzir? Condução desde as $time';
  }

  @override
  String get serviceSuggestTitle => 'Parece que está a conduzir';

  @override
  String serviceSuggestText(String time) {
    return 'Começar a condução desde as $time? O repouso será interrompido';
  }

  @override
  String serviceDriving(String untilBreak, String dayLeft) {
    return 'Até à pausa $untilBreak · hoje faltam $dayLeft';
  }

  @override
  String serviceDrivingOver(String time) {
    return 'Pausa necessária: excesso de $time';
  }

  @override
  String serviceBreakLeft(String time) {
    return 'Até à pausa completa $time';
  }

  @override
  String serviceBreakDone(String time) {
    return 'Pausa cumprida, pode conduzir $time';
  }

  @override
  String serviceWorkday(String time, String limit) {
    return 'Dia de trabalho $time de $limit';
  }

  @override
  String serviceRestLeft(String limit, String time) {
    return 'Até ao repouso completo de $limit: $time';
  }

  @override
  String get serviceDailyRestDone => 'Repouso diário regular cumprido';

  @override
  String get serviceWeeklyRestDone => 'Repouso semanal regular cumprido';

  @override
  String get serviceNotStartedText =>
      'A condução ativa-se sozinha quando o veículo arrancar';

  @override
  String get serviceNoModeText => 'Abra o TachoGo e escolha uma atividade';

  @override
  String get autoTitle => 'Deteção automática da condução';

  @override
  String get autoSwitch => 'Detetar a condução por GPS';

  @override
  String get autoSwitchHint =>
      'Arranca — condução, para — outro trabalho. Só é precisa a velocidade: as coordenadas não são guardadas.';

  @override
  String get autoAfterStop => 'Depois de parar';

  @override
  String get autoAfterStopHint => 'Após 3 minutos parado';

  @override
  String get autoStartFromRest => 'Condução logo após o repouso';

  @override
  String get autoStartFromRestHint =>
      'Caso contrário, a aplicação pergunta primeiro: podia ir como passageiro';

  @override
  String get autoBattery => 'Poupança de bateria';

  @override
  String get autoBatteryLimited =>
      'Pode parar a deteção. Retire o TachoGo da lista de poupança';

  @override
  String get autoBatteryOk => 'Não impede o funcionamento em segundo plano';

  @override
  String get autoAutostart => 'Arranque automático e segundo plano';

  @override
  String get autoAutostartHint =>
      'Xiaomi, Huawei, Honor, Oppo, Vivo, Samsung: permita, caso contrário o telemóvel para a deteção';

  @override
  String get autoBlockedService =>
      'A localização está desligada no telemóvel. Ligue-a para detetar a condução.';

  @override
  String get autoBlockedDenied =>
      'Sem acesso à localização não é possível detetar a condução. A aplicação só precisa da velocidade, as coordenadas não são guardadas.';

  @override
  String get autoBlockedForever =>
      'O acesso à localização está bloqueado. Permita-o nas definições do telemóvel: Localização → «Durante a utilização da app».';

  @override
  String get autoNoAccess =>
      'Sem acesso à localização — a deteção não funciona. Permita-o nas definições do telemóvel.';

  @override
  String get autoEnable => 'Ativar a deteção da condução';

  @override
  String get autoEnabled => 'Deteção da condução ativada';

  @override
  String get settingsData => 'Dados';

  @override
  String get settingsExport => 'Exportar relatório';

  @override
  String get settingsExportFormats => 'PDF · CSV';

  @override
  String get settingsAnalytics => 'Estatísticas anónimas';

  @override
  String get settingsAnalyticsHint =>
      'Que ecrãs os condutores abrem — para melhorar a aplicação. Sem coordenadas, nomes nem números de cartão.';

  @override
  String get settingsClear => 'Apagar todos os dados';

  @override
  String get clearTitle => 'Apagar todos os dados?';

  @override
  String get clearText =>
      'Serão eliminados o registo de atividades, os turnos, os países, as notas e as descargas do cartão. Não é possível anular. As definições mantêm-se.';

  @override
  String get clearConfirm => 'Apagar';

  @override
  String get clearDone => 'Dados eliminados';

  @override
  String onbStep(int step, int count) {
    return 'Passo $step de $count';
  }

  @override
  String get onbWelcomeTitle => 'O tempo ao volante sob controlo';

  @override
  String get onbWelcomeText =>
      'Calculamos a condução, as pausas e o repouso segundo as regras UE 561/2006 e AETR e avisamos dos limites com antecedência.';

  @override
  String get onbStart => 'Começar';

  @override
  String get onbNext => 'Seguinte';

  @override
  String get onbDone => 'Concluído';

  @override
  String get onbModesTitle => 'Quatro atividades — como no tacógrafo';

  @override
  String get onbModesText =>
      'Mude a atividade com os botões do ecrã inicial. Os contadores funcionam sozinhos — mesmo com a aplicação fechada.';

  @override
  String get onbModeDriving =>
      'Ao volante. Contamos a condução sem pausa, diária e semanal.';

  @override
  String get onbModeWork => 'Carga, verificação do veículo, documentos.';

  @override
  String get onbModeAvailability =>
      'Espera: fila de carga, fronteira, segundo condutor em viagem.';

  @override
  String get onbModeRest => 'Pausas e repouso. «Terminar o dia» fecha o turno.';

  @override
  String get onbSetupTitle => 'Vamos ajustar para si';

  @override
  String get onbSetupText =>
      'Tudo isto pode ser alterado depois nas definições.';

  @override
  String get onbMobilityHint => 'Ative se faz viagens internacionais';

  @override
  String onbNotifyText(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutos',
      one: '$minutes minuto',
    );
    return 'Avisamos $_temp0 antes da pausa e do fim do dia de trabalho — mesmo com a aplicação fechada.';
  }

  @override
  String get onbAutoText =>
      'Arranca — a aplicação ativa a condução, para — outro trabalho. Depois do repouso pergunta primeiro. Só é precisa a velocidade do GPS: as coordenadas não são guardadas nem enviadas.';

  @override
  String get onbAutoLater => 'Pode ativar mais tarde nas definições.';

  @override
  String languageButton(String language) {
    return 'Idioma: $language';
  }

  @override
  String get settingsVehicle => 'Veículo';

  @override
  String get vehicleTruckOrBus => 'Camião ou autocarro';

  @override
  String get vehicleVan => 'Carrinha 2,5–3,5 t';

  @override
  String settingsVanHint(String date) {
    return 'Regras — desde $date no transporte internacional e na cabotagem por conta de outrem';
  }

  @override
  String onbVanText(String date) {
    return 'As regras da UE para carrinhas aplicam-se desde $date — no transporte internacional e na cabotagem por conta de outrem. A carrinha tem um tacógrafo inteligente de segunda geração e o condutor tem cartão.';
  }

  @override
  String get onbRulesTitle => 'As regras principais';

  @override
  String get onbRulesText =>
      'Iguais para camiões, autocarros e carrinhas. A aplicação calcula-as sozinha e avisa com antecedência.';

  @override
  String get onbRulesMore =>
      'Todas as regras explicadas — «Mais» → «Guia e regras».';

  @override
  String get guideTitle => 'Guia e regras';

  @override
  String get guideHowTo => 'Como usar';

  @override
  String get guideStep1 =>
      'Mude a atividade com os botões do ecrã inicial: condução, repouso, trabalho ou disponibilidade.';

  @override
  String get guideStep2 =>
      'Indique o país de início e de fim do turno — como no tacógrafo.';

  @override
  String get guideStep3 =>
      'Vigie os limites. A aplicação avisa com antecedência da pausa e do fim do dia. Qualquer tempo pode ser corrigido manualmente.';

  @override
  String get guideRules => 'Regras UE 561/2006 e AETR';

  @override
  String get guideContinuous => 'Condução sem pausa';

  @override
  String guideContinuousText(String full, String first, String second) {
    return 'Depois, uma pausa de $full. Pode ser repartida: primeiro $first, depois $second.';
  }

  @override
  String get guideDailyDriving => 'Condução por dia';

  @override
  String guideDailyDrivingText(String extended) {
    return 'Duas vezes por semana é permitido até $extended.';
  }

  @override
  String get guideWeeklyDriving => 'Condução por semana';

  @override
  String guideWeeklyDrivingText(String fortnight) {
    return 'Em quaisquer duas semanas seguidas — no máximo $fortnight.';
  }

  @override
  String get guideDailyRest => 'Repouso diário';

  @override
  String guideDailyRestText(String reduced, String first, String second) {
    return 'Até três vezes entre repousos semanais pode ser reduzido a $reduced. Opção repartida — $first + $second.';
  }

  @override
  String get guideWorkday => 'Dia de trabalho';

  @override
  String guideWorkdayText(String window, String regular, String reduced) {
    return 'O repouso tem de terminar nas $window após o início do turno: $regular com repouso regular, $reduced com reduzido.';
  }

  @override
  String guideWorkdaySpoken(int first, int second) {
    String _temp0 = intl.Intl.pluralLogic(
      second,
      locale: localeName,
      other: '$second horas',
      one: '$second hora',
    );
    return '$first ou $_temp0';
  }

  @override
  String get guideWeeklyRest => 'Repouso semanal';

  @override
  String guideWeeklyRestText(String reduced) {
    return 'Reduzido — $reduced, com compensação até ao fim da terceira semana. O repouso regular não pode ser gozado na cabina.';
  }

  @override
  String get guideWorkWeek => 'Semana de trabalho';

  @override
  String guideWorkWeekText(String period) {
    return 'O repouso semanal começa o mais tardar após seis períodos de $period desde o anterior.';
  }

  @override
  String get guideCard => 'Cartão de condutor';

  @override
  String guideCardText(String days) {
    return 'Os dados do cartão têm de ser descarregados pelo menos a cada $days.';
  }

  @override
  String get guideModes => 'Cores e ícones';

  @override
  String get guideNewbie => 'Primeira vez com tacógrafo';

  @override
  String get guideNewbieCard =>
      'O cartão fica no tacógrafo durante todo o turno';

  @override
  String get guideNewbieCardText =>
      'Insira o cartão no início do turno e retire-o no fim. O que fez sem cartão — trabalho, disponibilidade ou repouso — introduza manualmente na inserção seguinte.';

  @override
  String get guideNewbieApp => 'A aplicação não substitui o tacógrafo';

  @override
  String get guideNewbieAppText =>
      'O registo oficial está no tacógrafo. Mude a atividade lá e aqui — assim os contadores coincidem.';

  @override
  String get guideNewbieBreak => 'Pausa é só repouso';

  @override
  String get guideNewbieBreakText =>
      'Durante a pausa não pode conduzir nem trabalhar. Carga e descarga são outro trabalho, não pausa.';

  @override
  String get guideNewbieRestPlace => 'Onde repousar';

  @override
  String get guideNewbieRestPlaceText =>
      'O repouso diário e o semanal reduzido podem ser gozados no veículo, se tiver beliche e estiver parado. O repouso semanal regular e a compensação — só fora do veículo.';

  @override
  String get guideNewbieCountry => 'Países';

  @override
  String get guideNewbieCountryText =>
      'O país é introduzido no tacógrafo no início e no fim do turno. O tacógrafo inteligente de segunda geração regista sozinho a passagem da fronteira; nos mais antigos o país é introduzido na primeira paragem após a fronteira.';

  @override
  String guideVanText(String date) {
    return 'As regras são as mesmas dos camiões. Desde $date aplicam-se a carrinhas com mais de 2,5 t incluindo o reboque — no transporte internacional de mercadorias e na cabotagem. Uma carrinha assim tem um tacógrafo inteligente de segunda geração e o condutor tem cartão.';
  }

  @override
  String get guideVanCheck => 'As regras aplicam-se à sua viagem?';

  @override
  String get guideVanTrip => 'Viagem';

  @override
  String get guideVanTripHint =>
      'Cabotagem — transporte dentro de outro país da UE';

  @override
  String get guideVanDomestic => 'Nacional';

  @override
  String get guideVanCrossBorder => 'Para o estrangeiro ou cabotagem';

  @override
  String get guideVanCarriage => 'Transporte';

  @override
  String get guideVanHire => 'Por conta de outrem';

  @override
  String get guideVanOwn => 'Por conta própria';

  @override
  String get guideVanNonCommercial => 'Não comercial';

  @override
  String get guideVanCarriageHint =>
      'Conta própria — mercadorias, materiais ou ferramentas da sua empresa. Não comercial — sem pagamento nem rendimento, sem ligação ao trabalho';

  @override
  String get guideVanMain => 'Conduzir é o seu trabalho principal?';

  @override
  String get yes => 'Sim';

  @override
  String get no => 'Não';

  @override
  String get guideVanApplies => 'As regras aplicam-se';

  @override
  String get guideVanNotApply => 'As regras não se aplicam';

  @override
  String get guideVanAppliesText =>
      'São precisos tacógrafo e cartão de condutor, os limites são os de um camião.';

  @override
  String guideVanNotYetText(String date) {
    return 'Até $date as carrinhas não estavam abrangidas pelas regras.';
  }

  @override
  String get guideVanDomesticText =>
      'O regulamento da UE não se aplica a carrinhas no transporte nacional. Consulte as regras do seu país.';

  @override
  String get guideVanOwnText =>
      'Exceção: transporte para necessidades próprias, e conduzir não é o trabalho principal.';

  @override
  String get guideVanNonCommercialText =>
      'Exceção: transporte sem pagamento nem rendimento, sem ligação ao trabalho.';

  @override
  String guideArticle(String article) {
    return 'Regulamento 561/2006, art. $article';
  }

  @override
  String get guideVanNotes =>
      'Com o reboque acima de 3,5 t — regras como para camiões, também no transporte nacional. Viagem parcialmente fora da UE — para a Ucrânia, a Moldávia, a Turquia, os Balcãs — confirme com o transportador: não há uma interpretação única.';

  @override
  String get guideDisclaimer =>
      'O TachoGo ajuda a planear o tempo, mas não substitui o tacógrafo nem é aconselhamento jurídico. Texto oficial das regras — Regulamento (CE) n.º 561/2006 e Acordo AETR.';

  @override
  String get moreAbout => 'Sobre a aplicação';

  @override
  String get moreDisclaimer =>
      'O TachoGo ajuda a planear os tempos de condução e repouso, mas não substitui o tacógrafo nem é aconselhamento jurídico.';

  @override
  String get problemTitle => 'Comunicar um problema';

  @override
  String get problemHint =>
      'Versão beta: o relatório vai para os criadores da aplicação';

  @override
  String get problemText =>
      'O relatório contém a versão da aplicação, o modelo do telemóvel, as definições, as permissões, o calendário de notificações e as entradas do registo dos últimos dois dias. Não contém coordenadas. Escolha para onde enviar — e-mail ou mensagens — e descreva o que aconteceu.';

  @override
  String get problemSend => 'Enviar';

  @override
  String get problemSubject => 'TachoGo — problema na versão beta';

  @override
  String get problemPrompt => 'O que aconteceu e quando (por palavras suas):';

  @override
  String get problemFailed =>
      'Não foi possível abrir o envio. Tente novamente.';
}
