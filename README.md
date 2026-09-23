# TachoTimeEU

European driver hours assistant according to **Regulation (EC) No 561/2006**, the **AETR Agreement**, **Regulation (EU) 165/2014** and the **EU Mobility Package I**.

Built for professional truck and coach drivers: switch the activity mode, and the app keeps the log and shows in real time how much driving and working time is left before each limit.

This repository contains the **web prototype** (React). The production app is planned in Flutter — see `CLAUDE.md` and `docs/roadmap.md`.

## Features

- **Cockpit** — four one-tap activity buttons with tachograph pictograms (driving, rest, other work, availability). Tapping the active mode again does nothing, so a break is never split by accident.
- **Limits calculated from the log**, not typed in:
  - continuous driving 4:30 and the 45 min break, including the split 15 + 30 in the correct order;
  - daily driving 9 h / 10 h with the two weekly extensions counted automatically;
  - working day 13 h / 15 h (21 h for multi-manning) and the 24 h / 30 h daily-rest window;
  - weekly 56 h and two-week 90 h driving (weeks from Monday 00:00 UTC, as on the tachograph);
  - reduced daily rests since the last weekly rest, split daily rest 3 + 9;
  - working week 144 h, reduced weekly rest availability and compensation;
  - ferry / train interruptions of the daily rest (Art. 9);
  - driver card download every 28 days.
- **Warnings and infringements** on screen with article references; optional sound per category.
- **Log** — weeks and shifts built from the activity records plus shifts added manually; highlights for 10 h driving, 13+ h working day and reduced rest.
- **Corrections** — adjust daily driving, the current or last break and the shift start; edits take time from the neighbouring record, so records never overlap.
- **Export** — CSV for the selected period and a printable report for inspection (save as PDF from the print dialog).
- **Five languages** — Russian, Ukrainian, Polish, English, German.
- **Dark and light themes** built on the design tokens from `docs/design/tokens.json`.

All data is stored locally in the browser (`localStorage`). There is no account or sync yet.

## Run

```bash
npm install
npm run dev
```

Open http://localhost:3000. To check on a phone in the same network: `npm run dev -- --host`.

```bash
npm test        # rule engine tests (Vitest)
npm run lint    # TypeScript check
npm run build   # production build
```

## Structure

```
src/domain/     rule engine: timeline, shifts, limits, edits, journal, report — no React
src/i18n/       dictionaries (ru is the source; others are type-checked against it)
src/components/ screens and bottom sheets
src/storage.ts  localStorage persistence
```

## Tech stack

React 19, TypeScript, Vite, Tailwind CSS 4, Vitest, Lucide icons.

## Disclaimer

TachoTime helps plan driving and rest time but does not replace the tachograph and is not legal advice.
