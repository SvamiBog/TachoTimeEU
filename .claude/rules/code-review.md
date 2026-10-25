# Code Review Standards

> Adapted from ECC `rules/common/code-review.md` (github.com/affaan-m/ECC, MIT). `CLAUDE.md` and the project docs take precedence over this file.

## When to review

- After a non-trivial change, before it is committed, and before a PR is marked "Ready for review" (that starts the full CI stage, CI-13).
- Always for: the regulatory engine (`packages/tacho_engine`), Premium and licensing (`EntitlementService`, `docs/premium.md`), the Drift schema and migrations, journal edits, backup and transfer, PDF/CSV export, background tracking and notifications, permissions, crash reporting and analytics consent.

## Checklist

- [ ] Readable and well-named; functions focused (about 50 lines), files cohesive (about 800 lines; tests and generated code may be longer)
- [ ] No nesting deeper than 4 levels; errors handled explicitly
- [ ] No secrets in code, tests or `env/*.json`; keys only through `--dart-define`
- [ ] No `print`/`debugPrint` left in `lib/`; no `console.log` in the web prototype
- [ ] Regulation logic only in `tacho_engine` (pure Dart, UTC); the UI shows engine results and warnings and does not repeat the rules
- [ ] UI: theme tokens only (no hex in widgets), touch targets of at least 44 dp, every string in ARB and in all languages at once
- [ ] Premium decided only by `EntitlementService`; no `isPremium` flags anywhere
- [ ] Module and class doc comments in English, other comments in Russian (DOC-07)
- [ ] Tests for new behaviour; the coverage thresholds from `docs/testing.md` still hold
- [ ] `dart format` and `analyze --fatal-infos` are clean

## Severity

| Level | Meaning | Action |
|-------|---------|--------|
| CRITICAL | Security issue, data loss, or a wrong regulatory result | Block: fix before merge |
| HIGH | Bug or significant quality issue | Fix before merge |
| MEDIUM | Maintainability concern | Consider fixing |
| LOW | Style or minor suggestion | Optional |

Approve only with no CRITICAL or HIGH findings. A wrong driving, break or rest calculation is always CRITICAL: drivers rely on it in front of inspectors.

## Workflow

1. Read the diff (`git diff`, or the PR diff).
2. Security-sensitive and engine areas first.
3. Run the affected tests (commands in [dart/testing.md](dart/testing.md)).
4. For a deeper pass: the `/code-review` or `/security-review` skill.
