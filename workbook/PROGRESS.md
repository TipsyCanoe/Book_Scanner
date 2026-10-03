# Progress Tracker

Statuses: `NOT STARTED`, `IN PROGRESS`, `BLOCKED`, `COMPLETE`.

Rules:
- You change the statuses. The reviewer never marks a module COMPLETE; it happens only when you say the required deliverables are done.
- COMPLETE means every item under "Deliverables" exists and the "Checkpoint" passed. Optional challenges do not count either way.
- BLOCKED needs a one-line reason in the Notes column.
- Only one module should be IN PROGRESS at a time, apart from a BLOCKED one you have stepped around.

| # | Module | Milestone | Status | Started | Completed | Notes |
|---|---|---|---|---|---|---|
| 0 | Environment, repository, journal, Git workflow | A | NOT STARTED | | | |
| 1 | Requirements and application plan | A | NOT STARTED | | | |
| 2 | Domain modeling | B | NOT STARTED | | | |
| 3 | Relational database design | B | NOT STARTED | | | |
| 4 | PostgreSQL / Neon implementation | B | NOT STARTED | | | |
| 5 | ISBN fundamentals | C | NOT STARTED | | | |
| 6 | External metadata APIs | C | NOT STARTED | | | |
| 7 | Backend / API | C | NOT STARTED | | | |
| 8 | Barcode scanner input | D | NOT STARTED | | | |
| 9 | Book ingestion pipeline | D | NOT STARTED | | | |
| 10 | Duplicate and edition handling | D | NOT STARTED | | | |
| 11 | Genre classification | E | NOT STARTED | | | |
| 12 | Library UI | E | NOT STARTED | | | |
| 13 | Reading state, history, progress, personal fields | E | NOT STARTED | | | |
| 14 | Series support and rule-based suggestions | E | NOT STARTED | | | |
| 15 | Testing and failure handling | F | NOT STARTED | | | |
| 16 | Security and configuration | F | NOT STARTED | | | |
| 17 | Mobile client | G | NOT STARTED | | | |
| 18 | Rose / OpenClaw read-only integration | G | NOT STARTED | | | |
| 19 | Deployment, public page, documentation, retrospective | G | NOT STARTED | | | |
| 20 | Optional advanced extensions | H | NOT STARTED | | | |

## Milestones

| Milestone | Reached when | Done |
|---|---|---|
| A. Foundations | Modules 0 and 1 complete | [ ] |
| B. Data layer | Schema live in Neon (Module 4) | [ ] |
| C. Lookup core | API returns candidate metadata for an ISBN (Module 7) | [ ] |
| D. First usable version | Scan to saved book with duplicate handling (Module 10) | [ ] |
| E. A library you use | Modules 11 to 14 complete | [ ] |
| F. Hardening | Modules 15 and 16 complete | [ ] |
| G. Beyond the desk | v1.0 tagged (Module 19) | [ ] |
| H. Extensions | Open-ended | [ ] |

## Hint usage log

Optional, and useful for the retrospective: which modules needed which hint levels.

| Module | Topic | Highest hint level used |
|---|---|---|
| | | |

## Session resume

Paste this at the start of a new session, filled in:

```
WORKBOOK MODE: Personal Library project.
Current module: <number and name>
Status: <IN PROGRESS | BLOCKED>
Done so far in this module: <deliverables finished>
Working on: <the requirement or bug in front of me>
Hints already used in this module: <topic and level, or none>
What I want from this session: <review | hint | concept refresher | discuss a design choice>
```

Then attach or paste the relevant code, design document, or error output.
