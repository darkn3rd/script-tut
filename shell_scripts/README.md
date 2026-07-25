# Shell Scripting Area

These languages cover Unix/Linux shell scripting languages.

## Directory Structure

Each language directory (`bash/`, `csh/`, `ksh/`, `posix/`) follows the same shape:

* `scripts/` - every lesson file (`a00.output.bash`, `f00.loop.bash`, ...) plus `dirtest/`, the fixture directory the F0 (Collection Loop) lesson reads. This is what actually changes between languages.
* `Rakefile` - a one-liner that imports the shared [testbox](../testbox/README.md) harness, same as every other lesson directory in this project.
* `README.md` - install instructions for that specific language.

`rake` changes into `scripts/` before running anything, so a lesson can be invoked as a bare filename and any self-name introspection it does (`$0`, ...) still reports just that bare filename - moving the lesson files here doesn't change what any lesson actually outputs.

## Windows 11

```powershell
# Install Chocolatey on Windows 11
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = 
    [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
$WebClient = New-Object System.Net.WebClient
$ScriptUrl = 'https://community.chocolatey.org/install.ps1'
Invoke-Expression ($WebClient.DownloadString($ScriptUrl))

# Install MSYS2 environment
choco install -y choco.config
```

## macOS

```bash
# Install Homebrew
script_url="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"
/bin/bash -c "$(curl -fsSL "$script_url")"

# Install latest shell versions
brew bundle --verbose
```