# Agent Orchestration

> Adapted from ECC `rules/common/agents.md` (github.com/affaan-m/ECC, MIT). `CLAUDE.md` and the project docs take precedence over this file.

The ECC agents, skills and commands TachoGo uses are copied into `.claude/agents/`, `.claude/skills/` and `.claude/commands/` with the `ecc-` prefix (source and license: `.claude/ECC-NOTICE.md`), so they work the same locally and in cloud sessions. Invoke an agent through the Agent tool, for example `Agent(subagent_type: "ecc-planner", prompt: "...")`.

| Agent | Purpose | When to use |
|-------|---------|-------------|
| ecc-planner | Implementation plan | Features or refactors that touch several files |
| ecc-tdd-guide | Test-first development | New behaviour and bug fixes |
| ecc-code-reviewer | General code review | After a non-trivial change |
| ecc-flutter-reviewer | Flutter/Dart review | Changes in `app/` or `packages/` |
| ecc-dart-build-resolver | Analyzer and build errors | `dart analyze`, `flutter analyze` or build failures |
| ecc-security-reviewer | Security review | Premium and licensing, backup and transfer, export, network, permissions, crash reporting and analytics |

Commands: `/ecc-plan`, `/ecc-code-review`, `/ecc-flutter-review`, `/ecc-flutter-build`, `/ecc-flutter-test`, `/ecc-test-coverage`, `/ecc-save-session`, `/ecc-resume-session`. Skills: `ecc-tdd-workflow`, `ecc-dart-flutter-patterns`, `ecc-flutter-dart-code-review`, `ecc-context-budget`.

## When to delegate

- Delegate when the user asks, or when an `ecc-` command or skill does it as part of its workflow.
- Do not start agents on your own for routine edits: each one starts with an empty context, re-reads the code and costs tokens. Small, local changes stay in the main session.
- Give an agent the goal, the files or area, and what "done" means, not just the query.
- Run agents in parallel only for independent work that touches different files.

## Delegation Completion Contract

Applies to every agent at every depth:

1. **A subagent's final message is its deliverable.** It never ends with "waiting for background agents": results of children that are still running get lost.
2. **If you delegate, you collect.** Wait for the results, check them, integrate them, then answer.
3. **Decompose only when the work does not fit one context.** Do not re-delegate a task already sized for one agent.
