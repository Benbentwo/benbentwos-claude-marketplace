# decision-maker Plugin — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Ship a Claude Code plugin that makes Claude an autonomous decision-maker during the build phase — turning would-be mid-build clarifying questions into conservative, logged decisions instead of round-trips to the user.

**Architecture:** A marketplace plugin under `plugins/decision-maker/` (hook-weighted blend). A prompt-based `Stop` hook is the enforcement core: when Claude tries to end its turn to ask a mid-build question that is neither destructive nor architecture-altering, it blocks the stop and directs Claude to pick the conservative option, log it, and continue. A `decision-maker` skill defines the log format, the conservative-choice rule, the escape hatch, doc-location discovery, and plan seeding. A `/decisions-start` command creates the log (the activation flag) and arms the behavior.

**Tech Stack:** Claude Code plugin format — JSON manifest, Markdown skill/command/reference files with YAML frontmatter, prompt-based hooks. No runtime code, no build step.

## Global Constraints

- Plugin directory: `plugins/decision-maker/` — components auto-discovered under `commands/`, `skills/<skill>/SKILL.md` (+ `references/`), `hooks/hooks.json`. Copied verbatim from repo convention.
- Reference internal files from Markdown bodies via `${CLAUDE_PLUGIN_ROOT}/...` full paths.
- Skill frontmatter: `name` (kebab-case matching directory `decision-maker`), `description` (starts "This skill should be used when..." with quoted trigger phrases), optional `version: 0.1.0`.
- Command frontmatter fields: `description`, `argument-hint`, `allowed-tools` (comma-separated; scoped bash as `Bash(mkdir:*)`).
- Hooks are **prompt-based** (`"type": "prompt"`). The `Stop` prompt hook returns `{"decision": "approve"|"block", "reason": "..."}` — `block` forces Claude to continue with the reason as guidance; `approve` allows the stop.
- **Log filename:** `implementation-notes-<datetime>.md`, datetime `YYYY-MM-DD-HHmmss` (e.g. `implementation-notes-2026-07-08-142530.md`). Honors the original design principle verbatim. The log's **existence** is the "we are building" activation flag.
- **Escape hatch:** still stop and ask ONLY when the sole path forward is destructive/irreversible OR the surprise is architecture-altering. Everything smaller is decided autonomously and logged.
- **Coupling:** independent-but-aware. decision-maker owns arming; it opportunistically seeds from a plan/spec if present but never requires clarify-interview.
- Manifest `version`: `0.1.0`. `author`: `{"name": "Benjamin Smith"}`. Marketplace `category`: `workflow`.
- No test runner exists in this repo. Verification = `jq` JSON validation + structural/content assertions + `/plugin validate .` as the final manual gate.
- Spec of record: `docs/plans/2026-07-08-decision-maker-design.md`.

---

### Task 1: Manifest + decision-maker skill + log template (core)

The skill and its log template are the heart — they define the format, the conservative-choice rule, the escape hatch, doc-location discovery, and seeding. The manifest is the scaffolding they need to be installable, so all three ship together.

**Files:**
- Create: `plugins/decision-maker/.claude-plugin/plugin.json`
- Create: `plugins/decision-maker/skills/decision-maker/SKILL.md`
- Create: `plugins/decision-maker/skills/decision-maker/references/decision-log-template.md`

**Interfaces:**
- Consumes: nothing (first task).
- Produces: plugin `decision-maker`, skill `decision-maker`, and a log template at `${CLAUDE_PLUGIN_ROOT}/skills/decision-maker/references/decision-log-template.md`. Later tasks (command, hook, README) rely on: the log filename pattern `implementation-notes-<datetime>.md`, the `Deviations` section name, and the escape-hatch rule defined here.

- [ ] **Step 1: Create the plugin manifest**

Create `plugins/decision-maker/.claude-plugin/plugin.json`:

```json
{
  "name": "decision-maker",
  "version": "0.1.0",
  "description": "Makes Claude an autonomous decision-maker during implementation: when the plan doesn't cover something, it picks the conservative non-destructive option and logs it under Deviations instead of stopping to ask — only pausing for destructive or architecture-altering forks.",
  "author": {
    "name": "Benjamin Smith"
  },
  "keywords": ["implementation", "autonomy", "decisions", "deviations", "workflow", "notes"]
}
```

- [ ] **Step 2: Verify the manifest is valid JSON**

Run: `jq empty plugins/decision-maker/.claude-plugin/plugin.json && echo VALID`
Expected: prints `VALID`.

- [ ] **Step 3: Write the log template reference**

Create `plugins/decision-maker/skills/decision-maker/references/decision-log-template.md`:

```markdown
# Decision Log Template

The decision log is a Markdown file named
`implementation-notes-<YYYY-MM-DD-HHmmss>.md`, placed in the repository's docs
home (see doc-location discovery in the skill). Seed it at build start with the
structure below.

    # Implementation Notes — <one-line build description>

    **Started:** <YYYY-MM-DD HH:mm:ss>
    **Plan/spec:** <relative path to plan or spec, or "none">

    ## Assumptions carried in

    <Bulleted list seeded from the plan/spec's "Assumptions carried in" section,
    if one exists. Otherwise: "None recorded.">

    ## Decisions

    <Notable non-trivial choices made while executing the plan that were NOT
    forced deviations. Optional; add entries as they occur.>

    ## Deviations

    <One entry per off-plan surprise handled autonomously. Append, never
    rewrite. Each entry:>

    ### <YYYY-MM-DD HH:mm:ss> — <short title>

    - **Surfaced:** <what came up that the plan did not cover>
    - **Chosen:** <the conservative, non-destructive option taken>
    - **Why:** <why this is the conservative/reversible choice>
    - **Revisit:** <what the user may want to review later, if anything>
```

- [ ] **Step 4: Write the skill**

Create `plugins/decision-maker/skills/decision-maker/SKILL.md`:

```markdown
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
```

- [ ] **Step 5: Verify skill + template structure**

Run:
```bash
test -f plugins/decision-maker/skills/decision-maker/SKILL.md \
  && grep -q '^name: decision-maker$' plugins/decision-maker/skills/decision-maker/SKILL.md \
  && grep -q 'Escape hatch' plugins/decision-maker/skills/decision-maker/SKILL.md \
  && grep -q 'implementation-notes-' plugins/decision-maker/skills/decision-maker/SKILL.md \
  && test -f plugins/decision-maker/skills/decision-maker/references/decision-log-template.md \
  && grep -q '## Deviations' plugins/decision-maker/skills/decision-maker/references/decision-log-template.md \
  && echo OK
```
Expected: prints `OK`.

- [ ] **Step 6: Commit**

```bash
git add plugins/decision-maker/.claude-plugin/plugin.json plugins/decision-maker/skills/decision-maker/
git commit -m "feat(decision-maker): add manifest, decision-maker skill, and log template"
```

---

### Task 2: /decisions-start command

Creates the decision log (the activation flag) and arms the decide-and-continue behavior. This is also the mechanism invoked when a plan/spec is approved.

**Files:**
- Create: `plugins/decision-maker/commands/decisions-start.md`

**Interfaces:**
- Consumes: the `decision-maker` skill (doc-location discovery, template path, filename pattern) from Task 1.
- Produces: the `/decisions-start` command.

- [ ] **Step 1: Write the command**

Create `plugins/decision-maker/commands/decisions-start.md`:

```markdown
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
```

- [ ] **Step 2: Verify the command file**

Run:
```bash
test -f plugins/decision-maker/commands/decisions-start.md \
  && grep -q '^description:' plugins/decision-maker/commands/decisions-start.md \
  && grep -q 'Bash(date:\*)' plugins/decision-maker/commands/decisions-start.md \
  && grep -q 'implementation-notes-' plugins/decision-maker/commands/decisions-start.md \
  && grep -q '\$ARGUMENTS' plugins/decision-maker/commands/decisions-start.md \
  && echo OK
```
Expected: prints `OK`.

- [ ] **Step 3: Commit**

```bash
git add plugins/decision-maker/commands/decisions-start.md
git commit -m "feat(decision-maker): add /decisions-start command"
```

---

### Task 3: Stop prompt-based hook (enforcement core)

**Files:**
- Create: `plugins/decision-maker/hooks/hooks.json`

**Interfaces:**
- Consumes: the activation-flag concept, the `Deviations` section name, and the escape-hatch rule from Task 1.
- Produces: a `Stop` prompt hook enforcing decide-and-continue. No later task depends on it.

- [ ] **Step 1: Write the hook**

Create `plugins/decision-maker/hooks/hooks.json`. The prompt does the judgment: it first gates on whether an active decision log exists this session (no-op otherwise), then decides whether Claude is stopping to ask a non-destructive, non-architectural mid-build question — if so it blocks the stop and directs decide-and-log; otherwise it approves.

```json
{
  "description": "During an active implementation (a decision log exists), redirects would-be mid-build clarifying questions into conservative logged decisions instead of stopping to ask",
  "hooks": {
    "Stop": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "prompt",
            "prompt": "You are gating whether the assistant may stop.\n\nStep 1 (activation gate): Determine whether an active implementation decision log was established this session — a file named implementation-notes-<datetime>.md was created via /decisions-start or on plan approval, and the assistant is executing an approved plan. If NO such active log exists, return {\"decision\": \"approve\"} and stop — this hook must be a silent no-op outside an active build.\n\nStep 2 (only if a log is active): Determine why the assistant is stopping. If it is finishing legitimately (the planned work is complete, or it already asked and is awaiting an answer), return {\"decision\": \"approve\"}.\n\nStep 3: If the assistant is stopping to ASK the user a mid-build clarifying question because the plan did not cover something, classify that question:\n- If answering it would require a DESTRUCTIVE or IRREVERSIBLE action with no safe default (data loss, irreversible migration, deleting user work, force-push, spending money), OR the surprise is ARCHITECTURE-ALTERING (a genuine fork changing the data model, protocol, or a system boundary) — return {\"decision\": \"approve\"} so the question reaches the user.\n- Otherwise (a small, reversible, non-architectural choice) — return {\"decision\": \"block\", \"reason\": \"Do not stop to ask. Pick the recommended non-destructive, reversible option, append a Deviations entry to the active implementation-notes log (what surfaced, what you chose, why it is conservative), and continue implementing.\"}.\n\nReturn only the JSON decision object."
          }
        ]
      }
    ]
  }
}
```

- [ ] **Step 2: Verify the hook is valid JSON with the right shape**

Run:
```bash
jq -e '.hooks.Stop[0].hooks[0].type == "prompt"' plugins/decision-maker/hooks/hooks.json >/dev/null \
  && jq -e '.hooks.Stop[0].hooks[0].prompt | test("Deviations")' plugins/decision-maker/hooks/hooks.json >/dev/null \
  && jq -e '.hooks.Stop[0].hooks[0].prompt | test("architecture-altering|ARCHITECTURE-ALTERING")' plugins/decision-maker/hooks/hooks.json >/dev/null \
  && echo OK
```
Expected: prints `OK` (valid JSON; prompt-type Stop hook; encodes the Deviations log and the escape hatch).

- [ ] **Step 3: Commit**

```bash
git add plugins/decision-maker/hooks/hooks.json
git commit -m "feat(decision-maker): add Stop hook enforcing decide-and-continue"
```

---

### Task 4: README + marketplace registration + changelog

**Files:**
- Create: `plugins/decision-maker/README.md`
- Modify: `.claude-plugin/marketplace.json` (add entry to `plugins` array)
- Modify: `CHANGELOG.md` (add entry under `## [Unreleased]` → `### Added`)

**Interfaces:**
- Consumes: plugin name `decision-maker` and components from Tasks 1–3.
- Produces: a registered, documented plugin.

- [ ] **Step 1: Write the README**

Create `plugins/decision-maker/README.md`:

```markdown
# decision-maker

Makes Claude an autonomous decision-maker during the build phase. Once the plan
is set, when something it did not cover surfaces, Claude picks the conservative,
non-destructive option and logs it under **Deviations** instead of stopping to
ask — pausing only for destructive or architecture-altering forks.

## Features

- **Stop hook (enforcement core)** — when Claude would end its turn to ask a
  non-destructive, non-architectural mid-build question, it is redirected to
  decide, log, and continue.
- **`decision-maker` skill** — defines the log format, the conservative-choice
  rule, the escape hatch, doc-location discovery, and plan seeding.
- **`/decisions-start [plan]`** — create the decision log (the activation flag)
  and arm the behavior for an ad-hoc build.

## Installation

```
/plugin marketplace add /path/to/benbentwos-claude-marketplace
/plugin install decision-maker
```

## How It Works

### The activation flag

A build is "active" when a decision log
(`implementation-notes-<datetime>.md`) exists for the session. Create it with
`/decisions-start` or on plan approval. While it exists, the Stop hook enforces
decide-and-continue. Archive or remove it and the behavior goes silent — no
config.

### The escape hatch

Claude still stops and asks in exactly two cases: the only path forward is
**destructive/irreversible**, or the surprise is **architecture-altering**.
Everything smaller is decided and logged.

### Why it exists

Its companion, **clarify-interview**, front-loads the *known* unknowns while
interrupting is cheap. decision-maker absorbs the *unknown* unknowns during the
build without a round-trip — seeding its "Assumptions carried in" from whatever
plan clarify-interview produced, when present.
```

- [ ] **Step 2: Register the plugin in the marketplace**

In `.claude-plugin/marketplace.json`, add this object as a new element of the top-level `plugins` array (after the `clarify-interview` entry if present, else after `context-docs`; keep JSON valid with correct commas):

```json
    {
      "name": "decision-maker",
      "source": "./plugins/decision-maker",
      "description": "Autonomous implementation decisions: picks the conservative non-destructive option and logs it under Deviations instead of stopping to ask, pausing only for destructive or architecture-altering forks",
      "version": "0.1.0",
      "author": {
        "name": "Benjamin Smith"
      },
      "category": "workflow",
      "keywords": ["implementation", "autonomy", "decisions", "deviations", "workflow", "notes"]
    }
```

- [ ] **Step 3: Verify marketplace.json is still valid and contains the entry**

Run:
```bash
jq -e '.plugins[] | select(.name == "decision-maker") | .source == "./plugins/decision-maker"' .claude-plugin/marketplace.json >/dev/null \
  && echo OK
```
Expected: prints `OK`.

- [ ] **Step 4: Add a changelog entry**

In `CHANGELOG.md`, under `## [Unreleased]` → `### Added`, add:

```markdown
- **decision-maker plugin** (v0.1.0) - Autonomous decision-making during implementation
  - Stop hook - redirects non-destructive, non-architectural mid-build questions into logged decisions instead of stopping to ask
  - `decision-maker` skill - log format, conservative-choice rule, escape hatch, doc-location discovery, plan seeding
  - `/decisions-start` command - create the decision log and arm decide-and-continue
```

(If `## [Unreleased]` or `### Added` does not exist, create them above the most recent dated release section.)

- [ ] **Step 5: Verify the changelog mentions the plugin**

Run: `grep -q 'decision-maker plugin' CHANGELOG.md && echo OK`
Expected: prints `OK`.

- [ ] **Step 6: Final structural validation of the whole plugin**

Run:
```bash
for f in \
  plugins/decision-maker/.claude-plugin/plugin.json \
  plugins/decision-maker/skills/decision-maker/SKILL.md \
  plugins/decision-maker/skills/decision-maker/references/decision-log-template.md \
  plugins/decision-maker/commands/decisions-start.md \
  plugins/decision-maker/hooks/hooks.json \
  plugins/decision-maker/README.md ; do
  test -f "$f" || { echo "MISSING: $f"; break; }
done
jq empty plugins/decision-maker/.claude-plugin/plugin.json
jq empty plugins/decision-maker/hooks/hooks.json
jq empty .claude-plugin/marketplace.json
echo ALL-OK
```
Expected: prints `ALL-OK` with no `MISSING` line and no jq errors.

- [ ] **Step 7: Manual gate — run the built-in validator**

In an interactive Claude Code session at the repo root, run `/plugin validate .` and confirm `decision-maker` reports no structural errors.

- [ ] **Step 8: Commit**

```bash
git add plugins/decision-maker/README.md .claude-plugin/marketplace.json CHANGELOG.md
git commit -m "docs(decision-maker): add README, register in marketplace, update changelog"
```

---

## Self-Review

**Spec coverage** (against `2026-07-08-decision-maker-design.md`):
- Stop prompt hook, file-presence gate, escape hatch → Task 3 (gate + escape hatch in the prompt). ✓
- Skill: log format, conservative rule, escape hatch, doc-location discovery, seeding → Task 1. ✓
- Log template with `Deviations` (+ Assumptions carried in) → Task 1. ✓
- `/decisions-start` command, arming, timestamped filename → Task 2. ✓
- Log filename `implementation-notes-<datetime>.md` as activation flag → Global Constraints + Tasks 1–3. ✓
- Independent-but-aware coupling / seeding from plan → skill + command + README. ✓
- Manifest + marketplace registration + README → Tasks 1 & 4. ✓
- Resolved open questions: filename kept literal; decision-maker owns arming; datetime `YYYY-MM-DD-HHmmss`. ✓

**Placeholder scan:** No TBD/TODO; every file's full content inline; every verification is a runnable command with expected output. ✓

**Type/name consistency:** plugin name `decision-maker`, skill name `decision-maker`, command `/decisions-start`, log pattern `implementation-notes-<datetime>.md`, section name `Deviations`, and the two-case escape hatch used identically across skill, command, hook, README, changelog, and marketplace entry. ✓
