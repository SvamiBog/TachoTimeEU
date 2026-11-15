/// A driver's action that writes to the journal, with a failure handled the
/// same way everywhere: reported to crash reporting and shown to the driver.
library;

import 'package:flutter/material.dart';
import 'package:tachogo/core/l10n/l10n.dart';

/// Writes to the journal and returns whether it worked.
typedef JournalSaver = Future<bool> Function(Future<void> Function() write);

/// Запись в журнал по действию водителя: «Завершить день», корректировки с
/// экранов лимитов. Не получилось — ошибка уходит в отчёт о падениях
/// ([reportSaveError]), а водитель видит «Не удалось сохранить»: молча
/// терять его правку нельзя.
///
/// Берётся до шторки ввода: после неё экран, с которого начали, может быть
/// закрыт, а сообщение и запись всё равно нужны.
JournalSaver journalSaver(BuildContext context) {
  final messenger = ScaffoldMessenger.maybeOf(context);
  final failed = context.l10n.shiftSaveFailed;
  return (write) async {
    try {
      await write();
      return true;
    } on Object catch (error, stack) {
      reportSaveError(error, stack);
      messenger?.showSnackBar(SnackBar(content: Text(failed)));
      return false;
    }
  };
}

/// Ошибка записи в журнал — в отчёт о падениях: `FlutterError.onError`
/// передаёт её в `CrashReporter` (`bootstrap.dart`).
void reportSaveError(Object error, StackTrace stack) =>
    FlutterError.reportError(
      FlutterErrorDetails(exception: error, stack: stack, library: 'journal'),
    );
