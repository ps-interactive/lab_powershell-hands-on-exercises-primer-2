# Prerequisite
$path = "C:\Users\public\Desktop\LAB_FILES\Challenge 9\"

# Step 1: Load the Computers.txt File from the $path
$computers = Get-Content -Path "$path\Computers.txt"

# Step 2: Load the Computers.txt File from the $path, and split the IP Address and Name into two variables
$computers = Get-Content -Path "$path\Computers.txt" | ForEach-Object -Process {
    $ip, $name = $_.Split(" ")
    [PSCustomObject]@{
        IPAddress = $ip
        Name = $name
    }
}
$computers

# Step 3: Ping the computers using Invoke-Expression
$computers | ForEach-Object -Process {
    Invoke-Expression -Command "ping.exe $($_.IPAddress)"
}

# Step 4: Ping the computers and store the results in a variable
$pingResults = $computers | ForEach-Object -Process {
    Test-Connection -ComputerName $_.IPAddress -Count 1 -Quiet
}
$pingResults

# Step 5: Create a Function using Invoke-Expression for Pinging the computers
function Ping-Computer {
    param (
        [Parameter(Mandatory)]
        [string]$IPAddress
    )
    Invoke-Expression -Command "ping.exe $IPAddress"
}
Ping-Computer -IPAddress "172.31.24.39"

# Step 6: Create a Function using Test-Connection for Pinging the computers
function Ping-Computer {
    param (
        [Parameter(Mandatory)]
        [string]$IPAddress
    )
    Test-Connection -ComputerName $IPAddress -Count 1 -Quiet
}
Ping-Computer -IPAddress "172.31.24.39"

# Step 7: Create a Function that Offers a Choice to Ping the computers using Invoke-Expression or Test-Connection
function Ping-Computer {
    param (
        [Parameter(Mandatory)]
        [string]$IPAddress
    )

    $choice = Read-Host -Prompt "Do you want to use Invoke-Expression or Test-Connection?"

    if ($choice -eq "Invoke-Expression") {
        $output = Invoke-Expression -Command "ping.exe $IPAddress" 2>$null
        if($output -match "TTL=") {
            $status = "Status: Online"
        } else {
            $status = "Status: Offline"
        }
    }
    elseif ($choice -eq "Test-Connection") {
        $output = Test-Connection -ComputerName $IPAddress -Count 1 -Quiet
        if ($output) {
            $status = "Status: Online"
        } else {
            $status = "Status: Offline"
        }
    }
    else {
        Write-Warning -Message "Invalid Choice"
    }

    return $status
}
Ping-Computer -IPAddress "172.31.24.39"

# Step 8: Ping the Computer, retrieve the name, IP address and Status, then generate a HTML report
$pingResults = $computers | ForEach-Object -Process {
    $pingResult = Ping-Computer -IPAddress $_.IPAddress
    [PSCustomObject]@{
        IPAddress = $_.IPAddress
        Name = $_.Name
        Status = $pingResult
    }
}
$pingResults | ConvertTo-Html -Property IPAddress, Name, Status | Out-File -FilePath "$path\Ping.html"
Start-Process "$path\Ping.html"


