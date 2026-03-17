#!/bin/bash
# sysinfo.sh — CPU/MEM status bar widget (cross-platform)

case "$(uname -s)" in
  Darwin)
    cpu=$(top -l 1 -n 0 2>/dev/null | awk '/CPU usage/{printf "%.0f", $3}')
    mem=$(memory_pressure 2>/dev/null | awk '/percentage/{printf "%.0f", $5}')
    ;;
  Linux)
    cpu=$(awk '/^cpu /{u=$2+$4; t=$2+$4+$5; if(t>0) printf "%.0f", u/t*100}' /proc/stat 2>/dev/null)
    mem=$(awk '/MemTotal/{t=$2} /MemAvailable/{a=$2} END{if(t>0) printf "%.0f", (t-a)/t*100}' /proc/meminfo 2>/dev/null)
    ;;
  *) # Windows (MSYS2 / Git Bash)
    info=$(powershell -NoProfile -Command '
      $cpu = (Get-CimInstance Win32_Processor).LoadPercentage
      $os = Get-CimInstance Win32_OperatingSystem
      $mem = [math]::Round(($os.TotalVisibleMemorySize - $os.FreePhysicalMemory) / $os.TotalVisibleMemorySize * 100)
      "$cpu $mem"
    ' 2>/dev/null)
    cpu=$(echo "$info" | tail -1 | awk '{print $1}')
    mem=$(echo "$info" | tail -1 | awk '{print $2}')
    ;;
esac

echo "󰍛 ${cpu:-?}% 󰘚 ${mem:-?}%"
