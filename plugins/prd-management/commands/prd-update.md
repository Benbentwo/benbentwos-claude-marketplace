---
description: Evolve a living PRD — append an edge case, resolve an open question, add a behavior/criterion, advance status, or update the implementation-status table. Append-only, dated, INDEX-synced.
argument-hint: <feature/slug> [what changed]
allowed-tools: Read, Write, Edit, Glob, Grep
---

# /prd-update — Evolve a Living PRD

Invoke the `manage-prd` skill. Update the PRD for: **$ARGUMENTS**

Procedure:

1. **Resolve `{prd_dir}`** (see `references/conventions.md`). `Glob {prd_dir}/*.md` and
   locate the target PRD by slug/title. If ambiguous or missing, ask which one (or offer
   `/prd-new`).
2. **Read only the sections you need** — do not pull the whole file if a surgical edit will
   do.
3. **Classify the change** and edit the matching section, following the append-only rules:
   - **New edge case discovered** -> append `- [YYYY-MM-DD] <case> -> <handling/TBD>` to
     `## Edge Cases`.
   - **Open question answered** -> flip `[ ]` to `[x]` in `## Open Questions` and append the
     decision inline. Never delete the question.
   - **New/changed behavior or requirement** -> add to `## Features & Behaviors`,
     `## Requirements`, and/or a testable line to `## Acceptance Criteria`. Prompt before
     changing existing requirements or acceptance criteria; apply routine additions freely.
   - **New open question** -> add `- [ ] <question>` to `## Open Questions`.
   - **Defer something** -> append `- [YYYY-MM-DD] <item>` to `## Future Considerations`.
   - **Implementation progressed** -> update the `## Implementation Status` table rows.
   - **Status transition** -> update frontmatter `status` (draft→review→approved→
     in-progress→implemented, or parked).
   - **Coupling changed** -> update `## Dependencies & Interactions` and frontmatter
     `touches` / `related`.
4. **Stamp it.** Append one dated line to `## Changelog` describing the change and the why,
   set frontmatter `updated:` to today, and **sync `{prd_dir}/INDEX.md`**.
5. **Report** what changed in one or two lines.

Use `Edit` (surgical), not a full rewrite. Preserve all existing history.
