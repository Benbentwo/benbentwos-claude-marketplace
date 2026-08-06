# Living PRD Template

Copy the block below into `{prd_dir}/<slug>.md` when scaffolding a new PRD. Fill every
field. Delete the inline `<!-- guidance -->` comments once the section has real content.
One file = one feature/epic.

The **frontmatter is the machine-readable index**; the sections are the human-readable
spec. Keep both accurate — impact analysis relies on `touches` and `related`, and the
INDEX/status board relies on `title`, `status`, `created`, `updated`.

---

```markdown
---
title: <Human-readable feature name>
slug: <kebab-case-matches-filename>
status: draft            # draft | review | approved | in-progress | implemented | parked
owner: <name>
created: YYYY-MM-DD
updated: YYYY-MM-DD
touches: []              # subsystem tags this feature reads/writes, e.g. [hud, scoring, replication, input]
related: []              # slugs of other PRDs this feature interacts with
---

## Overview
<!-- The user problem and the desired outcome, in the user's words. Who is the user,
what do they want, why does it matter? No implementation. 2-5 sentences. -->

## User Goals
- As a <user type>, I want <goal> so that <reason>.

## Goals / Non-Goals
**Goals**
- <what this feature must achieve for the user>

**Non-Goals**
- <explicitly out of scope — prevents scope creep and clarifies boundaries>

## Requirements
### Functional Requirements
- [ ] <requirement>

### Non-Functional Requirements
- [ ] Performance: <metric or constraint>
- [ ] Security / Authority: <requirement>
- [ ] Compatibility: <requirement>

## Features & Behaviors
<!-- User-facing capabilities and their expected behavior. Prefer Given/When/Then so each
behavior is unambiguous and testable. -->
- **<capability>** — Given <context>, when <user action>, then <observable result>.

## Acceptance Criteria
<!-- Observable, testable invariants. Each line must be checkable by a test, a build, or
manual verification. These double as the regression checklist for impact analysis. Avoid
vague prose ("feels responsive") — state the measurable behavior. -->
- [ ] Given <state>, when <event>, the user observes <specific, checkable result>.

## Assumptions & Constraints
- Assumption: <...>
- Constraint: <...>

## Dependencies & Interactions
<!-- Which systems and other features this one couples to, and HOW. This is the human
explanation behind the `touches` / `related` frontmatter. State the direction of coupling
("reads X", "writes Y", "must fire before Z"). -->
- Depends on: <feature/system> — <how>
- Affects: <feature/system> — <how>

## Design Decisions
<!-- Key decisions and trade-offs made while refining requirements. -->

| Decision | Options Considered | Choice | Rationale |
|----------|--------------------|--------|-----------|
|          |                    |        |           |

## Edge Cases
<!-- APPEND-ONLY log. Never delete an entry. Each line is dated when discovered and records
the case plus its handling (or TBD if undecided). Discovered edge cases during development
land here. -->
- [YYYY-MM-DD] <edge case> -> <handling, or TBD>

## Open Questions
<!-- Unresolved decisions. Use checkboxes. When resolved, flip to [x] and append the
decision inline — do NOT delete the question. -->
- [ ] <question that must be answered before/while building>

## Future Considerations
<!-- Things intentionally deferred, to revisit in a later session. Dated. -->
- [YYYY-MM-DD] <idea / thing to revisit later>

## Implementation Status
<!-- Updated as development progresses. One row per requirement/acceptance criterion. -->

| Requirement | Status | Notes |
|-------------|--------|-------|
|             | Not Started | |

## Changelog
<!-- APPEND-ONLY. One dated line per substantive change to this PRD, with the why. This is
the version history of the requirement itself. -->
- YYYY-MM-DD: PRD created.
```

---

## INDEX.md

Maintain a status board at `{prd_dir}/INDEX.md`. Sync it after any PRD create, status
change, or `updated:` bump.

```markdown
# PRD Index

| PRD | Status | Created | Updated |
|-----|--------|---------|---------|
| [Feature Name](slug.md) | in-progress | YYYY-MM-DD | YYYY-MM-DD |
```

Sort rows by status priority: `in-progress`, `approved`, `review`, `draft`,
`implemented`, `parked`.

## Status values

| Status | Meaning |
|--------|---------|
| `draft` | Initial creation, still being written |
| `review` | Ready for stakeholder review |
| `approved` | Requirements finalized, ready for planning |
| `in-progress` | Implementation has begun |
| `implemented` | All requirements delivered |
| `parked` | Intentionally deferred |

## Field notes

- **slug** must equal the filename (minus `.md`) and is how `related:` cross-links other
  PRDs. Keep it stable — renaming a slug breaks references.
- **touches** is a flat, lowercase tag vocabulary shared across all PRDs in a project.
  Reuse existing tags rather than inventing synonyms (`hud` not `heads-up-display`); a
  consistent vocabulary is what makes impact matching reliable. Keep a canonical tag list
  at the top of `{prd_dir}/README.md` if the project wants one.
- **Acceptance Criteria vs. Features & Behaviors**: Behaviors describe what the feature
  does; Acceptance Criteria are the pass/fail gates you verify. Every criterion should
  trace back to a behavior, goal, or requirement.
- Impact analysis still considers `implemented` PRDs — those are exactly the features a new
  change can regress.
