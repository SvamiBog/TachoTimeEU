import React from 'react';
import { ActivityEntry, ActivityType, SupportedLanguage } from '../types/tacho';
import { translations } from '../utils/translations';
import { formatMinutesToHM } from '../utils/compliance';

interface TimelineBarProps {
  entries: ActivityEntry[];
  language: SupportedLanguage;
}

export const TimelineBar: React.FC<TimelineBarProps> = ({ entries, language }) => {
  const t = translations[language] || translations.en;
  const now = Date.now();

  // Define today from 00:00 to 24:00 in local/UTC time
  const todayStart = new Date();
  todayStart.setHours(0, 0, 0, 0);
  const startOfDayMs = todayStart.getTime();
  const totalDayMs = 24 * 60 * 60 * 1000;

  // Filter and clip entries to today
  const dayEntries = entries.filter((e) => {
    const end = e.endTime ?? now;
    return end >= startOfDayMs && e.startTime < startOfDayMs + totalDayMs;
  });

  // Calculate totals for today
  let driveTotal = 0;
  let workTotal = 0;
  let poaTotal = 0;
  let restTotal = 0;

  dayEntries.forEach((e) => {
    const start = Math.max(startOfDayMs, e.startTime);
    const end = Math.min(startOfDayMs + totalDayMs, e.endTime ?? now);
    const durMin = Math.max(0, (end - start) / 60000);

    if (e.activity === 'DRIVE') driveTotal += durMin;
    else if (e.activity === 'WORK') workTotal += durMin;
    else if (e.activity === 'POA') poaTotal += durMin;
    else if (e.activity === 'REST') restTotal += durMin;
  });

  const getActivityColor = (type: ActivityType) => {
    switch (type) {
      case 'DRIVE':
        return 'bg-emerald-500';
      case 'WORK':
        return 'bg-amber-500';
      case 'POA':
        return 'bg-sky-500';
      case 'REST':
        return 'bg-indigo-500';
    }
  };

  const hoursMarks = [0, 3, 6, 9, 12, 15, 18, 21, 24];

  return (
    <div className="bg-slate-900 border border-slate-800 rounded-xl p-4 shadow-lg">
      <div className="flex flex-wrap items-center justify-between gap-2 mb-3">
        <h3 className="text-xs font-bold uppercase tracking-wider text-slate-300 flex items-center gap-2">
          <span className="w-2 h-2 rounded-full bg-blue-500"></span>
          24-Hour Tachograph Timeline (Today)
        </h3>

        {/* Legend / Breakdown Badges */}
        <div className="flex items-center gap-3 text-xs font-mono-tacho flex-wrap">
          <span className="flex items-center gap-1.5 text-emerald-400">
            <span className="w-2.5 h-2.5 rounded-xs bg-emerald-500 inline-block"></span>
            {t.drive}: <strong>{formatMinutesToHM(driveTotal)}</strong>
          </span>
          <span className="flex items-center gap-1.5 text-amber-400">
            <span className="w-2.5 h-2.5 rounded-xs bg-amber-500 inline-block"></span>
            {t.work}: <strong>{formatMinutesToHM(workTotal)}</strong>
          </span>
          <span className="flex items-center gap-1.5 text-sky-400">
            <span className="w-2.5 h-2.5 rounded-xs bg-sky-500 inline-block"></span>
            {t.poa}: <strong>{formatMinutesToHM(poaTotal)}</strong>
          </span>
          <span className="flex items-center gap-1.5 text-indigo-400">
            <span className="w-2.5 h-2.5 rounded-xs bg-indigo-500 inline-block"></span>
            {t.rest}: <strong>{formatMinutesToHM(restTotal)}</strong>
          </span>
        </div>
      </div>

      {/* 24-Hour Ribbon Track */}
      <div className="relative w-full h-8 bg-slate-950 rounded-lg overflow-hidden border border-slate-800 shadow-inner">
        {dayEntries.map((entry) => {
          const start = Math.max(startOfDayMs, entry.startTime);
          const end = Math.min(startOfDayMs + totalDayMs, entry.endTime ?? now);
          const leftPercent = Math.max(0, ((start - startOfDayMs) / totalDayMs) * 100);
          const widthPercent = Math.max(0.2, ((end - start) / totalDayMs) * 100);

          return (
            <div
              key={entry.id}
              className={`absolute top-0 bottom-0 ${getActivityColor(entry.activity)} transition-opacity hover:opacity-80`}
              style={{
                left: `${leftPercent}%`,
                width: `${widthPercent}%`,
              }}
              title={`${entry.activity}: ${new Date(entry.startTime).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })} - ${entry.endTime ? new Date(entry.endTime).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }) : 'Now'} (${Math.round((end - start) / 60000)}m) ${entry.note ? `[${entry.note}]` : ''}`}
            />
          );
        })}

        {/* Current Time Pointer Line */}
        {now >= startOfDayMs && now <= startOfDayMs + totalDayMs && (
          <div
            className="absolute top-0 bottom-0 w-0.5 bg-red-500 z-10 shadow-sm"
            style={{
              left: `${((now - startOfDayMs) / totalDayMs) * 100}%`,
            }}
            title="Current Time"
          >
            <div className="w-1.5 h-1.5 bg-red-500 rounded-full -ml-0.5 -mt-0.5"></div>
          </div>
        )}
      </div>

      {/* Hour ticks line */}
      <div className="relative w-full flex justify-between text-[10px] text-slate-500 font-mono-tacho mt-1 px-1">
        {hoursMarks.map((h) => (
          <span key={h} className="text-center">
            {h.toString().padStart(2, '0')}:00
          </span>
        ))}
      </div>
    </div>
  );
};
