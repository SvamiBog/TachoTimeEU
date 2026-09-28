// Инструмент для реальных данных Фазы 4 (tool/ddd.dart): разбор выгрузки
// карты водителя, журнал для движка, нарушения за журнал, фикстура ENG-20
// и сверка с CSV приложения (DEV-03). Файлы собираются здесь по
// Регламенту 2016/799, прил. 1C — настоящих выгрузок в репозитории нет.

import 'dart:convert';
import 'dart:typed_data';

import 'package:tacho_engine/tacho_engine.dart';
import 'package:test/test.dart';

import '../../tool/ddd.dart' as cli;
import '../../tool/src/compare.dart';
import '../../tool/src/ddd.dart';
import '../../tool/src/fixture.dart';
import '../../tool/src/violations.dart';
import '../helpers.dart';

/// Изменение режима 'scpaattttttttttt'B.
int change(
  DriverMode mode,
  int minute, {
  bool coDriver = false,
  bool crew = false,
  bool inserted = true,
  bool known = true,
}) {
  final aa = switch (mode) {
    DriverMode.rest => 0,
    DriverMode.availability => 1,
    DriverMode.otherWork => 2,
    DriverMode.driving => 3,
  };
  final c = inserted ? crew : known;
  return (coDriver ? 0x8000 : 0) |
      (c ? 0x4000 : 0) |
      (inserted ? 0 : 0x2000) |
      aa << 11 |
      minute;
}

/// Суточная запись карты: сутки, пробег, изменения режима.
typedef Day = (String date, int km, List<int> changes);

void _u16(List<int> out, int v) => out.addAll([v >> 8 & 0xFF, v & 0xFF]);
void _u32(List<int> out, int v) {
  _u16(out, v >> 16 & 0xFFFF);
  _u16(out, v & 0xFFFF);
}

/// EF Driver_Activity_Data: кольцевой буфер размера [size], первая запись
/// — со смещения [offset] (так запись переходит через конец буфера).
Uint8List activityFile(List<Day> days, {int size = 1024, int offset = 0}) {
  final ring = List<int>.filled(size, 0);
  var p = offset;
  var previous = 0;
  var newest = offset;
  for (final (i, (date, km, changes)) in days.indexed) {
    final record = <int>[];
    final length = 12 + changes.length * 2;
    _u16(record, previous);
    _u16(record, length);
    _u32(record, utc('$date 00:00').millisecondsSinceEpoch ~/ 1000);
    _u16(record, int.parse('${i + 1}', radix: 16)); // счётчик в BCD
    _u16(record, km);
    for (final c in changes) {
      _u16(record, c);
    }
    for (final (j, b) in record.indexed) {
      ring[(p + j) % size] = b;
    }
    newest = p;
    previous = length;
    p = (p + length) % size;
  }
  final out = <int>[];
  _u16(out, offset);
  _u16(out, newest);
  return Uint8List.fromList([...out, ...ring]);
}

/// Блок выгрузки: FID, приложение, длина, данные.
List<int> block(int fid, int appendix, List<int> data) {
  final out = <int>[];
  _u16(out, fid);
  out.add(appendix);
  _u16(out, data.length);
  return [...out, ...data];
}

/// Выгрузка карты: служебные файлы с подписями и журнал режимов.
Uint8List cardFile(
  Uint8List activity, {
  int generation = 1,
  List<(String, int)> conditions = const [],
  String? lastDownload,
}) {
  final data = generation == 1 ? 0 : 2;
  final conditionsData = <int>[];
  for (final (at, type) in conditions) {
    _u32(conditionsData, utc(at).millisecondsSinceEpoch ~/ 1000);
    conditionsData.add(type);
  }
  final download = <int>[];
  _u32(
    download,
    lastDownload == null ? 0 : utc(lastDownload).millisecondsSinceEpoch ~/ 1000,
  );
  return Uint8List.fromList([
    ...block(0x0002, 0, List.filled(25, 1)), // EF ICC
    ...block(0x0005, 0, List.filled(8, 2)), // EF IC
    ...block(0x0520, data, List.filled(143, 0x41)), // имя и номер карты
    ...block(0x0520, data + 1, List.filled(128, 0xEE)), // подпись
    ...block(0x050E, data, download),
    ...block(0x0504, data, activity),
    ...block(0x0504, data + 1, List.filled(128, 0xEE)),
    ...block(0x0522, data, conditionsData),
  ]);
}

void main() {
  final shift = <Day>[
    (
      '2026-09-21',
      612,
      [
        change(DriverMode.rest, 0),
        change(DriverMode.otherWork, 360), // 06:00
        change(DriverMode.driving, 375), // 06:15
        change(DriverMode.rest, 645), // 10:45
        change(DriverMode.driving, 690), // 11:30
        change(DriverMode.rest, 960), // 16:00
      ],
    ),
    ('2026-09-22', 0, [change(DriverMode.rest, 0)]),
  ];

  group('разбор выгрузки карты', () {
    test('блоки: FID, приложение и данные подряд', () {
      final blocks = readBlocks(cardFile(activityFile(shift)));
      expect(blocks.map((b) => (b.fid, b.appendix)), [
        (0x0002, 0),
        (0x0005, 0),
        (0x0520, 0),
        (0x0520, 1),
        (0x050E, 0),
        (0x0504, 0),
        (0x0504, 1),
        (0x0522, 0),
      ]);
    });

    test('обрезанный файл и чужой формат — понятная ошибка', () {
      final bytes = cardFile(activityFile(shift));
      expect(
        () => readBlocks(Uint8List.sublistView(bytes, 0, bytes.length - 3)),
        throwsFormatException,
      );
      expect(
        () => DriverCard.parse(Uint8List.fromList(utf8.encode('%PDF-1.7 …'))),
        throwsFormatException,
      );
      expect(
        () => DriverCard.parse(Uint8List.fromList(block(0x0002, 0, [1]))),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'message',
            contains('EF 0504'),
          ),
        ),
      );
    });

    test('суточные записи: дата, пробег, счётчик, режимы и слоты', () {
      final card = DriverCard.parse(
        cardFile(activityFile(shift), lastDownload: '2026-09-01 07:10'),
      );
      expect(card.generation, 1);
      expect(card.lastDownload, utc('2026-09-01 07:10'));
      expect(card.days.map((d) => (d.date, d.distanceKm, d.presenceCounter)), [
        (utc('2026-09-21 00:00'), 612, 1),
        (utc('2026-09-22 00:00'), 0, 2),
      ]);
      final first = card.days.first.changes;
      expect(first.map((c) => (c.minute, c.mode)), [
        (0, DriverMode.rest),
        (360, DriverMode.otherWork),
        (375, DriverMode.driving),
        (645, DriverMode.rest),
        (690, DriverMode.driving),
        (960, DriverMode.rest),
      ]);
      expect(first.every((c) => c.inserted && c.known), isTrue);
    });

    test('изменение режима: слот, экипаж, карта не вставлена', () {
      final co = ActivityChange.decode(
        change(DriverMode.availability, 90, coDriver: true, crew: true),
      );
      expect(
        (co.slot, co.crew, co.inserted, co.known, co.mode, co.minute),
        (CardSlot.coDriver, true, true, true, DriverMode.availability, 90),
      );
      final unknown = ActivityChange.decode(
        change(DriverMode.rest, 1439, inserted: false, known: false),
      );
      expect(
        (unknown.inserted, unknown.known, unknown.crew),
        (false, false, false),
      );
      final manual = ActivityChange.decode(
        change(DriverMode.otherWork, 5, inserted: false),
      );
      expect((manual.known, manual.mode), (true, DriverMode.otherWork));
    });

    test('кольцевой буфер: запись переходит через конец', () {
      final days = [
        for (var d = 1; d <= 6; d++)
          (
            '2026-09-${d.toString().padLeft(2, '0')}',
            d,
            [change(DriverMode.rest, 0), change(DriverMode.driving, 480)],
          ),
      ];
      // 6 записей по 16 байт в буфере 90 байт с 40-го байта: последняя
      // начинается на 30-м байте после перехода.
      final card = DriverCard.parse(
        cardFile(activityFile(days, size: 100, offset: 40)),
      );
      expect(card.days.map((d) => d.distanceKm), [1, 2, 3, 4, 5, 6]);
    });

    test('пустая карта — суток нет', () {
      final empty = Uint8List.fromList([0, 0, 0, 0, ...List.filled(64, 0)]);
      expect(DriverCard.parse(cardFile(empty)).days, isEmpty);
    });

    test('второе поколение важнее первого', () {
      final gen1 = activityFile([
        ('2026-09-01', 1, [change(DriverMode.rest, 0)]),
      ]);
      final gen2 = activityFile(shift);
      final bytes = Uint8List.fromList([
        ...block(0x0504, 0, gen1),
        ...block(0x0504, 2, gen2),
        ...block(0x0504, 3, [0xEE]),
      ]);
      final card = DriverCard.parse(bytes);
      expect(card.generation, 2);
      expect(card.days, hasLength(2));
    });

    test('особые условия: OUT и паром второго поколения', () {
      final card = DriverCard.parse(
        cardFile(
          activityFile(shift),
          generation: 2,
          conditions: [
            ('2026-09-21 16:30', 3),
            ('2026-09-21 19:00', 4),
            ('2026-09-21 05:00', 1),
            ('2026-09-21 05:30', 2),
          ],
        ),
      );
      expect(card.conditions.map((c) => (c.at, c.type)), [
        (utc('2026-09-21 05:00'), SpecificCondition.outOfScopeBegin),
        (utc('2026-09-21 05:30'), SpecificCondition.outOfScopeEnd),
        (utc('2026-09-21 16:30'), SpecificCondition.ferryBegin),
        (utc('2026-09-21 19:00'), SpecificCondition.ferryEnd),
      ]);
    });
  });

  group('журнал карты для движка', () {
    test('отрезки по порядку, одинаковые режимы через полночь склеены', () {
      final periods = cardPeriods(
        DriverCard.parse(cardFile(activityFile(shift))).days,
      );
      expect(periods.map((p) => (p.start, p.end, p.mode)), [
        (utc('2026-09-21 00:00'), utc('2026-09-21 06:00'), DriverMode.rest),
        (
          utc('2026-09-21 06:00'),
          utc('2026-09-21 06:15'),
          DriverMode.otherWork,
        ),
        (utc('2026-09-21 06:15'), utc('2026-09-21 10:45'), DriverMode.driving),
        (utc('2026-09-21 10:45'), utc('2026-09-21 11:30'), DriverMode.rest),
        (utc('2026-09-21 11:30'), utc('2026-09-21 16:00'), DriverMode.driving),
        (utc('2026-09-21 16:00'), utc('2026-09-23 00:00'), DriverMode.rest),
      ]);
    });

    test('сутки без записи и карта без ручного ввода — неизвестно', () {
      final days = cardPeriods([
        CardDay(
          date: utc('2026-09-01 00:00'),
          presenceCounter: 1,
          distanceKm: 0,
          changes: [
            ActivityChange.decode(change(DriverMode.driving, 0)),
            ActivityChange.decode(
              change(DriverMode.rest, 600, inserted: false, known: false),
            ),
          ],
        ),
        CardDay(
          date: utc('2026-09-03 00:00'),
          presenceCounter: 2,
          distanceKm: 0,
          changes: [ActivityChange.decode(change(DriverMode.driving, 60))],
        ),
      ], until: utc('2026-09-03 05:00'));
      expect(periods(days), [
        ('2026-09-01 00:00', '2026-09-01 10:00', DriverMode.driving),
        ('2026-09-01 10:00', '2026-09-03 01:00', null),
        ('2026-09-03 01:00', '2026-09-03 05:00', DriverMode.driving),
      ]);
      final engine = toEnginePeriods(days);
      expect(engine.map((p) => p.mode), [
        DriverMode.driving,
        DriverMode.rest,
        DriverMode.driving,
      ]);
      expect(toEnginePeriods(days, unknownAsRest: false).map((p) => p.mode), [
        DriverMode.driving,
        DriverMode.driving,
      ], reason: 'неизвестное — разрыв, а не отдых');
    });

    test('паром по особым условиям и обрезка по периоду', () {
      final card = DriverCard.parse(
        cardFile(
          activityFile(shift),
          generation: 2,
          conditions: [('2026-09-21 16:00', 3), ('2026-09-22 02:00', 4)],
        ),
      );
      final engine = toEnginePeriods(
        cardPeriods(card.days),
        conditions: card.conditions,
        from: utc('2026-09-21 06:00'),
        to: utc('2026-09-22 12:00'),
      );
      expect(engine.first.start, utc('2026-09-21 06:00'));
      expect(engine.last.end, utc('2026-09-22 12:00'));
      expect(engine.last.ferry, isTrue, reason: 'отдых начат на пароме');
      expect(engine.where((p) => p.ferry), hasLength(1));
    });
  });

  group('нарушения за журнал', () {
    test('пустой журнал — нарушений нет', () {
      expect(journalViolations(const []), isEmpty);
    });

    test('4:50 без перерыва и 10:30 за день — с момента появления', () {
      final log = logFrom(utc('2026-09-21 06:00'), [
        drive('4:50'),
        rest('0:45'),
        drive('4:00'),
        rest('0:45'),
        drive('1:40'),
        rest('11:00'),
      ]);
      final found = journalViolations(log.periods);
      expect(found.map((v) => (v.type, v.at)), [
        (InfringementType.continuousExceeded, utc('2026-09-21 10:49')),
        (InfringementType.dailyDriveExceeded, utc('2026-09-21 17:59')),
      ]);
      expect(found.first.article, '7');
    });

    test('журнал без нарушений — пусто, карта не считается', () {
      final log = logFrom(utc('2026-09-21 06:00'), [
        ...drivingDay('9:00'),
        rest('11:00'),
      ]);
      expect(journalViolations(log.periods), isEmpty);
    });
  });

  group('фикстура ENG-20', () {
    test('запись и чтение без потерь, без персональных данных', () {
      final card = DriverCard.parse(cardFile(activityFile(shift)));
      final fixture = cli.fixtureOf(card, name: 'test', crew: true);
      final text = fixture.encode();
      expect(text, isNot(contains('AAAA')), reason: 'имя с карты не выносим');
      final back = RealJournalFixture.fromJson(
        (jsonDecode(text) as Map).cast<String, Object?>(),
      );
      expect(back.periods, fixture.periods);
      expect(back.settings.crew, CrewMode.team);
      expect(back.source, contains('поколение 1'));
      expect(back.expected, isEmpty);
    });

    test('нарушения и расхождения читаются, дата ±1 сутки', () {
      final fixture = RealJournalFixture.fromJson({
        'name': 'x',
        'periods': [
          {
            'mode': 'driving',
            'start': '2026-09-21T06:00Z',
            'end': '2026-09-21T07:00Z',
          },
        ],
        'expected': [
          {'type': 'dailyDriveExceeded', 'date': '2026-09-21', 'note': 'n'},
        ],
        'knownDifferences': [
          {'type': 'shiftExceeded', 'date': '2026-09-22', 'reason': 'r'},
        ],
      });
      expect(fixture.expected.single.note, 'n');
      expect(fixture.knownDifferences.single.note, 'r');
      final e = fixture.expected.single;
      expect(sameViolation(e.type, utc('2026-09-22 00:00'), e), isTrue);
      expect(sameViolation(e.type, utc('2026-09-23 00:00'), e), isFalse);
      expect(sameViolation(InfringementType.shiftExceeded, e.date, e), isFalse);
      expect(
        () => RealJournalFixture.fromJson({
          'name': 'x',
          'periods': [
            {'mode': 'driving', 'start': '2026-09-21T06:00'},
          ],
        }),
        throwsFormatException,
        reason: 'время без Z',
      );
    });

    test('сводка по карте: сутки, особые условия, нарушения', () {
      final card = DriverCard.parse(
        cardFile(
          activityFile(shift),
          generation: 2,
          conditions: [('2026-09-21 05:00', 1)],
        ),
      );
      final text = cli.summary(card);
      expect(text, contains('поколение 2, суток 2'));
      expect(text, contains('2026-09-21  9:00 / 0:15 / 0:00 / 14:45 / 0:00'));
      expect(text, contains('outOfScopeBegin'));
      expect(text, contains('Нарушения по движку (0)'));
    });
  });

  group('DEV-03: журнал приложения против карты', () {
    List<CardPeriod> card() =>
        cardPeriods(DriverCard.parse(cardFile(activityFile(shift))).days);

    const header =
        '\uFEFF'
        '"activity","start_utc","end_utc","duration_min","driving_min",'
        '"ferry"';
    String csv(List<(String, String, String)> rows) => [
      header,
      for (final (a, s, e) in rows) '"$a","$s","$e","0","0","0"',
    ].join('\r\n');

    test('CSV приложения читается, идущая запись — ACTIVE', () {
      final app = readAppCsv(
        csv([
          ('DRIVING', '2026-09-21T06:15:20Z', '2026-09-21T10:45:00Z'),
          ('REST', '2026-09-21T10:45:00Z', 'ACTIVE'),
        ]),
      );
      expect(app.map((r) => (r.mode, r.start, r.end)), [
        (
          DriverMode.driving,
          utc('2026-09-21 06:15:20'),
          utc('2026-09-21 10:45'),
        ),
        (DriverMode.rest, utc('2026-09-21 10:45'), null),
      ]);
      expect(() => readAppCsv('"a","b"\r\n"1","2"'), throwsFormatException);
    });

    test('сдвиг внутри минуты — пройдено; перерыв забыт — нет', () {
      final exact = readAppCsv(
        csv([
          ('OTHER_WORK', '2026-09-21T06:00:10Z', '2026-09-21T06:15:40Z'),
          ('DRIVING', '2026-09-21T06:15:40Z', '2026-09-21T10:45:05Z'),
          ('REST', '2026-09-21T10:45:05Z', '2026-09-21T11:30:00Z'),
          ('DRIVING', '2026-09-21T11:30:00Z', '2026-09-21T16:00:00Z'),
          ('REST', '2026-09-21T16:00:00Z', '2026-09-22T12:00:00Z'),
        ]),
      );
      final ok = compareJournals(exact, card(), now: utc('2026-09-22 12:00'));
      expect(ok.from, utc('2026-09-21 06:00'));
      expect(ok.to, utc('2026-09-22 12:00'));
      expect(ok.passed, isTrue);
      expect(ok.mismatchMinutes, 1, reason: '06:15 — вождение с 06:15:40');
      expect(cli.comparisonReport(ok), contains('DEV-03: пройдено'));

      final forgot = readAppCsv(
        csv([
          ('OTHER_WORK', '2026-09-21T06:00:00Z', '2026-09-21T06:15:00Z'),
          ('DRIVING', '2026-09-21T06:15:00Z', '2026-09-21T16:00:00Z'),
          ('REST', '2026-09-21T16:00:00Z', 'ACTIVE'),
        ]),
      );
      final bad = compareJournals(forgot, card(), now: utc('2026-09-22 12:00'));
      expect(bad.passed, isFalse);
      expect(bad.mismatches.single, (
        start: utc('2026-09-21 10:45'),
        end: utc('2026-09-21 11:30'),
        app: DriverMode.driving,
        card: DriverMode.rest,
      ));
      expect(cli.comparisonReport(bad), contains('больше минуты'));
    });
  });
}

/// Отрезки журнала карты для сравнения: (начало, конец, режим).
List<(String, String, DriverMode?)> periods(List<CardPeriod> list) => [
  for (final p in list) (_short(p.start), _short(p.end), p.mode),
];

String _short(DateTime t) =>
    t.toIso8601String().substring(0, 16).replaceFirst('T', ' ');
