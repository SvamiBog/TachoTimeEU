// INT-04 (docs/testing.md, раздел 14): смена часового пояса эмулятора
// посреди смены. Длительности не меняются — движок и журнал в UTC; время
// на экране — местное, и приложение видит новый пояс без перезапуска
// (docs/background.md, «Часовой пояс»: на Windows, Linux и macOS
// `DateTime.now()` его не видит, на Android — должен).
//
// Пояс меняет помощник хоста (`tool/integration/host_agent.sh`) по команде
// `timezone <зона>`. Ожидаемое время — по известному смещению зоны на
// момент записи, а не через `toLocal()`: иначе экран и проверка ошиблись
// бы одинаково.
//
// Без эмулятора сценарий пропускается.

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/core/l10n/format.dart';
import 'package:tachogo/features/home/hero_card.dart';

import 'support/harness.dart';

/// Начало смены в местном времени пояса: 21.09.2026 в Варшаве — летнее
/// время, UTC+2; Калькутта — UTC+5:30 круглый год.
const warsaw = ('Europe/Warsaw', '08:00', 120);
const kolkata = ('Asia/Kolkata', '11:30', 330);

/// Местное время начала смены так, как его видит Dart сейчас.
String localStart() => formatClock(monday);

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'INT-04: пояс сменился посреди смены — длительности те же, время на '
    'экране — новое местное, без перезапуска',
    timeout: const Timeout(Duration(minutes: 5)),
    // Без эмулятора нет помощника хоста
    skip: !onDevice,
    (tester) async {
      Future<void> switchZone((String, String, int) zone) async {
        hostCommand('timezone ${zone.$1}');
        await waitFor(
          tester,
          () async => localStart() == zone.$2,
          timeout: const Duration(seconds: 60),
          reason:
              'DateTime видит пояс ${zone.$1} без перезапуска приложения '
              '(начало смены ${zone.$2}, сейчас ${localStart()})',
        );
      }

      addTearDown(() => hostCommand('timezone UTC'));
      await switchZone(warsaw);

      final db = await freshDatabase(tester, 'int04');
      final clock = ScenarioClock(monday);
      await launchApp(tester, overrides: appOverrides(db, clock: clock));
      await tapMode(tester, DriverMode.driving);
      clock.now = monday.add(h(2));
      await settle(tester);

      Finder modeSince(String time) => find.descendant(
        of: find.byType(CurrentModeRow),
        matching: find.textContaining(ru.modeSince(time)),
      );
      expect(modeSince(warsaw.$2), findsOneWidget);
      var s = await expectScreenMatchesEngine(tester, db, clock.now);
      expect(s.continuousDriving, h(2));

      // Пояс сменился в пути; приложение не перезапускалось
      await switchZone(kolkata);
      clock.now = clock.now.add(const Duration(minutes: 1));
      await settle(tester);
      expect(modeSince(kolkata.$2), findsOneWidget);
      s = await expectScreenMatchesEngine(tester, db, clock.now);
      expect(s.continuousDriving, h(2, 1), reason: 'длительность — по UTC');

      // Новая запись хранит смещение устройства на момент её начала
      await tapMode(tester, DriverMode.rest);
      final offsets = await tester.runAsync(
        () => db
            .customSelect(
              'SELECT utc_offset_minutes AS o FROM activity_periods '
              'ORDER BY start_utc',
            )
            .map((r) => r.read<int>('o'))
            .get(),
      );
      expect(offsets, [warsaw.$3, kolkata.$3]);
    },
  );
}
