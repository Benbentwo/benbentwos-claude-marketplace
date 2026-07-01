# PRD Conventions — Config, Portability, INDEX, Editing Rules

Read this before creating or editing any PRD. It is the source of truth for *where* PRDs
live and *how* to change them safely.

## 1. Resolving the PRD directory (portability)

The plugin hardcodes no project-specific path. Resolve `{prd_dir}` at the start of every
operation:

1. If `.claude/prd.local.md` exists in the current repo, read its YAML frontmatter and use
   `prd_dir`.
2. Otherwise use the default `docs/prds/`.

Always interpret the path relative to the repo root. Create the directory if missing.

### Optional per-project config: `.claude/prd.local.md`

A project overrides the location (and can note a tag vocabulary) with:

```markdown
---
prd_dir: docs/specs
---

# PRD settings for <project>

Canonical `touches` tags: hud, scoring, replication, input, matchmaking, audio
```

This file is per-project (it lives in the *consuming* repo's `.claude/`, not in the
plugin). Because the plugin only reads it, the same plugin drives different doc layouts in
any repo.

## 2. Filenames & INDEX

- One PRD per feature: `{prd_dir}/<slug>.md`. `<slug>` is kebab-case and MUST match the
  frontmatter `slug:` field.
- `{prd_dir}/INDEX.md` is the status board (see the template). **Sync it after every
  create, status change, or `updated:` bump.** When listing, if INDEX is missing, scan the
  folder frontmatter and offer to build it.
- `{prd_dir}/README.md` (optional) holds the canonical `touches` tag list. INDEX.md and
  README.md are NOT PRDs and are skipped by impact globbing and status scans.

## 3. Status lifecycle

`draft → review → approved → in-progress → implemented`, plus `parked`. Set `in-progress`
when a plan is generated or implementation begins; `implemented` when all requirements and
acceptance criteria are delivered. Every status change updates frontmatter `status` +
`updated`, appends a Changelog line, and syncs INDEX.

## 4. Editing rules (how the document stays "living")

- **Append, don't overwrite.** `## Edge Cases`, `## Future Considerations`, and
  `## Changelog` are append-only. New entries go at the bottom of their section with a
  `YYYY-MM-DD` date prefix.
- **Resolve, don't delete.** An answered `## Open Questions` item flips `[ ]` -> `[x]` and
  gets the decision appended inline. The question text stays for the record.
- **Surgical edits only.** Use `Edit` to change specific lines/sections. Never rewrite an
  entire PRD to make a small change — it destroys history and wastes context.
- **Stamp every change.** Any substantive edit appends one `## Changelog` line (with the
  why), updates the frontmatter `updated:` date, and syncs INDEX.
- **User's voice.** Requirements are written from the end user's perspective. If a line
  reads like an implementation note, move it to a design/plan doc instead.

## 5. Versioning without version files

The requirement's history *is* the append-only `## Changelog` plus git history of the
file. There are no `v1/v2` copies. To see how a requirement evolved, read the Changelog or
`git log -p {prd_dir}/<slug>.md`. Newly discovered requirements are appended as new
behaviors/criteria with a changelog note, not tracked in a separate file.

## 6. Relationship to other docs (do not overlap)

| Doc surface | Owns | Plugin |
|-------------|------|--------|
| `{prd_dir}/*.md` | *What & why for the user*: requirements, behaviors, acceptance criteria, edge cases, status | **prd-management** (this) |
| plans folder / `writing-plans` | *How in code*: design + implementation approach | external |
| ADRs | Architecture decisions & trade-offs | external |

When a plan is written for a feature that has a PRD, the plan should reference the PRD slug
so the two stay linked. On approval, `/prd-new` hands off to the `writing-plans` skill if
available, else does lightweight inline planning.

## 7. Impact analysis contract (used by `/prd-check`)

- The `touches:` frontmatter is the primary join key. Two features "interact" when they
  share a `touches` tag or one lists the other in `related:`.
- Only read a candidate PRD's `## Acceptance Criteria` and `## Edge Cases` during impact
  analysis — those are the invariants a change could violate. Don't pull whole docs.
- The output is a *checklist*, not a verdict. Verification (tests/build/manual) confirms
  whether the invariants still hold after the change.
