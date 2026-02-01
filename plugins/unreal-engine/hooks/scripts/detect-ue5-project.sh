#!/bin/bash
# detect-ue5-project.sh - SessionStart hook to detect UE5 projects
# Outputs context message if .uproject file is found

set -euo pipefail

# Find .uproject file in current directory tree
PROJECT_FILE=$(find . -maxdepth 3 -name "*.uproject" 2>/dev/null | head -1)

if [ -z "$PROJECT_FILE" ]; then
    # No UE5 project found, exit silently
    exit 0
fi

PROJECT_NAME=$(basename "$PROJECT_FILE" .uproject)
PROJECT_DIR=$(dirname "$PROJECT_FILE")

# Check for user settings
SETTINGS_FILE=".claude/unreal-engine.local.md"
HAS_SETTINGS="no"
if [ -f "$SETTINGS_FILE" ]; then
    HAS_SETTINGS="yes"
fi

# Detect platform
case "$(uname -s)" in
    Darwin)  PLATFORM="macOS" ;;
    Linux)   PLATFORM="Linux" ;;
    MINGW*|CYGWIN*|MSYS*) PLATFORM="Windows" ;;
    *)       PLATFORM="Unknown" ;;
esac

# Check for logs directory
LOGS_DIR="$PROJECT_DIR/Saved/Logs"
HAS_LOGS="no"
if [ -d "$LOGS_DIR" ]; then
    HAS_LOGS="yes"
fi

# Output context for Claude
cat << EOF
{
  "continue": true,
  "systemMessage": "UE5 Project Detected: $PROJECT_NAME

Project file: $PROJECT_FILE
Platform: $PLATFORM
Logs available: $HAS_LOGS
Custom settings: $HAS_SETTINGS

Available commands:
- /ue:start - Start Unreal Editor with this project
- /ue:stop - Stop running editor instances
- /ue:logs - View and tail log files
- /ue:rebuild - Full rebuild cycle (stop → build → start)

The ue5-dev-assistant agent is available for managing build-test-debug cycles during feature development.

Log locations:
- Project logs: $PROJECT_DIR/Saved/Logs/
- Crash reports: $PROJECT_DIR/Saved/Crashes/"
}
EOF
