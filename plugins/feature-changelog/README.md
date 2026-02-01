# feature-changelog

A Claude Code plugin that helps maintain project documentation by guiding Claude to update FEATURES.md and CHANGELOG.md during development tasks.

## Features

- **Automatic guidance**: When FEATURES.md or CHANGELOG.md exists in your project, Claude will update them as part of completing development tasks
- **Manual updates**: Use `/update-docs` to catch up documentation based on current session work
- **Project scaffolding**: Use `/init-docs` to create FEATURES.md and CHANGELOG.md with project-aware content

## Installation

```shell
/plugin install feature-changelog@benbentwos-claude-marketplace
```

## Usage

### Automatic (Skill-based)

When working on any project with FEATURES.md or CHANGELOG.md files, Claude will automatically:
1. Update FEATURES.md with user-facing feature descriptions
2. Update CHANGELOG.md with developer-focused change entries

### Manual Commands

- `/update-docs` - Analyze current conversation and update documentation accordingly
- `/init-docs` - Create FEATURES.md and CHANGELOG.md with project-aware scaffolding

## Documentation Format

### FEATURES.md
Documents features from the **end-user perspective** (player/developer). Format is flexible and matches existing project structure.

### CHANGELOG.md
Follows [Keep a Changelog](https://keepachangelog.com/) format:
- **Added**: New features
- **Changed**: Changes to existing functionality
- **Fixed**: Bug fixes
- **Removed**: Removed features

Each entry includes a brief summary of what changed and why.

## File Detection

The plugin auto-detects documentation files in:
1. `docs/FEATURES.md` and `docs/CHANGELOG.md`
2. Root-level `FEATURES.md` and `CHANGELOG.md`
