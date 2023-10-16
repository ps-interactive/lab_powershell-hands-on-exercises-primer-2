# Step 1: Initialize variables to store directory paths and backup destinations.
$directoriesToBackup = @("C:\Users\pslearner\Desktop\PRIVATE_FILES", "C:\Users\pslearner\Desktop\PUBLIC_FILES") 
$backupDestination = "C:\Users\pslearner\Desktop\BACKUP"

# Step 2: Ensure backup destination exists
if (-not (Test-Path $backupDestination)) {
    Write-Host "$($backupDestination) Does Not Exists...Creating" -ForegroundColor Red 

    New-Item -Path $backupDestination -ItemType Directory
}
else
{
    Write-Host "$($backupDestination) Already Exists" -ForegroundColor Green    
}


# Step 3: Create a backup log
$logFile = "$backupDestination\backupLog.txt"
New-Item -Path $logFile -ItemType File -Force


# Step 4: Iterate through the directories and initiate a backup
foreach ($dir in $directoriesToBackup) {
    $backupName = (Get-Date -Format "yyyyMMddHHmmss") + "_" + ($dir -replace '[:\\]', '_') + ".zip"
    $backupPath = Join-Path -Path $backupDestination -ChildPath $backupName
    Compress-Archive -Path $dir -DestinationPath $backupPath
    Add-Content -Path $logFile -Value "[$(Get-Date)] SUCCESS: Backed up $dir to $backupPath."
}

# Step 5: Cause Error for Non-Existent Directory
$directoriesToBackup = @("C:\Users\pslearner\Desktop\DOES_NOT_EXIST", "C:\Users\pslearner\Desktop\PUBLIC_FILES") 
foreach ($dir in $directoriesToBackup) {
    $backupName = (Get-Date -Format "yyyyMMddHHmmss") + "_" + ($dir -replace '[:\\]', '_') + ".zip"
    $backupPath = Join-Path -Path $backupDestination -ChildPath $backupName
    Compress-Archive -Path $dir -DestinationPath $backupPath
    Add-Content -Path $logFile -Value "[$(Get-Date)] SUCCESS: Backed up $dir to $backupPath."
}

# Step 6: Add Error Handling
foreach ($dir in $directoriesToBackup) {
    try {
        $backupName = (Get-Date -Format "yyyyMMddHHmmss") + "_" + ($dir -replace '[:\\]', '_') + ".zip"
        $backupPath = Join-Path -Path $backupDestination -ChildPath $backupName
        if (Test-Path $dir) {
            Compress-Archive -Path $dir -DestinationPath $backupPath -ErrorAction Stop
            Add-Content -Path $logFile -Value "[$(Get-Date)] SUCCESS: Backed up $dir to $backupPath."
        } else {
            throw "Directory $dir does not exist."
        }
    } catch {
        Add-Content -Path $logFile -Value "[$(Get-Date)] ERROR: Failed to backup $dir. Reason: $($_.Exception.Message)"
    }
}
