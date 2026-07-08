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
- **clarify-interview plugin** (v0.1.0) - Architectural-triage interview for the design/planning phase
  - `clarifying-interview` skill - auto-triggers on design/planning language; asks one question at a time, prioritizing architecture-changing questions
  - `/interview` command - deliberately start the interview on any topic
  - `UserPromptSubmit` hook - detects planning intent and nudges Claude into the interview
- **decision-maker plugin** (v0.1.0) - Autonomous decision-making during implementation
  - Stop hook - redirects non-destructive, non-architectural mid-build questions into logged decisions instead of stopping to ask
  - `decision-maker` skill - log format, conservative-choice rule, escape hatch, doc-location discovery, plan seeding
  - `/decisions-start` command - create the decision log and arm decide-and-continue

## [1.0.0] - 2026-02-01

### Added
- Initial marketplace setup with `marketplace.json` configuration
- **feature-changelog plugin** (v1.0.0)
  - `/init-docs` command for creating project documentation scaffolding
  - `/update-docs` command for updating documentation from conversation context
  - `documentation-keeper` skill for automatic documentation guidance during development
  - Support for both root-level and `docs/` directory documentation files
