# Benbentwo's Claude Marketplace

Personal collection of Claude Code plugins for documentation, development workflows, and productivity.

## Installation

Add this marketplace to Claude Code:

```shell
/plugin marketplace add Benbentwo/benbentwos-claude-marketplace
```

Or for local development:

```shell
/plugin marketplace add /path/to/benbentwos-claude-marketplace
```

## Available Plugins

### feature-changelog

Helps maintain FEATURES.md and CHANGELOG.md documentation during development tasks.

```shell
/plugin install feature-changelog@benbentwos-claude-marketplace
```

**Features:**
- **Automatic guidance**: When FEATURES.md or CHANGELOG.md exists in your project, Claude will update them as part of completing development tasks
- **Manual updates**: Use `/update-docs` to catch up documentation based on current session work
- **Project scaffolding**: Use `/init-docs` to create FEATURES.md and CHANGELOG.md with project-aware content

### uem (Unreal Editor Manager)

Editor lifecycle management, AI-driven rebuilds, log analysis, and MCP integration for UE5 projects. Wraps the [ue5 CLI](https://github.com/Benbentwo/ue5) server daemon.

```shell
/plugin install uem@benbentwos-claude-marketplace
```

**Features:**
- **Editor control**: `/uem:start`, `/uem:stop` to launch and stop managed editor instances
- **AI-driven rebuilds**: `/uem:rebuild` triggers daemon-orchestrated stop-build-restart with metadata tracking
- **Log intelligence**: `/uem:logs` queries captured logs with filtering by level, category, pattern, and time
- **Server management**: `/uem:server` manages the background daemon
- **Multi-agent coordination**: Automatic build coalescing when multiple agents request rebuilds
- **MCP integration**: Push notifications to connected agents via SSE
- **Development assistant**: Agent for autonomous build-test-debug cycles

### unreal-mcp-improver

Automatically detects, logs, and fixes SadTire MCP limitations in the background while you continue your main work.

```shell
/plugin install unreal-mcp-improver@benbentwos-claude-marketplace
```

**Features:**
- **Gap detection**: Skill that recognizes when MCP tools can't do what you need
- **Background implementation**: `/mcp-improve` command spawns agents to implement improvements without interrupting your work
- **Failure detection**: PostToolUse hook monitors MCP tool calls for errors and offers fixes
- **Progress tracking**: Maintains a log of requested and completed improvements in `SadTire_MCP/docs/mcp-improvements.md`

## Contributing

To add a new plugin:

1. Create a directory under `plugins/`
2. Add a `.claude-plugin/plugin.json` manifest
3. Add your commands, skills, agents, or hooks
4. Update the marketplace.json to include your plugin
5. Run `/plugin validate .` to verify the structure

## License

MIT
