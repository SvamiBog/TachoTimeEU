# Git Workflow

> Adapted from ECC `rules/common/git-workflow.md` (github.com/affaan-m/ECC, MIT). `CLAUDE.md` and the project docs take precedence over this file. Conventional Commits do not apply here.

## Commits

- Commit only when the user asks, and never directly on `main`: work on a branch.
- The message is in Russian, like the existing history: a short subject saying what changed, optionally prefixed with the area (`CI: …`, `Сайт: …`, `Движок: …`); details go in the body. Examples: `Страна фирмы обязательна; рабочие дни для зарплаты (Premium)`, `CI: debug APK хранится 3 дня`.
- End the message with the `Co-Authored-By` trailer the session asks for.
- Never bypass hooks: no `--no-verify`, no `core.hooksPath` overrides. The pre-commit hook (`.githooks/`, enabled with `git config core.hooksPath .githooks`) runs `dart format` and `analyze --fatal-infos`; fix what it reports.

## Pull requests

- Open a PR as a draft: only the fast CI checks run. Mark it "Ready for review" once the changes are complete: that starts the full stage (about 90 minutes of the account's Actions quota, CI-13).
- Describe the whole branch (`git diff main...HEAD`), not only the last commit, and include a test plan.
- Merging into `main` with changes in `app/`, `packages/` or `ci.yml` ships an AAB to Google Play internal testing.
