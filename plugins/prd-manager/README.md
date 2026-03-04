# PRD Manager

Manage Product Requirements Documents (PRDs) to gate feature development behind structured requirements. PRDs serve as the source of truth for feature requirements, user goals, and implementation status.

## Features

- **`/prd`** — Create new PRDs through interactive Q&A. Asks clarifying questions, generates a structured document, iterates until approved, then transitions to implementation planning.
- **`/prd-list`** — View all PRDs and their current statuses at a glance. Maintains an INDEX.md for quick reference.
- **`/prd-update`** — Update PRD requirements, status, or implementation progress. Runs automatically when development work related to a PRD is detected.
- **PRD Tracker skill** — Automatically detects `docs/prds/` and keeps PRDs in sync with development activity. Provides cross-PRD awareness to prevent conflicts.

## Installation

```bash
claude plugin add benbentwos-claude-marketplace/prd-manager
```

## How It Works

### Workflow

1. **`/prd`** — Describe your feature. The plugin asks clarifying questions and generates a PRD.
2. **Iterate** — Refine the PRD until requirements are clear and complete.
3. **Approve** — Confirm the PRD. Status moves to `approved`.
4. **Plan** — If the `writing-plans` skill is available, it's invoked automatically. Otherwise, lightweight inline planning breaks requirements into tasks.
5. **Develop** — The `prd-tracker` skill monitors progress and updates the PRD's Implementation Status.
6. **Complete** — When all requirements are met, the PRD status moves to `implemented`.

### PRD Format

PRDs are Markdown files with YAML frontmatter stored in `docs/prds/`:

```yaml
---
title: Feature Name
status: draft  # draft | review | approved | in-progress | implemented
created: 2026-03-03
updated: 2026-03-03
---
```

### Status Flow

`draft` → `review` → `approved` → `in-progress` → `implemented`

## Optional Integration

If the `writing-plans` skill (from the superpowers plugin) is installed, `/prd` will invoke it for implementation planning after PRD approval. Without it, the plugin does its own lightweight planning.
