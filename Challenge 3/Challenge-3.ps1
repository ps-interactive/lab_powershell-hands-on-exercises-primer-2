# Step 1: Identify and list all existing partitions on the computer.
$partitions = Get-Volume
$partitions

# Step 2: Extract basic metadata for each partition.
foreach ($partition in $partitions) {
    $partitionInfo = [PSCustomObject]@{
        Name       = $partition.FileSystemLabel
        FileSystem = $partition.FileSystem
    }
    Write-Output "Partition Name: $($partitionInfo.Name); File System: $($partitionInfo.FileSystem)"
}

# Step 3: For each partition, determine the total, used, and available space.
$partitionSpaces = foreach ($partition in $partitions) {
    $totalSpace = $partition.Size
    $freeSpace  = $partition.SizeRemaining
    $usedSpace  = $totalSpace - $freeSpace

    [PSCustomObject]@{
        PartitionName = $partition.FileSystemLabel
        TotalSpace    = $totalSpace
        UsedSpace     = $usedSpace
        FreeSpace     = $freeSpace
    }
}

# Step 4: View the results
$partitionSpaces | Format-Table -AutoSize

# Step 5: Set up a mechanism to periodically retrieve storage metrics.
$intervalInSeconds = 10
while ($true) {
    Start-Sleep -Seconds $intervalInSeconds
    $partitions = Get-Volume
    $partitionSpaces = foreach ($partition in $partitions) {
        $totalSpace = $partition.Size
        $freeSpace  = $partition.SizeRemaining
        $usedSpace  = $totalSpace - $freeSpace
        [PSCustomObject]@{
            PartitionName = $partition.FileSystemLabel
            TotalSpace    = $totalSpace
            UsedSpace     = $usedSpace
            FreeSpace     = $freeSpace
        }
    }
    $partitionSpaces | Format-Table -AutoSize
}

# Step 6: List Elapsed Timing
$intervalInSeconds = 10
$totalElapsedSeconds = 0
while ($true) {
    $startTime = Get-Date
    Start-Sleep -Seconds $intervalInSeconds
    $endTime = Get-Date
    $elapsedTime = $endTime - $startTime
    $elapsedSeconds = [math]::Round($elapsedTime.TotalSeconds)
    $totalElapsedSeconds += $elapsedSeconds
    # Display total elapsed time
    Write-Host "Total Elapsed Seconds: $totalElapsedSeconds"
    # Re-fetch partitions and recompute metrics
    $partitions = Get-Volume
    $partitionSpaces = foreach ($partition in $partitions) {
        $totalSpace = $partition.Size
        $freeSpace  = $partition.SizeRemaining
        $usedSpace  = $totalSpace - $freeSpace
        [PSCustomObject]@{
            PartitionName = $partition.FileSystemLabel
            TotalSpace    = $totalSpace
            UsedSpace     = $usedSpace
            FreeSpace     = $freeSpace
        }
    }
    $partitionSpaces | Format-Table -AutoSize
}

# Step 7: Add Message Logic
$intervalInSeconds = 10
while ($true) {
    Start-Sleep -Seconds $intervalInSeconds
    # Re-fetch partitions and recompute metrics
    $partitions = Get-Volume
    $partitionSpaces = foreach ($partition in $partitions) {
        $totalSpace = $partition.Size
        $freeSpace  = $partition.SizeRemaining
        $usedSpace  = $totalSpace - $freeSpace
        [PSCustomObject]@{
            PartitionName = $partition.FileSystemLabel
            TotalSpace    = $totalSpace
            UsedSpace     = $usedSpace
            FreeSpace     = $freeSpace
        }
    }
    $partitionSpaces | Format-Table -AutoSize
    $thresholdInPercent = 10
    foreach ($space in $partitionSpaces) {
        if ($space.TotalSpace -gt 0 -and ($space.FreeSpace / $space.TotalSpace) * 100 -lt $thresholdInPercent) {
            Write-Warning "Warning! Partition $($space.PartitionName) has less than $thresholdInPercent% free space left!"
        }
    }
}

# Adjust the $thresholdInPercent to 90
$intervalInSeconds = 10
while ($true) {
    Start-Sleep -Seconds $intervalInSeconds
    # Re-fetch partitions and recompute metrics
    $partitions = Get-Volume
    $partitionSpaces = foreach ($partition in $partitions) {
        $totalSpace = $partition.Size
        $freeSpace  = $partition.SizeRemaining
        $usedSpace  = $totalSpace - $freeSpace
        [PSCustomObject]@{
            PartitionName = $partition.FileSystemLabel
            TotalSpace    = $totalSpace
            UsedSpace     = $usedSpace
            FreeSpace     = $freeSpace
        }
    }
    $partitionSpaces | Format-Table -AutoSize
    $thresholdInPercent = 90
    foreach ($space in $partitionSpaces) {
        if ($space.TotalSpace -gt 0 -and ($space.FreeSpace / $space.TotalSpace) * 100 -lt $thresholdInPercent) {
            Write-Warning "Warning! Partition $($space.PartitionName) has less than $thresholdInPercent% free space left!"
        }
    }
}
