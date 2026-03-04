---
name: prd-tracker
description: This skill should be used when the project contains a "docs/prds/" directory or when the user mentions "update the PRD", "check PRD status", "PRD progress", "track implementation progress", "which PRDs does this affect", "feature requirements", or "update implementation status". Tracks PRD status during feature development, updates implementation progress, and ensures PRDs stay in sync with development work. Also triggers when plan generation, implementation work, or feature completion relates to an existing PRD.
---

# PRD Tracker

## Overview

Track Product Requirements Documents during feature development. When a `docs/prds/` folder exists in the project, maintain awareness of existing PRDs and keep their implementation status current as development progresses.

## Core Behavior

### On Session Start (when docs/prds/ detected)

1. Read `docs/prds/INDEX.md` to understand existing PRDs and their statuses.
2. Note any PRDs with status `approved` or `in-progress` — these are active features.
3. Keep this context available when processing development tasks.

### During Development

When working on code changes, check if the current work relates to an existing PRD by comparing:
- The feature being implemented against PRD titles and requirements
- File paths being modified against PRD scope
- Task descriptions against PRD acceptance criteria

**If a connection is detected:**
- Reference the relevant PRD requirements to guide implementation.
- After completing work that addresses one or more PRD requirements, update the PRD's Implementation Status table.
- Use `/prd-update` to apply changes. Invoke automatically for routine updates (status transitions, implementation table updates). Prompt the user before changing requirements or acceptance criteria.

### On Plan Generation

When a plan is created for work that maps to an existing PRD:
1. Update the PRD status to `in-progress` if currently `approved`.
2. Update the `updated` date in frontmatter.
3. Sync INDEX.md.

### On Feature Completion

When implementation work related to a PRD is complete:
1. Review the PRD's requirements and acceptance criteria.
2. Update the Implementation Status table with completion status for each requirement.
3. If all requirements are addressed, suggest updating status to `implemented`.
4. Sync INDEX.md.

## Cross-PRD Awareness

Before making changes that could affect multiple features:
1. Scan the PRD index for PRDs with status `approved`, `in-progress`, or `implemented`.
2. Check if proposed changes could conflict with requirements in other PRDs.
3. If a potential conflict is detected, warn before proceeding and reference the conflicting PRD.

## PRD Reference

For the PRD document template and format details, consult `${CLAUDE_PLUGIN_ROOT}/skills/prd-tracker/references/prd-template.md`.

## Commands

This plugin provides three commands for explicit PRD management (see `${CLAUDE_PLUGIN_ROOT}/commands/` for full definitions):
- **`/prd`** — Create a new PRD interactively
- **`/prd-list`** — List all PRDs and statuses
- **`/prd-update`** — Update an existing PRD

Use these commands when the user explicitly requests PRD operations. Use this skill's automatic behavior for passive tracking during development.
