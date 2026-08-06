---
description: Update an existing PRD (requirements, status, or implementation progress)
argument-hint: "[prd-name]"
allowed-tools: Read, Write, Edit, Glob, Grep
---

# Update an Existing PRD

Modify a Product Requirements Document — update requirements, change status, or record implementation progress.

## Step 1: Find the PRD

If `$ARGUMENTS` is provided:
- Search `docs/prds/` for a file matching `$ARGUMENTS` (try exact match, then partial match, then fuzzy match on the title frontmatter field).
- If multiple matches found, present them and ask the user to choose.
- If no match found, list available PRDs and ask which one to update.

If `$ARGUMENTS` is NOT provided:
- Read `docs/prds/INDEX.md` (or scan the folder if no index).
- Present the list of PRDs.
- Ask the user which PRD to update.

## Step 2: Present Current State

Read the selected PRD and display:
- Current status
- A summary of requirements (how many total, how many checked off)
- Implementation status table if present

Ask: "What would you like to update?" Offer options:
1. **Requirements** — add, remove, or modify requirements
2. **Status** — change the PRD status (draft → review → approved → in-progress → implemented)
3. **Implementation progress** — update the Implementation Status table
4. **Other sections** — modify overview, user goals, design decisions, etc.

## Step 3: Apply Updates

Based on the user's choice:

**Requirements updates:**
- Show current requirements.
- Apply additions, removals, or modifications.
- Ensure each requirement remains specific and testable.

**Status changes:**
- Validate the transition makes sense (e.g., don't go from `draft` directly to `implemented`).
- If setting to `implemented`, verify all requirements have been addressed in the Implementation Status table.
- Warn if setting to `approved` but acceptance criteria are missing or vague.

**Implementation progress:**
- Read the Implementation Status table.
- For each requirement, ask or determine the current status: Not Started, In Progress, Complete.
- Update the table with status and any relevant notes.

**Other sections:**
- Present the current content of the section.
- Apply the requested changes.

## Step 4: Finalize

1. Update the `updated` date in the frontmatter.
2. Write the modified PRD back to the file.
3. Sync `docs/prds/INDEX.md` to reflect any status changes.
4. Show the user what changed.

## Automatic Update Triggers

This command may be invoked automatically by the `prd-tracker` skill when:
- A plan is generated for a PRD (status → `in-progress`)
- Implementation on a PRD-related plan begins (update Implementation Status)
- Development work is completed (update Implementation Status, possibly status → `implemented`)

When triggered automatically, apply the relevant updates without requiring user interaction for routine status changes, but always report what was updated.
