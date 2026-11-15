---
name: live-text
description: "Review and rewrite TachoGo interface texts so they read like a person talking to a driver in the cab: short, plain, no officialese, no extra words, one term per concept. Scans the ARB files for dead text (officialese, long rule paragraphs, dash chains, repeated explanations, drifting terms), rewrites the Russian source, carries the same cuts into every translation, updates tests and checks the result on rendered screens. Use when asked to check, proofread, simplify, shorten, 'make alive' or humanize app texts, notifications, hints, errors, onboarding or translations, or after adding many new strings."
---

# Living interface text

TachoGo talks to a truck, bus or van driver who glances at the phone between two tasks: tired, sometimes in gloves, often reading Russian as a second language (Ukrainians, Georgians, Uzbeks, Moldovans). Every string must be understood in two seconds. A good string sounds like an experienced colleague or dispatcher, not like the regulation and not like an advertisement.

The source language is Russian (`app/lib/l10n/app_ru.arb`); 13 translations follow it (`app_<lang>.arb`). All interface text lives in ARB — there are no strings in code (L10N-04).

## Workflow

### 1. Scan

From the repository root:

```sh
dart run .claude/skills/live-text/scan.dart              # Russian, flagged strings
dart run .claude/skills/live-text/scan.dart --all        # every string, with descriptions
dart run .claude/skills/live-text/scan.dart --lang uk    # a translation against Russian
```

Flags are hints, not verdicts: `long`, `sentences`, `dashes` (two or more « — »), `parens`, `word:` (officialese, with a replacement), `term:` (a word that drifted from the glossary), `dup:` (the same long text under two keys), `repeat:` (one explanation on several screens), for translations `ratio:` (much longer than Russian) and `untranslated`. Read the whole list anyway: unnatural phrasing often has no flag (“Новая начнётся с первого режима кроме отдыха”).

### 2. See the string where the driver sees it

For every candidate read its `@description` and find the widget: `grep -rn "\.<key>\b" app/lib`. Look at what stands next to it — the screen title, a value, a chip, the button. Most excess text repeats its neighbours: a dialog body that repeats the title, a hint that repeats the row name, a rule footer that repeats the milestones above it.

Render the screens to look at them (step 6) before and after: a phrase that reads fine in the ARB can be the fourth line of grey text on a crowded card.

### 3. Rewrite the Russian source

Apply the rules below. Keep a before/after table: it is the report for the user and the brief for the translations.

Do not touch keys, placeholders `{name}`, ICU `select`/`plural` structure and cases. Dropping a placeholder means changing the calling code too (`flutter gen-l10n` takes parameters from the template's metadata). Update `@key.description` when the meaning changes.

### 4. Carry the change into every translation

A cut made in Russian is made in all 13 languages in the same edit (rule: a string changes in every ARB at once). Rewrite each translation as a native speaker would say the new meaning — never translate word by word from Russian, and never translate the old version. Keep the language's established terms (Polish `przerwa`, `odpoczynek dobowy`; Ukrainian `перерва`, `відпочинок`; the EU official terms in German, French, Czech… — the PDF report is shown to inspectors). French and Italian use the typographic apostrophe `’`. Georgian and Uzbek (Latin) strings follow the same cut. If a style-only change in Russian does not change the meaning and the translation is already natural, leave the translation.

“Already natural” is checked, not assumed. After the Russian edit run

```sh
dart run .claude/skills/live-text/scan.dart --stale --lang en   # then uk, pl, de…
```

It lists every Russian string changed since the last commit whose translation is still the old one. Read each: the old translation usually carries what was just removed from Russian — “the app” as the actor (`the app asks first` → `we ask first`), an instruction about the control instead of the action (`Use this if…` → `Switched the mode at the wrong time? Fix it here`), a second mention of the same noun, `записи журналу` where `журнал` is enough. Passive voice is not a defect by itself: `буде видалено`, `will be deleted`, `wird gelöscht` are normal in those languages. What may stay on the list: strings where only Russian word order or a Russian-only word changed.

Check terms per language too: the word for a 45 h weekly rest on the weekly-rest card (`weeklyFull`: `Повний`, `Pełny`, `Regular`, `Regelmäßig`…) is the one used in every other string of that language.

Apply edits with a script that replaces only the value on the `"key": "…",` line, so key order and formatting stay as they are; write files with LF line endings (`newline='\n'` in Python).

### 5. Regenerate and test

```sh
cd app
flutter gen-l10n
grep -rn "старый текст" test        # tests that look for the old Russian text
flutter test test/l10n test/design/screen_conformance_test.dart test/store
flutter test                         # widget tests find many strings by literal text
flutter analyze --fatal-infos
(cd ../packages/tacho_engine && dart test test/docs_test.dart)   # if docs/domain changed
```

`docs/domain/eu-561-rules.md` is not a UI quote: its limits table is checked against the engine by DOC-01 (`packages/tacho_engine/test/docs_test.dart`) and keeps the regulation's wording (“шесть периодов по 24 ч”). Update only the cells that name a UI text.

Tests that `find.text('…')` a changed string are updated to the new text — the test was right about behaviour, the copy changed. Screen conformance draws every screen in every language at 360 dp with font ×2: a string that no longer fits is wrapped, not shortened into nonsense. Store captions (`docs/store/listing/`) and docs that quote UI labels (`docs/beta/tester-guide.md`, `docs/design/README.md`, `docs/site/`) are updated if a quoted label changed; rename labels only when it is worth that.

### 6. Look at the screens

There is no emulator locally; the widget-test renderer draws the real screens with the real fonts:

```sh
cd app
cp ../.claude/skills/live-text/screens_test.dart test/l10n/live_text_screens_test.dart
flutter test --no-pub test/l10n/live_text_screens_test.dart --dart-define=LIVE_TEXT_OUT=<scratchpad>/after [--dart-define=LIVE_TEXT_LANG=uk]
rm test/l10n/live_text_screens_test.dart
```

It writes one PNG per screen and sheet (home, limits screens, sheets, journal, shift form, settings, onboarding steps, More, guide, bans, work days, infringements and the explanation sheet) at 412 dp. Open them and read every text as the driver: does it say what to do, is anything said twice, does anything sound like a lawyer or a robot. Notifications have no screen: read `notify*`, `service*` and `infr*` strings as a lock-screen line. On a real phone, the debug APK from CI shows the same.

### 7. Report

Before/after table of what changed and why, which languages were updated, what was deliberately left formal (step “Exceptions”), test results, and the screens checked.

## Rules

**Say the fact or the action.** One idea per string. Lead with what matters to the driver: what is happening, what to do, until when. “Нужна вторая часть перерыва — 30 мин”, not “Нужен перерыв 30 мин — вторая часть раздельного 15 + 30”.

**Cut what the screen already says.** No title repeated in the body, no number repeated in its caption, no “Сейчас…” when the screen is live anyway. A confirmation body states the consequence, not the question again: title “Сохранить изменения?” — body “Без сохранения правки пропадут”.

**Do not explain the app.** No “Приложение считает / распознаёт само / позволяет”. If the point is that the driver need not do something, say that: “Части засчитаются сами”. Voice: the driver is “вы”, imperative for actions; the app says “мы” only for promises it keeps (“предупредим”, “спросим”); otherwise impersonal. Not “Приложение” as the subject unless the disclaimer needs it.

**Plain words instead of officialese.** в пределах → за / не позже чем через; необходимо → нужно; корректировка → исправление; будет удалён → сотрётся / удалится; является → «—» or nothing; осуществляется, производится → a real verb; данный → этот. No passive where an active verb exists.

**A deadline is a deadline.** “Начните отдых через 0:15” reads as “wait 15 minutes, then start” (the Uzbek translation said exactly that). When the time is the latest moment, say so: “не позже чем через {time}”, `within`, `spätestens in`, `najpóźniej za`.

**A legend lives next to its marks.** If rows above a calendar or chart already show the dot and the ring with their names, the footer does not describe the colours again; it explains only what has no label on the screen.

**Numbers as digits.** “144 ч (6 суток)”, not “шесть периодов по 24 часа”; “дважды”, “трижды” are fine. Units as in the app: ч, мин, дн.

**Punctuation.** At most one « — » per sentence; prefer a full stop, colon or comma. No parenthetical explanations of the main point. No exclamation marks, no emoji, no ellipsis. Hints under a setting have no full stop; sentences in bodies do.

**Rules footers and the guide** — three short sentences at most: the numbers first, the article last (“ст. 8(6)”), one article reference per screen. The milestones above the footer already show the numbers for today; the footer gives the rule, not the screen's legend again.

**No slogans or praise.** Not “под контролем”, “настроим под вас”, “легко”, “удобно”, “умное решение”. (“Умный тахограф” is the legal name of the device and stays.) A heading says what the screen is for: “Знайте, сколько ещё можно ехать”, “Пара настроек”.

**Do not overpromise.** “Всё”, “всегда”, “никогда” only when literally true. Journal edits, export and transfer are Premium (`docs/premium.md`): a free-tier text must not promise them.

**Glossary — one word per concept** (`dart run …/scan.dart` flags drift):

| Concept | Word | Not |
|---|---|---|
| driving up to 10 h twice a week | продление | удлинение |
| country of the employer (art. 8(6)) | страна фирмы | страна регистрации |
| fixing recorded time | исправить, исправление | корректировка |
| break (art. 7) | перерыв | пауза |
| daily / weekly rest | суточный / недельный отдых; полный, сокращённый, раздельный | регулярный (except quoting the regulation in the guide) |
| reduced-rest debt | долг, компенсация; “присоединить к отдыху” | — |
| the 13/15 h window | рабочий день | — |
| between two daily rests | смена | — |
| the 144 h period | рабочая неделя | — |
| card data download | считывание карты | выгрузка, скачивание |
| GPS driving detection | автоопределение | трекинг |

Driver slang (“сократка”, “тахо”, “девятка”) stays out of the interface: not every reader knows it.

**Kinds of strings:**

| Kind | Shape |
|---|---|
| Button | a verb, 1–3 words: “Начать перерыв”, “Сохранить” |
| Title | the subject, up to ~30 characters, no full stop |
| Chip | 1–2 words: “скоро перерыв”, “кончится раньше” |
| Hint under a row or setting | one line, up to ~50 characters, no full stop |
| Message, info note | one or two short sentences |
| Error | what happened + what to do; no “Ошибка”, no technical cause, no blame |
| Confirmation | title asks; body gives the consequence (“Вернуть будет нельзя”) |
| Notification | title is the fact (≤ ~30); text is the number or the action (≤ ~60) |
| TalkBack (`*Spoken`, “для диктора”) | a full spoken phrase, no “×”, “·”, “→” |

**Exceptions — keep formal and complete:**
- The PDF report (`report*`): read by inspectors; precise terms, full legal names.
- Disclaimers (`guideDisclaimer`, `moreDisclaimer`, `reportDisclaimer`, `exportPdfHint`, `bansDisclaimer`): may be shortened, never softened — “не заменяет тахограф”, “не юридическая консультация”, “не связано с органами власти” stay.
- Privacy statements (`problemText`, `settingsAnalyticsHint`, `onbAutoText`, `autoSwitchHint`): the list of what is collected and what is not stays complete.
- Regulation facts: shorter must not become wrong. Check every changed rule text against `docs/domain/eu-561-rules.md`; when unsure, keep the longer correct version.

## Done when

- [ ] Every flagged Russian string reviewed; the before/after table is written
- [ ] The same change made in all 13 translations; placeholders and ICU intact
- [ ] `flutter gen-l10n` run; tests updated to new texts; `flutter test` and `analyze --fatal-infos` clean
- [ ] Screens rendered and read after the change, at least in Russian
- [ ] Docs and store captions that quote a changed label updated
