import React, { useState } from 'react';
import { Check, ChevronRight, Globe, Sparkles, Trash2 } from 'lucide-react';
import type { AppTheme, CardAlertDays, CrewMode, DriverSettings, LeadMinutes } from '../domain/types';
import { LANGUAGES, languageName, useI18n } from '../i18n';
import { Card, Chip, ConfirmSheet, Pills, SectionTitle, Segmented, Sheet, Switch } from './ui';

interface Props {
  settings: DriverSettings;
  onUpdate: (s: Partial<DriverSettings>) => void;
  onOpenExport: () => void;
  onOpenPaywall: () => void;
  onLoadDemo: () => void;
  onClearData: () => void;
}

export const SettingsView: React.FC<Props> = ({ settings, onUpdate, onOpenExport, onOpenPaywall, onLoadDemo, onClearData }) => {
  const { t } = useI18n();
  const [sheet, setSheet] = useState<null | 'language' | 'demo' | 'clear'>(null);

  return (
    <div className="flex flex-col gap-3 pb-8">
      <header className="h-16 px-5 flex items-center">
        <h1 className="text-[18px] font-bold tracking-tight">{t.settings.title}</h1>
      </header>

      <SectionTitle className="mt-1">{t.settings.general}</SectionTitle>
      <Card>
        <button
          type="button"
          onClick={() => setSheet('language')}
          className="w-full min-h-14 p-4 flex items-center justify-between text-left hover:bg-surface2/40"
        >
          <span className="text-[15px] font-semibold">{t.settings.language}</span>
          <span className="flex items-center gap-2 text-[14px] text-muted">
            {languageName(settings.language)}
            <ChevronRight className="w-4 h-4" />
          </span>
        </button>
        <div className="p-4 flex flex-col gap-2.5">
          <span className="text-[15px] font-semibold">{t.settings.theme}</span>
          <Segmented<AppTheme>
            options={[
              { value: 'system', label: t.settings.themeSystem },
              { value: 'light', label: t.settings.themeLight },
              { value: 'dark', label: t.settings.themeDark },
            ]}
            value={settings.theme}
            onChange={(theme) => onUpdate({ theme })}
          />
        </div>
      </Card>

      <SectionTitle>{t.settings.driver}</SectionTitle>
      <Card>
        <TextRow label={t.settings.driverName} value={settings.driverName} onChange={(driverName) => onUpdate({ driverName })} />
        <TextRow
          label={t.settings.driverCard}
          value={settings.driverCardNumber}
          onChange={(driverCardNumber) => onUpdate({ driverCardNumber })}
          mono
        />
        <TextRow label={t.settings.vehicle} value={settings.vehiclePlate} onChange={(vehiclePlate) => onUpdate({ vehiclePlate })} mono />
        <TextRow label={t.settings.company} value={settings.companyName} onChange={(companyName) => onUpdate({ companyName })} />
      </Card>
      <p className="mx-6 -mt-1 text-[12px] text-muted">{t.settings.driverHint}</p>

      <SectionTitle>{t.settings.rules}</SectionTitle>
      <Card>
        <SwitchRow
          title={t.settings.mobility}
          hint={t.settings.mobilityHint}
          checked={settings.mobilityPackageEnabled}
          onChange={(mobilityPackageEnabled) => onUpdate({ mobilityPackageEnabled })}
        />
        <div className="p-4 flex flex-col gap-2.5">
          <span className="flex flex-col">
            <span className="text-[15px] font-semibold">{t.settings.crew}</span>
            <span className="text-[13px] text-muted">{t.settings.teamHint}</span>
          </span>
          <Segmented<CrewMode>
            options={[
              { value: 'SOLO', label: t.settings.solo },
              { value: 'TEAM', label: t.settings.team },
            ]}
            value={settings.crewMode}
            onChange={(crewMode) => onUpdate({ crewMode })}
          />
        </div>
        <SwitchRow
          title={t.settings.ferry}
          hint={t.settings.ferryHint}
          checked={settings.ferryModeActive}
          onChange={(ferryModeActive) => onUpdate({ ferryModeActive })}
        />
      </Card>

      <SectionTitle>{t.settings.notifications}</SectionTitle>
      <Card>
        <div className="p-4 flex flex-col gap-2.5">
          <span className="flex flex-col">
            <span className="text-[15px] font-semibold">{t.settings.warnAbout}</span>
            <span className="text-[13px] text-muted">{t.settings.warnAboutHint}</span>
          </span>
          <Pills<LeadMinutes>
            options={([15, 30, 60] as const).map((m) => ({ value: m, label: t.settings.lead(m) }))}
            value={settings.notifyLeadMinutes}
            onChange={(notifyLeadMinutes) => onUpdate({ notifyLeadMinutes })}
          />
        </div>
        <SwitchRow title={t.settings.notifyBreak} checked={settings.notifyBreak} onChange={(notifyBreak) => onUpdate({ notifyBreak })} />
        <SwitchRow
          title={t.settings.notifyShiftEnd}
          checked={settings.notifyShiftEnd}
          onChange={(notifyShiftEnd) => onUpdate({ notifyShiftEnd })}
        />
        <SwitchRow
          title={t.settings.notifyDriving}
          checked={settings.notifyDrivingLimit}
          onChange={(notifyDrivingLimit) => onUpdate({ notifyDrivingLimit })}
        />
        <div className="p-4 flex flex-col gap-3">
          <div className="flex items-center justify-between gap-4">
            <span className="flex flex-col">
              <span className="text-[15px] font-semibold">{t.settings.notifyCard}</span>
              <span className="text-[13px] text-muted">{t.settings.cardEvery}</span>
            </span>
            <Switch
              checked={settings.notifyCardReading}
              onChange={(notifyCardReading) => onUpdate({ notifyCardReading })}
              label={t.settings.notifyCard}
            />
          </div>
          <span className="text-[13px] text-muted">{t.settings.warnBefore}</span>
          <Pills<CardAlertDays>
            options={([3, 7, 14] as const).map((d) => ({ value: d, label: t.common.days(d) }))}
            value={settings.cardReadingAlertDays}
            onChange={(cardReadingAlertDays) => onUpdate({ cardReadingAlertDays })}
          />
        </div>
        <SwitchRow
          title={t.settings.sound}
          hint={t.settings.soundHint}
          checked={settings.soundEnabled}
          onChange={(soundEnabled) => onUpdate({ soundEnabled })}
        />
      </Card>

      <SectionTitle>{t.settings.data}</SectionTitle>
      <Card>
        <NavRow label={t.settings.export} onClick={onOpenExport} trailing="PDF · CSV" />
        {/* Перенос — Premium; в прототипе самого переноса ещё нет */}
        {settings.isPremium ? (
          <NavRow label={t.settings.transfer} trailing={<Chip tone="neutral">{t.common.soon}</Chip>} />
        ) : (
          <NavRow label={t.settings.transfer} onClick={onOpenPaywall} trailing={<Chip tone="accent">{t.common.premium}</Chip>} />
        )}
        <NavRow
          label={t.settings.loadDemo}
          onClick={() => setSheet('demo')}
          icon={<Sparkles className="w-5 h-5 text-drive shrink-0" />}
        />
        <button
          type="button"
          onClick={() => setSheet('clear')}
          className="w-full min-h-14 p-4 flex items-center gap-3 text-left text-err-fg hover:bg-err-bg font-semibold text-[15px]"
        >
          <Trash2 className="w-5 h-5 shrink-0" />
          {t.settings.clear}
        </button>
      </Card>

      {sheet === 'language' && (
        <Sheet onClose={() => setSheet(null)} label={t.settings.chooseLanguage}>
          <div className="p-4 flex items-center justify-between border-b border-surface2">
            <span className="flex items-center gap-2">
              <Globe className="w-5 h-5 text-drive" />
              <h3 className="text-[17px] font-bold">{t.settings.chooseLanguage}</h3>
            </span>
            <button type="button" onClick={() => setSheet(null)} className="min-h-11 px-2 text-[14px] text-muted hover:text-fg">
              {t.common.close}
            </button>
          </div>
          <div className="p-2 pb-6">
            {LANGUAGES.map((lang) => (
              <button
                key={lang}
                type="button"
                lang={lang === 'ua' ? 'uk' : lang}
                onClick={() => {
                  onUpdate({ language: lang });
                  setSheet(null);
                }}
                className="w-full min-h-14 px-4 flex items-center justify-between text-left rounded-[12px] hover:bg-surface2"
              >
                <span className="text-[15px] font-medium">{languageName(lang)}</span>
                {settings.language === lang && <Check className="w-5 h-5 text-drive" />}
              </button>
            ))}
          </div>
        </Sheet>
      )}
      {sheet === 'demo' && (
        <ConfirmSheet
          title={t.settings.loadDemoTitle}
          text={t.settings.loadDemoText}
          confirmLabel={t.settings.loadDemo}
          cancelLabel={t.common.cancel}
          onConfirm={onLoadDemo}
          onClose={() => setSheet(null)}
        />
      )}
      {sheet === 'clear' && (
        <ConfirmSheet
          title={t.settings.clearTitle}
          text={t.settings.clearText}
          confirmLabel={t.common.delete}
          cancelLabel={t.common.cancel}
          danger
          onConfirm={onClearData}
          onClose={() => setSheet(null)}
        />
      )}
    </div>
  );
};

const SwitchRow: React.FC<{ title: string; hint?: string; checked: boolean; onChange: (v: boolean) => void }> = ({
  title,
  hint,
  checked,
  onChange,
}) => (
  <div className="min-h-14 p-4 flex items-center justify-between gap-4">
    <span className="flex flex-col gap-0.5">
      <span className="text-[15px] font-semibold">{title}</span>
      {hint && <span className="text-[13px] leading-relaxed text-muted">{hint}</span>}
    </span>
    <Switch checked={checked} onChange={onChange} label={title} />
  </div>
);

/** Без onClick — строка только показывает состояние. */
const NavRow: React.FC<{ label: string; onClick?: () => void; trailing?: React.ReactNode; icon?: React.ReactNode }> = ({
  label,
  onClick,
  trailing,
  icon,
}) => {
  const body = (
    <>
      {icon}
      <span className="flex-1 text-[15px] font-semibold">{label}</span>
      {typeof trailing === 'string' ? <span className="text-[13px] text-muted">{trailing}</span> : trailing}
    </>
  );
  const cls = 'w-full min-h-14 p-4 flex items-center gap-3 text-left';
  return onClick ? (
    <button type="button" onClick={onClick} className={`${cls} hover:bg-surface2/40`}>
      {body}
      <ChevronRight className="w-4 h-4 text-muted" />
    </button>
  ) : (
    <div className={cls}>{body}</div>
  );
};

const TextRow: React.FC<{ label: string; value: string; onChange: (v: string) => void; mono?: boolean }> = ({
  label,
  value,
  onChange,
  mono,
}) => (
  <label className="min-h-14 px-4 py-2 flex items-center justify-between gap-3">
    <span className="text-[15px] font-semibold shrink-0">{label}</span>
    <input
      value={value}
      onChange={(e) => onChange(e.target.value)}
      placeholder="—"
      className={`min-w-0 flex-1 h-11 text-right bg-transparent outline-none placeholder:text-muted focus:text-drive ${
        mono ? 'font-mono-num' : ''
      } text-[15px]`}
    />
  </label>
);
