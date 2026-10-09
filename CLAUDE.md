# CLAUDE.md

Guidance for Claude Code when working in this repository.

## Repo conventions

- **All changes land through a pull request into `main`.** Never commit directly
  to `main`; branch first. A ruleset enforces this (see
  `.github/expected-settings.json`).
- **CI must pass before merge.** The `ci` status check is required. If CI is
  failing, fix the cause — do not disable, skip, or weaken the check.
- **Never commit `.env`, credentials, tokens, or any other secret.** If you need
  a value that looks like a secret, add it as a placeholder and tell me to set
  it as a repository secret. Secret scanning with push protection is enabled;
  treat a push-protection block as a real finding, not an obstacle to work
  around.
- **Never modify anything under `.github/workflows/` without asking me first.**
  This includes adding, deleting, renaming, or editing a workflow. Propose the
  change and wait for approval. The same applies to
  `.github/expected-settings.json` and `scripts/bootstrap.sh`, which together
  define the repo's protections.

## Workbook mode (this is a self-guided learning project)

The application is written by the owner, module by module, from `workbook/`.
Unless they say the exact phrase `EXIT WORKBOOK MODE`, follow the teaching
contract in `workbook/README.md` (sections 1 to 3): review and explain, do not
write the implementation for workbook assignments, and give hints only one level
at a time, only when asked. When they are stuck, point them to `workbook/HINTS.md`
(stuck protocol, hint request format) and `workbook/RESOURCES.md` (reading). Repo
plumbing, docs, and workbook upkeep are not assignments and can be done directly.

## Smoke tests are mandatory

Every project must define its own smoke test, and CI enforces this — the smoke
step fails the build when one is missing.

- **Node projects:** a `smoke` script in `package.json`.
- **Python projects:** an executable `scripts/smoke.sh`.

A smoke test is not a unit test. It must **build the app, start it, and verify
it stays alive** — for example: start the process, poll a health endpoint (or
check the port is accepting connections) for a fixed window, and fail if the
process exits or never becomes healthy. Always shut the process down again so CI
does not hang.

If a project genuinely has no runnable surface (a pure library), the smoke test
should still exercise the real entry point — import the built artifact and call
its primary API — rather than being stubbed out to `exit 0`.

## Snippet library — check it before writing new code

Before implementing new functionality, consult the **`reusable-snippets`** repo
(`TipsyCanoe/cs-reusable-snippets`):

1. Read `SNIPPETS_INDEX.md` for the catalogue.
2. For game projects, also read `unity-csharp/MANIFEST.md`.

**A match in a different language still counts.** Do not dismiss a snippet
because it is written in another language — treat it as a **PORT candidate** and
say so explicitly in your response, rather than silently starting from scratch.

Report every match using this triage vocabulary:

| Verdict | Meaning |
| --- | --- |
| **use-as-is** | Same language, fits the need. Copy it in, adjusting only names and config. |
| **port** | Right approach, wrong language or framework. Translate it, keeping the structure and edge-case handling intact. |
| **rewrite-reference** | Solves a related problem or has aged out, but the approach is informative. Write fresh code, and say what you took from it. |

State the verdict and the source path for each relevant snippet before writing
code. If nothing in the library applies, say that explicitly — "no snippet
match" is a useful answer, and it tells me the new code is a candidate to
contribute back.

## Placeholders

`README.md` and `SECURITY.md` ship with `{{PLACEHOLDER}}` values
(`{{REPO_NAME}}`, `{{YOUR_NAME}}`, `{{LLC_NAME}}`, `{{SECURITY_EMAIL}}`). These
must all be filled during repo setup. If you see a `{{...}}` token still in
place, flag it — do not invent a value for it.
