# Read a list of computer names or IP addresses from an external file
$filePath = Read-Host "Enter the path to the file containing computer names or IP addresses"
$computerList = Get-Content -Path $filePath

# Using the traditional ping command within PowerShell:
function Test-Ping {
    param (
        [string]$computerName
    )
    # Using Invoke-Expression to run the traditional ping command
    $pingOutput = Invoke-Expression -Command "ping -n 1 $computerName"

    if ($pingOutput -like '*TTL*') {
        return @{
            ComputerName = $computerName
            Online       = $true
            ResponseTime = ($pingOutput -split 'time=')[1].Split('ms')[0] + 'ms'
        }
    } else {
        return @{
            ComputerName = $computerName
            Online       = $false
            ResponseTime = "N/A"
        }
    }
}

# Using the PowerShell Test-Connection cmdlet:
function Test-ConnectionPing {
    param (
        [string]$computerName
    )
    try {
        $result = Test-Connection -ComputerName $computerName -Count 1 -ErrorAction Stop
        return @{
            ComputerName = $computerName
            Online       = $true
            ResponseTime = $result.ResponseTime
        }
    } catch {
        return @{
            ComputerName = $computerName
            Online       = $false
            ResponseTime = "N/A"
        }
    }
}


# To demonstrate both within the script:
$filePath = Read-Host "Enter the path to the file containing computer names or IP addresses"
$computerList = Get-Content -Path $filePath

$method = Read-Host "Which method would you like to use? (1. Traditional ping, 2. Test-Connection)"

$results = $computerList | ForEach-Object {
    if ($method -eq "1") {
        Test-Ping -computerName $_
    } elseif ($method -eq "2") {
        Test-ConnectionPing -computerName $_
    } else {
        Write-Error "Invalid method selected."
        exit
    }
}

# Display the results
$results | Format-Table -Property ComputerName, Online, ResponseTime -AutoSize


# Function
# Read a list of computer names or IP addresses from an external file
$filePath = Read-Host "Enter the path to the file containing computer names or IP addresses"
$computerList = Get-Content -Path $filePath

# Function to test connectivity using the 'Test-Connection' cmdlet (PowerShell's version of ping)
function Test-ComputerPing {
    param (
        [string]$computerName
    )
    try {
        $result = Test-Connection -ComputerName $computerName -Count 1 -ErrorAction Stop
        return @{
            ComputerName = $computerName
            Online       = $true
            ResponseTime = $result.ResponseTime
        }
    } catch {
        return @{
            ComputerName = $computerName
            Online       = $false
            ResponseTime = "N/A"
        }
    }
}

# Embed the ping command within a PowerShell script to check online statuses
$results = $computerList | ForEach-Object {
    Test-ComputerPing -computerName $_
}

# Display the results in a structured format
$results | Format-Table -Property ComputerName, Online, ResponseTime -AutoSize


# Ping the Computer, retrieve the name, IP address and Status, then generate a HTML report
$computerName = Read-Host "Enter the name of the computer to ping"
$pingOutput = Invoke-Expression -Command "ping -n 1 $computerName"

if ($pingOutput -like '*TTL*') {
    $status = "Online"
} else {
    $status = "Offline"
}

$ipAddress = [System.Net.Dns]::GetHostAddresses($computerName) | Select-Object -ExpandProperty IPAddressToString

$report = [PSCustomObject]@{
    ComputerName = $computerName
    IPAddress    = $ipAddress
    Status       = $status
}

$report | ConvertTo-Html -Property ComputerName, IPAddress, Status | Out-File -FilePath "$env:USERPROFILE\Desktop\ComputerStatus.html"
Invoke-Item -Path "$env:USERPROFILE\Desktop\ComputerStatus.html"

