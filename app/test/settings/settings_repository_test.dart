import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tachogo/data/db/app_database.dart';
import 'package:tachogo/data/settings/settings_repository.dart';

void main() {
  late AppDatabase db;
  late SettingsRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = SettingsRepository(db);
  });
  tearDown(() => db.close());

  test('согласия на аналитику нет, пока водитель не ответил', () async {
    expect(await repo.watchAnalyticsConsent().first, isFalse);
  });

  test('согласие даётся и отзывается', () async {
    final consent = repo.watchAnalyticsConsent();

    await repo.setAnalyticsConsent(granted: true);
    expect(await consent.first, isTrue);

    await repo.setAnalyticsConsent(granted: false);
    expect(await consent.first, isFalse);
  });
}
