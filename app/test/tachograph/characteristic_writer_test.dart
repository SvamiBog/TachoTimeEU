// BT-13 (docs/testing.md): запись в характеристику тахографа. Спецификация
// говорит только «запись»; DTCO 4.1a владельца 25.11.2026 отвечал на запись
// с ответом «запись не разрешена» — тогда пробуем запись без ответа.
import 'package:flutter_test/flutter_test.dart';
import 'package:tachogo/tachograph/exchange_log.dart';
import 'package:tachogo/tachograph/its_client.dart';
import 'package:tachogo/tachograph/tachograph_platform.dart';

const _notPermitted =
    'GATT exception from MAC=XX, status 3 (GATT_WRITE_NOT_PERMIT), '
    'type CHARACTERISTIC_WRITE';

/// Характеристика: записи и какие из них тахограф отклоняет.
class _Characteristic {
  final writes = <({List<int> value, bool withResponse})>[];
  bool rejectWithResponse = false;
  StateError? error;

  Future<void> write(List<int> value, {required bool withResponse}) async {
    writes.add((value: value, withResponse: withResponse));
    if (error case final e?) throw e;
    if (withResponse && rejectWithResponse) throw Exception(_notPermitted);
  }
}

void main() {
  late ExchangeLog log;
  late _Characteristic c;

  setUp(() {
    log = ExchangeLog(now: () => DateTime.utc(2026, 11, 25, 15));
    c = _Characteristic();
  });

  CharacteristicWriter writer({
    bool withResponse = true,
    bool withoutResponse = true,
  }) => CharacteristicWriter(
    name: 'credits',
    write: c.write,
    log: log,
    withResponse: withResponse,
    withoutResponse: withoutResponse,
  );

  group('BT-13: запись в характеристику тахографа', () {
    test('можно с ответом — пишем с ответом', () async {
      await writer()([0x20]);
      expect(c.writes.single.withResponse, isTrue);
    });

    test('только без ответа — пишем без ответа', () async {
      await writer(withResponse: false)([0x20]);
      expect(c.writes.single.withResponse, isFalse);
    });

    test(
      '«запись не разрешена» — переходим на запись без ответа насовсем',
      () async {
        c.rejectWithResponse = true;
        final write = writer();
        await write([0x20]);
        await write([0x10]);
        expect(c.writes.map((w) => w.withResponse), [true, false, false]);
        expect(c.writes.last.value, [0x10]);
        expect(
          log.lines.single,
          contains('switching to write without response'),
        );
      },
    );

    test(
      '«запись не разрешена», а без ответа нельзя — отказ тахографа',
      () async {
        c.rejectWithResponse = true;
        await expectLater(
          writer(withoutResponse: false)([0x20]),
          throwsA(isA<ItsWriteRejected>()),
        );
      },
    );

    test('другая ошибка Bluetooth — как есть, способ записи прежний', () async {
      c.error = StateError('link lost');
      final write = writer();
      await expectLater(write([0x20]), throwsStateError);
      c.error = null;
      await write([0x20]);
      expect(c.writes.map((w) => w.withResponse), [true, true]);
    });

    test('признак отказа — только «запись не разрешена» (status 3)', () {
      expect(writeNotPermitted.hasMatch(_notPermitted), isTrue);
      expect(writeNotPermitted.hasMatch('status 30 (GATT_ERROR)'), isFalse);
      expect(writeNotPermitted.hasMatch('status 5 (INSUF_AUTH)'), isFalse);
    });
  });
}
