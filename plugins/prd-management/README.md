# prd-management

PRD-driven (spec-driven) development for Claude Code. Maintains **living, per-feature
product specs** written from the end user's perspective, tracks their **implementation
status**, and helps Claude discover which **existing features a new change might impact**
before you build it.

It is deliberately context-light and project-agnostic — the same plugin drives different
doc layouts in any repo that enables it.

> **Supersedes `prd-manager`.** This plugin merges `prd-manager`'s status lifecycle and
> INDEX board with living append-only sections, dedicated impact analysis, auto-capture
> hooks, and portability config. `prd-manager` is archived under `deprecated/`.

## What it gives you

- A **living PRD per feature** under `docs/prds/` (path configurable) capturing: user
  goals & outcomes, requirements, expected behaviors, testable acceptance criteria,
  assumptions & constraints, discovered edge cases, open questions, future considerations,
  and an implementation-status table.
- An **INDEX.md status board** and a `draft → review → approved → in-progress →
  implemented` lifecycle (plus `parked`).
- **Impact analysis** (`/prd-check`): before building, find which existing features a change
  may affect/regress and get a checklist to verify against.
- **Auto-capture** of feature requests and approved-plan requirements (via hooks), so the
  spec stays current without you remembering to update it.

## Commands

| Command | Purpose |
|---------|---------|
| `/prd-new <feature>` | Scaffold a living PRD, approve, hand off to planning. |
| `/prd-list` | Show the INDEX status board of all PRDs. |
| `/prd-update <feature>` | Append an edge case, resolve a question, advance status, update impl-status — append-only + dated. |
| `/prd-review <feature>` | Audit a PRD for vague criteria, stale questions, missing edge cases. |
| `/prd-check <change>` | **Impact analysis** — which existing features might this change break? |

The `manage-prd` skill also self-triggers on natural phrasing ("add this to the PRD", "log
an edge case", "will this break anything", "which PRDs does this affect", "spec this out").

## Configuration (portability)

By default PRDs live in `docs/prds/`. To use a different location in a given project, create
`.claude/prd.local.md` in that repo:

```markdown
---
prd_dir: docs/specs
---

# PRD settings
Canonical `touches` tags: hud, scoring, replication, input, matchmaking
```

## Hooks (auto-capture)

Active whenever the plugin is enabled (prompt-based, no scripts — works on Windows and
macOS):

- **`UserPromptSubmit`** — self-gating detector. When a message is a genuine new-feature
  request, it nudges Claude to scaffold a `draft` PRD and run impact analysis before writing
  code. Stays silent for questions, bug reports, refactors, and chatter.
- **`PostToolUse` / `ExitPlanMode`** — after an approved plan, folds newly-decided
  user-facing requirements and edge cases into the matching PRD.

To disable auto-capture while keeping the commands/skill, remove the `hooks` block from
`hooks/hooks.json` (or the relevant event) and restart Claude Code — hooks load at session
start.

## How it stays "living" (not a static file)

- **Append, don't overwrite**: Edge Cases, Future Considerations, and Changelog are
  append-only and dated.
- **Resolve, don't delete**: answered Open Questions flip to `[x]` with the decision
  recorded inline.
- **Versioning** is the dated Changelog + git history — no `v1/v2` copies.

## Impact analysis in one line

Each PRD tags the subsystems it `touches:`. `/prd-check` globs every PRD, matches shared
tags, deep-reads only the affected ones' acceptance criteria + edge cases, and emits a
regression checklist — then hands off to your real tests/build for confirmation.
