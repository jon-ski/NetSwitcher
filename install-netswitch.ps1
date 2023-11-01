# Define the script name and target directory
$scriptName = "MyScript.ps1"
$targetDir = "$env:USERPROFILE\MyScripts"

# Create target directory if it doesn't exist
if (-not (Test-Path $targetDir)) {
    New-Item -Path $targetDir -ItemType Directory
}

# Copy the script to the target directory
Copy-Item -Path ".\$scriptName" -Destination $targetDir

# Add target directory to user PATH if it's not already present
$oldPath = [Environment]::GetEnvironmentVariable("PATH", [System.EnvironmentVariableTarget]::User)
if ($oldPath -notlike "*$targetDir*") {
    [Environment]::SetEnvironmentVariable("PATH", "$oldPath;$targetDir", [System.EnvironmentVariableTarget]::User)
}

Write-Host "Script installed successfully. You can now run it from any PowerShell instance by typing '$scriptName'."
