# Context Document Template

## File Format

Context documents use YAML frontmatter with Markdown content. Filename should be kebab-case matching the feature name (e.g., `user-authentication.md`).

```markdown
---
title: [Feature Name]
created: [YYYY-MM-DD]
updated: [YYYY-MM-DD]
related_prd: [filename or null]
related_plan: [filename or null]
---

## Overview

Brief description of what this feature is and why it exists. Include the problem it solves and the motivation behind building it.

## Key Files

| File | Purpose |
|------|---------|
| `path/to/file.ts` | Brief description of what this file does for the feature |
| `path/to/other.ts` | Brief description |

## Architecture Decisions

### [Decision Title]

**Context:** What situation led to this decision
**Decision:** What was chosen
**Rationale:** Why this approach was selected over alternatives
**Alternatives considered:** What else was evaluated

## How It Works

Technical flow description. Walk through the feature's behavior step-by-step:

1. [Step 1 - entry point or trigger]
2. [Step 2 - processing]
3. [Step 3 - output or side effects]

Include code references where helpful:
- Entry point: `path/to/entry.ts:functionName`
- Core logic: `path/to/core.ts:className`

## Related Docs

- PRD: [link to docs/prds/feature-name.md if exists]
- Plan: [link to docs/plans/feature-name.md if exists]
- Roadmap: [reference to docs/ROADMAP.md section if applicable]
```

## INDEX.md Template

Located at `docs/context/INDEX.md`:

```markdown
# Context Documents Index

Quick-reference index of all feature context documents.

| Feature | Created | Updated | Related PRD |
|---------|---------|---------|-------------|
```

## Guidelines

### When Creating

- Use kebab-case for filenames matching the feature name
- Fill Overview immediately — this is the most important section for quick context
- Key Files can be partial during planning, completed during implementation
- Architecture Decisions should capture the "why" not just the "what"
- Always link to related PRDs and plans if they exist

### When Updating (Append Mode)

- Add new Key Files entries — do not remove existing ones unless files were deleted
- Add new Architecture Decisions sections — do not modify existing decisions
- Update the How It Works section to reflect current behavior
- Update the `updated` date in frontmatter
- Add new Related Docs links as they become available

### When Updating (Rewrite Mode)

- Only use rewrite mode when the feature has been fundamentally redesigned
- Preserve the original `created` date
- Document that this is a rewrite in the Architecture Decisions section
