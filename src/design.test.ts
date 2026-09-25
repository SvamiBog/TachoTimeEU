/// <reference types="vite/client" />
// Интерфейс веб-прототипа соответствует дизайну: CSS-токены совпадают
// с docs/design/tokens.json, шрифты — Onest и JetBrains Mono, в компонентах
// нет цветов hex-кодом (только классы на токенах).

import { describe, expect, it } from 'vitest';
import tokens from '../docs/design/tokens.json';

// Vitest отдаёт CSS через ?raw пустой строкой — читаем файл напрямую
const fs: { readFileSync(path: URL, encoding: 'utf-8'): string } = await import('node:fs' as string);
const css = fs.readFileSync(new URL('./index.css', import.meta.url), 'utf-8');

const components = import.meta.glob<string>(['./components/**/*.tsx', './App.tsx'], {
  query: '?raw',
  import: 'default',
  eager: true,
});

type ColorToken = keyof typeof tokens.color;

// CSS-переменная прототипа → токен дизайна
const cssToToken: Record<string, ColorToken> = {
  bg: 'background',
  surface: 'surface',
  surface2: 'surface2',
  line: 'line',
  fg: 'text',
  muted: 'textSecondary',
  drive: 'drive',
  rest: 'rest',
  work: 'work',
  poa: 'available',
  'warn-bg': 'warningBg',
  'warn-fg': 'warningText',
  'err-bg': 'errorBg',
  'err-fg': 'errorText',
  'switch-off': 'switchOff',
  scrim: 'scrim',
};

/** Переменные --tt-* из блока CSS с данным селектором. */
function cssVars(selector: string): Record<string, string> {
  const start = css.indexOf(`${selector} {`);
  expect(start, `нет блока ${selector}`).toBeGreaterThanOrEqual(0);
  const body = css.slice(start, css.indexOf('}', start));
  return Object.fromEntries([...body.matchAll(/--tt-([\w-]+):\s*(#[0-9a-fA-F]{6})/g)].map((m) => [m[1], m[2].toUpperCase()]));
}

describe('веб-прототип: токены', () => {
  it('каждый цвет из tokens.json есть в CSS', () => {
    expect(new Set(Object.values(cssToToken))).toEqual(new Set(Object.keys(tokens.color)));
  });

  it.each([
    ['dark', ':root'],
    ['light', ':root[data-theme="light"]'],
  ] as const)('тема %s совпадает с tokens.json', (theme, selector) => {
    const vars = cssVars(selector);
    for (const [name, token] of Object.entries(cssToToken)) {
      expect(vars[name], `--tt-${name} (${token})`).toBe(tokens.color[token][theme].toUpperCase());
    }
  });

  it('тёмная тема по умолчанию', () => {
    expect(tokens.defaultTheme).toBe('dark');
    expect(cssVars(':root').bg).toBe(tokens.color.background.dark.toUpperCase());
  });

  it('шрифты: Onest для интерфейса, JetBrains Mono для цифр', () => {
    expect(css).toMatch(new RegExp(`--font-sans:\\s*'${tokens.font.ui}'`));
    expect(css).toMatch(new RegExp(`--font-mono:\\s*'${tokens.font.numeric}'`));
  });
});

describe('веб-прототип: компоненты', () => {
  it('файлы компонентов найдены и прочитаны', () => {
    expect(Object.keys(components).length).toBeGreaterThan(5);
    for (const [file, source] of Object.entries(components)) expect(source, file).toContain('className');
  });

  it('цвета только через классы на токенах, без hex-кодов', () => {
    const found = Object.entries(components).flatMap(([file, source]) =>
      source
        .split('\n')
        .map((line, i) => ({ line: line.replace(/\/\/.*$/, ''), n: i + 1 }))
        .filter(({ line }) => /#[0-9a-fA-F]{3,8}\b/.test(line))
        .map(({ line, n }) => `${file}:${n} — ${line.trim()}`),
    );
    expect(found, found.join('\n')).toEqual([]);
  });
});
