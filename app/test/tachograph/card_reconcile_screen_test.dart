import 'package:flutter_test/flutter_test.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/features/tachograph/card_reconcile_screen.dart';
import 'package:tachogo/tachograph/card_reconcile.dart';

import '../support/app_harness.dart';

ReconcileDay reconcileDay(int d, {int different = 0}) => ReconcileDay(
  day: DateTime(2026, 11, d),
  card: const [
    (mode: DriverMode.rest, minutes: 480),
    (mode: DriverMode.driving, minutes: 240),
    (mode: DriverMode.rest, minutes: 720),
  ],
  journal: const [
    (mode: DriverMode.rest, minutes: 510),
    (mode: DriverMode.driving, minutes: 210),
    (mode: DriverMode.rest, minutes: 720),
  ],
  differentMinutes: different,
);

void main() {
  const path = 'card_20261128_135815.ddd';

  Future<void> pump(WidgetTester tester, CardReconciliation result) =>
      pumpScreen(
        tester,
        const CardReconcileScreen(path: path),
        overrides: [
          cardReconcileProvider.overrideWith((ref, _) async => result),
        ],
      );

  group('BT-23: экран «Сверка с картой»', () {
    testWidgets(
      'итог, пояснение и сутки: совпадает или на сколько расходится',
      (tester) async {
        await pump(
          tester,
          CardReconciliation([
            reconcileDay(27, different: 30),
            reconcileDay(26),
          ]),
        );
        await tester.pump();
        expect(find.text('Сверка с картой'), findsOneWidget);
        expect(
          find.text('Суток: 2 · совпадает: 1 · с расхождениями: 1'),
          findsOneWidget,
        );
        expect(find.textContaining('Карта главнее журнала'), findsOneWidget);
        expect(find.text('расходится на 0:30'), findsOneWidget);
        expect(find.text('совпадает'), findsOneWidget);
        expect(find.text('Карта'), findsNWidgets(2));
        await unmount(tester);
      },
    );

    testWidgets('за дни карты журнал пуст — так и пишем', (tester) async {
      await pump(tester, const CardReconciliation([]));
      await tester.pump();
      expect(find.textContaining('нет записей'), findsOneWidget);
      await unmount(tester);
    });
  });
}
