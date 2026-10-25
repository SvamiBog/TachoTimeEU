---
description: Fix Dart analyzer errors and Flutter build failures incrementally. Invokes the ecc-dart-build-resolver agent for minimal, surgical fixes.
---

> Adapted from ECC `commands/flutter-build.md` v2.2.3 (github.com/affaan-m/ECC, MIT; see `.claude/ECC-NOTICE.md`). `CLAUDE.md` and `.claude/rules/` take precedence over this file.
>
> In TachoGo: run the commands from `.claude/rules/dart/testing.md` (from `app/` or `packages/tacho_engine/`, analyze with `--fatal-infos`); Riverpod without code generation, Drift, hand-written fakes instead of mocks, every string in ARB (`.claude/rules/dart/`); regulation logic only in `packages/tacho_engine`. Commit only when the user asks.

# Flutter Build and Fix

This command invokes the **ecc-dart-build-resolver** agent to incrementally fix Dart/Flutter build errors with minimal changes.

## What This Command Does

1. **Run Diagnostics**: Execute `flutter analyze`, `flutter pub get`
2. **Parse Errors**: Group by file and sort by severity
3. **Fix Incrementally**: One error at a time
4. **Verify Each Fix**: Re-run analysis after each change
5. **Report Summary**: Show what was fixed and what remains

## When to Use

Use `/ecc-flutter-build` when:
- `flutter analyze` reports errors
- `flutter build` fails for any platform
- `dart pub get` / `flutter pub get` fails with version conflicts
- `build_runner` fails to generate code
- After pulling changes that break the build

## Diagnostic Commands Run

```bash
# Analysis
flutter analyze 2>&1

# Dependencies
flutter pub get 2>&1

# Code generation (if project uses build_runner)
dart run build_runner build --delete-conflicting-outputs 2>&1

# Android builds run in CI only: there is no Android SDK locally or in cloud sessions
```

## Example Session

````text
User: /ecc-flutter-build

Agent:
# Flutter Build Resolution

## Initial Diagnostics

```
$ flutter analyze
Analyzing project...

  error • lib/features/user/data/user_repository_impl.dart:34:16 •
    A value of type 'String?' can't be assigned to a variable of type 'String'. •
    invalid_assignment

  error • lib/features/cart/presentation/cart_page.dart:58:5 •
    The method 'add' isn't defined for the type 'List<Item>'.
    Try correcting the name to the name of an existing method, or defining a method named 'add'. •
    undefined_method

2 errors found.
```

## Fix 1: Null Safety

File: lib/features/user/data/user_repository_impl.dart:34
Error: A value of type 'String?' can't be assigned to type 'String'

Changed:
```dart
final id = response.id;
```
To:
```dart
final id = response.id ?? '';
```

```
$ flutter analyze
1 error found.
```

## Fix 2: Immutable List

File: lib/features/cart/presentation/cart_page.dart:58
Error: The method 'add' isn't defined for the type 'List<Item>'
Cause: State holds an unmodifiable list; mutation goes through Cubit

Changed:
```dart
state.items.add(item);
```
To:
```dart
context.read<CartCubit>().addItem(item);
// Note: Cubit exposes named methods (addItem, removeItem);
// .add(event) is the BLoC event API — don't mix them.
```

```
$ flutter analyze
No issues found!
```

## Final Verification

```
$ flutter test
All tests passed.
```

## Summary

| Metric | Count |
|--------|-------|
| Analysis errors fixed | 2 |
| Files modified | 2 |
| Remaining issues | 0 |

Build Status: PASS ✓
````

## Common Errors Fixed

| Error | Typical Fix |
|-------|-------------|
| `A value of type 'X?' can't be assigned to 'X'` | Add `?? default` or null guard |
| `The name 'X' isn't defined` | Add import or fix typo |
| `Non-nullable instance field must be initialized` | Add initializer or `late` |
| `Version solving failed` | Adjust version constraints in pubspec.yaml |
| `Missing concrete implementation of 'X'` | Implement missing interface method |
| `build_runner: Part of X expected` | Delete stale `.g.dart` and rebuild |

## Fix Strategy

1. **Analysis errors first** — code must be error-free
2. **Warning triage second** — fix warnings that could cause runtime bugs
3. **pub conflicts third** — fix dependency resolution
4. **One fix at a time** — verify each change
5. **Minimal changes** — don't refactor, just fix

## Stop Conditions

The agent will stop and report if:
- Same error persists after 3 attempts
- Fix introduces more errors
- Requires architectural changes
- Package upgrade conflicts need user decision

## Related Commands

- `/ecc-flutter-test` — Run tests after build succeeds
- `/ecc-flutter-review` — Review code quality

## Related

- Agent: `.claude/agents/ecc-dart-build-resolver.md`
- Skill: `.claude/skills/ecc-flutter-dart-code-review/`
