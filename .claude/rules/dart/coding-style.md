---
paths:
  - "**/*.dart"
  - "**/pubspec.yaml"
  - "**/analysis_options.yaml"
---
# Dart/Flutter Coding Style

> Adapted from ECC `rules/dart/coding-style.md` (github.com/affaan-m/ECC, MIT). Extends [coding-style.md](../coding-style.md). `CLAUDE.md`, `app/README.md` and `very_good_analysis` take precedence over this file.

## Formatting and lints

- `dart format` for every `.dart` file; the pre-commit hook and CI check it.
- 80-character lines (`lines_longer_than_80_chars`), trailing commas on multi-line argument and parameter lists.
- `very_good_analysis` with `--fatal-infos`: an info is a failure. Fix the code instead of adding `// ignore:` — hand-written code has none.

## Immutability

- `final` for locals, `const` for compile-time constants and for constructors whose fields are all `final`.
- Public APIs return unmodifiable collections; state classes change through `copyWith`.

## Naming

- `lowerCamelCase` for variables, parameters, named constructors and constants (`constant_identifier_names`: no `SCREAMING_CASE`).
- `UpperCamelCase` for classes, enums, typedefs and extensions; `snake_case` for files.
- Private members start with `_`; an extension's name says what it adds (`ModeColors`, `ModeNames`), not `Helpers`.

## Null safety

- Avoid `!`: prefer `?.`, `??`, a null check with promotion, or a pattern. Keep `!` for a null that would be a programming error.
- Avoid `late` unless initialization before first use is guaranteed.

## Sealed types and pattern matching

Model closed sets of states as `sealed` classes and handle them with an exhaustive `switch` without a default branch, so the compiler flags a new case.

## Error handling

- Every `catch` has an `on` clause (`avoid_catches_without_on_clauses`); catch the specific type you can handle (`on BackupException`, `on PlatformException`).
- `on Object catch (e, st)` only where any failure must be caught — a driver's action (mode switch, transfer, report), background scheduling, platform calls — and then always both: report it (`FlutterError.reportError` or the class's error callback, which reach `CrashReporter`) and show the driver a localized message or state, as in `features/home/mode_buttons.dart`. Never swallow it.
- Do not use exceptions for control flow; recoverable outcomes are return values or sealed results.

## Async

- `await` every Future or wrap it in `unawaited(...)` to show the fire-and-forget is intended.
- No `async` on a function that never awaits.
- After an `await` in a widget, check `context.mounted` before using the `BuildContext`.

## Imports

- `package:` imports only (`always_use_package_imports`): `package:tachogo/…`, `package:tacho_engine/…`.
- Order: `dart:`, then external packages, then the project's own packages.

## Generated code

- Drift `*.g.dart` and `lib/l10n/app_localizations*.dart` are committed; CI checks they are current. Never edit them by hand.
- Regenerate with `dart run build_runner build` (Drift) and `flutter gen-l10n` (ARB).
