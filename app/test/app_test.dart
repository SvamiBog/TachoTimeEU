import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tachotime/app.dart';

void main() {
  testWidgets('приложение запускается и показывает лимит 4:30', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: TachoTimeApp()));
    expect(find.text('TachoTime'), findsOneWidget);
    expect(find.text('4:30'), findsOneWidget);
  });
}
