import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tachogo/app.dart';

void main() {
  testWidgets('приложение запускается и показывает лимит 4:30', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: TachoGoApp()));
    expect(find.text('TachoGo'), findsOneWidget);
    expect(find.text('4:30'), findsOneWidget);
  });
}
