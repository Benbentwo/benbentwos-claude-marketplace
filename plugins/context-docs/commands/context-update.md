---
description: Update an existing feature context document
argument-hint: [feature-name]
allowed-tools: Read, Write, Edit, Glob, Grep, Task
---

Update an existing feature context document with new information from the current session.

1. **Find the context document**:
   - If `$ARGUMENTS` is provided, look for `docs/context/<argument>.md` (exact match first, then partial/fuzzy match)
   - If no argument, scan `docs/context/` and present available documents for the user to choose
   - If no match found, suggest using `/context <feature-name>` to create a new one

2. **Read the existing document** and present its current state to the user:
   - Show the title and last updated date
   - Summarize current sections (number of key files, architecture decisions, etc.)

3. **Determine update scope** — ask the user what to update:
   - **Key Files** — Add newly created or modified files
   - **Architecture Decisions** — Capture new design choices
   - **How It Works** — Update the technical flow description
   - **Related Docs** — Link new PRDs, plans, or other docs
   - **Full refresh** — Re-analyze and append all sections

4. **Dispatch the context-summarizer agent** via the Task tool to:
   - Read the existing document
   - Analyze the current conversation for new information
   - Append new content to the appropriate sections (append mode)
   - Update the `updated` date in frontmatter
   - Update `docs/context/INDEX.md`

5. **Report changes** to the user: what sections were updated and what was added.
