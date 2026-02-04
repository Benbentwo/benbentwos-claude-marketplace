#!/bin/bash
# detect-mcp-failure.sh - PostToolUse hook to detect MCP tool failures
# Monitors MCP tool responses for errors and offers to spawn improvement agent

set -euo pipefail

# Read JSON input from stdin
INPUT=$(cat)

# Extract relevant fields using jq
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // "unknown"')
TOOL_RESPONSE=$(echo "$INPUT" | jq -r '.tool_response // "{}"')
TOOL_INPUT=$(echo "$INPUT" | jq -c '.tool_input // {}')
CWD=$(echo "$INPUT" | jq -r '.cwd // "."')

# Check for various error patterns in the response
# Pattern 1: Explicit error field
ERROR=$(echo "$TOOL_RESPONSE" | jq -r 'if type == "object" then .error // empty else empty end' 2>/dev/null || echo "")

# Pattern 2: Success field set to false
SUCCESS=$(echo "$TOOL_RESPONSE" | jq -r 'if type == "object" then .success // "true" else "true" end' 2>/dev/null || echo "true")

# Pattern 3: Error in string response
ERROR_IN_STRING=""
if echo "$TOOL_RESPONSE" | jq -e 'type == "string"' >/dev/null 2>&1; then
    RESPONSE_STRING=$(echo "$TOOL_RESPONSE" | jq -r '.')
    if echo "$RESPONSE_STRING" | grep -qi "error\|failed\|exception\|not found\|unable to"; then
        ERROR_IN_STRING="$RESPONSE_STRING"
    fi
fi

# Pattern 4: Status field indicates failure
STATUS=$(echo "$TOOL_RESPONSE" | jq -r 'if type == "object" then .status // "ok" else "ok" end' 2>/dev/null || echo "ok")

# Determine if this is a failure
IS_FAILURE="false"
FAILURE_REASON=""

if [[ -n "$ERROR" ]]; then
    IS_FAILURE="true"
    FAILURE_REASON="MCP tool returned error: $ERROR"
elif [[ "$SUCCESS" == "false" ]]; then
    IS_FAILURE="true"
    FAILURE_REASON="MCP tool reported failure (success=false)"
elif [[ -n "$ERROR_IN_STRING" ]]; then
    IS_FAILURE="true"
    FAILURE_REASON="MCP tool response indicates error: ${ERROR_IN_STRING:0:200}"
elif [[ "$STATUS" == "error" || "$STATUS" == "failed" ]]; then
    IS_FAILURE="true"
    FAILURE_REASON="MCP tool status indicates failure: $STATUS"
fi

# If no failure detected, allow the conversation to continue normally
if [[ "$IS_FAILURE" != "true" ]]; then
    exit 0
fi

# Extract short tool name for logging
SHORT_TOOL_NAME=$(echo "$TOOL_NAME" | sed 's/mcp__[^_]*__//')

# Log the failure to a temporary file for potential batch processing
FAILURE_LOG="/tmp/mcp-failures.log"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Append to failure log (create if doesn't exist)
echo "[$TIMESTAMP] $TOOL_NAME - $FAILURE_REASON" >> "$FAILURE_LOG"

# Output JSON response to inject context and suggest improvement
# Using decision: "block" would stop Claude, but we want to inform and suggest
# So we use additionalContext instead
cat << EOF
{
  "hookSpecificOutput": {
    "hookEventName": "PostToolUse",
    "additionalContext": "MCP Tool Failure Detected:\n- Tool: $SHORT_TOOL_NAME\n- Reason: $FAILURE_REASON\n\nYou may want to:\n1. Try an alternative approach for this operation\n2. Use /mcp-improve to log this failure and spawn a background agent to fix it\n\nExample: /mcp-improve Fix $SHORT_TOOL_NAME - $FAILURE_REASON"
  },
  "systemMessage": "MCP tool '$SHORT_TOOL_NAME' failed. Consider using /mcp-improve to fix this."
}
EOF
