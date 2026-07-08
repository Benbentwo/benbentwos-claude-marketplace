---
name: decision-maker
description: This skill should be used during implementation of an approved plan, especially when an edge case or unknown surfaces that the plan did not cover and Claude would otherwise stop to ask. Also use when the user says "start the decision log", "keep implementation notes", "log deviations", "decide as you go", or "don't stop to ask, just log it". Makes Claude pick the conservative non-destructive option, log it under Deviations, and continue — pausing only for destructive or architecture-altering forks.
version: 0.1.0
---

# Decision Maker

Once a plan is set, run to completion and decide as you go. When something the
plan did not cover surfaces, do not stop to ask — **make the conservative call,
log it, and continue.** The running log is a byproduct; fewer round-trips is the
goal.

## The activation flag

A build is "active" when a decision log
(`implementation-notes-<YYYY-MM-DD-HHmmss>.md`) exists for this session. The log
is created by `/decisions-start` or when a plan/spec is approved. While it
exists, apply the decide-and-continue behavior below. If no log exists, this
skill does not apply.

## Creating the log (doc-location discovery)

Place the log where the repo already keeps docs, to match convention. Discovery
order:

1. If a docs home exists (e.g. `docs/`, `documentation/`, or wherever other
   `.md` plan/design docs already live), use it.
2. Otherwise create and use `docs/`.
3. Last resort: repository root.

Seed the file from the template at
`${CLAUDE_PLUGIN_ROOT}/skills/decision-maker/references/decision-log-template.md`.
If a plan/spec is present, copy its "Assumptions carried in" items into the log
so mid-build surprises can be checked against what was already flagged.

## Decide-and-continue rule

When executing the plan and something surfaces that it did not cover:

1. Identify the options.
2. **Check the escape hatch first** (see below). If it applies, stop and ask.
3. Otherwise pick the **recommended, non-destructive, reversible** option.
4. Append a `Deviations` entry: what surfaced, what was chosen, why it is the
   conservative choice, and anything to revisit.
5. Continue — do not end the turn to ask.

## Escape hatch — when to STILL stop and ask

Stop and ask the user only when either holds:

- **Destructive / irreversible:** the only path forward causes data loss, an
  irreversible migration, deletes user work, force-pushes, spends money, etc.
  No safe default exists.
- **Architecture-altering:** the surprise is a genuine fork that changes the
  architecture — the kind the design interview should have caught. A small local
  choice is not architecture-altering; a different data model, protocol, or
  system boundary is.

Everything smaller is decided autonomously and logged.

## What NOT to do

- Do not stop to ask about small, reversible choices — decide and log them.
- Do not make a destructive or architecture-altering change silently — those are
  the two cases that DO warrant interrupting.
- Do not rewrite past Deviations entries — append only.
