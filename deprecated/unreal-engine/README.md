# Unreal Engine Plugin for Claude Code

Helps Claude work effectively with Unreal Engine 5 projects by providing engine control, log analysis, and development workflow assistance.

## Features

- **Engine Control**: Start, stop, and rebuild UE5 editor via commands
- **Log Intelligence**: Knows where logs are on all platforms, can tail and analyze them
- **Development Workflow**: Manages the stop → rebuild → start cycle during feature development
- **Cross-Platform**: Supports macOS, Windows, and Linux

## Installation

```shell
/plugin install unreal-engine@benbentwos-claude-marketplace
```

## Commands

| Command | Description |
|---------|-------------|
| `/ue:start` | Start Unreal Editor with current project |
| `/ue:stop` | Stop running Unreal Editor instances |
| `/ue:logs` | View and tail UE5 log files |
| `/ue:rebuild` | Full rebuild cycle: stop → build → start |

## Configuration

Create `.claude/unreal-engine.local.md` in your project to customize settings:

```yaml
---
engine_path: /path/to/UE_5.x
build_config: Development
platform: Mac
---
```

### Settings

| Setting | Default | Description |
|---------|---------|-------------|
| `engine_path` | Auto-detected | Path to Unreal Engine installation |
| `build_config` | Development | Build configuration (Development, Shipping, DebugGame) |
| `platform` | Auto-detected | Target platform (Mac, Win64, Linux) |

## Default Engine Paths

The plugin looks for UE5 in standard installation locations:

- **macOS**: `/Users/Shared/Epic Games/UE_5.x`
- **Windows**: `C:\Program Files\Epic Games\UE_5.x`
- **Linux**: `~/UnrealEngine` or `/opt/UnrealEngine`

## Log Locations

The plugin knows where to find UE5 logs:

- **Project logs**: `[Project]/Saved/Logs/`
- **Editor logs (macOS)**: `~/Library/Logs/Unreal Engine/`
- **Editor logs (Windows)**: `%LOCALAPPDATA%/UnrealEngine/`
- **Editor logs (Linux)**: `~/.config/unrealengine/`

## Components

- **Skill**: `ue5-development` - Automatic knowledge about UE5 development
- **Agent**: `ue5-dev-assistant` - Autonomous debugging and workflow assistance
- **Hook**: SessionStart detection for UE5 projects
