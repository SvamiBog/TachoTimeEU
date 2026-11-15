/// Scanner for the `live-text` skill: lists ARB messages with the signs of
/// dead interface text — officialese, long texts, dash chains, repeats
/// across screens, terms that drift from the glossary, translations much
/// longer than the Russian source.
///
/// ```sh
/// dart run .claude/skills/live-text/scan.dart              # ru, flagged only
/// dart run .claude/skills/live-text/scan.dart --all        # every message
/// dart run .claude/skills/live-text/scan.dart --lang uk    # a translation
/// dart run .claude/skills/live-text/scan.dart --keys a,b   # chosen keys
/// dart run .claude/skills/live-text/scan.dart --stale      # ru changed since
///                              # HEAD, translation not (add --lang to see it)
/// ```
///
/// Flags are hints for a human reader, not errors: a rule footer may be
/// long, a PDF line may be formal. The decision stays with the editor.
library;

import 'dart:convert';
import 'dart:io';

const _arbDir = 'app/lib/l10n';

/// Канцелярит и штампы: основа слова → чем заменить.
const _officialese = {
  'в пределах': 'за / не позже чем через',
  'осуществ': 'глагол действия',
  'производит': 'глагол действия',
  'является': 'тире или «это»',
  'являются': 'тире или «это»',
  'данный': 'этот',
  'данная': 'эта',
  'при наличии': 'если есть',
  'в случае': 'если',
  'с целью': 'чтобы',
  'в целях': 'чтобы',
  'посредством': 'через / по',
  'необходимо': 'нужно',
  'возможно ': 'можно',
  'в настоящее время': 'сейчас',
  'на данный момент': 'сейчас',
  'будет удал': 'действительный залог: «сотрётся», «удалим»',
  'будут удал': 'действительный залог',
  'будет замен': 'действительный залог: «заменится»',
  'будет прерв': 'действительный залог: «прервётся»',
  'корректир': 'исправить',
  'функци': 'что именно делает',
  'позволяет': 'можно',
  'ознакомьтесь': 'прочитайте / посмотрите',
  'успешно': 'просто факт: «Сохранено»',
  'пожалуйста': 'без вежливых вставок',
  'под контролем': 'конкретный факт вместо слогана',
  'под вас': 'конкретный факт вместо слогана',
  'легко': 'без оценки',
  'удобно': 'без оценки',
  'всего лишь': 'без оценки',
  'реальном времени': 'сейчас / сразу',
  'для того чтобы': 'чтобы',
  'в том числе': 'и / список',
  'а также': 'и',
  'соответств': 'по / как',
  'обеспеч': 'что именно происходит',
  'именно в таком': 'лишнее усиление',
  'шесть периодов': '144 ч / 6 × 24 ч',
  'приложение ': 'кто действует: вы, мы или сам факт',
};

/// Термины повторяются по делу: повтор объяснения ищем среди остальных фраз.
const _termPhrases = {
  'попробуйте ещё раз',
  'конец рабочего дня',
  'конца рабочего дня',
  'начните суточный отдых',
  'сокращённый недельный отдых',
  'сокращённых недельных отдыха',
  'два сокращённых недельных',
  'отдых после смены',
  'недельный отдых набран',
  'вождение две недели',
  'нужен перерыв мин',
};

/// Глоссарий: вариант → слово, которое уже принято в приложении.
const _glossary = {
  // «Удлинённый день» (15 ч) — другое понятие, его не трогаем
  'удлинени': 'продление (вождения до 10 ч)',
  'регулярн': 'полный (кроме цитаты регламента в инструкции)',
  'страна регистрации': 'страна фирмы',
  'страны регистрации': 'страна фирмы',
  'пауз': 'перерыв',
  'тахо ': 'тахограф',
  'сократк': 'сокращённый',
};

void main(List<String> args) {
  final lang = _option(args, '--lang') ?? 'ru';
  final keys = _option(args, '--keys')?.split(',').toSet();
  final all = args.contains('--all');
  if (args.contains('--stale')) return _stale(lang);

  final arb = _read(lang);
  final ru = lang == 'ru' ? arb : _read('ru');
  final messages = _messages(arb);
  final repeats = lang == 'ru' ? _repeats(messages) : <String, String>{};
  final byText = <String, List<String>>{};
  for (final MapEntry(:key, :value) in messages.entries) {
    byText.putIfAbsent(value, () => []).add(key);
  }

  var flagged = 0;
  for (final MapEntry(:key, :value) in messages.entries) {
    if (keys != null && !keys.contains(key)) continue;
    final flags = <String>[
      ..._shape(value),
      if (lang == 'ru') ..._words(value),
      if (lang != 'ru') ..._translation(lang, value, _messages(ru)[key]),
      for (final other in byText[value]!)
        if (other != key && value.length > 25) 'dup:$other',
      if (repeats[key] case final phrase?) 'repeat:"$phrase"',
    ];
    if (flags.isEmpty && !all && keys == null) continue;
    if (flags.isNotEmpty) flagged++;
    final description =
        (arb['@$key'] as Map?)?['description'] ??
        (ru['@$key'] as Map?)?['description'];
    stdout
      ..writeln('$key  ${flags.isEmpty ? '' : '[${flags.join(', ')}]'}')
      ..writeln('  $value');
    if (description != null) stdout.writeln('  # $description');
  }
  stdout.writeln('\n$lang: ${messages.length} messages, $flagged flagged');
}

/// Русский изменён с последнего коммита, а перевод остался прежним: правка
/// не дошла до языка. С `--lang` показывает и сам перевод.
void _stale(String lang) {
  final ruNow = _messages(_read('ru'));
  final ruWas = _messages(_head('ru'));
  final langs = [
    for (final file in Directory(_arbDir).listSync().whereType<File>())
      if (RegExp(r'app_(\w+)\.arb$').firstMatch(file.path) case final m?)
        if (m[1] != 'ru') m[1]!,
  ]..sort();
  final now = {for (final l in langs) l: _messages(_read(l))};
  final was = {for (final l in langs) l: _messages(_head(l))};

  var stale = 0;
  for (final MapEntry(:key, :value) in ruNow.entries) {
    if (ruWas[key] == null || ruWas[key] == value) continue;
    final same = [
      for (final l in langs)
        if (now[l]![key] == was[l]![key]) l,
    ];
    if (same.isEmpty) continue;
    stale++;
    stdout
      ..writeln('$key  [unchanged: ${same.join(', ')}]')
      ..writeln('  ru was: ${ruWas[key]}')
      ..writeln('  ru now: $value');
    if (same.contains(lang)) stdout.writeln('  $lang: ${now[lang]![key]}');
  }
  stdout.writeln('\n$stale changed ru messages with untouched translations');
}

/// ARB языка из последнего коммита.
Map<String, dynamic> _head(String lang) {
  final result = Process.runSync('git', [
    'show',
    'HEAD:$_arbDir/app_$lang.arb',
  ], stdoutEncoding: utf8);
  if (result.exitCode != 0) {
    stderr.writeln('git show: ${result.stderr}');
    exit(69);
  }
  return jsonDecode(result.stdout as String) as Map<String, dynamic>;
}

/// Форма текста: длина, число фраз, цепочки тире, скобки с пояснением.
List<String> _shape(String text) {
  final plain = _plain(text);
  final sentences = RegExp(r'[.!?](\s|$)').allMatches(plain).length;
  final dashes = ' — '.allMatches(plain).length;
  return [
    if (plain.length > 120) 'long:${plain.length}',
    if (sentences > 2) 'sentences:$sentences',
    if (dashes > 1) 'dashes:$dashes',
    // «(ст. 8(6))» и «(UTC)» — ссылки и коды, не пояснение
    if (RegExp(r'\((?!ст\.|art|\d|[A-Z]{2,})[^)]{12,}\)').hasMatch(plain))
      'parens',
    if (plain.contains('!')) 'exclamation',
  ];
}

List<String> _words(String text) {
  final lower = text.toLowerCase();
  return [
    for (final MapEntry(:key, :value) in _officialese.entries)
      if (lower.contains(key)) 'word:"${key.trim()}" → $value',
    for (final MapEntry(:key, :value) in _glossary.entries)
      if (lower.contains(key)) 'term:"${key.trim()}" → $value',
  ];
}

/// Языки на кириллице: «Журнал», «Назад» совпадают с русским по праву.
const _cyrillic = {'uk', 'be', 'kk', 'ky', 'bg', 'sr', 'mk'};

/// Перевод: заметно длиннее русского или не переведён. Длинный перевод
/// после правки русского — часто старое лишнее, которое осталось в языке.
List<String> _translation(String lang, String text, String? source) {
  if (source == null) return ['missing-in-ru'];
  final ratio = _plain(text).length / _plain(source).length.clamp(1, 1 << 20);
  return [
    if (_plain(source).length > 20 && ratio > 1.6)
      'ratio:${ratio.toStringAsFixed(1)}',
    if (!_cyrillic.contains(lang) && RegExp('[а-яё]').hasMatch(text))
      'untranslated',
  ];
}

/// Фразы из трёх слов, которые повторяются в трёх строках и больше:
/// одно и то же объяснение на нескольких экранах.
Map<String, String> _repeats(Map<String, String> messages) {
  final where = <String, Set<String>>{};
  for (final MapEntry(:key, :value) in messages.entries) {
    final words = _plain(value)
        .toLowerCase()
        .replaceAll(RegExp(r'[^\p{L}\s]', unicode: true), ' ')
        .split(RegExp(r'\s+'))
        .where((w) => w.length > 2)
        .toList();
    for (var i = 0; i + 2 < words.length; i++) {
      final three = words.sublist(i, i + 3);
      // «час часа часов» — формы одного слова в plural, не фраза
      if (three.map((w) => w[0]).toSet().length == 1) continue;
      final phrase = three.join(' ');
      if (_termPhrases.contains(phrase)) continue;
      where.putIfAbsent(phrase, () => {}).add(key);
    }
  }
  final result = <String, String>{};
  for (final MapEntry(key: phrase, value: keys) in where.entries) {
    if (keys.length < 3) continue;
    for (final key in keys) {
      result.putIfAbsent(key, () => phrase);
    }
  }
  return result;
}

/// Текст без синтаксиса ICU: подстановки — как «0:00».
String _plain(String text) => text
    .replaceAll(RegExp(r'\{\w+, (plural|select),'), '')
    .replaceAll(RegExp(r'\b(one|few|many|other|zero|two)\{'), '')
    .replaceAll(RegExp(r'\{\w+\}'), '0:00')
    .replaceAll(RegExp(r'[{}]'), '');

Map<String, dynamic> _read(String lang) {
  final file = File('$_arbDir/app_$lang.arb');
  if (!file.existsSync()) {
    stderr.writeln('нет ${file.path}: запускать из корня репозитория');
    exit(64);
  }
  return jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
}

Map<String, String> _messages(Map<String, dynamic> arb) => {
  for (final MapEntry(:key, :value) in arb.entries)
    if (!key.startsWith('@')) key: value as String,
};

String? _option(List<String> args, String name) {
  final i = args.indexOf(name);
  return i >= 0 && i + 1 < args.length ? args[i + 1] : null;
}
