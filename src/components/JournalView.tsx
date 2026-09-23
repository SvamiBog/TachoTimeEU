import React, { useState } from 'react';
import { Download, Plus, Bed, ChevronDown } from 'lucide-react';
import { JournalWeek, JournalDay } from '../types/tacho';

interface JournalViewProps {
  onOpenShiftModal: (day?: JournalDay, weekId?: string) => void;
  onOpenExportModal: () => void;
  weeks: JournalWeek[];
}

export const JournalView: React.FC<JournalViewProps> = ({
  onOpenShiftModal,
  onOpenExportModal,
  weeks,
}) => {
  const [showOlderWeek, setShowOlderWeek] = useState(false);

  return (
    <div className="relative flex flex-col gap-3 pb-28 text-[#EDEBE6]">
      
      {/* Top Header */}
      <header className="h-16 px-5 flex items-center justify-between">
        <div className="flex flex-col">
          <h1 className="text-[20px] font-bold tracking-tight">Журнал</h1>
          <span className="text-[12px] text-[#A3A8AE]">Сентябрь 2026</span>
        </div>
        <button
          onClick={onOpenExportModal}
          className="w-10 h-10 rounded-full flex items-center justify-center text-[#EDEBE6] hover:bg-[#1A1D20] transition-colors"
        >
          <Download className="w-5 h-5" />
        </button>
      </header>

      {/* Weeks list */}
      <div className="flex flex-col gap-3">
        {weeks.map((week) => {
          const driveH = Math.floor(week.driveMinutes / 60);
          const driveM = week.driveMinutes % 60;
          const fortnightH = Math.floor(week.fortnightMinutes / 60);
          const fortnightM = week.fortnightMinutes % 60;
          const drivePct = Math.min(100, (week.driveMinutes / week.driveLimitMinutes) * 100);

          return (
            <section
              key={week.id}
              className="mx-4 bg-[#1A1D20] rounded-[24px] overflow-hidden border border-[#262A2F]/40 shadow-sm"
            >
              {/* Week Summary Header */}
              <div className="p-4 flex flex-col gap-2.5">
                <div className="flex items-baseline justify-between">
                  <h2 className="text-[15px] font-bold">{week.title}</h2>
                  {week.isCurrent && (
                    <span className="text-[12px] font-bold px-2 py-0.5 rounded-[8px] bg-[#2B2415] text-[#F7D38A]">
                      текущая
                    </span>
                  )}
                </div>

                <div className="h-1.5 rounded-full bg-[#2A2E33] overflow-hidden">
                  <div
                    className="h-full rounded-full bg-[#F3B33D]"
                    style={{ width: `${drivePct}%` }}
                  />
                </div>

                <div className="flex justify-between text-[13px] text-[#A3A8AE]">
                  <span>
                    Вождение{' '}
                    <b className="font-mono-num text-[#EDEBE6]">
                      {driveH}:{driveM.toString().padStart(2, '0')}
                    </b>{' '}
                    из 56
                  </span>
                  <span>
                    За 2 нед.{' '}
                    <b className="font-mono-num text-[#EDEBE6]">
                      {fortnightH}:{fortnightM.toString().padStart(2, '0')}
                    </b>{' '}
                    из 90
                  </span>
                </div>
              </div>

              {/* Days List */}
              <div className="divide-y divide-[#262A2F]">
                {week.days.map((d) => {
                  const isLive = d.timeRange.includes('сейчас') || d.timeRange.includes('идёт');
                  return (
                    <div
                      key={d.id}
                      onClick={() => onOpenShiftModal(d, week.id)}
                      className="p-3.5 px-4 grid grid-cols-[44px_1fr] gap-3 cursor-pointer hover:bg-[#262A2F]/40 transition-colors"
                    >
                      {/* DOW & Day Number */}
                      <div className="flex flex-col items-center justify-center">
                        <span className="text-[12px] text-[#A3A8AE] uppercase font-semibold">
                          {d.dow}
                        </span>
                        <span className="font-mono-num text-[20px] font-bold leading-tight">
                          {d.day}
                        </span>
                      </div>

                      {/* Details & 3 chips */}
                      <div className="flex flex-col gap-2">
                        <div className="flex justify-between items-center text-[14px]">
                          <span className="font-semibold text-[#EDEBE6]">{d.place}</span>
                          <span
                            className={`font-mono-num text-[13px] font-bold ${
                              isLive ? 'text-[#F3B33D]' : 'text-[#A3A8AE]'
                            }`}
                          >
                            {d.timeRange}
                          </span>
                        </div>

                        {/* 3 Metric Chips */}
                        <div className="grid grid-cols-3 gap-1.5">
                          {/* Drive Chip */}
                          <div
                            className="p-1.5 px-2 rounded-[10px] flex flex-col"
                            style={{
                              backgroundColor: d.driveBg || '#262A2F',
                              color: d.driveFg || '#EDEBE6',
                            }}
                          >
                            <span className="text-[11px] opacity-75">Вождение</span>
                            <span className="font-mono-num text-[15px] font-bold">
                              {d.drive}
                            </span>
                          </div>

                          {/* Shift Chip */}
                          <div
                            className="p-1.5 px-2 rounded-[10px] flex flex-col"
                            style={{
                              backgroundColor: d.shiftBg || '#262A2F',
                              color: d.shiftFg || '#EDEBE6',
                            }}
                          >
                            <span className="text-[11px] opacity-75">Смена</span>
                            <span className="font-mono-num text-[15px] font-bold">
                              {d.shift}
                            </span>
                          </div>

                          {/* Rest Chip */}
                          <div
                            className="p-1.5 px-2 rounded-[10px] flex flex-col"
                            style={{
                              backgroundColor: d.restBg || '#262A2F',
                              color: d.restFg || '#EDEBE6',
                            }}
                          >
                            <span className="text-[11px] opacity-75">Отдых</span>
                            <span className="font-mono-num text-[15px] font-bold">
                              {d.rest}
                            </span>
                          </div>
                        </div>
                      </div>
                    </div>
                  );
                })}

                {/* Weekly Rest Card if present */}
                {week.weeklyRest && (
                  <div className="p-3.5 px-4 flex items-center gap-3 bg-[#16261F] text-[#9FE3CE]">
                    <Bed className="w-5 h-5 text-[#4FBF9F] shrink-0" />
                    <div className="flex-1 flex flex-col">
                      <span className="text-[14px] font-semibold">{week.weeklyRest.type}</span>
                      <span className="font-mono-num text-[12px] text-[#A3A8AE]">
                        {week.weeklyRest.range}
                      </span>
                    </div>
                    <span className="font-mono-num text-[17px] font-bold">
                      {week.weeklyRest.duration}
                    </span>
                  </div>
                )}
              </div>
            </section>
          );
        })}

        {/* Older week toggle */}
        <button
          onClick={() => setShowOlderWeek(!showOlderWeek)}
          className="mx-4 h-14 px-4 rounded-[20px] bg-[#1A1D20] text-[#EDEBE6] flex items-center justify-between border border-[#2A2E33] hover:border-[#F3B33D]/40 transition-colors"
        >
          <span className="text-[15px] font-bold">7–13 сентября</span>
          <div className="flex items-center gap-2">
            <span className="text-[13px] text-[#A3A8AE]">
              вождение <b className="font-mono-num text-[#EDEBE6]">41:10</b>
            </span>
            <ChevronDown
              className={`w-4 h-4 text-[#A3A8AE] transition-transform ${
                showOlderWeek ? 'rotate-180' : ''
              }`}
            />
          </div>
        </button>

        {showOlderWeek && (
          <div className="mx-4 p-4 rounded-[20px] bg-[#1A1D20] text-[13px] text-[#A3A8AE] border border-[#262A2F] text-center">
            Всего за неделю 41 ч 10 мин вождения · 5 смен без нарушений.
          </div>
        )}
      </div>

      {/* Floating Action Button «+ Смена» */}
      <div className="sticky bottom-4 mr-4 self-end z-20 pointer-events-auto mt-2">
        <button
          type="button"
          onClick={() => onOpenShiftModal(undefined, weeks[0]?.id)}
          className="h-14 px-5 rounded-[18px] bg-[#F3B33D] hover:bg-[#e0a232] text-[#111315] flex items-center gap-2 font-bold text-[15px] shadow-2xl active:scale-95 transition-all"
        >
          <Plus className="w-5 h-5 stroke-[2.5]" />
          <span>Смена</span>
        </button>
      </div>

    </div>
  );
};
