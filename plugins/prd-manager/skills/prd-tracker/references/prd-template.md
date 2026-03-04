# PRD Template

Use this template when creating new PRDs. Copy the structure below and fill in each section.

```markdown
---
title: [Feature Name]
status: draft
created: [YYYY-MM-DD]
updated: [YYYY-MM-DD]
---

## Overview

Brief description of the feature and why it's needed. Include the problem being solved and the value it delivers.

## User Goals

- As a [user type], I want [goal] so that [reason]
- As a [user type], I want [goal] so that [reason]

## Requirements

### Functional Requirements

- [ ] Requirement 1
- [ ] Requirement 2
- [ ] Requirement 3

### Non-Functional Requirements

- [ ] Performance: [specific metric or constraint]
- [ ] Security: [specific requirement]
- [ ] Compatibility: [specific requirement]

## Acceptance Criteria

- [ ] Criteria 1: [specific, testable condition]
- [ ] Criteria 2: [specific, testable condition]
- [ ] Criteria 3: [specific, testable condition]

## Design Decisions

Document key decisions and trade-offs made during PRD refinement.

| Decision | Options Considered | Choice | Rationale |
|----------|-------------------|--------|-----------|
| | | | |

## Implementation Status

<!-- Updated as development progresses -->

| Requirement | Status | Notes |
|-------------|--------|-------|
| | Not Started | |
```

## INDEX.md Template

Use this template for the PRD index file at `docs/prds/INDEX.md`:

```markdown
# PRD Index

| PRD | Status | Created | Updated |
|-----|--------|---------|---------|
```

## Status Values

| Status | Meaning |
|--------|---------|
| `draft` | Initial creation, still being written |
| `review` | Ready for stakeholder review |
| `approved` | Requirements finalized, ready for planning |
| `in-progress` | Implementation has begun |
| `implemented` | All requirements delivered |

## Guidelines

- Keep PRD filenames kebab-case (e.g., `user-authentication.md`)
- One PRD per feature — avoid combining unrelated features
- Update the `updated` field in frontmatter whenever the PRD is modified
- Always sync INDEX.md after any PRD change
- Check existing PRDs in the index before creating duplicates
