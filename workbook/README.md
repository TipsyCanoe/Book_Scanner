# Personal Library Management System: Project Workbook

A self-guided, upper-division-style software project. You design and write the application. This workbook supplies the tasks, the background, the acceptance criteria, and the review process. It contains no implementation code, no schema, and no finished endpoints, and it never will.

Files in this workbook:

- `README.md`: this file. Rules, settled decisions, module map, repo structure.
- `MODULES.md`: all 21 modules, in order.
- `PROGRESS.md`: the progress tracker and the session-resume format.
- `JOURNAL.md`: the project journal template.
- `HINTS.md`: what to do when stuck, how to request a hint, and a per-module record of hints received. Holds no hint content itself.
- `RESOURCES.md`: documentation and references by module, plus relevant snippets from your snippet library.

---

## 1. Teaching contract

You are the student and you write the implementation. In workbook mode the reviewer (Claude) will:

**Not do:** complete implementation code, finished functions for assignments, the final SQL schema, finished API endpoints, finished React or React Native components, exercise solutions, code replacement when correcting, full answers on request, silent completion of unfinished parts, TODOs turned into code, or copy/paste solutions dressed up as examples.

**Do:** explain concepts, point out wrong reasoning or wrong implementation, identify bugs without fixing them, explain documentation, give pseudocode when appropriate, give tiny isolated syntax examples that are not the assignment's solution, suggest debugging strategies, point to documentation, review your code and your database design, review implementation choices, and write tests or specifications your code should eventually satisfy.

Where there is a meaningful implementation choice, the workbook lays out the options and tradeoffs and leaves the choice to you. Decisions get a line or two in `docs/decisions/`, not an essay.

### Override

If you say "just give me the answer", "write it for me", "fix this", or "show me the code", the reviewer reminds you that you asked for workbook mode and offers the next hint level.

The only override is the exact phrase:

> EXIT WORKBOOK MODE

After that phrase, normal coding assistance resumes.

---

## 2. Hint ladder

Hints exist for every lab but are never shown unprompted. Ask for them by level.

| Level | What you get |
|---|---|
| Hint 1 | A small conceptual nudge. |
| Hint 2 | A pointer to the relevant concept, doc page, file, data structure, SQL feature, or API feature. |
| Hint 3 | A more explicit explanation or pseudocode. Still no implementation. |
| Hint 4 | A detailed walk through the problem and the reasoning. The implementation is still yours. |

Rules:

- The next level is given only when you explicitly ask for it.
- Hint 4 is not the finished answer.
- If you are stuck because a prerequisite has gone fuzzy, the reviewer refreshes the prerequisite and then returns you to the lab.
- Work the stuck protocol in `HINTS.md` first, and record what you receive there. `RESOURCES.md` lists where to read.

---

## 3. Code review protocol

When you submit code you wrote:

1. The reviewer reads your implementation.
2. States whether it satisfies the current assignment.
3. Identifies bugs, wrong assumptions, and problem areas.
4. Does not rewrite it.
5. Gives Hint 1 for each problem found.
6. Waits for your fix attempt.
7. Gives stronger hints only on request.

Every review reports four things: what is working, what is incorrect, where the problem appears to be, and what to investigate next.

---

## 4. Settled decisions

These were decided before the workbook was written. The modules assume them.

**Stack**

- Backend: FastAPI (Python).
- Web client: React + TypeScript (Vite).
- Mobile client: Expo / React Native + TypeScript (Module 17).
- Database: Neon PostgreSQL. The project database is empty. There is no data migration from the earlier flat-table app; that app is reference only and its schema is not reused.

**Hardware and workflow**

- Scanner: Eyoyo EYH2 wired USB 2D scanner. It behaves as a keyboard, sends Enter after each scan, reads EAN-13 and QR, and can be configured to output either ISBN-10 or the full 13-digit EAN.
- The collection is roughly 150 books. Scanning is slow and ongoing, a shelf at a time, not a batch import.
- A personal "what I thought" blurb is written at scan time. It is separate from the book's description and is never overwritten by fetched or generated text.
- An existing `books.csv` (title and author only) is available as a cross-check for books the scanner misses.

**Metadata**

- Open Library is the primary source. Google Books is secondary: fallback, and the subject of the lab on conflicting and missing data.
- Open Library series data is unreliable. Series name and position are manually editable. Series position supports values like 1.5.

**Features beyond the core Work / Edition / Copy model**

- Wishlist (wanted, not owned).
- Books with no ISBN: manual entry plus a generated QR label the scanner can read back.
- Reading progress: current chapter (free text) and current page (integer).
- Personal fields: notes, favorite quotes, writer takeaways, mood tags, reread score (1 to 5), rating.
- Reading states: unread, reading, read, paused, did-not-finish, with history.
- Genre: primary and secondary, classified by an LLM (Groq Llama) with human override. Decided taxonomy rules: an author can split across genres by book (Le Guin: Earthsea is Epic Fantasy, Hainish is Classic SF); Indigenous Literature is its own primary genre; Indigenous authorship wins the primary-genre tiebreak.
- Rule-based suggestions only: next in series, same author, same genre, oldest unread, newest added. No ML recommender.

**Access and deployment**

- Desk writes happen on the home LAN through the FastAPI app. No public write surface and no login in the first version.
- Public access is a view-only page at salishcode.com/library, served by a Netlify function reading from Neon.
- Authentication is introduced in the mobile module, as a consequence of writes leaving the LAN, and not earlier.
- Rose / OpenClaw access is strictly read-only. A narrow wishlist insert path for Rose is listed as an optional extension in Module 20.

**Open decision you make in Module 1:** single-user or multi-user (a second household user may use the app).

---

## 5. Architecture

```
USB barcode scanner (keyboard input)
        |
   web client (React + TS)          mobile client (Expo, Module 17)
        |                                   |
        +---------------+-------------------+
                        |
               your backend (FastAPI)
                  |              |
   Open Library / Google Books   Groq (genre, Module 11)
                  |
        normalization / validation
                  |
           Neon PostgreSQL
                  |
     read-only consumers: public Netlify page (Module 19), Rose (Module 18)
```

No client ever holds database credentials. Read-only consumers get their own least-privilege access.

---

## 6. Module map and milestones

| # | Module | Milestone |
|---|---|---|
| 0 | Environment, repository, journal, Git workflow | **A. Foundations** |
| 1 | Requirements and application plan | A |
| 2 | Domain modeling | **B. Data layer** |
| 3 | Relational database design | B |
| 4 | PostgreSQL / Neon implementation | B: schema live in Neon |
| 5 | ISBN fundamentals | **C. Lookup core** |
| 6 | External metadata APIs | C |
| 7 | Backend / API | C: API returns candidate metadata for an ISBN |
| 8 | Barcode scanner input (web client begins) | **D. First usable version** |
| 9 | Book ingestion pipeline | D |
| 10 | Duplicate and edition handling | D: scan to saved book. Start scanning real shelves here. |
| 11 | Genre classification | **E. A library you use** |
| 12 | Library UI | E |
| 13 | Reading state, history, progress, personal fields | E |
| 14 | Series support and rule-based suggestions | E |
| 15 | Testing and failure handling | **F. Hardening** |
| 16 | Security and configuration | F |
| 17 | Mobile client | **G. Beyond the desk** |
| 18 | Rose / OpenClaw read-only integration | G |
| 19 | Deployment, public page, documentation, retrospective | G: v1.0 tagged |
| 20 | Optional advanced extensions | **H. Extensions** |

Changes from the originally proposed sequence: a genre classification module was added after duplicate handling, rule-based suggestions were folded into the series module, and everything after shifted by one. Testing starts in Module 5 and is practiced in every module after it; Module 15 consolidates and fills the gaps rather than introducing testing for the first time.

---

## 7. Module format

Every module in `MODULES.md` has the same twelve parts:

1. Learning objectives
2. Short reading / refresher
3. Research / documentation
4. Lab / implementation assignment
5. Requirements
6. Deliverables
7. Checkpoint
8. Tests / acceptance criteria
9. Common failure modes
10. Hint ladder (locked; topics listed, content given only on request)
11. Optional challenge
12. Project journal prompt

---

## 8. Progress system

`PROGRESS.md` holds one row per module with a status of NOT STARTED, IN PROGRESS, BLOCKED, or COMPLETE. A module becomes COMPLETE only when you say its required deliverables are done. The reviewer never marks it for you.

To resume in a new session, paste the "Session resume" block from `PROGRESS.md`.

---

## 9. Suggested repository structure

Top level only. The internal layout of `backend/`, `web/`, and `mobile/` is a design decision you make in the modules that create them.

```
personal-library/
  README.md            project README (you write it; finished in Module 19)
  .gitignore
  .env.example         names of required settings, never values
  workbook/            these six files
  docs/
    requirements.md    Module 1
    domain-model.md    Module 2
    erd.*              Module 3
    genre-taxonomy.md  Module 11
    api-notes/         Module 6 (field mappings, saved sample responses)
    decisions/         one short file per significant decision
  backend/             FastAPI app, migrations, backend tests
  web/                 React + TypeScript client
  mobile/              Expo client (Module 17)
  public-page/         Netlify function and view-only page (Module 19)
  scripts/             one-off utilities (CSV cross-check, label printing)
```

---

## 10. Where to begin

Open `MODULES.md` at Module 0. Set `PROGRESS.md` Module 0 to IN PROGRESS. Write your first `JOURNAL.md` entry when Module 0's deliverables are done, then bring questions or code for review whenever you want them.
