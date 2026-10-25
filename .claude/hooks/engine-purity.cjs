#!/usr/bin/env node
// PreToolUse hook (TachoGo, ECC step 4): blocks an Edit/Write/MultiEdit that
// would put `package:flutter` or `dart:ui` into packages/tacho_engine (lib/,
// test/, tool/ — the folders the pre-commit hook and CI check) or a Flutter
// dependency into its pubspec.yaml. The engine stays pure Dart (CLAUDE.md,
// "Главное правило кода"). Exit code 2 blocks the call and shows stderr to
// Claude; anything else passes. Writes through Bash are not seen here — the
// pre-commit hook and CI still catch them.
'use strict';

const SOURCE = /package:flutter|dart:ui/;
const PUBSPEC = /^\s*(flutter|flutter_test)\s*:|sdk:\s*flutter/m;

/** Path inside packages/tacho_engine with forward slashes, or null. */
function enginePath(file) {
  const norm = String(file || '').replace(/\\/g, '/');
  const i = norm.toLowerCase().lastIndexOf('/packages/tacho_engine/');
  if (i < 0) return null;
  return norm.slice(i + '/packages/tacho_engine/'.length);
}

/** Text the call would add: Write content or every Edit/MultiEdit new_string. */
function newText(toolInput) {
  if (typeof toolInput.content === 'string') return toolInput.content;
  const parts = [];
  if (typeof toolInput.new_string === 'string') parts.push(toolInput.new_string);
  for (const edit of toolInput.edits || []) {
    if (typeof edit.new_string === 'string') parts.push(edit.new_string);
  }
  return parts.join('\n');
}

let input = '';
process.stdin.setEncoding('utf8');
process.stdin.on('data', (chunk) => {
  input += chunk;
});
process.stdin.on('end', () => {
  let payload;
  try {
    payload = JSON.parse(input);
  } catch {
    return;
  }
  const toolInput = payload.tool_input || {};
  const rel = enginePath(toolInput.file_path);
  if (rel === null) return;
  const text = newText(toolInput);
  const isSource = /^(lib|test|tool)\//.test(rel);
  const isPubspec = rel === 'pubspec.yaml';
  if (isSource && SOURCE.test(text)) {
    process.stderr.write(
      `Заблокировано: tacho_engine должен оставаться чистым Dart — ` +
        `в packages/tacho_engine/${rel} нельзя package:flutter и dart:ui ` +
        `(CLAUDE.md, «Главное правило кода»). Логику с Flutter держите в app/.\n`,
    );
    process.exit(2);
  }
  if (isPubspec && PUBSPEC.test(text)) {
    process.stderr.write(
      'Заблокировано: у tacho_engine не может быть зависимостей от Flutter ' +
        '(packages/tacho_engine/pubspec.yaml, CLAUDE.md, «Главное правило кода»).\n',
    );
    process.exit(2);
  }
});
