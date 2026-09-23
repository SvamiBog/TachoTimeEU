import React, { useState } from 'react';
import { ChevronLeft, ChevronRight } from 'lucide-react';

interface ShiftDateTimeModalProps {
  initialTab?: 'start' | 'end';
  startDay: number;
  startTime: string; // "HH:MM"
  endDay: number;
  endTime: string; // "HH:MM"
  onClose: () => void;
  onSave: (result: {
    startDay: number;
    startTime: string;
    endDay: number;
    endTime: string;
  }) => void;
}

export const ShiftDateTimeModal: React.FC<ShiftDateTimeModalProps> = ({
  initialTab = 'start',
  startDay: initialStartDay,
  startTime: initialStartTime,
  endDay: initialEndDay,
  endTime: initialEndTime,
  onClose,
  onSave,
}) => {
  const [tab, setTab] = useState<'start' | 'end'>(initialTab);
  const [startDay, setStartDay] = useState(initialStartDay || 22);
  const [startTime, setStartTime] = useState(initialStartTime || '06:30');
  const [endDay, setEndDay] = useState(initialEndDay || 22);
  const [endTime, setEndTime] = useState(initialEndTime || '19:10');

  const activeDay = tab === 'start' ? startDay : endDay;
  const activeTime = tab === 'start' ? startTime : endTime;

  const [activeHourStr, activeMinuteStr] = activeTime.split(':');
  const activeHour = parseInt(activeHourStr || '6', 10);
  const activeMinute = parseInt(activeMinuteStr || '30', 10);

  const setHour = (h: number) => {
    const validH = (h + 24) % 24;
    const newTime = `${validH.toString().padStart(2, '0')}:${activeMinute.toString().padStart(2, '0')}`;
    if (tab === 'start') {
      setStartTime(newTime);
    } else {
      setEndTime(newTime);
    }
  };

  const setMinute = (m: number) => {
    const validM = (m + 60) % 60;
    const newTime = `${activeHour.toString().padStart(2, '0')}:${validM.toString().padStart(2, '0')}`;
    if (tab === 'start') {
      setStartTime(newTime);
    } else {
      setEndTime(newTime);
    }
  };

  const handleSelectDay = (d: number) => {
    if (tab === 'start') {
      setStartDay(d);
      // If end day is earlier than start day, sync end day
      if (endDay < d) setEndDay(d);
    } else {
      setEndDay(d);
    }
  };

  // Calendar setup for September 2026 (September 1 is Tuesday -> 1 empty cell at start)
  const today = 23;
  const daysInMonth = 30;
  const firstDowOffset = 1; // Tuesday (Mon=0, Tue=1)

  const calendarCells = [];
  for (let i = 0; i < firstDowOffset; i++) {
    calendarCells.push(null);
  }
  for (let d = 1; d <= daysInMonth; d++) {
    calendarCells.push(d);
  }
  while (calendarCells.length % 7 !== 0) {
    calendarCells.push(null);
  }

  const prevHour = (activeHour - 1 + 24) % 24;
  const nextHour = (activeHour + 1) % 24;
  const prevMin = (activeMinute - 5 + 60) % 60;
  const nextMin = (activeMinute + 5) % 60;

  return (
    <div className="fixed inset-0 bg-black/85 backdrop-blur-xs flex items-end justify-center p-0 z-50">
      <div
        className="w-full max-w-[412px] bg-[#1A1D20] text-[#EDEBE6] rounded-t-[28px] p-5 pb-7 flex flex-col gap-3.5 shadow-2xl border-t border-[#2A2E33]"
      >
        {/* Top pill drag handle */}
        <div className="self-center w-10 h-1 rounded-full bg-[#3A3F45]" />

        {/* Tablist for Start / End */}
        <div className="grid grid-cols-2 gap-1 p-1 rounded-[16px] bg-[#111315]">
          <button
            type="button"
            onClick={() => setTab('start')}
            className={`h-11 rounded-[12px] flex flex-col items-center justify-center transition-all ${
              tab === 'start'
                ? 'bg-[#2F343A] text-[#EDEBE6]'
                : 'text-[#A3A8AE] hover:text-[#EDEBE6]'
            }`}
          >
            <span className="text-[12px] font-semibold">Начало</span>
            <span className="font-mono-num text-[13px] font-bold">
              {startDay.toString().padStart(2, '0')}.09 · {startTime}
            </span>
          </button>

          <button
            type="button"
            onClick={() => setTab('end')}
            className={`h-11 rounded-[12px] flex flex-col items-center justify-center transition-all ${
              tab === 'end'
                ? 'bg-[#2F343A] text-[#EDEBE6]'
                : 'text-[#A3A8AE] hover:text-[#EDEBE6]'
            }`}
          >
            <span className="text-[12px] font-semibold">Конец</span>
            <span className="font-mono-num text-[13px] font-bold">
              {endDay.toString().padStart(2, '0')}.09 · {endTime}
            </span>
          </button>
        </div>

        {/* Month Title */}
        <div className="flex items-center justify-between">
          <h2 className="text-[17px] font-bold">Сентябрь 2026</h2>
          <div className="flex items-center gap-1">
            <button
              type="button"
              className="w-10 h-10 rounded-full flex items-center justify-center text-[#EDEBE6] hover:bg-[#262A2F]"
            >
              <ChevronLeft className="w-5 h-5" />
            </button>
            <button
              type="button"
              disabled
              className="w-10 h-10 rounded-full flex items-center justify-center text-[#4A4F55]"
            >
              <ChevronRight className="w-5 h-5" />
            </button>
          </div>
        </div>

        {/* Days of week */}
        <div className="grid grid-cols-7 gap-1 text-center">
          {['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'].map((d) => (
            <span key={d} className="h-6 text-[12px] font-semibold text-[#A3A8AE]">
              {d}
            </span>
          ))}

          {/* Calendar Day Buttons */}
          {calendarCells.map((d, idx) => {
            if (d === null) {
              return <div key={`empty-${idx}`} className="h-10" />;
            }
            const isSelected = d === activeDay;
            const isToday = d === today;
            const isFuture = d > today;

            return (
              <button
                key={`day-${d}`}
                type="button"
                disabled={isFuture}
                onClick={() => handleSelectDay(d)}
                className={`h-10 rounded-full font-mono-num text-[15px] font-bold flex items-center justify-center transition-all ${
                  isSelected
                    ? 'bg-[#F3B33D] text-[#111315] shadow-md scale-105'
                    : isFuture
                    ? 'text-[#4A4F55] cursor-not-allowed'
                    : isToday
                    ? 'border border-[#A3A8AE] text-[#EDEBE6] hover:bg-[#262A2F]'
                    : 'text-[#EDEBE6] hover:bg-[#262A2F]'
                }`}
              >
                {d}
              </button>
            );
          })}
        </div>

        {/* Time Selector */}
        <div className="flex flex-col gap-2 pt-2 border-t border-[#262A2F]">
          <span className="text-[12px] font-semibold tracking-wider uppercase text-[#A3A8AE]">
            Время ({tab === 'start' ? 'Начало' : 'Конец'})
          </span>

          <div className="relative grid grid-cols-[1fr_20px_1fr] items-center text-center py-1">
            {/* Center Drum Highlight Bar */}
            <div
              aria-hidden="true"
              className="absolute left-0 right-0 top-1/2 -translate-y-1/2 h-12 rounded-[14px] bg-[#262A2F] pointer-events-none"
            />

            {/* Hours Column */}
            <div className="relative flex flex-col items-center">
              <button
                type="button"
                onClick={() => setHour(activeHour - 1)}
                className="h-9 flex items-center font-mono-num text-[17px] text-[#6B7178] hover:text-[#EDEBE6]"
              >
                {prevHour.toString().padStart(2, '0')}
              </button>
              <div className="h-12 flex items-center font-mono-num text-[28px] font-bold text-[#EDEBE6]">
                {activeHour.toString().padStart(2, '0')}
              </div>
              <button
                type="button"
                onClick={() => setHour(activeHour + 1)}
                className="h-9 flex items-center font-mono-num text-[17px] text-[#6B7178] hover:text-[#EDEBE6]"
              >
                {nextHour.toString().padStart(2, '0')}
              </button>
            </div>

            {/* Colon */}
            <span className="relative text-center font-mono-num text-[26px] font-bold text-[#EDEBE6]">
              :
            </span>

            {/* Minutes Column */}
            <div className="relative flex flex-col items-center">
              <button
                type="button"
                onClick={() => setMinute(activeMinute - 5)}
                className="h-9 flex items-center font-mono-num text-[17px] text-[#6B7178] hover:text-[#EDEBE6]"
              >
                {prevMin.toString().padStart(2, '0')}
              </button>
              <div className="h-12 flex items-center font-mono-num text-[28px] font-bold text-[#EDEBE6]">
                {activeMinute.toString().padStart(2, '0')}
              </div>
              <button
                type="button"
                onClick={() => setMinute(activeMinute + 5)}
                className="h-9 flex items-center font-mono-num text-[17px] text-[#6B7178] hover:text-[#EDEBE6]"
              >
                {nextMin.toString().padStart(2, '0')}
              </button>
            </div>
          </div>
        </div>

        {/* Buttons */}
        <div className="grid grid-cols-2 gap-2.5 mt-2">
          <button
            type="button"
            onClick={onClose}
            className="h-13 rounded-[18px] border border-[#3A3F45] text-[#EDEBE6] font-semibold text-[15px] hover:bg-[#262A2F] transition-colors"
          >
            Отмена
          </button>
          <button
            type="button"
            onClick={() => {
              onSave({ startDay, startTime, endDay, endTime });
              onClose();
            }}
            className="h-13 rounded-[18px] bg-[#F3B33D] hover:bg-[#e0a232] text-[#111315] font-bold text-[15px] transition-colors"
          >
            Готово
          </button>
        </div>
      </div>
    </div>
  );
};
