---
name: mcp-improve
description: Log an MCP improvement request and spawn a background agent to implement it
allowed_arguments: "[description of the capability to add]"
---

# MCP Improve Command

Explicitly request an MCP improvement and spawn a background agent to implement it.

## Usage

```
/mcp-improve Add ability to spawn Niagara particle systems
/mcp-improve Fix spawn_actor not returning actor reference
/mcp-improve              # Interactive prompt for description
```

## Execution Steps

### Step 1: Get Description

If no description provided in the command:
```
What MCP capability would you like to add or improve?
Please describe:
- What you want to be able to do
- What currently happens (or doesn't)
- Any specific requirements
```

### Step 2: Log the Request

Append to the MCP improvements log file at:
`Plugins/SadTirePlugins/SadTire_MCP/docs/mcp-improvements.md`

Use this format:
```markdown
### [YYYY-MM-DD HH:MM] - [Short Title]

**Requested by:** User
**Priority:** Medium (adjust based on description)
**Status:** In Progress

**Description:**
[Full description from user]

**Agent ID:** [Will be filled when agent spawns]
```

### Step 3: Spawn Background Agent

Spawn the `mcp-developer` agent in the background with this prompt:

```
Implement the following MCP improvement:

**Description:** [user's description]

**Log Entry Location:** Plugins/SadTirePlugins/SadTire_MCP/docs/mcp-improvements.md

**Instructions:**
1. Analyze existing MCP tools for similar patterns
2. Determine if this requires Python-only or C++ changes
3. Implement the capability
4. Update the log entry with implementation details
5. Compile and verify if possible
6. Update documentation using /update-docs

The user is continuing their main work. This runs in the background.
```

### Step 4: Confirm to User

```
MCP improvement request logged and background agent spawned.

**Request:** [short title]
**Agent ID:** [agent id]

I'll continue with your main task. The agent will update:
- `Plugins/SadTirePlugins/SadTire_MCP/docs/mcp-improvements.md`

You'll be notified when the implementation is complete.
```

### Step 5: Resume Main Conversation

Continue helping the user with their original task using available workarounds.

## Background Agent Configuration

The background agent should be spawned with:
- `subagent_type`: `mcp-developer`
- `run_in_background`: `true`
- Full context about the request

## Example Flow

```
User: /mcp-improve Add get_actor_by_name tool that finds actors by exact name match

Claude: [Logs to mcp-improvements.md]

MCP improvement request logged and background agent spawned.

**Request:** Add get_actor_by_name tool
**Agent ID:** agent_12345

I'll continue with your main task. The agent will update:
- `Plugins/SadTirePlugins/SadTire_MCP/docs/mcp-improvements.md`

You'll be notified when the implementation is complete.

Now, back to what you were working on...
```

## Log File Format

The improvements log should maintain this structure:

```markdown
# MCP Improvement Log

## In Progress
<!-- Currently being worked on by background agents -->

## Pending
<!-- Logged but not yet started -->

## Completed
<!-- Successfully implemented -->

## Deferred Testing
<!-- Implemented but awaiting editor restart for C++ verification -->
```

## Error Handling

If the log file doesn't exist, create it with the initial structure.

If the background agent fails to spawn:
```
Failed to spawn background agent. The improvement request has been logged.
You can retry with `/mcp-improve` or manually implement later.

Log location: Plugins/SadTirePlugins/SadTire_MCP/docs/mcp-improvements.md
```

## Related Commands

- `/mcp-improve-status` - Check status of pending improvements (future enhancement)
- `/mcp-improve-list` - List all improvement requests (future enhancement)
