// Считывания карты водителя. План тестов: REP-03 в docs/testing.md.
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tachogo/data/db/app_database.dart';
import 'package:tachogo/data/journal/card_download_repository.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  test('без считываний — null', () async {
    expect(await CardDownloadRepository(db).watchLast().first, isNull);
  });

  test('последнее — самое позднее, даже если записано не по порядку', () async {
    for (final t in [
      DateTime.utc(2026, 9, 20),
      DateTime.utc(2026, 9, 22, 18),
      DateTime.utc(2026, 9, 21),
    ]) {
      await CardDownloadRepository(db, clock: () => t).record();
    }
    expect(
      await CardDownloadRepository(db).watchLast().first,
      DateTime.utc(2026, 9, 22, 18),
    );
  });

  test('часы в местном времени записываются и читаются в UTC', () async {
    final local = DateTime.utc(2026, 9, 23, 6, 30).toLocal();
    await CardDownloadRepository(db, clock: () => local).record();

    final last = await CardDownloadRepository(db).watchLast().first;
    expect(last, DateTime.utc(2026, 9, 23, 6, 30));
    expect(last!.isUtc, isTrue);
  });

  test('новое считывание приходит в поток', () async {
    final repo = CardDownloadRepository(
      db,
      clock: () => DateTime.utc(2026, 9, 23),
    );
    final values = repo.watchLast();
    expect(await values.first, isNull);
    await repo.record();
    expect(await values.first, DateTime.utc(2026, 9, 23));
  });
}
