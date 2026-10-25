# Coding Style

> Adapted from ECC `rules/common/coding-style.md` (github.com/affaan-m/ECC, MIT). `CLAUDE.md` and the project docs take precedence over this file.

## Immutability

Prefer immutable data: `final` fields, `const` constructors, `copyWith`, new collections instead of in-place changes. Mutate only where the framework or performance needs it (Riverpod `Notifier.state`, controllers, a local accumulator inside one function) and keep that mutation local.

## Principles

- KISS: the simplest solution that works; clarity over cleverness; no premature optimization.
- DRY: extract repetition that is real, not speculative.
- YAGNI: no features or abstractions before they are needed.

## File organization

- Many small, cohesive files: 200–400 lines is typical, about 800 is a soft ceiling (tests and generated code may exceed it).
- Organize by feature and domain, following `app/README.md` (`core/`, `data/`, `features/<screen>/`, `background/`, `notifications/`) and `packages/tacho_engine`.

## Error handling

- Handle errors explicitly; never swallow them silently.
- Messages for the driver are short, localized (ARB) and say what to do; technical details go to the log and `CrashReporter`.
- There is no backend: the app is offline-first. Crash reports reach Sentry only when `CRASH_DSN` is set; analytics only after the driver's consent.

## Input validation

Validate at the boundaries and fail fast: driver input in forms, imported files (backup JSON, the ban rules file, `.DDD`), data from plugins and the OS. Never trust external data.

## Naming

The language rules decide casing (Dart: `lowerCamelCase` for variables and constants, `UpperCamelCase` for types). A name says what the thing holds or does without a comment.

## Code smells

- Deep nesting: prefer early returns.
- Magic numbers: name thresholds and limits; regulation limits live as named constants in `tacho_engine`.
- Long functions: split them by responsibility.
