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

  group('BG-02: остальные состояния', () {
    test('готовность', () {
      final n = trackingNotification(
        snapshot([
          (DriverMode.rest, h * 11),
          (DriverMode.availability, m * 30),
        ]),
      );
      expect(n.title, 'Готовность · 0:30');
      expect(n.text, 'Рабочий день 0:30 из 15:00');
    });

    test('недельный отдых: до 45 ч, часы без ограничения', () {
      final n = trackingNotification(
        snapshot([(DriverMode.driving, h * 4), (DriverMode.rest, h * 30)]),
      );
      expect(n.title, 'Недельный отдых · 30:00');
      expect(n.text, 'До полного отдыха 45 ч: 15:00');
    });

    test('недельный отдых набран', () {
      final n = trackingNotification(
        snapshot([(DriverMode.driving, h * 4), (DriverMode.rest, h * 46)]),
      );
      expect(n.text, 'Полный недельный отдых набран');
    });

    test('суточный отдых набран', () {
      final n = trackingNotification(
        snapshot([(DriverMode.driving, h * 4), (DriverMode.rest, h * 12)]),
      );
      expect(n.text, 'Полный суточный отдых набран');
    });

    test('перерыв засчитан', () {
      final n = trackingNotification(
        snapshot([
          (DriverMode.rest, h * 11),
          (DriverMode.driving, h * 4),
          (DriverMode.rest, m * 50),
        ]),
      );
      expect(n.title, 'Перерыв · 0:50');
      expect(n.text, 'Перерыв засчитан, можно ехать 4:30');
    });

    test('смена не начата', () {
      final n = trackingNotification(snapshot([(DriverMode.rest, m * 30)]));
      expect(n.title, 'Смена не начата');
      expect(n.text, 'Вождение включится само, когда машина поедет');
    });

    test('режим не выбран: журнал обрывается разрывом', () {
      final periods = [
        ActivityPeriod(
          mode: DriverMode.rest,
          start: now.subtract(h * 14),
          end: now.subtract(h * 3),
        ),
        ActivityPeriod(
          mode: DriverMode.driving,
          start: now.subtract(h * 3),
          end: now.subtract(h),
        ),
      ];
      final n = trackingNotification(
        calculateCompliance(periods: periods, now: now),
      );
      expect(n.title, 'Режим не выбран');
      expect(n.text, 'Откройте TachoGo и выберите режим');
    });

    test('предложение экипажу', () {
      final at = now.subtract(m * 2);
      final n = trackingNotification(
        snapshot([(DriverMode.rest, h * 11), (DriverMode.otherWork, h)]),
        suggestion: AutoSwitch(
          AutoSwitchKind.suggest,
          mode: DriverMode.driving,
          at: at,
          reason: AutoSwitchReason.team,
        ),
      );
      expect(n.title, 'Машина едет');
      expect(n.text, startsWith('Вы за рулём? Вождение с '));
    });

    test('часы переведены назад: время режима не отрицательное', () {
      final periods = [
        ActivityPeriod(
          mode: DriverMode.rest,
          start: now.subtract(h * 11),
          end: now,
        ),
        ActivityPeriod(mode: DriverMode.driving, start: now.add(h)),
      ];
      final n = trackingNotification(
        calculateCompliance(periods: periods, now: now),
      );
      expect(n.title, 'Вождение · 0:00');
    });
  });
}
