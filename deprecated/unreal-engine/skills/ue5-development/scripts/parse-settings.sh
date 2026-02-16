#!/bin/bash
# parse-settings.sh - Read user configuration from .claude/unreal-engine.local.md
# Usage: source parse-settings.sh
# Sets: UE_ENGINE_PATH, UE_BUILD_CONFIG, UE_PLATFORM

SETTINGS_FILE=".claude/unreal-engine.local.md"

# Default values
UE_BUILD_CONFIG="Development"
UE_PLATFORM=""  # Will be auto-detected if not set

# Parse settings if file exists
if [ -f "$SETTINGS_FILE" ]; then
    # Extract YAML frontmatter values
    # File format:
    # ---
    # engine_path: /path/to/engine
    # build_config: Development
    # platform: Mac
    # ---

    # Check if file has frontmatter
    if head -1 "$SETTINGS_FILE" | grep -q "^---"; then
        # Extract frontmatter (between first and second ---)
        frontmatter=$(sed -n '2,/^---$/p' "$SETTINGS_FILE" | sed '$d')

        # Parse engine_path
        engine_path=$(echo "$frontmatter" | grep "^engine_path:" | cut -d: -f2- | sed 's/^ *//' | sed 's/ *$//')
        if [ -n "$engine_path" ]; then
            UE_ENGINE_PATH="$engine_path"
        fi

        # Parse build_config
        build_config=$(echo "$frontmatter" | grep "^build_config:" | cut -d: -f2- | sed 's/^ *//' | sed 's/ *$//')
        if [ -n "$build_config" ]; then
            UE_BUILD_CONFIG="$build_config"
        fi

        # Parse platform
        platform=$(echo "$frontmatter" | grep "^platform:" | cut -d: -f2- | sed 's/^ *//' | sed 's/ *$//')
        if [ -n "$platform" ]; then
            UE_PLATFORM="$platform"
        fi
    fi
fi

# Auto-detect platform if not configured
if [ -z "$UE_PLATFORM" ]; then
    case "$(uname -s)" in
        Darwin)  UE_PLATFORM="Mac" ;;
        Linux)   UE_PLATFORM="Linux" ;;
        MINGW*|CYGWIN*|MSYS*) UE_PLATFORM="Win64" ;;
        *)       UE_PLATFORM="Unknown" ;;
    esac
fi

# Output for non-sourced usage
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    echo "UE_ENGINE_PATH=${UE_ENGINE_PATH:-<not set>}"
    echo "UE_BUILD_CONFIG=$UE_BUILD_CONFIG"
    echo "UE_PLATFORM=$UE_PLATFORM"
fi

# Export for sourcing
export UE_ENGINE_PATH UE_BUILD_CONFIG UE_PLATFORM
