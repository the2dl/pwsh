# Script Name: File Share Creation Script
# Description: Creates multiple file shares with varying permissions and sensitive/non-sensitive content
# for security testing purposes.
# Author: the2dl

# Enable verbose output
$VerbosePreference = "Continue"

# Arrays for file generation
$sensitiveFileNames = @(
    "passwords", "credentials", "ssn", "credit_cards", "bank_accounts",
    "employee_data", "salary_info", "customer_database", "admin_access",
    "secret_keys", "api_tokens", "confidential", "restricted", "internal_only"
)

$normalFileNames = @(
    "readme", "notes", "meeting_minutes", "schedule", "todo", "project_plan",
    "budget", "report", "presentation", "template", "policy", "procedure",
    "guidelines", "manual", "handbook"
)

$fileExtensions = @(
    ".txt", ".doc", ".docx", ".xls", ".xlsx", ".pdf", ".csv",
    ".conf", ".ini", ".cfg", ".xml", ".json", ".bak", ".old"
)

$departments = @("IT", "HR", "Finance", "Marketing", "Sales", "Operations", "Legal")

# Function to write log messages
function Write-LogMessage {
    param(
        [string]$Message,
        [string]$Level = "Info"
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] [$Level] $Message"
    
    switch ($Level) {
        "Error"   { Write-Host $logMessage -ForegroundColor Red }
        "Warning" { Write-Host $logMessage -ForegroundColor Yellow }
        "Success" { Write-Host $logMessage -ForegroundColor Green }
        default   { Write-Host $logMessage }
    }
    
    $logMessage | Out-File -FilePath ".\share_creation.log" -Append
}

# Function to generate random sensitive content
function Get-SensitiveContent {
    param([string]$Type)
    
    switch ($Type) {
        "ssn" { 
            return 1..10 | ForEach-Object { "SSN: {0:000}-{1:00}-{2:0000}" -f (Get-Random -Min 100 -Max 999), (Get-Random -Min 10 -Max 99), (Get-Random -Min 1000 -Max 9999) }
        }
        "credit_cards" {
            return 1..10 | ForEach-Object { "CC: {0:0000}-{1:0000}-{2:0000}-{3:0000}" -f (Get-Random -Min 1000 -Max 9999), (Get-Random -Min 1000 -Max 9999), (Get-Random -Min 1000 -Max 9999), (Get-Random -Min 1000 -Max 9999) }
        }
        "passwords" {
            return 1..10 | ForEach-Object { "user$_:P@ssw0rd$_" }
        }
        default {
            return "CONFIDENTIAL INFORMATION`nNot for distribution`nInternal Use Only"
        }
    }
}

# Function to generate random normal content
function Get-NormalContent {
    return @"
Lorem ipsum dolor sit amet, consectetur adipiscing elit.
Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris.
"@
}

# Function to create a share with specific permissions
function New-TestFileShare {
    param(
        [string]$BasePath,
        [string]$ShareName,
        [string]$Permission = "Normal"
    )

    # Clean the share name of any illegal characters
    $ShareName = $ShareName -replace '[\\/:*?"<>|]', '_'
    $sharePath = Join-Path $BasePath $ShareName
    
    try {
        # Create directory if it doesn't exist
        if (!(Test-Path $sharePath)) {
            New-Item -Path $sharePath -ItemType Directory -Force | Out-Null
        }

        # Create the share
        $shareParams = @{
            Name = $ShareName
            Path = $sharePath
            FullAccess = "Everyone"
            Description = "Test share - $Permission permissions"
        }

        New-SmbShare @shareParams -ErrorAction Stop

        # Set NTFS permissions based on permission type
        switch ($Permission) {
            "Open" {
                $acl = Get-Acl $sharePath
                $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("Everyone","FullControl","ContainerInherit,ObjectInherit","None","Allow")
                $acl.SetAccessRule($accessRule)
                Set-Acl $sharePath $acl
            }
            "Locked" {
                $acl = Get-Acl $sharePath
                $acl.SetAccessRuleProtection($true, $false)
                $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("SYSTEM","FullControl","ContainerInherit,ObjectInherit","None","Allow")
                $acl.AddAccessRule($accessRule)
                $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("Administrators","FullControl","ContainerInherit,ObjectInherit","None","Allow")
                $acl.AddAccessRule($accessRule)
                Set-Acl $sharePath $acl
            }
            default {
                # Normal permissions - Authenticated Users have Read & Execute
                $acl = Get-Acl $sharePath
                $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("Authenticated Users","ReadAndExecute","ContainerInherit,ObjectInherit","None","Allow")
                $acl.AddAccessRule($accessRule)
                Set-Acl $sharePath $acl
            }
        }

        Write-LogMessage "Created share: \\$env:COMPUTERNAME\$ShareName with $Permission permissions" "Success"
        return $sharePath
    }
    catch {
        Write-LogMessage ("Failed to create share {0}: {1}" -f $ShareName, $_.Exception.Message) "Error"
        return $null
    }
}

# Get input from user
$numShares = Read-Host "Enter the number of shares to create"
$basePath = Read-Host "Enter the base path for share creation (e.g., C:\Shares)"
$domain = Read-Host "Enter the domain name (e.g., company.com)"

# Validate inputs
if (-not ($numShares -match '^\d+$')) {
    Write-Error "Please enter a valid number"
    exit
}

if (-not (Test-Path $basePath)) {
    try {
        New-Item -Path $basePath -ItemType Directory -Force | Out-Null
    }
    catch {
        Write-Error "Cannot create base directory: $_"
        exit
    }
}

# Permission types for shares
$permissionTypes = @("Open", "Normal", "Locked")

# Create shares and populate with files
$successfulCreations = 0

while ($successfulCreations -lt $numShares) {
    $department = $departments | Get-Random
    $shareName = "{0}_Share_{1}" -f $department, (Get-Random -Minimum 1000 -Maximum 9999)
    $permission = $permissionTypes | Get-Random
    
    # Clean the share name
    $shareName = $shareName -replace '[\\/:*?"<>|]', '_'
    $sharePath = Join-Path -Path $basePath -ChildPath $shareName
    
    $shareCreated = New-TestFileShare -BasePath $basePath -ShareName $shareName -Permission $permission
    
    if ($shareCreated) {
        # Create random directory structure
        1..(Get-Random -Minimum 3 -Maximum 8) | ForEach-Object {
            $folderName = "Folder$_"
            $subDir = Join-Path -Path $sharePath -ChildPath $folderName
            
            try {
                # Create directory
                if (!(Test-Path -Path $subDir -ErrorAction Stop)) {
                    $null = New-Item -Path $subDir -ItemType Directory -Force -ErrorAction Stop
                    Write-LogMessage "Created directory: $subDir" "Info"
                
                    # Create sensitive files (20% chance)
                    if ((Get-Random -Minimum 1 -Maximum 100) -le 20) {
                        $sensitiveFileName = ($sensitiveFileNames | Get-Random) + ($fileExtensions | Get-Random)
                        $sensitiveFileName = $sensitiveFileName -replace '[\\/:*?"<>|]', '_'
                        $sensitiveFilePath = Join-Path -Path $subDir -ChildPath $sensitiveFileName
                        
                        try {
                            $sensitiveContent = Get-SensitiveContent -Type ($sensitiveFileNames | Get-Random)
                            $null = Set-Content -Path $sensitiveFilePath -Value $sensitiveContent -Force -ErrorAction Stop
                            Write-LogMessage "Created sensitive file: $sensitiveFileName in $folderName" "Info"
                        }
                        catch {
                            Write-LogMessage "Failed to create sensitive file: $sensitiveFilePath - $($_.Exception.Message)" "Warning"
                        }
                    }
                    
                    # Create normal files
                    1..(Get-Random -Minimum 2 -Maximum 6) | ForEach-Object {
                        $normalFileName = ($normalFileNames | Get-Random) + ($fileExtensions | Get-Random)
                        $normalFileName = $normalFileName -replace '[\\/:*?"<>|]', '_'
                        $normalFilePath = Join-Path -Path $subDir -ChildPath $normalFileName
                        
                        try {
                            $normalContent = Get-NormalContent
                            $null = Set-Content -Path $normalFilePath -Value $normalContent -Force -ErrorAction Stop
                            Write-LogMessage "Created normal file: $normalFileName in $folderName" "Info"
                        }
                        catch {
                            Write-LogMessage "Failed to create normal file: $normalFilePath - $($_.Exception.Message)" "Warning"
                        }
                    }
                }
            }
            catch {
                Write-LogMessage "Failed to process directory $subDir - $($_.Exception.Message)" "Warning"
                continue
            }
        }
        
        $successfulCreations++
        Write-LogMessage "Progress: $successfulCreations/$numShares shares created" "Info"
    }
}

Write-Host "`nFile share creation complete!" -ForegroundColor Green 