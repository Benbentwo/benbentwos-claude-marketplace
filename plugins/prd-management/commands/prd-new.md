---
description: Scaffold a new living PRD (per-feature product spec) from the template — user goals, behaviors, acceptance criteria, edge cases, open questions — then approve and hand off to planning.
argument-hint: <feature name or slug>
allowed-tools: Read, Write, Edit, Glob, Grep, Bash(mkdir:*)
---

# /prd-new — Create a Living PRD

Invoke the `manage-prd` skill. Create a new per-feature PRD for: **$ARGUMENTS**

Procedure:

1. **Resolve `{prd_dir}`** per `references/conventions.md` (read `.claude/prd.local.md`
   `prd_dir`, else default `docs/prds/`). Create the directory if missing.
2. **Derive the slug** (kebab-case) from `$ARGUMENTS`. If `{prd_dir}/<slug>.md` already
   exists, stop and tell the user — do not overwrite; suggest `/prd-update` instead.
3. **Interview from the end-user perspective**, one question at a time (most important
   first): what problem this solves and for whom, what success looks like, what's out of
   scope, known assumptions/constraints, and which subsystems this feature `touches` (the
   impact-analysis tags). Reuse existing tag vocabulary — glob the other PRDs' `touches`
   frontmatter first so you don't invent synonyms. Stop asking once there's enough for a
   meaningful PRD.
4. **Read `references/prd-template.md`** and write `{prd_dir}/<slug>.md`. Set `status:
   draft`, `created`/`updated` to today, seed the Changelog with `YYYY-MM-DD: PRD created.`
   Write testable content — acceptance criteria and behaviors as Given/When/Then.
5. **Cross-link.** If this feature clearly interacts with an existing PRD, add that slug to
   `related:` here and offer to add the reciprocal link there.
6. **Review & iterate.** Present the PRD; ask what to change; update until the user is
   satisfied.
7. **Approve.** On confirmation, set `status: approved`, bump `updated:`, and **sync
   `{prd_dir}/INDEX.md`** (create it from the template if missing).
8. **Hand off to planning.** If the `writing-plans` skill is available, invoke it with the
   PRD as context and then set `status: in-progress`. If not, do lightweight inline
   planning (ordered tasks + dependencies), get approval, then set `status: in-progress`.
   Each transition bumps `updated:`, appends a Changelog line, and syncs INDEX.
9. **Report** the path written and any Open Questions still to resolve.

Do not implement any code changes — this command only defines the spec.
