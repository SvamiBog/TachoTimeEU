import React, { useState, useMemo } from 'react';
import {
  ArrowLeft,
  Check,
  Trash2,
  Calendar,
  Clock,
  ChevronRight,
  ChevronDown,
} from 'lucide-react';
import { JournalDay } from '../../types/tacho';
import { CountryPickerModal } from './CountryPickerModal';
import { ShiftDateTimeModal } from './ShiftDateTimeModal';
import { TimeEditModal } from './TimeEditModal';

interface ShiftModalProps {
  shift?: JournalDay | null;
  defaultCountry?: string;
  onClose: () => void;
  onSaveShift: (savedShift: JournalDay) => void;
  onDeleteShift?: (shiftId: string) => void;
}

export const ShiftModal: React.FC<ShiftModalProps> = ({
  shift,
  defaultCountry = 'PL',
  onClose,
  onSaveShift,
  onDeleteShift,
}) => {
  const isEditing = !!shift;

  // Initial State derived from existing shift or new shift defaults
  const [startCountry, setStartCountry] = useState(
    shift?.startCountry || defaultCountry || 'PL'
  );
  const [endCountry, setEndCountry] = useState(
    shift?.endCountry || (isEditing ? 'PL' : '—')
  );

  const [startDay, setStartDay] = useState<number>(shift?.day ?? 22);
  const [startTime, setStartTime] = useState<string>(
    shift?.startTime ?? (isEditing ? '06:30' : '07:00')
  );

  const [endDay, setEndDay] = useState<number>(shift?.day ?? 22);
  const [endTime, setEndTime] = useState<string>(
    shift?.endTime ?? (isEditing ? '19:10' : '18:00')
  );

  const [dailyDrive, setDailyDrive] = useState<string>(
    shift?.drive ?? (isEditing ? '8:55' : '7:30')
  );
  const [continuousDrive, setContinuousDrive] = useState<string>(
    shift?.continuousDrive ?? '2:05'
  );

  const [restType, setRestType] = useState<'none' | 'daily' | 'weekly'>(
    shift?.restType ?? 'daily'
  );
  const [splitRest, setSplitRest] = useState<boolean>(shift?.splitRest ?? false);
  const [restDuration, setRestDuration] = useState<string>(
    shift?.rest ?? (isEditing ? '11:39' : '11:00')
  );
  const [notes, setNotes] = useState<string>(shift?.notes ?? '');

  // Sub-modals
  const [countryPickerTarget, setCountryPickerTarget] = useState<
    'start' | 'end' | null
  >(null);
  const [showDateTimeModal, setShowDateTimeModal] = useState<
    'start' | 'end' | null
  >(null);
  const [timeEditTarget, setTimeEditTarget] = useState<
    'daily' | 'continuous' | null
  >(null);

  // Compute shift duration between startTime and endTime
  const shiftDuration = useMemo(() => {
    try {
      const [sh, sm] = startTime.split(':').map((n) => parseInt(n, 10));
      const [eh, em] = endTime.split(':').map((n) => parseInt(n, 10));
      let startTotal = sh * 60 + sm;
      let endTotal = eh * 60 + em;
      if (endDay > startDay) {
        endTotal += (endDay - startDay) * 24 * 60;
      } else if (endTotal < startTotal) {
        endTotal += 24 * 60;
      }
      const diff = Math.max(0, endTotal - startTotal);
      const h = Math.floor(diff / 60);
      const m = diff % 60;
      return `${h}:${m.toString().padStart(2, '0')}`;
    } catch {
      return shift?.shift || '12:40';
    }
  }, [startTime, endTime, startDay, endDay, shift]);

  // Compute Day of Week label for startDay
  const dowLabel = useMemo(() => {
    const dows = ['вс', 'пн', 'вт', 'ср', 'чт', 'пт', 'сб'];
    // September 2026: 1st is Tuesday
    const dowIdx = (1 + (startDay - 1)) % 7;
    return dows[dowIdx] || 'вт';
  }, [startDay]);

  const subtitleLabel = useMemo(() => {
    const fullDows = [
      'Воскресенье',
      'Понедельник',
      'Вторник',
      'Среда',
      'Четверг',
      'Пятница',
      'Суббота',
    ];
    const dowIdx = (1 + (startDay - 1)) % 7;
    return `${fullDows[dowIdx]}, ${startDay} сентября`;
  }, [startDay]);

  const handleSave = () => {
    const saved: JournalDay = {
      id: shift?.id || `shift-${Date.now()}`,
      dow: dowLabel,
      day: startDay,
      place: `${startCountry} → ${endCountry === '—' ? startCountry : endCountry}`,
      timeRange: `${startTime} — ${endTime}`,
      drive: dailyDrive,
      continuousDrive,
      shift: shiftDuration,
      rest: restDuration,
      startCountry,
      endCountry,
      startDate: `${dowLabel}, ${startDay.toString().padStart(2, '0')}.09`,
      startTime,
      endDate: `${dowLabel}, ${endDay.toString().padStart(2, '0')}.09`,
      endTime,
      restType,
      splitRest,
      restStatus:
        restType === 'daily'
          ? parseInt(restDuration.split(':')[0] || '11', 10) >= 11
            ? 'полный'
            : 'сокращённый'
          : undefined,
      notes,
      driveFg: '#EDEBE6',
      driveBg: '#262A2F',
      shiftFg: '#EDEBE6',
      shiftBg: '#262A2F',
      restFg: restType !== 'none' ? '#4FBF9F' : '#A3A8AE',
      restBg: restType !== 'none' ? '#16261F' : '#262A2F',
    };

    onSaveShift(saved);
    onClose();
  };

  return (
    <div className="absolute inset-0 bg-[#111315] text-[#EDEBE6] flex flex-col z-50 overflow-y-auto">
      
      {/* Top Header */}
      <header className="sticky top-0 h-16 px-2 bg-[#111315]/95 backdrop-blur-md flex items-center justify-between border-b border-[#262A2F] z-20">
        <button
          type="button"
          onClick={onClose}
          aria-label="Назад"
          className="w-12 h-12 rounded-full flex items-center justify-center text-[#EDEBE6] hover:bg-[#262A2F] transition-colors"
        >
          <ArrowLeft className="w-6 h-6" />
        </button>

        <div className="flex-1 flex flex-col items-center">
          <h1 className="text-[18px] font-bold">
            {isEditing ? 'Смена' : 'Новая смена'}
          </h1>
          <span className="text-[12px] text-[#A3A8AE]">{subtitleLabel}</span>
        </div>

        <button
          type="button"
          onClick={handleSave}
          aria-label="Сохранить"
          className="w-12 h-12 rounded-full flex items-center justify-center text-[#F3B33D] hover:bg-[#262A2F] transition-colors active:scale-95"
        >
          <Check className="w-6 h-6 stroke-[2.5]" />
        </button>
      </header>

      {/* Main Content Body */}
      <div className="flex-1 flex flex-col gap-5 py-4 pb-20">
        
        {/* Section 1: СМЕНА (Start & End Columns) */}
        <div>
          <h2 className="mx-6 mb-2 text-[13px] font-semibold tracking-wider uppercase text-[#A3A8AE]">
            Смена
          </h2>

          <div className="mx-4 bg-[#1A1D20] rounded-[24px] overflow-hidden border border-[#262A2F]/40 shadow-sm">
            <div className="grid grid-cols-2 divide-x divide-[#262A2F]">
              
              {/* Start Column */}
              <div className="p-4 flex flex-col gap-2.5">
                <span className="text-[13px] text-[#A3A8AE]">Начало</span>
                
                {/* Country Badge */}
                <button
                  type="button"
                  onClick={() => setCountryPickerTarget('start')}
                  className="self-start h-10 px-3.5 rounded-full border border-[#3A3F45] bg-[#111315] hover:border-[#F3B33D] flex items-center gap-1.5 font-mono-num text-[14px] font-bold text-[#EDEBE6] transition-colors"
                >
                  <span>{startCountry}</span>
                  <ChevronDown className="w-4 h-4 text-[#A3A8AE]" />
                </button>

                {/* Date & Time Selectors */}
                <div className="flex flex-col gap-1.5 mt-1">
                  <button
                    type="button"
                    onClick={() => setShowDateTimeModal('start')}
                    className="h-11 px-3 rounded-[12px] bg-[#111315] hover:bg-[#262A2F] flex items-center gap-2 text-[#EDEBE6] transition-colors"
                  >
                    <Calendar className="w-4 h-4 text-[#A3A8AE] shrink-0" />
                    <span className="text-[14px] font-semibold">
                      {dowLabel}, {startDay.toString().padStart(2, '0')}.09
                    </span>
                  </button>

                  <button
                    type="button"
                    onClick={() => setShowDateTimeModal('start')}
                    className="h-11 px-3 rounded-[12px] bg-[#111315] hover:bg-[#262A2F] flex items-center gap-2 text-[#EDEBE6] transition-colors"
                  >
                    <Clock className="w-4 h-4 text-[#A3A8AE] shrink-0" />
                    <span className="font-mono-num text-[16px] font-bold">
                      {startTime}
                    </span>
                  </button>
                </div>
              </div>

              {/* End Column */}
              <div className="p-4 flex flex-col gap-2.5">
                <span className="text-[13px] text-[#A3A8AE]">Конец</span>

                {/* Country Badge */}
                <button
                  type="button"
                  onClick={() => setCountryPickerTarget('end')}
                  className="self-start h-10 px-3.5 rounded-full border border-[#3A3F45] bg-[#111315] hover:border-[#F3B33D] flex items-center gap-1.5 font-mono-num text-[14px] font-bold text-[#EDEBE6] transition-colors"
                >
                  <span>{endCountry}</span>
                  <ChevronDown className="w-4 h-4 text-[#A3A8AE]" />
                </button>

                {/* Date & Time Selectors */}
                <div className="flex flex-col gap-1.5 mt-1">
                  <button
                    type="button"
                    onClick={() => setShowDateTimeModal('end')}
                    className="h-11 px-3 rounded-[12px] bg-[#111315] hover:bg-[#262A2F] flex items-center gap-2 text-[#EDEBE6] transition-colors"
                  >
                    <Calendar className="w-4 h-4 text-[#A3A8AE] shrink-0" />
                    <span className="text-[14px] font-semibold">
                      {dowLabel}, {endDay.toString().padStart(2, '0')}.09
                    </span>
                  </button>

                  <button
                    type="button"
                    onClick={() => setShowDateTimeModal('end')}
                    className="h-11 px-3 rounded-[12px] bg-[#111315] hover:bg-[#262A2F] flex items-center gap-2 text-[#EDEBE6] transition-colors"
                  >
                    <Clock className="w-4 h-4 text-[#A3A8AE] shrink-0" />
                    <span className="font-mono-num text-[16px] font-bold">
                      {endTime}
                    </span>
                  </button>
                </div>
              </div>

            </div>

            {/* Shift Duration Row */}
            <div className="min-h-13 px-4 border-t border-[#262A2F] flex items-center justify-between">
              <span className="text-[15px] font-semibold">Длительность смены</span>
              <span className="font-mono-num text-[17px] font-bold text-[#A3A8AE]">
                {shiftDuration}
              </span>
            </div>
          </div>
        </div>

        {/* Section 2: ВОЖДЕНИЕ (Driving Breakdown) */}
        <div>
          <h2 className="mx-6 mb-2 text-[13px] font-semibold tracking-wider uppercase text-[#A3A8AE]">
            Вождение
          </h2>

          <div className="mx-4 bg-[#1A1D20] rounded-[24px] overflow-hidden divide-y divide-[#262A2F] border border-[#262A2F]/40 shadow-sm">
            
            {/* Daily Drive */}
            <button
              type="button"
              onClick={() => setTimeEditTarget('daily')}
              className="w-full min-h-14 px-4 flex items-center justify-between text-left hover:bg-[#262A2F]/40 transition-colors"
            >
              <span className="text-[15px] font-semibold">За день</span>
              <div className="flex items-center gap-2">
                <span className="font-mono-num text-[17px] font-bold text-[#EDEBE6]">
                  {dailyDrive}
                </span>
                <ChevronRight className="w-4 h-4 text-[#A3A8AE]" />
              </div>
            </button>

            {/* Continuous Drive */}
            <button
              type="button"
              onClick={() => setTimeEditTarget('continuous')}
              className="w-full min-h-14 px-4 flex items-center justify-between text-left hover:bg-[#262A2F]/40 transition-colors"
            >
              <span className="text-[15px] font-semibold">
                Непрерывное на конец смены
              </span>
              <div className="flex items-center gap-2">
                <span className="font-mono-num text-[17px] font-bold text-[#EDEBE6]">
                  {continuousDrive}
                </span>
                <ChevronRight className="w-4 h-4 text-[#A3A8AE]" />
              </div>
            </button>

          </div>
        </div>

        {/* Section 3: ОТДЫХ ПОСЛЕ СМЕНЫ */}
        <div>
          <h2 className="mx-6 mb-2 text-[13px] font-semibold tracking-wider uppercase text-[#A3A8AE]">
            Отдых после смены
          </h2>

          <div className="mx-4 bg-[#1A1D20] rounded-[24px] overflow-hidden border border-[#262A2F]/40 shadow-sm">
            
            {/* Rest Type Segmented Control */}
            <div className="p-4">
              <div className="grid grid-cols-3 gap-1 p-1 rounded-[16px] bg-[#111315]">
                {(['none', 'daily', 'weekly'] as const).map((r) => {
                  const labels = {
                    none: 'Не начат',
                    daily: 'Суточный',
                    weekly: 'Недельный',
                  };
                  const isPicked = restType === r;
                  return (
                    <button
                      key={r}
                      type="button"
                      onClick={() => setRestType(r)}
                      className={`h-10 rounded-[12px] text-[14px] font-semibold transition-all ${
                        isPicked
                          ? 'bg-[#2F343A] text-[#EDEBE6]'
                          : 'text-[#A3A8AE] hover:text-[#EDEBE6]'
                      }`}
                    >
                      {labels[r]}
                    </button>
                  );
                })}
              </div>
            </div>

            {/* Split Rest Switch */}
            {restType !== 'none' && (
              <div className="p-4 border-t border-[#262A2F] flex items-center justify-between">
                <div className="flex flex-col gap-0.5">
                  <span className="text-[15px] font-semibold">
                    Раздельный отдых 3 + 9
                  </span>
                  <span className="text-[13px] text-[#A3A8AE]">
                    Сначала 3 ч, затем 9 ч
                  </span>
                </div>
                <button
                  type="button"
                  role="switch"
                  onClick={() => setSplitRest(!splitRest)}
                  className={`w-[52px] h-[32px] p-1 rounded-full transition-colors flex shrink-0 ${
                    splitRest
                      ? 'bg-[#F3B33D] justify-end'
                      : 'bg-[#3A3F45] justify-start'
                  }`}
                >
                  <span
                    className={`w-6 h-6 rounded-full ${
                      splitRest ? 'bg-[#111315]' : 'bg-[#A3A8AE]'
                    }`}
                  />
                </button>
              </div>
            )}

            {/* Rest Duration Row */}
            {restType !== 'none' && (
              <div className="min-h-14 px-4 border-t border-[#262A2F] flex items-center justify-between">
                <span className="text-[15px] font-semibold">Длительность</span>
                <div className="flex items-center gap-2.5">
                  <span className="font-mono-num text-[17px] font-bold text-[#EDEBE6]">
                    {restDuration}
                  </span>
                  <span className="text-[12px] font-bold px-2 py-0.5 rounded-[8px] bg-[#16261F] text-[#9FE3CE]">
                    полный
                  </span>
                </div>
              </div>
            )}

          </div>
        </div>

        {/* Section 4: ЗАМЕТКИ */}
        <div>
          <h2 className="mx-6 mb-2 text-[13px] font-semibold tracking-wider uppercase text-[#A3A8AE]">
            Заметки
          </h2>

          <div className="mx-4">
            <textarea
              value={notes}
              onChange={(e) => setNotes(e.target.value)}
              placeholder="Например: паром, ожидание загрузки"
              rows={3}
              className="w-full p-4 rounded-[20px] bg-[#1A1D20] text-[#EDEBE6] placeholder-[#6B7178] border border-[#262A2F]/40 outline-none focus:border-[#F3B33D] text-[15px] leading-relaxed resize-none shadow-sm transition-colors"
            />
          </div>
        </div>

        {/* Delete Shift Button (if editing existing shift) */}
        {isEditing && (
          <div className="mx-4 mt-2">
            <button
              type="button"
              onClick={() => {
                if (
                  window.confirm('Вы действительно хотите удалить эту смену из журнала?')
                ) {
                  if (onDeleteShift && shift?.id) {
                    onDeleteShift(shift.id);
                  }
                  onClose();
                }
              }}
              className="w-full h-14 rounded-[18px] border border-[#5A2A27] bg-transparent text-[#FF8F87] hover:bg-[#5A2A27]/20 flex items-center justify-center gap-2.5 text-[15px] font-semibold transition-colors"
            >
              <Trash2 className="w-5 h-5" />
              <span>Удалить смену</span>
            </button>
          </div>
        )}

      </div>

      {/* Sub-modals */}

      {/* Country Picker Submodal */}
      {countryPickerTarget && (
        <CountryPickerModal
          startCountry={startCountry}
          endCountry={endCountry}
          onSelectCountry={(type, code) => {
            if (countryPickerTarget === 'start') {
              setStartCountry(code);
            } else {
              setEndCountry(code);
            }
            setCountryPickerTarget(null);
          }}
          onClose={() => setCountryPickerTarget(null)}
        />
      )}

      {/* Date & Time Submodal */}
      {showDateTimeModal && (
        <ShiftDateTimeModal
          initialTab={showDateTimeModal}
          startDay={startDay}
          startTime={startTime}
          endDay={endDay}
          endTime={endTime}
          onClose={() => setShowDateTimeModal(null)}
          onSave={({ startDay: sD, startTime: sT, endDay: eD, endTime: eT }) => {
            setStartDay(sD);
            setStartTime(sT);
            setEndDay(eD);
            setEndTime(eT);
          }}
        />
      )}

      {/* Time Edit Submodal for Driving */}
      {timeEditTarget && (
        <TimeEditModal
          initialMinutes={
            timeEditTarget === 'daily'
              ? parseInt(dailyDrive.split(':')[0] || '8', 10) * 60 +
                parseInt(dailyDrive.split(':')[1] || '55', 10)
              : parseInt(continuousDrive.split(':')[0] || '2', 10) * 60 +
                parseInt(continuousDrive.split(':')[1] || '05', 10)
          }
          onClose={() => setTimeEditTarget(null)}
          onSave={(totalMins) => {
            const h = Math.floor(totalMins / 60);
            const m = totalMins % 60;
            const str = `${h}:${m.toString().padStart(2, '0')}`;
            if (timeEditTarget === 'daily') {
              setDailyDrive(str);
            } else {
              setContinuousDrive(str);
            }
            setTimeEditTarget(null);
          }}
        />
      )}

    </div>
  );
};
