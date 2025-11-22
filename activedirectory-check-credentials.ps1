# activedirectory-check-credentials.ps1
# ==================================================
# Description
# This script checks Active Directory credentials by prompting the user for a username and password,
# then validating them against the domain using .NET's System.DirectoryServices.AccountManagement.
# ==================================================
# Usage
# Run the script in a PowerShell environment. It will prompt for username and password.
# ==================================================


Write-Host "Starting  activedirectory-check-credentials.ps1 ..."


# Prompt for username and password
$Username = Read-Host "Enter username"
$SecurePassword = Read-Host "Enter password" -AsSecureString

# Convert SecureString to plain text in memory (required for ValidateCredentials)
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecurePassword)
$Password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

# Load .NET class for AD auth
Add-Type -AssemblyName System.DirectoryServices.AccountManagement

# Determine domain automatically from the computer
$Domain = $env:USERDOMAIN

# Create AD context
$Context = New-Object System.DirectoryServices.AccountManagement.PrincipalContext(
    [System.DirectoryServices.AccountManagement.ContextType]::Domain,
    $Domain
)

# Validate credentials
if ($Context.ValidateCredentials($Username, $Password)) {
    Write-Host "Credentials are valid." -ForegroundColor Green
} else {
    Write-Host "Invalid credentials." -ForegroundColor Red
}

# Clean up password from memory
[System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR)


Write-Host ""

Write-Host "Terminating  activedirectory-check-credentials.ps1 ..."
pause


# ==================================================
# Notes
# ==================================================
