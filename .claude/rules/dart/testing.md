---
paths:
  - "**/*.dart"
  - "**/pubspec.yaml"
  - "**/analysis_options.yaml"
---
# Dart/Flutter Testing

> Adapted from ECC `rules/dart/testing.md` (github.com/affaan-m/ECC, MIT). Extends [testing.md](../testing.md). `docs/testing.md` and `app/README.md` take precedence over this file.

## Tools

`flutter_test` and `package:test`, `fake_async` for time, hand-written fakes instead of mocking libraries (no mockito or mocktail), `integration_test` for app scenarios.

## Layout

- Tests mirror `lib/`: `app/test/<area>/…_test.dart`.
- Engine tests in `packages/tacho_engine/test/`, grouped by regulation article (`art7_breaks_test.dart`, `art8_daily_rest_test.dart`, …).
- `app/integration_test/all_test.dart` runs every scenario in one app build.
- Drift migration tests in `app/test/drift/`; screen conformance in `app/test/design/`; store screenshots are drawn by `app/test/store/`.

## Commands

| What | Command |
|------|---------|
| Engine tests | `cd packages/tacho_engine && dart test` |
| Engine coverage | `dart run coverage:test_with_coverage`, then `dart run tool/check_coverage.dart coverage/lcov.info 95 lib/` |
| App tests and coverage | `cd app && flutter test --coverage`, then `dart run ../packages/tacho_engine/tool/check_coverage.dart coverage/lcov.info 80 lib/data/` |
| Format | `dart format lib test tool` |
| Analyze | `flutter analyze --fatal-infos` in `app`, `dart analyze --fatal-infos` in `packages/tacho_engine` |
| Integration without a device | `cd app && flutter test -d flutter-tester integration_test/all_test.dart` |

Use these instead of guessing a runner.

## Patterns

- Fakes over mocks: platforms are replaced whole (`test/notifications/fake_notification_platform.dart`); the forecast is computed without an isolate in tests.
- Time: an injected clock, `fake_async` or `ScenarioClock`; CI also runs the tests in three time zones, so never depend on the machine's zone.
- Widget tests wrap the widget in `ProviderScope` with overrides. Screen conformance draws every screen in every language at 360 dp with font scale ×2: if a string does not fit, wrap it rather than shorten the translation.
- A new ARB key goes into every language at once, otherwise L10N-01 fails.
- Every state transition that matters gets a test: loading → data, loading → error, retry.
