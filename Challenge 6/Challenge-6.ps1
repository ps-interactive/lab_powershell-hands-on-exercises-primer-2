# Step 1: Retrieve all Schedule Tasks
Get-ScheduledTask | Select-Object TaskName

# Step 2: Retrieve all Scheduled Tasks that are Enabled
Get-ScheduledTask | Where-Object { $_.State -ne "Disabled" } | Select-Object TaskName

# Step 3: Retieve Detailed Scheduled Task
Get-ScheduledTask | Where-Object { $_.State -ne "Disabled" } | Select-Object *

# Step 4: Repeat Step 3 but output a PSCustomObject
Get-ScheduledTask | Where-Object { $_.State -ne "Disabled" } | ForEach-Object {
    [PSCustomObject]@{
        TaskName = $_.TaskName
        LastRunTime = $_.LastRunTime
        NextRunTime = $_.NextRunTime
        State = $_.State
        Triggers = $_.Triggers
    }
}

# Step 5: Get Detailed Scheduled Task Information
Get-ScheduledTask | Where-Object { $_.State -ne "Disabled" } | ForEach-Object {
    $taskInfo = Get-ScheduledTaskInfo $_
    @(
        "Task Name: $($taskInfo.TaskName)",
        "Last Run: $($taskInfo.LastRunTime)",
        "Next Run: $($taskInfo.NextRunTime)",
        "*****************************"
    ) -join "`r`n" | Write-Host
}

# Step 6: Create a Schedule Task with a Trigger, that executes a PowerShell Script
$trigger = New-ScheduledTaskTrigger -At 12:00pm -Once
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-File ""C:\Users\public\Desktop\LAB_FILES\Challenge 6\ScheduledTask.ps1"""
$settings = New-ScheduledTaskSettingsSet -Compatibility Win8
Register-ScheduledTask -TaskName "Challenge 6 - Task 1" -Trigger $trigger -Action $action -Settings $settings

# Step 7: Create an Advanced Scheduled Task with a Trigger and Settings, that executes a PowerShell Script
$trigger = New-ScheduledTaskTrigger -At 12:00pm -Once
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-File ""C:\Users\public\Desktop\LAB_FILES\Challenge 6\ScheduledTask.ps1"""
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -RunOnlyIfNetworkAvailable -DontStopOnIdleEnd -Compatibility Win8
Register-ScheduledTask -TaskName "Challenge 6 - Task 2" -Trigger $trigger -Action $action -Settings $settings

# Step 8: Create an Advanced Scheduled Task with a Trigger, Settings, that executes a PowerShell Script, and Authenticates with a User Account
$trigger = New-ScheduledTaskTrigger -At 12:00pm -Once
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-File ""C:\Users\public\Desktop\LAB_FILES\Challenge 6\ScheduledTask.ps1"""
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -RunOnlyIfNetworkAvailable -DontStopOnIdleEnd -Compatibility Win8
$principal = New-ScheduledTaskPrincipal -UserID "LiamCleary" -LogonType ServiceAccount -RunLevel Highest
Register-ScheduledTask -TaskName "Challenge 6 - Task 3" -Trigger $trigger -Action $action -Settings $settings -Principal $principal

# Step 9: Start the Scheduled Task
Start-ScheduledTask -TaskName "Challenge 6 - Task 1"

# Step 10: Stop the Scheduled Task
Stop-ScheduledTask -TaskName "Challenge 6 - Task 1"

# Step 11: Retrieve the Existing Task, then Update to Run Every Day at 12:00pm
$task = Get-ScheduledTask -TaskName "Challenge 6 - Task 1"
$trigger = New-ScheduledTaskTrigger -At 12:00pm -Daily
Set-ScheduledTask -TaskName $task.TaskName -Trigger $trigger

# Step 12: Remove the Scheduled Task
Unregister-ScheduledTask -TaskName "Challenge 6 - Task 1" -Confirm:$false

# Step 13: Generate the HTML Report of all Scheduled Tasks
$tasks = Get-ScheduledTask | ForEach-Object {
    $info = Get-ScheduledTaskInfo $_
    [PSCustomObject]@{
        TaskName       = $_.TaskName
        Status         = $_.State
        LastRunTime    = $info.LastRunTime
        NextRunTime    = $info.NextRunTime
        Actions        = ($_ | Select-Object -ExpandProperty Actions | ForEach-Object { 
            "$($_.Id) $($_.Execute) $($_.Arguments)"
        }) -join '<br/>'
        Triggers       = ($_ | Select-Object -ExpandProperty Triggers | ForEach-Object {
            "$($_.Id) $($_.StartBoundary) $($_.EndBoundary)"
        }) -join '<br/>'
        Settings       = [PSCustomObject]@{
            AllowStartIfOnBatteries = $_.Settings.AllowStartIfOnBatteries
            WakeToRun               = $_.Settings.WakeToRun
            StartWhenAvailable      = $_.Settings.StartWhenAvailable
            ExecutionTimeLimit      = $_.Settings.ExecutionTimeLimit
        } | Out-String
    }
}

$css = @"
<style type='text/css'>
    table {
        width: 600px;
        border-collapse: collapse;
    }
    th, td {
        border: 1px solid #D3D3D3; /* Pale Gray */
        padding: 8px;
        word-wrap: break-word;
    }
    th {
        background-color: #0000FF; /* Blue */
        color: white;
    }
</style>
"@

$html = $tasks | ConvertTo-Html -Title "Scheduled Tasks Report" -As Table -PreContent "<h1>Scheduled Tasks Report</h1>" -Head $css

# To save the HTML content to a file
$html | Out-File -FilePath "ScheduledTasksReport.html"

# To open the HTML file in a web browser
Start-Process -FilePath "ScheduledTasksReport.html"
