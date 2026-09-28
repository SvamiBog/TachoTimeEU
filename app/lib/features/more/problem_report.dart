import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tachogo/core/config/app_env.dart';
import 'package:tachogo/core/diagnostics/diagnostics.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/widgets/confirm_sheet.dart';

// «Сообщить о проблеме» (Фаза 4, закрытая бета): водитель описывает, что
// случилось, а приложение прикладывает диагностику — версию, телефон,
// настройки, разрешения, расписание уведомлений и журнал за двое суток.
// Отправка — через системное «Поделиться»: почта или мессенджер, куда
// тестировщики уже пишут. В релизе вместо неё — обратная связь с адресом
// поддержки (Фаза 7).

/// Строка есть в бете и в сборке разработчика, в релизе — нет.
final problemReportEnabledProvider = Provider<bool>(
  (ref) => !AppEnv.current.isProd,
);

/// Отдаёт текст в системное «Поделиться». В тестах подменяется.
abstract interface class TextSharer {
  Future<void> share({required String text, required String subject});
}

class SystemTextSharer implements TextSharer {
  const new();

  @override
  Future<void> share({required String text, required String subject}) async {
    await SharePlus.instance.share(ShareParams(text: text, subject: subject));
  }
}

final textSharerProvider = Provider<TextSharer>(
  (ref) => const SystemTextSharer(),
);

/// Сообщение с отчётом: приглашение водителю написать своими словами, под
/// ним — диагностика.
String problemMessage(AppLocalizations l, Diagnostics d) =>
    '${l.problemPrompt}\n\n\n———\n${formatDiagnostics(d)}\n';

/// Шторка с пояснением, что уйдёт в отчёте, затем «Поделиться».
Future<void> sendProblemReport(BuildContext context, WidgetRef ref) async {
  final l = context.l10n;
  final messenger = ScaffoldMessenger.of(context);
  final ok = await showConfirmSheet(
    context,
    title: l.problemTitle,
    text: l.problemText,
    confirm: l.problemSend,
    cancel: l.cancel,
  );
  if (ok != true) return;
  try {
    final diagnostics = await ref.read(diagnosticsCollectorProvider).collect();
    await ref
        .read(textSharerProvider)
        .share(text: problemMessage(l, diagnostics), subject: l.problemSubject);
  } on Object catch (e, st) {
    FlutterError.reportError(
      FlutterErrorDetails(exception: e, stack: st, library: 'problem report'),
    );
    messenger.showSnackBar(SnackBar(content: Text(l.problemFailed)));
  }
}
