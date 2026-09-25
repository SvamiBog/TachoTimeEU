import 'package:flutter_test/flutter_test.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/background/tracking_notification.dart';

void main() {
  final now = DateTime.utc(2026, 9, 23, 12);

  ComplianceSnapshot snapshot(List<(DriverMode, Duration)> segs) {
    final total = segs.fold(Duration.zero, (sum, s) => sum + s.$2);
    var t = now.subtract(total);
    final periods = <ActivityPeriod>[];
    for (final (i, (mode, d)) in segs.indexed) {
      final end = t.add(d);
      periods.add(
        ActivityPeriod(
          mode: mode,
          start: t,
          end: i == segs.length - 1 ? null : end,
        ),
      );
      t = end;
    }
    return calculateCompliance(periods: periods, now: now);
  }

  const h = Duration(hours: 1);
  const m = Duration(minutes: 1);

  test('вождение: время режима, до перерыва и остаток за день', () {
    final n = trackingNotification(
      snapshot([(DriverMode.rest, h * 11), (DriverMode.driving, m * 85)]),
    );
    expect(n.title, 'Вождение · 1:25');
    expect(n.text, 'До перерыва 3:05 · за день осталось 8:35');
  });

  test('вождение без перерыва дольше 4:30 — превышение', () {
    final n = trackingNotification(
      snapshot([(DriverMode.rest, h * 11), (DriverMode.driving, m * 280)]),
    );
    expect(n.text, 'Нужен перерыв: превышение 0:10');
  });

  test('перерыв: сколько осталось до полного', () {
    final n = trackingNotification(
      snapshot([
        (DriverMode.rest, h * 11),
        (DriverMode.driving, h * 2),
        (DriverMode.rest, m * 20),
      ]),
    );
    expect(n.title, 'Перерыв · 0:20');
    expect(n.text, 'До полного перерыва 0:25');
  });

  test('работа: рабочий день из лимита', () {
    final n = trackingNotification(
      snapshot([(DriverMode.rest, h * 11), (DriverMode.otherWork, h * 2)]),
    );
    expect(n.title, 'Другая работа · 2:00');
    expect(n.text, 'Рабочий день 2:00 из 15:00');
  });

  test('суточный отдых: до 11 ч', () {
    final n = trackingNotification(
      snapshot([(DriverMode.driving, h * 4), (DriverMode.rest, h * 9)]),
    );
    expect(n.title, 'Суточный отдых · 9:00');
    expect(n.text, 'До полного отдыха 11 ч: 2:00');
  });

  test('предложение начать вождение — с местным временем', () {
    final at = now.subtract(m * 2);
    final local = at.toLocal();
    final hhmm =
        '${local.hour.toString().padLeft(2, '0')}:'
        '${local.minute.toString().padLeft(2, '0')}';
    final n = trackingNotification(
      snapshot([(DriverMode.driving, h * 4), (DriverMode.rest, h * 9)]),
      suggestion: AutoSwitch(
        AutoSwitchKind.suggest,
        mode: DriverMode.driving,
        at: at,
        reason: AutoSwitchReason.offDuty,
      ),
    );
    expect(n.title, 'Похоже, вы едете');
    expect(n.text, 'Начать вождение с $hhmm? Отдых будет прерван');
  });
}
