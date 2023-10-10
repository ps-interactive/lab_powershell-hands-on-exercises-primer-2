# Step 1: Load relevant .NET library
Add-Type -AssemblyName System.Security

# Step 2: Encode and Decode Functions
# Function to Encode (Encrypt) a string
function New-EncodedString {
    param (
        [Parameter(Mandatory = $true)]
        [string]$plainText
    )
    
    $plainTextBytes = [System.Text.Encoding]::Unicode.GetBytes($plainText)
    $secureText = [Security.Cryptography.ProtectedData]::Protect($plainTextBytes, $null, [Security.Cryptography.DataProtectionScope]::LocalMachine)
    $secureTextBase64 = [System.Convert]::ToBase64String($secureText)

    return $secureTextBase64
}

# Function to Decode (Decrypt) a string
function Get-DecodedString {
    param (
        [Parameter(Mandatory = $true)]
        [string]$encryptedText
    )
    
    $secureTextBase64 = [System.Convert]::FromBase64String($encryptedText)
    $secureText = [Security.Cryptography.ProtectedData]::Unprotect($secureTextBase64, $null, [Security.Cryptography.DataProtectionScope]::LocalMachine)
    $plainText = [System.Text.Encoding]::Unicode.GetString($secureText)

    return $plainText
}


# Step 3: Test Encode and Decode Functions.
# Encode the string
$plainText = "I Love Using PowerShell!"
$secureText = New-EncodedString -plainText $plainText
Write-Host "Encoded String: $secureText"

# Decode the string
$retrievedPlainText = Get-DecodedString -encryptedText $secureText
Write-Host "Decoded String: $retrievedPlainText"


# Step 4: Add a Key and Update the Encode and Decode Functions
function New-EncodedString {
    param (
        [string]$plainText,
        [byte[]]$Key
    )

    $plainTextBytes = [System.Text.Encoding]::Unicode.GetBytes($plainText)
    $secureText = [System.Security.Cryptography.ProtectedData]::Protect($plainTextBytes, $Key, [System.Security.Cryptography.DataProtectionScope]::LocalMachine)
    $secureTextBase64 = [System.Convert]::ToBase64String($secureText)

    return $secureTextBase64
}

function Get-DecodedString {
    param (
        [string]$encryptedText,
        [byte[]]$Key
    )

    $secureTextBase64 = [System.Convert]::FromBase64String($encryptedText)
    $secureText = [System.Security.Cryptography.ProtectedData]::Unprotect($secureTextBase64, $Key, [System.Security.Cryptography.DataProtectionScope]::LocalMachine)
    $plainText = [System.Text.Encoding]::Unicode.GetString($secureText)

    return $plainText
}

# Create an encryption key
$EncryptKey = New-Object byte[] 32
[System.Security.Cryptography.RandomNumberGenerator]::Create().GetBytes($EncryptKey)

# Encode the string
$plainText = "I Love Using PowerShell!"
$secureText = New-EncodedString -plainText $plainText -Key $EncryptKey
Write-Host "Encoded String: $secureText"

# Decode the string
$retrievedPlainText = Get-DecodedString -encryptedText $secureText -Key $EncryptKey
Write-Host "Decoded String: $retrievedPlainText"


