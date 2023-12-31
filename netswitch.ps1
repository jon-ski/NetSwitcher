<#
.SYNOPSIS
This is a simple script for managing IP addresses.

.DESCRIPTION
This script allows you to switch between different IP configurations.

.PARAMETER IPAddress
The IP address to set. Use "auto" for DHCP.

.EXAMPLE
.\netswitch.ps1 192.168.1.2/24
#>

# Function to display Help Text
function Show-Help {
    Write-Host "Usage: YourScriptName.ps1 [COMMAND] [ARGUMENTS]"
    Write-Host ""
    Write-Host "Commands:"
    Write-Host "  init     Initialize the config file by selecting a network interface."
    Write-Host "  auto     Set the IP address to DHCP."
    Write-Host "  [IP]     Set the static IP address. Can specify subnet mask (e.g., 192.168.1.2/24)."
    Write-Host ""
}

# Function to initialize the config file
function Initialize-Config {
    # List network interfaces
    $interfaces = Get-NetAdapter | Select-Object Name, Status
    $count = 1
    Write-Host "Available network interfaces:"
    $interfaces | ForEach-Object {
        Write-Host "$count. $($_.Name) (Status: $($_.Status))"
        $count++
    }

    # User selection
    [int]$selection = Read-Host "Enter the number of the network interface you'd like to select"
    $selectedInterface = $interfaces[$selection - 1].Name

    # Create config file
    $config = @{
        InterfaceName = $selectedInterface
    } | ConvertTo-Json

    Set-Content -Path "config.json" -Value $config
    Write-Host "Config file created with selected interface."
}

# Function to set IP to DHCP
function Set-DHCP {
    Write-Host "Setting IP address to DHCP for $interfaceName."
    netsh interface ip set address "$interfaceName" dhcp
}

# Function to set Static IP
function Set-StaticIP {
    param(
        [string]$ipInfo
    )

    # Extract IP address and Subnet Mask
    $ipAddress, $subnetBits = $ipInfo -split '/'
    $subnetMask = [IPAddress]::Parse("255.255.255.255").GetAddressBytes()
    $subnetMask[3] = [byte]([math]::Floor(1 -shl ($subnetBits - 24)))
    $subnetMask = [IPAddress]::Parse($subnetMask).IPAddressToString

    Write-Host "Setting IP address to $ipAddress with a subnet mask of $subnetMask for $interfaceName."
    netsh interface ip set address "$interfaceName" static $ipAddress $subnetMask
}

# Main Script Logic
if ($args.Length -eq 0) {
    Show-Help
} elseif ($args[0] -eq "init") {
    Initialize-Config
} elseif ($args[0] -eq "auto") {
    if (Test-Path "config.json") {
        $config = Get-Content "config.json" | ConvertFrom-Json
        $interfaceName = $config.InterfaceName
        Set-DHCP
    } else {
        Write-Host "Config file not found. Please initialize the config file by running the script with 'init' argument."
    }
} else {
    if (Test-Path "config.json") {
        $config = Get-Content "config.json" | ConvertFrom-Json
        $interfaceName = $config.InterfaceName
        foreach ($ip in $args) {
            Set-StaticIP $ip
        }
    } else {
        Write-Host "Config file not found. Please initialize the config file by running the script with 'init' argument."
    }
}
