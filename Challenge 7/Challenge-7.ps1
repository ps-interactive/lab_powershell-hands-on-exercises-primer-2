# Key Step 1: List out all the contents of the target directory.
# Key Step 2: Store the directory content in designated variables.
function Get-DirectoryContent {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Path
    )

    # Return all items from the specified path
    Get-ChildItem -Path $Path -Recurse
}

$targetDirectory = "C:\Path\To\TargetDirectory"  # Specify your target directory path here
$allItems = Get-DirectoryContent -Path $targetDirectory

# Key Step 3: Break down the directory content into different types.
$allFiles = $allItems | Where-Object { !$_.PSIsContainer }
$subDirectories = $allItems | Where-Object { $_.PSIsContainer }

# Key Step 4: Populate this structured information.
$directoryStructure = @{
    Files         = $allFiles
    SubDirectories = $subDirectories
}

# Key Step 5: Create variables to capture and store provided search keywords.
$searchKeywords = @("keyword1", "keyword2")  # Replace with your keywords or make it dynamic based on user input

# Key Step 6: Design a script to parse and search the directory's content.
function Search-DirectoryContent {
    param (
        [Parameter(Mandatory=$true)]
        [array]$Keywords,
        
        [Parameter(Mandatory=$true)]
        [hashtable]$DirectoryStructure
    )

    $matchedFiles = @()

    foreach ($keyword in $Keywords) {
        $matches = $DirectoryStructure.Files | Where-Object { $_.Name -like "*$keyword*" }
        $matchedFiles += $matches
    }

    # Return unique files (in case a file matches multiple keywords)
    return $matchedFiles | Select-Object -Unique
}

# Execute search
$foundFiles = Search-DirectoryContent -Keywords $searchKeywords -DirectoryStructure $directoryStructure
$foundFiles | Format-Table -Property Name, FullName -AutoSize
