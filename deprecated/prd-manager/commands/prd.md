---
description: Create a new Product Requirements Document (PRD)
argument-hint: "[feature description]"
allowed-tools: Read, Write, Edit, Glob, Grep, Bash(mkdir:*)
---

# Create a New PRD

Create a Product Requirements Document in `docs/prds/` for a new feature. Follow this process strictly — do not skip steps.

## Step 1: Understand the Feature

If `$ARGUMENTS` is empty or not provided:
- Ask the user: "What feature do you want to create? Describe the problem it solves and who it's for."
- Wait for a response before proceeding.

If `$ARGUMENTS` is provided, use it as the starting point but still ask clarifying questions.

Ask refinement questions **one at a time** to understand:
1. What problem does this solve?
2. Who are the target users?
3. What are the key requirements?
4. What are the acceptance criteria — how do we know it's done?
5. Are there constraints or trade-offs to consider?

Do not ask all questions at once. Ask the most important question first, then follow up based on answers. Stop asking when there is enough information to write a meaningful PRD.

## Step 2: Create the PRD

1. Ensure `docs/prds/` directory exists. Create it if not.
2. Read the PRD template at `${CLAUDE_PLUGIN_ROOT}/skills/prd-tracker/references/prd-template.md` for the standard format.
3. Generate a kebab-case filename from the feature name (e.g., `user-authentication.md`).
4. Check if a PRD with this name already exists. If so, ask the user if they want to update the existing one instead.
5. Write the PRD to `docs/prds/<feature-name>.md` with:
   - YAML frontmatter: title, status set to `draft`, created and updated dates set to today
   - All sections filled in based on the conversation
   - Requirements as checkbox lists
   - Acceptance criteria as checkbox lists

## Step 3: Review and Iterate

Present the full PRD to the user and ask: "Does this PRD capture your requirements? What would you like to change?"

Iterate on feedback until the user is satisfied. Update the PRD file after each round of changes.

## Step 4: Approve the PRD

When the user confirms the PRD is complete:
1. Update the PRD status from `draft` to `approved` in the frontmatter.
2. Update the `updated` date.
3. Sync the INDEX.md file — read `docs/prds/INDEX.md` (create if it doesn't exist) and add or update the entry for this PRD.

## Step 5: Transition to Planning

After approval, check if the `writing-plans` skill is available by looking for it in the active skills list.

**If `writing-plans` skill is available:**
- Inform the user: "The PRD is approved. I'll use the writing-plans skill to create an implementation plan based on this PRD."
- Invoke the writing-plans skill, providing the PRD content as context.

**If `writing-plans` skill is NOT available:**
- Perform lightweight inline planning:
  1. Break the PRD requirements into ordered implementation tasks.
  2. Identify dependencies between tasks.
  3. Present the plan as a numbered list with task descriptions.
  4. Ask the user to approve the plan before proceeding.

After the plan is created or approved:
1. Update the PRD status to `in-progress`.
2. Update the `updated` date.
3. Sync INDEX.md.

## Important Notes

- Always read existing PRDs before creating new ones to avoid duplicates.
- Keep PRD language clear and specific — avoid vague requirements.
- Each requirement should be independently testable.
- Acceptance criteria must be concrete and verifiable.
