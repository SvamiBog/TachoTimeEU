/// Reads a driver card download file (.DDD) — the activity log only, without
/// the name, card number or other personal data. Used for fixtures from real
/// tachographs (ENG-20) and to compare the app's log with the card (DEV-03),
/// `docs/testing.md`. Not part of the app: importing .DDD is open question 10
/// of the PRD.
///
/// Format — Regulation (EU) 2016/799, Annex 1C:
/// - card download file (Appendix 7, "Card downloading"): consecutive blocks
///   "FID (2 bytes) + appendix (1 byte) + length (2 bytes) + data". Appendix
///   00 is first generation data, 01 its signature, 02 and 03 the same for the
///   second generation;
/// - EF Driver_Activity_Data (FID 0504, Appendix 1, CardDriverActivity):
///   pointers to the oldest and the newest record and a ring buffer of daily
///   records (CardActivityDailyRecord);
/// - daily record: length of the previous and of this record, date (TimeReal,
///   seconds since 1970 UTC), presence counter, distance of the day and
///   activity changes of 2 bytes each (ActivityChangeInfo,
///   'scpaattttttttttt'B): s — slot (driver / co-driver), c — crew (card
///   inserted) or "activity known, entered manually" (card not inserted), p —
///   card not inserted, aa — activity (00 rest, 01 availability, 10 work,
///   11 driving), t — minute of the day UTC;
/// - EF Specific_Conditions (FID 0522): out of scope (OUT) and ferry / train.
///
/// All numbers are big-endian. Checked on files built to the specification
/// (`test/tool/ddd_test.dart`); verify against analysis software on the first
/// real file.
library;

import 'dart:typed_data';

import 'package:tacho_engine/tacho_engine.dart';

/// FIDs of the driver card elementary files the tool needs.
abstract final class CardFile {
  static const driverActivity = 0x0504;
  static const cardDownload = 0x050E;
  static const specificConditions = 0x0522;
}

/// A block of the download file: a card elementary file or its signature.
typedef DddBlock = ({int fid, int appendix, Uint8List data});

/// Блоки файла выгрузки по порядку.
List<DddBlock> readBlocks(Uint8List bytes) {
  final blocks = <DddBlock>[];
  var i = 0;
  while (i < bytes.length) {
    if (bytes.length - i < 5) {
      throw FormatException('Обрезанный заголовок блока', bytes, i);
    }
    final fid = bytes[i] << 8 | bytes[i + 1];
    final appendix = bytes[i + 2];
    final length = bytes[i + 3] << 8 | bytes[i + 4];
    if (appendix > 3) {
      throw FormatException(
        'Блок ${_hex(fid)}: приложение $appendix — это не выгрузка карты',
        bytes,
        i,
      );
    }
    if (i + 5 + length > bytes.length) {
      throw FormatException('Блок ${_hex(fid)} длиннее файла', bytes, i);
    }
    blocks.add((
      fid: fid,
      appendix: appendix,
      data: Uint8List.sublistView(bytes, i + 5, i + 5 + length),
    ));
    i += 5 + length;
  }
  return blocks;
}

String _hex(int fid) => fid.toRadixString(16).padLeft(4, '0').toUpperCase();

/// The tachograph slot the card was in.
enum CardSlot { driver, coDriver }

/// An activity change in a daily record of the card.
class ActivityChange {
  const new({
    required this.minute,
    required this.slot,
    required this.inserted,
    required this.crew,
    required this.known,
    required this.mode,
  });

  /// Разбор двух байт 'scpaattttttttttt'B.
  factory decode(int value) {
    final inserted = value & 0x2000 == 0;
    final flag = value & 0x4000 != 0;
    return ActivityChange(
      minute: value & 0x07FF,
      slot: value & 0x8000 == 0 ? CardSlot.driver : CardSlot.coDriver,
      inserted: inserted,
      crew: inserted && flag,
      known: inserted || flag,
      mode: const [
        DriverMode.rest,
        DriverMode.availability,
        DriverMode.otherWork,
        DriverMode.driving,
      ][value >> 11 & 0x3],
    );
  }

  /// Минута суток UTC, с которой действует режим.
  final int minute;
  final CardSlot slot;

  /// Карта была вставлена в тахограф.
  final bool inserted;

  /// Экипаж из двух водителей (при вставленной карте).
  final bool crew;

  /// Режим известен: карта вставлена или водитель ввёл его вручную.
  final bool known;
  final DriverMode mode;
}

/// A daily record of the card.
class CardDay {
  const new({
    required this.date,
    required this.presenceCounter,
    required this.distanceKm,
    required this.changes,
  });

  /// Сутки: 00:00 UTC.
  final DateTime date;
  final int presenceCounter;
  final int distanceKm;
  final List<ActivityChange> changes;
}

/// A specific condition: out of the regulation's scope, or ferry / train.
enum SpecificCondition { outOfScopeBegin, outOfScopeEnd, ferryBegin, ferryEnd }

/// A specific condition and when it was recorded.
typedef SpecificConditionRecord = ({DateTime at, SpecificCondition type});

/// A driver card from a download file: daily activity records and specific
/// conditions. The second generation is used when the file has both.
class DriverCard {
  const new({
    required this.generation,
    required this.days,
    required this.conditions,
    required this.lastDownload,
  });

  factory parse(Uint8List bytes) {
    final blocks = readBlocks(bytes);
    Uint8List? data(int fid) {
      Uint8List? found;
      for (final b in blocks) {
        if (b.fid != fid || b.appendix.isOdd) continue;
        // Второе поколение (02) важнее первого (00)
        if (found == null || b.appendix == 2) found = b.data;
      }
      return found;
    }

    final activity = data(CardFile.driverActivity);
    if (activity == null) {
      throw const FormatException(
        'В файле нет журнала режимов (EF 0504): это не выгрузка карты водителя',
      );
    }
    final generation = blocks.any((b) => b.appendix >= 2) ? 2 : 1;
    final download = data(CardFile.cardDownload);
    return DriverCard(
      generation: generation,
      days: readActivity(activity),
      conditions: readConditions(
        data(CardFile.specificConditions) ?? Uint8List(0),
        generation: generation,
      ),
      lastDownload: download == null || download.length < 4
          ? null
          : _time(ByteData.sublistView(download).getUint32(0)),
    );
  }

  final int generation;
  final List<CardDay> days;
  final List<SpecificConditionRecord> conditions;

  /// Последнее считывание карты по данным самой карты.
  final DateTime? lastDownload;
}

DateTime? _time(int seconds) => seconds == 0
    ? null
    : DateTime.fromMillisecondsSinceEpoch(seconds * 1000, isUtc: true);

/// Суточные записи из EF Driver_Activity_Data, от старых к новым.
List<CardDay> readActivity(Uint8List file) {
  if (file.length < 4) {
    throw const FormatException('EF 0504 короче указателей');
  }
  final head = ByteData.sublistView(file);
  final oldest = head.getUint16(0);
  final newest = head.getUint16(2);
  final ring = Uint8List.sublistView(file, 4);
  final size = ring.length;
  if (size == 0) return const [];
  if (oldest >= size || newest >= size) {
    throw FormatException('Указатели $oldest / $newest за буфером $size');
  }
  int byte(int i) => ring[(i % size + size) % size];
  int u16(int i) => byte(i) << 8 | byte(i + 1);
  int u32(int i) => u16(i) << 16 | u16(i + 2);

  final days = <CardDay>[];
  var p = oldest;
  // Каждая запись — не меньше 12 байт: больше записей в буфере не бывает
  for (var guard = 0; guard <= size ~/ 12; guard++) {
    final length = u16(p + 2);
    if (length == 0 && days.isEmpty) return const []; // карта без записей
    if (length < 12 || (length - 12).isOdd || length > size) {
      throw FormatException('Запись по смещению $p: длина $length');
    }
    final date = _time(u32(p + 4));
    if (date == null) throw FormatException('Запись по смещению $p без даты');
    final bcd = u16(p + 8);
    days.add(
      CardDay(
        date: date,
        presenceCounter:
            (bcd >> 12 & 0xF) * 1000 +
            (bcd >> 8 & 0xF) * 100 +
            (bcd >> 4 & 0xF) * 10 +
            (bcd & 0xF),
        distanceKm: u16(p + 10),
        changes: [
          for (var c = p + 12; c < p + length; c += 2)
            ActivityChange.decode(u16(c)),
        ],
      ),
    );
    if (p == newest) {
      days.sort((a, b) => a.date.compareTo(b.date));
      return days;
    }
    p = (p + length) % size;
  }
  throw const FormatException('Кольцевой буфер не дошёл до новой записи');
}

/// Особые условия из EF Specific_Conditions: по 5 байт — время и вид.
/// Пустые записи (время 0) пропускаются.
List<SpecificConditionRecord> readConditions(
  Uint8List file, {
  required int generation,
}) {
  final data = ByteData.sublistView(file);
  final records = <SpecificConditionRecord>[];
  for (var i = 0; i + 5 <= file.length; i += 5) {
    final at = _time(data.getUint32(i));
    if (at == null) continue;
    final type = switch (file[i + 4]) {
      1 => SpecificCondition.outOfScopeBegin,
      2 => SpecificCondition.outOfScopeEnd,
      // Первое поколение: одна отметка «паром / поезд» — начало
      3 => SpecificCondition.ferryBegin,
      4 when generation == 2 => SpecificCondition.ferryEnd,
      _ => null,
    };
    if (type != null) records.add((at: at, type: type));
  }
  return records..sort((a, b) => a.at.compareTo(b.at));
}

/// A stretch of the card's log: an activity or "unknown" (no card, nothing
/// entered manually).
typedef CardPeriod = ({
  DateTime start,
  DateTime end,
  DriverMode? mode,
  bool crew,
  CardSlot slot,
});

/// Журнал карты отрезками от первой до последней суточной записи. Сутки
/// без записи — «неизвестно». Последний режим идёт до конца суток или до
/// [until], если он раньше.
List<CardPeriod> cardPeriods(List<CardDay> days, {DateTime? until}) {
  final result = <CardPeriod>[];
  void add(CardPeriod p) {
    if (!p.end.isAfter(p.start)) return;
    final last = result.isEmpty ? null : result.last;
    if (last != null &&
        last.end == p.start &&
        last.mode == p.mode &&
        last.crew == p.crew &&
        last.slot == p.slot) {
      result[result.length - 1] = (
        start: last.start,
        end: p.end,
        mode: p.mode,
        crew: p.crew,
        slot: p.slot,
      );
    } else {
      result.add(p);
    }
  }

  for (final day in days) {
    final changes = [...day.changes]
      ..sort((a, b) => a.minute.compareTo(b.minute));
    final dayEnd = day.date.add(const Duration(days: 1));
    // Сутки без записи перед этими — неизвестно
    if (result.isNotEmpty && result.last.end.isBefore(day.date)) {
      add((
        start: result.last.end,
        end: day.date,
        mode: null,
        crew: false,
        slot: CardSlot.driver,
      ));
    }
    // До первого изменения суток идёт режим из прошлых суток; суток перед
    // этими нет — неизвестно. На настоящей карте первое изменение — 00:00.
    if (changes.isNotEmpty && changes.first.minute > 0) {
      final last = result.isEmpty ? null : result.last;
      final continues = last != null && last.end == day.date;
      add((
        start: day.date,
        end: day.date.add(Duration(minutes: changes.first.minute)),
        mode: continues ? last.mode : null,
        crew: continues && last.crew,
        slot: continues ? last.slot : CardSlot.driver,
      ));
    }
    for (final (i, c) in changes.indexed) {
      final start = day.date.add(Duration(minutes: c.minute));
      var end = i + 1 < changes.length
          ? day.date.add(Duration(minutes: changes[i + 1].minute))
          : dayEnd;
      if (until != null && end.isAfter(until)) end = until;
      add((
        start: start,
        end: end,
        mode: c.known ? c.mode : null,
        crew: c.crew,
        slot: c.slot,
      ));
    }
  }
  return result;
}

/// Журнал для движка: неизвестные отрезки — отдых ([unknownAsRest], как
/// считают программы анализа по умолчанию) или разрыв. Отметка «паром»
/// ставится по особым условиям второго поколения. Время — UTC, границы —
/// минуты.
List<ActivityPeriod> toEnginePeriods(
  List<CardPeriod> periods, {
  bool unknownAsRest = true,
  List<SpecificConditionRecord> conditions = const [],
  DateTime? from,
  DateTime? to,
}) {
  final ferries = <(DateTime, DateTime?)>[];
  for (final c in conditions) {
    if (c.type == SpecificCondition.ferryBegin) ferries.add((c.at, null));
    if (c.type == SpecificCondition.ferryEnd &&
        ferries.isNotEmpty &&
        ferries.last.$2 == null) {
      ferries.last = (ferries.last.$1, c.at);
    }
  }
  bool onFerry(DateTime t) => ferries.any(
    (f) => f.$2 != null && !t.isBefore(f.$1) && t.isBefore(f.$2!),
  );

  final result = <ActivityPeriod>[];
  for (final p in periods) {
    final mode = p.mode ?? (unknownAsRest ? DriverMode.rest : null);
    if (mode == null) continue;
    var start = p.start;
    var end = p.end;
    if (from != null && start.isBefore(from)) start = from;
    if (to != null && end.isAfter(to)) end = to;
    if (!end.isAfter(start)) continue;
    final ferry = onFerry(start);
    final last = result.isEmpty ? null : result.last;
    if (last != null &&
        last.end == start &&
        last.mode == mode &&
        last.ferry == ferry) {
      result[result.length - 1] = last.withEnd(end);
    } else {
      result.add(
        ActivityPeriod(mode: mode, start: start, end: end, ferry: ferry),
      );
    }
  }
  return result;
}
