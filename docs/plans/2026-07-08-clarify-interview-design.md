# clarify-interview — Design

**Date:** 2026-07-08
**Status:** Approved (brainstorm), pending implementation plan
**Companion plugin:** [decision-maker](2026-07-08-decision-maker-design.md)

## Origin

Design principle:

> "Interview me one question at a time about anything ambiguous, prioritize
> questions where my answer would change the architecture."

## Purpose

A Claude Code plugin that engages during the **design/planning phase** and
interviews the user to surface and resolve ambiguity *before* work begins.
It front-loads the **known unknowns** — resolving the ambiguities that would
change the architecture — so the plan is solid before any code is written.

This is the first half of a two-plugin workflow:

- **`clarify-interview`** (this plugin) — resolve knowns/unknowns up front.
- **`decision-maker`** — during the build, make the call on *unknown* unknowns
  that surface, choosing the conservative option and logging it instead of
  stopping to ask.

The shared goal is **fewer round-trips**: interrupt up front where it is cheap,
avoid interrupting mid-build.

## Doctrine (the behavior the plugin enforces)

1. **One question per message.** Never batch questions.
2. **Multiple-choice when possible.** Easier to answer than open-ended; offer
   an explicit recommendation with reasoning each time.
3. **Rank by architectural leverage.** Ask the fork-in-the-road questions first
   — the ones whose answer changes the architecture. Defer or skip cosmetic
   ones. This is the core differentiator.
4. **Separate knowns from unknowns.** Track what is settled vs. still open.
5. **Name a recommendation every time.** Lead with the recommended option and
   why, so the user can approve-by-default.
6. **Terminate into the plan.** End by writing resolved decisions **and the
   still-open assumptions** into the plan/spec, so known-unknowns are visible
   going into the build.

## Architecture

A blend of three activation mechanisms so the interview fires reliably but the
user retains control:

### Components

| Component | Path | Role |
|---|---|---|
| Skill | `skills/clarifying-interview/SKILL.md` | Core doctrine. Auto-triggers on design/planning language. |
| Command | `commands/interview.md` | `/interview` — deliberate invocation on any topic. |
| Hook | `hooks/hooks.json` (+ prompt) | `UserPromptSubmit` prompt-based hook that detects planning intent and nudges Claude toward the skill. |
| Manifest | `.claude-plugin/plugin.json` | Plugin metadata. |
| Readme | `README.md` | Usage + philosophy. |

### Skill

- **Description** tuned to fire on "design / plan / build / architect X" style
  prompts so Claude naturally reaches for it.
- **Body** encodes the six doctrine points above.
- Progressive disclosure: keep SKILL.md focused; push any long templates
  (e.g., a decision-log format) into `references/`.

### Command

- `/interview [topic]` — invoke the interview deliberately, even mid-project.
- Same doctrine as the skill; useful when Claude did not auto-trigger.

### Hook (prompt-based)

- Event: `UserPromptSubmit`.
- **Judgment required** ("is this prompt planning/design intent?") → use a
  **prompt-based hook**, not a regex script.
- On a positive match, injects a short nudge into context: reach for the
  clarifying-interview skill and run the architectural-triage interview.
- This is the "forceful" layer so the behavior fires even when Claude would not
  spontaneously pick the skill.

## Relationship to existing tools

Conceptual overlap with `superpowers:brainstorming`, but a **deliberately
distinct niche**:

- `brainstorming` — broad, idea-shaping, full design-doc lifecycle.
- `clarify-interview` — a disciplined **architectural-triage interview**:
  one question at a time, ranked by architectural leverage.

The skill description will stake out this niche so it complements rather than
duplicates brainstorming.

## Coupling to decision-maker

Awareness, not dependency (independent-but-aware):

- Neither plugin requires the other.
- `clarify-interview`'s output (decisions + open assumptions written into the
  plan/spec) is what `decision-maker` opportunistically reads if present.

## Out of scope (YAGNI)

- No separate interview-transcript artifact; output folds into the existing
  plan/spec.
- No config surface in v1.
- No enforcement that the user *answer* questions — it is advisory.

## Open questions for the implementation plan

- Exact skill description wording (triggering accuracy vs. over-firing).
- Precise `UserPromptSubmit` prompt-hook criteria to avoid false positives on
  non-planning prompts.
