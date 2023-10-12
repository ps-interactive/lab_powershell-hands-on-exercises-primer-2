# Prerequisite
$path = "/Users/liamcleary/Documents/GitHub/lab_powershell-hands-on-exercises-primer-2/Challenge 8/Files"


# Step 1: Get all files in the path and sort by size
Get-ChildItem -Path $path -File | Sort-Object -Property Length -Descending


# Step 2: Get all files recursively in the path and sort by size
Get-ChildItem -Path $path -File -Recurse | `
    Sort-Object -Property Length -Descending | `
    Select-Object Length, Name -Unique


# Step 3: Get all files recursively in the path between 1MB and 10MB
Get-ChildItem -Path $path -File -Recurse | `
    Where-Object -FilterScript { $_.Length -gt 1MB -and $_.Length -lt 10MB } | `
    Sort-Object -Property Length -Descending | `
    Select-Object Length, Name -Unique


# Step 4: Get all files recursively in the path between 1MB and 10MB and filter to PowerPoint files
Get-ChildItem -Path $path -File -Recurse | `
    Where-Object -FilterScript { $_.Length -gt 1MB -and $_.Length -lt 10MB -and $_.Extension -eq ".pptx" } | `
    Sort-Object -Property Length -Descending | `
    Select-Object Length, Name -Unique


# Step 5: Get all Rich Text files recursively in the path and use a pattern match to filter off the year
Get-ChildItem -Path $path -File -Recurse | `
    Where-Object -FilterScript { $_.Extension -eq ".rtf" -and $_.Name -match "2023" } | `
    Sort-Object -Property Length -Descending | `
    Select-Object Length, Name -Unique


# Step 6: Get all files recursively in the path and store the enumerated files in a variable for further processing
$files = Get-ChildItem -Path $path -File -Recurse | `
    Sort-Object -Property Length -Descending | `
    Select-Object Length, Name -Unique

$files

# Step 7: Extract the first ten entries from $files and list the top 10 largest files
$files[0..9]


# Step 8: Output format to display the file names, sizes, and their path
$files[0..9] | `
    Format-Table -Property Name, Length, Directory -AutoSize

# Step 9: Generate a CSV files displaying the file names, sizes.
# Create four size buckets: 0MB to 1MB, 1MB to 10MB, 10MB to 100MB, and 100MB to 1GB
# Create a CSV file for each bucket
# Loop all files and add them to the appropriate CSV file
$files | `
    ForEach-Object -Process {
        if ($_.Length -lt 1MB) {
            $_ | Export-Csv -Path "$path\0MB-1MB.csv" -Append -NoTypeInformation
        }
        elseif ($_.Length -lt 10MB) {
            $_ | Export-Csv -Path "$path\1MB-10MB.csv" -Append -NoTypeInformation
        }
        elseif ($_.Length -lt 100MB) {
            $_ | Export-Csv -Path "$path\10MB-100MB.csv" -Append -NoTypeInformation
        }
        elseif ($_.Length -lt 1GB) {
            $_ | Export-Csv -Path "$path\100MB-1GB.csv" -Append -NoTypeInformation
        }
    }
