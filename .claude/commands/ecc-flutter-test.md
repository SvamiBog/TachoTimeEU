---
description: Run Flutter/Dart tests, report failures, and incrementally fix test issues. Covers unit, widget, golden, and integration tests.
---

> Adapted from ECC `commands/flutter-test.md` v2.2.3 (github.com/affaan-m/ECC, MIT; see `.claude/ECC-NOTICE.md`). `CLAUDE.md` and `.claude/rules/` take precedence over this file.
>
> In TachoGo: run the commands from `.claude/rules/dart/testing.md` (from `app/` or `packages/tacho_engine/`, analyze with `--fatal-infos`); Riverpod without code generation, Drift, hand-written fakes instead of mocks, every string in ARB (`.claude/rules/dart/`); regulation logic only in `packages/tacho_engine`. Commit only when the user asks.

# Flutter Test

This command runs the Flutter test suite and reports results. When failures occur, it diagnoses and fixes issues incrementally.

## What This Command Does

1. **Run Tests**: Execute `flutter test` (or scope to changed files)
2. **Parse Failures**: Identify failing tests by type and cause
3. **Fix Incrementally**: One failure at a time where possible
4. **Verify**: Re-run after each fix
5. **Report**: Show coverage summary and remaining failures

## When to Use

Use `/ecc-flutter-test` when:
- After implementing a feature to verify nothing broke
- After running `/ecc-flutter-build` to ensure tests pass
- To check test coverage on new code
- When a specific test file is failing
- Before submitting a PR

## Commands Run

```bash
# Run all tests
flutter test 2>&1

# Run with coverage
flutter test --coverage 2>&1

# Run specific test file
flutter test test/unit/domain/usecases/get_user_test.dart 2>&1

# Run tests matching a name pattern
flutter test --name "CartBloc" 2>&1

# Integration scenarios without a device, as in CI (from app/)
flutter test -d flutter-tester integration_test/all_test.dart 2>&1

# Update golden files when intentional visual changes are made
flutter test --update-goldens 2>&1
```

## Example Session

````text
User: /ecc-flutter-test

Agent:
# Flutter Test Run

## Test Execution

```
$ flutter test
00:05 +42 -2: Some tests failed.

FAILED: test/unit/data/user_repository_test.dart
  UserRepository getById
    returns null when user not found
    Expected: null
    Actual: User(id: 'test-id', name: 'Test User')

FAILED: test/widget/cart_page_test.dart
  CartPage
    shows empty state when cart is empty
    Expected: exactly one widget with text 'Your cart is empty'
    Found: no widget with text 'Your cart is empty'
```

## Fix 1: Repository Test

File: test/unit/data/user_repository_test.dart
Failure: `getById` returns a user when it should return null for missing ID

Root cause: Test setup adds a user with ID 'test-id' but queries with 'missing-id'.
Fix: Updated test to query with 'missing-id' — setup was correct, query was wrong.

```
$ flutter test test/unit/data/user_repository_test.dart
1 test passed.
```

## Fix 2: Widget Test

File: test/widget/cart_page_test.dart
Failure: Empty state text widget not found

Root cause: Empty state message was renamed from 'Your cart is empty' to 'Cart is empty' in the widget.
Fix: Updated test string to match current widget copy.

```
$ flutter test test/widget/cart_page_test.dart
1 test passed.
```

## Final Run

```
$ flutter test --coverage
All 44 tests passed.
Coverage: 84.2% (target: 80%)
```

## Summary

| Metric | Value |
|--------|-------|
| Total tests | 44 |
| Passed | 44 |
| Failed | 0 |
| Coverage | 84.2% |

Test Status: PASS ✓
````

## Common Test Failures

| Failure | Typical Fix |
|---------|-------------|
| `Expected: <X> Actual: <Y>` | Update assertion or fix implementation |
| `Widget not found` | Fix finder selector or update test after widget rename |
| `Golden file not found` | Run `flutter test --update-goldens` to generate |
| `Golden mismatch` | Inspect diff; run `--update-goldens` if change was intentional |
| `MissingPluginException` | Mock platform channel in test setup |
| `LateInitializationError` | Initialize `late` fields in `setUp()` |
| `pumpAndSettle timed out` | Replace with explicit `pump(Duration)` calls |

## Related Commands

- `/ecc-flutter-build` — Fix build errors before running tests
- `/ecc-flutter-review` — Review code after tests pass
- `ecc-tdd-workflow` skill — Test-driven development workflow

## Related

- Agent: `.claude/agents/ecc-flutter-reviewer.md`
- Agent: `.claude/agents/ecc-dart-build-resolver.md`
- Skill: `.claude/skills/ecc-flutter-dart-code-review/`
- Rules: `.claude/rules/dart/testing.md`
