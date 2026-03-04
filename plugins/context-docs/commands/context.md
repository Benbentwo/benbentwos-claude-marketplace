---
description: Create or update a feature context document
argument-hint: [feature-name]
allowed-tools: Read, Write, Edit, Glob, Grep, Bash(mkdir:*), Task
---

Create or update a feature context document at `docs/context/`.

1. **Determine the feature name**:
   - If `$ARGUMENTS` is provided, use it as the feature name (convert to kebab-case for filename)
   - If no argument, analyze the current conversation to infer the feature being worked on
   - Propose a kebab-case name to the user and confirm before proceeding

2. **Check for existing context doc**:
   - Look for `docs/context/<feature-name>.md`
   - If it exists, this is an update operation (append mode by default)
   - If it does not exist, this is a create operation

3. **Ensure directory structure exists**:
   - Create `docs/context/` if it does not exist

4. **Dispatch the context-summarizer agent** via the Task tool to:
   - Analyze the current conversation for feature knowledge
   - Identify key files, architecture decisions, and technical flow
   - Check for related PRDs in `docs/prds/`, plans in `docs/plans/`, and entries in `docs/ROADMAP.md`
   - Write or update the context document following the template at `${CLAUDE_PLUGIN_ROOT}/skills/context-tracker/references/context-template.md`
   - Update `docs/context/INDEX.md`

5. **Report what was created or updated** to the user with the file path and a summary of captured content.
