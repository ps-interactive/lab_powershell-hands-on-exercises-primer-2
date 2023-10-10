# Key Step 1: Retrieve a list of all existing scheduled tasks on the system.
# Key Step 2: Store the list in variables for further processing.
$scheduledTasks = Get-ScheduledTask

# Key Step 4: Populate these attributes into structured arrays or hash tables.
$taskDetails = @()

foreach ($task in $scheduledTasks) {
    # Key Step 3: For each scheduled task, retrieve key attributes.
    $taskName = $task.TaskName
    $taskStatus = $task.State
    $lastRunTime = ($task | Get-ScheduledTaskInfo).LastRunTime
    $nextRunTime = ($task.Triggers | ForEach-Object { $_.StartBoundary }) -join ", "
    $triggerConditions = ($task.Triggers | ForEach-Object { $_.Id }) -join ", "

    # Populate these into a hash table
    $taskHash = @{
        Name            = $taskName
        LastRunTime     = $lastRunTime
        NextRunTime     = $nextRunTime
        Status          = $taskStatus
        TriggerConditions = $triggerConditions
    }

    # Add this hash table to our details array
    $taskDetails += $taskHash
}

# Display the task details
$taskDetails | Format-Table -AutoSize

# Key Step 5: Develop scripts to perform specific actions on these tasks.

# Example: Disable a scheduled task by name
function Disable-ScheduledTaskByName {
    param (
        [Parameter(Mandatory=$true)]
        [string]$TaskName
    )

    try {
        Disable-ScheduledTask -TaskName $TaskName -ErrorAction Stop
        Write-Output "Successfully disabled the task: $TaskName"
    } catch {
        Write-Error "Failed to disable the task: $TaskName. Error: $_"
    }
}

# Example usage:
# Disable-ScheduledTaskByName -TaskName "Task Name Here"
