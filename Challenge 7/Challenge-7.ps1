# Step 1: List all contents of the directory specified in the variable: $path
$path = "C:\Users\Public\Desktop\LAB_FILES\Challenge 7\Files"

Get-ChildItem -Path $path

# Step 2: List all contents of the directory specified in the variable: $path that are files
Get-ChildItem -Path $path -File

# Step 3: List all contents of the directory specified in the variable: $path that are folders
Get-ChildItem -Path $path -Directory

# Step 4: List all contents of the directory specified in the variable: $path recursively
Get-ChildItem -Path $path -Recurse

# Step 5: List all contents of the directory specified in the variable: $path recursively that are files
Get-ChildItem -Path $path -Recurse -File

# Step 6: List all contents of the directory specified in the variable: $path recursively that are folders
Get-ChildItem -Path $path -Recurse -Directory

# Step 7: List all different file types recursively in the directory specified in the variable: $path
Get-ChildItem -Path $path -Recurse -File | Select-Object -Property Extension -Unique

# Step 8: List all different file types recursively in the directory 
$directories = Get-ChildItem -Path $path -Recurse -Directory
foreach ($dir in $directories) {
    $indentation = '-' * ($dir.FullName.Split('\').Count - $Path.Split('\').Count)
    Write-Host "$($dir.Name)"
    
    $files = Get-ChildItem -Path $dir.FullName -File
    foreach ($file in $files) {
        Write-Host "$indentation- $($file.Name)"
    }
}

# Step 9: Search for all files containing the word "Password" in the directory
Get-ChildItem -Path $path -Recurse -File | `
    Select-String -Pattern "password" | `
    Select-Object Filename, Path

# Step 10: Search for files containing any of the words "Password", "Secret" or "Confidential" in the directory
Get-ChildItem -Path $path -Recurse -File | `
    Select-String -Pattern "password|secret|confidential" | `
    Select-Object Filename, Path


# Step 11: Search for files containing any of the words "Password", "Secret" or "Confidential" using a Variable array for files in the directory
$keywords = @('password', 'secret', 'confidential')
$pattern = ($keywords -join '|')

Get-ChildItem -Path $path -Recurse -File | 
    Select-String -Pattern $pattern | 
    Select-Object Filename, Path


# Step 12: Create a function for searching files and folders using variable array values
function Search-FilesAndFolders {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Path,
        [Parameter(Mandatory = $true)]
        [string[]]$Keywords
    )

    # Check if the provided path exists
    if (-Not (Test-Path $Path)) {
        Write-Error "The specified path does not exist: $Path"
        return
    }

    # Check if keywords array is not empty
    if ($Keywords.Count -eq 0) {
        Write-Error "Please provide at least one keyword to search for."
        return
    }

    $pattern = ($Keywords -join '|')

    try {
        Get-ChildItem -Path $Path -Recurse -File | 
            Select-String -Pattern $pattern -ErrorAction Stop | 
            Select-Object Filename, Path
    }
    catch {
        Write-Error "An error occurred while searching: $_"
    }
}


# Step 13: Execute the Function
# Single Keyword Exection of the function
Search-FilesAndFolders -Path $path -Keywords "password"

# Multiple Keyword Exection of the function
Search-FilesAndFolders -Path $path -Keywords "password", "secret"

# Dynamic Keyword Exection of the function
$Path = $path
$Keywords = @("password", "secret", "confidential")

Search-FilesAndFolders -Path $Path -Keywords $Keywords


# Step 14: Search within Word, Excel, and PowerPoint documents using COM objects
$keywords = @('password', 'secret', 'confidential')
$pattern = ($keywords -join '|')

Get-ChildItem -Path $path -Recurse |
    Where-Object { $_.Extension -eq '.txt' -or $_.Extension -eq '.ps1'} |
    Select-String -Pattern $pattern |
    Select-Object FileName, Path

$extensions = @('.docx', '.pptx', '.xlsx', '.rtf')
$officeFiles = Get-ChildItem -Path $path -Recurse | 
               Where-Object { $extensions -contains $_.Extension }

foreach ($file in $officeFiles) {
    $content = $null

    if ($file.Extension -eq '.rtf' -or $file.Extension -eq '.docx') {
        $word = New-Object -ComObject Word.Application
        $word.Visible = $false
        $doc = $word.Documents.Open($file.FullName)
        $content = $doc.Content.Text
        $doc.Close([ref]$false)
        $word.Quit()
        [System.Runtime.InteropServices.Marshal]::ReleaseComObject($word) | Out-Null
    } elseif ($file.Extension -eq '.xlsx') {
        $excel = New-Object -ComObject Excel.Application
        $excel.Visible = $false
        $workbook = $excel.Workbooks.Open($file.FullName)
        $worksheets = $workbook.Worksheets.Count
        
        for ($i=1; $i -le $worksheets; $i++) {
            $worksheet = $workbook.Worksheets.Item($i)
            $usedRange = $worksheet.UsedRange
            foreach ($cell in $usedRange.Cells) {
                if ($cell.Text -match $pattern) {
                    $content = $cell.Text
                    break
                }
            }
    
            if ($content) { break }
        }
    
        $workbook.Close($false)
        $excel.Quit()
        [System.Runtime.InteropServices.Marshal]::ReleaseComObject($excel) | Out-Null
    } elseif ($file.Extension -eq '.pptx') {
        $powerpoint = New-Object -ComObject PowerPoint.Application
        $presentation = $powerpoint.Presentations.Open($file.FullName, $true, $true, $false)
        $content = ($presentation.Slides | ForEach-Object { $_.Shapes | ForEach-Object { $_.TextFrame.TextRange.Text } }) -join " "
        $presentation.Close()
        $powerpoint.Quit()
        [System.Runtime.InteropServices.Marshal]::ReleaseComObject($powerpoint) | Out-Null
    }

    if ($content -match $pattern) {
        [PSCustomObject]@{
            FileName = $file.Name
            Path = $file.FullName
        }
    }
}

# Step 15: Convert the code into a function
function Search-FilesForKeywords {
    param (
        [string]$directory,
        [string[]]$keywords
    )

    $pattern = ($keywords -join '|')

    Get-ChildItem -Path $directory -Recurse |
        Where-Object { $_.Extension -eq '.txt' -or $_.Extension -eq '.ps1'} |
        Select-String -Pattern $pattern |
        Select-Object FileName, Path

    $extensions = @('.docx', '.pptx', '.xlsx', '.rtf')
    $officeFiles = Get-ChildItem -Path $directory -Recurse | 
                   Where-Object { $extensions -contains $_.Extension }

    foreach ($file in $officeFiles) {
        $content = $null

        if ($file.Extension -eq '.rtf' -or $file.Extension -eq '.docx') {
            $word = New-Object -ComObject Word.Application
            $word.Visible = $false
            $doc = $word.Documents.Open($file.FullName)
            $content = $doc.Content.Text
            $doc.Close([ref]$false)
            $word.Quit()
            [System.Runtime.InteropServices.Marshal]::ReleaseComObject($word) | Out-Null
        } elseif ($file.Extension -eq '.xlsx') {
            $excel = New-Object -ComObject Excel.Application
            $excel.Visible = $false
            $workbook = $excel.Workbooks.Open($file.FullName)
            $worksheets = $workbook.Worksheets.Count
            
            for ($i=1; $i -le $worksheets; $i++) {
                $worksheet = $workbook.Worksheets.Item($i)
                $usedRange = $worksheet.UsedRange
                foreach ($cell in $usedRange.Cells) {
                    if ($cell.Text -match $pattern) {
                        $content = $cell.Text
                        break
                    }
                }
        
                if ($content) { break }
            }
        
            $workbook.Close($false)
            $excel.Quit()
            [System.Runtime.InteropServices.Marshal]::ReleaseComObject($excel) | Out-Null
        } elseif ($file.Extension -eq '.pptx') {
            $powerpoint = New-Object -ComObject PowerPoint.Application
            $presentation = $powerpoint.Presentations.Open($file.FullName, $true, $true, $false)
            $content = ($presentation.Slides | ForEach-Object { $_.Shapes | ForEach-Object { $_.TextFrame.TextRange.Text } }) -join " "
            $presentation.Close()
            $powerpoint.Quit()
            [System.Runtime.InteropServices.Marshal]::ReleaseComObject($powerpoint) | Out-Null
        }

        if ($content -match $pattern) {
            [PSCustomObject]@{
                FileName = $file.Name
                Path = $file.FullName
            }
        }
    }
}

Search-FilesForKeywords -directory $path -keywords @('password', 'secret', 'confidential')
