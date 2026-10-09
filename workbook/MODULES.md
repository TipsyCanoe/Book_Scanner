# Modules

Work through these in order. Section 10 of every module is locked: it lists the topics hints exist for, and the hints themselves are given only when you ask, one level at a time. When stuck, start with the protocol in [`HINTS.md`](HINTS.md); for reading material see [`RESOURCES.md`](RESOURCES.md).

---

# Module 0: Environment, Repository, Journal, Git Workflow

**Milestone A. Foundations**

### 1. Learning objectives
- Set up a reproducible toolchain for a Python backend and a TypeScript frontend in one repository.
- Re-establish a disciplined Git workflow: branches, small commits, meaningful messages.
- Establish secrets hygiene before any secret exists.
- Start the project journal habit.

### 2. Short reading / refresher
A solo project still benefits from a branch-per-unit-of-work flow: `main` always runs, work happens on a short-lived branch, and merging is a deliberate act. It gives you a clean history to debug against and a natural review point (you can paste a diff for review).

Commit size matters more than message style. A commit should be one logical change that you could revert without collateral damage.

Reproducibility means someone with a fresh clone can get to a working toolchain by following the README. That requires pinned language versions, an isolated Python environment, a lockfile for each ecosystem, and a `.env.example` that names every required setting without holding a value.

Secrets that reach Git history are compromised permanently, even if deleted in a later commit. The only fix is rotation. It is far cheaper to make the mistake impossible up front.

### 3. Research / documentation
- Git: branching and merging, merge vs rebase, `git log` options you find readable.
- Python environment and dependency tools: `venv` + `pip`, `uv`, Poetry. Compare lockfile support, speed, and how much tooling you want to learn.
- Node version management and the package manager you prefer.
- GitHub's maintained `.gitignore` templates for Python and Node.

### 4. Lab / implementation assignment
Create the project repository and toolchain. No application code yet.

### 5. Requirements
- A Git repository with the top-level structure from the workbook README (empty directories may hold a placeholder file).
- All the workbook files committed under `workbook/`.
- Python and Node versions pinned in a way your chosen tools respect.
- An isolated Python environment that is not committed.
- A `.gitignore` covering Python, Node, editor files, and environment files.
- A `.env.example` (it can be nearly empty for now).
- At least one piece of work done on a branch and merged into `main`.
- A starter project `README.md` with setup steps that are true today.

### 6. Deliverables
- The repository, pushed to a remote.
- A short note in `docs/decisions/` recording your Python tooling choice and your branching convention.
- Journal entry 0.

### 7. Checkpoint
Clone the repository into a fresh directory and follow only your own README. If you reach a verified toolchain without remembering anything that is not written down, you are ready.

### 8. Tests / acceptance criteria
- Creating a file named `.env` in the repo root does not make it appear in `git status`.
- `git log` shows at least three commits, each describing a single change.
- `main` contains a merge (or fast-forward) from at least one feature branch.
- The fresh-clone checkpoint passes.

### 9. Common failure modes
- One enormous initial commit.
- Global package installs that make the project work only on this machine.
- A `.gitignore` added after the files it should have ignored were committed.
- Unpinned language versions.

### 10. Hint ladder (locked)
Topics: choosing a Python tool, what to ignore, pinning versions, recovering from a bad commit.

### 11. Optional challenge
Add a pre-commit hook that blocks commits containing likely secrets, and one that runs a formatter. Separately: a minimal CI workflow that does nothing but install dependencies, ready to grow in Module 15.

### 12. Project journal
What you set up, which tools you chose, anything that fought you during setup, what you had forgotten about Git, what is still unfinished.

---

# Module 1: Requirements and Application Plan

**Milestone A. Foundations**

### 1. Learning objectives
- Turn a loose idea into written, testable requirements.
- Separate functional requirements, non-functional requirements, and explicit non-goals.
- Make the scope decisions that the data model depends on.

### 2. Short reading / refresher
A requirement is useful when you can tell whether it has been met. "Track my books" is a wish; "after scanning an ISBN I already own, the app tells me before saving" is a requirement.

User stories are a lightweight format for this: who, what, and why, plus acceptance criteria. For a personal tool the "who" is mostly you, but there are other actors here too: a possible second household user, a public visitor to the view-only page, and Rose.

Non-goals prevent scope creep. The settled decisions already contain several (no ML recommender, no login in v1, no public write surface). Write them down as non-goals so that future-you has to argue with the document.

Some decisions are cheap to change later and some are not. Anything that changes the shape of the data model is expensive, so those get decided now.

### 3. Research / documentation
- User story and acceptance criteria formats. Pick one and stay consistent.
- MoSCoW or a similar prioritization scheme.
- Look at two or three existing personal-library apps and note what they model that you had not thought of, and what they model that you do not want.

### 4. Lab / implementation assignment
Write `docs/requirements.md`.

### 5. Requirements
The document must:
- List the actors and what each can do.
- Cover every feature in the workbook README's settled decisions, either as a requirement or as an explicit non-goal.
- Walk the main workflow (scan, lookup, review, write blurb, save) as a numbered scenario, including at least three things that can go wrong in it.
- Record a decision on **single-user vs multi-user**, with the consequences you expect for the data model (who owns a copy, whose reading state, whose notes).
- Record a decision on **which personal fields are public** on the view-only page and which are private.
- Prioritize: what must exist for Milestone D (first usable version) and what waits.
- Define what "done" means for v1.0.

### 6. Deliverables
- `docs/requirements.md`.
- Two decision notes: user model, public vs private fields.
- Journal entry 1.

### 7. Checkpoint
Pick any five requirements at random. For each, can you describe an observable behavior that would prove it is met? If not, rewrite it.

### 8. Tests / acceptance criteria
- Every feature named in the settled decisions is traceable to a line in the document.
- Every requirement is verifiable by observation.
- The two scope decisions are stated unambiguously.
- A Milestone D feature list exists and is smaller than the full list.

### 9. Common failure modes
- Requirements that describe implementation ("use a table for...") rather than behavior.
- No non-goals.
- Deferring the user-model decision, then discovering in Module 13 that reading state belongs to a user you never modeled.
- Treating the public page as an afterthought and leaking private notes later.

### 10. Hint ladder (locked)
Topics: making a requirement testable, thinking through the multi-user consequences, scoping Milestone D.

### 11. Optional challenge
Sketch low-fidelity wireframes for the scan-and-review screen and the library browse screen. Paper is fine. Photograph them into `docs/`.

### 12. Project journal
What you decided, which decision was hardest, what you cut, what you are unsure about.

---

# Module 2: Domain Modeling

**Milestone B. Data layer**

### 1. Learning objectives
- Model a domain conceptually before thinking in tables.
- Distinguish Work, Edition, and Copy, and place every attribute on the right one.
- Identify entities, relationships, cardinalities, and the awkward cases.

### 2. Short reading / refresher
Library science has a name for this problem. FRBR describes a hierarchy from the abstract work down to the single physical item. You need three levels of it:

- **Work**: the conceptual book. *Red Rising* is one work.
- **Edition**: a particular publication of a work. It usually has its own ISBN, format, publisher, date, page count, and cover.
- **Copy**: a physical object on your shelf. It has an acquisition story and a condition.

The modeling skill is attribute placement. For every piece of information, ask "if I owned two editions of this, would the value differ?" and "if I owned two copies of the same edition, would it differ?" The answers tell you where it lives. Some attributes are arguable (rating, reading state, notes, the scan-time blurb), and those arguments are the real work of this module.

Relationships to reason about: works and authors (many to many, and author order and role can matter), works and series (a work can plausibly sit in more than one), editions and ISBNs (one edition can carry both an ISBN-10 and an ISBN-13, and some books have none), and the wishlist, which is about wanting something you do not have a Copy of.

Open Library happens to use a works/editions split in its own data. It is worth knowing that before Module 6, but model your domain, not theirs.

### 3. Research / documentation
- FRBR Group 1 entities (a summary is enough).
- Open Library's description of works vs editions.
- Conceptual vs logical vs physical data models.

### 4. Lab / implementation assignment
Write `docs/domain-model.md`: a conceptual model of the whole domain, with no SQL and no column types.

### 5. Requirements
- Every entity named, with a one-sentence definition.
- Every attribute from the requirements placed on exactly one entity, with a short justification for each arguable placement.
- Every relationship named with its cardinality in both directions.
- Explicit treatment of: multiple authors, series membership and position (including fractional positions), a book with no ISBN, an edition with both ISBN forms, two copies of one edition, two editions of one work, the wishlist, genre, reading state and its history, reading progress, and the personal fields.
- Your Module 1 user-model decision reflected in the model.
- At least five concrete books from your own shelves walked through the model, including at least one awkward case (omnibus, manga volume, deluxe edition, boxed set, or a book without a barcode).

### 6. Deliverables
- `docs/domain-model.md`.
- A list of open questions the model could not settle.
- Journal entry 2.

### 7. Checkpoint
Submit the model for review. You are ready when you can answer, without hesitating: "I buy a second paperback of a book I already own in hardcover, read the paperback, and rate it. What changes in the model, and where?"

### 8. Tests / acceptance criteria
- No attribute appears on two entities.
- The five-book walkthrough needs no entity or attribute that is not in the model.
- The wishlist is representable without a fake Copy.
- A no-ISBN book is representable.

### 9. Common failure modes
- Collapsing Work and Edition because most of your books have one edition.
- Putting the ISBN on the Work.
- Treating author as a text attribute.
- Modeling reading state as a single current value when the requirement says history.
- Designing tables instead of concepts.

### 10. Hint ladder (locked)
Topics: attribute placement tests, where reading state belongs, representing the wishlist, omnibus and boxed-set cases, author roles.

### 11. Optional challenge
Model contributors beyond authors (translator, illustrator, narrator) and decide whether a translated edition is the same work.

### 12. Project journal
What you modeled, which placements you argued with yourself about, what you changed after the walkthrough, open questions.

---

# Module 3: Relational Database Design

**Milestone B. Data layer**

### 1. Learning objectives
- Translate a conceptual model into a logical relational design.
- Apply normalization deliberately and know when you are departing from it.
- Choose keys, constraints, and indexes on purpose.

### 2. Short reading / refresher
**Normalization.** First normal form: atomic values, no repeating groups. Second: no attribute depends on part of a composite key. Third: no attribute depends on another non-key attribute. In practice the question is "if this fact changes, how many rows do I have to touch?" More than one is a smell.

**Keys.** A natural key is meaningful data (an ISBN); a surrogate key is an invented identifier. Natural keys are tempting and occasionally correct. Ask whether the value is truly unique, truly always present, and truly never changes. Surrogate key types have tradeoffs of their own: sequential integers, UUIDs, and identity columns differ in size, guessability, and index locality.

**Many-to-many** relationships become junction tables, and junction tables can carry their own attributes (order, role, position).

**Constraints** are the database refusing bad data regardless of which client sent it: NOT NULL, UNIQUE, CHECK, foreign keys, and the ON DELETE behavior of each foreign key. Each ON DELETE choice is a statement about your domain.

**Constrained value sets** (reading states, formats) can be a PostgreSQL enum type, a CHECK constraint, or a lookup table. They differ in how painful it is to add a value later, whether values can carry extra data, and how they appear to the application.

**Multi-valued attributes** such as tags can be an array column or a related table. They differ in queryability, integrity, and convenience.

**Indexes** speed reads and cost writes. Primary keys and unique constraints are indexed automatically in PostgreSQL; foreign key columns are not. Index for the queries you will actually run.

### 3. Research / documentation
- PostgreSQL docs: constraints, data types (numeric, text, date/time with and without time zone, arrays), enumerated types, indexes.
- ER diagram notation (crow's foot is the common one) and a diagramming tool you like. Text-based tools keep the diagram in Git.
- Partial and expression indexes. You may want them in Module 10.

### 4. Lab / implementation assignment
Produce the logical design: an ER diagram and a written table specification. Still no DDL.

### 5. Requirements
- An ER diagram covering every entity and relationship from Module 2.
- For every table: columns, types, nullability, primary key, foreign keys with ON DELETE behavior, unique constraints, check constraints.
- A stated approach, with a one-line reason, for: surrogate vs natural keys, constrained value sets, tags, timestamps and time zones, fractional series positions, ISBN storage (one form, both, or derived).
- A list of the ten queries you expect to run most (from your requirements), and the indexes that serve them.
- A normalization pass: state the normal form you are targeting and list any deliberate denormalization with its reason.

### 6. Deliverables
- `docs/erd.*` and the table specification.
- Decision notes for the approaches listed above.
- Journal entry 3.

### 7. Checkpoint
Submit the design for review. You are ready when every one of your ten queries can be answered from the design, and you can say what the database itself will refuse for each table.

### 8. Tests / acceptance criteria
- Every Module 2 entity and relationship is traceable to the design.
- No fact is stored in two places without a written reason.
- Every foreign key has a chosen ON DELETE behavior.
- The design can represent: two authors in a specific order, a series position of 1.5, a book with no ISBN, a wishlist entry, two copies of one edition, and a full reading history with a re-read.

### 9. Common failure modes
- Comma-separated values in a text column.
- Nullable everything.
- A unique constraint that the no-ISBN case violates.
- Defaulting to cascade deletes without asking what they would destroy.
- Timestamps without time zones.
- Indexing every column "to be safe".

### 10. Hint ladder (locked)
Topics: choosing keys, enum vs check vs lookup table, uniqueness with nullable columns, junction table attributes, modeling history, what to index.

### 11. Optional challenge
Design an audit trail: how would you know what changed on a record, and when? Decide whether it belongs in v1.

### 12. Project journal
What you designed, where you departed from the conceptual model and why, what you relearned about normalization, what still feels shaky.

---

# Module 4: PostgreSQL / Neon Implementation

**Milestone B. Schema live in Neon**

### 1. Learning objectives
- Implement the design as versioned, repeatable migrations.
- Work with Neon's connection model and branching.
- Verify constraints by trying to break them.

### 2. Short reading / refresher
A migration is a versioned, ordered change to the schema, committed to Git alongside the code that needs it. The discipline: never edit a migration that has been applied anywhere that matters; write a new one. The schema you have in Module 4 will change in later modules, and that is expected.

Migration tooling options, broadly:
- **Alembic**, the usual companion to SQLAlchemy. It can autogenerate migrations from ORM models or run hand-written ones. Powerful; more to learn; autogenerate needs checking.
- **Plain SQL files with a small runner** (a tool such as dbmate, or your own). You write exactly the DDL you mean, which is good SQL practice; you give up autogeneration and some safety rails.
- **ORM-driven "create all"** with no migrations. Fast to start and a dead end the first time the schema changes.

A related choice you will face in Module 7 but should be aware of now: ORM, query builder, or raw SQL through a driver. They trade convenience against control and SQL fluency. Since SQL is on your refresher list, weigh that.

Neon specifics worth understanding before you connect: it offers both direct and pooled connection strings, and they behave differently for migrations and for long-lived sessions; it requires SSL; compute can suspend when idle, so the first query after a pause is slow; and it supports branching, which gives you a disposable copy of the database for development and tests.

### 3. Research / documentation
- Neon docs: connection strings, pooled vs direct connections, branching, roles.
- Your chosen migration tool's getting-started guide.
- PostgreSQL docs: `CREATE TABLE`, `ALTER TABLE`, constraint syntax, `psql` meta-commands for inspecting a schema.

### 4. Lab / implementation assignment
Write the migrations that create your schema, and apply them to a Neon development branch.

### 5. Requirements
- The schema matches your Module 3 design. Where it differs, the design document is updated.
- Migrations run from an empty database to the full schema with one command.
- Migrations can be rolled back, or you have a written reason why a given one cannot.
- The connection string comes from the environment and appears in no committed file.
- A development branch exists in Neon separate from the branch you will treat as production.
- A small seed script or SQL file inserts a handful of your real books by hand, covering the awkward cases from Module 2.
- A file of "constraint probes": statements that should fail, each with the constraint it should trip.

### 6. Deliverables
- Migrations in `backend/`.
- Seed data and constraint probes.
- Updated `.env.example` and README setup steps.
- Journal entry 4.

### 7. Checkpoint
Create a fresh Neon branch, run the migrations from nothing, load the seed, and run the probes. Everything that should succeed succeeds, and everything that should fail fails for the expected reason.

### 8. Tests / acceptance criteria
- Every constraint probe fails with an error naming the intended constraint.
- Your ten queries from Module 3 run against the seed data and return sensible results.
- `git grep` for your Neon hostname or password returns nothing.
- A second person could build the database using only the README.

### 9. Common failure modes
- Running migrations over the pooled connection and hitting confusing errors.
- Editing an applied migration.
- Creating the schema by hand in the console "just this once".
- Seed data that avoids every awkward case.
- Committing a connection string.

### 10. Hint ladder (locked)
Topics: migration tool setup, pooled vs direct connection symptoms, writing a reversible migration, constraint syntax, inspecting the live schema.

### 11. Optional challenge
Use `EXPLAIN ANALYZE` on three of your ten queries. With seed-sized data the planner may ignore your indexes; find out why and what that implies about when to measure.

### 12. Project journal
What you built, which constraint surprised you, what you had forgotten about DDL, any design changes the implementation forced.

---

# Module 5: ISBN Fundamentals

**Milestone C. Lookup core**

### 1. Learning objectives
- Understand the structure of ISBN-10 and ISBN-13 and the relationship between them.
- Implement normalization, validation, and conversion as pure, well-tested functions.
- Begin test-first development, which continues in every module from here.

### 2. Short reading / refresher
An ISBN-13 is an EAN-13 product code. Book barcodes start with 978 or 979, which is why a retail barcode scanner can read them. An ISBN-10 is the older form. Every ISBN-10 maps to a 978-prefixed ISBN-13, and not every ISBN-13 maps back.

Both forms end in a check digit computed from the other digits with a weighted sum: ISBN-10 uses modulo 11 with descending weights, and its check digit can be the letter X; ISBN-13 uses modulo 10 with alternating weights. The check digit catches single-digit errors and most transpositions. Converting between forms means recomputing it.

Hyphens and spaces are presentation only, and their positions vary by registration group, so they carry no information you need. Normalization means reducing any reasonable input to one canonical form. Validation means deciding whether a normalized string is a real ISBN.

This code is pure logic with no I/O, which makes it the ideal place to restart a testing habit. Write the tests from the vectors below first, watch them fail, then write the code.

### 3. Research / documentation
- The ISBN check digit algorithms (the ISBN Users' Manual or any solid reference).
- `pytest` basics: test discovery, parametrized tests, asserting exceptions.
- Python typing for function signatures, and how you want to represent "invalid" (exception, result object, or None). Each has consequences for the callers you will write later.

### 4. Lab / implementation assignment
Build a small ISBN module in the backend: normalize, validate, identify form, convert between forms. Tests first.

### 5. Requirements
- Accepts input with hyphens, spaces, surrounding whitespace, and a lowercase x.
- Identifies whether input is ISBN-10, ISBN-13, or neither.
- Validates check digits for both forms.
- Converts ISBN-10 to ISBN-13 always, and ISBN-13 to ISBN-10 only when that is possible, with a defined behavior when it is not.
- Produces one canonical form for storage and lookup, consistent with your Module 3 ISBN storage decision.
- Rejects invalid input in a way callers can distinguish by reason (wrong length, bad characters, bad check digit).
- No network, no database, no framework imports.

### 6. Deliverables
- The ISBN module and its test file.
- All tests passing.
- Journal entry 5.

### 7. Checkpoint
Scan five of your own books into a text file with the scanner and feed the results to your functions. Then hand-type the same ISBNs from the copyright pages, with hyphens. Both routes must agree.

### 8. Tests / acceptance criteria
Your tests must cover at least these vectors:

| Input | Expected |
|---|---|
| `9780306406157` | valid ISBN-13 |
| `978-0-306-40615-7` | valid, normalizes to the row above |
| `0306406152` | valid ISBN-10; converts to `9780306406157` |
| `080442957X` | valid ISBN-10 (X check digit) |
| `080442957x` | same as above |
| `9791090636071` | valid ISBN-13; has no ISBN-10 form |
| `9780306406158` | invalid: check digit |
| `030640615X` | invalid: check digit |
| `978030640615` | invalid: length |
| `97803O6406157` (letter O) | invalid: characters |
| `X306406152` | invalid: X in a non-final position |
| empty string, whitespace only | invalid |

Add vectors of your own from your shelves.

### 9. Common failure modes
- Treating the ISBN as a number and losing leading zeros.
- Handling X everywhere or nowhere.
- Converting by swapping the prefix and keeping the old check digit.
- Assuming every ISBN-13 has an ISBN-10.
- Writing the tests after the code and only for the cases the code already passes.

### 10. Hint ladder (locked)
Topics: the two checksum algorithms, conversion, representing failure, parametrized tests.

### 11. Optional challenge
Write the same module a second time in TypeScript for the web client (you will want instant feedback in Module 8), driven by the same vector table. Then consider: how do you keep two implementations from drifting?

### 12. Project journal
What you built, which vector caught a bug, how test-first felt, what remains.

---

# Module 6: External Metadata APIs

**Milestone C. Lookup core**

### 1. Learning objectives
- Read API documentation and explore an unfamiliar API by hand before writing code against it.
- Write async HTTP clients with timeouts and sensible failure behavior.
- Map two inconsistent external data shapes onto one internal candidate shape.

### 2. Short reading / refresher
Explore first. Before writing a client, make requests by hand with `curl` or an HTTP tool for a dozen of your own ISBNs and read the raw JSON. You will find missing fields, fields that are sometimes a string and sometimes a list, dates in several formats, and books one source has never heard of. Your code must survive all of it.

Open Library and Google Books model books differently. Open Library separates works from editions, which lines up with your domain; Google Books returns "volumes". Neither is authoritative. Both have usage expectations: read Open Library's guidance on identifying your application and on rate limits, and Google's on quotas and API keys. The previous version of this project hit 403 responses from Open Library for exactly this kind of reason, so read that section carefully.

**Async refresher.** `async`/`await` lets one thread wait on many I/O operations. In Python that means an async HTTP client, awaiting calls, and knowing how to run two requests concurrently rather than one after the other. Every network call needs a timeout. Failures come in kinds: connection errors, timeouts, non-2xx statuses, a 200 with an empty result, and a 200 with malformed or unexpected JSON. Each should be distinguishable by your caller.

Put a boundary around the outside world. Code beyond the client layer should see only your own candidate shape and never raw API JSON. That boundary is what makes Module 15's failure testing possible.

### 3. Research / documentation
- Open Library developer docs: the Books API, the ISBN endpoint, the Search API, the Covers API, and their usage guidelines.
- Google Books API docs: volume search by ISBN, API keys, quotas.
- `httpx` async client: timeouts, error classes, client lifecycle.
- Pydantic models for parsing and validating external data.

### 4. Lab / implementation assignment
Part A: exploration and a written field mapping. Part B: one client per source, each returning your internal candidate shape.

### 5. Requirements
**Part A**
- Raw responses saved for at least ten of your ISBNs from each source, chosen to include: a mainstream novel, a manga volume, an older printing, a 979-prefixed book if you own one, a textbook, and an ISBN at least one source does not know.
- `docs/api-notes/field-mapping.md`: for every field you want (title, subtitle, authors, publisher, publish date, page count, format, cover, description, series, identifiers, the source's own work and edition keys), where it lives in each source, how reliable it looked, and what forms it took.

**Part B**
- A defined internal candidate shape that records which source each candidate came from.
- One client per source, async, with timeouts, returning zero or more candidates.
- Each failure kind listed in the refresher surfaces as something the caller can tell apart.
- Open Library is queried as primary; Google Books behavior as secondary is defined by you (fallback only, or always queried and compared). State which and why.
- Date handling: a defined internal representation for partial dates such as a bare year.
- API keys, if used, come from the environment.
- Unit tests run against the saved responses, with no network.

### 6. Deliverables
- Saved sample responses (check whether any should be excluded from Git; they are public data, but decide deliberately).
- The field mapping document.
- Two clients, tests passing offline.
- Journal entry 6.

### 7. Checkpoint
Run your clients live against all ten ISBNs and compare the candidates by eye with the physical books. Note every disagreement. You are ready when you can say, per field, which source you trust more and what you do when both are empty.

### 8. Tests / acceptance criteria
- A known ISBN yields a populated candidate from Open Library.
- An unknown ISBN yields an empty result and not an error.
- A simulated timeout, a 500, a 429, and a malformed body each produce a distinct, handled outcome.
- A response with missing optional fields parses without exceptions.
- The test suite passes with the network disconnected.

### 9. Common failure modes
- Writing the client from the documentation without looking at real responses.
- Assuming a field exists because it existed for the first book you tried.
- No timeout.
- Treating "not found" as an exception, or an exception as "not found".
- Letting raw API JSON leak past the client layer.
- Hammering an API in a loop during development.

### 10. Hint ladder (locked)
Topics: exploring an API by hand, concurrency for two requests, modeling partial dates, distinguishing failure kinds, testing without the network.

### 11. Optional challenge
Write a merge function that takes candidates from both sources for one ISBN and produces a single best candidate, recording per field where the value came from.

### 12. Project journal
What you built, what the real data looked like compared with the docs, which fields are unreliable, async concepts you had to relearn.

---

# Module 7: Backend / API

**Milestone C. API returns candidate metadata for an ISBN**

### 1. Learning objectives
- Design an HTTP API before implementing it.
- Build a layered FastAPI application: routing, validation, services, data access.
- Handle errors consistently and return correct status codes.

### 2. Short reading / refresher
**Layers.** A maintainable backend keeps HTTP concerns (routes, status codes, request and response models) apart from domain logic (what it means to add a copy) and from data access (SQL). The test: could you call your domain logic from a script with no web framework involved?

**Request and response models are not database rows.** They are the contract with your clients, and they should be able to stay stable while the schema changes underneath.

**FastAPI refresher.** Path operations, Pydantic models for validation and serialization, dependency injection for things like database sessions and settings, async handlers, exception handlers for mapping domain errors to HTTP responses, and automatic OpenAPI docs. CORS will matter the moment the Vite dev server calls your API from another origin.

**REST design choices** with real tradeoffs: nested resources versus flat ones with filters for the work/edition/copy hierarchy; how much related data a response embeds; offset versus cursor pagination; PUT versus PATCH for edits. Pick and be consistent.

**Data access choice** (flagged in Module 4): ORM, query builder, or raw SQL. Decide now and record why.

**Status codes to be deliberate about:** 200, 201, 204, 400, 404, 409, 422, 502, 503, 504. Several of them have an obvious use in this application. Work out which.

### 3. Research / documentation
- FastAPI docs: bigger applications and routers, dependencies, handling errors, CORS, testing with the test client.
- Your chosen data access library's async usage with PostgreSQL.
- Settings management from environment variables (for example `pydantic-settings`).
- HTTP semantics for the status codes above.

### 4. Lab / implementation assignment
Write an API design document, then implement the core backend.

### 5. Requirements
- `docs/api-design.md`: every resource, route, method, request and response shape, and error case, written before implementation.
- A lookup route that takes an ISBN, runs Module 5 validation, calls the Module 6 clients, and returns candidates. It does not save anything.
- Create, read, update, and delete for your core entities, with deletes respecting the ON DELETE decisions from Module 3.
- List routes with pagination.
- One consistent error response shape across the whole API.
- Invalid input never reaches the database layer.
- An upstream API failure produces a response that tells the client what happened, distinct from "book not found".
- Configuration from environment only. A health route that reports database reachability.
- The server binds in a way appropriate for LAN use; you know which interface it listens on and why.
- Tests for the lookup route (with the external clients replaced) and for at least one entity's full lifecycle.

### 6. Deliverables
- The API design document.
- A running backend with the routes above.
- Tests passing.
- Journal entry 7.

### 7. Checkpoint
Using only the generated API docs page, add one of your real books by hand end to end: look up the ISBN, then create the work, edition, and copy from the candidate. Then look at the rows in Neon. You are ready when the data is right and the experience told you what is tedious, because Module 9 automates exactly that.

### 8. Tests / acceptance criteria
- A valid ISBN returns candidates with a 200.
- A malformed ISBN returns a client error carrying your Module 5 reason and makes no external request.
- A valid but unknown ISBN returns a successful, empty result.
- An upstream timeout returns a gateway-class error in your standard error shape.
- Creating an edition with a duplicate ISBN returns a conflict and not a 500.
- Requesting a missing resource returns 404.
- No route returns a stack trace to the client.

### 9. Common failure modes
- Business logic inside route functions.
- Returning ORM objects or raw rows directly.
- A blocking database or HTTP call inside an async handler.
- 500 for everything that goes wrong.
- A different error shape per route.
- Wildcard CORS to make an error go away.

### 10. Hint ladder (locked)
Topics: layering, mapping domain errors to HTTP, session-per-request, pagination design, replacing dependencies in tests, CORS.

### 11. Optional challenge
Add structured request logging with a request ID that also appears in error responses, so a failure seen in the client can be found in the log.

### 12. Project journal
What you built, which design choices you made and why, what was tedious in the checkpoint, what FastAPI details you had to look up.

---

# Module 8: Barcode Scanner Input

**Milestone D. First usable version** (the web client begins here)

### 1. Learning objectives
- Understand how a USB HID "keyboard wedge" scanner delivers data.
- Scaffold the React + TypeScript web client.
- Capture scans reliably in a browser, where the scanner is indistinguishable from a fast typist.

### 2. Short reading / refresher
Your scanner is a keyboard as far as the operating system is concerned. A scan arrives as a burst of key events a few milliseconds apart, ending in Enter. There is no "scan event". Three consequences:

- **Focus.** Keystrokes go wherever focus is. If focus is on the wrong element, or nowhere, the scan is lost or typed into the wrong field.
- **Identification.** Approaches to knowing a scan happened: a dedicated input that always holds focus; a global key listener that uses inter-key timing to tell a scanner from a human; or a prefix or suffix character programmed into the scanner. They differ in robustness, accessibility, and how they coexist with normal typing elsewhere on the page.
- **Configuration.** The scanner's output depends on its settings: ISBN-10 versus the full EAN-13, the terminator character, and whether it reads the five-digit price add-on some books carry next to the main barcode. QR codes (your no-ISBN labels, Module 9) produce a different payload from the same device.

**TypeScript refresher.** Turn on strict mode from the first commit. Discriminated unions are a good fit for states that carry different data (nothing scanned, valid scan, invalid scan with a reason). Type what comes back from your API; untyped `any` from `fetch` is where bugs get in.

**React refresher.** Controlled inputs, refs for focus management, effects and their cleanup (global listeners must be removed), and keeping derived state derived.

### 3. Research / documentation
- The Eyoyo EYH2 manual: output mode, terminator, add-on code, and continuous-scan settings.
- Vite's React + TypeScript template.
- MDN: `KeyboardEvent`, focus management, `document.activeElement`.
- TypeScript handbook: narrowing and discriminated unions.

### 4. Lab / implementation assignment
Scaffold the web client and build a scan-capture screen that turns scanner input into validated ISBNs.

### 5. Requirements
- A Vite React + TypeScript app in `web/`, strict mode on, committed with a lockfile.
- A scan-capture screen that receives scanner input and shows, for each scan: the raw input, the normalized ISBN, and valid or invalid with the reason.
- A documented decision on the identification approach from the refresher.
- The screen is ready for the next scan immediately after each one, with no mouse needed.
- A visible indication of whether the screen is currently able to receive a scan.
- Manual typing of an ISBN also works.
- Rapid double scans of the same book are handled deliberately (your choice how, written down).
- A documented scanner configuration: which output mode you chose and why, so a factory reset is recoverable.
- A session log of scans on screen.
- ISBN validation on the client comes either from a TypeScript implementation (Module 5 optional challenge) or from your API. Decide and note the tradeoff.

### 6. Deliverables
- The `web/` scaffold and scan-capture screen.
- `docs/scanner-setup.md`.
- Journal entry 8.

### 7. Checkpoint
Scan a stack of fifteen books as fast as you comfortably can without touching the mouse. Every scan is captured exactly once, in order. Then click somewhere else on the page and scan again: the behavior matches what your design says should happen.

### 8. Tests / acceptance criteria
- Fifteen consecutive scans produce fifteen log entries in order.
- A scan with focus elsewhere behaves as designed and never silently disappears.
- A non-book barcode (a cereal box) is rejected with a clear reason.
- A QR code scan does not crash the screen.
- Typing an ISBN by hand and pressing Enter behaves the same as a scan.
- No TypeScript errors under strict mode, and no `any` in the scan-handling code.

### 9. Common failure modes
- Assuming focus.
- A global key listener that is never cleaned up, or that eats normal typing.
- The Enter key submitting an enclosing form.
- Timing thresholds tuned to one machine.
- Forgetting the scanner's configuration is state that lives outside your repository.

### 10. Hint ladder (locked)
Topics: focus strategy, telling scanner from typist, effect cleanup, modeling scan state in TypeScript, the add-on barcode.

### 11. Optional challenge
Audio or visual feedback distinct for success and failure, so you can scan without looking at the screen.

### 12. Project journal
What you built, how the scanner actually behaved, React or TypeScript details you had forgotten, remaining rough edges.

---

# Module 9: Book Ingestion Pipeline

**Milestone D. First usable version**

### 1. Learning objectives
- Build a multi-step workflow with explicit states across client and server.
- Save related records atomically with a database transaction.
- Handle incomplete metadata and the no-ISBN path.

### 2. Short reading / refresher
The pipeline is: scan, look up, review and edit, write the blurb, save. It is a state machine whether or not you draw one, and drawing one first makes the UI much easier to get right: idle, looking up, candidates found, nothing found, lookup failed, reviewing, saving, saved, save failed. Each state has a defined screen and defined exits.

**Transactions.** Saving one book may insert a work, an edition, a copy, one or more authors, the author links, and a series link. Either all of it happens or none of it does. Understand where your data access layer begins and ends a transaction, and what happens to it when an exception is raised halfway.

**Find-or-create.** The author "Pierce Brown" should not be inserted once per book. That requires deciding what "the same author" means, which is harder than it sounds with external data.

**The review step is the point of the whole design.** External metadata is a suggestion. The user sees it, corrects it, and only then does it become your data. The scan-time blurb is entered here and belongs to you alone.

**No-ISBN books.** Older printings and some small-press books have no barcode. They need manual entry and then a label: a QR code you generate, print, and stick inside the cover, which the same scanner reads back. Deciding what the QR encodes is a small design problem: it must be unique, stable, recognizable as yours (so a random QR code is rejected), and still meaningful if the database is rebuilt.

### 3. Research / documentation
- Transaction handling in your data access library, including rollback on exception.
- PostgreSQL `INSERT ... ON CONFLICT` and its limits as a find-or-create tool.
- Form handling in React for a form pre-filled from fetched data.
- A QR code generation library for either the backend or the frontend, and how you will print labels.

### 4. Lab / implementation assignment
Connect Modules 5 through 8 into a working scan-to-saved-book flow, plus the manual path.

### 5. Requirements
- A state diagram for the pipeline in `docs/`, made before the UI.
- After a scan, candidates are shown. With more than one, the user picks; with none, the user is offered manual entry with the ISBN carried over.
- Every metadata field is editable before saving. Series name and position are always manually editable.
- The blurb field is part of the review screen and is never pre-filled from external or generated text.
- Acquisition information can be entered at save time.
- Saving is one atomic operation on the server. A failure partway leaves no partial records.
- Authors are found or created according to a rule you wrote down.
- The source of the metadata (which API, which external keys) is stored with the record.
- After a successful save the screen returns to ready-to-scan.
- The manual path creates a book with no ISBN, generates its QR label, and scanning that label later finds the book.
- Scanning a QR code that is not one of yours is rejected cleanly.
- Tests: the save operation's atomicity, and find-or-create behavior.

### 6. Deliverables
- The working pipeline, both paths.
- The state diagram.
- A decision note on the QR payload.
- Journal entry 9.

### 7. Checkpoint
Add ten real books from one shelf, including one whose metadata needs correction and one with no ISBN. Inspect the rows afterwards. Then stop the backend mid-session and try to save: the client tells you what happened and loses nothing you typed.

### 8. Tests / acceptance criteria
- A forced failure during save leaves zero new rows in every table.
- Saving two books by the same author creates one author.
- An edited field is what gets stored and not the API's original value.
- A book with a bare publication year saves correctly.
- A lookup failure still allows manual entry.
- The blurb typed during review survives a failed save and a retry.
- A printed QR label scans back to the right book.

### 9. Common failure modes
- Multiple commits inside one logical save.
- Losing form input when a request fails.
- Matching authors on raw strings and ending up with near-duplicates.
- A UI that can be in two states at once (saving and idle) because state lives in several booleans.
- Saving the unedited candidate.

### 10. Hint ladder (locked)
Topics: drawing the state machine, transaction boundaries, find-or-create races, pre-filled editable forms, designing the QR payload.

### 11. Optional challenge
A "rapid mode" for clean scans: if exactly one confident candidate comes back, queue it for later review instead of interrupting the scanning rhythm. Decide how that interacts with the scan-time blurb.

### 12. Project journal
What you built, where state got complicated, a transaction bug if you met one, how adding the first ten real books felt.

---

# Module 10: Duplicate and Edition Handling

**Milestone D. Scan to saved book. Start scanning real shelves after this module.**

### 1. Learning objectives
- Distinguish the three "I already have this" cases and respond to each correctly.
- Combine database-level uniqueness with application-level matching.
- Reason about fuzzy identity in messy data.

### 2. Short reading / refresher
When a scan comes in, there are three different situations that feel the same to the user:

1. **Same edition, already owned.** The ISBN matches. Is this a second physical copy, or did you scan the same book twice?
2. **Same work, different edition.** A new ISBN, but you already own this title in another format. It should attach to the existing work and not create a second one.
3. **New work.**

Case 1 is exact matching, and the database can enforce part of it. Remember that the same edition can arrive as ISBN-10 one day and ISBN-13 the next.

Case 2 is fuzzy. Signals include the external source's work identifier, normalized title plus author, and series position. None is reliable alone. Title normalization is a rabbit hole (subtitles, leading articles, punctuation, "Book One of..."). Decide how far to go, and let the user confirm rather than letting the system guess silently. A wrong automatic merge is worse than a missed one, because a missed one is visible and fixable.

**Race conditions.** Check-then-insert is not safe under concurrency. With one user at one desk it is nearly theoretical, but the fix is cheap and the concept matters: let the constraint be the final arbiter and handle its violation gracefully.

You also need the repair tools: merge two works that turned out to be the same, and move an edition to a different work.

### 3. Research / documentation
- PostgreSQL unique constraints, partial unique indexes, and how constraint violations surface through your data access layer.
- Text normalization techniques; the `pg_trgm` extension and similarity search, and whether Neon supports it.
- How Open Library work keys behave across editions of the same work, tested on books you own in two editions if you have any.

### 4. Lab / implementation assignment
Make the pipeline aware of what you already own, and build the repair operations.

### 5. Requirements
- On scan, before the review screen, the user is told which of the three cases applies, with the evidence.
- Case 1: the user chooses between adding another copy and cancelling. Nothing is added silently.
- Case 2: the user is shown the likely existing work and chooses between attaching to it and creating a new work.
- An ISBN-10 and its equivalent ISBN-13 are recognized as the same edition.
- The database itself prevents two editions with the same ISBN, without breaking no-ISBN books.
- A written, deliberately limited rule for work matching, and a note on its known blind spots.
- Merge-works and move-edition operations, each atomic.
- The wishlist interacts correctly: acquiring a wishlisted book is detected and resolved (your design decides how).
- Tests for each case and for both repair operations.

### 6. Deliverables
- Duplicate-aware pipeline and repair operations.
- The matching rule document.
- Journal entry 10.

### 7. Checkpoint
Scan a book you have already added. Scan a second edition of something you own, or simulate one with seed data. Add a genuine second copy. Deliberately create a wrong duplicate work and merge it away. All four behave as designed, and the merged work keeps every edition, copy, and personal field.

### 8. Tests / acceptance criteria
- Re-scanning an owned ISBN never creates a record without confirmation.
- The same edition scanned as ISBN-10 and as ISBN-13 resolves to one edition.
- A forced duplicate insert produces a handled conflict and not a 500.
- Merging works loses no child records and no personal data.
- Two no-ISBN books can coexist.
- Scanning a wishlisted book triggers your wishlist resolution.

### 9. Common failure modes
- Relying on the application-level check alone.
- Aggressive automatic merging.
- A unique constraint that treats "no ISBN" as a duplicate of "no ISBN".
- A merge that orphans or double-counts children.
- Forgetting the personal fields during a merge.

### 10. Hint ladder (locked)
Topics: uniqueness with missing values, catching constraint violations, a sane title normalization scope, merge ordering inside a transaction.

### 11. Optional challenge
Write a script in `scripts/` that cross-checks `books.csv` against the database and reports titles that appear in the CSV but have not been scanned yet. The CSV has only title and author, so this is a fuzzy matching problem; report confidence and let a human decide.

### 12. Project journal
What you built, which case was hardest, what your matching rule misses, how many real books you have scanned so far.

---

# Module 11: Genre Classification

**Milestone E. A library you use**

### 1. Learning objectives
- Integrate an LLM API as an unreliable component behind a strict validation boundary.
- Write a classification taxonomy precise enough for a machine and a human to apply the same way.
- Keep human decisions safe from automated overwrites.

### 2. Short reading / refresher
An LLM call is an external API with one extra property: the same input can produce different outputs, and the output is text that merely claims to follow your format. Treat the response like any untrusted input: parse it, validate it against the allowed values, and have a defined behavior for anything that fails.

The quality of classification depends mostly on the taxonomy document. "Fantasy" is not a usable category until you have said where its borders are. Rules already decided for this project, which your taxonomy must encode:

- An author can split across genres by book. Le Guin: Earthsea is Epic Fantasy, Hainish is Classic SF. Classification is per work and never per author.
- Indigenous Literature is its own primary genre.
- Indigenous authorship wins the primary-genre tiebreak.

The third rule needs information that book metadata does not reliably contain. How the system knows, and who is the authority on it, is a design question for you.

Provenance matters. A genre value is either machine-suggested or human-set, and the system must know which. A human-set value is never overwritten by a re-run. This is the same principle as the scan-time blurb.

Cost and latency: classify once and store. Decide what triggers a re-classification.

### 3. Research / documentation
- Groq API docs: chat completions, available models, structured or JSON output options, rate limits.
- Prompting for classification: supplying the label set, definitions, and examples.
- How your schema from Module 3 represents genre, and whether it now needs a migration.

### 4. Lab / implementation assignment
Write the taxonomy, then build genre classification into the backend and the review flow.

### 5. Requirements
- `docs/genre-taxonomy.md`: every primary genre with a definition, borderline rulings, and the three decided rules. You write the taxonomy and the classification prompt; both can be reviewed, and neither will be written for you.
- A backend service that takes a work's metadata and returns a primary and secondary genre from the taxonomy, or a defined "could not classify" result.
- Model output is validated against the taxonomy. Out-of-taxonomy output is never stored.
- Each stored genre value records whether it was machine-suggested or human-set.
- The review screen shows the suggestion and lets the user change it. Human-set values are never overwritten.
- A classification failure (timeout, rate limit, malformed output) never blocks saving a book.
- The API key comes from the environment and never reaches the client.
- A defined way to supply the authorship information the tiebreak rule depends on.
- Tests with the LLM call replaced: valid output, out-of-taxonomy output, malformed output, timeout.

### 6. Deliverables
- The taxonomy document.
- Classification service, UI integration, tests.
- Any migration this required.
- Journal entry 11.

### 7. Checkpoint
Classify twenty of your books that span your shelves, including the Le Guin split and several Indigenous-authored works. Record how many suggestions you accepted unchanged. Where it was wrong, decide whether the fault is the taxonomy, the prompt, or the input metadata.

### 8. Tests / acceptance criteria
- A label outside the taxonomy is rejected and the book still saves.
- Re-running classification leaves a human-set genre untouched.
- A classification timeout does not fail the ingestion pipeline.
- The two Le Guin series classify differently.
- The tiebreak rule is applied when its condition is met.
- The Groq key appears in no client bundle and no committed file.

### 9. Common failure modes
- Trusting the output format.
- A taxonomy of bare labels with no definitions.
- Classification on the critical path of saving.
- Overwriting human corrections on re-run.
- Asking the model to infer facts about authors that it cannot know.

### 10. Hint ladder (locked)
Topics: validating model output, structuring a classification prompt, provenance modeling, where in the pipeline to classify, handling the tiebreak input.

### 11. Optional challenge
Build a small evaluation set from your accepted classifications and a script that re-runs them after any prompt or model change, reporting agreement. This is regression testing for a non-deterministic component.

### 12. Project journal
What you built, your acceptance rate, what the taxonomy got wrong, how working with a non-deterministic component differs.

---

# Module 12: Library UI

**Milestone E. A library you use**

### 1. Learning objectives
- Build browse, search, filter, sort, and detail views over a relational hierarchy.
- Choose and apply a data-fetching strategy in React.
- Make deliberate decisions about where filtering and searching happen.

### 2. Short reading / refresher
**Where the work happens.** With 150 books you could fetch everything and filter in the browser. With 1,500 you could not comfortably, and the mobile client and Rose will want server-side queries anyway. Options: all client-side, all server-side, or a hybrid. They differ in responsiveness, complexity, and reuse.

**Search in PostgreSQL** comes in tiers: `ILIKE` pattern matching, full-text search with `tsvector`, and trigram similarity. They differ in typo tolerance, ranking, index support, and setup cost.

**Data fetching in React.** Options: `fetch` inside effects with hand-rolled loading and error state; a server-state library such as TanStack Query; or a framework router's loaders. The hand-rolled route teaches the most about effects and race conditions (a slow response for an old query arriving after a fast one for a new query); a library handles caching and invalidation you would otherwise write yourself.

**Every view has four states:** loading, error, empty, and populated. The empty state is the one people forget.

**The hierarchy in the UI.** The list is probably of works, but a detail view has to show a work, its editions, and the copies of each, along with personal data whose placement you decided in Module 2.

**URL as state.** If search and filter live in the URL, the back button works and views are linkable.

**Covers.** Hotlinking external cover URLs is easy and fragile. Caching them yourself is robust and more work. Some books will have no cover at all.

### 3. Research / documentation
- A React router and its search-parameter handling.
- Your chosen data-fetching approach's docs.
- PostgreSQL pattern matching, full-text search, and `pg_trgm`.
- Basic accessibility for lists, forms, and keyboard navigation.

### 4. Lab / implementation assignment
Build the library browsing experience.

### 5. Requirements
- A library view listing what you own, with cover, title, authors, and reading state at minimum.
- Search across at least title, author, and series.
- Filters: reading state, genre, format, owned versus wishlist, and at least one of your choosing.
- Sorting: at least title, author, date added, and series order.
- Search, filter, and sort state survive a page reload and the back button.
- A detail view that shows the work, every edition, every copy, and all personal fields, with navigation to edit them.
- Loading, error, and empty states for every view.
- Missing covers handled gracefully.
- A documented decision on client-side versus server-side filtering, and on the search tier.
- Any new query routes follow your Module 7 conventions and are tested.
- Navigation between scanning and browsing.

### 6. Deliverables
- The library UI.
- Decision notes.
- Journal entry 12.

### 7. Checkpoint
With at least thirty real books in the database, answer these using only the UI: what do I own by a specific author, which unread science fiction do I have, which books did I add this month, and what editions of one particular work do I own? Then type fast in the search box and watch the results: they never show a stale query's answer.

### 8. Tests / acceptance criteria
- Search matches regardless of case.
- Combined filters narrow results and do not widen them.
- Reloading a filtered view restores it.
- A work with two editions and three copies displays all of them correctly.
- A search with no results shows an empty state and not a blank page.
- With the backend stopped, the UI shows an error state and recovers when the backend returns.
- Rapid typing never leaves stale results on screen.

### 9. Common failure modes
- An N+1 query pattern behind the list route.
- Race conditions between overlapping requests.
- Filter state in component state only.
- A request fired per keystroke with no restraint.
- A layout that assumes every book has a cover, a single author, and a short title.

### 10. Hint ladder (locked)
Topics: request races, avoiding N+1, URL state, choosing a search tier, shaping the detail response.

### 11. Optional challenge
A shelf-style cover grid and a dense table view, switchable, with the choice remembered.

### 12. Project journal
What you built, which data-fetching approach you chose and how it went, a race or performance bug you found, what the UI revealed about your API design.

---

# Module 13: Reading State, History, Progress, Personal Fields

**Milestone E. A library you use**

### 1. Learning objectives
- Implement state with history, including transitions, dates, and re-reads.
- Evolve a live schema with a migration that preserves data.
- Build the personal layer that makes this a reading journal and not a catalog.

### 2. Short reading / refresher
The original idea was a `read` boolean. The requirement is five states with history: unread, reading, read, paused, did-not-finish.

**Current value versus history.** Approaches: store the current state and append to a history table on every change; store only events and derive the current state; or model reading "sessions" with a start, an end, and an outcome, from which state is derived. They differ in query simplicity, the risk of the current value and the history disagreeing, and how naturally a re-read fits. You chose one in Modules 2 through 4. Now that you have used the app, check whether it still holds. If it does not, this is your first real data-preserving migration, which is a skill worth having.

**Transitions.** Not every change makes sense, and some imply dates. Moving to "reading" suggests a start date; "read" suggests a finish date; going from "read" to "reading" is a re-read and must not erase the first reading. Decide which transitions are allowed, which prompt for a date, and whether dates can be backfilled for books you read years ago with only a vague idea of when.

**Progress.** Current chapter is free text because real chapter labels are messy. Current page is an integer so you can compute a percentage, which needs the edition's page count, which may be missing or may differ between editions.

**Personal fields:** rating, reread score (1 to 5), notes, favorite quotes, writer takeaways, mood tags, and the scan-time blurb. Revisit where each attaches (work, edition, copy, or user) and which are public, per Module 1.

### 3. Research / documentation
- Approaches to temporal and history data in relational databases.
- Writing a migration that transforms existing rows, and testing it on a Neon branch copied from real data.
- PostgreSQL date, timestamp, and range types, and partial-date handling (you met this in Module 6).

### 4. Lab / implementation assignment
Implement reading state with history, progress tracking, and the personal fields, across the database, the API, and the UI.

### 5. Requirements
- All five states, changeable from the detail view and quickly from the library view.
- Every change recorded in history with its date.
- A written transition table: allowed changes, and what each prompts for.
- Re-reads supported without losing earlier readings.
- Backfilling approximate past dates supported to a precision you define.
- Progress: chapter text and page number, with a percentage shown when a page count exists and a sensible display when it does not.
- All personal fields editable. Quotes and takeaways can hold more than one entry. Mood tags are selectable from previously used tags as well as new ones.
- The blurb remains yours alone.
- Any schema change is a new migration that preserves existing data, rehearsed on a branch first.
- Tests for the transition rules and for the migration.

### 6. Deliverables
- Reading state, history, progress, and personal fields, end to end.
- The transition table.
- Any migrations, with a note on how you rehearsed them.
- Journal entry 13.

### 7. Checkpoint
Take one real book through: unread, reading with progress updates, paused, reading again, read with a rating and notes, then a re-read. View its history. Every step is there with dates, and the first reading's data is intact.

### 8. Tests / acceptance criteria
- A disallowed transition is refused with a clear message.
- The current state always agrees with the latest history entry.
- A re-read adds to history and removes nothing.
- A page number beyond the page count is handled deliberately.
- Percentage is absent, not wrong, when the page count is missing.
- After the migration, row counts and spot-checked values match the pre-migration data.
- Private fields do not appear in any response intended for public use.

### 9. Common failure modes
- Current state and history drifting apart because they are written separately.
- A destructive migration run on real data first.
- Finish dates that precede start dates.
- Treating rating and reread score as the same thing.
- Personal fields attached to the copy, then lost when the copy is replaced.

### 10. Hint ladder (locked)
Topics: keeping current state and history consistent, modeling re-reads, data-preserving migrations, partial dates, tag storage.

### 11. Optional challenge
A yearly reading summary view: books finished, pages read, ratings distribution, genres. It is mostly SQL aggregation practice.

### 12. Project journal
What you built, whether your Module 2 placement decisions survived contact with real use, how the migration went, what is unfinished.

---

# Module 14: Series Support and Rule-Based Suggestions

**Milestone E. A library you use**

### 1. Learning objectives
- Implement ordering, next-book logic, and gap detection for series.
- Practice the SQL that these questions need: window functions, anti-joins, CTEs.
- Build simple, explainable suggestion rules.

### 2. Short reading / refresher
Series data is where external metadata is weakest, which is why series name and position are manually editable. Positions are not integers: novellas sit at 1.5, prequels at 0, and some series have competing orders (publication versus chronological).

**"Next book" is three different questions:**
- What is the next book in this series that I own and have not read?
- What is the next book in this series that I do not own? (A shopping question, and a wishlist candidate.)
- Which volumes am I missing in the middle? You can detect gaps between positions you hold. You cannot know a series continues past your last volume unless something tells you its length.

Edge cases worth a decision each: omnibus editions that contain several positions, a series you own out of order, a book in two series, and a series where you have read a later volume but not an earlier one.

**SQL refresher.** Window functions (`LAG`, `LEAD`, `ROW_NUMBER`) answer "the row after this one" questions. Anti-joins (`NOT EXISTS`, or `LEFT JOIN ... IS NULL`) answer "things without a matching thing". CTEs keep multi-step queries readable. These are the right tools here, and they are the part of SQL that fades fastest.

**Suggestions.** Five rules, each a query with a one-line explanation the user can see: next in series, same author as something you rated highly, same genre, oldest unread, newest added. No machine learning. A sixth rule, "something different from what I have been reading lately", is needed for Rose in Module 18; defining "different" is the interesting part.

### 3. Research / documentation
- PostgreSQL window functions and `WITH` queries.
- Sorting on numeric columns and handling missing positions.
- How your data access layer runs hand-written SQL, if you have been using an ORM.

### 4. Lab / implementation assignment
Build series views, next-book logic, gap detection, and the suggestion rules.

### 5. Requirements
- A series view listing its books in order with owned, read, and wishlist status visible.
- Series membership and position editable from the UI.
- Fractional and zero positions sort correctly. Books with no position have a defined place.
- The three next-book questions each answerable, through the API and in the UI.
- Gap detection with its limits stated in the UI (it reports known gaps and makes no claim of completeness).
- An optional, manually entered expected length for a series, if you decide it is worth having.
- A written decision for each edge case in the refresher.
- Five suggestion rules, each returning results with a human-readable reason.
- The sixth "something different" rule defined in writing and implemented.
- The interesting queries are written by you in SQL and tested against seed data designed to break them.

### 6. Deliverables
- Series features and suggestion rules, end to end.
- Edge-case decision notes.
- Journal entry 14.

### 7. Checkpoint
Pick three series you own: one complete and fully read, one partly read, and one with a gap or a novella. The series view, next-book answers, and gap report are right for all three. Then look at the suggestions and ask whether you would actually follow them.

### 8. Tests / acceptance criteria
- Positions 1, 1.5, 2, and 10 sort in that order.
- Next-unread skips books marked did-not-finish, or does not, according to your written rule.
- A series owned as 1, 2, 4 reports 3 as missing.
- A fully read series yields no next-unread result, and not an error.
- Each suggestion rule returns a reason with each result.
- No suggestion rule recommends a book you are currently reading.
- The "something different" rule returns nothing from the genre or author you have read most recently, per your definition.

### 9. Common failure modes
- Positions stored or sorted as text.
- Next-book logic that breaks on the last book of a series.
- Gap detection that assumes integer steps.
- Suggestion rules that all return the same book.
- Doing in application loops what one SQL query does better.

### 10. Hint ladder (locked)
Topics: window function framing, anti-join patterns, fractional gap logic, omnibus handling, defining "different".

### 11. Optional challenge
Support two orderings per series (publication and chronological) and let the user pick which one drives next-book logic.

### 12. Project journal
What you built, which SQL features you had to relearn, an edge case that surprised you, whether the suggestions are useful.

---

# Module 15: Testing and Failure Handling

**Milestone F. Hardening**

### 1. Learning objectives
- Consolidate the tests written since Module 5 into a deliberate strategy.
- Test failure paths systematically: bad input, upstream failure, database failure.
- Run the suite automatically on every push.

### 2. Short reading / refresher
You have been writing tests since Module 5. This module looks at the whole suite and asks what it fails to protect.

**Levels.** Unit tests cover pure logic (ISBN, normalization, transition rules, merge logic) and should be many and fast. Integration tests cover your code against a real database and your API through its HTTP surface. End-to-end tests drive the UI; a few go a long way. Invest most where bugs would be both likely and costly. For this project that means ingestion, duplicates, merges, and migrations.

**Database testing options:** a Neon branch per test run, a local PostgreSQL container, or transactions rolled back after each test. They differ in speed, fidelity to production, and isolation. Mocking the database entirely tests almost nothing about SQL.

**External services** are replaced in tests. You already have recorded responses from Module 6. Failure injection means deliberately producing each failure kind (timeout, connection refused, 429, 500, malformed body, valid but empty) and asserting on what your system does.

**Frontend testing.** A component test runner and a testing library that exercises components the way a user does. The scan-capture logic and the ingestion state machine are the high-value targets.

**Coverage** tells you what is not tested. It does not tell you that what is tested is tested well.

### 3. Research / documentation
- `pytest` fixtures, scopes, and markers; an HTTP mocking library compatible with your client.
- Your chosen database testing approach.
- Vitest and React Testing Library.
- A CI service's workflow syntax, and how it handles secrets for a test database.

### 4. Lab / implementation assignment
Audit the suite, fill the gaps, inject failures, and automate.

### 5. Requirements
- A written test strategy: what each level covers, which database approach you use, and what you chose not to test and why.
- A failure matrix: rows are failure kinds, columns are the features they can hit, and each cell names the expected behavior and the test that proves it.
- Failure-path tests for at least: malformed ISBNs at every entry point, each upstream failure kind for both metadata sources and for Groq, missing metadata fields, a database that is unreachable, a constraint violation, and a failure in the middle of a multi-record save or merge.
- Integration tests run against real PostgreSQL.
- Frontend tests for scan capture and the ingestion state machine.
- One command runs the backend suite, and one runs the frontend suite.
- CI runs both on every push. No production credentials in CI.
- Any bug found during this module gets a test that fails before the fix.

### 6. Deliverables
- The test strategy and failure matrix.
- The expanded suites, green.
- CI configuration.
- Journal entry 15.

### 7. Checkpoint
Introduce three deliberate bugs into your own code, one at a time, in ingestion, duplicate detection, and series ordering. The suite catches all three. If it misses one, that is your next test.

### 8. Tests / acceptance criteria
- The backend suite passes with the network disconnected.
- Every cell of the failure matrix names a passing test.
- With the database unreachable, the API returns your standard error shape and the UI shows a recoverable error state.
- A failed merge leaves the data exactly as it was.
- CI fails when a test fails.
- The three-bug checkpoint passes.

### 9. Common failure modes
- Tests that mock so much they test the mocks.
- Tests that depend on execution order or shared state.
- Tests that hit live external APIs.
- Only happy paths.
- Chasing a coverage number.
- A test database that is secretly the development database.

### 10. Hint ladder (locked)
Topics: test isolation with a real database, simulating upstream failures, testing a state machine, making CI talk to a database safely.

### 11. Optional challenge
Property-based testing for the ISBN module: generate valid ISBNs, corrupt one digit, and assert detection. Or one true end-to-end browser test of scan-to-saved.

### 12. Project journal
What the audit found, bugs the new tests exposed, which failure was handled worst before this module, what is still untested.

---

# Module 16: Security and Configuration

**Milestone F. Hardening**

### 1. Learning objectives
- Build a threat model proportionate to a LAN-hosted personal application.
- Apply least privilege at the database role level.
- Audit configuration, secrets, input handling, and dependencies.

### 2. Short reading / refresher
Security work starts with a threat model: what are you protecting, from whom, and what is realistic? This is a personal app on a home LAN with a cloud database. The realistic threats are a leaked credential, an over-privileged connection string, a service accidentally reachable from the internet, other devices on your network, a vulnerable dependency, and later a public page and an AI agent reading your data. The proportionate response is to get the fundamentals right.

**Least privilege.** Your application currently connects to Neon with whatever role you first created, which can probably do anything, including dropping tables. Separate roles for separate jobs: one that owns and migrates the schema, one the application uses for ordinary reads and writes, and a read-only role. The read-only role is what the public page and Rose will use, so this module prepares Modules 18 and 19.

**Secrets.** Every secret comes from the environment, has an entry in `.env.example`, and can be rotated. Assume that any secret that ever touched Git history, a screenshot, or a chat log is compromised.

**Input.** Validation at the boundary (Pydantic), parameterized queries always, and output encoding in the UI for text that came from external APIs or from your own notes. Find every place SQL is built, and confirm none of it uses string formatting with external values.

**Network exposure.** Which interface the server binds to, what your router forwards, whether CORS allows only the origins you use, and whether error responses and logs leak internals or secrets.

**Dependencies** are code you run but did not write. Both ecosystems have audit tools.

### 3. Research / documentation
- PostgreSQL roles, `GRANT`, `REVOKE`, default privileges, and how Neon manages roles.
- OWASP Top 10, read selectively for what applies.
- Dependency audit tools for Python and npm.
- A Git history secret scanner.

### 4. Lab / implementation assignment
Threat model, role separation, and a security audit of your own application.

### 5. Requirements
- `docs/threat-model.md`: assets, actors, entry points, realistic threats, and your response to each, including the ones you accept.
- Three database roles as described above, created by script or migration. The application runs as the application role. Migrations run as the owner role.
- Proof that the read-only role cannot write, and that the application role cannot alter the schema.
- A Git history scan for secrets, and rotation of anything found.
- An audit of every SQL construction site, with findings.
- An audit of every input boundary: API bodies, query parameters, scanner input, QR payloads, external API responses, LLM output.
- CORS restricted to known origins. The bind address is deliberate and documented.
- Logs and error responses checked for secrets and internals.
- Dependency audits run for both ecosystems, with findings triaged.
- `.env.example` complete. Application startup fails fast, with a clear message, when a required setting is missing.

### 6. Deliverables
- The threat model.
- Role setup, with the verification evidence.
- An audit findings list with each item fixed or explicitly accepted.
- Journal entry 16.

### 7. Checkpoint
Connect as the read-only role and try to insert, update, delete, and drop. Every attempt fails. Connect as the application role and try to drop a table. It fails. From a device outside your LAN (a phone on cellular), confirm the backend is unreachable.

### 8. Tests / acceptance criteria
- The privilege probes above fail as expected, and the script that runs them is in the repo.
- The secret scanner reports a clean history, or every finding is rotated.
- No SQL is built by formatting external values into strings.
- A missing required setting stops startup with a message naming it.
- A request from an unlisted origin is refused by CORS.
- No response body contains a stack trace, connection string, or key.

### 9. Common failure modes
- One all-powerful role for everything.
- Deleting a leaked secret from the latest commit and considering it handled.
- Security by "it is only on my LAN".
- Granting privileges on existing tables and forgetting tables created later.
- Treating LLM output or QR payloads as trusted because you generated them.

### 10. Hint ladder (locked)
Topics: role and grant design, default privileges for future tables, finding injection sites, scoping a threat model, fail-fast configuration.

### 11. Optional challenge
Put the backend behind HTTPS on the LAN and document what that does and does not protect against in your threat model.

### 12. Project journal
What the audit found, what you rotated, which finding surprised you, which risks you consciously accepted.

---

# Module 17: Mobile Client

**Milestone G. Beyond the desk**

### 1. Learning objectives
- Build an Expo / React Native client that uses the same backend as the web client.
- Scan ISBN barcodes with the phone camera.
- Introduce authentication because writes are about to leave the LAN, and decide how the backend becomes reachable.

### 2. Short reading / refresher
React Native shares React's model (components, hooks, state) and none of the DOM. Layout is flexbox only, there is no CSS cascade, navigation is a library decision, and touch targets and keyboards behave differently. Expo gives you a managed toolchain. Know the difference between running in Expo Go and running a development build, because some native modules need the latter.

**Camera scanning** differs from the USB scanner in useful ways. You get a real scan event with a declared barcode type, along with new problems: permissions, repeated detections of the same code while it stays in frame, focus and lighting, and the price add-on barcode sitting next to the ISBN. Expo's barcode scanning API has moved between packages across SDK versions, so check the documentation for the SDK you install and do not trust older tutorials.

**Sharing with the web client.** Both are TypeScript and both need API types, an API client, and ISBN validation. Options: a shared package in a monorepo workspace, types generated from your FastAPI OpenAPI schema, or duplication. They differ in setup cost and in how they fail when the API changes.

**Reachability and auth.** So far the backend is LAN-only and has no login. A phone in a bookstore is not on your LAN. Options:
- Keep the backend private and put the phone on the home network virtually with a VPN or mesh network such as WireGuard or Tailscale. No public surface; auth can stay minimal; depends on the VPN being up.
- Host the backend publicly and add real authentication. Options within that: a static API token, username and password with sessions or JWTs, or passkeys. They differ in effort, in what a stolen phone means, and in how a second user would fit.
- Limit the phone to the home network and accept that it is a couch scanner. Simplest; least useful.

Return to your Module 16 threat model before choosing; this module changes it.

### 3. Research / documentation
- Expo docs: project setup, development builds, camera and barcode scanning for your SDK version, permissions, environment configuration.
- A React Native navigation library.
- OpenAPI type generation for TypeScript.
- The reachability option you lean towards: its setup and its failure modes.
- If you choose public hosting: FastAPI security utilities and token handling on mobile (secure storage, never plain async storage).

### 4. Lab / implementation assignment
Build the mobile client: camera scan, lookup, review, save, and a basic library view, against the same backend.

### 5. Requirements
- An Expo + TypeScript app in `mobile/`, strict mode on.
- Camera ISBN scanning with permission handling, including the denied case.
- One scan event per book, however long the barcode stays in frame.
- The add-on barcode does not produce a bogus lookup.
- The scan feeds the same backend pipeline as the web client: lookup, duplicate check, review, blurb, save. No business logic is reimplemented on the phone.
- A quick "do I own this?" mode that scans and answers without starting the add flow. This is the bookstore use case.
- A wishlist-add path from a scan.
- A basic library view with search.
- A documented decision on sharing types and client code with `web/`.
- A documented decision on reachability and authentication, with the threat model updated. Whatever you choose is implemented and tested, including the unauthenticated-request case if you add auth.
- If a second household user is in scope per Module 1, the auth design accounts for them.
- The API base address is configuration and not a hard-coded value.
- Tested on your physical phone.

### 6. Deliverables
- The mobile client.
- Decision notes: code sharing, reachability, auth.
- Updated threat model and README.
- Journal entry 17.

### 7. Checkpoint
Stand at your shelves with only your phone. Check whether you own three books (one you do, one you do not, one you own in a different edition), add one new book with a blurb, and add one wishlist entry. Then confirm on the desktop client that everything is there. If you chose remote access, repeat the ownership check on cellular data.

### 8. Tests / acceptance criteria
- Holding a barcode in frame for five seconds produces one lookup.
- Denying camera permission produces an explanation and a way forward, and not a blank screen.
- A book added on mobile is indistinguishable in the database from one added on desktop.
- With the backend unreachable, the app says so and loses no typed input.
- If auth was added: a request without valid credentials is refused, credentials are in secure storage, and the web client still works.
- The "do I own this?" answer distinguishes same edition, different edition, and not owned.

### 9. Common failure modes
- Reimplementing duplicate or validation logic on the phone.
- A hard-coded LAN IP address that breaks when DHCP reassigns it.
- The scan handler firing dozens of times per second.
- Following a tutorial written for an older Expo SDK.
- Exposing the backend publicly first and adding auth afterwards.
- Tokens in plain storage.

### 10. Hint ladder (locked)
Topics: debouncing camera detections, sharing types, development builds, choosing a reachability model, token storage, React Native layout differences.

### 11. Optional challenge
An offline queue: scans made with no connection are stored on the device and submitted later. Consider what duplicate detection means for a queued scan.

### 12. Project journal
What you built, React Native surprises, which reachability and auth option you chose and what it cost, how the bookstore test went.

---

# Module 18: Rose / OpenClaw Read-Only Integration

**Milestone G. Beyond the desk**

### 1. Learning objectives
- Design an access path for an AI agent under least privilege.
- Design query endpoints for a machine consumer.
- Treat your own stored text as untrusted input to an agent.

### 2. Short reading / refresher
Rose gets read-only access and nothing more. The questions she should be able to answer:

- What books do I own?
- Do I already own this book?
- What am I currently reading?
- What should I read next?
- What is the next book in a series I own?
- Which books have I owned for a long time but never read?
- Suggest something different from what I have recently been reading.

Most of these are already answered by logic from Modules 10, 13, and 14. This module is about the boundary.

**Access path options:**
- Rose connects to Neon directly with the read-only role from Module 16. Flexible, since she can write any query. It also means she sees every column the role can see, her queries are unreviewed, and your schema becomes her interface, so every migration can break her.
- Rose calls a read-only subset of your API with her own scoped credential. You decide exactly what she can ask and what comes back, the interface is stable, and it depends on the API being reachable from wherever OpenClaw runs.
- A hybrid: database views that expose a curated surface to a read-only role.

**Designing for an agent.** An agent reads your endpoint descriptions to decide what to call, so names and descriptions are part of the interface. Responses should be small, flat, and self-explanatory, with sensible limits so a broad question does not return the entire library into her context. "Do I own this?" must work from a title she heard in conversation and not only from an ISBN, which makes it a fuzzy search problem with the same three-way answer as Module 10.

**Your data is untrusted input to her.** Notes, blurbs, and external descriptions are free text that will land in an agent's context. Text that looks like instructions is a prompt injection risk even when you wrote the database yourself, because external metadata descriptions are in there too. Decide which fields Rose receives at all, and keep private fields private per Module 1.

**Read-only must be enforced and not promised.** The credential itself must be incapable of writing, whatever Rose is asked or tricked into attempting.

### 3. Research / documentation
- How OpenClaw defines tools or skills, and how it stores credentials for them.
- PostgreSQL views and granting on views, if you consider the hybrid.
- API key scoping and rate limiting in FastAPI.
- Prompt injection through retrieved data.

### 4. Lab / implementation assignment
Design and build Rose's read-only access, and the OpenClaw-side definition that uses it.

### 5. Requirements
- A documented decision on the access path, with the tradeoffs you weighed.
- A distinct credential for Rose, separate from every other client, revocable without affecting anything else.
- The credential cannot write. This is demonstrated and not assumed.
- Each of the seven questions maps to a defined query or endpoint, with bounded response sizes.
- "Do I own this?" accepts a title, an author, or an ISBN, and distinguishes same edition, different edition, wishlisted, and not owned.
- "Owned for a long time but never read" has a written definition.
- "Something different" reuses your Module 14 rule.
- Every suggestion carries its reason, so Rose can explain herself.
- A written list of fields Rose can see, consistent with your Module 1 privacy decision.
- Requests are logged, so you can see what she asked.
- Rate limiting or an equivalent bound.
- The OpenClaw tool or skill definition is written by you.
- Tests for every endpoint or query, and for the write-refusal.

### 6. Deliverables
- Rose's access path, credential, and endpoint set.
- The OpenClaw definition.
- Updated threat model.
- Journal entry 18.

### 7. Checkpoint
Ask Rose all seven questions in natural language over your usual channel. Check each answer against the UI. Then instruct her to mark a book as read or to delete one. She cannot, and the failure is visible in your logs as a refused operation and not as a silent success.

### 8. Tests / acceptance criteria
- Every write attempt with Rose's credential is refused at the enforcement layer.
- Revoking her credential stops her access and nothing else.
- No private field appears in any response she can obtain.
- A title-based ownership query finds a book despite a missing subtitle or a leading article.
- The broadest possible query returns a bounded response.
- A book whose description contains instruction-like text does not change her behavior in a test conversation.
- All seven questions return correct answers against seed data.

### 9. Common failure modes
- Reusing the application's credential for the agent.
- Enforcing read-only in the prompt instead of in the credential.
- Responses so large they crowd out the conversation.
- Exposing the raw schema and then breaking Rose with the next migration.
- Forgetting that external descriptions are untrusted text.

### 10. Hint ladder (locked)
Topics: choosing the access path, scoping a credential, shaping responses for an agent, fuzzy ownership lookup, testing for injection.

### 11. Optional challenge
See Module 20: the narrow wishlist insert path. It builds directly on this module's credential design.

### 12. Project journal
What you built, which access path you chose and why, how well Rose answered, anything she could see that she should not have.

---

# Module 19: Deployment, Public Page, Documentation, Retrospective

**Milestone G. v1.0 tagged**

### 1. Learning objectives
- Run the application as a dependable service and not a terminal you remember to open.
- Build and deploy the public view-only page with its own least-privilege access.
- Finish the documentation, establish backups, and close the project properly.

### 2. Short reading / refresher
**Deployment for this project has three parts.**

*The backend.* If it stays at home, it should start on boot, restart on failure, and write logs somewhere you can find them. Options include an OS service manager, a container with a restart policy, or a process manager. If Module 17 moved it to a public host, the same questions apply there, plus the platform's own deployment model.

*The web client.* A production build served as static files, by the backend or by a separate static server. The API address differs between development and production builds.

*The public page.* A view-only page at salishcode.com/library, served by a Netlify function that reads from Neon. The function uses a read-only role, returns only the fields you declared public in Module 1, and has no route that writes. A serverless function opening direct database connections per invocation is a known problem; Neon documents the approaches. Design an explicit allowlist of returned columns. Anything else will leak a private field the first time you add one.

**Migrations in production.** The order matters: back up, migrate, deploy the code that needs the migration. Know your rollback path before you start.

**Backups.** Neon offers point-in-time restore and branching within limits that depend on your plan. An independent periodic `pg_dump` protects against losing the account or the project. A backup you have never restored is a hope.

**Documentation.** The README gets someone from a fresh clone to a running system. An architecture document explains the parts and why they are the way they are, and your `docs/decisions/` folder is most of it already. A short runbook covers: start, stop, deploy, migrate, back up, restore, rotate a secret, reconfigure the scanner.

### 3. Research / documentation
- A service manager or container runtime for the machine that hosts the backend.
- Netlify functions: environment variables, and connecting to Neon from serverless.
- Neon backup, restore, and branch-retention behavior on your plan.
- `pg_dump` and `pg_restore`.
- Semantic versioning and Git tags.

### 4. Lab / implementation assignment
Deploy all three parts, establish backups, finish the documentation, tag v1.0, and write the retrospective.

### 5. Requirements
- The backend runs as a service that survives a reboot and restarts after a crash, with logs retained.
- The web client is served from a production build.
- A production configuration separate from development, with production secrets never on a development branch.
- A written deploy procedure that includes migrations, followed at least once for real.
- The public page: view-only, read-only role, explicit column allowlist, search and filter over title, read status, and blurb, and whatever else you declared public. It works on a phone.
- A test proving no private field can appear in the public function's output.
- A scheduled independent backup, and one full restore rehearsed into a scratch database.
- README complete from a fresh clone. Architecture document. Runbook.
- Dead code, stale TODOs, and abandoned experiments removed or ticketed.
- v1.0 tagged.
- A retrospective.

### 6. Deliverables
- The running deployment, all three parts.
- Backup job and restore evidence.
- README, architecture document, runbook.
- The v1.0 tag.
- `docs/retrospective.md` and the final journal entry.

### 7. Checkpoint
Reboot the host machine and do nothing. Five minutes later, scan a book successfully. Open salishcode.com/library on your phone over cellular and find that book. Restore last night's backup into a scratch database and find it there too.

### 8. Tests / acceptance criteria
- The backend is reachable after a reboot with no manual step.
- Killing the backend process results in an automatic restart.
- The public function's responses contain only allowlisted fields, verified by test.
- The public function's database role cannot write.
- A restore from backup produces a database that passes a row-count and spot-check comparison.
- A fresh clone plus the README yields a running development environment.
- The repository contains no secrets, and `main` is green in CI at the v1.0 tag.

### 9. Common failure modes
- A deployment that lives in shell history.
- The public function using the application's connection string.
- Selecting all columns in the public query and filtering afterwards.
- Connection exhaustion from serverless invocations.
- Backups that have never been restored.
- A README describing the project as it was in Module 4.

### 10. Hint ladder (locked)
Topics: service configuration, serverless-to-Postgres connections, column allowlisting, migration ordering, rehearsing a restore.

### 11. Optional challenge
One-command deploys, or a CI job that deploys on a tagged release.

### 12. Project journal and retrospective
The retrospective is the one longer piece of writing in the workbook, and bullet points are still fine: what you built, what you would design differently, which skills came back fastest and which are still weak, the worst bug, what you would tell yourself at Module 0, and what comes next.

---

# Module 20: Optional Advanced Extensions

**Milestone H. Extensions**

Each extension is a self-directed mini-module. Before starting one, write its objectives, requirements, and acceptance criteria yourself in the twelve-part format, and bring them for review. The same workbook rules and hint ladder apply.

### Carried over from the earlier project plan

1. **Narrow wishlist insert path for Rose via Telegram.** Insert-only, wishlist-only, with a credential separate from her read credential. She resolves a title or ISBN against Open Library and adds a wishlist entry. Questions to answer: how the insert-only limit is enforced at the credential level, how a wrong match is caught and undone, what she may never touch, and how this changes the threat model. Builds on Module 18.
2. **pgvector semantic search over your blurbs.** Deferred on purpose until enough blurbs exist for embeddings to mean something. Concepts: embeddings, vector similarity, index types, keeping embeddings in step with edited text.
3. **Sandboxed demo for the Salish Code Solutions page.** Pure frontend, static seed data in the bundle, Open Library called directly from the browser, no backend and no database. The constraint is the lesson: what changes when there is no server to hold a boundary?
4. **Goodreads-compatible CSV export.**

### Further ideas

5. **Spine OCR.** Photograph a shelf and identify books from spine text. The earlier scaffold's notes apply: rotated and stylized text is the hard case, and preprocessing is where the work is.
6. **Lending tracker.** Which copy is with whom, since when.
7. **Statistics dashboard.** Reading pace, genre mix over time, shelf age.
8. **Local cover cache** with resizing, replacing hotlinked covers.
9. **Passkey authentication**, if Module 17 used something simpler.
10. **Bulk import** from the ISBN text file of a batch scanning session, with a review queue.
