# Hints

The place to go when you are stuck. This file holds the *process* and the *record*. It deliberately holds no hint content: under the workbook's teaching contract ([`README.md`](README.md) section 2), hints are given by the reviewer, one level at a time, only when you ask. Paste what you receive into the module section below so you can find it again.

Related files:

- [`RESOURCES.md`](RESOURCES.md): documentation and references to read *before* and *alongside* asking for a hint.
- [`PROGRESS.md`](PROGRESS.md): the one-line "highest hint level used" log for the retrospective.
- [`JOURNAL.md`](JOURNAL.md): what you learned from getting unstuck.

---

## 1. Before you ask: the stuck protocol

Work down this list. Most problems end somewhere in steps 1 to 5, and writing the answers down for step 6 is usually where the penny drops.

1. **Timebox it.** Decide up front: 20 to 30 minutes on a single problem before you escalate. Note the start time in the stuck log.
2. **Read the actual error.** Top to bottom, then bottom to top. The last line names the failure; the first line of *your* code in the traceback is where to look.
3. **State what you expected and what happened.** One sentence each. If you cannot write the first sentence, you are stuck on understanding, not on a bug: go back to the module's refresher (section 2).
4. **Shrink it.** Delete code until the problem still happens with the least possible code, or reproduce it in a scratch file / `psql` / a REPL. A failure you can reproduce in ten lines is half-solved.
5. **Check one assumption at a time.** Print or log the real value, query the real row, `curl` the real endpoint. Do not change two things between runs.
6. **Read the primary source.** The module's section 3 list and [`RESOURCES.md`](RESOURCES.md). Search the exact error message in quotes, plus the library name.
7. **Step away** for ten minutes if you are going in circles. Then re-read your step 3 sentences.
8. **Ask for Hint 1.** Use the request format below.

If the cause is a *prerequisite that has gone fuzzy* (SQL joins, async, TypeScript narrowing), say so. The reviewer will refresh that prerequisite and send you back to the lab. That is not a hint level.

## 2. How to ask

Paste this, filled in, along with the code, schema, or error output:

```
HINT REQUEST
Module: <number and name>
Topic: <one of the topics listed for the module below, or "other">
Level wanted: <1 | 2 | 3 | 4>   (next level only; I have used up to <n> on this topic)
Expected: <one sentence>
Actual: <one sentence, include the exact error text>
Tried: <what you ruled out and how>
```

Rules of the ladder, repeated so they are in front of you:

| Level | What you get |
|---|---|
| Hint 1 | A small conceptual nudge. |
| Hint 2 | A pointer to the relevant concept, doc page, file, data structure, SQL feature, or API feature. |
| Hint 3 | A more explicit explanation or pseudocode. Still no implementation. |
| Hint 4 | A detailed walk through the problem and the reasoning. The implementation is still yours. |

- You get the next level only when you ask for it.
- Hint 4 is not the finished answer.
- To drop the whole contract, the only phrase is `EXIT WORKBOOK MODE`.

## 3. After you get unstuck

1. Write one line in the module's notes below: what the problem really was.
2. Update the highest level used in [`PROGRESS.md`](PROGRESS.md) (hint usage log).
3. If it will bite you again, add it to the module's "Common failure modes" in your journal entry.
4. Ask yourself what you could have checked in steps 1 to 5 that would have found it.

## 4. Stuck log

One row per time you hit the timebox. Newest at the bottom.

| Date | Module | What I was doing | What I expected / got | Rules-outs so far | Highest hint level | What it turned out to be |
|---|---|---|---|---|---|---|
| | | | | | | |

---

## 5. Per-module hint record

Topics are copied from section 10 of each module in [`MODULES.md`](MODULES.md). Tick `L1` to `L4` as you receive each level and paste the hint under "Received". Nothing is pre-filled on purpose.


### Module 0: Environment, Repository, Journal, Git Workflow

| Topic | L1 | L2 | L3 | L4 |
|---|---|---|---|---|
| Choosing a Python tool | [ ] | [ ] | [ ] | [ ] |
| What to ignore | [ ] | [ ] | [ ] | [ ] |
| Pinning versions | [ ] | [ ] | [ ] | [ ] |
| Recovering from a bad commit | [ ] | [ ] | [ ] | [ ] |

Received:
-

What it really was:
-

### Module 1: Requirements and Application Plan

| Topic | L1 | L2 | L3 | L4 |
|---|---|---|---|---|
| Making a requirement testable | [ ] | [ ] | [ ] | [ ] |
| Thinking through the multi-user consequences | [ ] | [ ] | [ ] | [ ] |
| Scoping Milestone D | [ ] | [ ] | [ ] | [ ] |

Received:
-

What it really was:
-

### Module 2: Domain Modeling

| Topic | L1 | L2 | L3 | L4 |
|---|---|---|---|---|
| Attribute placement tests | [ ] | [ ] | [ ] | [ ] |
| Where reading state belongs | [ ] | [ ] | [ ] | [ ] |
| Representing the wishlist | [ ] | [ ] | [ ] | [ ] |
| Omnibus and boxed-set cases | [ ] | [ ] | [ ] | [ ] |
| Author roles | [ ] | [ ] | [ ] | [ ] |

Received:
-

What it really was:
-

### Module 3: Relational Database Design

| Topic | L1 | L2 | L3 | L4 |
|---|---|---|---|---|
| Choosing keys | [ ] | [ ] | [ ] | [ ] |
| Enum vs check vs lookup table | [ ] | [ ] | [ ] | [ ] |
| Uniqueness with nullable columns | [ ] | [ ] | [ ] | [ ] |
| Junction table attributes | [ ] | [ ] | [ ] | [ ] |
| Modeling history | [ ] | [ ] | [ ] | [ ] |
| What to index | [ ] | [ ] | [ ] | [ ] |

Received:
-

What it really was:
-

### Module 4: PostgreSQL / Neon Implementation

| Topic | L1 | L2 | L3 | L4 |
|---|---|---|---|---|
| Migration tool setup | [ ] | [ ] | [ ] | [ ] |
| Pooled vs direct connection symptoms | [ ] | [ ] | [ ] | [ ] |
| Writing a reversible migration | [ ] | [ ] | [ ] | [ ] |
| Constraint syntax | [ ] | [ ] | [ ] | [ ] |
| Inspecting the live schema | [ ] | [ ] | [ ] | [ ] |

Received:
-

What it really was:
-

### Module 5: ISBN Fundamentals

| Topic | L1 | L2 | L3 | L4 |
|---|---|---|---|---|
| The two checksum algorithms | [ ] | [ ] | [ ] | [ ] |
| Conversion | [ ] | [ ] | [ ] | [ ] |
| Representing failure | [ ] | [ ] | [ ] | [ ] |
| Parametrized tests | [ ] | [ ] | [ ] | [ ] |

Received:
-

What it really was:
-

### Module 6: External Metadata APIs

| Topic | L1 | L2 | L3 | L4 |
|---|---|---|---|---|
| Exploring an API by hand | [ ] | [ ] | [ ] | [ ] |
| Concurrency for two requests | [ ] | [ ] | [ ] | [ ] |
| Modeling partial dates | [ ] | [ ] | [ ] | [ ] |
| Distinguishing failure kinds | [ ] | [ ] | [ ] | [ ] |
| Testing without the network | [ ] | [ ] | [ ] | [ ] |

Received:
-

What it really was:
-

### Module 7: Backend / API

| Topic | L1 | L2 | L3 | L4 |
|---|---|---|---|---|
| Layering | [ ] | [ ] | [ ] | [ ] |
| Mapping domain errors to HTTP | [ ] | [ ] | [ ] | [ ] |
| Session-per-request | [ ] | [ ] | [ ] | [ ] |
| Pagination design | [ ] | [ ] | [ ] | [ ] |
| Replacing dependencies in tests | [ ] | [ ] | [ ] | [ ] |
| CORS | [ ] | [ ] | [ ] | [ ] |

Received:
-

What it really was:
-

### Module 8: Barcode Scanner Input

| Topic | L1 | L2 | L3 | L4 |
|---|---|---|---|---|
| Focus strategy | [ ] | [ ] | [ ] | [ ] |
| Telling scanner from typist | [ ] | [ ] | [ ] | [ ] |
| Effect cleanup | [ ] | [ ] | [ ] | [ ] |
| Modeling scan state in TypeScript | [ ] | [ ] | [ ] | [ ] |
| The add-on barcode | [ ] | [ ] | [ ] | [ ] |

Received:
-

What it really was:
-

### Module 9: Book Ingestion Pipeline

| Topic | L1 | L2 | L3 | L4 |
|---|---|---|---|---|
| Drawing the state machine | [ ] | [ ] | [ ] | [ ] |
| Transaction boundaries | [ ] | [ ] | [ ] | [ ] |
| Find-or-create races | [ ] | [ ] | [ ] | [ ] |
| Pre-filled editable forms | [ ] | [ ] | [ ] | [ ] |
| Designing the QR payload | [ ] | [ ] | [ ] | [ ] |

Received:
-

What it really was:
-

### Module 10: Duplicate and Edition Handling

| Topic | L1 | L2 | L3 | L4 |
|---|---|---|---|---|
| Uniqueness with missing values | [ ] | [ ] | [ ] | [ ] |
| Catching constraint violations | [ ] | [ ] | [ ] | [ ] |
| A sane title normalization scope | [ ] | [ ] | [ ] | [ ] |
| Merge ordering inside a transaction | [ ] | [ ] | [ ] | [ ] |

Received:
-

What it really was:
-

### Module 11: Genre Classification

| Topic | L1 | L2 | L3 | L4 |
|---|---|---|---|---|
| Validating model output | [ ] | [ ] | [ ] | [ ] |
| Structuring a classification prompt | [ ] | [ ] | [ ] | [ ] |
| Provenance modeling | [ ] | [ ] | [ ] | [ ] |
| Where in the pipeline to classify | [ ] | [ ] | [ ] | [ ] |
| Handling the tiebreak input | [ ] | [ ] | [ ] | [ ] |

Received:
-

What it really was:
-

### Module 12: Library UI

| Topic | L1 | L2 | L3 | L4 |
|---|---|---|---|---|
| Request races | [ ] | [ ] | [ ] | [ ] |
| Avoiding N+1 | [ ] | [ ] | [ ] | [ ] |
| URL state | [ ] | [ ] | [ ] | [ ] |
| Choosing a search tier | [ ] | [ ] | [ ] | [ ] |
| Shaping the detail response | [ ] | [ ] | [ ] | [ ] |

Received:
-

What it really was:
-

### Module 13: Reading State, History, Progress, Personal Fields

| Topic | L1 | L2 | L3 | L4 |
|---|---|---|---|---|
| Keeping current state and history consistent | [ ] | [ ] | [ ] | [ ] |
| Modeling re-reads | [ ] | [ ] | [ ] | [ ] |
| Data-preserving migrations | [ ] | [ ] | [ ] | [ ] |
| Partial dates | [ ] | [ ] | [ ] | [ ] |
| Tag storage | [ ] | [ ] | [ ] | [ ] |

Received:
-

What it really was:
-

### Module 14: Series Support and Rule-Based Suggestions

| Topic | L1 | L2 | L3 | L4 |
|---|---|---|---|---|
| Window function framing | [ ] | [ ] | [ ] | [ ] |
| Anti-join patterns | [ ] | [ ] | [ ] | [ ] |
| Fractional gap logic | [ ] | [ ] | [ ] | [ ] |
| Omnibus handling | [ ] | [ ] | [ ] | [ ] |
| Defining "different" | [ ] | [ ] | [ ] | [ ] |

Received:
-

What it really was:
-

### Module 15: Testing and Failure Handling

| Topic | L1 | L2 | L3 | L4 |
|---|---|---|---|---|
| Test isolation with a real database | [ ] | [ ] | [ ] | [ ] |
| Simulating upstream failures | [ ] | [ ] | [ ] | [ ] |
| Testing a state machine | [ ] | [ ] | [ ] | [ ] |
| Making CI talk to a database safely | [ ] | [ ] | [ ] | [ ] |

Received:
-

What it really was:
-

### Module 16: Security and Configuration

| Topic | L1 | L2 | L3 | L4 |
|---|---|---|---|---|
| Role and grant design | [ ] | [ ] | [ ] | [ ] |
| Default privileges for future tables | [ ] | [ ] | [ ] | [ ] |
| Finding injection sites | [ ] | [ ] | [ ] | [ ] |
| Scoping a threat model | [ ] | [ ] | [ ] | [ ] |
| Fail-fast configuration | [ ] | [ ] | [ ] | [ ] |

Received:
-

What it really was:
-

### Module 17: Mobile Client

| Topic | L1 | L2 | L3 | L4 |
|---|---|---|---|---|
| Debouncing camera detections | [ ] | [ ] | [ ] | [ ] |
| Sharing types | [ ] | [ ] | [ ] | [ ] |
| Development builds | [ ] | [ ] | [ ] | [ ] |
| Choosing a reachability model | [ ] | [ ] | [ ] | [ ] |
| Token storage | [ ] | [ ] | [ ] | [ ] |
| React Native layout differences | [ ] | [ ] | [ ] | [ ] |

Received:
-

What it really was:
-

### Module 18: Rose / OpenClaw Read-Only Integration

| Topic | L1 | L2 | L3 | L4 |
|---|---|---|---|---|
| Choosing the access path | [ ] | [ ] | [ ] | [ ] |
| Scoping a credential | [ ] | [ ] | [ ] | [ ] |
| Shaping responses for an agent | [ ] | [ ] | [ ] | [ ] |
| Fuzzy ownership lookup | [ ] | [ ] | [ ] | [ ] |
| Testing for injection | [ ] | [ ] | [ ] | [ ] |

Received:
-

What it really was:
-

### Module 19: Deployment, Public Page, Documentation, Retrospective

| Topic | L1 | L2 | L3 | L4 |
|---|---|---|---|---|
| Service configuration | [ ] | [ ] | [ ] | [ ] |
| Serverless-to-Postgres connections | [ ] | [ ] | [ ] | [ ] |
| Column allowlisting | [ ] | [ ] | [ ] | [ ] |
| Migration ordering | [ ] | [ ] | [ ] | [ ] |
| Rehearsing a restore | [ ] | [ ] | [ ] | [ ] |

Received:
-

What it really was:
-

### Module 20: Optional Advanced Extensions

| Topic | L1 | L2 | L3 | L4 |
|---|---|---|---|---|
| Per extension: topics are defined when you write the extension's twelve-part spec | [ ] | [ ] | [ ] | [ ] |

Received:
-

What it really was:
-
