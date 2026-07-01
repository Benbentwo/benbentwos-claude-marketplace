# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/).

## [Unreleased]

### Added
- **prd-management plugin** (v0.2.0) - PRD-driven development with living per-feature specs, status tracking, and impact analysis. **Supersedes `prd-manager`.**
  - `/prd-new`, `/prd-list`, `/prd-update`, `/prd-review` commands (carried forward and reworked from `prd-manager`)
  - `/prd-check` command - impact analysis that matches a change against existing PRDs by subsystem `touches` tags and emits a regression checklist, so new work doesn't silently break existing features
  - `manage-prd` skill with the `draft → review → approved → in-progress → implemented` lifecycle, INDEX status board, and passive implementation-status tracking during development
  - Living-document schema: append-only Edge Cases, Open Questions (resolve-don't-delete), Future Considerations, and Changelog per PRD
  - Auto-capture hooks: self-gating `UserPromptSubmit` feature-request detector and `PostToolUse`/`ExitPlanMode` plan-capture (prompt-based, portable across Windows/macOS)
  - Configurable doc location via `.claude/prd.local.md` (default `docs/prds/`)
- **uem plugin** (v1.0.0) - Unreal Editor Manager wrapping the [ue5 CLI](https://github.com/Benbentwo/ue5) server daemon
  - `/uem:start` command for launching managed editor instances
  - `/uem:stop` command for graceful editor shutdown
  - `/uem:rebuild` command for daemon-orchestrated build cycles with metadata tracking
  - `/uem:logs` command for querying captured editor logs with filtering
  - `/uem:server` command for managing the background daemon
  - `ue5-development` skill documenting server mode architecture, MCP integration, and multi-agent coordination
  - `ue5-dev-assistant` agent for autonomous build-test-debug workflows

### Changed
- **prd-manager** deprecated and moved to `deprecated/prd-manager/`; removed from the marketplace manifest in favor of `prd-management`. Its status lifecycle and INDEX board are preserved in the successor.

## [1.0.0] - 2026-02-01

### Added
- Initial marketplace setup with `marketplace.json` configuration
- **feature-changelog plugin** (v1.0.0)
  - `/init-docs` command for creating project documentation scaffolding
  - `/update-docs` command for updating documentation from conversation context
  - `documentation-keeper` skill for automatic documentation guidance during development
  - Support for both root-level and `docs/` directory documentation files
