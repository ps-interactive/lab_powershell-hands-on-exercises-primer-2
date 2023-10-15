# Step 1: Define Variables
$acceptableThreshold = 70 
$criticalThreshold = 90
$logFile = "C:\Users\public\Desktop\LAB_FILES\CPULogFile.txt" 

# Step 2: Create the LogFile
New-Item -Path $logFile -ItemType File -Force

# Step 3: Retrieve CPI Usage Data
$cpuLoad = Get-Counter '\Processor(_Total)\% Processor Time' | ForEach-Object { $_.CounterSamples.CookedValue }
$cpuLoad

# Step 4: Retrieve Counter Sets
Get-Counter -ListSet * | Select-Object CounterSetName

# Step 5: Retrieve Counter Paths
Get-Counter -ListSet * | Select-Object Paths

# Step 6: Log CPU Usage Data
Add-Content -Path $logFile -Value "[$(Get-Date)] CPU Load: $cpuLoad%"

# Step 7: Create a Function to Log CPU Usage
function LogCpuUsage {
    $cpuLoad = Get-Counter '\Processor(_Total)\% Processor Time' | ForEach-Object { $_.CounterSamples.CookedValue }
    Add-Content -Path $logFile -Value "[$(Get-Date)] CPU Load: $cpuLoad%"
}

LogCpuUsage


# Step 8: Modify the Function to Compare Against Thresholds
function LogCpuUsage {
    $cpuLoad = Get-Counter '\Processor(_Total)\% Processor Time' | ForEach-Object { $_.CounterSamples.CookedValue }
    Add-Content -Path $logFile -Value "[$(Get-Date)] CPU Load: $cpuLoad%"

    if ($cpuLoad -gt $criticalThreshold) {
        Add-Content -Path $logFile -Value "[$(Get-Date)] ALERT: CPU Load is CRITICAL at $cpuLoad%."
    } elseif ($cpuLoad -gt $acceptableThreshold) {
        Add-Content -Path $logFile -Value "[$(Get-Date)] WARNING: CPU Load is HIGH at $cpuLoad%."
    }
}

LogCpuUsage

# Step 9: Execute the Retrieval of CPU Usage Data, Log the Data, and Compare Against Thresholds, every 10 seconds
while ($true) {
    LogCpuUsage
    Start-Sleep -Seconds 10
}

# Step 10: xecute the Retrieval of CPU Usage Data, Log the Data, and Compare Against Thresholds, every 10 seconds and dssplay the results
while ($true) {
    LogCpuUsage
    Start-Sleep -Seconds 10
    Get-Content -Path $logFile
}
