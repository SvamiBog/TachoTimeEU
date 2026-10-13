// Страница TachoGo в Google Play: тексты и подписи скриншотов по языкам
// страницы — docs/store/listing/<язык Play>/. Читают проверка текстов
// (STORE-01) и генератор скриншотов (STORE-02, STORE-03).

import 'dart:io';
import 'dart:ui';

/// Языки страницы в Play и язык интерфейса на её скриншотах. Узбекского
/// среди языков страницы в Play нет: водитель с узбекским телефоном видит
/// страницу по умолчанию — русскую.
const storeLocales = <String, Locale>{
  'ru-RU': Locale('ru'),
  'uk': Locale('uk'),
  'pl-PL': Locale('pl'),
  'ro': Locale('ro'),
  'ka-GE': Locale('ka'),
  'en-US': Locale('en'),
  'de-DE': Locale('de'),
  'fr-FR': Locale('fr'),
  'es-ES': Locale('es'),
  'it-IT': Locale('it'),
  'nl-NL': Locale('nl'),
  'cs-CZ': Locale('cs'),
  'sk': Locale('sk'),
};

/// Тексты страницы; тесты запускаются из `app/`.
final listingDir = Directory('../docs/store/listing');

/// Подпись скриншота: крупно и пояснение под ней.
typedef Caption = ({String title, String subtitle});

/// Страница на одном языке.
typedef StoreListing = ({
  String title,
  String short,
  String full,
  List<Caption> captions,
});

StoreListing readListing(String locale) {
  String read(String name) =>
      File('${listingDir.path}/$locale/$name').readAsStringSync().trim();
  return (
    title: read('title.txt'),
    short: read('short_description.txt'),
    full: read('full_description.txt'),
    captions: [
      for (final line in read('captions.txt').split('\n'))
        if (line.split('|') case [final title, final subtitle])
          (title: title.trim(), subtitle: subtitle.trim()),
    ],
  );
}
