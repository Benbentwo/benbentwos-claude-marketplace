---
name: logs
description: View and tail Unreal Engine log files
argument-hint: "[lines] [--errors]"
allowed-tools:
  - Bash
  - Read
  - Glob
  - Grep
---

# View UE5 Logs

Display recent log output and optionally follow new entries.

## Arguments

- `lines` (optional): Number of recent lines to show (default: 100)
- `--errors`: Filter to show only Error and Warning lines

## Process

1. **Find the project**
   - Locate `.uproject` file
   - Determine project root directory

2. **Find log files**
   - Primary: `[Project]/Saved/Logs/[ProjectName].log`
   - Backup logs: `[Project]/Saved/Logs/[ProjectName]-backup-*.log`
   - System logs based on platform

3. **Display logs**
   - Show the requested number of recent lines
   - If `--errors` flag: filter for Error/Warning only
   - Start tailing for new output

4. **Provide context**
   - Note the log file path being viewed
   - Mention if there are backup logs available

## Log Locations

### Project Logs (Primary)
```
[ProjectRoot]/Saved/Logs/[ProjectName].log
```

### System Logs by Platform

**macOS:**
```
~/Library/Logs/Unreal Engine/UnrealEditor/
```

**Windows:**
```
%LOCALAPPDATA%\UnrealEngine\5.x\Saved\Logs\
```

**Linux:**
```
~/.config/unrealengine/
```

## Example Commands

### Show last 100 lines and follow
```bash
tail -n 100 -f Saved/Logs/*.log
```

### Show only errors
```bash
grep -E "(Error|Warning|Fatal)" Saved/Logs/*.log | tail -n 50
```

### Show recent build output
```bash
tail -n 200 Saved/Logs/*.log | grep -E "(LogCompile|LogLinker|LogBuild)"
```

## Important Notes

- The main log file is overwritten each session
- Backup logs preserve previous sessions
- Use `grep` patterns to filter specific categories
- Log verbosity can be increased with `-LogCmds` startup flag
- Crash logs are in `Saved/Crashes/` directory
