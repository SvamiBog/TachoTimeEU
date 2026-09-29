// Что показать водителю по прогнозу движка: id, категории из настроек,
// тексты и каналы. План тестов: NTF-03, NTF-05 в docs/testing.md.

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/data/settings/settings_repository.dart';
import 'package:tachogo/notifications/alert_notifications.dart';
import 'package:tachogo/notifications/notification_platform.dart';

void main() {
  final l = lookupAppLocalizations(const Locale('ru'));
  final at = DateTime.utc(2026, 9, 23, 9);
  const all = NotificationSettings();
  final kinds = <Enum>[...InfringementType.values, ...RestMilestone.values];

  group('id уведомления', () {
    test('у каждого вида свой, с сервисом автоопределения не совпадает', () {
      final ids = [for (final k in kinds) alertId(k)];
      expect(ids.toSet(), hasLength(kinds.length));
      expect(ids, isNot(contains(561)));
    });

    test('по id находится вид; чужой id — не о лимитах', () {
      for (final k in kinds) {
        expect(alertKindOf(alertId(k)), k);
      }
      expect(alertKindOf(561), isNull);
      expect(alertKindOf(999), isNull);
      expect(alertKindOf(alertId(InfringementType.values.last) + 1), isNull);
      expect(() => alertId(DriverMode.rest), throwsArgumentError);
    });
  });

  group('NTF-03: категории из настроек', () {
    test('каждый вид — в своей категории', () {
      const cases = <Enum, String>{
        InfringementType.breakSoon: 'breaks',
        InfringementType.continuousExceeded: 'breaks',
        RestMilestone.breakTaken: 'breaks',
        InfringementType.dailyDriveSoon: 'driving',
        InfringementType.weeklyDriveExceeded: 'driving',
        InfringementType.fortnightDriveSoon: 'driving',
        InfringementType.shiftSoon: 'shiftEnd',
        InfringementType.shiftExceeded: 'shiftEnd',
        InfringementType.weeklyRestSoon: 'shiftEnd',
        InfringementType.weeklyRestOverdue: 'shiftEnd',
        InfringementType.weeklyRestContinue: 'shiftEnd',
        InfringementType.compensationSoon: 'shiftEnd',
        RestMilestone.dailyRestTaken: 'shiftEnd',
        RestMilestone.weeklyRestTaken: 'shiftEnd',
        RestMilestone.compensationTaken: 'shiftEnd',
        InfringementType.cardSoon: 'card',
        InfringementType.cardOverdue: 'card',
      };
      for (final MapEntry(key: kind, value: category) in cases.entries) {
        final off = switch (category) {
          'breaks' => all.copyWith(breaks: false),
          'driving' => all.copyWith(driving: false),
          'shiftEnd' => all.copyWith(shiftEnd: false),
          _ => all.copyWith(card: false),
        };
        expect(alertEnabled(kind, all), isTrue, reason: '$kind');
        expect(alertEnabled(kind, off), isFalse, reason: '$kind');
      }
    });

    test('справка «идёт продление» уведомлением не приходит', () {
      expect(alertEnabled(InfringementType.extensionInUse, all), isFalse);
      expect(alertEnabled(DriverMode.driving, all), isFalse);
    });

    test('выключенная категория выпадает из расписания', () {
      final upcoming = [
        LimitAlert(at, const Infringement(InfringementType.breakSoon)),
        LimitAlert(at, const Infringement(InfringementType.dailyDriveSoon)),
      ];
      expect(
        alertNotifications(
          upcoming,
          all.copyWith(breaks: false),
          l,
        ).map((n) => n.id),
        [alertId(InfringementType.dailyDriveSoon)],
      );
    });
  });

  group('NTF-05: тексты', () {
    test('лимит — заголовок, текст и статья, как на главной', () {
      final n = alertNotifications(
        [
          LimitAlert(
            at,
            const Infringement(
              InfringementType.breakSoon,
              time: Duration(minutes: 30),
              requiredBreak: Duration(minutes: 45),
            ),
          ),
        ],
        all,
        l,
      ).single;
      expect(n.id, alertId(InfringementType.breakSoon));
      expect(n.at, at);
      expect(n.channel, AlertChannel.limits);
      expect(n.title, 'Скоро перерыв');
      expect(n.body, 'До лимита 4:30 осталось 0:30. Нужен перерыв 45 мин.');
      expect(n.article, 'ЕС 561/2006 · ст. 7');
    });

    test('отдых набран — в своём канале, без статьи', () {
      final notifications = alertNotifications(
        [
          RestAlert(
            at,
            RestMilestone.breakTaken,
            taken: const Duration(minutes: 30),
            drivingUntilBreak: EuLimits.continuousDriving,
          ),
          RestAlert(
            at,
            RestMilestone.dailyRestTaken,
            taken: EuLimits.dailyRestRegular,
            drivingUntilBreak: EuLimits.continuousDriving,
          ),
          RestAlert(
            at,
            RestMilestone.weeklyRestTaken,
            taken: EuLimits.weeklyRestRegular,
            drivingUntilBreak: EuLimits.continuousDriving,
          ),
          RestAlert(
            at,
            RestMilestone.compensationTaken,
            taken: const Duration(hours: 2, minutes: 19),
            drivingUntilBreak: EuLimits.continuousDriving,
          ),
        ],
        all,
        l,
      );
      expect(
        [for (final n in notifications) (n.title, n.body)],
        [
          (
            'Перерыв засчитан',
            'Перерыв 30 мин набран. Можно ехать 4:30 до следующего перерыва.',
          ),
          (
            'Суточный отдых набран',
            'Полный отдых 11 ч — можно начинать смену.',
          ),
          (
            'Недельный отдых набран',
            'Полный отдых 45 ч — можно начинать новую рабочую неделю.',
          ),
          (
            'Компенсация взята',
            'Отдых вместил долг 2:19 за сокращённый недельный отдых — долг '
                'погашен.',
          ),
        ],
      );
      expect(
        notifications.every((n) => n.channel == AlertChannel.rest),
        isTrue,
      );
      expect(notifications.every((n) => n.article == null), isTrue);
    });

    test('каналы — на языке интерфейса', () {
      final names = alertChannelNames(l);
      expect(names[AlertChannel.limits]!.name, 'Лимиты и нарушения');
      expect(names[AlertChannel.rest]!.name, 'Отдых набран');
    });

    test('язык — из настроек, иначе телефона; без перевода — русский', () {
      expect(appLocale('ru', const [Locale('pl')]), const Locale('ru'));
      expect(appLocale(null, const [Locale('ru', 'UA')]), const Locale('ru'));
      expect(appLocale(null, const [Locale('hi')]), const Locale('ru'));
      expect(appLocale(null, const [Locale('de')]), const Locale('de'));
      expect(appLocale(null, const <Locale>[]), const Locale('ru'));
    });
  });
}
