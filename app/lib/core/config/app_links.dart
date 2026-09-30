import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

/// Политика конфиденциальности — страница `site/privacy/index.html` на
/// GitHub Pages. Тот же адрес — в Play Console. Домен — открытый вопрос 11
/// PRD: при переезде сменить здесь, в Play Console и в
/// `docs/beta/play-console.md`, а по старому адресу оставить переадресацию —
/// ссылку из уже установленных версий не поменять.
const privacyPolicyPage = 'https://svamibog.github.io/TachoTimeEU/privacy/';

/// Политика на языке интерфейса: на странице русский и английский текст,
/// остальным языкам — английский.
Uri privacyPolicyUri(String languageCode) =>
    Uri.parse('$privacyPolicyPage#${languageCode == 'ru' ? 'ru' : 'en'}');

/// Открывает ссылку во внешнем браузере. Обёртка над плагином — для тестов.
abstract interface class LinkOpener {
  /// false — открыть нечем (на телефоне нет браузера).
  Future<bool> open(Uri uri);
}

class SystemLinkOpener implements LinkOpener {
  const new();

  @override
  Future<bool> open(Uri uri) =>
      launchUrl(uri, mode: LaunchMode.externalApplication);
}

final linkOpenerProvider = Provider<LinkOpener>(
  (ref) => const SystemLinkOpener(),
);
