#!/bin/bash
info=$(powershell -NoProfile -Command '
  $cpu = (Get-CimInstance Win32_Processor).LoadPercentage
  $os = Get-CimInstance Win32_OperatingSystem
  $mem = [math]::Round(($os.TotalVisibleMemorySize - $os.FreePhysicalMemory) / $os.TotalVisibleMemorySize * 100)
  "$cpu $mem"
' 2>/dev/null)
cpu=$(echo "$info" | tail -1 | awk '{print $1}')
mem=$(echo "$info" | tail -1 | awk '{print $2}')
echo "󰍛 ${cpu:-?}% 󰘚 ${mem:-?}%"
