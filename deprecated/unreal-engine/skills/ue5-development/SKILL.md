---
name: UE5 Development
description: This skill should be used when the user is working in an Unreal Engine 5 project, mentions "UE5", "Unreal", "blueprints", "UnrealBuildTool", "UBT", asks about "editor logs", "build errors", "crash reports", or when a .uproject file is detected in the working directory. Provides knowledge about engine control, log locations, error patterns, and development workflows.
---

# UE5 Development Skill

Specialized knowledge for working with Unreal Engine 5 projects, including engine lifecycle management, log analysis, and debugging workflows.

## Detecting UE5 Projects

Identify UE5 projects by checking for:
- `.uproject` file in current directory or parent directories
- `Source/` directory with C++ game code
- `Content/` directory with assets
- `Saved/` directory with logs and configs

To find the project file:
```bash
find . -maxdepth 2 -name "*.uproject" 2>/dev/null | head -1
```

## Engine Installation Paths

Default installation locations by platform:

| Platform | Default Path |
|----------|--------------|
| macOS | `/Users/Shared/Epic Games/UE_5.x` |
| Windows | `C:\Program Files\Epic Games\UE_5.x` |
| Linux | `~/UnrealEngine` or `/opt/UnrealEngine` |

To detect the engine path, check for user settings in `.claude/unreal-engine.local.md` first, then fall back to defaults.

## Log File Locations

### Project Logs (Most Important)

Located in `[ProjectRoot]/Saved/Logs/`:
- `[ProjectName].log` - Main editor/game log
- `[ProjectName]-backup-*.log` - Previous session logs

### System Logs by Platform

**macOS:**
- `~/Library/Logs/Unreal Engine/UnrealEditor/`
- `~/Library/Application Support/Epic/UnrealEngine/`

**Windows:**
- `%LOCALAPPDATA%\UnrealEngine\5.x\Saved\Logs\`
- `%APPDATA%\Unreal Engine\`

**Linux:**
- `~/.config/unrealengine/`
- `~/.local/share/unrealengine/`

### Build Logs

UnrealBuildTool output goes to:
- Console output (primary source)
- `[ProjectRoot]/Saved/Logs/UnrealBuildTool/`

## Starting the Editor

### macOS
```bash
# Find the editor binary
EDITOR="/Users/Shared/Epic Games/UE_5.4/Engine/Binaries/Mac/UnrealEditor.app/Contents/MacOS/UnrealEditor"

# Launch with project
"$EDITOR" "/path/to/Project.uproject"
```

### Windows
```powershell
# Launch editor
& "C:\Program Files\Epic Games\UE_5.4\Engine\Binaries\Win64\UnrealEditor.exe" "C:\path\to\Project.uproject"
```

### Linux
```bash
~/UnrealEngine/Engine/Binaries/Linux/UnrealEditor "/path/to/Project.uproject"
```

## Stopping the Editor

### macOS
```bash
# Graceful shutdown
pkill -TERM UnrealEditor

# Force kill if needed (wait 5 seconds first)
pkill -9 UnrealEditor
```

### Windows
```powershell
# Graceful
Stop-Process -Name "UnrealEditor" -ErrorAction SilentlyContinue

# Force
Stop-Process -Name "UnrealEditor" -Force -ErrorAction SilentlyContinue
```

### Linux
```bash
pkill -TERM UnrealEditor
```

## Building with UnrealBuildTool

### Build Command Structure

```bash
# macOS/Linux
"$ENGINE_PATH/Engine/Build/BatchFiles/Mac/Build.sh" \
    [ProjectName][Target] \
    [Platform] \
    [Configuration] \
    -Project="$PROJECT_PATH" \
    -WaitMutex

# Windows
"%ENGINE_PATH%\Engine\Build\BatchFiles\Build.bat" ^
    [ProjectName][Target] ^
    [Platform] ^
    [Configuration] ^
    -Project="%PROJECT_PATH%" ^
    -WaitMutex
```

### Common Targets

| Target | Description |
|--------|-------------|
| `Editor` | Build for editor (e.g., `MyGameEditor`) |
| `Game` | Standalone game build |
| `Client` | Multiplayer client |
| `Server` | Dedicated server |

### Build Configurations

| Config | Use Case |
|--------|----------|
| `Development` | Default, debugging enabled |
| `DebugGame` | Full debugging, slower |
| `Shipping` | Release, optimized |
| `Test` | Testing builds |

### Example Build Commands

```bash
# macOS - Build editor
"/Users/Shared/Epic Games/UE_5.4/Engine/Build/BatchFiles/Mac/Build.sh" \
    MyGameEditor Mac Development \
    -Project="/path/to/MyGame.uproject"

# Rebuild (clean + build)
"/Users/Shared/Epic Games/UE_5.4/Engine/Build/BatchFiles/Mac/Build.sh" \
    MyGameEditor Mac Development \
    -Project="/path/to/MyGame.uproject" \
    -Clean
```

## Reading and Analyzing Logs

### Tail Recent Logs
```bash
# Show last 100 lines and follow
tail -n 100 -f Saved/Logs/*.log
```

### Filter for Errors
```bash
# Show only errors and warnings
grep -E "(Error|Warning|Fatal)" Saved/Logs/*.log
```

### Common Error Patterns

| Pattern | Meaning |
|---------|---------|
| `LogCompile: Error:` | C++ compilation error |
| `LogBlueprint: Error:` | Blueprint compilation error |
| `LogLinker: Warning:` | Asset reference issues |
| `Assertion failed:` | Runtime assertion (crash) |
| `Fatal error:` | Unrecoverable crash |
| `LogShaderCompiler: Error:` | Shader compilation failure |
| `LogAssetRegistry:` | Asset loading issues |
| `LogHotReload:` | Hot reload/Live Coding issues |

### Crash Reports

Located in:
- `[Project]/Saved/Crashes/`
- macOS: `~/Library/Logs/DiagnosticReports/` (look for UnrealEditor*)

Crash logs contain:
- Stack trace
- Loaded modules
- Thread state
- Register values

## Development Workflow

### Standard Build-Test Cycle

1. **Stop editor** - Ensure no locks on files
2. **Build** - Compile changes
3. **Start editor** - Launch with project
4. **Check logs** - Monitor for errors

### Debugging Build Failures

When a build fails:

1. Read the **last 50 lines** of build output
2. Look for `error:` or `Error:` lines
3. Check if it's a:
   - **Compilation error** - Fix C++ code
   - **Linker error** - Check includes/dependencies
   - **Blueprint error** - Fix in editor
4. Search project source for the error location
5. Fix and rebuild

### Debugging Runtime Issues

When the editor crashes or behaves unexpectedly:

1. Check `Saved/Logs/[Project].log` for recent errors
2. Look for `Fatal error` or `Assertion failed`
3. Check crash dumps in `Saved/Crashes/`
4. Correlate with recent code changes

## User Settings

Check for user configuration in `.claude/unreal-engine.local.md`:

```yaml
---
engine_path: /custom/path/to/UE_5.4
build_config: Development
platform: Mac
---
```

Parse with:
```bash
# Extract engine_path
grep "^engine_path:" .claude/unreal-engine.local.md | cut -d: -f2- | tr -d ' '
```

## Platform Detection

Detect current platform for cross-platform commands:

```bash
case "$(uname -s)" in
    Darwin)  PLATFORM="Mac" ;;
    Linux)   PLATFORM="Linux" ;;
    MINGW*|CYGWIN*|MSYS*) PLATFORM="Win64" ;;
    *)       PLATFORM="Unknown" ;;
esac
```

## Additional Resources

### Reference Files

For detailed information, consult:
- **`references/error-patterns.md`** - Comprehensive error pattern guide
- **`references/ubt-flags.md`** - UnrealBuildTool command-line flags

### Scripts

Utility scripts for common operations:
- **`scripts/detect-project.sh`** - Find .uproject and engine path
- **`scripts/parse-settings.sh`** - Read user configuration
