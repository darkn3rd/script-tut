# Windows Scripting Languages

This area covers scripting languages used on Windows operating systems.

## Windows 11

As these languages are bundled with the operating system, no further installation is required. 

If you would like to get the latest powershell (`pwsh`)

```powershell
choco install -y choco.config
```

## macOS

You can install DotNet and Powershell with this command:

```bash
# Install Homebrew
script_url="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"
/bin/bash -c "$(curl -fsSL "$script_url")"

# Install PowerShell (pwsh)
brew bundle --verbose
```