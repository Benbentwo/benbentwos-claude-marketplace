# PRD Manager Plugin Design

**Date:** 2026-03-03
**Status:** Approved

## Overview

A Claude Code plugin that manages Product Requirements Documents (PRDs) as part of the feature development workflow. PRDs serve as the source of truth for feature requirements, user goals, and implementation status.

## Problem

When developing features across multiple sessions or with multiple agents, there's no structured way to:
- Capture requirements before jumping into code
- Track what's been implemented vs. what's planned
- Prevent new features from breaking existing feature contracts
- Maintain a living reference of all planned and delivered features

## Solution

A plugin with 3 commands and 1 skill that manages PRDs in a `docs/prds/` folder:

### Components

| Type | Name | Purpose |
|------|------|---------|
| Command | `/prd` | Create a new PRD interactively |
| Command | `/prd-list` | List all PRDs and their statuses |
| Command | `/prd-update` | Update an existing PRD |
| Skill | `prd-tracker` | Auto-detect PRDs and nudge updates during development |

### PRD Document Format

PRDs use Markdown with YAML frontmatter:

```yaml
---
title: Feature Name
status: draft  # draft | review | approved | in-progress | implemented
created: YYYY-MM-DD
updated: YYYY-MM-DD
---
```

Sections: Overview, User Goals, Requirements (Functional + Non-Functional), Acceptance Criteria, Design Decisions, Implementation Status.

### INDEX.md

Maintains a table of all PRDs with status, created, and updated dates.

### Status Flow

`draft` → `review` → `approved` → `in-progress` → `implemented`

### Command Flows

**`/prd`**: No args → ask user what to create. With args → use as starting point. Interactive Q&A → generate PRD → iterate → approve → check for `writing-plans` skill → plan or lightweight inline planning → update status to `in-progress`.

**`/prd-list`**: Read INDEX.md, or scan folder and build index if missing. Show status table.

**`/prd-update <name>`**: Find PRD by name, present current state, ask what to update, apply changes, sync INDEX.md.

### Skill: prd-tracker

Activates when `docs/prds/` exists. During development, reminds Claude to update PRD implementation status when working on PRD-related tasks.

### External Skill Integration

The `/prd` command checks for the `writing-plans` skill. If available, invokes it for plan generation. If not, performs lightweight inline planning.

## Plugin Structure

```
prd-manager/
├── .claude-plugin/
│   └── plugin.json
├── README.md
├── commands/
│   ├── prd.md
│   ├── prd-list.md
│   └── prd-update.md
└── skills/
    └── prd-tracker/
        ├── SKILL.md
        └── references/
            └── prd-template.md
```
