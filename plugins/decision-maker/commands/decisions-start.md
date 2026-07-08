---
description: Start a decision log for autonomous implementation — decide-and-log instead of stopping to ask
argument-hint: "[path to plan or spec]"
allowed-tools: Read, Write, Glob, Grep, Bash(mkdir:*), Bash(date:*)
---

# Start Decision Log

Create the decision log that arms decide-and-continue behavior for this build,
following the `decision-maker` skill.

## Steps

1. Resolve the plan/spec:
   - If `$ARGUMENTS` is provided, treat it as the path to the plan/spec.
   - If empty, look for a recent plan/spec (e.g. under `docs/plans/`,
     `docs/superpowers/plans/`, or the conversation). If none, proceed with
     "none".
2. Pick the log location via the skill's doc-location discovery (existing docs
   home → else create `docs/` → else repo root).
3. Compute a timestamp: run `date +%Y-%m-%d-%H%M%S`. Name the file
   `implementation-notes-<timestamp>.md`.
4. Create the file from the template at
   `${CLAUDE_PLUGIN_ROOT}/skills/decision-maker/references/decision-log-template.md`.
   If a plan/spec was found, copy its "Assumptions carried in" items into the
   log's matching section; otherwise write "None recorded."
5. Confirm to the user: the log path, and that from now on off-plan surprises
   will be decided conservatively and logged under Deviations rather than
   interrupting — except destructive or architecture-altering forks, which will
   still be raised.
