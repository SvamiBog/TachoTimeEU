# ECC components in this repository

Some Claude Code files under `.claude/` are adapted from ECC (github.com/affaan-m/ECC), version 2.2.3, commit `c05b2d6614f62f6db0047669aa4eefb223d478f9`, under the MIT License below. Each file names its source in the first lines. `CLAUDE.md` and `.claude/rules/` take precedence over them.

They are copied into the repository rather than installed as the `ecc@ecc` plugin because cloud sessions of Claude Code load only the repository's files, never plugins.

| File | Source in ECC | Changes |
|------|---------------|---------|
| `.claude/agents/ecc-planner.md` | `agents/planner.md` | `ecc-` prefix, project note |
| `.claude/agents/ecc-tdd-guide.md` | `agents/tdd-guide.md` | rewritten for Dart and Flutter |
| `.claude/agents/ecc-code-reviewer.md` | `agents/code-reviewer.md` | prefix, project conventions |
| `.claude/agents/ecc-flutter-reviewer.md` | `agents/flutter-reviewer.md` | prefix, fakes instead of mocks |
| `.claude/agents/ecc-dart-build-resolver.md` | `agents/dart-build-resolver.md` | prefix, dependency changes only with agreement |
| `.claude/agents/ecc-security-reviewer.md` | `agents/security-reviewer.md` | prefix, project risk areas and commands |
| `.claude/skills/ecc-tdd-workflow/SKILL.md` | `skills/tdd-workflow/SKILL.md` | rewritten for Dart and Flutter, no checkpoint commits |
| `.claude/skills/ecc-dart-flutter-patterns/SKILL.md` | `skills/dart-flutter-patterns/SKILL.md` | prefix, project note |
| `.claude/skills/ecc-flutter-dart-code-review/SKILL.md` | `skills/flutter-dart-code-review/SKILL.md` | prefix, project note |
| `.claude/skills/ecc-context-budget/SKILL.md` | `skills/context-budget/SKILL.md` | prefix, project paths |
| `.claude/commands/ecc-plan.md` | `commands/plan.md` | prefix, links to components the project has |
| `.claude/commands/ecc-code-review.md` | `commands/code-review.md` | prefix, project checks, publishing only with permission |
| `.claude/commands/ecc-flutter-review.md` | `commands/flutter-review.md` | prefix |
| `.claude/commands/ecc-flutter-build.md` | `commands/flutter-build.md` | prefix, Android builds only in CI |
| `.claude/commands/ecc-flutter-test.md` | `commands/flutter-test.md` | prefix, integration tests on `flutter-tester` |
| `.claude/commands/ecc-test-coverage.md` | `commands/test-coverage.md` | prefix, project coverage commands and thresholds |
| `.claude/commands/ecc-save-session.md` | `commands/save-session.md` | prefix, note on cloud sessions |
| `.claude/commands/ecc-resume-session.md` | `commands/resume-session.md` | prefix, note on cloud sessions |
| `.claude/rules/*.md`, `.claude/rules/dart/*.md` | `rules/common/`, `rules/dart/` | rewritten for TachoGo |

ECC's hooks and scripts are not included. When updating to a newer ECC version, review its changes first and re-apply these adaptations.

## License

MIT License

Copyright (c) 2026 Affaan Mustafa

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
