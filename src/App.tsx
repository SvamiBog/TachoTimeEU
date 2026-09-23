import React, { useState, useEffect, useRef } from 'react';
import {
  ActivityEntry,
  ActivityType,
  DriverSettings,
  JournalDay,
} from './types/tacho';
import {
  loadEntries,
  saveEntries,
  loadSettings,
  saveSettings,
  initialSampleWeeks,
} from './utils/storage';
import { calculateCompliance } from './utils/compliance';
import { playWarningChime, playViolationAlarm } from './utils/audio';

import { CockpitMain } from './components/CockpitMain';
import { JournalView } from './components/JournalView';
import { SettingsView } from './components/SettingsView';
import { MoreView } from './components/MoreView';
import { GuideView } from './components/GuideView';

// Modals
import { CountryPickerModal } from './components/modals/CountryPickerModal';
import { LimitBreakModal } from './components/modals/LimitBreakModal';
import { LimitWorkdayModal } from './components/modals/LimitWorkdayModal';
import { LimitWeeklyRestModal } from './components/modals/LimitWeeklyRestModal';
import { ShiftModal } from './components/modals/ShiftModal';
import { TimeEditModal } from './components/modals/TimeEditModal';
import { ExportModal } from './components/modals/ExportModal';
import { PaywallModal } from './components/modals/PaywallModal';
import { TachoPrintoutModal } from './components/TachoPrintoutModal';

type MainTab = 'main' | 'journal' | 'settings' | 'more' | 'guide';

export const App: React.FC = () => {
  const [settings, setSettings] = useState<DriverSettings>(loadSettings);
  const [entries, setEntries] = useState<ActivityEntry[]>(loadEntries);
  const [weeks, setWeeks] = useState(initialSampleWeeks);
  const [activeTab, setActiveTab] = useState<MainTab>('main');
  const [currentTime, setCurrentTime] = useState<number>(Date.now());

  // Modal states
  const [isCountryPickerOpen, setIsCountryPickerOpen] = useState(false);
  const [countryPickerTarget, setCountryPickerTarget] = useState<'start' | 'end'>('start');
  const [isLimitBreakOpen, setIsLimitBreakOpen] = useState(false);
  const [isLimitWorkdayOpen, setIsLimitWorkdayOpen] = useState(false);
  const [isLimitWeeklyRestOpen, setIsLimitWeeklyRestOpen] = useState(false);
  const [isShiftModalOpen, setIsShiftModalOpen] = useState(false);
  const [editingShift, setEditingShift] = useState<JournalDay | null>(null);
  const [editingWeekId, setEditingWeekId] = useState<string | null>(null);
  const [isTimeEditOpen, setIsTimeEditOpen] = useState(false);
  const [isExportOpen, setIsExportOpen] = useState(false);
  const [isPaywallOpen, setIsPaywallOpen] = useState(false);
  const [isPrintoutOpen, setIsPrintoutOpen] = useState(false);

  // Audio chimes
  const prevViolationCount = useRef<number>(0);
  const prevWarningCount = useRef<number>(0);

  // Sync settings and entries
  useEffect(() => {
    saveSettings(settings);
  }, [settings]);

  useEffect(() => {
    saveEntries(entries);
  }, [entries]);

  // Live timer tick every second
  useEffect(() => {
    const timer = setInterval(() => {
      setCurrentTime(Date.now());
    }, 1000);
    return () => clearInterval(timer);
  }, []);

  // Compute live compliance metrics
  const metrics = calculateCompliance(entries, settings, currentTime);

  // Sound alert trigger
  useEffect(() => {
    if (!settings.soundEnabled) return;
    const violations = metrics.infringements.filter((i) => i.severity === 'violation');
    const warnings = metrics.infringements.filter((i) => i.severity === 'warning');

    if (violations.length > prevViolationCount.current) {
      playViolationAlarm();
    } else if (warnings.length > prevWarningCount.current) {
      playWarningChime();
    }

    prevViolationCount.current = violations.length;
    prevWarningCount.current = warnings.length;
  }, [metrics.infringements, settings.soundEnabled]);

  // Current active mode
  const activeEntry = entries.find((e) => e.endTime === null);
  const currentActivity: ActivityType = activeEntry ? activeEntry.activity : 'DRIVE';

  const handleChangeActivity = (newActivity: ActivityType) => {
    const now = Date.now();
    let updatedEntries = [...entries];

    // Close existing
    updatedEntries = updatedEntries.map((e) => {
      if (e.endTime === null) {
        return { ...e, endTime: now };
      }
      return e;
    });

    // Start new
    const newEntry: ActivityEntry = {
      id: `act-${now}`,
      activity: newActivity,
      startTime: now,
      endTime: null,
      vehiclePlate: settings.vehiclePlate,
      location: settings.startCountry || 'PL',
    };

    updatedEntries.push(newEntry);
    setEntries(updatedEntries);
  };

  const handleUpdateSettings = (newPartial: Partial<DriverSettings>) => {
    setSettings((prev) => ({ ...prev, ...newPartial }));
  };

  const handleSaveShift = (savedShift: JournalDay, targetWeekId: string | null) => {
    setWeeks((prevWeeks) => {
      return prevWeeks.map((week) => {
        const isTarget = targetWeekId ? week.id === targetWeekId : week.id === prevWeeks[0]?.id;
        if (!isTarget) return week;

        const dayExists = week.days.some((d) => d.id === savedShift.id);
        let newDays: JournalDay[];
        if (dayExists) {
          newDays = week.days.map((d) => (d.id === savedShift.id ? savedShift : d));
        } else {
          newDays = [savedShift, ...week.days];
        }

        const totalDriveMins = newDays.reduce((acc, d) => {
          const parts = d.drive.split(':');
          const h = parseInt(parts[0] || '0', 10);
          const m = parseInt(parts[1] || '0', 10);
          return acc + h * 60 + m;
        }, 0);

        return {
          ...week,
          days: newDays,
          driveMinutes: totalDriveMins,
        };
      });
    });

    if (savedShift.startCountry) {
      handleUpdateSettings({
        startCountry: savedShift.startCountry,
        endCountry: savedShift.endCountry,
      });
    }
  };

  const handleDeleteShift = (shiftId: string, targetWeekId: string | null) => {
    setWeeks((prevWeeks) => {
      return prevWeeks.map((week) => {
        const contains = week.days.some((d) => d.id === shiftId);
        if (!contains) return week;

        const newDays = week.days.filter((d) => d.id !== shiftId);
        const totalDriveMins = newDays.reduce((acc, d) => {
          const parts = d.drive.split(':');
          const h = parseInt(parts[0] || '0', 10);
          const m = parseInt(parts[1] || '0', 10);
          return acc + h * 60 + m;
        }, 0);

        return {
          ...week,
          days: newDays,
          driveMinutes: totalDriveMins,
        };
      });
    });
  };

  const handleClearData = () => {
    localStorage.clear();
    setSettings(loadSettings());
    setEntries(loadEntries());
    setWeeks(initialSampleWeeks);
  };

  return (
    <div className="min-h-screen bg-[#070808] flex items-center justify-center font-sans antialiased text-[#EDEBE6]">
      {/* 412dp Mobile Container */}
      <div className="w-full max-w-[412px] h-screen max-h-screen sm:h-[880px] sm:max-h-[920px] bg-[#111315] relative flex flex-col sm:rounded-[36px] sm:border sm:border-[#2A2E33] sm:shadow-2xl overflow-hidden">
        
        {/* Scrollable Page Content Area */}
        <main className="flex-1 overflow-y-auto overflow-x-hidden relative flex flex-col overscroll-contain">
          {activeTab === 'main' && (
            <CockpitMain
              metrics={metrics}
              settings={settings}
              activeActivity={currentActivity}
              onSelectActivity={handleChangeActivity}
              onOpenCountryPicker={() => {
                setCountryPickerTarget('start');
                setIsCountryPickerOpen(true);
              }}
              onOpenLimitBreak={() => setIsLimitBreakOpen(true)}
              onOpenLimitWorkday={() => setIsLimitWorkdayOpen(true)}
              onOpenLimitWeeklyRest={() => setIsLimitWeeklyRestOpen(true)}
              onOpenTimeEdit={() => setIsTimeEditOpen(true)}
              onOpenPaywall={() => setIsPaywallOpen(true)}
            />
          )}

          {activeTab === 'journal' && (
            <JournalView
              weeks={weeks}
              onOpenShiftModal={(day, weekId) => {
                setEditingShift(day || null);
                setEditingWeekId(weekId || weeks[0]?.id || null);
                setIsShiftModalOpen(true);
              }}
              onOpenExportModal={() => setIsExportOpen(true)}
            />
          )}

          {activeTab === 'settings' && (
            <SettingsView
              settings={settings}
              onUpdateSettings={handleUpdateSettings}
              onOpenExportModal={() => setIsExportOpen(true)}
              onOpenPaywall={() => setIsPaywallOpen(true)}
              onClearData={handleClearData}
            />
          )}

          {activeTab === 'more' && (
            <MoreView
              settings={settings}
              onOpenPaywall={() => setIsPaywallOpen(true)}
              onOpenExportModal={() => setIsExportOpen(true)}
              onOpenGuide={() => setActiveTab('guide')}
            />
          )}

          {activeTab === 'guide' && (
            <GuideView onBack={() => setActiveTab('more')} />
          )}
        </main>

        {/* Bottom Navigation Bar (Permanently anchored at the bottom of the screen, separate from page) */}
        {activeTab !== 'guide' && (
          <nav
            aria-label="Основная навигация"
            className="shrink-0 h-20 px-2 pt-2.5 pb-3.5 bg-[#1A1D20] border-t border-[#262A2F] grid grid-cols-4 z-30 select-none shadow-[0_-4px_20px_rgba(0,0,0,0.6)]"
          >
            {/* 1. Главная */}
            <button
              type="button"
              onClick={() => setActiveTab('main')}
              className={`flex flex-col items-center gap-1 text-[12px] font-semibold transition-all ${
                activeTab === 'main' ? 'text-[#EDEBE6] font-bold' : 'text-[#A3A8AE] hover:text-[#EDEBE6]'
              }`}
            >
              <span
                className={`w-[60px] h-8 flex items-center justify-center transition-all ${
                  activeTab === 'main'
                    ? 'rounded-full bg-[#F3B33D] text-[#111315]'
                    : 'text-[#A3A8AE]'
                }`}
              >
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinejoin="round">
                  <path d="M4 11l8-7 8 7v9h-5v-6H9v6H4z" />
                </svg>
              </span>
              Главная
            </button>

            {/* 2. Журнал */}
            <button
              type="button"
              onClick={() => setActiveTab('journal')}
              className={`flex flex-col items-center gap-1 text-[12px] font-semibold transition-all ${
                activeTab === 'journal' ? 'text-[#EDEBE6] font-bold' : 'text-[#A3A8AE] hover:text-[#EDEBE6]'
              }`}
            >
              <span
                className={`w-[60px] h-8 flex items-center justify-center transition-all ${
                  activeTab === 'journal'
                    ? 'rounded-full bg-[#F3B33D] text-[#111315]'
                    : 'text-[#A3A8AE]'
                }`}
              >
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round">
                  <path d="M5 5h14M5 10h14M5 15h14M5 20h9" />
                </svg>
              </span>
              Журнал
            </button>

            {/* 3. Настройки */}
            <button
              type="button"
              onClick={() => setActiveTab('settings')}
              className={`flex flex-col items-center gap-1 text-[12px] font-semibold transition-all ${
                activeTab === 'settings' ? 'text-[#EDEBE6] font-bold' : 'text-[#A3A8AE] hover:text-[#EDEBE6]'
              }`}
            >
              <span
                className={`w-[60px] h-8 flex items-center justify-center transition-all ${
                  activeTab === 'settings'
                    ? 'rounded-full bg-[#F3B33D] text-[#111315]'
                    : 'text-[#A3A8AE]'
                }`}
              >
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round">
                  <path d="M4 7h10M18 7h2M4 17h4M12 17h8" />
                  <circle cx="16" cy="7" r="2" />
                  <circle cx="10" cy="17" r="2" />
                </svg>
              </span>
              Настройки
            </button>

            {/* 4. Ещё */}
            <button
              type="button"
              onClick={() => setActiveTab('more')}
              className={`flex flex-col items-center gap-1 text-[12px] font-semibold transition-all ${
                activeTab === 'more' ? 'text-[#EDEBE6] font-bold' : 'text-[#A3A8AE] hover:text-[#EDEBE6]'
              }`}
            >
              <span
                className={`w-[60px] h-8 flex items-center justify-center transition-all ${
                  activeTab === 'more'
                    ? 'rounded-full bg-[#F3B33D] text-[#111315]'
                    : 'text-[#A3A8AE]'
                }`}
              >
                <svg width="22" height="22" viewBox="0 0 24 24" fill="currentColor">
                  <circle cx="5" cy="12" r="1.8" />
                  <circle cx="12" cy="12" r="1.8" />
                  <circle cx="19" cy="12" r="1.8" />
                </svg>
              </span>
              Ещё
            </button>
          </nav>
        )}

        {/* Modals & Dialogs */}

        {/* Country Picker */}
        {isCountryPickerOpen && (
          <CountryPickerModal
            startCountry={settings.startCountry || 'PL'}
            endCountry={settings.endCountry || 'PL'}
            onSelectCountry={(type: 'start' | 'end', countryCode: string) => {
              if (type === 'start') {
                handleUpdateSettings({ startCountry: countryCode });
              } else {
                handleUpdateSettings({ endCountry: countryCode });
              }
              setIsCountryPickerOpen(false);
            }}
            onClose={() => setIsCountryPickerOpen(false)}
          />
        )}

        {/* Limit Break Modal */}
        {isLimitBreakOpen && (
          <LimitBreakModal
            metrics={metrics}
            onClose={() => setIsLimitBreakOpen(false)}
            onStartBreak={() => handleChangeActivity('REST')}
          />
        )}

        {/* Limit Workday Modal */}
        {isLimitWorkdayOpen && (
          <LimitWorkdayModal
            metrics={metrics}
            settings={settings}
            onClose={() => setIsLimitWorkdayOpen(false)}
            onEndDay={() => handleChangeActivity('REST')}
          />
        )}

        {/* Limit Weekly Rest Modal */}
        {isLimitWeeklyRestOpen && (
          <LimitWeeklyRestModal
            onClose={() => setIsLimitWeeklyRestOpen(false)}
            onStartRest={() => handleChangeActivity('REST')}
          />
        )}

        {/* Time Edit Modal */}
        {isTimeEditOpen && (
          <TimeEditModal
            initialMinutes={metrics.dailyDriveMinutes || 235}
            onClose={() => setIsTimeEditOpen(false)}
            onSave={(newMins) => {
              // Adjust the last driving entry
              const now = Date.now();
              const updated = entries.map((e, idx) => {
                if (idx === entries.length - 1 && e.activity === 'DRIVE') {
                  return { ...e, startTime: now - newMins * 60 * 1000 };
                }
                return e;
              });
              setEntries(updated);
            }}
          />
        )}

        {/* Shift Modal */}
        {isShiftModalOpen && (
          <ShiftModal
            shift={editingShift}
            defaultCountry={settings.startCountry || 'PL'}
            onClose={() => {
              setIsShiftModalOpen(false);
              setEditingShift(null);
              setEditingWeekId(null);
            }}
            onSaveShift={(savedShift) => {
              handleSaveShift(savedShift, editingWeekId);
            }}
            onDeleteShift={(shiftId) => {
              handleDeleteShift(shiftId, editingWeekId);
            }}
          />
        )}

        {/* Export Modal */}
        {isExportOpen && (
          <ExportModal
            entries={entries}
            settings={settings}
            onClose={() => setIsExportOpen(false)}
            onOpenPaywall={() => {
              setIsExportOpen(false);
              setIsPaywallOpen(true);
            }}
          />
        )}

        {/* Paywall Modal */}
        {isPaywallOpen && (
          <PaywallModal
            onClose={() => setIsPaywallOpen(false)}
            onUpgrade={() => {
              handleUpdateSettings({ isPremium: true });
              alert('Premium успешно активирован!');
            }}
          />
        )}

        {/* 24h Digital Tachograph Printout Modal */}
        {isPrintoutOpen && (
          <TachoPrintoutModal
            entries={entries}
            settings={settings}
            metrics={metrics}
            language={settings.language}
            onClose={() => setIsPrintoutOpen(false)}
          />
        )}

      </div>
    </div>
  );
};
