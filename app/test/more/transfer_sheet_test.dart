// «Ещё» → «Перенос на другой телефон»: журнал в файл и из файла. План
// тестов: TRF-07 в docs/testing.md (формат и замена — backup/
// journal_backup_test.dart).

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/data/backup/journal_backup.dart';
import 'package:tachogo/data/db/app_database.dart';
import 'package:tachogo/data/journal/activity_repository.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/features/export/report_exporter.dart';
import 'package:tachogo/features/more/more_screen.dart';
import 'package:tachogo/features/more/transfer_sheet.dart';

import '../support/app_harness.dart';

/// «Поделиться» в памяти: какие файлы ушли водителю.
class _FakeSharer implements ReportSharer {
  final files = <({String name, Uint8List bytes, String mime})>[];
  Error? error;

  @override
  Future<void> share({
    required String fileName,
    required Uint8List bytes,
    required String mimeType,
  }) async {
    if (error case final e?) throw e;
    files.add((name: fileName, bytes: bytes, mime: mimeType));
  }
}

/// Выбор файла: отдаёт заданное содержимое; null — водитель передумал.
class _FakePicker implements BackupFilePicker {
  Uint8List? file;
  int opened = 0;

  @override
  Future<Uint8List?> pick() async {
    opened++;
    return file;
  }
}

void main() {
  final now = DateTime.utc(2026, 9, 23, 12);
  late AppDatabase phone;
  late _FakeSharer sharer;
  late _FakePicker picker;
  late int changed;

  setUp(() {
    phone = memoryDatabase();
    sharer = _FakeSharer();
    picker = _FakePicker();
    changed = 0;
  });
  tearDown(() => phone.close());

  /// Журнал из двух записей режимов, начало — [start].
  Future<void> seed(AppDatabase db, DateTime start) async {
    var t = start;
    final activity = ActivityRepository(db, clock: () => t);
    await activity.switchMode(DriverMode.driving);
    t = t.add(const Duration(hours: 3));
    await activity.switchMode(DriverMode.rest);
  }

  /// Файл переноса со старого телефона: журнал с [start].
  Future<Uint8List> oldPhoneFile(WidgetTester tester, DateTime start) async {
    final old = memoryDatabase();
    addTearDown(old.close);
    return (await tester.runAsync(() async {
      await seed(old, start);
      return await JournalBackup(old, clock: () => now).export();
    }))!;
  }

  Future<List<ActivityPeriod>> periods(WidgetTester tester) async =>
      (await tester.runAsync(ActivityRepository(phone).periods))!;

  Future<void> openSheet(WidgetTester tester) async {
    await pumpScreen(
      tester,
      const MoreScreen(),
      overrides: [
        ...journalOverrides(periods: const [], now: now),
        journalBackupProvider.overrideWithValue(
          JournalBackup(phone, clock: () => now, onChanged: () => changed++),
        ),
        reportSharerProvider.overrideWithValue(sharer),
        backupFilePickerProvider.overrideWithValue(picker),
      ],
    );
    expect(find.text('Журнал — файлом через мессенджер или почту'), findsOne);
    await tester.tap(find.text('Перенос на другой телефон'));
    await settle(tester);
    expect(find.byType(TransferSheet), findsOneWidget);
  }

  Future<void> tap(WidgetTester tester, String text) async {
    await tester.tap(find.text(text));
    await settle(tester);
  }

  testWidgets('TRF-07: «Сохранить журнал в файл» — файл переноса в '
      '«Поделиться», шторка закрыта', (tester) async {
    await tester.runAsync(
      () => seed(phone, now.subtract(const Duration(hours: 5))),
    );
    await openSheet(tester);
    await tap(tester, 'Сохранить журнал в файл');

    expect(sharer.files, hasLength(1));
    final file = sharer.files.single;
    expect(file.name, matches(r'^tachogo-journal-\d{4}-\d\d-\d\d\.json$'));
    expect(file.mime, 'application/json');
    final contents = JournalBackup.parse(file.bytes);
    expect(contents.periods, hasLength(2));
    expect(find.byType(TransferSheet), findsNothing);
    await unmount(tester);
  });

  testWidgets('TRF-07: не удалось сохранить — сообщение, шторка открыта', (
    tester,
  ) async {
    sharer.error = StateError('нет приложения');
    await openSheet(tester);
    await tap(tester, 'Сохранить журнал в файл');
    expect(tester.takeException(), isA<StateError>());
    expect(
      find.text('Не удалось сохранить файл. Попробуйте ещё раз.'),
      findsOneWidget,
    );
    expect(find.byType(TransferSheet), findsOneWidget);
    await unmount(tester);
  });

  testWidgets('TRF-07: пустой телефон — журнал из файла загружается после '
      'подтверждения с датами', (tester) async {
    picker.file = await oldPhoneFile(tester, DateTime.utc(2026, 9, 20, 6));
    await openSheet(tester);
    await tap(tester, 'Загрузить журнал из файла');

    expect(find.text('Загрузить журнал?'), findsOneWidget);
    expect(
      find.text('В файле — журнал с 20.09.2026 по 20.09.2026.'),
      findsOneWidget,
    );
    await tap(tester, 'Загрузить');

    expect(await periods(tester), hasLength(2));
    expect(changed, 1);
    expect(find.text('Журнал загружен'), findsOneWidget);
    expect(find.byType(TransferSheet), findsNothing);
    await unmount(tester);
  });

  testWidgets('TRF-07: на телефоне есть журнал — предупреждение о замене; '
      '«Отмена» ничего не меняет', (tester) async {
    await tester.runAsync(
      () => seed(phone, now.subtract(const Duration(hours: 5))),
    );
    picker.file = await oldPhoneFile(tester, DateTime.utc(2026, 9, 10, 6));
    await openSheet(tester);
    await tap(tester, 'Загрузить журнал из файла');

    expect(
      find.text(
        'В файле — журнал с 10.09.2026 по 10.09.2026. Журнал на этом '
        'телефоне будет заменён журналом из файла.',
      ),
      findsOneWidget,
    );
    await tap(tester, 'Отмена');
    final kept = await periods(tester);
    expect(kept.first.start, now.subtract(const Duration(hours: 5)));
    expect(changed, 0);

    await tap(tester, 'Загрузить журнал из файла');
    await tap(tester, 'Загрузить');
    final replaced = await periods(tester);
    expect(replaced.first.start, DateTime.utc(2026, 9, 10, 6));
    expect(replaced, hasLength(2));
    await unmount(tester);
  });

  testWidgets('TRF-07: чужой, новый, повреждённый и пустой файл — понятное '
      'сообщение, журнал не тронут', (tester) async {
    final good = jsonDecode(
      utf8.decode(await oldPhoneFile(tester, DateTime.utc(2026, 9, 20, 6))),
    ) as Map<String, Object?>;
    Uint8List encode(Map<String, Object?> json) =>
        utf8.encode(jsonEncode(json));
    final cases = <Uint8List, String>{
      utf8.encode('activity,start_utc\n'):
          'Это не файл журнала TachoGo — выберите файл tachogo-journal',
      encode({...good, 'version': 99}):
          'Файл сохранён в более новой версии TachoGo — обновите приложение',
      encode({...good, 'periods': 'none'}):
          'Файл журнала повреждён — сохраните его на старом телефоне заново',
      encode({...good, 'periods': <Object?>[], 'manualShifts': <Object?>[]}):
          'В файле нет записей журнала',
    };
    await openSheet(tester);
    for (final MapEntry(key: file, value: message) in cases.entries) {
      picker.file = file;
      await tap(tester, 'Загрузить журнал из файла');
      expect(find.text(message), findsOneWidget);
      expect(find.text('Загрузить журнал?'), findsNothing);
      ScaffoldMessenger.of(tester.element(find.byType(TransferSheet)))
          .removeCurrentSnackBar();
      await settle(tester);
    }
    expect(await periods(tester), isEmpty);
    expect(changed, 0);
    await unmount(tester);
  });

  testWidgets('TRF-07: файл не выбран — ничего не происходит', (tester) async {
    await openSheet(tester);
    await tap(tester, 'Загрузить журнал из файла');
    expect(picker.opened, 1);
    expect(find.text('Загрузить журнал?'), findsNothing);
    expect(find.byType(SnackBar), findsNothing);
    expect(find.byType(TransferSheet), findsOneWidget);
    await unmount(tester);
  });
}
