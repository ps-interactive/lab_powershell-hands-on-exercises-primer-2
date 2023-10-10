# Get the user-specified directory
$targetDirectory = Read-Host "Enter the path to the target directory"

# List all files within the target directory and store them in a variable
$allFiles = Get-ChildItem -Path $targetDirectory -Recurse -File

# For each file in the directory, retrieve its size and create a hash table with the details
$fileSizeMapping = $allFiles | ForEach-Object {
    @{
        FileName = $_.Name
        FullPath = $_.FullName
        SizeInBytes = $_.Length
    }
}

# Sort the hash table based on file size in descending order and get the top 10 largest files
$top10Files = $fileSizeMapping | Sort-Object -Property SizeInBytes -Descending | Select-Object -First 10

# Convert the top 10 files to an HTML table
$htmlContent = $top10Files | ConvertTo-Html -Property FileName, SizeInBytes, FullPath -Title "Top 10 Largest Files" -Head '<style>table { border-collapse: collapse; } th, td { border: 1px solid black; padding: 8px; } th { background-color: #f2f2f2; }</style>'

# Specify the HTML file path
$htmlFilePath = Join-Path -Path $targetDirectory -ChildPath "Top10LargestFiles.html"

# Save the HTML content to a file
$htmlContent | Out-File -Path $htmlFilePath

# Display the HTML file in the default browser
Start-Process $htmlFilePath

