---
description: Audit one living PRD for quality gaps — vague/untestable acceptance criteria, stale open questions, missing edge cases, and unmet criteria.
argument-hint: <feature/slug>
---

# /prd-review — Audit a Living PRD

Invoke the `manage-prd` skill. Audit the PRD for: **$ARGUMENTS**

Procedure:

1. **Resolve `{prd_dir}`**, locate and read the target PRD.
2. **Assess against these checks** and report findings (do not silently edit — propose,
   then apply on confirmation, except trivial dating/formatting fixes):
   - **Testability:** Is every `## Acceptance Criteria` line observable and checkable
     (Given/When/Then or measurable)? Flag vague prose ("feels good", "responsive") and
     rewrite it into a checkable statement.
   - **Completeness:** Does each Goal/Requirement trace to at least one Acceptance
     Criterion? Are there obvious behaviors with no criterion, or criteria with no behavior?
   - **Implementation Status:** Is the status table in sync with reality and with the
     frontmatter `status`?
   - **Open Questions health:** Any questions stale relative to `updated:`? Any that
     should now be answerable? Surface them.
   - **Edge Cases:** Given the behaviors, are there likely edge cases with no entry
     (empty state, disconnect/timeout, concurrency, max/min, permission/authority)?
     Propose additions.
   - **Frontmatter integrity:** `slug` matches filename; `touches`/`related` reflect the
     Dependencies section; `updated` current; status accurate.
   - **User-voice:** Flag any line written as an implementation detail rather than a user
     requirement.
3. **Apply agreed fixes** using surgical `Edit`s, append a dated `## Changelog` line for
   any content change, and bump `updated:`.
4. **Summarize** the audit: what's solid, what was fixed, what open questions remain.
