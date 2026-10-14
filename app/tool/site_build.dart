/// Landing pages of the TachoGo website (`docs/site/README.md`): one page per
/// site language from a single template, plus `sitemap.xml` and `robots.txt`.
///
/// Texts come from `docs/site/<language>.json`; the phone on the page speaks
/// the app's own strings (`lib/l10n/app_<language>.arb`), and the driving ban
/// countries come from the engine — so the page cannot promise what the app
/// does not show. The pages load nothing from other sites: fonts are in
/// `site/fonts/`, there are no cookies and no analytics.
///
/// ```sh
/// dart run tool/site_build.dart <site directory>
/// ```
///
/// The "Site" workflow (`site.yml`) runs it before publishing; the pages
/// are not kept in git. English is the site root and `x-default`, other
/// languages live in `<language>/`.
library;

// Генератор HTML: соседние строки склеиваются без пробелов намеренно.
// ignore_for_file: missing_whitespace_between_adjacent_strings
// ignore_for_file: no_adjacent_strings_in_list

import 'dart:convert';
import 'dart:io';

import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:tacho_engine/driving_bans.dart';

/// Адрес сайта. Тот же, что у политики (`privacyPolicyPage` в
/// `lib/core/config/app_links.dart`, проверяет SITE-01): при переезде на свой
/// домен — сменить оба.
const siteBase = 'https://tachogo.eu/';

/// Почта для связи и заявок в бету — та же, что в политике.
const contactEmail = 'support@tachogo.eu';

/// Языки сайта — английский, польский и немецкий (решение 2026-10-14):
/// часть языков приложения. Первый — корень сайта: туда же попадают
/// посетители с остальными языками браузера.
const siteLanguages = ['en', 'pl', 'de'];

/// Название языка на нём самом — в переключателе.
const languageNames = {'en': 'English', 'pl': 'Polski', 'de': 'Deutsch'};

/// Языки браузера, для которых корень сайта открывает другую страницу.
final Map<String, String> _browserLanguages = {
  for (final l in siteLanguages.skip(1)) l: l,
};

const _ogLocales = {'en': 'en_GB', 'pl': 'pl_PL', 'de': 'de_DE'};

/// Коды EUR-Lex — как `regulationUri` в приложении (проверяет SITE-01).
const _eurLex = {
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

/// Цены Premium (`docs/premium.md`, решение 2026-10-13).
const ({double month, double year, double forever}) premiumPrices = (
  month: 2.99,
  year: 19.99,
  forever: 39.99,
);

/// Папка страницы от корня сайта: «» у корня, «pl/» у остальных.
String pagePath(String language) =>
    language == siteLanguages.first ? '' : '$language/';

/// Регламент 561/2006 на EUR-Lex на языке страницы.
String regulationUrl(String language) {
  final code = _eurLex[language];
  const page = 'https://eur-lex.europa.eu/eli/reg/2006/561/oj';
  return code == null ? page : '$page/$code';
}

/// Политика на языке страницы: на ней русский и английский текст.
String privacyAnchor(String language) => language == 'ru' ? 'ru' : 'en';

/// Все файлы сайта, которые собирает генератор: путь от корня сайта →
/// содержимое. [docs] — тексты, [arb] — строки приложения, пути от `app/`.
Future<Map<String, String>> buildSite({
  String docs = '../docs/site',
  String arb = 'lib/l10n',
}) async {
  await initializeDateFormatting();
  final files = <String, String>{};
  for (final language in siteLanguages) {
    files['${pagePath(language)}index.html'] = landingPage(
      language,
      SiteTexts(language, _json('$docs/$language.json')),
      _json('$arb/app_$language.arb'),
    );
  }
  files['sitemap.xml'] = _sitemap();
  files['robots.txt'] =
      'User-agent: *\nAllow: /\n\nSitemap: ${siteBase}sitemap.xml\n';
  return files;
}

Map<String, Object?> _json(String path) =>
    jsonDecode(File(path).readAsStringSync()) as Map<String, Object?>;

/// Texts of one landing page: `docs/site/<language>.json`, HTML-escaped.
class SiteTexts {
  /// [values] — разобранный файл текстов языка [language].
  new(this.language, this.values);

  /// Код языка страницы.
  final String language;

  /// Строки, списки строк и формы множественного числа по ключам.
  final Map<String, Object?> values;

  /// Строка без экранирования; нет ключа — ошибка с именем файла.
  String raw(String key) {
    final value = values[key];
    if (value is! String) {
      throw FormatException('docs/site/$language.json: нет строки «$key»');
    }
    return value;
  }

  /// Строка для HTML.
  String operator [](String key) => escapeHtml(raw(key));

  /// Список строк — строки заголовка.
  List<String> lines(String key) {
    final value = values[key];
    if (value is! List || value.isEmpty || value.any((v) => v is! String)) {
      throw FormatException('docs/site/$language.json: нет списка «$key»');
    }
    return [for (final v in value) escapeHtml(v as String)];
  }

  /// Форма множественного числа по правилам языка, `{count}` — число.
  String plural(String key, int count) {
    final value = values[key];
    if (value is! Map || value['other'] is! String) {
      throw FormatException('docs/site/$language.json: нет форм «$key»');
    }
    String? form(String name) => value[name] as String?;
    final text = Intl.plural(
      count,
      zero: form('zero'),
      one: form('one'),
      two: form('two'),
      few: form('few'),
      many: form('many'),
      other: form('other')!,
      locale: language,
    );
    return escapeHtml(text.replaceAll('{count}', '$count'));
  }
}

/// Текст и значения атрибутов для HTML.
String escapeHtml(String text) => text
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;');

/// Строка приложения из ARB с подставленными значениями.
String _appString(
  Map<String, Object?> arb,
  String key, [
  Map<String, String> args = const {},
]) {
  var text = arb[key]! as String;
  for (final MapEntry(:key, :value) in args.entries) {
    text = text.replaceAll('{$key}', value);
  }
  return escapeHtml(text);
}

/// Название страны по отличительному знаку — из `countryName` приложения.
String _countryName(Map<String, Object?> arb, String code) {
  final names = arb['countryName']! as String;
  final match = RegExp('[ ,]$code\\{([^}]*)\\}').firstMatch(names);
  return escapeHtml(match?[1] ?? code);
}

/// «Ср, 23 сентября» — как `formatWeekdayDate` в шапке главной (SITE-01
/// сверяет).
String weekdayDate(DateTime t, String language) {
  final full = DateFormat.MMMMEEEEd(language).pattern!;
  final short = full.replaceAll('EEEE', 'EEE').replaceAll('cccc', 'ccc');
  final text = DateFormat(short, language).format(t);
  return text.isEmpty ? text : text[0].toUpperCase() + text.substring(1);
}

String _price(double value, String language) => NumberFormat.currency(
  locale: language,
  symbol: '€',
  decimalDigits: 2,
).format(value);

String _mailto(SiteTexts t) =>
    'mailto:$contactEmail?subject=${Uri.encodeComponent(t.raw('mail_subject'))}'
    '&body=${Uri.encodeComponent(t.raw('mail_body'))}';

/// Отличительный знак TachoGo (`docs/brand/mark/`): кольцо [ring], стрелка
/// и ось [needle].
String _mark(String ring, String needle, int size) =>
    '<svg width="$size" height="$size" viewBox="15 15 70 70" '
    'aria-hidden="true">'
    '<path d="M63.61 24.39A29 29 0 1 0 78.72 45.96" fill="none" '
    'stroke="$ring" stroke-width="11" stroke-linecap="round"/>'
    '<path d="M54.98 51.19L81.95 27.63L50.59 44.91Z" fill="$needle" '
    'stroke="$needle" stroke-width="1.5" stroke-linejoin="round"/>'
    '<path d="M42.5 50a7.5 7.5 0 1 0 15 0a7.5 7.5 0 1 0-15 0ZM47.6 50a2.4 2.4 '
    '0 1 0 4.8 0a2.4 2.4 0 1 0-4.8 0Z" fill="$needle" fill-rule="evenodd"/>'
    '</svg>';

/// Страница лендинга на языке [language]: [t] — тексты, [arb] — строки
/// приложения.
String landingPage(String language, SiteTexts t, Map<String, Object?> arb) {
  final root = language == siteLanguages.first ? '' : '../';
  final url = '$siteBase${pagePath(language)}';
  final mail = escapeHtml(_mailto(t));
  final bans = europeBans.values.toList();
  final shown = DateTime(2026, 9, 23);

  final alternates = [
    for (final l in siteLanguages)
      '<link rel="alternate" hreflang="$l" href="$siteBase${pagePath(l)}">',
    '<link rel="alternate" hreflang="x-default" href="$siteBase">',
  ].join('\n');

  final languageLinks = [
    for (final l in siteLanguages)
      '<li><a href="$root${pagePath(l)}" hreflang="$l" lang="$l"'
          '${l == language ? ' aria-current="page"' : ''}>'
          '${escapeHtml(languageNames[l]!)}</a></li>',
  ].join();

  final ld = jsonEncode({
    '@context': 'https://schema.org',
    '@type': 'SoftwareApplication',
    'name': 'TachoGo',
    'operatingSystem': 'Android',
    'applicationCategory': 'TravelApplication',
    'description': t.raw('description'),
    'inLanguage': language,
    'url': url,
    'offers': {'@type': 'Offer', 'price': '0', 'priceCurrency': 'EUR'},
  }).replaceAll('</', r'<\/');

  final redirect = language == siteLanguages.first
      ? '<script>(function(){try{var r=document.referrer;'
            'if(r&&r.indexOf(location.origin)===0)return;'
            'var m=${jsonEncode(_browserLanguages)};'
            'var l=navigator.languages||[navigator.language||""];'
            'for(var i=0;i<l.length;i++){var c=String(l[i]).toLowerCase()'
            '.split("-")[0];if(c==="en")return;'
            'if(m[c]){location.replace(m[c]+"/");return;}}}catch(e){}})();'
            '</script>\n'
      : '';

  final ticker = [
    (t['tick_driving'], '4:30'),
    (t['tick_break'], '0:45'),
    (t['tick_day'], '9:00 / 10:00'),
    (t['tick_week'], '56:00'),
    (t['tick_fortnight'], '90:00'),
    (t['tick_rest'], '11:00'),
    (t['tick_weekly_rest'], '45:00'),
  ].map((e) => '<span>${e.$1} ${e.$2}</span><i>■</i>').join();

  final features = [
    for (var i = 1; i <= 6; i++)
      '<li class="cell${i == 2 ? ' cell-accent' : ''}'
          '${i == 6 ? ' cell-navy' : ''}">'
          '<span class="num">0$i</span>'
          '<h3>${t['f${i}_title']}</h3>'
          '<p>${t['f${i}_text']}</p></li>',
  ].join('\n');

  final chips = [
    for (final c in bans)
      '<li class="chip chip-${c.coverage.name}" '
          'title="${_countryName(arb, c.code)}">'
          '<span aria-hidden="true">${c.code}</span>'
          '<span class="sr">${_countryName(arb, c.code)}</span></li>',
  ].join();

  final faq = [
    for (var i = 1; i <= 4; i++)
      '<div class="qa"><h3>${t['q$i']}</h3><p>${t['a$i']}</p></div>',
  ];

  final regulation =
      '<a href="${regulationUrl(language)}" hreflang="$language">'
      '${t['regulation']}</a>';

  final mode = [
    for (final key in ['modeRest', 'modeWork', 'modeAvailability'])
      _modeButton(arb[key]! as String, on: false),
  ].join();

  return '''
<!doctype html>
<html lang="$language">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>${t['title']}</title>
<meta name="description" content="${t['description']}">
<link rel="canonical" href="$url">
$alternates
<meta name="theme-color" content="#0F1E33">
<meta property="og:type" content="website">
<meta property="og:site_name" content="TachoGo">
<meta property="og:title" content="${t['title']}">
<meta property="og:description" content="${t['description']}">
<meta property="og:url" content="$url">
<meta property="og:image" content="${siteBase}icon-512.png">
<meta property="og:locale" content="${_ogLocales[language]}">
<link rel="icon" href="${root}favicon-32.png" sizes="32x32" type="image/png">
<link rel="icon" href="${root}favicon.svg" type="image/svg+xml">
<link rel="apple-touch-icon" href="${root}icon-512.png">
<link rel="preload" href="${root}fonts/unbounded.woff2" as="font" type="font/woff2" crossorigin>
$redirect<script type="application/ld+json">$ld</script>
<style>
${_css(root)}
</style>
</head>
<body>
<a class="skip" href="#main">${t['skip']}</a>
<header class="top">
<div class="wrap top-row">
<a class="logo" href="$root${pagePath(language)}">${_mark('#0F1E33', '#E89A00', 36)}<span>Tacho<b>Go</b></span></a>
<nav class="nav" aria-label="TachoGo">
<a href="#features">${t['nav_features']}</a>
<a href="#bans">${t['nav_bans']}</a>
<a href="#pricing">${t['nav_pricing']}</a>
<a href="#faq">${t['nav_faq']}</a>
</nav>
<details class="lang">
<summary aria-label="${t['nav_language']}: ${escapeHtml(languageNames[language]!)}">${language.toUpperCase()}</summary>
<ul>$languageLinks</ul>
</details>
<a class="btn btn-navy btn-small" href="$mail">${t['cta_short']} →</a>
</div>
</header>

<main id="main">
<section class="wrap hero">
<p class="kicker">${t['kicker']}</p>
<h1>${t.lines('h1').map((l) => l.replaceAll('TachoGo', '<mark>TachoGo</mark>')).join('<br>')}</h1>
<div class="hero-row">
<p class="lead">${t['lead']}</p>
<div class="actions">
<a class="btn btn-amber" href="$mail">${t['cta']}</a>
<a class="btn btn-line" href="#features">${t['cta_more']} ↓</a>
</div>
</div>
</section>

<div class="ticker" aria-hidden="true"><div class="ticker-track"><div>$ticker</div><div>$ticker</div></div></div>

<section class="wrap screen">
<div class="screen-text">
<p class="big-time">0:35</p>
<h2>${t['screen_title']}</h2>
<p>${t['screen_text']}</p>
</div>
<div class="phone" aria-hidden="true">
<div class="pm-head"><div><b>TachoGo</b><small>${_appString(arb, 'homeShiftSince', {'date': weekdayDate(shown, language), 'time': '06:49'})}</small></div><span class="pm-chip">PL → —</span></div>
<div class="pm-hero">
<div class="pm-ring"><svg viewBox="0 0 200 200" width="176" height="176"><circle cx="100" cy="100" r="88" fill="none" stroke="#262A2F" stroke-width="12"/><circle cx="100" cy="100" r="88" fill="none" stroke="#F3B33D" stroke-width="12" stroke-linecap="round" stroke-dasharray="481 553" transform="rotate(-90 100 100)"/></svg>
<div class="pm-ring-text"><small>${_appString(arb, 'heroUntilBreak')}</small><b>0:35</b><span>${_appString(arb, 'heroContinuousOf', {'time': '3:55', 'limit': '4:30'})}</span></div></div>
<p class="pm-warn">${_appString(arb, 'bannerBreakNeeded30')}</p>
</div>
<div class="pm-modes">${_modeButton(arb['modeDriving']! as String, on: true)}$mode</div>
<div class="pm-rows">
<div class="pm-row"><p><span>${_appString(arb, 'rowDailyDriving')}</span><b class="amber">3:55</b></p><i><u style="width:43%"></u></i></div>
<div class="pm-row"><p><span>${_appString(arb, 'rowWorkday')}</span><b>4:48</b></p><i><u class="light" style="width:37%"></u></i></div>
</div>
</div>
</section>

<section id="features" class="wrap features">
<h2 class="display">${t['features_title']}</h2>
<ul class="cells">
$features
</ul>
</section>

<section class="vans">
<div class="wrap vans-row">
<p class="vans-weight">${t['vans_weight']}</p>
<div><h2>${t['vans_title']}</h2><p>${t['vans_text']}</p></div>
</div>
</section>

<section id="bans" class="wrap bans">
<div class="bans-text">
<h2 class="display">${t['bans_title']}<br>${t.plural('bans_count', bans.length)}</h2>
<p>${t['bans_text']}</p>
<ul class="legend">
<li><span class="chip chip-rules"></span>${t['bans_rules']}</li>
<li><span class="chip chip-someRoads"></span>${t['bans_some_roads']}</li>
<li><span class="chip chip-none"></span>${t['bans_none']}</li>
</ul>
</div>
<ul class="chips">$chips</ul>
</section>

<section id="pricing" class="pricing">
<div class="wrap">
<h2 class="display">${t.lines('pricing_title').join('<br>')}</h2>
<div class="plans">
<div class="plan">
<p class="plan-name">${t['free_name']}</p>
<p class="plan-price">${_price(0, language).replaceAll(RegExp('[.,]00'), '')}</p>
<p>${t['free_text']}</p>
</div>
<div class="plan plan-amber">
<p class="plan-name">Premium · ${t['premium_trial']}</p>
<p class="plan-price">${_price(premiumPrices.month, language)}<small>${t['per_month']}</small></p>
<p class="plan-more">${_price(premiumPrices.year, language)} ${t['per_year']} · ${_price(premiumPrices.forever, language)} ${t['forever']}</p>
<p>${t['premium_text']}</p>
</div>
</div>
</div>
</section>

<section id="faq" class="faq">
<div class="wrap faq-grid">
<h2 class="display">${t['faq_title']}</h2>
<div>${faq[0]}${faq[1]}</div>
<div>${faq[2]}${faq[3]}</div>
</div>
</section>
</main>

<footer class="foot">
<div class="wrap">
<a class="foot-cta" href="$mail">${t['footer_cta']} →</a>
<div class="foot-row">
<p>${t['disclaimer'].replaceAll('{regulation}', regulation)}</p>
<ul class="foot-links">
<li><a href="${root}privacy/#${privacyAnchor(language)}">${t['privacy']}</a></li>
<li><a href="mailto:$contactEmail">$contactEmail</a></li>
<li>© 2026 TachoGo</li>
</ul>
</div>
<ul class="foot-langs">$languageLinks</ul>
</div>
</footer>
</body>
</html>
''';
}

/// Кнопка режима на телефоне: длинное слово («Bereitschaft») уменьшает
/// шрифт, чтобы не переносилось посередине — кнопка шириной около 61 px.
String _modeButton(String label, {required bool on}) {
  final longest = label
      .split(' ')
      .map((w) => w.length * .58)
      .reduce((a, b) => a > b ? a : b);
  final size = (61 / longest).clamp(6.5, 9.5).toStringAsFixed(1);
  return '<div class="pm-mode${on ? ' pm-on' : ''}" '
      'style="font-size:${size}px">${escapeHtml(label)}</div>';
}

String _sitemap() {
  final links = [
    for (final l in siteLanguages)
      '<xhtml:link rel="alternate" hreflang="$l" href="$siteBase${pagePath(l)}"/>',
    '<xhtml:link rel="alternate" hreflang="x-default" href="$siteBase"/>',
  ].join();
  final pages = [
    for (final l in siteLanguages)
      '<url><loc>$siteBase${pagePath(l)}</loc>$links</url>',
    '<url><loc>${siteBase}privacy/</loc></url>',
  ].join('\n');
  return '<?xml version="1.0" encoding="UTF-8"?>\n'
      '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9" '
      'xmlns:xhtml="http://www.w3.org/1999/xhtml">\n$pages\n</urlset>\n';
}

/// Стили «Дорожного плаката» (вариант B, выбран 2026-10-14). Цвета —
/// фирменные из `docs/brand/README.md`.
String _css(String root) =>
    '''
@font-face{font-family:Unbounded;src:url(${root}fonts/unbounded.woff2) format("woff2");font-weight:700 900;font-display:swap}
@font-face{font-family:Onest;src:url(${root}fonts/onest-400.woff2) format("woff2");font-weight:400;font-display:swap}
@font-face{font-family:Onest;src:url(${root}fonts/onest-600.woff2) format("woff2");font-weight:600;font-display:swap}
@font-face{font-family:Onest;src:url(${root}fonts/onest-700.woff2) format("woff2");font-weight:700 900;font-display:swap}
@font-face{font-family:"JetBrains Mono";src:url(${root}fonts/jetbrains-mono-500.woff2) format("woff2");font-weight:400 500;font-display:swap}
@font-face{font-family:"JetBrains Mono";src:url(${root}fonts/jetbrains-mono-700.woff2) format("woff2");font-weight:600 900;font-display:swap}
:root{--navy:#0F1E33;--amber:#FFB020;--paper:#F4F3EF;--brown:#8A5500;--line:2px solid var(--navy);--display:Unbounded,sans-serif;--text:Onest,system-ui,sans-serif;--mono:"JetBrains Mono",ui-monospace,monospace;color-scheme:light}
*{box-sizing:border-box}
html{scroll-behavior:smooth;-webkit-text-size-adjust:100%}
@media (prefers-reduced-motion:reduce){html{scroll-behavior:auto}}
body{margin:0;background:var(--paper);color:var(--navy);font:400 18px/1.5 var(--text)}
a{color:var(--navy)}
a:hover{color:var(--brown)}
a:focus-visible,summary:focus-visible{outline:3px solid var(--amber);outline-offset:2px}
h1,h2,h3,p{margin:0}
ul{margin:0;padding:0;list-style:none}
.sr{position:absolute;width:1px;height:1px;overflow:hidden;clip:rect(0 0 0 0);white-space:nowrap}
.skip{position:absolute;left:16px;top:-60px;padding:12px 16px;background:var(--navy);color:#fff;z-index:10}
.skip:focus{top:12px;color:#fff}
.wrap{max-width:1280px;margin:0 auto;padding:0 24px}
.display{font-family:var(--display);font-weight:900;text-transform:uppercase;letter-spacing:-.04em;line-height:1;font-size:clamp(34px,5.4vw,80px);hyphens:auto;overflow-wrap:break-word}
.top{border-bottom:var(--line);background:var(--paper);position:sticky;top:0;z-index:5}
.top-row{display:flex;align-items:center;gap:16px;min-height:76px}
.logo{display:flex;align-items:center;gap:10px;text-decoration:none;font:700 21px var(--display);margin-right:auto}
.logo b{color:#E89A00;font-weight:700}
.nav{display:flex;gap:4px;font-weight:600;font-size:15px}
.nav a{padding:12px 14px;text-decoration:none}
.lang{position:relative}
.lang summary{list-style:none;cursor:pointer;height:44px;min-width:56px;padding:0 14px;display:flex;align-items:center;justify-content:center;border:var(--line);font:700 14px var(--mono)}
.lang summary::-webkit-details-marker{display:none}
.lang ul{position:absolute;right:0;top:52px;background:#fff;border:var(--line);box-shadow:6px 6px 0 var(--navy);padding:8px 0;min-width:200px;max-height:70vh;overflow:auto}
.lang a{display:block;padding:10px 18px;text-decoration:none;font-size:16px}
.lang a[aria-current]{background:var(--amber);font-weight:700}
.btn{display:inline-flex;align-items:center;justify-content:center;min-height:64px;padding:0 30px;border:var(--line);font-weight:800;font-size:18px;text-decoration:none;text-align:center}
.btn-small{min-height:44px;padding:0 18px;font-size:15px}
.btn-navy{background:var(--navy);color:#fff}
.btn-navy:hover{color:var(--amber)}
.btn-amber{background:var(--amber);box-shadow:6px 6px 0 var(--navy)}
.btn-amber:hover{color:var(--navy);transform:translate(2px,2px);box-shadow:4px 4px 0 var(--navy)}
.btn-line:hover{background:#fff;color:var(--navy)}
.hero{padding-top:64px;padding-bottom:56px}
.kicker{font:700 14px var(--mono);letter-spacing:.1em;text-transform:uppercase;margin-bottom:28px}
h1{font-family:var(--display);font-weight:900;font-size:clamp(34px,9.6vw,150px);line-height:1;letter-spacing:-.045em;text-transform:uppercase;hyphens:auto;overflow-wrap:break-word}
mark{display:inline-block;background:var(--amber);color:var(--navy);line-height:.94;padding:.04em .12em 0}
.hero-row{display:flex;flex-wrap:wrap;gap:32px;margin-top:48px;align-items:flex-end}
.lead{flex:1 1 420px;font-size:21px;max-width:620px}
.actions{display:flex;flex-wrap:wrap;gap:14px}
.ticker{background:var(--navy);color:var(--amber);border-block:var(--line);overflow:hidden}
.ticker-track{display:flex;width:max-content;animation:ticker 48s linear infinite}
.ticker-track>div{display:flex;gap:40px;padding:18px 20px;white-space:nowrap;font:800 22px var(--mono);text-transform:uppercase}
.ticker i{font-style:normal;color:#fff}
@keyframes ticker{to{transform:translateX(-50%)}}
@media (prefers-reduced-motion:reduce){.ticker{overflow-x:auto}.ticker-track{animation:none}}
.screen{display:flex;flex-wrap:wrap;gap:48px;align-items:center;padding-top:80px;padding-bottom:80px}
.screen-text{flex:1 1 460px;min-width:0;display:flex;flex-direction:column;gap:20px}
.big-time{font:800 clamp(96px,16vw,230px)/.85 var(--mono);letter-spacing:-.06em}
.screen h2{font:800 clamp(28px,3.4vw,44px)/1.05 var(--display);text-transform:uppercase;letter-spacing:-.02em}
.screen-text>p:last-child{font-size:19px;max-width:520px}
.phone{flex:0 0 auto;margin:0 auto;width:320px;background:#111315;color:#EDEBE6;border:3px solid var(--navy);border-radius:44px;box-shadow:14px 14px 0 var(--amber);padding:22px 16px;display:flex;flex-direction:column;gap:12px;overflow:hidden;font-family:Onest,sans-serif}
.pm-head{display:flex;justify-content:space-between;align-items:center;gap:8px}
.pm-head b{display:block;font-size:17px}
.pm-head small{display:block;font-size:11px;color:#A3A8AE}
.pm-chip{flex:0 0 auto;padding:6px 10px;border-radius:12px;border:1px solid #2A2E33;font:700 12px var(--mono)}
.pm-hero{background:#1A1D20;border-radius:24px;padding:16px;display:flex;flex-direction:column;align-items:center;gap:12px}
.pm-ring{position:relative;width:176px;height:176px}
.pm-ring svg{display:block}
.pm-ring-text{position:absolute;inset:0;display:flex;flex-direction:column;align-items:center;justify-content:center;gap:2px;text-align:center;padding:0 22px}
.pm-ring-text small{font-size:9px;font-weight:600;letter-spacing:.08em;text-transform:uppercase;color:#A3A8AE}
.pm-ring-text b{font:800 42px/1 var(--mono);color:#F3B33D}
.pm-ring-text span{font-size:10px}
.pm-warn{width:100%;background:#2B2415;color:#F7D38A;border-radius:14px;padding:9px 12px;font-size:11px;line-height:1.4}
.pm-modes{display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:6px}
.pm-mode{min-height:58px;border-radius:16px;border:1px solid #2A2E33;font-weight:600;line-height:1.15;display:flex;align-items:flex-end;justify-content:center;text-align:center;padding:0 3px 8px}
.pm-on{background:#F3B33D;border-color:#F3B33D;color:#111315;font-weight:700}
.pm-rows{background:#1A1D20;border-radius:20px;padding:12px 14px;display:flex;flex-direction:column;gap:12px}
.pm-row p{display:flex;justify-content:space-between;gap:8px;font-size:12px;font-weight:600;margin-bottom:6px}
.pm-row b{font-family:var(--mono)}
.pm-row .amber{color:#F3B33D}
.pm-row i{display:block;height:5px;border-radius:3px;background:#262A2F}
.pm-row u{display:block;height:5px;border-radius:3px;background:#F3B33D}
.pm-row u.light{background:#EDEBE6}
.features{padding-top:24px;padding-bottom:80px}
.features h2{margin-bottom:32px}
.cells{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));border-top:var(--line);border-left:var(--line)}
.cell{border-right:var(--line);border-bottom:var(--line);padding:32px;display:flex;flex-direction:column;gap:12px}
.cell .num{font:800 18px var(--mono);color:var(--brown)}
.cell h3{font-size:26px;font-weight:800;line-height:1.15}
.cell p{font-size:17px}
.cell-accent{background:var(--amber)}
.cell-accent .num{color:var(--navy)}
.cell-navy{background:var(--navy);color:#fff}
.cell-navy .num{color:var(--amber)}
.vans{background:var(--amber);border-block:var(--line)}
.vans-row{display:flex;flex-wrap:wrap;gap:32px 56px;align-items:center;padding-top:72px;padding-bottom:72px}
.vans-weight{flex:0 1 auto;font:900 clamp(56px,11vw,168px)/.9 var(--display);letter-spacing:-.05em;white-space:nowrap}
.vans-row>div{flex:1 1 360px;min-width:0}
.vans h2{font-size:30px;font-weight:800;line-height:1.2;margin-bottom:12px}
.vans-row>div>p{font-size:19px}
.bans{display:flex;flex-wrap:wrap;gap:40px 56px;align-items:flex-start;padding-top:80px;padding-bottom:80px}
.bans-text{flex:1 1 380px;min-width:0;display:flex;flex-direction:column;gap:20px}
.bans h2,.faq h2{font-size:clamp(30px,4vw,60px)}
.bans-text>p{font-size:19px}
.legend{display:flex;flex-direction:column;gap:10px;font-size:15px}
.legend li{display:flex;align-items:center;gap:12px}
.legend .chip{width:28px;height:20px}
.chips{flex:1 1 480px;display:flex;flex-wrap:wrap;gap:10px}
.chip{min-width:72px;height:52px;padding:0 8px;display:flex;align-items:center;justify-content:center;border:var(--line);font:800 20px var(--mono)}
.chip-rules{background:var(--navy);color:var(--amber)}
.chip-none{border-style:dashed;color:#4A5568}
.pricing{border-top:var(--line)}
.pricing .wrap{padding-top:80px;padding-bottom:80px}
.pricing h2{margin-bottom:40px}
.plans{display:flex;flex-wrap:wrap;gap:28px}
.plan{flex:1 1 360px;background:#fff;border:var(--line);box-shadow:8px 8px 0 var(--navy);padding:36px;display:flex;flex-direction:column;gap:18px}
.plan-amber{background:var(--amber)}
.plan-name{font:800 16px var(--mono);letter-spacing:.08em;text-transform:uppercase}
.plan-price{font:800 clamp(44px,6vw,64px)/1 var(--mono);display:flex;flex-wrap:wrap;align-items:baseline;gap:6px 14px}
.plan-price small{font:600 17px var(--text)}
.plan-more{font-weight:700}
.plan p:last-child{font-size:18px}
.faq{border-top:var(--line)}
.faq-grid{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:40px;padding-top:80px;padding-bottom:80px}
.faq-grid>div{display:flex;flex-direction:column;gap:28px}
.qa h3{font-size:20px;font-weight:800;margin-bottom:8px}
.qa p{font-size:17px}
.foot{background:var(--navy);color:#C9D2E0}
.foot .wrap{padding-top:64px;padding-bottom:48px;display:flex;flex-direction:column;gap:36px}
.foot a{color:#fff}
.foot a:hover{color:var(--amber)}
.foot-cta{font:900 clamp(34px,7vw,110px)/.95 var(--display);letter-spacing:-.04em;text-transform:uppercase;color:var(--amber) !important;text-decoration:none;hyphens:auto;overflow-wrap:break-word}
.foot-row{display:flex;flex-wrap:wrap;gap:20px 48px;font-size:14px;line-height:1.6;border-top:1px solid #2A3D5E;padding-top:28px}
.foot-row>p{flex:1 1 520px;min-width:0}
.foot-row a{color:var(--amber)}
.foot-links{display:flex;flex-direction:column;gap:6px}
.foot-links a{color:#fff}
.foot-langs{display:flex;flex-wrap:wrap;gap:6px 18px;font-size:14px}
.foot-langs a[aria-current]{color:var(--amber);text-decoration:none}
@media (max-width:900px){.nav{display:none}.cells,.faq-grid{grid-template-columns:minmax(0,1fr)}.cell{padding:24px}}
@media (max-width:520px){body{font-size:17px}.top-row{gap:10px}.logo span{display:none}.actions .btn{width:100%}.hero{padding-top:40px}.hero-row{margin-top:32px}.lead{font-size:19px}.plan{padding:26px}}
''';

Future<void> main(List<String> args) async {
  if (args.length != 1) {
    stderr.writeln('dart run tool/site_build.dart <каталог сайта>');
    exit(64);
  }
  final files = await buildSite();
  for (final MapEntry(:key, :value) in files.entries) {
    File('${args.single}/$key')
      ..createSync(recursive: true)
      ..writeAsStringSync(value);
  }
  stdout.writeln('Сайт: ${files.length} файлов в ${args.single}');
}
