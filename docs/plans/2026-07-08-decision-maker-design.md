# decision-maker — Design

**Date:** 2026-07-08
**Status:** Approved (brainstorm), pending implementation plan
**Companion plugin:** [clarify-interview](2026-07-08-clarify-interview-design.md)

## Origin

Design principle:

> "Keep an implementation-notes-<date-time>.md file. If you hit an edge case
> that forces you to deviate from the plan, pick the conservative option, log
> it under 'Deviations', and keep going."

## Purpose

A Claude Code plugin that makes Claude an **autonomous decision-maker during
the build phase**. Once a plan is set, Claude should run to completion, deciding
as it goes. When an **unknown unknown** surfaces — something the plan did not
cover, where Claude would normally *stop and ask* — this plugin makes it instead
**make the call**: pick the recommended, non-destructive option, record the
decision, and keep going.

The artifact (a running decisions/deviations log) is a **byproduct** of the real
goal: **fewer round-trips**. The companion `clarify-interview` plugin resolves
the *known* unknowns up front; `decision-maker` absorbs the *unknown* unknowns
during the build without a pause.

## Core behavior

This is not a passive logger — it is an **intervention at the stop-and-ask
moment** that turns a would-be question into an autonomous decision:

> During an active implementation, the moment Claude *would* end its turn to ask
> a mid-build clarifying question, the plugin redirects to:
> **choose the recommended non-destructive option → append a Deviations entry
> (what surfaced, what was chosen, why) → continue.**

### Escape hatch — when it *still* stops and asks

Autonomy stops at two lines (architecture-altering OR destructive):

1. **Destructive / irreversible** — the only path forward causes data loss, an
   irreversible migration, deletes user work, force-push, spends money, etc.
   No safe default exists.
2. **Architecture-altering** — the surprise is a genuine fork that the design
   interview *should* have caught (a big fork, not a small one).

This keeps the "architecture-changing = worth interrupting" principle
consistent with the `clarify-interview` plugin. Everything smaller is decided
autonomously and logged.

## Architecture

A blend (hook-weighted) with a file-presence activation gate.

### Components

| Component | Path | Role |
|---|---|---|
| Hook | `hooks/hooks.json` (+ prompt) | **Enforcement core.** `Stop` prompt-based hook, gated on the decision log existing. |
| Skill | `skills/decision-maker/SKILL.md` | Log format, conservative-choice rule, escape hatch, doc-location discovery, seeding from an existing plan. |
| Command | `commands/decisions-start.md` | Manual arm for ad-hoc builds. |
| Manifest | `.claude-plugin/plugin.json` | Plugin metadata. |
| Readme | `README.md` | Usage + philosophy. |

### Hook (prompt-based `Stop`)

- Event: `Stop` (fires when Claude tries to end its turn).
- **Activation gate:** no-op unless the decision log
  (`implementation-notes-<datetime>.md`) exists for the active build. Outside a
  build, total silence.
- **Judgment:** when armed, evaluate — is Claude ending the turn to *ask a
  mid-build clarifying question*?
  - If yes **and** it is *not* destructive/architecture-altering → block the
    stop; inject "make the call: pick the recommended non-destructive option,
    log it under Deviations, and continue."
  - If it hits the escape hatch (destructive OR architecture-altering) → allow
    the stop; the question reaches the user.
  - Otherwise (normal completion) → allow the stop.
- Prompt-based, not a regex script, because the decision is a judgment call.

### Skill

- **Log format:** `implementation-notes-<datetime>.md` with at minimum a
  `Deviations` section. Each entry: *what surfaced, what was chosen, why (why it
  is the conservative/non-destructive choice)*. Optional: `Assumptions carried
  in`, `Decisions`.
- **Conservative-choice rule** and the escape-hatch definition (mirrors the
  hook so behavior is consistent whether triggered by skill or hook).
- **Doc-location discovery:** place the log where the repo keeps docs, to match
  repository convention. Discovery order:
  1. Existing docs home (e.g., `docs/`, `documentation/`, or wherever other
     `.md` design/plan docs already live).
  2. Fallback: create/use `docs/` if the repo has none.
  3. Last resort: repo root.
- **Seeding:** if a plan/spec is present, seed the log with an "Assumptions
  carried in" section from it (independent-but-aware coupling).

### Command

- `/decisions-start [plan-path]` — manually create the decision log and arm the
  hook for ad-hoc builds. Also the mechanism auto-invoked when a plan/spec is
  approved.

## The log as the activation flag

The **existence** of the decision log
(`implementation-notes-<datetime>.md`) is the "we are building" signal:

- Created when work starts (plan approved, or `/decisions-start`).
- While it exists, the `Stop` hook enforces decide-and-continue.
- Archive or remove it → the hook goes silent. Self-cleaning, zero config.

## Coupling to clarify-interview

Independent-but-aware:

- Neither plugin requires the other.
- If a plan/spec (e.g., from `clarify-interview`) is present, the log is seeded
  from it and mid-build surprises can be checked against the assumptions already
  flagged — one continuous paper trail.

## Out of scope (YAGNI)

- No automatic archival/rotation of old logs in v1.
- No config surface beyond doc-location discovery.
- No enforcement of a specific plan format to seed from — best-effort read.

## Open questions for the implementation plan

- Exact `Stop` prompt-hook wording distinguishing "asking a mid-build question"
  from "normal completion" and from the escape-hatch cases.
- Whether the auto-arm on plan approval lives in this plugin or is triggered by
  `clarify-interview` (leaning: this plugin owns arming; `clarify-interview`
  stays unaware).
- Datetime format and collision handling for the filename.
- Final filename convention: keep `implementation-notes-<datetime>.md`, or
  rename to something decision-oriented (e.g., `decisions-<datetime>.md`).
