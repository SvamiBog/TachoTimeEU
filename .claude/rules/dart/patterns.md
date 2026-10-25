---
paths:
  - "**/*.dart"
  - "**/pubspec.yaml"
---
# Dart/Flutter Patterns

> Adapted from ECC `rules/dart/patterns.md` (github.com/affaan-m/ECC, MIT). The generic examples of the original (BLoC, get_it, freezed, GoRouter, remote data sources) are replaced by the patterns this project actually uses; `app/README.md` describes them in full and takes precedence.

## Layers

`features/<screen>/` (widgets and screen providers) → Riverpod providers → `data/` (repositories over Drift) and `tacho_engine`. Regulation logic lives only in `packages/tacho_engine`: pure Dart, no Flutter or `dart:ui`, all times in UTC. The UI shows the engine's results and warnings and never re-implements a rule.

## State: Riverpod without code generation

- Providers are declared by hand (`Provider`, `StreamProvider`, `FutureProvider`, `NotifierProvider`); there is no `@riverpod` / `riverpod_generator`.
- Widgets watch narrow slices: the compliance snapshot is read through `watchSnapshot` (`features/home/snapshot_select.dart`), so the per-second clock tick rebuilds only the timers whose minute changed.
- Dependencies arrive through constructors and providers; no service locator.

## Data: Drift repositories

- Each area has a repository over `AppDatabase` in `data/<area>/`; widgets never touch tables.
- Live mode switching goes through `ActivityRepository`; retroactive edits, manual shifts and corrections only through `JournalEditRepository` (Premium). One edit is one transaction.
- Schema change: edit `lib/data/db/tables.dart`, bump `schemaVersion`, run `dart run drift_dev make-migrations`, add the `stepByStep` step to `AppDatabase.migration`. Snapshots live in `drift_schemas/`, migration tests in `test/drift/`.
- Settings are written to the database immediately (`SettingsRepository`); screens subscribe to setting streams instead of using a "Save" button.

## Platform boundaries

OS and plugin access sits behind small interfaces (`TrackingPlatform`, `NotificationPlatform`) that tests replace with fakes. Put any new plugin call behind such an interface.

## Time

- Store and compute in UTC; convert to local time only for display (`core/l10n/format.dart`).
- Take the time from the injected clock (`clock` package, `clockProvider`); `lib/` never calls `DateTime.now()`.
- A week starts on Monday (`weekStartUtc`), regardless of the locale.

## Strings

All interface strings live in ARB (`lib/l10n/app_ru.arb` is the source) and are added to every language at once; no Cyrillic or Georgian literals in `lib/` (test L10N-04). Do not build a phrase from pieces: word order differs between languages.

## Backup format

`JournalBackup` reads fields by name, not by column. A change that an older app cannot read bumps `formatVersion` and keeps reading the previous version in `parse`.
