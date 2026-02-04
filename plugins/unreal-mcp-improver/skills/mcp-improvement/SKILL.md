---
name: MCP Improvement Detection
description: This skill activates when Claude recognizes MCP capability gaps during conversation. Triggers when Claude says "I don't have an MCP tool for that", attempts workarounds because MCP can't do something, or when a user asks for functionality that should be possible via MCP but isn't available. Guides detection and offers to spawn background agents for implementation.
---

# MCP Improvement Detection Skill

Guides Claude to recognize MCP capability gaps during normal conversation and offer to fix them autonomously.

## Detection Triggers

This skill activates when you observe:

### 1. Explicit Capability Gaps
- You say "I don't have an MCP tool for that"
- You say "The MCP server doesn't support..."
- You mention "There's no way to do X via MCP"

### 2. Workaround Patterns
- You implement a manual workaround for something MCP should handle
- You ask the user to do something in the editor that could be automated
- You use multiple MCP calls when a single specialized tool would be better

### 3. User Requests for Missing Features
- User asks to do something in Unreal that requires editor access
- User requests automation that doesn't exist
- User mentions a common workflow that should be automated

## Response Protocol

When you detect an MCP gap:

### Step 1: Acknowledge the Gap
```
I notice the SadTire MCP doesn't currently have a tool for [capability].
```

### Step 2: Offer Background Agent
```
I can spawn a background agent to implement this capability while we continue working.
Would you like me to add "[capability name]" to the MCP improvement queue?
```

### Step 3: If User Agrees
Use the `/mcp-improve` command with the capability description:
```
/mcp-improve [capability description]
```

### Step 4: Continue Main Work
Resume the user's original task using available workarounds while the background agent works.

## Gap Classification

When identifying gaps, classify them:

| Classification | Description | Example |
|----------------|-------------|---------|
| **Missing Tool** | Functionality doesn't exist at all | "Spawn Niagara particle systems" |
| **Tool Limitation** | Tool exists but missing parameter/feature | "Set actor material with slot index" |
| **Error Handling** | Tool fails silently or unhelpfully | "spawn_actor returns success but actor not visible" |
| **Performance** | Tool is too slow or requires too many calls | "Getting 100 actors requires 100 separate calls" |
| **Discovery** | Hard to find the right tool | "3 similar tools, unclear which to use" |

## Priority Assessment

Rate gaps by impact:

| Priority | Criteria |
|----------|----------|
| **High** | Blocks user workflow, no workaround |
| **Medium** | Slows down workflow, has workaround |
| **Low** | Minor inconvenience, nice-to-have |

## Documentation Pattern

When logging gaps to `mcp-improvements.md`:

```markdown
### [ISO Date] - [Capability Name]

**Classification:** [Missing Tool | Tool Limitation | etc.]
**Priority:** [High | Medium | Low]
**Trigger:** [What prompted the detection]

**Description:**
[What the tool should do]

**Current Workaround:**
[How we're handling it now, or "None"]

**Status:** Pending
```

## What NOT to Flag

Don't flag these as MCP gaps:
- Things that require runtime game state (PIE mode limitations are known)
- Dangerous operations that shouldn't be automated (delete all assets)
- One-time operations not worth automating
- Features that require significant engine modifications

## Integration with Main Workflow

This skill supplements your main work. You should:

1. **Not interrupt** complex user tasks for every gap
2. **Batch multiple gaps** when possible
3. **Continue working** after spawning background agents
4. **Report completion** when background agents finish

## MCP Architecture Context

When flagging gaps, understand the SadTire MCP structure:

- **Python Server:** `sadtire_mcp_server.py` - Handles most tools
- **C++ Bridge:** `SadTireMCPBridge.cpp` - For operations requiring engine code
- **Python-only changes** can be tested immediately (restart MCP server)
- **C++ changes** require editor restart for testing

## Example Conversation

```
User: Can you spawn a Niagara particle system at the player location?

Claude: I can spawn actors via MCP, but I notice there's no dedicated tool
for spawning Niagara systems with proper parameter configuration. Let me
try using the generic spawn_actor...

[Attempts, but Niagara system lacks activation]

The generic approach works but doesn't activate the system properly.
I notice the SadTire MCP doesn't currently have a specialized tool for
Niagara particle systems.

I can spawn a background agent to add proper Niagara support while we
continue. Would you like me to add "Spawn and configure Niagara particle
systems" to the MCP improvement queue?

User: Yes, please do that.

Claude: /mcp-improve Add ability to spawn Niagara particle systems with activation state and parameter overrides

[Background agent spawned]

In the meantime, let me show you how to manually activate the system
we spawned...
```
