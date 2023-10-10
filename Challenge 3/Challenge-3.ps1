# Key Step 1: Identify and list all existing partitions on the computer.
$partitions = Get-Volume

# Key Step 2: Extract basic metadata for each partition.
foreach ($partition in $partitions) {
    $partitionInfo = [PSCustomObject]@{
        Name       = $partition.FileSystemLabel
        FileSystem = $partition.FileSystem
    }
    Write-Output "Partition Name: $($partitionInfo.Name); File System: $($partitionInfo.FileSystem)"
}

# Key Step 3, 4 & 5: For each partition, determine the total, used, and available space.
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

# Displaying the computed spaces
$partitionSpaces | Format-Table -AutoSize

# Key Step 6: Set up a mechanism to periodically retrieve storage metrics.
# Assuming a 10 seconds interval for the purpose of the example. Adjust as needed.
$intervalInSeconds = 10
while ($true) {
    Start-Sleep -Seconds $intervalInSeconds

    # Re-fetch partitions and recompute metrics
    $partitions = Get-Volume
    # ... (Reuse the logic from the above steps for space calculation here if you wish to display it periodically)
}

# Key Step 7: Implement logic to compare current storage status against predefined thresholds.
$thresholdInPercent = 10 # For instance, alert if free space is below 10%. Adjust as needed.

foreach ($space in $partitionSpaces) {
    if (($space.FreeSpace / $space.TotalSpace) * 100 -lt $thresholdInPercent) {
        Write-Warning "Warning! Partition $($space.PartitionName) has less than $thresholdInPercent% free space left!"
    }
}
