/// External web pages the app links to, and how it opens them.
///
/// Google Play requires the privacy policy link inside the app, and the
/// policy on government information asks for a source the driver can check
/// the rules against (`docs/store/play-audit.md`).
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

/// Политика конфиденциальности — страница `site/privacy/index.html` на
/// GitHub Pages. Тот же адрес — в Play Console. Домен — открытый вопрос 11
/// PRD: при переезде сменить здесь, в `banDataUri`
/// (`data/bans/ban_data_file.dart`), в Play Console и в
/// `docs/beta/play-console.md`, а по старому адресу оставить переадресацию —
/// ссылку из уже установленных версий не поменять.
const privacyPolicyPage = 'https://svamibog.github.io/TachoTimeEU/privacy/';

/// Политика на языке интерфейса: на странице русский и английский текст,
/// остальным языкам — английский.
Uri privacyPolicyUri(String languageCode) =>
    Uri.parse('$privacyPolicyPage#${languageCode == 'ru' ? 'ru' : 'en'}');

/// Регламент (ЕС) 561/2006 на EUR-Lex — официальный текст правил. Тот же
/// адрес — в описании приложения в Google Play (`docs/store/listing/`).
const regulationPage = 'https://eur-lex.europa.eu/eli/reg/2006/561/oj';

/// Коды EUR-Lex для языков интерфейса, которые есть среди языков ЕС.
const _eurLexLanguages = {
  'pl': 'pol',
  'ro': 'ron',
  'en': 'eng',
  'de': 'deu',
  'fr': 'fra',
  'es': 'spa',
  'it': 'ita',
  'nl': 'nld',
  'cs': 'ces',
  'sk': 'slk',
};

/// Регламент на языке интерфейса. Русского, украинского, грузинского и
/// узбекского среди языков ЕС нет — им страница с выбором языка.
Uri regulationUri(String languageCode) {
  final language = _eurLexLanguages[languageCode];
  return Uri.parse(
    language == null ? regulationPage : '$regulationPage/$language',
  );
}

/// Opens web links in an external browser; tests replace it with a fake.
abstract interface class LinkOpener {
  /// false — открыть нечем (на телефоне нет браузера).
  Future<bool> open(Uri uri);
}

/// [LinkOpener] backed by the `url_launcher` plugin.
class SystemLinkOpener implements LinkOpener {
  const new();

  @override
  Future<bool> open(Uri uri) =>
      launchUrl(uri, mode: LaunchMode.externalApplication);
}

final linkOpenerProvider = Provider<LinkOpener>(
  (ref) => const SystemLinkOpener(),
);

/// Открывает [uri] в браузере. Открыть нечем — адрес [address] в плашке:
/// водитель откроет его сам.
Future<void> openLink(
  BuildContext context,
  WidgetRef ref,
  Uri uri, {
  required String address,
}) async {
  final l = context.l10n;
  final messenger = ScaffoldMessenger.of(context);
  var opened = false;
  try {
    opened = await ref.read(linkOpenerProvider).open(uri);
  } on Object catch (e, st) {
    FlutterError.reportError(
      FlutterErrorDetails(exception: e, stack: st, library: 'links'),
    );
  }
  if (!opened) {
    messenger.showSnackBar(SnackBar(content: Text(l.linkFailed(address))));
  }
}
