# {{REPO_NAME}}

Professional project by {{YOUR_NAME}} / {{LLC_NAME}}.

## Purpose
Briefly describe what this solution does, who it serves, and expected outcomes.

## Using this template

1. **Generate the repo** — click *Use this template* on GitHub (or
   `gh repo create <name> --template <owner>/REPO_TEMPLATE`), then clone it.

2. **Run the bootstrap script.** A template does not copy repository settings,
   so a fresh repo starts out unprotected:

   ```bash
   ./scripts/bootstrap.sh
   ```

   It applies `.github/expected-settings.json` via the `gh` CLI: merge and
   branch behaviour, secret scanning with push protection, Dependabot alerts
   and security updates, and a `main` ruleset requiring PRs and a passing `ci`
   check while blocking force-pushes. Requires `gh` (authenticated, admin on
   the repo) and `jq`. It is idempotent — re-run it any time
   `.github/workflows/repo-audit.yml` reports drift.

3. **Fill the placeholders.** `README.md` and `SECURITY.md` ship with
   `{{REPO_NAME}}`, `{{YOUR_NAME}}`, `{{LLC_NAME}}`, and `{{SECURITY_EMAIL}}`.
   Replace all of them:

   ```bash
   grep -rn '{{' --include='*.md' .
   ```

4. **Define your smoke test.** CI fails until you do — this is deliberate.
   Add a `smoke` script to `package.json` (Node) or an executable
   `scripts/smoke.sh` (Python). It must build the app, start it, and verify it
   stays alive — not just run unit tests. See `CLAUDE.md` for what counts.

5. **Optionally enable the opt-in workflows.** Both ship disabled with `if: false`
   and a header comment explaining exactly how to turn them on:

   - `.github/workflows/memcheck.yml` — weekly memory-leak check. Needs
     project-specific scenario files (memlab for Node, tracemalloc + pytest for
     Python) before it is meaningful.
   - `.github/workflows/snippets.yml` — on README changes, suggests matches from
     the reusable-snippets library. Needs the `SNIPPETS_REPO_TOKEN` and
     `ANTHROPIC_API_KEY` secrets.

## Security
Please report vulnerabilities privately (see `SECURITY.md`).

## Development
- Create branch from `main`
- Open PR with completed checklist
- CI + CodeQL must pass

Working with Claude Code in this repo? See `CLAUDE.md` for the conventions it
follows.
