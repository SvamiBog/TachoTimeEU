import React from 'react';
import {
  Compass,
  Hammer,
  Clock,
  Bed,
  AlertTriangle,
  CheckCircle2,
  Ship,
  Sparkles,
  Info
} from 'lucide-react';
import { ActivityType, ComplianceMetrics, DriverSettings } from '../types/tacho';
import { translations } from '../utils/translations';
import { formatMinutesToHM, formatSecondsToHMS } from '../utils/compliance';
import { playKeypressTone, playWarningChime, playViolationAlarm } from '../utils/audio';

interface TachoHUDProps {
  currentActivity: ActivityType;
  metrics: ComplianceMetrics;
  settings: DriverSettings;
  onChangeActivity: (newActivity: ActivityType) => void;
  onUpdateSettings: (settings: DriverSettings) => void;
}

export const TachoHUD: React.FC<TachoHUDProps> = ({
  currentActivity,
  metrics,
  settings,
  onChangeActivity,
  onUpdateSettings,
}) => {
  const t = translations[settings.language] || translations.en;

  const handleSelectActivity = (activity: ActivityType) => {
    if (activity === currentActivity) return;
    if (settings.soundEnabled) playKeypressTone();
    onChangeActivity(activity);
  };

  const handleToggle10hExtension = () => {
    if (settings.used10hExtensionsThisWeek >= 2 && !settings.isExtendedDriveAllowedToday) {
      alert(
        settings.language === 'de'
          ? 'Maximale Anzahl von 2 Verlängerungen auf 10h in dieser Woche bereits erreicht!'
          : 'Maximum 2 extensions to 10h weekly limit reached under EC 561/2006 Art. 6(1)!'
      );
      return;
    }
    const nextVal = !settings.isExtendedDriveAllowedToday;
    const newUsed = nextVal 
      ? Math.min(2, settings.used10hExtensionsThisWeek + 1)
      : Math.max(0, settings.used10hExtensionsThisWeek - 1);

    onUpdateSettings({
      ...settings,
      isExtendedDriveAllowedToday: nextVal,
      used10hExtensionsThisWeek: newUsed,
    });
    if (settings.soundEnabled) playKeypressTone();
  };

  const handleToggleFerry = () => {
    const nextFerry = !settings.ferryModeActive;
    onUpdateSettings({
      ...settings,
      ferryModeActive: nextFerry,
    });
    if (settings.soundEnabled) playKeypressTone();
  };

  // Activity UI definition with official tachograph symbols
  const activityButtons: {
    type: ActivityType;
    label: string;
    icon: React.ReactNode;
    colorClasses: string;
    activeClasses: string;
    symbolCode: string;
  }[] = [
    {
      type: 'DRIVE',
      label: t.drive,
      icon: <Compass className="w-6 h-6" />,
      symbolCode: '⛟ ◯', // steering wheel symbol
      colorClasses: 'border-emerald-600/40 text-emerald-400 hover:bg-emerald-950/40',
      activeClasses: 'bg-emerald-600 text-white shadow-lg shadow-emerald-900/50 border-emerald-400 ring-2 ring-emerald-400/30',
    },
    {
      type: 'WORK',
      label: t.work,
      icon: <Hammer className="w-6 h-6" />,
      symbolCode: '⚒', // crossed hammers
      colorClasses: 'border-amber-600/40 text-amber-400 hover:bg-amber-950/40',
      activeClasses: 'bg-amber-600 text-white shadow-lg shadow-amber-900/50 border-amber-400 ring-2 ring-amber-400/30',
    },
    {
      type: 'POA',
      label: t.poa,
      icon: <Clock className="w-6 h-6" />,
      symbolCode: '⊠', // availability box
      colorClasses: 'border-sky-600/40 text-sky-400 hover:bg-sky-950/40',
      activeClasses: 'bg-sky-600 text-white shadow-lg shadow-sky-900/50 border-sky-400 ring-2 ring-sky-400/30',
    },
    {
      type: 'REST',
      label: t.rest,
      icon: <Bed className="w-6 h-6" />,
      symbolCode: '🛏', // bed
      colorClasses: 'border-indigo-600/40 text-indigo-400 hover:bg-indigo-950/40',
      activeClasses: 'bg-indigo-600 text-white shadow-lg shadow-indigo-900/50 border-indigo-400 ring-2 ring-indigo-400/30',
    },
  ];

  // Continuous drive progress (0 to 100%)
  const continuousDrivePercent = Math.min(100, Math.round((metrics.continuousDriveMinutes / 270) * 100));
  const dailyDrivePercent = Math.min(100, Math.round((metrics.dailyDriveMinutes / metrics.dailyDriveLimitMinutes) * 100));

  // Determine countdown styling
  const isContinuousWarning = metrics.driveMinutesUntilBreak <= 30 && metrics.driveMinutesUntilBreak > 0;
  const isContinuousUrgent = metrics.driveMinutesUntilBreak <= 15 && metrics.driveMinutesUntilBreak > 0;
  const isContinuousViolated = metrics.continuousDriveMinutes > 270;

  return (
    <div className="bg-slate-900 border border-slate-800 rounded-2xl p-4 sm:p-6 shadow-xl relative overflow-hidden">
      
      {/* Top Tachograph Brand Plate */}
      <div className="flex flex-wrap items-center justify-between pb-4 border-b border-slate-800/80 gap-2">
        <div className="flex items-center gap-2">
          <span className="inline-block w-2.5 h-2.5 rounded-full bg-emerald-500 animate-pulse"></span>
          <span className="font-mono-tacho text-xs tracking-wider text-slate-400 font-semibold uppercase">
            SMART TACHO V2 • GEN2 TYPE-APPROVED
          </span>
        </div>

        <div className="flex items-center gap-3">
          {/* Ferry mode status */}
          <button
            onClick={handleToggleFerry}
            className={`flex items-center gap-1.5 px-2.5 py-1 rounded text-xs font-mono-tacho font-medium border transition-colors ${
              settings.ferryModeActive
                ? 'bg-blue-950 border-blue-500 text-blue-300'
                : 'bg-slate-800/60 border-slate-700 text-slate-400 hover:bg-slate-800'
            }`}
            title="Regulation EC 561/2006 Art. 9: Ferry / Train interruption (up to 2 interruptions of max 1h total)"
          >
            <Ship className="w-3.5 h-3.5 text-blue-400" />
            <span>{t.ferryMode}</span>
            {settings.ferryModeActive && <span className="w-1.5 h-1.5 rounded-full bg-blue-400 animate-ping"></span>}
          </button>

          {/* 10h Extension Toggle */}
          <button
            onClick={handleToggle10hExtension}
            className={`flex items-center gap-1.5 px-2.5 py-1 rounded text-xs font-mono-tacho font-medium border transition-colors ${
              settings.isExtendedDriveAllowedToday
                ? 'bg-amber-950 border-amber-500 text-amber-300'
                : 'bg-slate-800/60 border-slate-700 text-slate-400 hover:bg-slate-800'
            }`}
            title="Extend daily drive from 9h to 10h (allowed max 2 times per week)"
          >
            <Sparkles className="w-3.5 h-3.5 text-amber-400" />
            <span>10h EXT: {settings.isExtendedDriveAllowedToday ? 'ON' : 'OFF'}</span>
            <span className="text-[10px] opacity-75">({settings.used10hExtensionsThisWeek}/2 used)</span>
          </button>
        </div>
      </div>

      {/* Main Tachograph Activity Switcher */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-3 my-5">
        {activityButtons.map((btn) => {
          const isActive = currentActivity === btn.type;
          return (
            <button
              key={btn.type}
              onClick={() => handleSelectActivity(btn.type)}
              className={`flex flex-col items-center justify-center p-3.5 sm:p-4 rounded-xl border transition-all duration-200 cursor-pointer select-none ${
                isActive
                  ? btn.activeClasses
                  : `bg-slate-950/60 ${btn.colorClasses}`
              }`}
            >
              <div className="flex items-center gap-2 mb-1.5">
                <span className="text-xl font-bold font-mono-tacho">{btn.symbolCode}</span>
                {btn.icon}
              </div>
              <span className="font-extrabold text-sm sm:text-base tracking-wider">
                {btn.label}
              </span>
              {isActive && (
                <span className="mt-1 text-[11px] font-mono-tacho tracking-widest uppercase bg-white/20 px-2 py-0.5 rounded-full font-bold">
                  ACTIVE
                </span>
              )}
            </button>
          );
        })}
      </div>

      {/* Center LCD Console: Big Stopwatch & Timers */}
      <div className="tacho-lcd rounded-xl border border-slate-700/80 p-4 sm:p-6 mb-5">
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6 items-center">
          
          {/* Col 1: Active Mode Stopwatch */}
          <div className="text-center lg:text-left border-b lg:border-b-0 lg:border-r border-slate-800 pb-4 lg:pb-0 lg:pr-6">
            <div className="text-xs font-semibold text-slate-400 uppercase tracking-widest mb-1 flex items-center justify-center lg:justify-start gap-1.5">
              <span>{t.activeActivity}</span>
              <span className="w-2 h-2 rounded-full bg-emerald-400 animate-ping"></span>
            </div>
            <div className="font-mono-tacho text-4xl sm:text-5xl font-black text-white tracking-wider">
              {formatSecondsToHMS(metrics.currentActivityDurationSeconds)}
            </div>
            <div className="mt-2 text-xs font-mono-tacho text-slate-400">
              {currentActivity === 'REST' ? (
                <span className="text-indigo-300">
                  {metrics.hasSplit15 ? t.splitBreak15Done : `${formatMinutesToHM(metrics.currentRestMinutes)} / 45m`}
                </span>
              ) : (
                <span>Continuous Drive: <strong className="text-emerald-400">{formatMinutesToHM(metrics.continuousDriveMinutes)}</strong> / 4h 30m</span>
              )}
            </div>
          </div>

          {/* Col 2: Continuous Drive & Break Requirement Countdown */}
          <div className="text-center lg:text-left border-b lg:border-b-0 lg:border-r border-slate-800 pb-4 lg:pb-0 lg:pr-6">
            <div className="flex items-center justify-between mb-1">
              <span className="text-xs font-semibold text-slate-400 uppercase tracking-wider">
                {t.nextBreakDueIn}
              </span>
              {isContinuousViolated ? (
                <span className="text-xs font-bold text-red-400 animate-pulse flex items-center gap-1 font-mono-tacho">
                  <AlertTriangle className="w-3.5 h-3.5" /> OVERDUE!
                </span>
              ) : isContinuousUrgent ? (
                <span className="text-xs font-bold text-amber-400 animate-pulse font-mono-tacho">
                  WARNING
                </span>
              ) : (
                <span className="text-xs text-slate-500 font-mono-tacho">Max 4h 30m</span>
              )}
            </div>

            <div className={`font-mono-tacho text-3xl sm:text-4xl font-extrabold tracking-wider ${
              isContinuousViolated
                ? 'text-red-500'
                : isContinuousUrgent
                ? 'text-amber-400'
                : isContinuousWarning
                ? 'text-yellow-400'
                : 'text-emerald-400'
            }`}>
              {isContinuousViolated 
                ? `-${formatMinutesToHM(metrics.continuousDriveMinutes - 270)}` 
                : formatMinutesToHM(metrics.driveMinutesUntilBreak)}
            </div>

            {/* Continuous Drive Bar Gauge */}
            <div className="w-full bg-slate-950 rounded-full h-3 mt-3 overflow-hidden border border-slate-800">
              <div
                className={`h-full transition-all duration-300 rounded-full ${
                  isContinuousViolated
                    ? 'bg-red-500'
                    : isContinuousUrgent
                    ? 'bg-amber-500'
                    : isContinuousWarning
                    ? 'bg-yellow-500'
                    : 'bg-emerald-500'
                }`}
                style={{ width: `${Math.min(100, continuousDrivePercent)}%` }}
              ></div>
            </div>

            {/* Split Break status badge */}
            <div className="mt-2 flex items-center justify-between text-[11px] font-mono-tacho">
              <span className="text-slate-400">Split Break:</span>
              <span className={metrics.hasSplit15 ? 'text-emerald-400 font-bold' : 'text-slate-500'}>
                {metrics.hasSplit15 ? '✓ 15m Done (30m Required Next)' : '45m or 15m+30m'}
              </span>
            </div>
          </div>

          {/* Col 3: Daily Driving Limit Gauge */}
          <div className="text-center lg:text-left">
            <div className="flex items-center justify-between mb-1">
              <span className="text-xs font-semibold text-slate-400 uppercase tracking-wider">
                {t.dailyDrive}
              </span>
              <span className="text-xs text-slate-400 font-mono-tacho">
                Limit: {formatMinutesToHM(metrics.dailyDriveLimitMinutes)}
              </span>
            </div>

            <div className={`font-mono-tacho text-3xl sm:text-4xl font-extrabold tracking-wider ${
              metrics.dailyDriveMinutes > metrics.dailyDriveLimitMinutes
                ? 'text-red-500'
                : metrics.dailyDriveRemainingMinutes <= 30
                ? 'text-amber-400'
                : 'text-sky-400'
            }`}>
              {formatMinutesToHM(metrics.dailyDriveMinutes)}
            </div>

            {/* Daily Driving Progress Bar */}
            <div className="w-full bg-slate-950 rounded-full h-3 mt-3 overflow-hidden border border-slate-800">
              <div
                className={`h-full transition-all duration-300 rounded-full ${
                  metrics.dailyDriveMinutes > metrics.dailyDriveLimitMinutes
                    ? 'bg-red-500'
                    : metrics.dailyDriveRemainingMinutes <= 30
                    ? 'bg-amber-500'
                    : 'bg-sky-500'
                }`}
                style={{ width: `${Math.min(100, dailyDrivePercent)}%` }}
              ></div>
            </div>

            <div className="mt-2 flex items-center justify-between text-[11px] font-mono-tacho">
              <span className="text-slate-400">{t.timeRemaining}:</span>
              <span className="text-sky-300 font-bold">
                {formatMinutesToHM(metrics.dailyDriveRemainingMinutes)}
              </span>
            </div>
          </div>

        </div>
      </div>

      {/* Secondary Metrics Bar: Shift Duty, 24h Rest Deadline, Weekly & Fortnightly */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
        
        {/* Metric 1: Current Shift / Duty Span */}
        <div className="bg-slate-950/70 border border-slate-800/80 rounded-xl p-3">
          <div className="text-[11px] text-slate-400 uppercase tracking-wider mb-1 font-semibold">
            {t.shiftDuration}
          </div>
          <div className="font-mono-tacho text-lg font-bold text-white">
            {formatMinutesToHM(metrics.shiftDurationMinutes)}
          </div>
          <div className="text-[10px] text-slate-500 mt-1 font-mono-tacho">
            Max: {formatMinutesToHM(metrics.maxShiftDurationMinutes)}
          </div>
        </div>

        {/* Metric 2: Daily Rest Window Deadline */}
        <div className="bg-slate-950/70 border border-slate-800/80 rounded-xl p-3">
          <div className="text-[11px] text-slate-400 uppercase tracking-wider mb-1 font-semibold">
            {t.restDueBy}
          </div>
          <div className="font-mono-tacho text-lg font-bold text-amber-300">
            {metrics.dailyRestDeadline ? (
              new Date(metrics.dailyRestDeadline).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
            ) : (
              '--:--'
            )}
          </div>
          <div className="text-[10px] text-slate-500 mt-1 font-mono-tacho">
            {settings.crewMode === 'TEAM' ? '30h Crew Window' : '24h Solo Window'}
          </div>
        </div>

        {/* Metric 3: Weekly Driving (56h limit) */}
        <div className="bg-slate-950/70 border border-slate-800/80 rounded-xl p-3">
          <div className="text-[11px] text-slate-400 uppercase tracking-wider mb-1 font-semibold">
            {t.weeklyDrive}
          </div>
          <div className="font-mono-tacho text-lg font-bold text-white">
            {formatMinutesToHM(metrics.weeklyDriveMinutes)}
          </div>
          <div className="text-[10px] text-emerald-400 mt-1 font-mono-tacho">
            {formatMinutesToHM(metrics.weeklyDriveRemainingMinutes)} left / 56h
          </div>
        </div>

        {/* Metric 4: Fortnightly Driving (90h limit) */}
        <div className="bg-slate-950/70 border border-slate-800/80 rounded-xl p-3">
          <div className="text-[11px] text-slate-400 uppercase tracking-wider mb-1 font-semibold">
            {t.fortnightlyDrive}
          </div>
          <div className="font-mono-tacho text-lg font-bold text-white">
            {formatMinutesToHM(metrics.fortnightlyDriveMinutes)}
          </div>
          <div className="text-[10px] text-purple-400 mt-1 font-mono-tacho">
            {formatMinutesToHM(metrics.fortnightlyDriveRemainingMinutes)} left / 90h
          </div>
        </div>

      </div>

    </div>
  );
};
