# MCP Improver Plugin

Automatically detects, logs, and fixes SadTire MCP limitations in the background while you continue your main work.

## Features

- **Automatic Gap Detection**: Recognizes when MCP tools can't do what you need
- **Background Implementation**: Spawns agents to implement improvements without interrupting your work
- **Failure Detection**: Monitors MCP tool calls for errors and offers fixes
- **Progress Tracking**: Maintains a log of requested and completed improvements

## Components

### Skill: MCP Improvement Detection

Guides Claude to recognize MCP capability gaps during normal conversation and offer to fix them.

**Triggers when:**
- Claude says "I don't have an MCP tool for that"
- Claude attempts workarounds because MCP can't do something
- User asks for functionality that should be possible via MCP

### Command: `/mcp-improve`

Explicitly request an MCP improvement.

```
/mcp-improve Add ability to spawn Niagara particle systems
/mcp-improve Fix spawn_actor not returning actor reference
/mcp-improve    # Interactive prompt
```

### Agent: MCP Developer

Autonomous implementation agent that runs in the background. Handles:
- Python-only changes (immediate testing)
- C++ additions (compile verification, restart for testing)
- Documentation updates
- Git commits

### Hook: MCP Failure Detector

PostToolUse hook that monitors MCP tool calls for failures. When errors are detected, it offers to spawn a background agent to investigate and fix.

## Requirements

- SadTire MCP plugin installed in your Unreal project
- Access to `Plugins/SadTirePlugins/SadTire_MCP/` directory

## Log File Location

Improvements are tracked in:
```
Plugins/SadTirePlugins/SadTire_MCP/docs/mcp-improvements.md
```

## Workflow

1. **Detection**: Plugin detects a capability gap or failure
2. **Offer**: Claude offers to spawn a background agent
3. **Logging**: Request is logged with context and priority
4. **Implementation**: Background agent implements the fix
5. **Verification**: Python changes tested immediately; C++ changes marked for restart
6. **Documentation**: FEATURES.md and CHANGELOG.md updated

## Future Enhancements

- `/mcp-improve-status` - Check status of pending improvements
- `/mcp-improve-list` - List all improvement requests
- Minimal test project for faster C++ testing
- Auto-restart MCP server after Python changes
