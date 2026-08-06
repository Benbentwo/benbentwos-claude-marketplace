---
description: List all PRDs and their current statuses
allowed-tools: Read, Glob, Write
---

# List All PRDs

Display the status of all Product Requirements Documents in the project.

## Process

1. Check if `docs/prds/INDEX.md` exists.

**If INDEX.md exists:**
- Read `docs/prds/INDEX.md` and display its contents to the user.
- Verify the index is accurate by scanning `docs/prds/` for `.md` files (excluding INDEX.md).
- If any PRDs exist that are not in the index, or index entries reference missing files, report the discrepancies and offer to fix them.

**If INDEX.md does NOT exist but `docs/prds/` directory exists:**
- Scan `docs/prds/` for all `.md` files (excluding INDEX.md).
- Read the YAML frontmatter from each PRD to extract title, status, created, and updated dates.
- Build and display a status table.
- Offer to create `docs/prds/INDEX.md` with the discovered PRDs.

**If `docs/prds/` directory does NOT exist:**
- Inform the user: "No PRDs found. Use `/prd` to create your first Product Requirements Document."

## Display Format

Present PRDs as a table sorted by status (in-progress first, then approved, review, draft, implemented):

```
| PRD | Status | Created | Updated |
|-----|--------|---------|---------|
| [User Authentication](user-authentication.md) | in-progress | 2026-03-03 | 2026-03-03 |
| [Search Feature](search-feature.md) | approved | 2026-03-01 | 2026-03-02 |
```

After the table, show a summary: "X PRDs total: Y in-progress, Z approved, ..."
