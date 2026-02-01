---
name: rebuild
description: Stop editor, rebuild the project, and restart editor
argument-hint: "[config]"
allowed-tools:
  - Bash
  - Read
  - Glob
---

# Rebuild UE5 Project

Perform a complete rebuild cycle: stop the running editor, build the project, and restart the editor.

## Arguments

- `config` (optional): Build configuration - Development (default), DebugGame, Shipping, Test

## Process

1. **Stop the editor**
   - Gracefully terminate UnrealEditor
   - Wait for clean shutdown (up to 5 seconds)
   - Force kill if needed

2. **Find project and engine**
   - Locate `.uproject` file
   - Extract project name
   - Find engine installation

3. **Build the project**
   - Construct UnrealBuildTool command
   - Build `[ProjectName]Editor` target
   - Use configured or default configuration
   - Stream build output

4. **Check build result**
   - If successful: proceed to start
   - If failed: display error summary, do NOT start editor

5. **Start the editor**
   - Launch editor with project
   - Run in background

6. **Report status**
   - Summary of rebuild process
   - Any warnings or errors encountered

## Build Command Structure

### macOS
```bash
"$ENGINE_PATH/Engine/Build/BatchFiles/Mac/Build.sh" \
    "${PROJECT_NAME}Editor" Mac Development \
    -Project="$PROJECT_PATH" \
    -WaitMutex
```

### Windows
```powershell
& "$ENGINE_PATH\Engine\Build\BatchFiles\Build.bat" `
    "${PROJECT_NAME}Editor" Win64 Development `
    -Project="$PROJECT_PATH" `
    -WaitMutex
```

### Linux
```bash
"$ENGINE_PATH/Engine/Build/BatchFiles/Linux/Build.sh" \
    "${PROJECT_NAME}Editor" Linux Development \
    -Project="$PROJECT_PATH" \
    -WaitMutex
```

## Build Configurations

| Config | Use Case |
|--------|----------|
| `Development` | Default, good for iteration |
| `DebugGame` | Deep debugging with symbols |
| `Shipping` | Release build, optimized |
| `Test` | Testing builds |

## Important Notes

- The full cycle takes time - builds can be several minutes
- If build fails, editor will NOT be started
- Check build output for compilation errors
- Use `-Clean` flag (add to command) for full rebuild from scratch
- After build failure, fix code and run `/ue:rebuild` again
