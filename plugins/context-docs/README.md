# context-docs

Automatically generate and maintain feature context documents so future AI sessions (or developers) can quickly understand what was built, where changes live, how it works, and why.

## How It Works

Context docs live at `docs/context/<feature-name>.md`. Each document captures a complete knowledge snapshot of a feature — the architecture decisions, key files, technical flow, and related documentation — in a single file.

### Automatic Triggers

The `context-tracker` skill activates at two key moments:

1. **After planning** — When a feature plan is created, a context doc is generated with the overview, architecture decisions, and related docs
2. **After implementation** — When feature code is written, the context doc is updated with key files, code references, and technical details

### Manual Commands

- `/context <name>` — Create or update a context doc for a feature
- `/context-list` — List all context docs with metadata
- `/context-update <name>` — Update an existing context doc

## Document Structure

Each context doc includes:

- **Overview** — What this feature is and why it exists
- **Key Files** — Files created/modified with brief descriptions
- **Architecture Decisions** — Why things were built the way they were
- **How It Works** — Technical flow/behavior summary
- **Related Docs** — Links to PRDs, plans, roadmap entries

## Documentation Ecosystem

Context docs are designed to work alongside:

```
docs/
  context/       ← this plugin
  prds/          ← prd-manager plugin
  plans/         ← AI implementation plans
  ROADMAP.md     ← high-level project direction
  Features.md    ← feature summaries
```

## Installation

Add to your Claude Code plugins or install from the marketplace.
