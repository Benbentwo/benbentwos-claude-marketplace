# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/).

## [Unreleased]

### Added
- **uem plugin** (v1.0.0) - Unreal Editor Manager wrapping the [ue5 CLI](https://github.com/Benbentwo/ue5) server daemon
  - `/uem:start` command for launching managed editor instances
  - `/uem:stop` command for graceful editor shutdown
  - `/uem:rebuild` command for daemon-orchestrated build cycles with metadata tracking
  - `/uem:logs` command for querying captured editor logs with filtering
  - `/uem:server` command for managing the background daemon
  - `ue5-development` skill documenting server mode architecture, MCP integration, and multi-agent coordination
  - `ue5-dev-assistant` agent for autonomous build-test-debug workflows

## [1.0.0] - 2026-02-01

### Added
- Initial marketplace setup with `marketplace.json` configuration
- **feature-changelog plugin** (v1.0.0)
  - `/init-docs` command for creating project documentation scaffolding
  - `/update-docs` command for updating documentation from conversation context
  - `documentation-keeper` skill for automatic documentation guidance during development
  - Support for both root-level and `docs/` directory documentation files
