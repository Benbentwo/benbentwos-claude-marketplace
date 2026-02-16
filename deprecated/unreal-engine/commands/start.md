---
name: start
description: Start Unreal Editor with the current project
allowed-tools:
  - Bash
  - Read
  - Glob
---

# Start Unreal Editor

Launch Unreal Editor with the project in the current directory.

## Process

1. **Find the project file**
   - Search for `.uproject` file in current directory and subdirectories
   - If multiple found, use the one closest to current directory
   - If none found, inform user and exit

2. **Check for user settings**
   - Look for `.claude/unreal-engine.local.md`
   - Extract `engine_path` if configured
   - If not configured, use platform defaults

3. **Detect platform and engine**
   - Determine current platform (Mac, Win64, Linux)
   - Locate engine installation:
     - macOS: `/Users/Shared/Epic Games/UE_5.x`
     - Windows: `C:\Program Files\Epic Games\UE_5.x`
     - Linux: `~/UnrealEngine` or `/opt/UnrealEngine`

4. **Launch the editor**
   - Build the launch command for current platform
   - Run in background so command returns immediately
   - Report success with project name

## Platform-Specific Commands

### macOS
```bash
"$ENGINE_PATH/Engine/Binaries/Mac/UnrealEditor.app/Contents/MacOS/UnrealEditor" "$PROJECT_PATH" &
```

### Windows
```powershell
Start-Process "$ENGINE_PATH\Engine\Binaries\Win64\UnrealEditor.exe" -ArgumentList "$PROJECT_PATH"
```

### Linux
```bash
"$ENGINE_PATH/Engine/Binaries/Linux/UnrealEditor" "$PROJECT_PATH" &
```

## Important Notes

- The editor starts in the background - the command returns immediately
- If the editor is already running, this will open another instance
- Use `/ue:stop` first if you need to restart with a clean slate
- Watch `Saved/Logs/` for startup issues
