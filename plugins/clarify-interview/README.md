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
