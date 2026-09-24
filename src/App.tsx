import React, { useEffect, useMemo, useRef, useState } from 'react';
import { createPortal } from 'react-dom';
import { calculateCompliance } from './domain/compliance';
import { analyzeTimeline } from './domain/shifts';
import { generateDemoData } from './domain/demo';
import {
  changeActivity,
  deleteEntriesInRange,
  drivingAdjustmentBounds,
  setLastBreakDuration,
} from './domain/entries';
import { buildJournal, type JournalShift } from './domain/journal';
import { applyLiveShiftEdit, carveRest, startShiftAt, type LiveShiftEdit } from './domain/shiftEdit';
import type {
  ActivityEntry,
  ActivityType,
  DriverSettings,
  InfringementCategory,
  ManualShift,
  RestKind,
  ShiftMeta,
} from './domain/types';
import { I18nProvider, dictFor } from './i18n';
import {
  clearAppData,
  defaultSettings,
  loadEntries,
  loadManualShifts,
  loadSettings,
  loadShiftMeta,
  saveEntries,
  saveManualShifts,
  saveSettings,
  saveShiftMeta,
} from './storage';
import { playViolationAlarm, playWarningChime } from './utils/audio';

import { GuideView } from './components/GuideView';
import { JournalView } from './components/JournalView';
import { MainView } from './components/MainView';
import { MoreView } from './components/MoreView';
import { PrintReport } from './components/PrintReport';
import { SettingsView } from './components/SettingsView';
import { DateTimeSheet } from './components/pickers';
import { BreakSheet } from './components/sheets/BreakSheet';
import { CardSheet } from './components/sheets/CardSheet';
import { CountrySheet } from './components/sheets/CountrySheet';
import { DriveEditSheet } from './components/sheets/DriveEditSheet';
import { ExportSheet, type PrintJob } from './components/sheets/ExportSheet';
import { PaywallSheet } from './components/sheets/PaywallSheet';
import { ShiftSheet } from './components/sheets/ShiftSheet';
import { WeeklyRestSheet } from './components/sheets/WeeklyRestSheet';
import { WorkdaySheet } from './components/sheets/WorkdaySheet';

type Tab = 'main' | 'journal' | 'settings' | 'more' | 'guide';
type Overlay =
  | null
  | 'country'
  | 'break'
  | 'workday'
  | 'shiftStart'
  | 'weeklyRest'
  | 'driveEdit'
  | 'card'
  | 'export'
  | 'paywall'
  | { shift: JournalShift | null; presetRest?: RestKind };

const CATEGORY_SETTING: Record<InfringementCategory, keyof DriverSettings> = {
  break: 'notifyBreak',
  driving: 'notifyDrivingLimit',
  shiftEnd: 'notifyShiftEnd',
  weeklyRest: 'notifyShiftEnd',
  card: 'notifyCardReading',
};

function useResolvedTheme(theme: DriverSettings['theme']) {
  const [systemDark, setSystemDark] = useState(() => window.matchMedia?.('(prefers-color-scheme: dark)').matches ?? true);
  useEffect(() => {
    const mq = window.matchMedia?.('(prefers-color-scheme: dark)');
    if (!mq) return;
    const onChange = () => setSystemDark(mq.matches);
    mq.addEventListener('change', onChange);
    return () => mq.removeEventListener('change', onChange);
  }, []);
  const resolved = theme === 'system' ? (systemDark ? 'dark' : 'light') : theme;
  useEffect(() => {
    document.documentElement.dataset.theme = resolved;
  }, [resolved]);
}

export const App: React.FC = () => {
  const [settings, setSettings] = useState<DriverSettings>(loadSettings);
  const [entries, setEntries] = useState<ActivityEntry[]>(loadEntries);
  const [manualShifts, setManualShifts] = useState<ManualShift[]>(loadManualShifts);
  const [shiftMeta, setShiftMeta] = useState<Record<string, ShiftMeta>>(loadShiftMeta);
  const [tab, setTab] = useState<Tab>('main');
  const [overlay, setOverlay] = useState<Overlay>(null);
  const [printJob, setPrintJob] = useState<PrintJob | null>(null);
  const [now, setNow] = useState(Date.now);

  useEffect(() => saveSettings(settings), [settings]);
  useEffect(() => saveEntries(entries), [entries]);
  useEffect(() => saveManualShifts(manualShifts), [manualShifts]);
  useEffect(() => saveShiftMeta(shiftMeta), [shiftMeta]);

  useEffect(() => {
    const timer = setInterval(() => setNow(Date.now()), 1000);
    return () => clearInterval(timer);
  }, []);

  useResolvedTheme(settings.theme);
  useEffect(() => {
    document.documentElement.lang = settings.language === 'ua' ? 'uk' : settings.language;
  }, [settings.language]);

  const metrics = useMemo(
    () => calculateCompliance({ entries, manualShifts, settings, now }),
    [entries, manualShifts, settings, now],
  );
  const journal = useMemo(
    () => buildJournal({ timeline: metrics.timeline, manualShifts, meta: shiftMeta, crewMode: settings.crewMode, now }),
    [metrics.timeline, manualShifts, shiftMeta, settings.crewMode, now],
  );

  // Новая смена получает страну начала из настроек
  const currentShiftId = metrics.shift?.id;
  useEffect(() => {
    if (currentShiftId && !shiftMeta[currentShiftId]) {
      setShiftMeta((m) => ({ ...m, [currentShiftId]: { startCountry: settings.defaultCountry } }));
    }
  }, [currentShiftId, shiftMeta, settings.defaultCountry]);

  // Звук — только для новых предупреждений включённых категорий
  const heard = useRef<Set<string> | null>(null);
  useEffect(() => {
    const enabled = metrics.infringements.filter((i) => i.severity !== 'info' && settings[CATEGORY_SETTING[i.category]]);
    const keys = new Set(enabled.map((i) => `${i.severity}:${i.key}`));
    const prev = heard.current;
    heard.current = keys;
    if (!prev || !settings.soundEnabled) return;
    const fresh = enabled.filter((i) => !prev.has(`${i.severity}:${i.key}`));
    if (fresh.some((i) => i.severity === 'violation')) playViolationAlarm();
    else if (fresh.length) playWarningChime();
  }, [metrics.infringements, settings]);

  // Печать отчёта: только отчёт, затем возврат к приложению
  useEffect(() => {
    if (!printJob) return;
    const done = () => {
      document.body.classList.remove('printing');
      setPrintJob(null);
    };
    document.body.classList.add('printing');
    window.addEventListener('afterprint', done, { once: true });
    // Даём отчёту отрисоваться; setTimeout срабатывает и в фоновой вкладке
    const id = window.setTimeout(() => window.print(), 50);
    return () => {
      window.clearTimeout(id);
      window.removeEventListener('afterprint', done);
      document.body.classList.remove('printing');
    };
  }, [printJob]);

  const updateSettings = (patch: Partial<DriverSettings>) => setSettings((s) => ({ ...s, ...patch }));

  // Бесплатно — только режимы на главной. Любая правка журнала — Premium: без него
  // действие открывает Premium. Экраны прячут правку сами, это вторая проверка.
  const requirePremium =
    <A extends unknown[]>(fn: (...args: A) => void) =>
    (...args: A) => {
      if (settings.isPremium) fn(...args);
      else setOverlay('paywall');
    };
  // Смену из журнала без Premium можно только посмотреть, новую — не добавить
  const openShift = (shift: JournalShift | null) => setOverlay(shift || settings.isPremium ? { shift } : 'paywall');

  const selectActivity = (activity: ActivityType, extra: { dayEnd?: boolean } = {}) => {
    const at = Date.now();
    setNow(at);
    setEntries((prev) =>
      changeActivity(prev, activity, at, {
        location: countryTarget ? shiftMeta[countryTarget.id]?.startCountry : settings.defaultCountry,
        ...(settings.ferryModeActive ? { ferry: true } : {}),
        ...extra,
      }),
    );
  };

  // Страны на главном: текущая смена, а во время отдыха после неё — только что закончившаяся
  const lastShift = metrics.timeline.shifts[metrics.timeline.shifts.length - 1];
  const countryTarget = metrics.shift ?? (metrics.offDutyRest ? lastShift : null) ?? null;
  const countries = countryTarget
    ? {
        start: shiftMeta[countryTarget.id]?.startCountry ?? settings.defaultCountry,
        end: shiftMeta[countryTarget.id]?.endCountry ?? null,
      }
    : { start: settings.defaultCountry, end: null };

  const setCountries = (v: { start: string; end: string | null }) => {
    if (countryTarget) {
      setShiftMeta((m) => ({
        ...m,
        [countryTarget.id]: { ...m[countryTarget.id], startCountry: v.start, endCountry: v.end ?? undefined },
      }));
      if (v.end) updateSettings({ defaultCountry: v.end });
    } else {
      updateSettings({ defaultCountry: v.start });
    }
  };

  const loadDemo = () => {
    const demo = generateDemoData(Date.now());
    setEntries(demo.entries);
    setShiftMeta(demo.meta);
    setManualShifts([]);
    setTab('main');
  };

  const clearData = () => {
    clearAppData();
    setSettings({ ...defaultSettings, language: settings.language });
    setEntries([]);
    setManualShifts([]);
    setShiftMeta({});
  };

  const deleteShift = (shift: JournalShift) => {
    if (shift.source === 'manual') {
      setManualShifts((list) => list.filter((m) => m.id !== shift.id));
    } else {
      setEntries((prev) => deleteEntriesInRange(prev, shift.start, shift.end));
      setShiftMeta(({ [shift.id]: _, ...rest }) => rest);
    }
  };

  // Прошлая смена из записей становится ручной: её записи и отдых после неё заменяются
  const convertShift = (shift: JournalShift, record: ManualShift) => {
    setEntries((prev) =>
      carveRest(deleteEntriesInRange(prev, shift.start, shift.restEnd ?? shift.end), record.start, record.end ?? Date.now(), Date.now()),
    );
    setShiftMeta(({ [shift.id]: _, ...rest }) => rest);
    setManualShifts((list) => [...list, record]);
  };

  // Ручная смена: если она попала на записанный отдых, вырезаем её из отдыха
  const saveManualShift = (record: ManualShift) => {
    setEntries((prev) => carveRest(prev, record.start, record.end ?? Date.now(), Date.now()));
    setManualShifts((list) => [...list.filter((x) => x.id !== record.id), record]);
  };

  // Смена из журнала, которая идёт сейчас, становится текущей: дальше она
  // считается по записям режимов, как если бы режим переключили вовремя.
  const startOngoingShift = (record: ManualShift, replacing: JournalShift | null) => {
    const at = Date.now();
    const base =
      replacing?.source === 'auto' ? deleteEntriesInRange(entries, replacing.start, replacing.restEnd ?? replacing.end) : entries;
    const next = startShiftAt(base, record.start, record.driveMinutes, at, record.startCountry);
    const newId = `auto-${record.start}`;
    // Если отдых перед сменой короче 9 ч, по записям это продолжение прошлой смены — её данные не трогаем
    const isNewShift = analyzeTimeline(next, at).shifts.at(-1)?.id === newId;
    setEntries(next);
    if (replacing?.source === 'manual') setManualShifts((list) => list.filter((m) => m.id !== replacing.id));
    setShiftMeta((all) => {
      const rest = { ...all };
      if (replacing) delete rest[replacing.id];
      if (isNewShift) rest[newId] = { startCountry: record.startCountry, notes: record.notes || undefined };
      return rest;
    });
  };

  // «Живая» смена: правим записи режимов. Идентификатор смены — её начало,
  // поэтому страны и заметки переносим на смену, получившуюся после правки.
  const applyLiveEdit = (edit: LiveShiftEdit, meta?: ShiftMeta) => {
    const at = Date.now();
    const oldId = `auto-${edit.shiftStart}`;
    const next = applyLiveShiftEdit(entries, edit, at).entries;
    const newId = analyzeTimeline(next, at).shifts.at(-1)?.id;
    const keep = meta ?? shiftMeta[oldId];
    setEntries(next);
    setShiftMeta(({ [oldId]: _, ...rest }) => (newId && keep ? { ...rest, [newId]: keep } : rest));
    if (meta?.endCountry) updateSettings({ defaultCountry: meta.endCountry });
  };

  const allShifts = useMemo(() => journal.flatMap((w) => w.shifts), [journal]);
  const shiftStart = metrics.shift?.start ?? null;
  const t = dictFor(settings.language);

  const tabs: { id: Tab; label: string; icon: React.ReactNode }[] = [
    {
      id: 'main',
      label: t.nav.main,
      icon: <path d="M4 11l8-7 8 7v9h-5v-6H9v6H4z" />,
    },
    { id: 'journal', label: t.nav.journal, icon: <path d="M5 5h14M5 10h14M5 15h14M5 20h9" /> },
    {
      id: 'settings',
      label: t.nav.settings,
      icon: (
        <>
          <path d="M4 7h10M18 7h2M4 17h4M12 17h8" />
          <circle cx="16" cy="7" r="2" />
          <circle cx="10" cy="17" r="2" />
        </>
      ),
    },
    {
      id: 'more',
      label: t.nav.more,
      icon: (
        <>
          <circle cx="5" cy="12" r="1.2" />
          <circle cx="12" cy="12" r="1.2" />
          <circle cx="19" cy="12" r="1.2" />
        </>
      ),
    },
  ];

  return (
    <I18nProvider lang={settings.language}>
      <div className="min-h-dvh bg-page flex items-center justify-center text-fg antialiased">
        <div className="w-full max-w-[412px] h-dvh sm:h-[880px] sm:max-h-[95dvh] bg-bg relative flex flex-col sm:rounded-[36px] sm:border sm:border-line sm:shadow-2xl overflow-hidden">
          <main className="flex-1 min-h-0 overflow-y-auto overflow-x-hidden overscroll-contain">
            {tab === 'main' && (
              <MainView
                metrics={metrics}
                settings={settings}
                countries={countries}
                isEmpty={entries.length === 0 && manualShifts.length === 0}
                onSelectActivity={selectActivity}
                onOpenCountryPicker={() => setOverlay('country')}
                onOpenBreak={() => setOverlay('break')}
                onOpenWorkday={() => setOverlay('workday')}
                onOpenWeeklyRest={() => setOverlay('weeklyRest')}
                onOpenDriveEdit={requirePremium(() => setOverlay('driveEdit'))}
                onOpenCard={() => setOverlay('card')}
                onLoadDemo={loadDemo}
              />
            )}
            {tab === 'journal' && (
              <JournalView
                weeks={journal}
                now={now}
                locked={!settings.isPremium}
                onOpenShift={openShift}
                onOpenExport={() => setOverlay('export')}
              />
            )}
            {tab === 'settings' && (
              <SettingsView
                settings={settings}
                onUpdate={updateSettings}
                onOpenExport={() => setOverlay('export')}
                onOpenPaywall={() => setOverlay('paywall')}
                onLoadDemo={loadDemo}
                onClearData={clearData}
              />
            )}
            {tab === 'more' && (
              <MoreView
                settings={settings}
                onOpenPaywall={() => setOverlay('paywall')}
                onOpenExport={() => setOverlay('export')}
                onOpenGuide={() => setTab('guide')}
              />
            )}
            {tab === 'guide' && <GuideView onBack={() => setTab('more')} />}
          </main>

          {tab !== 'guide' && (
            <nav aria-label={t.nav.label} className="shrink-0 h-20 px-2 pt-2.5 pb-3.5 bg-surface border-t border-surface2 grid grid-cols-4 z-30">
              {tabs.map((item) => {
                const active = tab === item.id;
                return (
                  <button
                    key={item.id}
                    type="button"
                    aria-current={active ? 'page' : undefined}
                    onClick={() => setTab(item.id)}
                    className={`flex flex-col items-center gap-1 text-[12px] font-semibold ${active ? 'text-fg' : 'text-muted hover:text-fg'}`}
                  >
                    <span className={`w-[60px] h-8 flex items-center justify-center rounded-full ${active ? 'bg-drive text-on-accent' : ''}`}>
                      <svg
                        width="22"
                        height="22"
                        viewBox="0 0 24 24"
                        fill={item.id === 'more' ? 'currentColor' : 'none'}
                        stroke="currentColor"
                        strokeWidth="2"
                        strokeLinecap="round"
                        strokeLinejoin="round"
                        aria-hidden="true"
                      >
                        {item.icon}
                      </svg>
                    </span>
                    {item.label}
                  </button>
                );
              })}
            </nav>
          )}

          {overlay === 'country' && (
            <CountrySheet
              start={countries.start}
              end={countries.end}
              initialTarget="start"
              onChange={setCountries}
              onClose={() => setOverlay(null)}
            />
          )}
          {overlay === 'break' && (
            <BreakSheet
              metrics={metrics}
              entries={entries}
              locked={!settings.isPremium}
              onStartBreak={() => selectActivity('REST')}
              onSetDuration={requirePremium((minutes: number) => {
                if (shiftStart !== null) setEntries((prev) => setLastBreakDuration(prev, shiftStart, minutes, Date.now()));
              })}
              // Сохранение без Premium открывает Premium — закрытие шторки его не сбрасывает
              onClose={() => setOverlay((o) => (o === 'break' ? null : o))}
            />
          )}
          {overlay === 'workday' && (
            <WorkdaySheet
              metrics={metrics}
              settings={settings}
              country={countries.start}
              onChangeStart={requirePremium(() => setOverlay('shiftStart'))}
              onEndDay={() => selectActivity('REST', { dayEnd: true })}
              onClose={() => setOverlay(null)}
            />
          )}
          {overlay === 'shiftStart' && shiftStart !== null && (
            <DateTimeSheet
              start={shiftStart}
              end={null}
              initialTab="start"
              max={now}
              onSave={requirePremium((v: { start: number }) => applyLiveEdit({ shiftStart, restStart: null, newStart: v.start }))}
              onClose={() => setOverlay(null)}
            />
          )}
          {overlay === 'weeklyRest' && (
            <WeeklyRestSheet
              metrics={metrics}
              settings={settings}
              onStartRest={() => selectActivity('REST', { dayEnd: true })}
              onAddManually={requirePremium(() => {
                setTab('journal');
                setOverlay({ shift: null, presetRest: 'weekly' });
              })}
              onClose={() => setOverlay(null)}
            />
          )}
          {overlay === 'driveEdit' && (
            <DriveEditSheet
              computedMinutes={metrics.dailyDriveMinutes}
              bounds={shiftStart !== null ? drivingAdjustmentBounds(entries, shiftStart, now) : null}
              onSave={requirePremium((delta: number) => {
                if (shiftStart !== null) applyLiveEdit({ shiftStart, restStart: null, driveDelta: delta });
              })}
              onClose={() => setOverlay(null)}
            />
          )}
          {overlay === 'card' && (
            <CardSheet
              lastRead={settings.lastCardReadTimestamp}
              onMarkToday={() => updateSettings({ lastCardReadTimestamp: Date.now() })}
              onClose={() => setOverlay(null)}
            />
          )}
          {overlay === 'export' && (
            <ExportSheet
              weeks={journal}
              entries={entries}
              settings={settings}
              now={now}
              onOpenPaywall={() => setOverlay('paywall')}
              onPrint={setPrintJob}
              onClose={() => setOverlay((o) => (o === 'export' ? null : o))}
            />
          )}
          {overlay === 'paywall' && (
            <PaywallSheet
              isPremium={settings.isPremium}
              onUpgrade={() => updateSettings({ isPremium: true })}
              onClose={() => setOverlay(null)}
            />
          )}
          {overlay !== null && typeof overlay === 'object' && (
            <ShiftSheet
              shift={overlay.shift}
              manual={overlay.shift?.source === 'manual' ? manualShifts.find((m) => m.id === overlay.shift!.id) : undefined}
              presetRest={overlay.presetRest}
              allShifts={allShifts}
              driveBounds={overlay.shift?.live ? drivingAdjustmentBounds(entries, overlay.shift.start, now) : null}
              defaultCountry={settings.defaultCountry}
              crewMode={settings.crewMode}
              now={now}
              locked={!settings.isPremium}
              onLocked={() => setOverlay('paywall')}
              onSaveManual={requirePremium(saveManualShift)}
              onSaveMeta={requirePremium((id: string, meta: ShiftMeta) => setShiftMeta((all) => ({ ...all, [id]: meta })))}
              onConvert={requirePremium(convertShift)}
              onStartOngoing={requirePremium(startOngoingShift)}
              onApplyLive={requirePremium(applyLiveEdit)}
              onDelete={requirePremium(deleteShift)}
              onClose={() => setOverlay(null)}
            />
          )}
        </div>
      </div>

      {printJob &&
        createPortal(
          <PrintReport job={printJob} weeks={journal} settings={settings} now={now} />,
          document.getElementById('print-root')!,
        )}
    </I18nProvider>
  );
};
