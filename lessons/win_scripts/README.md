# Windows Scripting Languages

This area covers scripting languages used on Windows operating systems.

* 🖥️ [Command Shell (BATCH)](./batch/README.md) - classic command shell environments whose origins come from DOS
* ⚡ [PowerShell](./powershell/README.md) - offical shell environemnt supported by Microsoft and is cross-platform to non-Windows
* 🌐 [Widnows Script Host: JScript](./wsh.jscript/README.md) - Active Scripting langauge based on JavaScript
* 📝 [Windows Script Host: VBScript](./wsh.vbscript/README.md) - Active Scripting language based on VisualBasic

## Directory Structure

Each language directory will have the following items

* **`scripts/`** - the source code files
* **`Rakefile`** - test script taht is luanched through Rake based test harness with: `rake`
* **`psakefile.ps1`** - test script that is launched through Psake based test harness with: `Invoke-psake -Quiet`
* **`README.md`** - information about the specific language

## Windows 11

As these languages are bundled with the operating system, no further installation is required. 

If you would like to get the latest powershell (`pwsh`)

```powershell
gsudo choco install -y choco.config
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
