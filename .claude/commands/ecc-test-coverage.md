---
description: Analyze coverage, identify gaps, and generate missing tests toward the target threshold.
---

> Adapted from ECC `commands/test-coverage.md` v2.2.3 (github.com/affaan-m/ECC, MIT; see `.claude/ECC-NOTICE.md`). `CLAUDE.md` and `.claude/rules/` take precedence over this file.
>
> In TachoGo: run the commands from `.claude/rules/dart/testing.md` (from `app/` or `packages/tacho_engine/`, analyze with `--fatal-infos`); Riverpod without code generation, Drift, hand-written fakes instead of mocks, every string in ARB (`.claude/rules/dart/`); regulation logic only in `packages/tacho_engine`. Commit only when the user asks.

# Test Coverage

Analyze test coverage, identify gaps, and generate missing tests to reach the project's thresholds: at least 95 % of lines in `packages/tacho_engine/lib` and at least 80 % in `app/lib/data` (`.claude/rules/testing.md`).

## Step 1: Pick the Coverage Command

| Part | Coverage command |
|------|------------------|
| Engine (`packages/tacho_engine`) | `dart run coverage:test_with_coverage`, then `dart run tool/check_coverage.dart coverage/lcov.info 95 lib/` |
| App (`app`) | `flutter test --coverage`, then `dart run ../packages/tacho_engine/tool/check_coverage.dart coverage/lcov.info 80 lib/data/` |

## Step 2: Analyze Coverage Report

1. Run the coverage command
2. Parse the output (JSON summary or terminal output)
3. List files below the threshold of their part, sorted worst-first
4. For each under-covered file, identify:
   - Untested functions or methods
   - Missing branch coverage (if/else, switch, error paths)
   - Dead code that inflates the denominator

## Step 3: Generate Missing Tests

For each under-covered file, generate tests following this priority:

1. **Happy path** — Core functionality with valid inputs
2. **Error handling** — Invalid inputs, missing data, network failures
3. **Edge cases** — Empty arrays, null/undefined, boundary values (0, -1, MAX_INT)
4. **Branch coverage** — Each if/else, switch case, ternary

### Test Generation Rules

- Follow the project layout: `app/test/<area>/…_test.dart` mirrors `lib/`; engine tests are grouped by regulation article
- Use existing test patterns from the project (import style, assertion library, mocking approach)
- Replace platforms and plugins with the project's hand-written fakes (no mocking libraries)
- Each test should be independent — no shared mutable state between tests
- Name tests in Russian, with the test ID from `docs/testing.md` in front when there is one (`UI-11: тема из настроек — …`)

## Step 4: Verify

1. Run the full test suite — all tests must pass
2. Re-run coverage — verify improvement
3. If still below the threshold, repeat Step 3 for the remaining gaps

## Step 5: Report

Show before/after comparison:

```
Coverage Report
──────────────────────────────
File                   Before  After
src/services/auth.ts   45%     88%
src/utils/validation.ts 32%    82%
──────────────────────────────
Overall:               67%     84%  PASS:
```

## Focus Areas

- Functions with complex branching (high cyclomatic complexity)
- Error handlers and catch blocks
- Utility functions used across the codebase
- API endpoint handlers (request → response flow)
- Edge cases: null, undefined, empty string, empty array, zero, negative numbers
