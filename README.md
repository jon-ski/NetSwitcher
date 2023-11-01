# NetSwitcher

NetSwitcher is a PowerShell script that allows you to easily switch between different IP configurations on Windows. You can set it to DHCP or specify a static IP address.

## Installation

1. Clone this repository or download it as a ZIP archive.
2. Run the `install.ps1` script to install NetSwitcher on your system.

## Usage

Run the script in PowerShell as an administrator.

- **To display help text:**
    ```powershell
    .\netswitch.ps1
    ```

- **To initialize the config file:**
    ```powershell
    .\netswitch.ps1 init
    ```

- **To set the IP to DHCP:**
    ```powershell
    .\netswitch.ps1 auto
    ```

- **To set a static IP:**
    ```powershell
    .\netswitch.ps1 192.168.1.2/24
    ```
