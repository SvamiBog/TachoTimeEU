/// <reference types="vitest/config" />
import { readFileSync } from 'node:fs';
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import tailwindcss from '@tailwindcss/vite';

const { version } = JSON.parse(readFileSync(new URL('./package.json', import.meta.url), 'utf-8')) as { version: string };

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react(), tailwindcss()],
  define: {
    __APP_VERSION__: JSON.stringify(version),
  },
  // Dev-сервер только на этой машине. Для проверки с телефона в той же сети:
  // npm run dev -- --host (защита от DNS rebinding остаётся включённой).
  server: {
    port: 3000,
  },
  preview: {
    port: 3000,
  },
  test: {
    include: ['src/**/*.test.ts'],
  },
});
