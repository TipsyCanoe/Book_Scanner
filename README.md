# Book_Scanner

Professional project by Richard Jefferson / Salish Code LLC.

## Purpose

A personal library management system for a home collection of roughly 150
books. A USB barcode scanner reads a book's ISBN, the backend fetches candidate
metadata from Open Library (with Google Books as fallback), and the book is
saved to PostgreSQL along with a personal "what I thought" blurb, reading
state, and other personal fields. A read-only public page shows the
collection.

The project is built module by module from the self-guided workbook in
[`workbook/`](workbook/README.md). Progress is tracked in
[`workbook/PROGRESS.md`](workbook/PROGRESS.md).

## Stack

| Layer | Choice |
| --- | --- |
| Backend | FastAPI (Python) |
| Web client | React + TypeScript (Vite) |
| Mobile client | Expo / React Native + TypeScript (Module 17) |
| Database | Neon PostgreSQL |
| Metadata | Open Library (primary), Google Books (fallback) |
| Genre classification | Groq Llama, with human override (Module 11) |
| Public page | Netlify function reading from Neon, view-only (Module 19) |
| Scanner | Eyoyo EYH2 USB 2D scanner (keyboard input, EAN-13 / QR) |

## Architecture

```
USB barcode scanner (keyboard input)
        |
   web client (React + TS)          mobile client (Expo)
        |                                   |
        +---------------+-------------------+
                        |
                 backend (FastAPI)
                  |              |
   Open Library / Google Books   Groq (genre)
                  |
        normalization / validation
                  |
           Neon PostgreSQL
                  |
     read-only consumers: public Netlify page, Rose / OpenClaw
```

No client ever holds database credentials. Desk writes happen on the home LAN
only; read-only consumers get their own least-privilege access.

## Repository layout

```
workbook/      project workbook: modules, progress, journal, hints, resources
docs/          requirements, domain model, ERD, decisions (from Module 1)
backend/       FastAPI app, migrations, backend tests
web/           React + TypeScript client
mobile/        Expo client
public-page/   Netlify function and view-only page
scripts/       repo bootstrap, smoke test, one-off utilities
```

Directories other than `workbook/` and `scripts/` are created as the modules
that need them are reached.

## Configuration

Required settings will be listed by name (never value) in `.env.example`,
which is added once the first setting exists. Copy it to `.env` and fill it in
locally. `.env` is git-ignored and must never be
committed.

## Repository setup

These steps come from the repo template and must be done once:

1. **Run the bootstrap script.** A template does not copy repository
   settings, so a fresh repo starts out unprotected:

   ```bash
   ./scripts/bootstrap.sh
   ```

   It applies `.github/expected-settings.json` via the `gh` CLI: merge and
   branch behaviour, secret scanning with push protection, Dependabot alerts
   and security updates, and a `main` ruleset requiring PRs and a passing `ci`
   check while blocking force-pushes. Requires `gh` (authenticated, admin on
   the repo) and `jq`. It is idempotent: re-run it any time
   `.github/workflows/repo-audit.yml` reports drift.

2. **Fill the placeholders.** `README.md`, `SECURITY.md`, and `LICENSE` ship
   with `{{...}}` values. Find any that remain with:

   ```bash
   grep -rn '{{' --include='*.md' --include='LICENSE' .
   ```

3. **Define the smoke test.** CI fails until one exists, deliberately. Add a
   `smoke` script to `package.json` (Node) or an executable `scripts/smoke.sh`
   (Python). It must build the app, start it, and verify it stays alive, not
   just run unit tests. See `CLAUDE.md` for what counts.

4. **Optionally enable the opt-in workflows.** Both ship disabled with
   `if: false` and a header comment explaining how to turn them on:

   - `.github/workflows/memcheck.yml`: weekly memory-leak check. Needs
     project-specific scenario files (memlab for Node, tracemalloc + pytest
     for Python) before it is meaningful.
   - `.github/workflows/snippets.yml`: on README changes, suggests matches
     from the reusable-snippets library. Needs the `SNIPPETS_REPO_TOKEN` and
     `ANTHROPIC_API_KEY` secrets.

## Development

- Create a branch from `main`; never commit to `main` directly.
- Open a PR with the checklist completed.
- CI (including the smoke test) and CodeQL must pass before merge.

Working with Claude Code in this repo? See `CLAUDE.md` for the conventions it
follows, and `workbook/README.md` for the workbook-mode teaching contract.

## Security

Please report vulnerabilities privately (see `SECURITY.md`).

## License

Proprietary. All rights reserved. See `LICENSE`.
