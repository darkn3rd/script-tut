# Windows Scripting Languages

This area covers scripting languages used on Windows operating systems.

## Directory Structure

Each language directory (`batch/`, `powershell/`, `wsh.jscript/`, `wsh.vbscript/`) follows the same shape:

* `scripts/` - every lesson file (`a00.output.cmd`, `f00.loop.ps1`, ...) plus `dirtest/`, the fixture directory the F0 (Collection Loop) lesson reads. This is what actually changes between languages.
* `Rakefile` / `psakefile.ps1` + `psake.cmd` - one-liners that import the shared [testbox](../testbox/README.md) harness, same as every other lesson directory in this project.
* `README.md` - install instructions for that specific language.

`rake`/`psake` change into `scripts/` before running anything, so a lesson can be invoked as a bare filename and any self-name introspection it does (`$MyInvocation.MyCommand.Name`, `%~nx0`, `WScript.ScriptName`, ...) still reports just that bare filename - moving the lesson files here doesn't change what any lesson actually outputs.

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