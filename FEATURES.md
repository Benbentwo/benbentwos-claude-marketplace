# Benbentwo's Claude Marketplace Features

A personal collection of Claude Code plugins for documentation, development workflows, and productivity.

## Marketplace

- **Easy Installation**: Add the entire marketplace with a single command
- **Local Development Support**: Add plugins from local paths for development and testing
- **Plugin Discovery**: Browse and install individual plugins from the marketplace

## Plugins

### feature-changelog

Helps maintain FEATURES.md and CHANGELOG.md documentation during development tasks.

#### Automatic Documentation Guidance
- **Smart Detection**: Automatically detects when FEATURES.md or CHANGELOG.md exist in your project
- **Context-Aware Updates**: Claude updates documentation as part of completing development tasks
- **Dual Perspective**: FEATURES.md for end-users, CHANGELOG.md for developers

#### Manual Commands
- **`/update-docs`**: Analyze the current conversation and update documentation based on work completed in the session
- **`/init-docs`**: Create FEATURES.md and CHANGELOG.md files with project-aware content by analyzing the existing codebase

#### Documentation Formats
- **FEATURES.md**: User-facing feature descriptions organized by category
- **CHANGELOG.md**: Developer-focused change tracking following [Keep a Changelog](https://keepachangelog.com/) format
