# UE5 Error Patterns Reference

Comprehensive guide to interpreting Unreal Engine 5 log messages and error patterns.

## Log Categories

UE5 logs are prefixed with categories. Understanding these helps locate issues:

### Compilation Categories

| Category | Description |
|----------|-------------|
| `LogCompile` | C++ compilation messages |
| `LogLinker` | Linking phase messages |
| `LogBlueprintCompiler` | Blueprint to bytecode |
| `LogShaderCompiler` | Shader compilation |
| `LogHotReload` | Live coding / hot reload |

### Runtime Categories

| Category | Description |
|----------|-------------|
| `LogTemp` | Temporary debug logs (UE_LOG default) |
| `LogActor` | Actor lifecycle |
| `LogPlayerController` | Player input/control |
| `LogPhysics` | Physics simulation |
| `LogNetworking` | Network/replication |
| `LogStreaming` | Asset streaming |
| `LogAudio` | Audio system |
| `LogRendering` | Rendering pipeline |

### Asset Categories

| Category | Description |
|----------|-------------|
| `LogAssetRegistry` | Asset discovery/indexing |
| `LogPackageName` | Package loading |
| `LogUObjectGlobals` | Object creation |
| `LogLoad` | Asset loading |
| `LogSavePackage` | Asset saving |

## Compilation Errors

### C++ Syntax Errors

**Pattern:**
```
LogCompile: Error: /path/to/File.cpp(123): error C2065: 'undeclared identifier'
```

**Diagnosis:**
- Line number in parentheses
- Standard C++ error codes (MSVC: C####, Clang: similar)
- Usually missing include or typo

**Common causes:**
- Missing `#include`
- Typo in variable/function name
- Wrong namespace
- Forward declaration needed

### Linker Errors

**Pattern:**
```
LogLinker: Error: LNK2019: unresolved external symbol "function_name" referenced in function "caller"
```

**Diagnosis:**
- Symbol not found during linking
- Function declared but not defined
- Missing library or module dependency

**Common causes:**
- Forgot to implement declared function
- Missing module in `.Build.cs` dependencies
- `YOURMODULE_API` macro missing on exported class

### Blueprint Compilation Errors

**Pattern:**
```
LogBlueprint: Error: [Blueprint /Game/BP_MyActor] Error: Compile error in Blueprint
LogBlueprint: Error: [Compiler] Node "Event BeginPlay" uses invalid function
```

**Diagnosis:**
- Blueprint asset path in brackets
- Specific node or pin mentioned
- Often caused by C++ base class changes

**Resolution:**
1. Open blueprint in editor
2. Look for nodes with "!" warning icon
3. Reconnect or replace broken nodes
4. Compile in editor

### Shader Errors

**Pattern:**
```
LogShaderCompiler: Error: /Engine/Generated/Material.ush(1234): error: undeclared identifier 'CustomExpression'
```

**Diagnosis:**
- Shader source file path
- Line number in generated code
- Usually custom material expression issue

**Resolution:**
1. Find material with custom expression
2. Check HLSL syntax in custom node
3. Verify input/output pins connected

## Runtime Errors

### Assertion Failures

**Pattern:**
```
Assertion failed: Condition [File:Source/File.cpp] [Line: 123]
```

**Diagnosis:**
- Explicit programmer check failed
- File and line indicate location
- Usually logic error or invalid state

**Common assertions:**
- `check(Pointer)` - Null pointer
- `check(Index < Array.Num())` - Out of bounds
- `checkf(Condition, TEXT("message"))` - With message

### Null Pointer Access

**Pattern:**
```
LogCore: Fatal error: Unhandled Exception: EXCEPTION_ACCESS_VIOLATION reading address 0x0000000000000000
```

**Diagnosis:**
- Reading/writing address 0 = null pointer
- Check stack trace for location
- Find the dereference of null

**Common causes:**
- `GetOwner()` returning null
- Actor not spawned yet
- Component not found
- Cast failed (returns nullptr)

### Ensure Failures

**Pattern:**
```
LogOutputDevice: Error: Ensure condition failed: Condition [File:Source/File.cpp] [Line: 123]
```

**Diagnosis:**
- Like assertion but non-fatal
- Engine continues running
- Should still be fixed

### Garbage Collection Issues

**Pattern:**
```
LogGarbage: Error: GC detected destroyed UObject
LogGarbage: Warning: Object still referenced after GC
```

**Diagnosis:**
- Object destroyed but still referenced
- UPROPERTY() macro missing
- Raw pointer to UObject

**Resolution:**
1. Use `UPROPERTY()` for all UObject pointers
2. Use `TWeakObjectPtr` for optional references
3. Check validity with `IsValid()`

## Asset Errors

### Missing Asset References

**Pattern:**
```
LogLinker: Warning: Can't find file '/Game/Missing/Asset'
LogAssetRegistry: Error: Failed to load asset '/Game/BP_Something.BP_Something_C'
```

**Diagnosis:**
- Asset was deleted or moved
- Reference remains in other asset
- Redirector may be needed

**Resolution:**
1. Use "Fix Up Redirectors" in Content Browser
2. Find referencer: Right-click → Reference Viewer
3. Update or remove broken reference

### Circular Dependencies

**Pattern:**
```
LogBlueprint: Error: Circular dependency detected between BP_A and BP_B
```

**Diagnosis:**
- Two blueprints reference each other
- Cannot determine compile order

**Resolution:**
1. Create interface or base class
2. One BP implements, other references interface
3. Use soft object references

### Package Corruption

**Pattern:**
```
LogPackageName: Error: Package '/Game/Corrupted' has invalid format
LogSerialization: Error: Bad name index -1 in package
```

**Diagnosis:**
- Asset file is corrupted
- Version mismatch
- Binary incompatibility

**Resolution:**
1. Check source control for good version
2. Re-import from source (FBX, texture, etc.)
3. As last resort: delete and recreate

## Network/Replication Errors

**Pattern:**
```
LogNet: Warning: Property X not found for replication
LogNet: Error: RPC function Y called on non-authority
```

**Diagnosis:**
- Replication setup incorrect
- Authority/client mismatch
- Property not marked for replication

**Resolution:**
1. Check `UPROPERTY(Replicated)`
2. Verify `GetLifetimeReplicatedProps()`
3. Check server/client authority

## Hot Reload / Live Coding Issues

**Pattern:**
```
LogHotReload: Warning: HotReload failed: Class layout changed
LogLiveCoding: Error: Cannot patch function - ABI incompatible
```

**Diagnosis:**
- Header change requires full restart
- Function signature changed
- Class size changed (added/removed UPROPERTY)

**Resolution:**
1. Close editor
2. Full rebuild
3. Restart editor

## Debugging Strategy

### For Compilation Errors

1. Read the **first** error (later ones may be cascading)
2. Note file and line number
3. Check for missing includes
4. Verify all types are declared

### For Runtime Crashes

1. Get the **call stack** from crash reporter
2. Find the **first project file** in stack (skip engine)
3. Check that line for null access or assertions
4. Add validity checks

### For Asset Errors

1. Use **Reference Viewer** to find connections
2. Check **Message Log** in editor for details
3. Validate assets: Content Browser → Validate

### For Intermittent Issues

1. Enable **verbose logging**: `-LogCmds="LogCategory Verbose"`
2. Check **timing issues** (BeginPlay order, async loads)
3. Verify **initialization order** (constructors vs BeginPlay)
