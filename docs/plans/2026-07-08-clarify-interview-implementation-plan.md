# clarify-interview Plugin — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Ship a Claude Code plugin that, during design/planning, interviews the user one question at a time about ambiguity — prioritizing questions whose answer would change the architecture.

**Architecture:** A marketplace plugin under `plugins/clarify-interview/` with three activation layers (the approved D-blend): an auto-triggering skill carrying the interview doctrine, a `/interview` command for deliberate invocation, and a prompt-based `UserPromptSubmit` hook that detects planning intent and nudges Claude toward the skill. Components are auto-discovered by directory convention; no `plugin.json` component paths needed.

**Tech Stack:** Claude Code plugin format — JSON manifest (`plugin.json`, `marketplace.json`), Markdown skill/command files with YAML frontmatter, prompt-based hooks (`hooks/hooks.json`). No runtime code, no build step.

## Global Constraints

- Plugin directory: `plugins/clarify-interview/` — components auto-discovered under `commands/`, `skills/<skill>/SKILL.md`, `hooks/hooks.json`. Copied verbatim from repo convention.
- Reference internal files from Markdown bodies via `${CLAUDE_PLUGIN_ROOT}/...` full paths.
- Skill frontmatter: `name` (kebab-case matching directory), `description` (starts "This skill should be used when..." with quoted trigger phrases). Optional `version: 0.1.0`.
- Command frontmatter fields: `description`, `argument-hint`, `allowed-tools` (comma-separated inline list).
- Hooks are **prompt-based** (`"type": "prompt"`) — deliberately the repo's first prompt-based hook, per approved spec Section 4. Supported events for prompt hooks: Stop, SubagentStop, UserPromptSubmit, PreToolUse.
- Manifest `version`: `0.1.0`. `author`: `{"name": "Benjamin Smith"}`. Marketplace `category`: `workflow`.
- No test runner exists in this repo. Verification = `jq` JSON validation + structural/content assertions + `/plugin validate .` as the final manual gate.
- Spec of record: `docs/plans/2026-07-08-clarify-interview-design.md`.

---

### Task 1: Plugin manifest + clarifying-interview skill (core)

The skill is the heart of the plugin — the interview doctrine. The manifest is scaffolding it needs to be an installable plugin, so both ship together.

**Files:**
- Create: `plugins/clarify-interview/.claude-plugin/plugin.json`
- Create: `plugins/clarify-interview/skills/clarifying-interview/SKILL.md`

**Interfaces:**
- Consumes: nothing (first task).
- Produces: an installable plugin named `clarify-interview` with an auto-triggering skill named `clarifying-interview`. Later tasks (command, hook, README) reference the plugin name `clarify-interview` and skill name `clarifying-interview`.

- [ ] **Step 1: Create the plugin manifest**

Create `plugins/clarify-interview/.claude-plugin/plugin.json`:

```json
{
  "name": "clarify-interview",
  "version": "0.1.0",
  "description": "Interviews you one question at a time about ambiguity during design and planning, prioritizing questions whose answer would change the architecture, so the plan is solid before any code is written.",
  "author": {
    "name": "Benjamin Smith"
  },
  "keywords": ["planning", "design", "brainstorming", "requirements", "architecture", "workflow"]
}
```

- [ ] **Step 2: Verify the manifest is valid JSON**

Run: `jq empty plugins/clarify-interview/.claude-plugin/plugin.json && echo VALID`
Expected: prints `VALID` (no jq parse error).

- [ ] **Step 3: Write the skill**

Create `plugins/clarify-interview/skills/clarifying-interview/SKILL.md`:

```markdown
---
name: clarifying-interview
description: This skill should be used when the user is designing, planning, architecting, or scoping something new — e.g. "let's build X", "design X", "plan X", "how should I structure X", "I want to add X", or before entering plan mode. Runs a disciplined architectural-triage interview: one question at a time, prioritizing questions whose answer would change the architecture. Use before writing code or a spec, whenever requirements are ambiguous.
version: 0.1.0
---

# Clarifying Interview

Turn an ambiguous idea into a decision-complete plan by interviewing the user
**one question at a time**, prioritizing the questions whose answers would
change the architecture.

## When to use

Any time the user is designing, planning, or scoping work and the requirements
are not yet decision-complete. Prefer this the moment ambiguity would change
*what gets built*, not just how it looks.

This is a narrow, disciplined complement to broad brainstorming: its only job is
architectural-triage questioning. If a full design-doc lifecycle is wanted,
defer to that; this skill is the questioning engine.

## Doctrine

1. **One question per message.** Never batch. If a topic needs more, split it
   across turns.
2. **Rank by architectural leverage.** Before asking, sort candidate questions
   by how much the answer changes the architecture. Ask the fork-in-the-road
   questions first. Defer or drop cosmetic ones.
3. **Multiple-choice when possible.** Offer concrete options (A/B/C). They are
   easier to answer than open-ended prompts.
4. **Always name a recommendation.** Lead with the option you recommend and one
   line of reasoning, so the user can approve by default.
5. **Track knowns vs. unknowns.** Keep an explicit running split: what is now
   settled, what is still open.
6. **Terminate into the plan.** When the architecture-changing questions are
   resolved, stop interviewing and write the outcome into the plan/spec:
   - **Decisions** — what was settled and why.
   - **Assumptions carried in** — known-but-unresolved items the build should
     watch for. These are what the companion decision-maker plugin reads later.

## How to run the interview

- Open by restating the goal in one sentence to confirm shared understanding.
- Ask question 1 (highest architectural leverage). Wait for the answer.
- After each answer, briefly reflect it back, update the knowns/unknowns split,
  then ask the next-highest-leverage question.
- Stop when remaining unknowns would not change the architecture — do not drill
  into cosmetic detail. Interrupting up front is cheap; over-interviewing wastes
  the user's time.
- Close by writing Decisions + Assumptions into the plan/spec.

## What NOT to do

- Do not ask two questions in one message.
- Do not ask cosmetic questions before architectural ones.
- Do not continue interviewing once the architecture is settled.
- Do not silently assume — if an architecture-changing ambiguity remains, ask.
```

- [ ] **Step 4: Verify the skill file structure**

Run:
```bash
test -f plugins/clarify-interview/skills/clarifying-interview/SKILL.md \
  && head -1 plugins/clarify-interview/skills/clarifying-interview/SKILL.md | grep -q '^---$' \
  && grep -q '^name: clarifying-interview$' plugins/clarify-interview/skills/clarifying-interview/SKILL.md \
  && grep -q 'one question at a time\|One question per message' plugins/clarify-interview/skills/clarifying-interview/SKILL.md \
  && echo OK
```
Expected: prints `OK` (file exists, opens with YAML frontmatter, correct skill name, encodes the one-question rule).

- [ ] **Step 5: Commit**

```bash
git add plugins/clarify-interview/.claude-plugin/plugin.json plugins/clarify-interview/skills/clarifying-interview/SKILL.md
git commit -m "feat(clarify-interview): add plugin manifest and clarifying-interview skill"
```

---

### Task 2: /interview command

**Files:**
- Create: `plugins/clarify-interview/commands/interview.md`

**Interfaces:**
- Consumes: the `clarifying-interview` skill from Task 1 (the command instructs Claude to run that skill's doctrine).
- Produces: the `/interview` slash command.

- [ ] **Step 1: Write the command**

Create `plugins/clarify-interview/commands/interview.md`:

```markdown
---
description: Interview me one question at a time about ambiguity, prioritizing architecture-changing questions
argument-hint: "[topic or feature to clarify]"
allowed-tools: Read, Write, Edit, Glob, Grep
---

# Clarifying Interview

Run a disciplined architectural-triage interview to make the current idea
decision-complete before building.

Apply the doctrine in the `clarifying-interview` skill exactly:
one question per message, ranked by architectural leverage, multiple-choice with
a named recommendation, tracking knowns vs. unknowns, terminating into the plan.

## Steps

1. Determine the subject:
   - If `$ARGUMENTS` is provided, interview about that topic/feature.
   - If `$ARGUMENTS` is empty, infer the subject from the current conversation
     (what the user is designing or planning). If it is unclear, ask a single
     question: "What are we designing that you'd like me to interview you about?"
2. Restate the goal in one sentence to confirm shared understanding.
3. Ask the single highest-architectural-leverage question. Offer A/B/C options
   and your recommendation with one line of reasoning. Then wait.
4. After each answer: reflect it back, update the knowns/unknowns split, and ask
   the next-highest-leverage question — one at a time.
5. Stop once the remaining unknowns would not change the architecture.
6. Write the outcome into the relevant plan/spec: a **Decisions** section and an
   **Assumptions carried in** section.
```

- [ ] **Step 2: Verify the command file**

Run:
```bash
test -f plugins/clarify-interview/commands/interview.md \
  && grep -q '^description:' plugins/clarify-interview/commands/interview.md \
  && grep -q '^allowed-tools:' plugins/clarify-interview/commands/interview.md \
  && grep -q '\$ARGUMENTS' plugins/clarify-interview/commands/interview.md \
  && echo OK
```
Expected: prints `OK`.

- [ ] **Step 3: Commit**

```bash
git add plugins/clarify-interview/commands/interview.md
git commit -m "feat(clarify-interview): add /interview command"
```

---

### Task 3: UserPromptSubmit prompt-based hook

**Files:**
- Create: `plugins/clarify-interview/hooks/hooks.json`

**Interfaces:**
- Consumes: the `clarifying-interview` skill name from Task 1 (the hook nudges Claude toward it).
- Produces: a `UserPromptSubmit` prompt hook that injects planning-intent nudges. No later task depends on it.

- [ ] **Step 1: Write the hook**

Create `plugins/clarify-interview/hooks/hooks.json`. This is a prompt-based hook: on each user prompt it evaluates whether the prompt is design/planning intent and, if so, adds context steering Claude into the interview. It must be a no-op for non-planning prompts to avoid noise.

```json
{
  "description": "Detects design/planning intent and nudges Claude to run the clarifying-interview architectural-triage interview",
  "hooks": {
    "UserPromptSubmit": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "prompt",
            "prompt": "Decide whether the user's prompt ($USER_PROMPT) is starting design, planning, architecture, or scoping work on something new or non-trivial (e.g. 'let's build/design/plan/architect X', 'how should I structure X', 'I want to add X'). If it is NOT such a prompt (it's a small edit, a question, debugging, or continuing already-settled work), add no context and return nothing. If it IS design/planning intent, add this guidance as context for the assistant: 'Before proposing a design or writing code, use the clarifying-interview skill: interview the user ONE question at a time about anything ambiguous, prioritizing questions whose answer would change the architecture; offer multiple-choice options with a recommendation; then write Decisions and Assumptions into the plan.' Do not block the prompt."
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
jq -e '.hooks.UserPromptSubmit[0].hooks[0].type == "prompt"' plugins/clarify-interview/hooks/hooks.json >/dev/null \
  && jq -e '.hooks.UserPromptSubmit[0].hooks[0].prompt | test("clarifying-interview")' plugins/clarify-interview/hooks/hooks.json >/dev/null \
  && echo OK
```
Expected: prints `OK` (valid JSON, prompt-type hook on UserPromptSubmit, references the skill).

- [ ] **Step 3: Commit**

```bash
git add plugins/clarify-interview/hooks/hooks.json
git commit -m "feat(clarify-interview): add UserPromptSubmit planning-intent hook"
```

---

### Task 4: README + marketplace registration + changelog

Documentation and registration that make the plugin discoverable and installable. Grouped because a reviewer evaluates "is this plugin properly published" as one unit.

**Files:**
- Create: `plugins/clarify-interview/README.md`
- Modify: `.claude-plugin/marketplace.json` (add entry to `plugins` array)
- Modify: `CHANGELOG.md` (add entry under `## [Unreleased]` → `### Added`)

**Interfaces:**
- Consumes: plugin name `clarify-interview`, skill/command/hook from Tasks 1–3.
- Produces: a registered, documented plugin.

- [ ] **Step 1: Write the README**

Create `plugins/clarify-interview/README.md`:

```markdown
# clarify-interview

Interviews you one question at a time about ambiguity during design and
planning — prioritizing the questions whose answer would change the
architecture — so the plan is solid before any code is written.

## Features

- **`clarifying-interview` skill** — auto-triggers on design/planning language
  and runs a disciplined architectural-triage interview.
- **`/interview [topic]`** — deliberately start the interview on any topic.
- **Planning-intent hook** — detects design/planning prompts and nudges Claude
  into the interview even when it would not spontaneously do so.

## Installation

```
/plugin marketplace add /path/to/benbentwos-claude-marketplace
/plugin install clarify-interview
```

## How It Works

### The doctrine

1. One question per message — never batched.
2. Questions ranked by architectural leverage; forks first, cosmetics last.
3. Multiple-choice options with a named recommendation.
4. An explicit running split of knowns vs. unknowns.
5. Terminates into the plan: a **Decisions** section and an **Assumptions
   carried in** section.

### Why it exists

Front-load the *known* unknowns while interrupting is cheap. Its companion
plugin, **decision-maker**, then absorbs the *unknown* unknowns during the build
without stopping to ask — reading the Assumptions this plugin recorded.
```

- [ ] **Step 2: Register the plugin in the marketplace**

In `.claude-plugin/marketplace.json`, add this object as a new element of the top-level `plugins` array (after the existing `context-docs` entry; ensure the preceding entry keeps a trailing comma and JSON stays valid):

```json
    {
      "name": "clarify-interview",
      "source": "./plugins/clarify-interview",
      "description": "Interviews you one question at a time about ambiguity during design and planning, prioritizing questions whose answer would change the architecture",
      "version": "0.1.0",
      "author": {
        "name": "Benjamin Smith"
      },
      "category": "workflow",
      "keywords": ["planning", "design", "brainstorming", "requirements", "architecture", "workflow"]
    }
```

- [ ] **Step 3: Verify marketplace.json is still valid and contains the entry**

Run:
```bash
jq -e '.plugins[] | select(.name == "clarify-interview") | .source == "./plugins/clarify-interview"' .claude-plugin/marketplace.json >/dev/null \
  && echo OK
```
Expected: prints `OK` (valid JSON, entry present with correct source).

- [ ] **Step 4: Add a changelog entry**

In `CHANGELOG.md`, under `## [Unreleased]` → `### Added`, add:

```markdown
- **clarify-interview plugin** (v0.1.0) - Architectural-triage interview for the design/planning phase
  - `clarifying-interview` skill - auto-triggers on design/planning language; asks one question at a time, prioritizing architecture-changing questions
  - `/interview` command - deliberately start the interview on any topic
  - `UserPromptSubmit` hook - detects planning intent and nudges Claude into the interview
```

(If `## [Unreleased]` or its `### Added` subsection does not exist, create them above the most recent dated release section.)

- [ ] **Step 5: Verify the changelog mentions the plugin**

Run: `grep -q 'clarify-interview plugin' CHANGELOG.md && echo OK`
Expected: prints `OK`.

- [ ] **Step 6: Final structural validation of the whole plugin**

Run:
```bash
for f in \
  plugins/clarify-interview/.claude-plugin/plugin.json \
  plugins/clarify-interview/skills/clarifying-interview/SKILL.md \
  plugins/clarify-interview/commands/interview.md \
  plugins/clarify-interview/hooks/hooks.json \
  plugins/clarify-interview/README.md ; do
  test -f "$f" || { echo "MISSING: $f"; break; }
done
jq empty plugins/clarify-interview/.claude-plugin/plugin.json
jq empty plugins/clarify-interview/hooks/hooks.json
jq empty .claude-plugin/marketplace.json
echo ALL-OK
```
Expected: prints `ALL-OK` with no `MISSING` line and no jq errors.

- [ ] **Step 7: Manual gate — run the built-in validator**

In an interactive Claude Code session at the repo root, run `/plugin validate .` and confirm `clarify-interview` reports no structural errors. (This command cannot be run from bash; it is the repo's canonical validation per its Contributing guide.)

- [ ] **Step 8: Commit**

```bash
git add plugins/clarify-interview/README.md .claude-plugin/marketplace.json CHANGELOG.md
git commit -m "docs(clarify-interview): add README, register in marketplace, update changelog"
```

---

## Self-Review

**Spec coverage** (against `2026-07-08-clarify-interview-design.md`):
- Skill (auto-trigger, doctrine) → Task 1. ✓
- `/interview` command → Task 2. ✓
- UserPromptSubmit prompt-based hook → Task 3. ✓
- Output into plan (Decisions + Assumptions) → encoded in skill (Task 1) and command (Task 2). ✓
- Independent-but-aware coupling → skill/README describe Assumptions as what decision-maker reads; no hard dependency. ✓
- Distinct niche vs. brainstorming → stated in skill body and README. ✓
- Manifest + marketplace registration + README → Tasks 1 & 4. ✓

**Placeholder scan:** No TBD/TODO; every file's full content is inline; every verification is a runnable command with expected output. ✓

**Type/name consistency:** plugin name `clarify-interview`, skill name `clarifying-interview`, command `/interview` used identically across all tasks, README, marketplace entry, and changelog. ✓
