import React, { useState } from 'react';
import { Plus, Trash2, Play, CheckCircle2, AlertTriangle, ArrowRight, Route, Clock, Calendar } from 'lucide-react';
import { ActivityType, SupportedLanguage } from '../types/tacho';
import { translations } from '../utils/translations';
import { formatMinutesToHM } from '../utils/compliance';

interface PlanLeg {
  id: string;
  activity: ActivityType;
  durationMinutes: number;
  label: string;
}

interface ShiftPlannerProps {
  language: SupportedLanguage;
  onApplyPlan?: (legs: PlanLeg[]) => void;
}

export const ShiftPlanner: React.FC<ShiftPlannerProps> = ({ language, onApplyPlan }) => {
  const t = translations[language] || translations.en;

  const [startTime, setStartTime] = useState<string>('07:00');
  const [legs, setLegs] = useState<PlanLeg[]>([
    { id: 'leg-1', activity: 'WORK', durationMinutes: 30, label: 'Pre-trip check & loading' },
    { id: 'leg-2', activity: 'DRIVE', durationMinutes: 180, label: 'Leg 1: Highway transit (3h)' },
    { id: 'leg-3', activity: 'REST', durationMinutes: 45, label: 'Service station mandatory break' },
    { id: 'leg-4', activity: 'DRIVE', durationMinutes: 150, label: 'Leg 2: Delivery transit (2.5h)' },
    { id: 'leg-5', activity: 'WORK', durationMinutes: 40, label: 'Unloading at warehouse' },
    { id: 'leg-6', activity: 'DRIVE', durationMinutes: 120, label: 'Leg 3: Return to depot (2h)' },
  ]);

  const [newActivity, setNewActivity] = useState<ActivityType>('DRIVE');
  const [newDuration, setNewDuration] = useState<number>(60);
  const [newLabel, setNewLabel] = useState<string>('');

  const handleAddLeg = (e: React.FormEvent) => {
    e.preventDefault();
    if (newDuration <= 0) return;
    const newLeg: PlanLeg = {
      id: `leg-${Date.now()}`,
      activity: newActivity,
      durationMinutes: newDuration,
      label: newLabel.trim() || `${newActivity} (${formatMinutesToHM(newDuration)})`,
    };
    setLegs([...legs, newLeg]);
    setNewLabel('');
  };

  const handleRemoveLeg = (id: string) => {
    setLegs(legs.filter((l) => l.id !== id));
  };

  const handlePresetSelect = (presetType: 'standard9' | 'split10' | 'express') => {
    if (presetType === 'standard9') {
      setLegs([
        { id: 'p1', activity: 'WORK', durationMinutes: 20, label: 'Safety check' },
        { id: 'p2', activity: 'DRIVE', durationMinutes: 270, label: 'Driving Leg 1 (4h 30m max)' },
        { id: 'p3', activity: 'REST', durationMinutes: 45, label: 'Qualifying Break (45m)' },
        { id: 'p4', activity: 'DRIVE', durationMinutes: 270, label: 'Driving Leg 2 (4h 30m)' },
        { id: 'p5', activity: 'WORK', durationMinutes: 25, label: 'Final paperwork & parking' },
      ]);
    } else if (presetType === 'split10') {
      setLegs([
        { id: 's1', activity: 'WORK', durationMinutes: 15, label: 'Walkaround check' },
        { id: 's2', activity: 'DRIVE', durationMinutes: 150, label: 'Drive Leg 1 (2h 30m)' },
        { id: 's3', activity: 'REST', durationMinutes: 15, label: 'Split Break 1 (15m)' },
        { id: 's4', activity: 'DRIVE', durationMinutes: 120, label: 'Drive Leg 2 (2h 00m)' },
        { id: 's5', activity: 'REST', durationMinutes: 30, label: 'Split Break 2 (30m - resets drive)' },
        { id: 's6', activity: 'DRIVE', durationMinutes: 270, label: 'Drive Leg 3 (4h 30m)' },
        { id: 's7', activity: 'DRIVE', durationMinutes: 60, label: '10h Extended drive segment (1h)' },
      ]);
    } else if (presetType === 'express') {
      setLegs([
        { id: 'e1', activity: 'WORK', durationMinutes: 30, label: 'Loading dock' },
        { id: 'e2', activity: 'DRIVE', durationMinutes: 240, label: 'Express transit (4h)' },
        { id: 'e3', activity: 'REST', durationMinutes: 45, label: 'Service area break (45m)' },
        { id: 'e4', activity: 'DRIVE', durationMinutes: 180, label: 'Final delivery run (3h)' },
      ]);
    }
  };

  // Run simulation calculations
  let totalDriveMinutes = 0;
  let totalWorkMinutes = 0;
  let totalPoaMinutes = 0;
  let totalRestMinutes = 0;
  let totalShiftMinutes = 0;

  let currentContinuousDrive = 0;
  let hasSplit15 = false;
  let simulationViolations: string[] = [];

  // Parse start time
  const [startH, startM] = startTime.split(':').map((v) => parseInt(v, 10) || 0);
  let currentMinuteOfDay = startH * 60 + startM;

  const legTimelines = legs.map((leg) => {
    const legStartMin = currentMinuteOfDay;
    const legEndMin = legStartMin + leg.durationMinutes;
    currentMinuteOfDay = legEndMin;
    totalShiftMinutes += leg.durationMinutes;

    if (leg.activity === 'DRIVE') {
      totalDriveMinutes += leg.durationMinutes;
      currentContinuousDrive += leg.durationMinutes;
      if (currentContinuousDrive > 270) {
        simulationViolations.push(
          `Leg "${leg.label}": Continuous driving reached ${formatMinutesToHM(currentContinuousDrive)}, exceeding 4h 30m threshold!`
        );
      }
    } else if (leg.activity === 'WORK') {
      totalWorkMinutes += leg.durationMinutes;
    } else if (leg.activity === 'POA') {
      totalPoaMinutes += leg.durationMinutes;
    } else if (leg.activity === 'REST') {
      totalRestMinutes += leg.durationMinutes;
      if (leg.durationMinutes >= 45) {
        currentContinuousDrive = 0;
        hasSplit15 = false;
      } else if (!hasSplit15 && leg.durationMinutes >= 15) {
        hasSplit15 = true;
      } else if (hasSplit15 && leg.durationMinutes >= 30) {
        currentContinuousDrive = 0;
        hasSplit15 = false;
      }
    }

    const formatClock = (mins: number) => {
      const h = Math.floor(mins / 60) % 24;
      const m = mins % 60;
      return `${h.toString().padStart(2, '0')}:${m.toString().padStart(2, '0')}`;
    };

    return {
      ...leg,
      startTimeStr: formatClock(legStartMin),
      endTimeStr: formatClock(legEndMin),
      continuousAtEnd: currentContinuousDrive,
    };
  });

  if (totalDriveMinutes > 600) {
    simulationViolations.push(
      `Total driving is ${formatMinutesToHM(totalDriveMinutes)}, which exceeds even the 10h extended maximum (600 min)!`
    );
  } else if (totalDriveMinutes > 540) {
    simulationViolations.push(
      `Total driving is ${formatMinutesToHM(totalDriveMinutes)}. This plan requires a 10h driving extension for today.`
    );
  }

  if (totalShiftMinutes > 900) {
    simulationViolations.push(
      `Shift duration is ${formatMinutesToHM(totalShiftMinutes)}, exceeding the maximum 15-hour daily duty window under EC 561/2006!`
    );
  } else if (totalShiftMinutes > 780) {
    simulationViolations.push(
      `Shift duration is ${formatMinutesToHM(totalShiftMinutes)}. This requires taking a reduced 9h daily rest instead of regular 11h.`
    );
  }

  const shiftEndClock = () => {
    const totalEnd = startH * 60 + startM + totalShiftMinutes;
    const h = Math.floor(totalEnd / 60) % 24;
    const m = totalEnd % 60;
    return `${h.toString().padStart(2, '0')}:${m.toString().padStart(2, '0')}`;
  };

  return (
    <div className="bg-slate-900 border border-slate-800 rounded-2xl p-4 sm:p-6 shadow-xl space-y-6">
      
      {/* Title & Presets */}
      <div className="flex flex-wrap items-center justify-between gap-4 border-b border-slate-800 pb-4">
        <div>
          <h2 className="text-lg font-bold text-white flex items-center gap-2">
            <Route className="w-5 h-5 text-blue-400" /> {t.shiftPlanner}
          </h2>
          <p className="text-xs text-slate-400 mt-0.5">
            Test hypothetical routes, loading stops, and break splits to guarantee compliance before starting.
          </p>
        </div>

        {/* Quick Presets */}
        <div className="flex items-center gap-2 flex-wrap">
          <span className="text-xs text-slate-400 font-medium">Quick Templates:</span>
          <button
            onClick={() => handlePresetSelect('standard9')}
            className="px-2.5 py-1 text-xs font-mono-tacho rounded bg-slate-800 hover:bg-slate-700 text-slate-200 border border-slate-700"
          >
            Standard 9h (4.5h + 4.5h)
          </button>
          <button
            onClick={() => handlePresetSelect('split10')}
            className="px-2.5 py-1 text-xs font-mono-tacho rounded bg-slate-800 hover:bg-slate-700 text-amber-300 border border-slate-700"
          >
            Split Break (15+30m) & 10h
          </button>
          <button
            onClick={() => handlePresetSelect('express')}
            className="px-2.5 py-1 text-xs font-mono-tacho rounded bg-slate-800 hover:bg-slate-700 text-slate-200 border border-slate-700"
          >
            Express (7h Drive)
          </button>
        </div>
      </div>

      {/* Configuration & Shift Time */}
      <div className="grid grid-cols-1 sm:grid-cols-4 gap-4 bg-slate-950/70 p-4 rounded-xl border border-slate-800">
        <div>
          <label className="block text-xs font-medium text-slate-400 mb-1">Departure Time</label>
          <input
            type="time"
            value={startTime}
            onChange={(e) => setStartTime(e.target.value)}
            className="w-full bg-slate-900 border border-slate-700 rounded-md px-3 py-1.5 text-sm text-white font-mono-tacho focus:outline-hidden focus:border-blue-500"
          />
        </div>
        <div>
          <label className="block text-xs font-medium text-slate-400 mb-1">Planned Shift End</label>
          <div className="text-base font-bold font-mono-tacho text-emerald-400 py-1.5">
            {shiftEndClock()}
          </div>
        </div>
        <div>
          <label className="block text-xs font-medium text-slate-400 mb-1">Total Driving Time</label>
          <div className={`text-base font-bold font-mono-tacho py-1.5 ${
            totalDriveMinutes > 540 ? 'text-amber-400' : 'text-sky-400'
          }`}>
            {formatMinutesToHM(totalDriveMinutes)}
          </div>
        </div>
        <div>
          <label className="block text-xs font-medium text-slate-400 mb-1">Total Shift Duration</label>
          <div className={`text-base font-bold font-mono-tacho py-1.5 ${
            totalShiftMinutes > 780 ? 'text-amber-400' : 'text-slate-200'
          }`}>
            {formatMinutesToHM(totalShiftMinutes)}
          </div>
        </div>
      </div>

      {/* Simulation Compliance Banner */}
      {simulationViolations.length === 0 ? (
        <div className="bg-emerald-950/50 border border-emerald-800 rounded-xl p-3.5 flex items-center gap-3 text-emerald-300 text-xs">
          <CheckCircle2 className="w-5 h-5 text-emerald-400 shrink-0" />
          <div>
            <strong className="text-white">Legal Shift Itinerary: </strong>
            This planned shift fully satisfies Regulation (EC) No 561/2006. All breaks and drive limits are compliant.
          </div>
        </div>
      ) : (
        <div className="bg-amber-950/50 border border-amber-600 rounded-xl p-3.5 space-y-1.5">
          <div className="flex items-center gap-2 text-amber-300 text-xs font-bold">
            <AlertTriangle className="w-4 h-4 text-amber-400 shrink-0" />
            <span>Itinerary Compliance Warnings Detected ({simulationViolations.length}):</span>
          </div>
          <ul className="text-xs text-amber-200 space-y-1 pl-6 list-disc">
            {simulationViolations.map((v, i) => (
              <li key={i}>{v}</li>
            ))}
          </ul>
        </div>
      )}

      {/* Planned Legs Timeline */}
      <div className="space-y-2">
        <h3 className="text-xs font-bold uppercase tracking-wider text-slate-400">
          Planned Shift Itinerary ({legs.length} segments)
        </h3>

        <div className="space-y-2">
          {legTimelines.map((leg, index) => {
            const getBadge = () => {
              switch (leg.activity) {
                case 'DRIVE':
                  return 'bg-emerald-500/20 text-emerald-300 border-emerald-500/40';
                case 'WORK':
                  return 'bg-amber-500/20 text-amber-300 border-amber-500/40';
                case 'POA':
                  return 'bg-sky-500/20 text-sky-300 border-sky-500/40';
                case 'REST':
                  return 'bg-indigo-500/20 text-indigo-300 border-indigo-500/40';
              }
            };

            return (
              <div
                key={leg.id}
                className="flex items-center justify-between p-3 rounded-xl bg-slate-950/60 border border-slate-800 hover:border-slate-700 transition-colors gap-3"
              >
                <div className="flex items-center gap-3">
                  <span className="text-xs font-mono-tacho text-slate-500 w-5">
                    #{index + 1}
                  </span>
                  <span className={`px-2 py-0.5 rounded text-xs font-mono-tacho font-bold border ${getBadge()}`}>
                    {leg.activity}
                  </span>
                  <div>
                    <div className="text-sm font-semibold text-slate-200">{leg.label}</div>
                    <div className="text-xs text-slate-500 font-mono-tacho">
                      {leg.startTimeStr} → {leg.endTimeStr} ({formatMinutesToHM(leg.durationMinutes)})
                    </div>
                  </div>
                </div>

                <div className="flex items-center gap-3">
                  {leg.activity === 'DRIVE' && (
                    <div className="text-right hidden sm:block">
                      <div className="text-[10px] text-slate-400 font-mono-tacho">Continuous Drive</div>
                      <div className={`text-xs font-mono-tacho font-bold ${
                        leg.continuousAtEnd > 270 ? 'text-red-400' : 'text-slate-300'
                      }`}>
                        {formatMinutesToHM(leg.continuousAtEnd)} / 4h30
                      </div>
                    </div>
                  )}

                  <button
                    onClick={() => handleRemoveLeg(leg.id)}
                    className="p-1.5 text-slate-500 hover:text-red-400 hover:bg-slate-800 rounded transition-colors"
                    title="Remove segment"
                  >
                    <Trash2 className="w-4 h-4" />
                  </button>
                </div>
              </div>
            );
          })}
        </div>
      </div>

      {/* Add New Leg Form */}
      <form onSubmit={handleAddLeg} className="bg-slate-950 p-4 rounded-xl border border-slate-800 space-y-3">
        <h4 className="text-xs font-bold uppercase tracking-wider text-slate-300 flex items-center gap-1.5">
          <Plus className="w-4 h-4 text-blue-400" /> Add Route Segment
        </h4>
        <div className="grid grid-cols-1 sm:grid-cols-4 gap-3">
          <div>
            <label className="block text-[11px] text-slate-400 mb-1">Activity Type</label>
            <select
              value={newActivity}
              onChange={(e) => setNewActivity(e.target.value as ActivityType)}
              className="w-full bg-slate-900 border border-slate-700 rounded-md px-3 py-1.5 text-xs text-white font-mono-tacho"
            >
              <option value="DRIVE">{t.drive} (Drive)</option>
              <option value="WORK">{t.work} (Loading/Work)</option>
              <option value="REST">{t.rest} (Break/Rest)</option>
              <option value="POA">{t.poa} (Availability)</option>
            </select>
          </div>

          <div>
            <label className="block text-[11px] text-slate-400 mb-1">Duration (Minutes)</label>
            <input
              type="number"
              min="5"
              step="5"
              value={newDuration}
              onChange={(e) => setNewDuration(parseInt(e.target.value, 10) || 0)}
              className="w-full bg-slate-900 border border-slate-700 rounded-md px-3 py-1.5 text-xs text-white font-mono-tacho"
              placeholder="e.g. 45"
            />
          </div>

          <div className="sm:col-span-2">
            <label className="block text-[11px] text-slate-400 mb-1">Description / Waypoint</label>
            <div className="flex gap-2">
              <input
                type="text"
                value={newLabel}
                onChange={(e) => setNewLabel(e.target.value)}
                className="flex-1 bg-slate-900 border border-slate-700 rounded-md px-3 py-1.5 text-xs text-white"
                placeholder="e.g. Antwerp Hub -> Aachen Service Rest"
              />
              <button
                type="submit"
                className="px-4 py-1.5 bg-blue-600 hover:bg-blue-500 text-white rounded-md text-xs font-bold flex items-center gap-1 shrink-0"
              >
                <Plus className="w-3.5 h-3.5" /> Add
              </button>
            </div>
          </div>
        </div>
      </form>

    </div>
  );
};
