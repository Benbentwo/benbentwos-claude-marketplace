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
