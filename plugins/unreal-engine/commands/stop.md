---
name: stop
description: Stop running Unreal Editor instances
allowed-tools:
  - Bash
---

# Stop Unreal Editor

Gracefully stop all running Unreal Editor instances.

## Process

1. **Check for running instances**
   - Look for UnrealEditor processes
   - Report how many instances are running

2. **Attempt graceful shutdown**
   - Send SIGTERM to allow clean shutdown
   - Wait up to 5 seconds for process to exit

3. **Force kill if needed**
   - If process still running after timeout
   - Send SIGKILL to force termination
   - Report forced shutdown to user

4. **Verify shutdown**
   - Confirm no UnrealEditor processes remain
   - Report success

## Platform-Specific Commands

### macOS
```bash
# Graceful shutdown
pkill -TERM UnrealEditor 2>/dev/null

# Check if still running after 5 seconds
sleep 5
if pgrep -x UnrealEditor > /dev/null; then
    pkill -9 UnrealEditor
    echo "Force killed UnrealEditor"
else
    echo "UnrealEditor stopped gracefully"
fi
```

### Windows
```powershell
# Graceful
Stop-Process -Name "UnrealEditor" -ErrorAction SilentlyContinue

# Check and force if needed
Start-Sleep -Seconds 5
if (Get-Process -Name "UnrealEditor" -ErrorAction SilentlyContinue) {
    Stop-Process -Name "UnrealEditor" -Force
    Write-Host "Force killed UnrealEditor"
} else {
    Write-Host "UnrealEditor stopped gracefully"
}
```

### Linux
```bash
pkill -TERM UnrealEditor 2>/dev/null
sleep 5
if pgrep -x UnrealEditor > /dev/null; then
    pkill -9 UnrealEditor
    echo "Force killed UnrealEditor"
else
    echo "UnrealEditor stopped gracefully"
fi
```

## Important Notes

- Graceful shutdown allows editor to save autosave data
- Force kill may lose unsaved work
- This stops ALL UnrealEditor instances, not just the current project
- Wait for full shutdown before rebuilding to avoid file locks
