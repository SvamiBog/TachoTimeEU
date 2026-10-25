#!/usr/bin/env node
// PostToolUse hook: runs `dart format` on a Dart file right after Claude edits
// it — the same check the pre-commit hook does, only earlier. Reads the hook
// payload from stdin and never blocks: exit code 0.
//
// Dart comes from DART_EXE when it is set (for example in
// .claude/settings.local.json, when PATH has no SDK), otherwise from PATH.
'use strict';

const fs = require('fs');
const path = require('path');
const { spawnSync } = require('child_process');

/** dart.exe without a shell: on Windows PATH holds flutter\bin\dart.bat. */
function resolveDart() {
  if (process.env.DART_EXE) return process.env.DART_EXE;
  if (process.platform !== 'win32') return 'dart';
  const where = spawnSync('where', ['dart'], { encoding: 'utf8' });
  for (const line of (where.stdout || '').split(/\r?\n/).filter(Boolean)) {
    if (/dart\.exe$/i.test(line)) return line;
    // flutter\bin\dart.bat → flutter\bin\cache\dart-sdk\bin\dart.exe
    const sdk = path.join(path.dirname(line), 'cache', 'dart-sdk', 'bin', 'dart.exe');
    if (fs.existsSync(sdk)) return sdk;
  }
  return null;
}

let input = '';
process.stdin.setEncoding('utf8');
process.stdin.on('data', (chunk) => {
  input += chunk;
});
process.stdin.on('end', () => {
  let file;
  try {
    file = JSON.parse(input).tool_input?.file_path;
  } catch {
    return;
  }
  // Drift generates *.g.dart; the pre-commit hook skips them too.
  if (!file || !file.endsWith('.dart') || file.endsWith('.g.dart')) return;
  if (!fs.existsSync(file)) return;
  const dart = resolveDart();
  const result = dart
    ? spawnSync(dart, ['format', file], { encoding: 'utf8', timeout: 30000 })
    : null;
  if (!result || result.error) {
    process.stderr.write(
      '[dart-format] dart не найден: задайте DART_EXE или добавьте Flutter SDK в PATH\n',
    );
  } else if (result.status !== 0) {
    process.stderr.write(`[dart-format] ${(result.stderr || result.stdout).trim()}\n`);
  }
});
