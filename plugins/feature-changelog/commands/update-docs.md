---
name: update-docs
description: Analyze the current conversation and update FEATURES.md and CHANGELOG.md based on work completed in this session
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
---

# Update Documentation

Analyze the current conversation to identify completed work and update project documentation accordingly.

## Process

1. **Locate documentation files**
   - Search for `docs/FEATURES.md` or `FEATURES.md`
   - Search for `docs/CHANGELOG.md` or `CHANGELOG.md`
   - If neither exists, inform the user and suggest `/init-docs`

2. **Analyze conversation context**
   - Review what was implemented, changed, or fixed in this session
   - Identify user-facing changes (for FEATURES.md)
   - Identify all code changes (for CHANGELOG.md)

3. **Update FEATURES.md** (if exists and relevant changes occurred)
   - Add entries for new user-facing functionality
   - Update entries for changed functionality
   - Remove entries for removed features
   - Match the existing file's format and style

4. **Update CHANGELOG.md** (if exists)
   - Add entries under `[Unreleased]` section
   - Use appropriate categories: Added, Changed, Fixed, Removed
   - Include brief context on why changes were made
   - Follow Keep a Changelog format

5. **Report what was updated**
   - Summarize changes made to each file
   - Note any work that wasn't documented and why

## Important Notes

- Only document work that is complete and tested
- Match the existing style of each documentation file
- For FEATURES.md: Focus on user outcomes, not implementation
- For CHANGELOG.md: Include the "what" and brief "why"
- If no documentation files exist, suggest creating them with `/init-docs`
