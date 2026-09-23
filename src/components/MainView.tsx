import React from 'react';
import { AlertCircle, AlertTriangle, ChevronDown, CreditCard, Info } from 'lucide-react';
import type { ComplianceMetrics } from '../domain/compliance';
import { LIMITS } from '../domain/limits';
import { DAY, MINUTE } from '../domain/time';
import type { ActivityType, DriverSettings, Infringement } from '../domain/types';
import { useI18n } from '../i18n';
import { Card, Chip, LimitBar, MODE_BG, MODE_BORDER, ModeIcon, SectionTitle, type Tone } from './ui';

interface Props {
  metrics: ComplianceMetrics;
  settings: DriverSettings;
  countries: { start: string; end: string | null };
  isEmpty: boolean;
  onSelectActivity: (a: ActivityType) => void;
  onOpenCountryPicker: () => void;
  onOpenBreak: () => void;
  onOpenWorkday: () => void;
  onOpenWeeklyRest: () => void;
  onOpenDriveEdit: () => void;
  onOpenCard: () => void;
  onLoadDemo: () => void;
}

const MODES: ActivityType[] = ['DRIVE', 'REST', 'WORK', 'POA'];

export const MainView: React.FC<Props> = ({
  metrics: m,
  settings,
  countries,
  isEmpty,
  onSelectActivity,
  onOpenCountryPicker,
  onOpenBreak,
  onOpenWorkday,
  onOpenWeeklyRest,
  onOpenDriveEdit,
  onOpenCard,
  onLoadDemo,
}) => {
  const { t, fmt } = useI18n();
  const now = m.now;
  const lead = settings.notifyLeadMinutes;
  const modeLabel: Record<ActivityType, string> = {
    DRIVE: t.common.drive,
    REST: t.common.rest,
    WORK: t.common.work,
    POA: t.common.poaShort,
  };
  const at =(minutesFromNow: number) => fmt.time(now + minutesFromNow * MINUTE);
  const shift = m.shift;

  return (
    <div className="flex flex-col gap-3 pb-6">
      <header className="h-16 px-5 flex items-center justify-between gap-2">
        <div className="flex flex-col min-w-0">
          <span className="text-[18px] font-bold tracking-tight">TachoTime</span>
          <span className="text-[12px] text-muted truncate">
            {shift
              ? t.main.shiftSince(fmt.weekdayDayMonth(now), fmt.time(shift.start))
              : t.main.noShift(fmt.weekdayDayMonth(now))}
          </span>
        </div>
        <button
          type="button"
          onClick={onOpenCountryPicker}
          aria-label={t.main.countryAria(countries.start, countries.end ?? '—')}
          className="min-h-11 px-3.5 rounded-full bg-surface border border-line hover:border-drive flex items-center gap-1 font-mono-num text-[14px] font-bold shrink-0"
        >
          <span>{countries.start}</span>
          <span className="text-muted">→</span>
          <span>{countries.end ?? '—'}</span>
          <ChevronDown className="w-4 h-4 text-muted ml-0.5" />
        </button>
      </header>

      <Hero metrics={m} lead={lead} onOpenBreak={onOpenBreak} />

      {isEmpty && (
        <div className="mx-4 p-4 rounded-[24px] bg-surface flex flex-col gap-2">
          <span className="text-[15px] font-semibold">{t.main.emptyTitle}</span>
          <span className="text-[14px] text-muted leading-relaxed">{t.main.emptyText}</span>
          <button
            type="button"
            onClick={onLoadDemo}
            className="self-start min-h-11 px-4 rounded-full border border-switch-off font-semibold text-[14px] hover:bg-surface2"
          >
            {t.main.loadDemo}
          </button>
        </div>
      )}

      <div className="mx-4 grid grid-cols-4 gap-2">
        {MODES.map((mode) => {
          const active = m.currentActivity === mode;
          return (
            <button
              key={mode}
              type="button"
              aria-pressed={active}
              onClick={() => onSelectActivity(mode)}
              className={`h-[88px] rounded-[20px] p-1 flex flex-col items-center justify-center gap-1.5 border transition-transform active:scale-95 ${
                active
                  ? `${MODE_BG[mode]} ${MODE_BORDER[mode]} text-on-accent font-bold`
                  : 'bg-surface text-fg border-line'
              }`}
            >
              <ModeIcon mode={mode} />
              <span className="text-[12px] font-semibold leading-tight text-center">{modeLabel[mode]}</span>
            </button>
          );
        })}
      </div>

      {m.infringements.length > 0 && (
        <>
          <SectionTitle>{t.main.alerts}</SectionTitle>
          <div className="mx-4 flex flex-col gap-2">
            {m.infringements.map((i) => (
              <Alert key={i.id} item={i} />
            ))}
          </div>
        </>
      )}

      <SectionTitle>{t.main.today}</SectionTitle>
      <Card>
        <Row
          title={t.main.continuous}
          onClick={onOpenBreak}
          chip={
            m.continuousDriveMinutes > LIMITS.continuousDrive
              ? { tone: 'bad', text: t.main.exceededChip }
              : shift && m.currentActivity !== 'REST' && m.continuousDriveMinutes > 0 && m.driveUntilBreakMinutes <= lead
                ? { tone: 'warn', text: t.main.breakSoonChip }
                : undefined
          }
          value={fmt.hm(m.continuousDriveMinutes)}
          valueTone={
            m.continuousDriveMinutes > LIMITS.continuousDrive
              ? 'bad'
              : shift && m.currentActivity !== 'REST' && m.driveUntilBreakMinutes <= lead
                ? 'accent'
                : undefined
          }
          bar={
            <LimitBar
              value={m.continuousDriveMinutes}
              max={LIMITS.continuousDrive}
              tone={m.continuousDriveMinutes > LIMITS.continuousDrive ? 'bad' : 'drive'}
            />
          }
          left={t.main.limit('4:30')}
          right={
            m.currentActivity === 'DRIVE' && m.driveUntilBreakMinutes > 0
              ? t.main.leftUntil(fmt.hm(m.driveUntilBreakMinutes), at(m.driveUntilBreakMinutes))
              : undefined
          }
        />
        <Row
          title={t.main.workday}
          onClick={onOpenWorkday}
          chip={{
            tone: 'neutral',
            text: settings.crewMode === 'TEAM' ? t.main.teamChip : t.main.extendedChip(m.reducedRestsLeft),
          }}
          value={fmt.hm(m.shiftMinutes)}
          valueTone={m.shiftMinutes > m.shiftLimitMinutes ? 'bad' : undefined}
          bar={
            <LimitBar
              value={m.shiftMinutes}
              max={m.shiftExtendedLimitMinutes}
              ticks={
                m.shiftRegularLimitMinutes < m.shiftExtendedLimitMinutes
                  ? [m.shiftRegularLimitMinutes, m.shiftExtendedLimitMinutes]
                  : [m.shiftExtendedLimitMinutes]
              }
              tone={m.shiftMinutes > m.shiftLimitMinutes ? 'bad' : m.shiftMinutes > m.shiftRegularLimitMinutes ? 'warn' : 'fg'}
            />
          }
          left={
            shift
              ? settings.crewMode === 'TEAM'
                ? t.main.workdayTeam(
                    fmt.hm(Math.max(0, m.shiftExtendedLimitMinutes - m.shiftMinutes)),
                    fmt.time(shift.start + m.shiftExtendedLimitMinutes * MINUTE),
                  )
                : t.main.workday13(
                    fmt.hm(Math.max(0, m.shiftRegularLimitMinutes - m.shiftMinutes)),
                    fmt.time(shift.start + m.shiftRegularLimitMinutes * MINUTE),
                  )
              : t.workday.noShift
          }
          right={
            shift && settings.crewMode !== 'TEAM'
              ? t.main.workday15(fmt.time(shift.start + m.shiftExtendedLimitMinutes * MINUTE))
              : undefined
          }
        />
        <Row
          title={t.main.dailyDrive}
          onClick={onOpenDriveEdit}
          chip={{ tone: 'neutral', text: t.main.extensionChip(m.extensionsLeft) }}
          value={fmt.hm(m.dailyDriveMinutes)}
          valueTone={m.dailyDriveMinutes > m.dailyDriveLimitMinutes ? 'bad' : undefined}
          bar={
            <LimitBar
              value={m.dailyDriveMinutes}
              max={LIMITS.dailyDriveExtended}
              ticks={[LIMITS.dailyDrive]}
              tone={
                m.dailyDriveMinutes > m.dailyDriveLimitMinutes ? 'bad' : m.dailyDriveMinutes > LIMITS.dailyDrive ? 'warn' : 'drive'
              }
            />
          }
          left={t.main.daily9(fmt.hm(Math.max(0, LIMITS.dailyDrive - m.dailyDriveMinutes)))}
          right={
            m.extensionsLeft > 0
              ? t.main.daily10(fmt.hm(Math.max(0, LIMITS.dailyDriveExtended - m.dailyDriveMinutes)))
              : undefined
          }
        />
        <BreakRow metrics={m} onClick={onOpenBreak} />
      </Card>

      <SectionTitle>{t.main.restSection}</SectionTitle>
      <Card>
        <Row
          title={t.main.dailyRest}
          subtitle={t.main.dailyRestCaption}
          onClick={onOpenWorkday}
          chip={{ tone: 'neutral', text: t.main.reducedLeftChip(m.reducedRestsLeft) }}
          status={m.offDutyRest && !m.offDutyRest.weekly ? t.main.inProgress(fmt.hm(m.offDutyRest.minutes)) : t.main.notStarted}
        />
        <Row
          title={t.main.weeklyRest}
          subtitle={t.main.weeklyRestCaption}
          onClick={onOpenWeeklyRest}
          chip={
            m.reducedWeeklyRestAvailable
              ? { tone: 'rest', text: t.main.reducedAvailable }
              : { tone: 'neutral', text: t.main.reducedUnavailable }
          }
          status={
            m.offDutyRest?.weekly
              ? t.main.inProgress(fmt.hm(m.offDutyRest.minutes))
              : m.weeklyRestDeadline !== null
                ? t.main.by(`${fmt.weekdayShort(m.weeklyRestDeadline)} ${fmt.time(m.weeklyRestDeadline)}`)
                : t.main.noData
          }
        />
      </Card>

      <SectionTitle>{t.main.week}</SectionTitle>
      <Card>
        <Row
          title={t.main.weeklyDrive}
          value={fmt.hm(m.weeklyDriveMinutes)}
          valueTone={m.weeklyDriveMinutes > LIMITS.weeklyDrive ? 'bad' : undefined}
          bar={
            <LimitBar
              value={m.weeklyDriveMinutes}
              max={LIMITS.weeklyDrive}
              tone={m.weeklyDriveMinutes > LIMITS.weeklyDrive ? 'bad' : 'drive'}
            />
          }
          left={t.main.limit('56:00')}
          right={t.main.left(fmt.hm(Math.max(0, LIMITS.weeklyDrive - m.weeklyDriveMinutes)))}
        />
        <Row
          title={t.main.fortnightDrive}
          chip={m.fortnightLimiting ? { tone: 'warn', text: t.main.limitingChip } : undefined}
          value={fmt.hm(m.fortnightDriveMinutes)}
          valueTone={m.fortnightDriveMinutes > LIMITS.fortnightDrive ? 'bad' : undefined}
          bar={
            <LimitBar
              value={m.fortnightDriveMinutes}
              max={LIMITS.fortnightDrive}
              tone={m.fortnightDriveMinutes > LIMITS.fortnightDrive ? 'bad' : 'drive'}
            />
          }
          left={t.main.limit('90:00')}
          right={t.main.left(fmt.hm(Math.max(0, LIMITS.fortnightDrive - m.fortnightDriveMinutes)))}
        />
        <Row
          title={t.main.workWeek}
          onClick={onOpenWeeklyRest}
          chip={{ tone: 'neutral', text: t.main.workWeekChip }}
          value={m.workWeekStart !== null ? fmt.hm(m.workWeekMinutes) : '—'}
          valueTone={m.workWeekMinutes > LIMITS.maxBetweenWeeklyRests ? 'bad' : undefined}
          bar={
            <LimitBar
              value={m.workWeekMinutes}
              max={LIMITS.maxBetweenWeeklyRests}
              tone={m.workWeekMinutes > LIMITS.maxBetweenWeeklyRests ? 'bad' : 'fg'}
            />
          }
          left={
            m.workWeekStart !== null && m.weeklyRestDeadline !== null
              ? t.main.workWeekCaption(
                  fmt.weekdayDate(m.workWeekStart),
                  fmt.hm(Math.max(0, (m.weeklyRestDeadline - now) / MINUTE)),
                  `${fmt.weekdayShort(m.weeklyRestDeadline)} ${fmt.time(m.weeklyRestDeadline)}`,
                )
              : t.main.workWeekUnknown
          }
        />
      </Card>

      <CardReading metrics={m} settings={settings} onClick={onOpenCard} />
    </div>
  );
};

const Hero: React.FC<{ metrics: ComplianceMetrics; lead: number; onOpenBreak: () => void }> = ({ metrics: m, lead, onOpenBreak }) => {
  const { t, fmt } = useI18n();
  const radius = 102;
  const circumference = 2 * Math.PI * radius;

  let label: string;
  let big: string;
  let caption: string;
  let fraction: number;
  let ring: string;
  if (m.offDutyRest) {
    const target = m.offDutyRest.weekly ? LIMITS.weeklyRestRegular : LIMITS.dailyRestRegular;
    label = m.offDutyRest.weekly ? t.main.offDutyWeekly : t.main.offDutyDaily;
    big = fmt.hm(m.offDutyRest.minutes);
    caption = t.main.offDutyHint;
    fraction = m.offDutyRest.minutes / target;
    ring = 'var(--tt-rest)';
  } else if (m.currentBreak && m.shift) {
    label = t.breakSheet.title;
    big = fmt.hm(m.currentBreak.minutes);
    caption = t.main.continuousOf(fmt.hm(m.continuousDriveMinutes));
    fraction = m.currentBreak.minutes / m.currentBreak.requiredMinutes;
    ring = 'var(--tt-rest)';
  } else {
    label = t.main.untilBreak;
    big = fmt.hm(m.driveUntilBreakMinutes);
    caption = t.main.continuousOf(fmt.hm(m.continuousDriveMinutes));
    fraction = m.continuousDriveMinutes / LIMITS.continuousDrive;
    ring = m.continuousDriveMinutes > LIMITS.continuousDrive ? 'var(--tt-err-fg)' : 'var(--tt-drive)';
  }

  // Плашка — только когда есть что сказать
  let banner: { tone: 'warn' | 'bad' | 'rest'; text: string } | null = null;
  if (m.shift && m.currentBreak) {
    banner =
      m.continuousDriveMinutes === 0
        ? { tone: 'rest', text: t.main.breakCounted }
        : { tone: 'rest', text: t.main.onBreak(fmt.hm(m.currentBreak.minutes), m.currentBreak.requiredMinutes) };
  } else if (m.continuousDriveMinutes > LIMITS.continuousDrive) {
    banner = { tone: 'bad', text: t.infringement.continuousExceeded.title };
  } else if (m.shift && m.continuousDriveMinutes > 0 && (m.driveUntilBreakMinutes <= lead || m.breakFirstPart)) {
    banner = { tone: 'warn', text: m.breakFirstPart ? t.main.breakNeeded30 : t.main.breakNeeded45 };
  }
  const bannerClass = { warn: 'bg-warn-bg text-warn-fg', bad: 'bg-err-bg text-err-fg', rest: 'bg-rest-bg text-rest-fg' };

  const modeLabel: Record<ActivityType, string> = {
    DRIVE: t.common.drive,
    REST: t.common.rest,
    WORK: t.common.workFull,
    POA: t.common.poa,
  };

  return (
    <section className="mx-4 p-5 rounded-[28px] bg-surface flex flex-col items-center gap-4">
      <button
        type="button"
        onClick={onOpenBreak}
        className="relative w-[240px] h-[240px] flex items-center justify-center"
        aria-label={`${label} ${big}`}
      >
        <svg className="absolute inset-0 w-full h-full -rotate-90" viewBox="0 0 240 240" aria-hidden="true">
          <circle cx="120" cy="120" r={radius} fill="none" stroke="var(--tt-line)" strokeWidth="14" />
          <circle
            cx="120"
            cy="120"
            r={radius}
            fill="none"
            stroke={ring}
            strokeWidth="14"
            strokeLinecap="round"
            strokeDasharray={circumference}
            strokeDashoffset={circumference * (1 - Math.min(1, Math.max(0, fraction)))}
            className="transition-[stroke-dashoffset] duration-700"
          />
        </svg>
        <span className="relative flex flex-col items-center text-center px-6">
          <span className="text-[12px] font-semibold tracking-[0.08em] uppercase text-muted">{label}</span>
          <span className="font-mono-num text-[60px] font-bold leading-none my-1">{big}</span>
          <span className="text-[13px] text-muted">{caption}</span>
        </span>
      </button>

      {banner && (
        <div
          className={`w-full py-2.5 px-3.5 rounded-[16px] text-[13px] font-semibold flex items-center gap-2 ${bannerClass[banner.tone]}`}
          role="status"
        >
          <AlertCircle className="w-4 h-4 shrink-0" />
          <span>{banner.text}</span>
        </div>
      )}

      <div className="flex items-center gap-2 text-[14px] w-full">
        {m.currentActivity ? (
          <>
            <span className={`w-2.5 h-2.5 rounded-full ${MODE_BG[m.currentActivity]}`} />
            <span className="font-semibold">{modeLabel[m.currentActivity]}</span>
            {m.currentActivityStart !== null && (
              <span className="text-muted">{t.main.since(fmt.time(m.currentActivityStart))}</span>
            )}
            <span className="ml-auto font-mono-num text-[20px] font-bold">{fmt.hm(m.currentActivityMinutes)}</span>
          </>
        ) : (
          <span className="text-muted">{t.main.noMode}</span>
        )}
      </div>
    </section>
  );
};

const BreakRow: React.FC<{ metrics: ComplianceMetrics; onClick: () => void }> = ({ metrics: m, onClick }) => {
  const { t, fmt } = useI18n();
  const first = m.breakFirstPart;
  const current = m.currentBreak;
  const taken = current ? (current.requiredMinutes === LIMITS.breakSplitSecond && first ? first.minutes : 0) + current.minutes : first?.minutes ?? 0;
  const done = m.shift && m.continuousDriveMinutes === 0 && !!current;

  let caption: string;
  if (current) caption = t.breakSheet.resting(fmt.hm(current.minutes), current.requiredMinutes);
  else if (first) caption = `${t.main.breakTaken(Math.round(first.minutes), fmt.time(first.start))} · ${t.main.breakStillNeeded(LIMITS.breakSplitSecond)}`;
  else caption = t.main.breakNotTaken;

  return (
    <Row
      title={t.main.breakRow}
      onClick={onClick}
      chip={first || current?.requiredMinutes === LIMITS.breakSplitSecond ? { tone: 'rest', text: '15 + 30' } : undefined}
      value={`${fmt.hm(Math.min(taken, 999))} / 0:45`}
      valueTone={done ? 'rest' : undefined}
      bar={<LimitBar value={taken} max={LIMITS.breakFull} ticks={[LIMITS.breakSplitFirst]} tone="rest" />}
      left={caption}
    />
  );
};

const CardReading: React.FC<{ metrics: ComplianceMetrics; settings: DriverSettings; onClick: () => void }> = ({
  metrics: m,
  settings,
  onClick,
}) => {
  const { t, fmt } = useI18n();
  const last = settings.lastCardReadTimestamp;
  const left = m.cardDaysLeft;
  const tone = left === null ? 'fg' : left < 0 ? 'bad' : left <= settings.cardReadingAlertDays ? 'warn' : 'drive';
  return (
    <button type="button" onClick={onClick} className="mx-4 p-4 rounded-[24px] bg-surface flex flex-col gap-2 text-left hover:bg-surface2/60">
      <span className="flex items-center justify-between">
        <span className="flex items-center gap-2.5">
          <CreditCard className="w-5 h-5 text-drive" />
          <span className="text-[15px] font-semibold">{t.main.card}</span>
        </span>
        <span className={`font-mono-num text-[17px] font-bold ${left !== null && left < 0 ? 'text-err-fg' : 'text-drive'}`}>
          {left === null ? '—' : t.common.daysShort(left)}
        </span>
      </span>
      <LimitBar value={left === null ? 0 : LIMITS.cardDownloadDays - left} max={LIMITS.cardDownloadDays} tone={tone} />
      <span className="text-[12px] text-muted">
        {last === null ? t.main.cardNever : t.main.cardCaption(fmt.dayMonth(last), fmt.dayMonth(last + LIMITS.cardDownloadDays * DAY))}
      </span>
    </button>
  );
};

const Alert: React.FC<{ item: Infringement }> = ({ item }) => {
  const { t } = useI18n();
  const text = t.infringement[item.key];
  const style =
    item.severity === 'violation'
      ? 'bg-err-bg text-err-fg'
      : item.severity === 'warning'
        ? 'bg-warn-bg text-warn-fg'
        : 'bg-surface text-fg';
  const Icon = item.severity === 'violation' ? AlertTriangle : item.severity === 'warning' ? AlertCircle : Info;
  return (
    <div className={`p-3.5 rounded-[16px] flex gap-3 ${style}`} role={item.severity === 'violation' ? 'alert' : 'status'}>
      <Icon className="w-5 h-5 shrink-0 mt-0.5" />
      <div className="flex flex-col gap-0.5">
        <span className="text-[14px] font-semibold">{text.title}</span>
        <span className="text-[13px] leading-relaxed opacity-90">{text.text(item.params)}</span>
        <span className="text-[11px] opacity-70">{t.common.article(item.source.regulation, item.source.article)}</span>
      </div>
    </div>
  );
};

const VALUE_TONE: Record<Exclude<Tone, 'neutral'>, string> = {
  warn: 'text-warn-fg',
  bad: 'text-err-fg',
  rest: 'text-rest',
  accent: 'text-drive',
};

const Row: React.FC<{
  title: string;
  subtitle?: string;
  onClick?: () => void;
  chip?: { tone: Tone; text: string };
  value?: string;
  valueTone?: Exclude<Tone, 'neutral'>;
  status?: string;
  bar?: React.ReactNode;
  left?: string;
  right?: string;
}> = ({ title, subtitle, onClick, chip, value, valueTone, status, bar, left, right }) => {
  const body = (
    <>
      <span className="flex justify-between items-center gap-2">
        <span className="flex flex-col gap-0.5 min-w-0">
          <span className="text-[15px] font-semibold">{title}</span>
          {subtitle && <span className="text-[13px] text-muted">{subtitle}</span>}
        </span>
        <span className="flex items-center gap-2 shrink-0">
          {chip && <Chip tone={chip.tone}>{chip.text}</Chip>}
          {value && <span className={`font-mono-num text-[17px] font-bold ${valueTone ? VALUE_TONE[valueTone] : ''}`}>{value}</span>}
          {status && <span className="text-[14px] text-muted">{status}</span>}
        </span>
      </span>
      {bar}
      {(left || right) && (
        <span className="flex justify-between gap-3 text-[12px] text-muted">
          <span>{left}</span>
          {right && <span className="text-right">{right}</span>}
        </span>
      )}
    </>
  );
  const cls = 'w-full p-4 flex flex-col gap-2 text-left';
  return onClick ? (
    <button type="button" onClick={onClick} className={`${cls} hover:bg-surface2/40 transition-colors`}>
      {body}
    </button>
  ) : (
    <div className={cls}>{body}</div>
  );
};
