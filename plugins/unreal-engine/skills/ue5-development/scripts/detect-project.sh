#!/bin/bash
# detect-project.sh - Find UE5 project and engine paths
# Usage: source detect-project.sh
# Sets: PROJECT_PATH, PROJECT_NAME, ENGINE_PATH, PLATFORM

set -e

# Detect platform
case "$(uname -s)" in
    Darwin)  PLATFORM="Mac" ;;
    Linux)   PLATFORM="Linux" ;;
    MINGW*|CYGWIN*|MSYS*) PLATFORM="Win64" ;;
    *)       PLATFORM="Unknown" ;;
esac

# Find .uproject file
find_uproject() {
    local dir="$1"
    local max_depth="${2:-3}"

    find "$dir" -maxdepth "$max_depth" -name "*.uproject" 2>/dev/null | head -1
}

# Get project path
PROJECT_PATH=$(find_uproject "$(pwd)")

if [ -z "$PROJECT_PATH" ]; then
    echo "No .uproject file found in current directory tree" >&2
    exit 1
fi

PROJECT_NAME=$(basename "$PROJECT_PATH" .uproject)
PROJECT_DIR=$(dirname "$PROJECT_PATH")

# Check for user settings
SETTINGS_FILE=".claude/unreal-engine.local.md"
if [ -f "$SETTINGS_FILE" ]; then
    ENGINE_PATH=$(grep "^engine_path:" "$SETTINGS_FILE" 2>/dev/null | cut -d: -f2- | tr -d ' ' || true)
fi

# Default engine paths if not configured
if [ -z "$ENGINE_PATH" ]; then
    case "$PLATFORM" in
        Mac)
            # Find latest UE5 version
            ENGINE_PATH=$(ls -d "/Users/Shared/Epic Games/UE_5."* 2>/dev/null | sort -V | tail -1)
            ;;
        Win64)
            ENGINE_PATH=$(ls -d "/c/Program Files/Epic Games/UE_5."* 2>/dev/null | sort -V | tail -1)
            ;;
        Linux)
            if [ -d "$HOME/UnrealEngine" ]; then
                ENGINE_PATH="$HOME/UnrealEngine"
            elif [ -d "/opt/UnrealEngine" ]; then
                ENGINE_PATH="/opt/UnrealEngine"
            fi
            ;;
    esac
fi

# Validate engine path
if [ -z "$ENGINE_PATH" ] || [ ! -d "$ENGINE_PATH" ]; then
    echo "Could not find Unreal Engine installation" >&2
    echo "Set engine_path in .claude/unreal-engine.local.md" >&2
    exit 1
fi

# Output results
echo "PROJECT_PATH=$PROJECT_PATH"
echo "PROJECT_NAME=$PROJECT_NAME"
echo "PROJECT_DIR=$PROJECT_DIR"
echo "ENGINE_PATH=$ENGINE_PATH"
echo "PLATFORM=$PLATFORM"

# Export for sourcing
export PROJECT_PATH PROJECT_NAME PROJECT_DIR ENGINE_PATH PLATFORM
