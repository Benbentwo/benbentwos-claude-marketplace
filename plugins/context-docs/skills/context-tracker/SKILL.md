---
name: context-tracker
description: This skill should be used when maintaining feature context documents in docs/context/. It applies when a project contains a docs/context/ directory, when a feature plan is created or approved, when implementation work is completed, or when the user says "update context doc", "create context doc", "capture context", "feature context", "continue where I left off", "what was built", "document what we built", "save context", "track this feature", or "resume work on".
version: 0.1.0
---

# Context Document Tracker

Automatically maintain feature context documents at `docs/context/<feature-name>.md` that capture development knowledge — what was built, where changes live, how it works, and why — so future sessions can pick up where work left off.

## Core Behavior

### On Session Start

When `docs/context/` exists:

1. Read `docs/context/INDEX.md` to understand existing context documents
2. Note which features have context docs and their last update dates
3. Keep this context available for development tasks

When `docs/context/` does not exist but documentation work begins:

1. Create `docs/context/` directory
2. Create `docs/context/INDEX.md` using the template from `${CLAUDE_PLUGIN_ROOT}/skills/context-tracker/references/context-template.md`

### Trigger Point 1: After Planning

When a feature plan is created or approved:

1. Check `docs/context/` for an existing context doc matching the feature
   - Match by filename (kebab-case feature name)
   - If unsure which feature this relates to, ask the user and propose a name
2. If no existing doc, create a new one with:
   - Overview section filled from the plan's goals and motivation
   - Architecture Decisions populated from plan choices
   - Key Files left as placeholder (to be filled during implementation)
   - Related Docs linking to the plan and any related PRD
3. If existing doc found, append:
   - New Architecture Decisions from the plan
   - Updated Related Docs links
4. Update `docs/context/INDEX.md`
5. Dispatch the `context-summarizer` agent (see "Using the Context Summarizer Agent" below)

### Trigger Point 2: After Implementation

When feature code has been written or a significant implementation milestone is reached:

1. Identify the feature being worked on
   - Check existing context docs by filename for a match
   - If unsure, ask the user and propose a name
2. If no existing doc, create one with all sections populated
3. If existing doc found, append:
   - New Key Files entries for files created or modified
   - Updated How It Works section reflecting current behavior
   - New Architecture Decisions if implementation revealed new choices
   - Updated Related Docs links
4. Update `docs/context/INDEX.md`
5. Dispatch the `context-summarizer` agent (see "Using the Context Summarizer Agent" below)

### Continuity Detection

When starting work that may relate to a previous feature:

1. Scan `docs/context/INDEX.md` for features related to the current task
2. If a match is found, read the context doc to restore knowledge
3. Reference the context doc throughout development to maintain consistency
4. After work completes, update the context doc with new information

## Documentation Ecosystem Awareness

Context docs exist within a broader documentation structure:

```
docs/
  context/       ← this plugin manages
  prds/          ← prd-manager plugin
  plans/         ← AI implementation plans
  ROADMAP.md     ← high-level project direction
  Features.md    ← feature summaries
```

When creating or updating context docs:

- Check `docs/prds/` for related PRDs and link them in Related Docs
- Check `docs/plans/` for related plans and link them
- Reference `docs/ROADMAP.md` sections if the feature appears there
- Note connections to `docs/Features.md` entries

## Context Document Structure

Each context doc follows the template at `${CLAUDE_PLUGIN_ROOT}/skills/context-tracker/references/context-template.md`.

Key sections:
- **Overview** — What and why (most important for quick context)
- **Key Files** — File paths with purposes
- **Architecture Decisions** — Decision records with context, choice, and rationale
- **How It Works** — Step-by-step technical flow
- **Related Docs** — Links to PRDs, plans, roadmap

## Update Modes

**Append mode** (default): Add new entries to existing sections without removing or modifying previous content. Use for iterative development where the feature grows over time.

**Rewrite mode**: Replace the entire document. Use only when the feature has been fundamentally redesigned. Preserve the original `created` date and note the rewrite in Architecture Decisions.

To determine the mode: if the current work is a continuation or extension, use append. If the conversation explicitly describes a rewrite or redesign of the system, use rewrite.

## Using the Context Summarizer Agent

Dispatch the `context-summarizer` agent via the Task tool for the actual document writing. Provide it with:

- The feature name (kebab-case)
- Whether this is a create or update operation
- Whether to use append or rewrite mode
- A summary of what was planned or implemented
- Any related doc paths (PRDs, plans)

The agent handles reading conversation context, identifying key files, and writing the document.

## Additional Resources

### Reference Files

- **`references/context-template.md`** — Document template with YAML frontmatter structure and INDEX.md format

### Example Files

- **`examples/example-context-doc.md`** — Complete example of a well-written context document for a user authentication feature
