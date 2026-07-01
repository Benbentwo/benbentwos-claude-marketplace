---
name: manage-prd
description: >-
  This skill should be used for PRD-driven / spec-driven development: defining
  and evolving product requirements from the end user's perspective, tracking
  their implementation status, and finding which existing features a new change
  might affect. Activates when the project has a docs/prds/ directory, or when the
  user says "write a PRD", "spec this out", "define the requirements", "what should
  this feature do", "add this to the PRD", "log an edge case", "open question
  about", "revisit later", "success criteria", "check PRD status", "PRD progress",
  "update implementation status", or asks "what existing features might this break /
  impact", "which PRDs does this affect", "will this change affect other features",
  "check for regressions". Also use before implementing a new feature to find
  impacted existing features, and after decisions to keep the living PRD current.
  Maintains per-feature living specs plus an INDEX under docs/prds/ (path configurable).
---

# Managing Living PRDs

A PRD (Product Requirements Document) here is a **living, per-feature spec written
from the end user's perspective** — what the user wants, how it should behave, how you
know it works, and its current implementation status. It is NOT a design/implementation
doc (that is what a plans folder / the `writing-plans` skill is for). Keep the two
separate: PRDs describe *what and why for the user*; plans describe *how in code*.

The plugin has three jobs:

1. **Author & evolve** living specs as understanding grows — append edge cases, resolve
   open questions, record future considerations, never silently rewrite.
2. **Track status** — each PRD moves through a lifecycle and carries an implementation
   status table; an `INDEX.md` gives a single-glance board of every PRD.
3. **Impact analysis** — before building something new, read across the PRDs to find
   which existing features it might affect or break, so changes don't cause silent
   regressions.

## Resolve the PRD directory first

Every operation begins by resolving where PRDs live (this is what makes the plugin
portable across projects):

1. If `.claude/prd.local.md` exists, read its frontmatter `prd_dir` value.
2. Otherwise default to `docs/prds/` (relative to the repo root).

Create the directory if it does not exist. See `references/conventions.md` for the full
config, filename, INDEX, and editing rules — read it before writing to any PRD. The full
document schema is in `references/prd-template.md` (read it when scaffolding).

## Commands (thin wrappers over this skill)

| Command | Purpose |
|---------|---------|
| `/prd-new <feature>` | Scaffold a new living PRD from the template; approve → hand off to planning. |
| `/prd-list` | Show the INDEX status board of all PRDs. |
| `/prd-update <feature>` | Append an edge case, resolve an open question, add a behavior, advance status, or update the implementation-status table — always dated + INDEX synced. |
| `/prd-review <feature>` | Audit one PRD for gaps: vague success criteria, stale questions, unmet criteria, missing edge cases. |
| `/prd-check <feature-or-change>` | **Impact analysis.** Given a proposed change, find which existing PRDs it may affect and produce a regression checklist. |

You may also perform any of these inline when the user's phrasing triggers this skill.

## Status lifecycle

`draft → review → approved → in-progress → implemented` (plus `parked` for deferred
work). Transitions:

- **approved** — requirements finalized, ready for planning.
- **in-progress** — set when a plan is generated or implementation begins.
- **implemented** — all requirements/acceptance criteria delivered.

Whenever status changes, update the frontmatter `status` + `updated` date, append a
Changelog line, and **sync `INDEX.md`**.

## Passive tracking during development

When `docs/prds/` exists, stay aware of active PRDs (`approved` / `in-progress`) and, when
code work maps to a PRD (by feature name, scope, or acceptance criteria):

- Reference that PRD's requirements to guide the work.
- After completing work that satisfies requirements, update its **Implementation Status**
  table via `/prd-update`. Apply routine updates (status transitions, impl-status rows)
  automatically; prompt before changing requirements or acceptance criteria.

## Context economy (why this stays cheap)

- **Discover by INDEX / frontmatter, not by reading everything.** Read `INDEX.md` or
  `Glob {prd_dir}/*.md` + frontmatter (`title`, `status`, `touches`); read a PRD body only
  when relevant.
- **Edit surgically.** Updates are `Edit`s into the append-only sections (Edge Cases, Open
  Questions, Future Considerations, Changelog) and the impl-status table. Never rewrite a
  whole PRD to add one line.
- **Templates load on demand.** The full schema is in `references/prd-template.md`, read
  only when scaffolding.

## The living-PRD schema (summary)

One file per feature with YAML frontmatter + fixed sections. The frontmatter `touches:`
list (subsystem tags) is the index that powers impact analysis. Full template and INDEX
format: `references/prd-template.md`.

```
---
title, slug, status, owner, created, updated
touches: [subsystem tags — the impact-analysis index]
related: [slugs of PRDs this feature interacts with]
---
## Overview                 — user problem & desired outcome, in the user's words
## User Goals               — as a <user>, I want <goal> so that <reason>
## Goals / Non-Goals        — what success looks like; explicit out-of-scope
## Requirements             — Functional + Non-Functional (checkbox lists)
## Features & Behaviors      — Given/When/Then, user-facing
## Acceptance Criteria      — observable, testable invariants
## Assumptions & Constraints
## Dependencies & Interactions — which systems/features this couples to
## Design Decisions          — decision / options / choice / rationale
## Edge Cases                — APPEND-ONLY, dated
## Open Questions            — [ ] / [x] resolved with the decision
## Future Considerations     — revisit-later, dated
## Implementation Status     — per-requirement status table
## Changelog                 — APPEND-ONLY, dated
```

## Impact analysis (how `/prd-check` finds what a change might break)

This is the core "know what existing features are affected" capability:

1. Determine the **subsystems the new/changed feature touches** (ask the user or infer).
   Express them as `touches:` tags.
2. `Glob {prd_dir}/*.md` (skip `INDEX.md` and `README.md`) and read each PRD's frontmatter
   `touches` and `related`.
3. **Candidates = PRDs that share any tag** with the new change, or that list the new
   feature's slug in `related`. Include `implemented` and `in-progress` PRDs — those are
   exactly what a regression hurts.
4. For each candidate, read **only** its `## Acceptance Criteria` and `## Edge Cases` — the
   invariants that must still hold.
5. Produce an **impact report**: per affected feature, the specific criteria/edge cases at
   risk, and a pass/fail checklist to verify against.
6. Hand the checklist off to the project's real verification (tests, build, manual verify).
   The PRD says *what* must stay true; it does not replace *running* the check.

A PRD guides and catches; it does not guarantee. Guarantees come from tests and a passing
build. This plugin makes sure you are testing the *right* invariants.

## Writing rules (non-negotiable)

- Write from the **user's perspective**. "The runner sees a jail timer count down," not
  "the widget binds to a replicated float."
- Success/acceptance criteria and edge cases MUST be **observable and testable**
  (Given/When/Then or a checkable statement). Vague prose cannot guard a regression.
- **Never delete** an edge case or a resolved question. Mark resolved, append the decision.
- Every substantive change appends one dated `## Changelog` line, bumps `updated:`, and
  syncs `INDEX.md`.
