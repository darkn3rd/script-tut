# General Scripting

These languages cover general scripting languages.

## Windows 11

```powershell
# Install Chocolatey on Windows 11
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = `
  [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
$WebClient = New-Object System.Net.WebClient
$ScriptUrl = 'https://community.chocolatey.org/install.ps1'
Invoke-Expression ($WebClient.DownloadString($ScriptUrl))

# Install desired Java JDK
choco install -y corretto17jdk
# Install all general scripting language
choco install -y choco.config
```

## macOS

```bash
# Install Homebrew
script_url="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"
/bin/bash -c "$(curl -fsSL "$script_url")"

# Install all general scripting languages and OpenJDK
brew bundle --verbose
```