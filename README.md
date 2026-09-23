# TachoTimeEU

European Driver Tachograph & Driving Hours Regulation Assistant according to **Regulation (EC) No 561/2006**, **Regulation (EU) 165/2014**, and the **EU Mobility Package I**.

Designed for professional European truck, coach, and commercial transport drivers (HGV / LGV / PSV) to monitor compliance in real time and prevent costly roadside infringements.

## Features

- **Smart Tachograph HUD (Cockpit)**:
  - 4 one-tap standard activity buttons with official pictograms: **Drive** (⛟), **Work** (⚒), **POA** (⊠), and **Rest/Break** (🛏).
  - Real-time stopwatch and live UTC clock.
  - Continuous driving countdown (4h 30m maximum) with split break tracking (15m + 30m rule).
  - Daily driving limits countdown (9h standard / 10h extended with weekly allowance tracking).
  - Shift duty duration and 24h rest window deadline calculator.
  - Weekly (56h) and Fortnightly (90h) driving progress meters.
  - Solo Driver and Multi-Manning (Team Crew / 30h window) modes.
  - Ferry / Train crossing mode (Article 9 interruption tracking).
- **24-Hour Visual Tachograph Timeline**:
  - Color-coded activity ribbon mapping every minute of the 24-hour cycle.
- **Compliance & Infringement Engine**:
  - Instant detection of continuous driving overages, missed breaks, daily driving limit violations, and shift window overages with direct EC 561/2006 article citations.
- **Synthesized Web Audio Alerts**:
  - 15-minute advance break warning chime and violation alerts.
- **Shift & Route Planner (Simulator)**:
  - Build multi-stop trip itineraries and test break placements before departure.
- **Tachograph 24h Thermal Printout Simulation**:
  - Standard EU format printout with technical driver/vehicle header, activity summary, infringements, Article 12 derogation notes, and signature lines.
- **Activity History & Export**:
  - Full activity log with manual entry editing, JSON backup, and CSV export.
- **Multilingual Support**:
  - English, Deutsch, Polski, Español, Français, Română, and Nederlands.

## Tech Stack

- React 19 + TypeScript
- Vite
- Tailwind CSS
- Web Audio API
- Lucide React Icons
