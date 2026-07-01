# PRD Management — Supersede prd-manager

**Date:** 2026-07-01
**Status:** Approved

## Overview

Replace the `prd-manager` plugin with `prd-management`, a superset that keeps the original
status lifecycle and INDEX board while adding living append-only sections, dedicated impact
analysis, and auto-capture hooks. `prd-manager` is archived under `deprecated/`.

## Why supersede rather than run both

Both plugins solve the same problem (PRDs as the source of truth for feature requirements)
and would collide on triggers, commands, and mental model if listed together. `prd-manager`
(2026-03-03) already named "prevent new features from breaking existing feature contracts"
as a goal but implemented it only as prose "cross-PRD awareness." `prd-management` makes that
a first-class capability. One canonical plugin is clearer for anyone browsing the marketplace.

## What carries forward from prd-manager

- Status lifecycle: `draft → review → approved → in-progress → implemented` (+ `parked`).
- `INDEX.md` status board and `/prd-list`.
- Implementation-status table + passive tracking during development.
- Approval → `writing-plans` handoff (else lightweight inline planning).
- Default doc folder `docs/prds/` (so existing PRDs keep working).

## What prd-management adds

- **Impact analysis** (`/prd-check`): match a change to existing PRDs by subsystem `touches`
  tags, deep-read only the affected ones' acceptance criteria + edge cases, emit a regression
  checklist, then hand off to the project's real verification.
- **Living append-only sections**: Edge Cases (dated), Open Questions (resolve-don't-delete),
  Future Considerations, Changelog — the doc evolves instead of being overwritten.
- **Auto-capture hooks**: self-gating `UserPromptSubmit` feature-request detector and
  `PostToolUse`/`ExitPlanMode` plan-capture (prompt-based, portable across Windows/macOS).
- **Portability config**: `.claude/prd.local.md` `prd_dir` override.
- **Testable-invariant emphasis**: acceptance criteria and behaviors as Given/When/Then.

## Components

| Type | Name | Purpose |
|------|------|---------|
| Command | `/prd-new` | Create a PRD, approve, hand off to planning |
| Command | `/prd-list` | INDEX status board |
| Command | `/prd-update` | Evolve a PRD (append-only, status, impl-status) |
| Command | `/prd-review` | Audit a PRD for gaps |
| Command | `/prd-check` | Impact / regression analysis |
| Skill | `manage-prd` | Authoring, status tracking, and impact analysis |
| Hooks | `hooks.json` | Feature-request detection + plan capture |

## Migration

- `plugins/prd-manager/` → `deprecated/prd-manager/` (with a deprecation notice in its README).
- Marketplace manifest: `prd-manager` entry replaced by `prd-management` (v0.2.0).
- Existing `docs/prds/` PRDs remain compatible; new sections are additive.

## Consequences

- One canonical PRD plugin; no duplicate/overlapping listing.
- Users of `prd-manager` gain impact analysis and living sections with no doc migration.
- The deprecated copy remains available for reference under `deprecated/`.
