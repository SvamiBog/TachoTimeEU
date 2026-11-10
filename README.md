# TachoGo

Driving and rest time assistant for professional drivers in the EU: trucks, coaches and, from 1 July 2026, vans of 2.5–3.5 t in international transport.

The driver switches the activity — driving, other work, availability, rest — and the app keeps the log and shows in real time what is left of every limit of **Regulation (EC) No 561/2006** and the **AETR**, warns about breaks and the end of the working day, builds a report for a roadside check and shows truck driving bans across Europe.

TachoGo helps plan driving and rest time. It does not replace the tachograph and is not legal advice.

**Status:** closed beta on Android (Phase 4 of the [roadmap](docs/roadmap.md)). iOS is paused until after v1.0.

## What is in the repository

| Path | What |
|---|---|
| [`app/`](app/README.md) | The Flutter app (Android): screens, local database, background detection of driving, notifications, export |
| [`packages/tacho_engine/`](packages/tacho_engine/README.md) | The regulatory engine: pure Dart without Flutter, covered by tests on cases from the regulation |
| [`docs/`](docs/) | Requirements ([`PRD.md`](docs/PRD.md)), roadmap, the rules the engine follows ([`domain/eu-561-rules.md`](docs/domain/eu-561-rules.md)), the test plan ([`testing.md`](docs/testing.md)), design, beta, store listing |
| `site/`, `deploy/site/` | The website `tachogo.eu`: landing, privacy policy and the signed driving ban rules file ([`docs/site/README.md`](docs/site/README.md)) |
| `src/`, `index.html`, `package.json` | The first web prototype (React). Kept for reference — the app does not use it |

The project documentation is in Russian; module and class descriptions in the code are in English.

## The app

- **Limits calculated from the log**, not typed in: continuous driving 4:30 and the 45 min break (or 15 + 30), daily driving 9 h / 10 h, the working day 13 h / 15 h (crew 19 h / 21 h), weekly 56 h and two-week 90 h driving, daily and weekly rest with compensation, 144 h between weekly rests, ferry and train interruptions, driver card download every 28 days.
- **Warnings and notifications** before a limit runs out and when a rest is complete — they arrive with the app closed.
- **Journal** by weeks and shifts, corrections, shifts entered as totals, a PDF / CSV report for inspection.
- **Automatic detection of driving** by GPS speed (optional, off by default).
- **Truck driving bans** by country, updated from a signed file without a new app version.
- **Offline first:** everything is stored on the phone, no account is needed.
- **14 interface languages**, dark and light themes.

What is free and what is Premium: [`docs/premium.md`](docs/premium.md).

## Run

The Flutter version is the one CI uses — `FLUTTER_VERSION` in [`.github/workflows/ci.yml`](.github/workflows/ci.yml).

```bash
cd app
flutter pub get
flutter run --dart-define-from-file=env/dev.json
```

Tests and checks:

```bash
cd packages/tacho_engine && dart test          # the engine
cd app && flutter test                         # the app
cd app && flutter analyze --fatal-infos
```

More — environments, strings and languages, the database, notifications: [`app/README.md`](app/README.md). How CI runs the checks: [`docs/testing.md`](docs/testing.md).

## Web prototype

The prototype the app grew from: React 19, TypeScript, Vite, Tailwind CSS 4, Vitest. It has its own copy of the rules in `src/domain/` and is not kept in step with the engine.

```bash
npm install
npm run dev     # http://localhost:3000
npm test        # rule tests (Vitest)
npm run lint    # TypeScript check
```
