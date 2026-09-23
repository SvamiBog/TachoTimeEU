import React, { useState, useEffect } from 'react';
import { Volume2, VolumeX, Globe, Users, User, Printer, ShieldCheck, Clock } from 'lucide-react';
import { DriverSettings, SupportedLanguage } from '../types/tacho';
import { translations } from '../utils/translations';
import { playKeypressTone } from '../utils/audio';

interface HeaderProps {
  settings: DriverSettings;
  onUpdateSettings: (settings: DriverSettings) => void;
  onOpenPrintout: () => void;
}

export const Header: React.FC<HeaderProps> = ({
  settings,
  onUpdateSettings,
  onOpenPrintout,
}) => {
  const [time, setTime] = useState<Date>(new Date());
  const [isEditingDriver, setIsEditingDriver] = useState(false);
  const [driverNameInput, setDriverNameInput] = useState(settings.driverName);
  const [plateInput, setPlateInput] = useState(settings.vehiclePlate);
  const t = translations[settings.language] || translations.en;

  useEffect(() => {
    const timer = setInterval(() => setTime(new Date()), 1000);
    return () => clearInterval(timer);
  }, []);

  const handleToggleSound = () => {
    const next = !settings.soundEnabled;
    onUpdateSettings({ ...settings, soundEnabled: next });
    if (next) playKeypressTone();
  };

  const handleToggleCrew = () => {
    const nextCrew = settings.crewMode === 'SOLO' ? 'TEAM' : 'SOLO';
    onUpdateSettings({ ...settings, crewMode: nextCrew });
    if (settings.soundEnabled) playKeypressTone();
  };

  const handleSaveDriverDetails = (e: React.FormEvent) => {
    e.preventDefault();
    onUpdateSettings({
      ...settings,
      driverName: driverNameInput || 'Driver 1',
      vehiclePlate: plateInput || 'VRN-001',
    });
    setIsEditingDriver(false);
  };

  const languages: { code: SupportedLanguage; label: string; flag: string }[] = [
    { code: 'ru', label: 'Русский', flag: '🇷🇺' },
    { code: 'ua', label: 'Українська', flag: '🇺🇦' },
    { code: 'pl', label: 'Polski', flag: '🇵🇱' },
    { code: 'en', label: 'English', flag: '🇬🇧' },
    { code: 'de', label: 'Deutsch', flag: '🇩🇪' },
  ];

  const formatUtcTime = (date: Date) => {
    const h = date.getUTCHours().toString().padStart(2, '0');
    const m = date.getUTCMinutes().toString().padStart(2, '0');
    const s = date.getUTCSeconds().toString().padStart(2, '0');
    return `${h}:${m}:${s} UTC`;
  };

  const formatLocalDate = (date: Date) => {
    return date.toLocaleDateString(undefined, {
      weekday: 'short',
      year: 'numeric',
      month: 'short',
      day: 'numeric',
    });
  };

  return (
    <header className="bg-slate-900 border-b border-slate-800 text-slate-100 shadow-md sticky top-0 z-30">
      <div className="max-w-7xl mx-auto px-3 sm:px-6 py-2.5">
        <div className="flex flex-wrap items-center justify-between gap-3">
          
          {/* Logo & EU Regulation Badge */}
          <div className="flex items-center gap-3">
            <div className="flex items-center justify-center w-10 h-10 rounded-lg bg-blue-600/20 border border-blue-500/40 text-blue-400 shadow-inner">
              <span className="text-xl">🇪🇺</span>
            </div>
            <div>
              <div className="flex items-center gap-2">
                <h1 className="text-lg font-bold tracking-tight text-white flex items-center gap-1.5">
                  TachoTime<span className="text-blue-400 font-extrabold">EU</span>
                </h1>
                <span className="text-[10px] uppercase font-bold tracking-wider px-1.5 py-0.5 rounded bg-blue-950 text-blue-300 border border-blue-800">
                  EC 561/2006
                </span>
              </div>
              <p className="text-xs text-slate-400 hidden sm:block">
                {t.subtitle}
              </p>
            </div>
          </div>

          {/* Center: Live UTC Tachograph Clock */}
          <div className="flex items-center gap-3 bg-slate-950/80 px-3 py-1.5 rounded-lg border border-slate-800 font-mono-tacho">
            <Clock className="w-4 h-4 text-emerald-400 animate-pulse" />
            <div className="text-right">
              <div className="text-sm font-bold text-emerald-400 tracking-wider">
                {formatUtcTime(time)}
              </div>
              <div className="text-[10px] text-slate-400">
                {formatLocalDate(time)}
              </div>
            </div>
          </div>

          {/* Right: Driver Card, Crew Mode, Sound, Language & Printout */}
          <div className="flex items-center gap-2 flex-wrap">
            
            {/* Driver & Plate Info pill */}
            <button
              onClick={() => setIsEditingDriver(true)}
              title="Click to edit driver name and vehicle registration"
              className="flex items-center gap-2 bg-slate-800 hover:bg-slate-700/80 transition-colors px-2.5 py-1.5 rounded-md border border-slate-700 text-xs"
            >
              <div className="w-2 h-2 rounded-full bg-emerald-400"></div>
              <div className="text-left font-mono-tacho">
                <span className="text-slate-300 font-semibold truncate max-w-[100px] sm:max-w-[130px] inline-block align-bottom">
                  {settings.driverName}
                </span>
                <span className="text-slate-500 mx-1">|</span>
                <span className="text-amber-400 font-bold">{settings.vehiclePlate}</span>
              </div>
            </button>

            {/* Crew Mode toggle */}
            <button
              onClick={handleToggleCrew}
              title={`Switch crew mode (current: ${settings.crewMode === 'SOLO' ? t.soloDriver : t.teamCrew})`}
              className={`flex items-center gap-1.5 px-2.5 py-1.5 rounded-md text-xs font-medium border transition-colors ${
                settings.crewMode === 'TEAM'
                  ? 'bg-purple-950/80 border-purple-600 text-purple-200'
                  : 'bg-slate-800 border-slate-700 text-slate-300 hover:bg-slate-750'
              }`}
            >
              {settings.crewMode === 'TEAM' ? (
                <>
                  <Users className="w-3.5 h-3.5 text-purple-400" />
                  <span className="hidden md:inline">{t.teamCrew}</span>
                  <span className="md:hidden">2P</span>
                </>
              ) : (
                <>
                  <User className="w-3.5 h-3.5 text-slate-400" />
                  <span className="hidden md:inline">{t.soloDriver}</span>
                  <span className="md:hidden">1P</span>
                </>
              )}
            </button>

            {/* Printout Sheet button */}
            <button
              onClick={onOpenPrintout}
              className="flex items-center gap-1.5 px-2.5 py-1.5 rounded-md text-xs font-medium bg-slate-800 hover:bg-slate-700 border border-slate-700 text-slate-200 transition-colors"
              title={t.exportPrintout}
            >
              <Printer className="w-3.5 h-3.5 text-blue-400" />
              <span className="hidden sm:inline">{t.exportPrintout}</span>
            </button>

            {/* Sound toggle */}
            <button
              onClick={handleToggleSound}
              className={`p-1.5 rounded-md border transition-colors ${
                settings.soundEnabled
                  ? 'bg-slate-800 text-emerald-400 border-slate-700 hover:bg-slate-700'
                  : 'bg-slate-800 text-slate-500 border-slate-700 hover:bg-slate-700'
              }`}
              title={settings.soundEnabled ? 'Mute audio alerts' : 'Enable audio alerts'}
              aria-label="Toggle Sound"
            >
              {settings.soundEnabled ? <Volume2 className="w-4 h-4" /> : <VolumeX className="w-4 h-4" />}
            </button>

            {/* Language Selector */}
            <div className="relative group">
              <button
                className="flex items-center gap-1 bg-slate-800 hover:bg-slate-700 border border-slate-700 px-2 py-1.5 rounded-md text-xs font-medium text-slate-200"
                title="Select Language"
              >
                <Globe className="w-3.5 h-3.5 text-slate-400" />
                <span className="uppercase font-mono-tacho">{settings.language}</span>
              </button>
              <div className="absolute right-0 top-full mt-1 hidden group-hover:block group-focus-within:block bg-slate-900 border border-slate-700 rounded-md shadow-xl py-1 z-50 min-w-[130px]">
                {languages.map((lang) => (
                  <button
                    key={lang.code}
                    onClick={() => onUpdateSettings({ ...settings, language: lang.code })}
                    className={`w-full text-left px-3 py-1.5 text-xs flex items-center justify-between hover:bg-slate-800 transition-colors ${
                      settings.language === lang.code ? 'text-blue-400 font-bold bg-slate-800/60' : 'text-slate-300'
                    }`}
                  >
                    <span>{lang.flag} {lang.label}</span>
                    {settings.language === lang.code && <ShieldCheck className="w-3.5 h-3.5 text-blue-400" />}
                  </button>
                ))}
              </div>
            </div>

          </div>

        </div>
      </div>

      {/* Driver Edit Modal */}
      {isEditingDriver && (
        <div className="fixed inset-0 bg-black/70 backdrop-blur-xs flex items-center justify-center p-4 z-50">
          <div className="bg-slate-900 border border-slate-700 rounded-xl p-5 max-w-md w-full shadow-2xl">
            <h3 className="text-base font-bold text-white mb-3 flex items-center gap-2">
              <User className="w-5 h-5 text-blue-400" /> Driver Card & Vehicle Configuration
            </h3>
            <form onSubmit={handleSaveDriverDetails} className="space-y-4">
              <div>
                <label className="block text-xs font-medium text-slate-300 mb-1">{t.driverCard} Name</label>
                <input
                  type="text"
                  value={driverNameInput}
                  onChange={(e) => setDriverNameInput(e.target.value)}
                  className="w-full bg-slate-950 border border-slate-700 rounded-md px-3 py-2 text-sm text-slate-100 focus:outline-hidden focus:border-blue-500 font-mono-tacho"
                  placeholder="e.g. Jan Kowalski"
                />
              </div>
              <div>
                <label className="block text-xs font-medium text-slate-300 mb-1">{t.vehiclePlate}</label>
                <input
                  type="text"
                  value={plateInput}
                  onChange={(e) => setPlateInput(e.target.value)}
                  className="w-full bg-slate-950 border border-slate-700 rounded-md px-3 py-2 text-sm text-slate-100 focus:outline-hidden focus:border-blue-500 font-mono-tacho uppercase"
                  placeholder="e.g. WA 84920E"
                />
              </div>
              <div className="flex justify-end gap-2 pt-2">
                <button
                  type="button"
                  onClick={() => setIsEditingDriver(false)}
                  className="px-3 py-1.5 rounded-md bg-slate-800 hover:bg-slate-700 text-slate-300 text-xs font-medium"
                >
                  {t.cancel}
                </button>
                <button
                  type="submit"
                  className="px-4 py-1.5 rounded-md bg-blue-600 hover:bg-blue-500 text-white text-xs font-bold shadow-xs"
                >
                  {t.save}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </header>
  );
};
