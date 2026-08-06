---
description: List all PRDs and their current statuses from the INDEX board.
allowed-tools: Read, Glob, Write
---

# /prd-list — PRD Status Board

Invoke the `manage-prd` skill. Display the status of all PRDs in the project.

Procedure:

1. **Resolve `{prd_dir}`** per `references/conventions.md` (`.claude/prd.local.md` `prd_dir`,
   else default `docs/prds/`).
2. **If `{prd_dir}/INDEX.md` exists:** read and display it. Verify accuracy by globbing
   `{prd_dir}/*.md` (excluding `INDEX.md` and `README.md`). If PRDs exist that are missing
   from the index, or index rows point to missing files, report the discrepancies and offer
   to fix.
3. **If INDEX.md is missing but `{prd_dir}` exists:** glob the PRDs, read each one's
   frontmatter (`title`, `status`, `created`, `updated`), build and display the table, then
   offer to create `INDEX.md` from the template.
4. **If `{prd_dir}` does not exist:** tell the user "No PRDs found. Use `/prd-new` to create
   your first PRD."

## Display format

Sort by status priority: `in-progress`, `approved`, `review`, `draft`, `implemented`,
`parked`.

```
| PRD | Status | Created | Updated |
|-----|--------|---------|---------|
| [Round HUD](round-hud.md) | in-progress | 2026-06-30 | 2026-07-01 |
```

After the table, show a summary line: "X PRDs total: Y in-progress, Z approved, ..."
