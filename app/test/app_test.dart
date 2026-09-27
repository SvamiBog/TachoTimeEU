import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tachogo/app.dart';

import 'support/app_harness.dart';

void main() {
  testWidgets('приложение запускается: главная с пустым журналом', (
    tester,
  ) async {
    final db = memoryDatabase();
    addTearDown(db.close);
    await tester.pumpWidget(
      ProviderScope(
        overrides: databaseOverrides(
          db,
          now: () => DateTime.utc(2026, 9, 23, 8),
        ),
        child: const TachoGoApp(),
      ),
    );
    await settle(tester);
    expect(find.text('TachoGo'), findsOneWidget);
    expect(find.text('ДО ПЕРЕРЫВА'), findsOneWidget);
    expect(find.text('4:30'), findsOneWidget);
    await unmount(tester);
  });
}
