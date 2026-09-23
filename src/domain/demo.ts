import { analyzeTimeline } from './shifts';
import { MINUTE } from './time';
import type { ActivityEntry, ActivityType, ShiftMeta } from './types';

type Segment = [ActivityType, number];

// Две недели работы: прошлая неделя, недельный отдых 66:50, текущая неделя
// и идущая смена с первой частью раздельного перерыва (15 мин).
const SEGMENTS: Segment[] = [
  // пн: 7:50 вождения
  ['WORK', 20], ['DRIVE', 230], ['REST', 45], ['DRIVE', 240], ['WORK', 30], ['REST', 680],
  // вт: 9:40 — продление до 10 ч, раздельный перерыв 15 + 30, смена 14:05, затем сокращённый отдых 9:30
  ['WORK', 25], ['DRIVE', 270], ['REST', 15], ['WORK', 20], ['REST', 30], ['DRIVE', 240], ['REST', 45], ['DRIVE', 70], ['POA', 60], ['WORK', 70], ['REST', 570],
  // ср
  ['WORK', 20], ['DRIVE', 255], ['REST', 45], ['DRIVE', 240], ['WORK', 40], ['REST', 670],
  // чт
  ['WORK', 20], ['DRIVE', 210], ['REST', 45], ['DRIVE', 215], ['WORK', 60], ['REST', 940],
  // пт и недельный отдых 66:50
  ['WORK', 30], ['DRIVE', 164], ['WORK', 20], ['REST', 4010],
  // пн: 8:50
  ['WORK', 20], ['DRIVE', 265], ['REST', 45], ['DRIVE', 265], ['WORK', 45], ['REST', 690],
  // вт: 8:55
  ['WORK', 25], ['DRIVE', 260], ['REST', 45], ['DRIVE', 275], ['WORK', 35], ['REST', 699],
  // текущая смена: 15 мин перерыва взяты, сейчас вождение
  ['WORK', 20], ['DRIVE', 103], ['REST', 15], ['WORK', 18], ['DRIVE', 132],
];

const COUNTRIES = ['PL', 'D', 'D', 'D', 'D', 'PL', 'PL', 'PL'];

/** Демо-журнал, заканчивающийся текущим моментом. Только для «Загрузить пример». */
export function generateDemoData(now: number): { entries: ActivityEntry[]; meta: Record<string, ShiftMeta> } {
  const total = SEGMENTS.reduce((sum, [, m]) => sum + m, 0);
  let t = now - total * MINUTE;
  const entries: ActivityEntry[] = SEGMENTS.map(([activity, minutes], i) => {
    const startTime = t;
    t += minutes * MINUTE;
    const last = i === SEGMENTS.length - 1;
    return { id: `demo-${i}`, activity, startTime, endTime: last ? null : t };
  });

  // Страны по сменам: начало i-й смены, конец — начало следующей
  const meta: Record<string, ShiftMeta> = {};
  const { shifts } = analyzeTimeline(entries, now);
  shifts.forEach((s, i) => {
    meta[s.id] = { startCountry: COUNTRIES[i] ?? 'PL', endCountry: s.end === null ? undefined : (COUNTRIES[i + 1] ?? 'PL') };
  });
  return { entries, meta };
}
