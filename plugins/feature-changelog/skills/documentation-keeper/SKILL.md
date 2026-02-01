---
name: Documentation Keeper
description: Activates when the project contains FEATURES.md or CHANGELOG.md files. Guides documentation updates during development tasks including "implement feature", "add functionality", "fix bug", "refactor code", "update docs", "add to changelog", or "document changes". Ensures FEATURES.md captures user-facing capabilities and CHANGELOG.md tracks developer-focused changes with Keep a Changelog format.
---

# Documentation Keeper

Maintain project documentation by updating FEATURES.md and CHANGELOG.md as part of completing development tasks. Documentation is not a separate step—it integrates into the natural flow of implementation work.

## When This Skill Applies

This skill activates when the project contains:
- `FEATURES.md` or `docs/FEATURES.md`
- `CHANGELOG.md` or `docs/CHANGELOG.md`

Check for these files at session start or when beginning significant work.

## Core Principle

**Documentation happens during task completion, not after.** When implementing a feature or fix, updating the relevant documentation is part of "done."

## File Detection

Locate documentation files using this priority:

1. `docs/FEATURES.md` and `docs/CHANGELOG.md` (preferred)
2. Root-level `FEATURES.md` and `CHANGELOG.md`

If both locations exist, prefer the `docs/` versions.

## FEATURES.md Guidelines

### Purpose
Document features from the **end-user perspective**. Focus on what users (players, developers, API consumers) can do, not implementation details.

### Format
Match the existing structure of the file. Common patterns:
- Category-based with headers (Skills, UI, Combat, etc.)
- Flat bullet list
- Hierarchical with sub-features

### Writing Style
- Use active voice describing user capabilities
- Focus on outcomes, not implementation
- Be concise but complete

### When to Update
Update FEATURES.md when:
- Adding new user-facing functionality
- Significantly changing existing feature behavior
- Removing features (mark as removed or delete entry)

Do NOT update for:
- Internal refactoring
- Bug fixes (unless they enable new capabilities)
- Performance improvements (unless user-noticeable)

### Example Entries
```markdown
## Skills System
- **Skill Slots**: Players can equip up to 4 active skills
- **Cooldown Display**: Visual cooldown indicators on skill bar
- **Skill Leveling**: Skills gain XP through use and can be upgraded

## Combat
- **Targeting System**: Tab-targeting with soft-lock option
- **Damage Numbers**: Floating damage numbers with critical hit highlighting
```

## CHANGELOG.md Guidelines

### Purpose
Document changes from the **developer perspective**. Track what changed, when, and why.

### Format
Follow [Keep a Changelog](https://keepachangelog.com/) conventions:

```markdown
# Changelog

## [Unreleased]

### Added
- New feature description - brief explanation of why

### Changed
- What changed - reason for the change

### Fixed
- Bug that was fixed - what was wrong

### Removed
- What was removed - why it was removed
```

### Writing Style
- Start entries with what changed
- Include brief context on why (1 sentence max)
- Use past tense
- Reference issue/PR numbers if available

### When to Update
Update CHANGELOG.md for:
- Any code change that affects behavior
- Bug fixes
- Refactoring that changes APIs
- Dependency updates
- Configuration changes

### Version Management
- Add entries under `[Unreleased]` during development
- When releasing, move unreleased items to a versioned section
- Include date in version headers: `## [1.2.0] - 2024-01-15`

### Example Entries
```markdown
## [Unreleased]

### Added
- Skill bar UI component with 4 configurable slots - enables hotkey skill activation
- Cooldown system with visual feedback - players can see remaining cooldown time

### Changed
- Refactored ability execution to use command pattern - improves extensibility
- Updated skill icons to use atlas texture - reduces draw calls

### Fixed
- Skills no longer fire during UI interactions - was consuming input meant for menus
- Cooldown timer precision improved from 0.1s to 0.01s - smoother visual updates
```

## Integration Into Task Flow

### During Feature Implementation

1. **Before coding**: Check if FEATURES.md or CHANGELOG.md exist
2. **While implementing**: Note what user-facing changes occur
3. **After implementation**: Update documentation as final step before considering task complete

### Workflow Example

When asked to "add a health bar to the UI":

1. Implement the health bar component
2. Test functionality
3. Update FEATURES.md:
   ```markdown
   ## UI
   - **Health Bar**: Visual display of player health with smooth animations
   ```
4. Update CHANGELOG.md:
   ```markdown
   ### Added
   - Health bar UI component - displays current/max health with damage flash effect
   ```
5. Task complete

### For Bug Fixes

1. Fix the bug
2. Update CHANGELOG.md under `### Fixed`
3. Only update FEATURES.md if the fix enables new capabilities

### For Refactoring

1. Complete refactoring
2. Update CHANGELOG.md under `### Changed`
3. Do NOT update FEATURES.md (no user-facing change)

## What NOT to Document

Skip documentation updates for:
- Work-in-progress that will change
- Internal helper functions
- Code style changes
- Comment additions
- Test-only changes (unless documenting test features)

## Handling Missing Files

If asked to update documentation but files don't exist:
1. Inform the user documentation files weren't found
2. Suggest using `/init-docs` to create them
3. Continue with the task without documentation updates

## Summary

Documentation is part of task completion:
- **FEATURES.md**: User-facing capabilities (what can users do?)
- **CHANGELOG.md**: Developer-focused changes (what changed and why?)
- Update both as the final step of implementing features
- Match existing file formats
- Skip docs for internal-only changes
