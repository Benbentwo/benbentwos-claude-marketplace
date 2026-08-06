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
- **clarify-interview plugin** (v0.1.0) - Architectural-triage interview for the design/planning phase
  - `clarifying-interview` skill - auto-triggers on design/planning language; asks one question at a time, prioritizing architecture-changing questions
  - `/interview` command - deliberately start the interview on any topic
  - `UserPromptSubmit` hook - detects planning intent and nudges Claude into the interview
- **decision-maker plugin** (v0.1.0) - Autonomous decision-making during implementation
  - Stop hook - redirects non-destructive, non-architectural mid-build questions into logged decisions instead of stopping to ask
  - `decision-maker` skill - log format, conservative-choice rule, escape hatch, doc-location discovery, plan seeding
  - `/decisions-start` command - create the decision log and arm decide-and-continue
- **concise-tldr plugin** (v0.1.0) - Output style for terse, scannable updates aimed at a reader who steps away mid-session
  - `Concise TLDR` output style - every status or completion report is exactly three labeled bullets (*what changed* / *where we're at* / *what's next*), with a conditional fourth *Lessons learned* bullet that appears only when the work surfaced a real gotcha
  - Sets `keep-coding-instructions: true`, so the style changes how Claude communicates without dropping Claude Code's built-in software-engineering instructions
  - Deliberately omits `force-for-plugin`: the style is opt-in via `/config`, so enabling the plugin never overrides a user's existing `outputStyle`

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
