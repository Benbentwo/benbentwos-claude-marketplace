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

### uem (Unreal Editor Manager)

Wraps the [ue5 CLI](https://github.com/Benbentwo/ue5) server daemon for AI-driven UE5 development.

#### Editor Lifecycle
- **Managed Instances**: Start and stop Unreal Editor via the server daemon with automatic log capture
- **Graceful Shutdown**: SIGTERM with fallback to SIGKILL, per-project instance control

#### AI-Driven Rebuilds
- **Build Orchestrator**: Atomic stop-build-restart cycles with descriptive labels and metadata tracking
- **Build Modes**: Full rebuild (header changes) or hot reload (.cpp-only changes)
- **Multi-Agent Coalescing**: Multiple rebuild requests merged into a single UBT build automatically

#### Log Analysis
- **Captured Logs**: All editor stdout/stderr captured and queryable
- **Powerful Filtering**: By level, category, regex pattern, and time range
- **Streaming**: Real-time log streaming with `--follow` mode

#### MCP Integration
- **SSE Server**: Push notifications on port 9515 for editor state changes and build events
- **Agent Registration**: Track connected AI agent consumers
- **MCP Tools**: Rebuild, register/unregister agents, query build info

#### Development Assistant Agent
- **Autonomous Build Cycles**: Manages build-test-debug workflow
- **Error Pattern Recognition**: Identifies compile errors, blueprint errors, assertions, crashes
- **Build Mode Selection**: Automatically chooses full vs hot_reload based on changed files
