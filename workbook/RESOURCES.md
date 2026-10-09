# Resources

Where to look online when you are stuck, or before you start a module. Everything here is a *reference to read*, not a solution to copy. It complements the "Research / documentation" list (section 3) in each module of [`MODULES.md`](MODULES.md), and it is meant to be read before you ask for a hint ([`HINTS.md`](HINTS.md)).

> **Link status:** these URLs were written from memory of stable documentation roots and were **not** link-checked when this file was added (the authoring environment could not reach external sites). If one is dead, search the page title; and fix the entry here when you find the new address. Prefer the official docs over blog posts, and check the version in the URL matches the version you installed.

---

## 1. Getting good at getting unstuck

| Need | Where |
|---|---|
| Search an exact error | Put the message in quotes, add the library name and your major version. Drop file paths and IDs from the message first. |
| Library behaviour | The library's own docs, then its GitHub *Issues* and *Discussions* tabs (search closed issues too). |
| Real-world answers | Stack Overflow / Stack Exchange (`database administrators` for Postgres design questions). Check the date and the version. |
| Language reference | [Python docs](https://docs.python.org/3/), [TypeScript handbook](https://www.typescriptlang.org/docs/handbook/intro.html), [MDN Web Docs](https://developer.mozilla.org/) |
| Quick experiments | A scratch file, a Python REPL, `psql`, browser devtools, `curl`. Reproduce before you theorize. |
| Reading someone else's code | The library's own test suite is often the best usage example. |

Habits that pay back: read the whole error, change one thing per run, keep a scratch file for reproductions, and write the question down before you ask it (see the stuck protocol in `HINTS.md`).

---

## 2. Project-wide references

### Git and GitHub (Module 0)
- Pro Git (free book): https://git-scm.com/book
- GitHub Docs: https://docs.github.com
- GitHub's `.gitignore` templates: https://github.com/github/gitignore
- Conventional Commits (optional message style): https://www.conventionalcommits.org
- Architecture Decision Records, for your `docs/decisions/` notes: https://adr.github.io

### Python tooling (Module 0, 5, 7, 15)
- `venv`: https://docs.python.org/3/library/venv.html
- `uv`: https://docs.astral.sh/uv/
- pytest: https://docs.pytest.org
- Ruff (lint/format): https://docs.astral.sh/ruff/

### Node and web tooling (Module 0, 8, 12)
- Node: https://nodejs.org
- Vite: https://vite.dev/guide/
- React: https://react.dev
- TypeScript: https://www.typescriptlang.org/docs/

### Writing and design
- Semantic Versioning: https://semver.org
- Keep a Changelog: https://keepachangelog.com

---

## 3. By module

Items marked **(from the module)** repeat the module's own research list so everything is in one place.

### Milestone A. Foundations
**Module 0: Environment, repository, journal, Git workflow**
- Pro Git chapters on branching, and merging vs rebasing **(from the module)**: https://git-scm.com/book/en/v2/Git-Branching-Basic-Branching-and-Merging
- Atlassian's merge vs rebase comparison: https://www.atlassian.com/git/tutorials/merging-vs-rebasing
- `uv`, `venv`, Poetry docs, to compare lockfiles and speed **(from the module)**
- `.gitignore` templates for Python and Node **(from the module)**
- pre-commit (optional challenge): https://pre-commit.com
- gitleaks, a secret scanner (optional challenge, and Module 16): https://github.com/gitleaks/gitleaks

**Module 1: Requirements and application plan**
- User stories and acceptance criteria: search "user story acceptance criteria Given When Then"
- MoSCoW prioritization **(from the module)**: https://en.wikipedia.org/wiki/MoSCoW_method
- Existing personal-library apps to compare (look, don't copy): Goodreads, StoryGraph, LibraryThing, Libib, Calibre.

### Milestone B. Data layer
**Module 2: Domain modeling**
- FRBR Group 1 entities (Work, Expression, Manifestation, Item) **(from the module)**: search "FRBR Library of Congress summary"
- Open Library on works vs editions **(from the module)**: https://openlibrary.org/help (search "works and editions")
- Conceptual vs logical vs physical data models: search the three terms together.

**Module 3: Relational database design**
- PostgreSQL docs: constraints, data types, indexes **(from the module)**: https://www.postgresql.org/docs/current/ddl-constraints.html, https://www.postgresql.org/docs/current/datatype.html, https://www.postgresql.org/docs/current/indexes.html
- Partial and expression indexes: https://www.postgresql.org/docs/current/indexes-partial.html, https://www.postgresql.org/docs/current/indexes-expressional.html
- Text-based ER diagrams that live in Git: Mermaid https://mermaid.js.org, DBML https://dbml.dbdiagram.io
- Crow's foot notation: search "crow's foot notation ER diagram".

**Module 4: PostgreSQL / Neon implementation**
- Neon docs: connection strings, pooled vs direct, branching, roles **(from the module)**: https://neon.com/docs
- Your migration tool's getting-started guide **(from the module)**. If you choose Alembic: https://alembic.sqlalchemy.org
- PostgreSQL `CREATE TABLE`, `ALTER TABLE`, and `psql` meta-commands **(from the module)**: https://www.postgresql.org/docs/current/sql-createtable.html, https://www.postgresql.org/docs/current/app-psql.html

### Milestone C. Lookup core
**Module 5: ISBN fundamentals**
- ISBN Users' Manual (check digit algorithms) **(from the module)**: https://www.isbn-international.org
- pytest: test discovery, parametrize, `pytest.raises` **(from the module)**: https://docs.pytest.org
- Python `typing` and your choice of failure representation **(from the module)**: https://docs.python.org/3/library/typing.html

**Module 6: External metadata APIs**
- Open Library developer docs: Books, ISBN, Search, Covers APIs and usage guidelines **(from the module)**: https://openlibrary.org/developers/api
- Google Books API, volumes search and quotas **(from the module)**: https://developers.google.com/books
- `httpx` async client, timeouts, exceptions **(from the module)**: https://www.python-httpx.org
- Pydantic models for external data **(from the module)**: https://docs.pydantic.dev
- Hand-explore every endpoint with `curl` first and save sample responses to `docs/api-notes/`.

**Module 7: Backend / API**
- FastAPI: bigger applications, dependencies, error handling, CORS, testing **(from the module)**: https://fastapi.tiangolo.com/tutorial/
- Settings from environment variables **(from the module)**: https://docs.pydantic.dev/latest/concepts/pydantic_settings/
- Your data access library's async PostgreSQL docs (SQLAlchemy https://docs.sqlalchemy.org, or psycopg https://www.psycopg.org/psycopg3/docs/).
- HTTP status codes: https://developer.mozilla.org/en-US/docs/Web/HTTP/Status

### Milestone D. First usable version
**Module 8: Barcode scanner input**
- Eyoyo EYH2 manual (output mode, terminator, add-on code) **(from the module)**: use the manual that shipped with the scanner, or the manufacturer's support page for the EYH2.
- Vite React + TypeScript template **(from the module)**: https://vite.dev/guide/
- MDN `KeyboardEvent` and `document.activeElement` **(from the module)**: https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent, https://developer.mozilla.org/en-US/docs/Web/API/Document/activeElement
- TypeScript narrowing and discriminated unions **(from the module)**: https://www.typescriptlang.org/docs/handbook/2/narrowing.html
- React Effects (cleanup, and when not to use one): https://react.dev/learn/synchronizing-with-effects, https://react.dev/learn/you-might-not-need-an-effect

**Module 9: Book ingestion pipeline**
- Transactions and rollback in your data access library **(from the module)**.
- PostgreSQL `INSERT ... ON CONFLICT` **(from the module)**: https://www.postgresql.org/docs/current/sql-insert.html
- Forms in React **(from the module)**: https://react.dev/learn (Responding to Events, Managing State)
- QR code libraries, e.g. Python `qrcode` https://pypi.org/project/qrcode/ **(from the module)**

**Module 10: Duplicate and edition handling**
- Unique constraints and partial unique indexes **(from the module)**: https://www.postgresql.org/docs/current/indexes-unique.html, https://www.postgresql.org/docs/current/indexes-partial.html
- `pg_trgm` and whether Neon supports it **(from the module)**: https://www.postgresql.org/docs/current/pgtrgm.html and the Neon extensions page.
- Open Library work keys across editions: test with a book you own twice.

### Milestone E. A library you use
**Module 11: Genre classification**
- Groq API docs: chat completions, models, structured output, rate limits **(from the module)**: https://console.groq.com/docs
- Prompting for classification: search "LLM classification prompt label definitions few-shot".
- Schema for genre (revisit your Module 3 design).

**Module 12: Library UI**
- React Router and search params **(from the module)**: https://reactrouter.com
- Data fetching approach of your choice, e.g. TanStack Query https://tanstack.com/query **(from the module)**
- PostgreSQL pattern matching, full-text search, `pg_trgm` **(from the module)**: https://www.postgresql.org/docs/current/textsearch.html
- Accessibility basics **(from the module)**: https://www.w3.org/WAI/ARIA/apg/ and MDN's accessibility guides.

**Module 13: Reading state, history, progress, personal fields**
- Temporal and history data in relational databases: search "slowly changing dimension" and "temporal tables PostgreSQL" **(from the module)**
- Neon branching for migration rehearsal **(from the module)**: https://neon.com/docs
- PostgreSQL date/time and range types **(from the module)**: https://www.postgresql.org/docs/current/datatype-datetime.html, https://www.postgresql.org/docs/current/rangetypes.html

**Module 14: Series support and rule-based suggestions**
- Window functions and `WITH` queries **(from the module)**: https://www.postgresql.org/docs/current/functions-window.html, https://www.postgresql.org/docs/current/queries-with.html
- Sorting numeric columns, `NULLS FIRST/LAST`: https://www.postgresql.org/docs/current/queries-order.html
- Running hand-written SQL from your data access layer **(from the module)**.

### Milestone F. Hardening
**Module 15: Testing and failure handling**
- pytest fixtures, scopes, markers; an HTTP mocking library compatible with your client (for `httpx`: respx https://lundberg.github.io/respx/) **(from the module)**
- Vitest: https://vitest.dev and React Testing Library: https://testing-library.com/docs/react-testing-library/intro/ **(from the module)**
- CI workflow syntax and secrets: https://docs.github.com/actions **(from the module)**

**Module 16: Security and configuration**
- PostgreSQL `GRANT`, `REVOKE`, default privileges **(from the module)**: https://www.postgresql.org/docs/current/sql-grant.html, https://www.postgresql.org/docs/current/sql-alterdefaultprivileges.html
- OWASP Top 10 **(from the module)**: https://owasp.org/www-project-top-ten/
- OWASP Cheat Sheet Series: https://cheatsheetseries.owasp.org
- Dependency audits: `pip-audit` https://pypi.org/project/pip-audit/ and `npm audit` https://docs.npmjs.com/cli/commands/npm-audit **(from the module)**
- History secret scanning: gitleaks, TruffleHog **(from the module)**

### Milestone G. Beyond the desk
**Module 17: Mobile client**
- Expo docs: setup, development builds, camera/barcode scanning for your SDK version, permissions, environment configuration **(from the module)**: https://docs.expo.dev
- Secure token storage (SecureStore, not plain async storage) **(from the module)**: https://docs.expo.dev/versions/latest/sdk/securestore/
- React Navigation / Expo Router **(from the module)**: https://reactnavigation.org, https://docs.expo.dev/router/introduction/
- OpenAPI type generation **(from the module)**: https://openapi-ts.dev
- FastAPI security utilities **(from the module)**: https://fastapi.tiangolo.com/tutorial/security/

**Module 18: Rose / OpenClaw read-only integration**
- How OpenClaw defines tools and stores credentials **(from the module)**: use OpenClaw's own documentation.
- PostgreSQL views and granting on views **(from the module)**: https://www.postgresql.org/docs/current/sql-createview.html
- OWASP Top 10 for LLM Applications, prompt injection **(from the module)**: https://owasp.org/www-project-top-10-for-large-language-model-applications/

**Module 19: Deployment, public page, documentation, retrospective**
- Process manager or container runtime for your host (systemd https://systemd.io, or Docker https://docs.docker.com) **(from the module)**
- Netlify Functions and environment variables **(from the module)**: https://docs.netlify.com/functions/overview/
- Neon backup, restore, branch retention for your plan **(from the module)**: https://neon.com/docs
- `pg_dump` / `pg_restore` **(from the module)**: https://www.postgresql.org/docs/current/app-pgdump.html, https://www.postgresql.org/docs/current/app-pgrestore.html
- Semantic versioning and tags **(from the module)**: https://semver.org

### Milestone H. Extensions
**Module 20: Optional advanced extensions**
- Resources depend on the extension you pick. Add a subsection here when you write its spec.
- Examples: pgvector https://github.com/pgvector/pgvector; Goodreads CSV import/export format (export one of your own libraries to see the columns).

---

## 4. Your own snippet library (`cs-reusable-snippets`)

`CLAUDE.md` asks that the snippet library be checked before new code is written. This repo is in workbook mode, so these are **reference reading after you have made your own attempt**, not code to paste in. Verdicts use the `CLAUDE.md` vocabulary. Source repo: `TipsyCanoe/cs-reusable-snippets` (private).

| Module | Snippet (path in that repo) | Verdict | What to look at |
|---|---|---|---|
| 4, 7 | `databases/pg_pool.js` | port (JS to Python) | Pool configured from env vars, a `query()` wrapper, and a health check. Keep that structure; the language and driver change. |
| 4 to 7, 16 | `databases/jdbc_prepared_statement.java` | rewrite-reference | Config from a file/env and parameterized queries, as an injection-avoidance pattern. |
| 6 | `utils/simple_cache.py` | rewrite-reference | Bounded in-memory cache with simple eviction, if you decide to cache API responses. |
| 10 | `ml-nlp/text_cleaner.java` | rewrite-reference | Normalization steps for titles. Stemming and stop words are probably more than you need; the Module 10 scope note says keep normalization sane. |
| 11 | `ml-nlp/llm_batch_requests.py` | rewrite-reference | Shape of chat-completion style requests, batched. |
| 14 | `databases/sql_query_patterns.sql` | rewrite-reference | The anti-join and correlated-subquery patterns for "oldest unread" and "next in series". MySQL dialect, so check Postgres syntax. |
| 16, scripts | `databases/csv_to_postgres.py` | rewrite-reference | Chunked CSV ingest and column normalization for the `books.csv` cross-check. Your cross-check is fuzzy matching, not a bulk load. |
| 20 | `databases/pgvector_semantic_search.py` | rewrite-reference | The semantic-search extension. Credentials in it were already removed; use `DATABASE_URL`. |

No snippet matches Modules 0 to 3, 5, 8, 9, 12, 13, 15, 17 to 19. That is a "no snippet match" for those, and the finished work there is a candidate to contribute back to the library.

---

## 5. Keeping this file useful

- When a doc page finally explains your problem, add the link under the module and one line on why it helped.
- When a link dies, replace it and note the date.
- Remove anything you never opened.
