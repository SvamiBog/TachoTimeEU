# Testing Requirements

> Adapted from ECC `rules/common/testing.md` (github.com/affaan-m/ECC, MIT). `CLAUDE.md` and the project docs take precedence over this file. The list of tests, their IDs and the order they are introduced: `docs/testing.md`.

## Coverage (enforced in CI)

- `packages/tacho_engine/lib`: at least 95 % of lines.
- `app/lib/data`: at least 80 % of lines.
- Other code: tests for the behaviour that matters, no fixed percentage.

## Test-driven development

1. Write the test first and run it: it must fail (RED).
2. Write the smallest implementation that passes (GREEN).
3. Refactor with the tests green (IMPROVE).
4. Check coverage where a threshold applies.

Engine tests are cases from Regulation (EC) 561/2006 and AETR, described in `docs/domain/eu-561-rules.md`; where the text is ambiguous, follow the reading that document records (its sources: the regulation text and the DVSA guidance).

## When a test fails

- Fix the implementation, not the test, unless the test is wrong; say which of the two it was.
- Check isolation: time comes from an injected clock, platforms are fakes, nothing depends on the machine's time zone.

## Structure and names

Arrange–Act–Assert. A test name describes the behaviour, in Russian like the rest of the suite, with the test ID from `docs/testing.md` in front when there is one, for example `UI-11: тема из настроек — …`.
