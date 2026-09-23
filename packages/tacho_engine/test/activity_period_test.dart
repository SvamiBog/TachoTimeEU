import 'package:tacho_engine/tacho_engine.dart';
import 'package:test/test.dart';

void main() {
  final t0 = DateTime.utc(2026, 9, 23, 6, 49);

  group('ActivityPeriod', () {
    test('открытый период считает длительность до now', () {
      final p = ActivityPeriod(mode: DriverMode.driving, start: t0);
      expect(p.isOpen, isTrue);
      expect(
        p.durationAt(t0.add(const Duration(hours: 3, minutes: 55))),
        const Duration(hours: 3, minutes: 55),
      );
    });

    test('закрытый период не зависит от now', () {
      final p = ActivityPeriod(
        mode: DriverMode.rest,
        start: t0,
      ).close(t0.add(const Duration(minutes: 15)));
      expect(p.isOpen, isFalse);
      expect(
        p.durationAt(t0.add(const Duration(days: 1))),
        const Duration(minutes: 15),
      );
    });

    test('начало не в UTC отклоняется', () {
      expect(
        () => ActivityPeriod(
          mode: DriverMode.driving,
          start: DateTime(2026, 9, 23, 6, 49),
        ),
        throwsArgumentError,
      );
    });

    test('конец не в UTC отклоняется', () {
      expect(
        () => ActivityPeriod(
          mode: DriverMode.driving,
          start: t0,
          end: DateTime(2026, 9, 23, 9),
        ),
        throwsArgumentError,
      );
    });

    test('конец раньше начала отклоняется', () {
      expect(
        () => ActivityPeriod(
          mode: DriverMode.driving,
          start: t0,
          end: t0.subtract(const Duration(minutes: 1)),
        ),
        throwsArgumentError,
      );
    });
  });

  group('DriverMode', () {
    test('рабочее время — вождение и другая работа', () {
      expect(DriverMode.values.where((m) => m.isWorkingTime), [
        DriverMode.driving,
        DriverMode.otherWork,
      ]);
    });

    test('смену прерывает только отдых', () {
      expect(DriverMode.values.where((m) => m.isRest), [DriverMode.rest]);
    });
  });
}
