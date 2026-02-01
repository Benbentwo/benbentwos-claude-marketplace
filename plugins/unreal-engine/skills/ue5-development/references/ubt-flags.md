# UnrealBuildTool Command-Line Reference

Complete reference for UBT command-line arguments and flags.

## Basic Syntax

```bash
# Unix (macOS/Linux)
Engine/Build/BatchFiles/[Platform]/Build.sh <Target> <Platform> <Configuration> [Options]

# Windows
Engine\Build\BatchFiles\Build.bat <Target> <Platform> <Configuration> [Options]
```

## Required Arguments

### Target

The build target, typically `[ProjectName]Editor` or `[ProjectName]`:

| Target Suffix | Description |
|---------------|-------------|
| `Editor` | Editor build (e.g., `MyGameEditor`) |
| (none) | Standalone game |
| `Client` | Multiplayer client |
| `Server` | Dedicated server |

### Platform

| Platform | Description |
|----------|-------------|
| `Win64` | Windows 64-bit |
| `Mac` | macOS |
| `Linux` | Linux |
| `Android` | Android mobile |
| `IOS` | iOS mobile |

### Configuration

| Config | Optimizations | Debug Info | Use Case |
|--------|---------------|------------|----------|
| `Debug` | None | Full | Deep debugging |
| `DebugGame` | Engine optimized | Game debug | Game debugging |
| `Development` | Partial | Yes | Default development |
| `Shipping` | Full | No | Release builds |
| `Test` | Full | Minimal | Testing |

## Common Options

### Project Options

| Flag | Description |
|------|-------------|
| `-Project=<path>` | Path to .uproject file (required for projects) |
| `-TargetType=<type>` | Override target type |

### Build Control

| Flag | Description |
|------|-------------|
| `-Clean` | Clean before building |
| `-Build` | Build (default) |
| `-Rebuild` | Clean + Build |
| `-SkipBuild` | Generate project files only |

### Parallelization

| Flag | Description |
|------|-------------|
| `-NoParallelExecutor` | Disable parallel compilation |
| `-MaxParallelActions=N` | Limit parallel compile jobs |
| `-SingleFile=<file>` | Compile single file only |

### Output Control

| Flag | Description |
|------|-------------|
| `-Verbose` | Detailed output |
| `-VeryVerbose` | Maximum verbosity |
| `-NoLog` | Suppress log file |
| `-Log=<path>` | Custom log path |

### Compilation Options

| Flag | Description |
|------|-------------|
| `-DisableUnity` | Disable unity builds (slower, better errors) |
| `-ForceUnity` | Force unity builds |
| `-NoPCH` | Disable precompiled headers |
| `-Precompile` | Precompile only |

### Linking Options

| Flag | Description |
|------|-------------|
| `-NoLink` | Compile only, don't link |
| `-ForceLink` | Force re-link |

### Code Analysis

| Flag | Description |
|------|-------------|
| `-StaticAnalyzer` | Run static analysis |
| `-ClangSanitizer=<type>` | Enable sanitizer (Address, Thread, etc.) |

## Advanced Options

### Distributed Building

| Flag | Description |
|------|-------------|
| `-NoFASTBuild` | Disable FASTBuild |
| `-NoXGE` | Disable IncrediBuild/XGE |
| `-NoSNDBS` | Disable SN-DBS |

### Module Control

| Flag | Description |
|------|-------------|
| `-Module=<name>` | Build specific module only |
| `-Plugin=<name>` | Build specific plugin |
| `-IgnoreJunk` | Skip validation of module files |

### Hot Reload / Live Coding

| Flag | Description |
|------|-------------|
| `-LiveCoding` | Enable live coding support |
| `-NoLiveCoding` | Disable live coding |
| `-LiveCodingModules=<list>` | Specific modules for live coding |

### Platform-Specific

**iOS/Mac:**
| Flag | Description |
|------|-------------|
| `-SigningIdentity=<id>` | Code signing identity |
| `-ProvisioningProfile=<profile>` | Provisioning profile |

**Android:**
| Flag | Description |
|------|-------------|
| `-Architectures=<arch>` | Target architectures (arm64, x86_64) |
| `-GPUArchitectures=<gpu>` | GPU targets |

### Debugging UBT Itself

| Flag | Description |
|------|-------------|
| `-WaitMutex` | Wait for other UBT instances |
| `-NoMutex` | Don't use mutex |
| `-Trace` | Generate trace data |
| `-TraceFile=<path>` | Custom trace output |

## Common Recipes

### Standard Development Build

```bash
./Build.sh MyGameEditor Mac Development -Project="/path/to/MyGame.uproject"
```

### Clean Rebuild

```bash
./Build.sh MyGameEditor Mac Development -Project="/path/to/MyGame.uproject" -Clean
```

### Verbose Build (for debugging build issues)

```bash
./Build.sh MyGameEditor Mac Development \
    -Project="/path/to/MyGame.uproject" \
    -Verbose \
    -DisableUnity
```

### Single Module Rebuild

```bash
./Build.sh MyGameEditor Mac Development \
    -Project="/path/to/MyGame.uproject" \
    -Module=MyModule
```

### Shipping Build

```bash
./Build.sh MyGame Mac Shipping \
    -Project="/path/to/MyGame.uproject" \
    -Distribution
```

### Debug with Sanitizers

```bash
./Build.sh MyGameEditor Mac Development \
    -Project="/path/to/MyGame.uproject" \
    -ClangSanitizer=Address
```

### Fast Iteration (Live Coding)

```bash
./Build.sh MyGameEditor Mac Development \
    -Project="/path/to/MyGame.uproject" \
    -LiveCoding
```

## Environment Variables

| Variable | Description |
|----------|-------------|
| `UE_ROOT` | Engine root directory |
| `UBT_OPTIONS` | Default options |
| `UBT_NO_MUTEX` | Skip mutex by default |

## Exit Codes

| Code | Meaning |
|------|---------|
| 0 | Success |
| 1 | Build failed |
| 2 | Unknown target |
| 3 | Unknown platform |
| 4 | Unknown configuration |
| 5 | Invalid project |
| 6 | Compilation error |
| 7 | Link error |

## Troubleshooting

### Build Takes Forever

Try:
- `-DisableUnity` to find problematic files
- `-MaxParallelActions=4` if running out of memory
- Check for antivirus scanning build files

### Weird Errors After Code Changes

Try:
- `-Clean` to remove stale objects
- Delete `Intermediate/` folder
- Delete `Binaries/` folder

### Can't Find Target

Check:
- Target name matches `.Target.cs` file
- Module is listed in project's `.Build.cs`
- No syntax errors in build scripts

### Module Not Compiling

Verify:
- Module listed in project `PublicDependencyModuleNames` or `PrivateDependencyModuleNames`
- No circular dependencies
- `.Build.cs` file exists and is valid
