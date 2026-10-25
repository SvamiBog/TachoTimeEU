# Security Guidelines

> Adapted from ECC `rules/common/security.md` (github.com/affaan-m/ECC, MIT). `CLAUDE.md` and the project docs take precedence over this file.

## Before any commit

- [ ] No secrets in code, tests or `env/*.json`: keys come through `--dart-define` (`CRASH_DSN`, `ANALYTICS_KEY`); signing data only in `app/android/key.properties` (git-ignored) and CI secrets
- [ ] External input is validated: forms, backup JSON, the signed ban rules file, `.DDD` files, plugin and OS data
- [ ] Custom SQL in Drift uses variables, never string concatenation
- [ ] No personal data or coordinates in logs, crash reports or analytics events; analytics only after consent
- [ ] Premium is decided only by `EntitlementService`; nothing in settings or the database can grant it
- [ ] Messages shown to the driver leak no internals
- [ ] Web prototype and site: no unsanitized HTML built from data

## Secret management

- Never hardcode secrets; an optional service stays off when its key is missing.
- Rotate any secret that may have been exposed.

## If a security issue is found

1. Stop and tell the user.
2. Review it with the `/security-review` skill.
3. Fix CRITICAL issues before continuing.
4. Rotate exposed secrets and look for the same pattern elsewhere in the codebase.
