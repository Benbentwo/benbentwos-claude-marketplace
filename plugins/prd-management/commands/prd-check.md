---
description: Impact analysis — given a proposed new feature or code change, read across the PRDs to find which existing features it might affect or break, and produce a regression checklist to verify against.
argument-hint: <new feature / change description / changed files>
---

# /prd-check — Impact Analysis & Regression Guard

Invoke the `manage-prd` skill. Analyze the impact of: **$ARGUMENTS**

The goal: before (or while) building something new, find which **existing features it
might affect or regress**, by reading across the living PRDs. Produce a checklist, not a
guarantee — verification (tests/build/manual) confirms the invariants still hold.

Procedure:

1. **Characterize the change.** From `$ARGUMENTS` (a feature description, a plan, or a
   set of changed files), determine the **subsystems it touches**. Express them as the
   same lowercase `touches:` tag vocabulary the PRDs use. If the change maps to an
   existing PRD, note its slug; if it's brand new, you may still have no PRD yet — that's
   fine, work from the tags. Ask the user to confirm the tag set if uncertain.
2. **Resolve `{prd_dir}`** and `Glob {prd_dir}/*.md` (skip `INDEX.md` and `README.md`).
   Read **only the frontmatter** (`title`, `slug`, `status`, `touches`, `related`) of each.
3. **Select candidates** — existing PRDs that either share ≥1 `touches` tag with the
   change, or list the change's slug in `related`, or that the change's PRD lists in its
   own `related`. Include `implemented` and `in-progress` PRDs (those are what a regression
   hurts).
4. **Deep-read only the candidates' invariants** — for each candidate read just its
   `## Acceptance Criteria` and `## Edge Cases`. Do not pull entire documents.
5. **Produce the impact report:**

   ```
   ## Impact of: <change>
   Touches: [tags]

   ### Affected features
   - <feature> (slug, status) — shares [tags]
     Invariants at risk:
     - [ ] <acceptance criterion / edge case that this change could violate>
     - [ ] ...
   - <feature> ...

   ### Not obviously affected
   - <features scanned that share no tags> (for transparency)

   ### Regression checklist
   - [ ] <consolidated, deduped list of everything to verify before shipping>

   ### New edge cases this change implies
   - <edge cases the interaction surfaces that should be logged via /prd-update>
   ```

6. **Hand off to real verification.** Recommend running the project's existing checks
   against the checklist (tests, the build/verify loop, or manual `/verify`). State
   explicitly that this analysis *guides* the check — passing tests + a clean build are
   what actually confirm no regression.
7. **Offer to record** any newly discovered cross-feature edge cases into the relevant
   PRDs via `/prd-update` so the knowledge compounds for next time.

If no PRDs exist yet, say so and suggest `/prd-new` for the affected areas first — impact
analysis is only as good as the specs it reads.
