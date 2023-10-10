# Key Step 2: Store this information in variables for further processing.
# Key Step 5: Define variables for acceptable and critical CPU usage thresholds.
$acceptableThreshold = 70  # e.g., 70%. Adjust as needed.
$criticalThreshold = 90    # e.g., 90%. Adjust as needed.
$logFile = "C:\Path\To\LogFile.txt"  # Define the path to your log file

# Key Step 3: Design a script to fetch and log CPU metrics at regular intervals.
# Key Step 4: Utilize PowerShell's built-in logging functions.
# Key Step 6: Implement logic.
function LogCpuUsage {
    # Key Step 1: Retrieve real-time CPU usage data.
    $cpuLoad = Get-Counter '\Processor(_Total)\% Processor Time' | ForEach-Object { $_.CounterSamples.CookedValue }
    
    # Log the CPU usage
    Add-Content -Path $logFile -Value "[$(Get-Date)] CPU Load: $cpuLoad%"

    # Compare against thresholds
    if ($cpuLoad -gt $criticalThreshold) {
        Add-Content -Path $logFile -Value "[$(Get-Date)] ALERT: CPU Load is CRITICAL at $cpuLoad%."
    } elseif ($cpuLoad -gt $acceptableThreshold) {
        Add-Content -Path $logFile -Value "[$(Get-Date)] WARNING: CPU Load is HIGH at $cpuLoad%."
    }
}

# Key Step 7: Run the developed script to monitor CPU usage.
$intervalInSeconds = 10  # Adjust the monitoring interval as needed

while ($true) {
    LogCpuUsage
    Start-Sleep -Seconds $intervalInSeconds
}
