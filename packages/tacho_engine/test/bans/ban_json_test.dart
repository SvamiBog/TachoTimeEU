// BAN-11 (docs/testing.md): файл с правилами запретов для обновления по
// сети. Правила из файла считают те же запреты, что встроенные; файл
// другой версии или с ошибкой не читается целиком — приложение остаётся
// на прежних правилах.

import 'dart:convert';

import 'package:tacho_engine/driving_bans.dart';
import 'package:test/test.dart';

/// Встроенные правила текстом, с правкой [edit] первой страны.
String edited(void Function(Map<String, Object?> country) edit) {
  final json = jsonDecode(encodeBanData(europeBans.values)) as Map;
  edit((json['countries'] as List).first as Map<String, Object?>);
  return jsonEncode(json);
}

/// Встроенные правила текстом, с правкой [edit] первого правила Германии.
String editedRule(void Function(Map<String, Object?> rule) edit) => edited(
  (germany) => edit((germany['rules']! as List).first as Map<String, Object?>),
);

void main() {
  group('BAN-11: файл с правилами запретов', () {
    test('из файла — те же запреты, что у встроенных правил, на год '
        'вперёд, и тот же текст файла', () {
      final text = encodeBanData(europeBans.values);
      final decoded = decodeBanData(text);
      expect(decoded.keys, europeBans.keys);
      expect(encodeBanData(decoded.values), text);
      final from = DateTime.utc(2026, 10);
      final to = DateTime.utc(2027, 12, 31);
      for (final c in europeBans.values) {
        final d = decoded[c.code]!;
        expect(d.zone, c.zone, reason: c.code);
        expect(d.coverage, c.coverage, reason: c.code);
        expect(d.checkedOn, c.checkedOn, reason: c.code);
        expect(d.calendarUntil, c.calendarUntil, reason: c.code);
        expect(d.needsCheck, c.needsCheck, reason: c.code);
        expect(d.sources, c.sources, reason: c.code);
        for (final mass in VehicleMass.values) {
          expect(
            banWindows(d, mass, from, to),
            banWindows(c, mass, from, to),
            reason: '${c.code} ${mass.name}',
          );
        }
      }
    });

    test('время с днём: «22:00-1», «05:00+1»; праздник от православной '
        'Пасхи; сезон одного года', () {
      const country = CountryBans(
        code: 'BG',
        zone: BanZone.eet,
        coverage: BanCoverage.rules,
        checkedOn: BanDate(2026, 10, 1),
        sources: ['https://www.api.bg'],
        rules: [
          BanRule(
            kind: BanKind.holiday,
            days: HolidayDays([EasterHoliday(1, orthodox: true)]),
            from: BanTime(22, dayOffset: -1),
            to: BanTime(5, minute: 30, dayOffset: 1),
            season: BanSeason(4, 1, 5, 31, year: 2027),
          ),
        ],
      );
      final text = encodeBanData([country]);
      expect(text, contains('"from":"22:00-1"'));
      expect(text, contains('"to":"05:30+1"'));
      expect(text, contains('{"type":"easter","offset":1,"orthodox":true}'));
      expect(
        text,
        contains('"season":{"from":"04-01","to":"05-31","year":2027}'),
      );
      final rule = decodeBanData(text)['BG']!.rules.single;
      final holiday = (rule.days as HolidayDays).holidays.single;
      expect(holiday.dateIn(2027), DateTime.utc(2027, 5, 3));
      expect(rule.from.dayOffset, -1);
      expect(rule.to.minute, 30);
      expect(rule.season?.year, 2027);
      expect(
        banWindows(
          decodeBanData(text)['BG']!,
          VehicleMass.over12,
          DateTime.utc(2027, 5),
          DateTime.utc(2027, 5, 5),
        ),
        banWindows(
          country,
          VehicleMass.over12,
          DateTime.utc(2027, 5),
          DateTime.utc(2027, 5, 5),
        ),
      );
    });

    test('поле, которого формат не знает, пропускается', () {
      final text = edited((c) => c['ferryNote'] = 'с 2027 года');
      expect(decodeBanData(text).keys, europeBans.keys);
    });

    test('самая свежая сверка', () {
      expect(latestCheck(europeBans.values), const BanDate(2026, 10, 1));
      expect(
        latestCheck([
          const CountryBans(
            code: 'NL',
            zone: BanZone.cet,
            coverage: BanCoverage.none,
            checkedOn: BanDate(2027, 1, 5),
          ),
          ...europeBans.values,
        ]),
        const BanDate(2027, 1, 5),
      );
    });

    final broken = <String, String>{
      'не JSON': '{"format":1,',
      'не объект': '[1, 2]',
      'другая версия формата': jsonEncode({
        'format': 2,
        'countries': <Object>[],
      }),
      'нет списка стран': jsonEncode({'format': 1}),
      'страна дважды': edited(
        (c) => c['code'] = europeBans.values.elementAt(1).code,
      ),
      'неверный знак страны': edited((c) => c['code'] = 'de'),
      'неизвестный пояс': edited((c) => c['zone'] = 'msk'),
      'правил нет, а охват — правила': edited((c) => c['rules'] = <Object>[]),
      'источник не https': edited(
        (c) => c['sources'] = ['javascript:alert(1)'],
      ),
      'невозможная дата сверки': edited((c) => c['checkedOn'] = '2026-02-30'),
      'неизвестный вид правила': editedRule((r) => r['kind'] = 'ferry'),
      'неизвестный вид дней': editedRule(
        (r) => r['days'] = {'type': 'schoolHolidays'},
      ),
      'день недели 8': editedRule(
        (r) => r['days'] = {
          'type': 'weekdays',
          'weekdays': [8],
        },
      ),
      'неизвестный вид праздника': editedRule(
        (r) => r['days'] = {
          'type': 'holidays',
          'holidays': [
            {'type': 'ramadan'},
          ],
        },
      ),
      '31 июня': editedRule(
        (r) => r['days'] = {
          'type': 'holidays',
          'holidays': [
            {'type': 'fixed', 'date': '06-31'},
          ],
        },
      ),
      'сдвиг от Пасхи на полгода': editedRule(
        (r) => r['days'] = {
          'type': 'holidays',
          'holidays': [
            {'type': 'easter', 'offset': 180},
          ],
        },
      ),
      'дата не по формату': edited((c) => c['checkedOn'] = '01.10.2026'),
      'день сезона не по формату': editedRule(
        (r) => r['season'] = {'from': '7-1', 'to': '08-31'},
      ),
      'сезон в 1999 году': editedRule(
        (r) => r['season'] = {'from': '07-01', 'to': '08-31', 'year': 1999},
      ),
      'время без нуля': editedRule((r) => r['from'] = '7:00'),
      'время 24:00': editedRule((r) => r['to'] = '24:00'),
      'конец раньше начала': editedRule((r) => r['to'] = '00:00-1'),
      'порог массы не число': editedRule((r) => r['overTonnes'] = '7,5'),
      'отрицательный порог массы': editedRule((r) => r['overTonnes'] = -1),
      'сезон без конца': editedRule((r) => r['season'] = {'from': '07-01'}),
      'флаг не true / false': edited((c) => c['needsCheck'] = 'да'),
    };
    for (final MapEntry(key: name, value: text) in broken.entries) {
      test('не читается: $name', () {
        expect(() => decodeBanData(text), throwsFormatException);
      });
    }
  });
}
