// Headless Chrome (or Edge, Chromium) through the DevTools protocol for the
// site-review agent (.claude/agents/site-review.md, section 8): the audit
// matrix, screenshots one screen at a time, media emulation and a cold load on
// a slow network. Node 22+ (built-in fetch and WebSocket), no dependencies.
//
//   node cdp.mjs <base url> <out dir> audit
//   node cdp.mjs <base url> <out dir> shots
//   node cdp.mjs <base url> <out dir> privacy
//   node cdp.mjs <base url> <out dir> motion
//   node cdp.mjs <base url> <out dir> perf <page>
//   node cdp.mjs <base url> <out dir> shot <page> <w>x<h> <name> [#anchor|y] [dpr]
//   node cdp.mjs <base url> <out dir> script <page> <w>x<h> <file.js> [shot name] [dpr]
//   node cdp.mjs <base url> <out dir> keys <page> <w>x<h> <keys> [shot prefix] [dpr]
//   node cdp.mjs <base url> <out dir> ax <page> <w>x<h>
//   node cdp.mjs <base url> <out dir> redirect
//
// <page>: en, pl, de, privacy. <out dir> must be outside the repository: the
// Chrome profile, audit/*.json and shots/*.png go there. <keys>: comma list of
// Tab, ShiftTab, Enter, Space, Escape, each optionally *N (Tab*6,Enter,Escape).
// Env: CHROME — the browser executable; ACCEPT_LANG — browser languages
// (default en-US,en; q-values are dropped); MEDIA — media features for every
// job, e.g. prefers-reduced-motion:reduce,prefers-color-scheme:dark.
import { spawn } from 'node:child_process';
import { existsSync, mkdirSync, readFileSync, writeFileSync } from 'node:fs';
import { dirname, isAbsolute, join, relative, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const here = dirname(fileURLToPath(import.meta.url));
const repo = resolve(here, '../../..');
const [base, outArg, job, ...rest] = process.argv.slice(2);
if (!base || !outArg || !job) {
  console.error('node cdp.mjs <base url> <out dir> <job> [args] — см. начало файла');
  process.exit(64);
}
const out = resolve(outArg);
// Пишем только вне репозитория: агент только читает его. Путь на другом
// диске Windows relative() возвращает абсолютным — он тоже снаружи.
const inRepo = relative(repo, out);
if (!inRepo.startsWith('..') && !isAbsolute(inRepo)) {
  console.error(`Каталог ${out} внутри репозитория — нужен временный каталог`);
  process.exit(64);
}

const chrome = [
  process.env.CHROME,
  'C:/Program Files/Google/Chrome/Application/chrome.exe',
  'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe',
  'C:/Program Files/Microsoft/Edge/Application/msedge.exe',
  '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome',
  '/usr/bin/google-chrome', '/usr/bin/chromium', '/usr/bin/chromium-browser',
].find((p) => p && existsSync(p));
if (!chrome) {
  console.error('Не найден Chrome, Edge или Chromium — задайте CHROME');
  process.exit(69);
}

// Chrome ждёт в --accept-lang простой список: «pl;q=0.8» попал бы в
// navigator.languages как есть, и переадресация корня его не узнала бы
const acceptLang = (process.env.ACCEPT_LANG || 'en-US,en')
  .split(',').map((s) => s.split(';')[0].trim()).filter(Boolean).join(',');
const mediaEnv = (process.env.MEDIA || '').split(',').filter(Boolean)
  .map((s) => {
    const [name, value] = s.split(':').map((p) => p.trim());
    return { name, value };
  });
const port = 9333 + Math.floor(Math.random() * 500);
const auditSrc = readFileSync(join(here, 'audit.js'), 'utf8');
mkdirSync(join(out, 'audit'), { recursive: true });
mkdirSync(join(out, 'shots'), { recursive: true });

const proc = spawn(chrome, [
  '--headless=new', `--remote-debugging-port=${port}`,
  `--user-data-dir=${join(out, 'chrome-profile')}`, '--no-first-run',
  '--no-default-browser-check', '--hide-scrollbars',
  `--lang=${acceptLang.split(',')[0]}`, `--accept-lang=${acceptLang}`,
  'about:blank',
], { stdio: 'ignore' });
const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

let ws;
let seq = 0;
const pending = new Map();
const waiters = [];

async function connect() {
  for (let i = 0; i < 75 && !ws; i++) {
    try {
      const list = await (await fetch(`http://127.0.0.1:${port}/json/list`)).json();
      const page = list.find((t) => t.type === 'page');
      if (page) ws = new WebSocket(page.webSocketDebuggerUrl);
    } catch {
      // Chrome ещё запускается
    }
    if (!ws) await sleep(200);
  }
  if (!ws) throw new Error('Chrome не открыл порт отладки');
  await new Promise((r) => ws.addEventListener('open', r, { once: true }));
  ws.addEventListener('message', (ev) => {
    const msg = JSON.parse(ev.data);
    if (msg.id && pending.has(msg.id)) {
      pending.get(msg.id)(msg);
      pending.delete(msg.id);
    } else if (msg.method) {
      for (const w of [...waiters]) {
        if (w.method === msg.method) {
          waiters.splice(waiters.indexOf(w), 1);
          w.resolve(msg.params);
        }
      }
    }
  });
}

function send(method, params = {}) {
  const id = ++seq;
  ws.send(JSON.stringify({ id, method, params }));
  return new Promise((resolve, reject) => {
    const timer = setTimeout(() => reject(new Error(`${method}: нет ответа 30 с`)), 30000);
    pending.set(id, (m) => {
      clearTimeout(timer);
      if (m.error) reject(new Error(`${method}: ${m.error.message}`));
      else resolve(m.result);
    });
  });
}

const once = (method) => new Promise((resolve) => waiters.push({ method, resolve }));

async function evaluate(expression) {
  const r = await send('Runtime.evaluate', { expression, awaitPromise: true, returnByValue: true });
  if (r.exceptionDetails) throw new Error(JSON.stringify(r.exceptionDetails).slice(0, 400));
  return r.result.value;
}

// Телефон — если меньшая сторона экрана меньше 600 px (и в альбомной тоже)
async function viewport(w, h, dpr = 1) {
  await send('Emulation.setDeviceMetricsOverride', {
    width: w, height: h, deviceScaleFactor: dpr, mobile: Math.min(w, h) < 600,
  });
}

// Задания, которые сами меняют media, сбрасывают его к MEDIA, а не к пустому
const media = (features) => send('Emulation.setEmulatedMedia', { features: features.length ? features : mediaEnv });

const keyDefs = {
  Tab: { key: 'Tab', code: 'Tab', windowsVirtualKeyCode: 9 },
  ShiftTab: { key: 'Tab', code: 'Tab', windowsVirtualKeyCode: 9, modifiers: 8 },
  Enter: { key: 'Enter', code: 'Enter', windowsVirtualKeyCode: 13, text: '\r' },
  Space: { key: ' ', code: 'Space', windowsVirtualKeyCode: 32, text: ' ' },
  Escape: { key: 'Escape', code: 'Escape', windowsVirtualKeyCode: 27 },
};

// Где фокус: элемент, имя, видна ли рамка и какая, внутри ли aria-hidden,
// какие <details> открыты
const focusState = `(() => {
  const e = document.activeElement;
  const open = [...document.querySelectorAll('details')].filter((d) => d.open)
    .map((d) => d.className || 'details');
  if (!e || e === document.body) return JSON.stringify({ el: 'body', open, hash: location.hash });
  const s = getComputedStyle(e);
  const r = e.getBoundingClientRect();
  const cls = typeof e.className === 'string' && e.className.trim() ? '.' + e.className.trim().split(/\\s+/).join('.') : '';
  return JSON.stringify({
    el: e.tagName.toLowerCase() + (e.id ? '#' + e.id : '') + cls,
    href: e.getAttribute('href') || undefined,
    text: (e.getAttribute('aria-label') || e.innerText || '').trim().replace(/\\s+/g, ' ').slice(0, 40),
    focusVisible: e.matches(':focus-visible'),
    outline: s.outlineStyle === 'none' ? 'none' : s.outlineWidth + ' ' + s.outlineStyle + ' ' + s.outlineColor,
    rect: [r.x, r.y, r.width, r.height].map(Math.round),
    ariaHidden: !!e.closest('[aria-hidden="true"]') || undefined,
    open, hash: location.hash || undefined, path: location.pathname,
  });
})()`;

// Enter на ссылке уводит на другую страницу — ждём, пока она загрузится
async function stateNow() {
  for (let i = 0; i < 4; i++) {
    try {
      return JSON.parse(await evaluate(focusState));
    } catch {
      await sleep(500);
    }
  }
  return { el: '?', error: 'page did not settle' };
}

// Нажимает клавиши по-настоящему (Input.dispatchKeyEvent), так что
// :focus-visible срабатывает как у живого пользователя. Enter и Space на
// mailto: не нажимаем — почту агент не открывает
async function press(spec, each) {
  const steps = spec.split(',').filter(Boolean).flatMap((s) => {
    const [name, times] = s.trim().split('*');
    if (!keyDefs[name]) throw new Error(`Клавиша ${name}: нужна ${Object.keys(keyDefs).join(', ')}`);
    return Array(Number(times || 1)).fill(name);
  });
  const log = [];
  for (const [i, name] of steps.entries()) {
    const { text, ...def } = keyDefs[name];
    if (text && await evaluate(`!!document.activeElement?.closest('a[href^="mailto:"]')`)) {
      log.push({ step: i + 1, key: name, skipped: 'mailto link' });
      continue;
    }
    await send('Input.dispatchKeyEvent', { type: text ? 'keyDown' : 'rawKeyDown', ...def, ...(text ? { text } : {}) });
    await send('Input.dispatchKeyEvent', { type: 'keyUp', ...def });
    await sleep(150);
    log.push({ step: i + 1, key: name, ...await stateNow() });
    if (each) await each(i + 1);
  }
  return log;
}

async function open(url) {
  const loaded = once('Page.loadEventFired');
  await send('Page.navigate', { url });
  await loaded;
  await evaluate('document.fonts.ready.then(() => 1)');
  await sleep(300);
}

async function shot(file) {
  const { data } = await send('Page.captureScreenshot', { format: 'png' });
  const path = join(out, 'shots', file);
  writeFileSync(path, Buffer.from(data, 'base64'));
  console.log(path);
}

async function scrollTo(y) {
  await evaluate(`window.scrollTo({ top: ${y}, behavior: 'instant' }); scrollY`);
  await sleep(200);
}

// Страница экранами сверху вниз; шаг на 90 px меньше экрана — иначе липкая
// шапка (78 px) прячет полосы между снимками
async function screens(prefix, h) {
  const total = await evaluate('document.documentElement.scrollHeight');
  for (let y = 0, n = 1; ; y += h - 90, n++) {
    await scrollTo(y);
    await shot(`${prefix}-${String(n).padStart(2, '0')}.png`);
    if (y + h >= total) break;
  }
}

async function audit(name) {
  const json = await evaluate(auditSrc);
  writeFileSync(join(out, 'audit', `${name}.json`), json);
  return JSON.parse(json);
}

const pages = { en: '', pl: 'pl/', de: 'de/', privacy: 'privacy/' };
const url = (page) => {
  if (!(page in pages)) throw new Error(`Страница ${page}: нужна en, pl, de или privacy`);
  return new URL(pages[page], base).href;
};
const size = (s) => s.split('x').map(Number);
// 640×400 — масштаб 200 % у экрана 1280×800; 400 % — это ширина 320
const sizes = [[320, 640], [360, 780], [412, 915], [915, 412], [768, 1024], [1280, 800], [1920, 1080], [640, 400]];
// WCAG 1.4.12: интервалы текста
const textSpacing = `(() => { const s = document.createElement('style');
  s.textContent = '* { line-height: 1.5 !important; letter-spacing: .12em !important; word-spacing: .16em !important; } p { margin-bottom: 2em !important; }';
  document.head.append(s); return 1; })()`;

const jobs = {
  async audit() {
    const summary = {};
    const brief = (a) => ({
      scrollWidth: a.scrollWidth, vw: a.vw, overflow: a.overflow, spill: a.spill,
      contrast: a.contrast, targets: a.targets, missingGlyphs: a.missingGlyphs, anchors: a.anchors,
    });
    for (const page of Object.keys(pages)) {
      for (const [w, h] of sizes) {
        await viewport(w, h, w === 640 ? 2 : 1);
        await open(url(page));
        summary[`${page}-${w}x${h}`] = brief(await audit(`${page}-${w}x${h}`));
      }
      for (const [w, h] of [[320, 640], [360, 780], [1280, 800]]) {
        await viewport(w, h);
        await open(url(page));
        await evaluate(textSpacing);
        await sleep(200);
        const a = await audit(`spacing-${page}-${w}x${h}`);
        summary[`spacing-${page}-${w}x${h}`] = { scrollWidth: a.scrollWidth, vw: a.vw, overflow: a.overflow, spill: a.spill };
      }
    }
    await media([{ name: 'prefers-color-scheme', value: 'dark' }]);
    for (const [w, h] of [[320, 640], [1280, 800]]) {
      await viewport(w, h);
      await open(url('privacy'));
      summary[`privacy-dark-${w}x${h}`] = brief(await audit(`privacy-dark-${w}x${h}`));
    }
    await media([]);
    const file = join(out, 'audit', 'summary.json');
    writeFileSync(file, JSON.stringify(summary, null, 1));
    console.log(file);
  },

  async shots() {
    for (const page of ['en', 'pl', 'de']) {
      await viewport(360, 780);
      await open(url(page));
      await screens(`${page}-360x780`, 780);
    }
    for (const [w, h] of [[915, 412], [1280, 800]]) {
      await viewport(w, h);
      await open(url('de'));
      await screens(`de-${w}x${h}`, h);
    }
    for (const page of ['en', 'pl']) {
      await viewport(1280, 800);
      await open(url(page));
      await shot(`${page}-1280x800-01.png`);
    }
    for (const page of ['en', 'pl', 'de']) {
      await viewport(320, 640);
      await open(url(page));
      await shot(`${page}-320x640-01.png`);
    }
  },

  async privacy() {
    for (const scheme of ['light', 'dark']) {
      await media([{ name: 'prefers-color-scheme', value: scheme }]);
      for (const [w, h] of [[320, 640], [1280, 800]]) {
        await viewport(w, h);
        await open(url('privacy'));
        await screens(`privacy-${scheme}-${w}x${h}`, h);
      }
    }
    await media([]);
  },

  async motion() {
    const state = `JSON.stringify({
      animation: getComputedStyle(document.querySelector('.ticker-track')).animationName,
      scrollBehavior: getComputedStyle(document.documentElement).scrollBehavior,
      tickerScrollable: document.querySelector('.ticker').scrollWidth > document.querySelector('.ticker').clientWidth })`;
    await media([{ name: 'prefers-reduced-motion', value: 'reduce' }]);
    await viewport(360, 780);
    await open(url('en'));
    console.log('reduce', await evaluate(state));
    // Без анимации прокручиваемая бегущая строка может стать остановкой Tab:
    // «!» — остановка внутри aria-hidden или не ссылка, кнопка, поле
    const stops = await press('Tab*14');
    console.log('reduce tab stops', JSON.stringify(stops.map((s) =>
      (s.ariaHidden || !/^(a|button|summary|input|select|textarea)\b/.test(s.el) ? '! ' : '') + s.el)));
    await media([]);
    await open(url('en'));
    console.log('normal', await evaluate(state));
  },

  // Холодная загрузка на 360×780 при ~1,6 Мбит/с и 150 мс: FCP, LCP, CLS, байты
  async perf(page = 'en') {
    await send('Network.enable');
    await send('Network.clearBrowserCache');
    await send('Network.setCacheDisabled', { cacheDisabled: true });
    await send('Network.emulateNetworkConditions', {
      offline: false, latency: 150, downloadThroughput: 1.6e6 / 8, uploadThroughput: 750e3 / 8,
    });
    const bytes = [];
    ws.addEventListener('message', (ev) => {
      const m = JSON.parse(ev.data);
      if (m.method === 'Network.loadingFinished') bytes.push(m.params.encodedDataLength);
    });
    await viewport(360, 780);
    await open(url(page));
    await sleep(4000);
    console.log(await evaluate(`new Promise((done) => {
      const r = { cls: 0, shifts: [], lcp: null };
      new PerformanceObserver((l) => { for (const e of l.getEntries()) if (!e.hadRecentInput) {
        r.cls += e.value;
        r.shifts.push([+e.value.toFixed(4), Math.round(e.startTime), (e.sources || []).map((s) => s.node ? (s.node.className || s.node.nodeName) : '?').join(',')]);
      } }).observe({ type: 'layout-shift', buffered: true });
      new PerformanceObserver((l) => { const e = l.getEntries().pop();
        r.lcp = [Math.round(e.startTime), e.element ? (e.element.className || e.element.tagName) : '?'];
      }).observe({ type: 'largest-contentful-paint', buffered: true });
      r.fcp = Math.round(performance.getEntriesByName('first-contentful-paint')[0]?.startTime || 0);
      r.resources = performance.getEntriesByType('resource').map((e) => [e.name.split('/').pop(), e.transferSize, Math.round(e.responseEnd)]);
      setTimeout(() => done(JSON.stringify(r, null, 1)), 300);
    })`));
    console.log('bytes', bytes.reduce((a, b) => a + b, 0), 'requests', bytes.length);
  },

  async shot(page, wh, name, where, dpr) {
    const [w, h] = size(wh);
    await viewport(w, h, Number(dpr || 1));
    await open(url(page));
    if (/^\d+$/.test(where || '')) await scrollTo(Number(where));
    else if (where) {
      await evaluate(`location.hash = ${JSON.stringify(where)}; 1`);
      await sleep(800);
    }
    console.log(await evaluate('JSON.stringify({ y: scrollY, height: document.documentElement.scrollHeight })'));
    await shot(`${name}.png`);
  },

  async script(page, wh, file, name, dpr) {
    const [w, h] = size(wh);
    await viewport(w, h, Number(dpr || 1));
    await open(url(page));
    console.log(await evaluate(readFileSync(resolve(file), 'utf8')));
    if (name) {
      await sleep(300);
      await shot(`${name}.png`);
    }
  },

  // Клавиатура: после каждого нажатия — где фокус и видна ли рамка; с
  // префиксом — снимок после каждого шага
  async keys(page, wh, spec = 'Tab*10', prefix, dpr) {
    const [w, h] = size(wh);
    await viewport(w, h, Number(dpr || 1));
    await open(url(page));
    const each = prefix ? (n) => shot(`${prefix}-${String(n).padStart(2, '0')}.png`) : null;
    for (const step of await press(spec, each)) console.log(JSON.stringify(step));
  },

  // Дерево доступности, как его получит экранный диктор: без aria-hidden и
  // display:none, с вычисленными именами. Текст, повторяющий имя родителя,
  // не дублируется
  async ax(page, wh) {
    const [w, h] = size(wh);
    await viewport(w, h);
    await open(url(page));
    await send('Accessibility.enable');
    const { nodes } = await send('Accessibility.getFullAXTree');
    const byId = new Map(nodes.map((n) => [n.nodeId, n]));
    const quiet = new Set(['generic', 'none', 'InlineTextBox', 'LineBreak']);
    const lines = [];
    const walk = (n, depth, parentName) => {
      const role = n.role?.value || '?';
      const name = (n.name?.value || '').replace(/\s+/g, ' ').trim();
      const shown = !n.ignored && !quiet.has(role) && !(role === 'StaticText' && name === parentName);
      if (shown) lines.push(`${'  '.repeat(depth)}${role} "${name}"`);
      for (const c of n.childIds || []) {
        const child = byId.get(c);
        if (child) walk(child, shown ? depth + 1 : depth, shown ? name : parentName);
      }
    };
    for (const root of nodes.filter((n) => !n.parentId)) walk(root, 0, '');
    const file = join(out, 'audit', `ax-${page}-${w}x${h}.txt`);
    writeFileSync(file, lines.join('\n'));
    console.log(file, lines.length, 'lines');
  },

  // Куда корень сайта отправляет браузер с языками ACCEPT_LANG
  async redirect() {
    await viewport(360, 780);
    await open(new URL('/', base).href);
    await sleep(500);
    console.log(acceptLang, '→', await evaluate('location.pathname'));
  },
};

try {
  if (!jobs[job]) throw new Error(`Неизвестная задача ${job}`);
  await connect();
  await send('Page.enable');
  await send('Runtime.enable');
  await media([]);
  await jobs[job](...rest);
} catch (e) {
  console.error(e.message);
  process.exitCode = 1;
} finally {
  ws?.close();
  proc.kill();
}
