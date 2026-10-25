---
paths:
  - "**/*.dart"
  - "**/pubspec.yaml"
  - "**/AndroidManifest.xml"
---
# Dart/Flutter Security

> Adapted from ECC `rules/dart/security.md` (github.com/affaan-m/ECC, MIT). Extends [security.md](../security.md). `CLAUDE.md` and the project docs take precedence over this file.

## Secrets and configuration

- `env/<env>.json` (`--dart-define-from-file`) holds configuration, never secrets. `CRASH_DSN` and `ANALYTICS_KEY` come through `--dart-define`, in CI from secrets.
- Values compiled into the app are not secret: anything that must stay secret belongs on the license server (Phase 5, `docs/server/license-server.md`).
- If tokens or license data ever need storing on the device, use Keystore-backed secure storage, not the settings table and not plain files.

## Network

- HTTPS only; every request has a timeout (as in `BanDataRepository`).
- Downloaded ban rules are used only after their Ed25519 signature checks out; without the network the built-in rules apply.

## Input validation

- Drift custom SQL (`customSelect`, `customStatement`) uses variables, never interpolated strings.
- Imported data (backup JSON, ban rules file, `.DDD`) is validated before it touches the database, and a failed import leaves the journal unchanged.

## Data protection

- The driver's journal is personal data and stays on the device; it leaves only through files the driver shares (backup, PDF, CSV).
- No personal data, journal contents or coordinates in logs, Sentry events or PostHog events; analytics only after consent and anonymous.
- "Clear all data" (`JournalCleaner`) removes the journal in one transaction.

## Android

- Request only the permissions a feature needs, at the moment it needs them; the final manifest is checked by `tool/check_android_manifest.dart`.
- Export components only when necessary (`android:exported="false"` otherwise).
- Release signing comes from `app/android/key.properties` (git-ignored) or CI secrets; do not change release build or obfuscation settings unless asked.

## iOS

Paused until after v1.0: keep the existing `ios/` folder and iOS branches, but do not configure or extend them.
