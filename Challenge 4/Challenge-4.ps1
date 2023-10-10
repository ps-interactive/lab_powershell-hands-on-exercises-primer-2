# Key Step 1: Initialize variables to store directory paths and backup destinations.
$directoriesToBackup = @("C:\Path\To\Directory1", "C:\Path\To\Directory2")  # Replace with your specific directories
$backupDestination = "C:\BackupDestination"  # Replace with your backup destination

# Ensure backup destination exists
if (-not (Test-Path $backupDestination)) {
    New-Item -Path $backupDestination -ItemType Directory
}

# Key Step 4: Maintain a log
$logFile = "$backupDestination\backupLog.txt"

# Key Step 2: Develop logic to iterate through the directories and initiate a backup
foreach ($dir in $directoriesToBackup) {
    try {
        # Generate a unique backup name based on current date and time
        $backupName = (Get-Date -Format "yyyyMMddHHmmss") + "_" + ($dir -replace '[:\\]', '_') + ".zip"
        $backupPath = Join-Path -Path $backupDestination -ChildPath $backupName

        # Key Step 3: Insert error handling
        if (Test-Path $dir) {
            # Use Compress-Archive for backup
            Compress-Archive -Path $dir -DestinationPath $backupPath -ErrorAction Stop
            # Log success
            Add-Content -Path $logFile -Value "[$(Get-Date)] SUCCESS: Backed up $dir to $backupPath."
        } else {
            throw "Directory $dir does not exist."
        }
    } catch {
        # Log any errors
        Add-Content -Path $logFile -Value "[$(Get-Date)] ERROR: Failed to backup $dir. Reason: $($_.Exception.Message)"
    }
}
