# Windows Scripting Languages

This area covers scripting languages used on Windows operating systems.

* 🖥️ [Command Shell (BATCH)](./batch/README.md) - classic command shell environments whose origins come from DOS
* ⚡ [PowerShell](./powershell/README.md) - offical shell environemnt supported by Microsoft and is cross-platform to non-Windows
* 🌐 [Widnows Script Host: JScript](./wsh.jscript/README.md) - Active Scripting langauge based on JavaScript
* 📝 [Windows Script Host: VBScript](./wsh.vbscript/README.md) - Active Scripting language based on VisualBasic

## About Language Support

* PowerShell
  * **PowerShell 5.1** is bundled on Windows systems and requires .NET Framework to run. 
  * **PowerShell 7.x** (`pwsh`) - runs on Windows, Linux, and macOS and is bundled with its own embedded DotNet environment. 
  * Batch (`cmd`) only runs on Windows, but can run under [WINE](#wine-wine-is-not-an-emulator) on Linux or macOS
  * Windows Script Host (`cscript`) with support for JScript and VBScript only runs on Windows, but can run under [WINE](#wine-wine-is-not-an-emulator) on Linux or macOS.

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

## WINE (WINE Is Not an Emulator)

The WINE environment can execute Win32 binaries on non-Windows systems and comes their implementation of popular binaries: `cmd.exe`, `cscript.exe`, `findstr.exe`, `where.exe`.

See [WINE NOTES](WINE_NOTES.md) for further information.

## WSL1

**Windows Subsystem for Linux (WSL) v1** is a compatibility layer for running native Linux ELF binaries on Windows.  As it is still Windows, you can run native Windows binaries within teh WSL1 environment. 

Log into your WSL1 environemnt, e.g `wsl -d MyUnbuntu-WSL1`, and from this directory you can run using these helper functions. 

```bash
cmd() {
  SCRIPT_PATH=$(realpath "$1"); shift
  WIN_PATH=$(wslpath -w "$SCRIPT_PATH")
  pushd /mnt/c > /dev/null

  cmd.exe /c "$WIN_PATH" "$@"

  popd > /dev/null
}

cscript() {
  SCRIPT_PATH=$(realpath "$1"); shift
  WIN_PATH=$(wslpath -w "$SCRIPT_PATH")
  pushd /mnt/c > /dev/null

  cscript.exe /Nologo "$WIN_PATH" "$@"
 
  popd > /dev/null
}

cmd batch/scripts/a00.output.cmd
cscript wsh.vbscript/scripts/a00.output.vbs
cscript wsh.jscript/scripts/a00.output.js
```

> **NOTES**: 
>  1. The tools `cmd.exe` or `cscript.exe` must be run from /mnt/c or otherwise, they'll print warnings to stderr. 
>  2. The full absolute path must be used 

The actual, current version of these helpers lives in [`wsl1-run.sh`](wsl1-run.sh) - copy it to `/usr/local/bin/cmd` and `/usr/local/bin/cscript` (both names dispatch off the same script) so `rake`/`Script.rb`'s `Wsl1ShellScript` can find them on PATH the same way any other interpreter is resolved.

## Cygwin

**[Cygwin](https://www.cygwin.com/)** is a full POSIX environment on Windows (unlike MSYS2/WSL1, its Ruby build is genuinely Cygwin-runtime-linked, not a native Windows binary) - it can run `cmd.exe`/`cscript.exe` directly, no WINE or interop layer needed, but Cygwin's own argument handling mis-parses a `./`-style relative path passed to a native (non-Cygwin) executable - confirmed directly:

```bash
$ cmd /c ./scripts/a00.output.cmd
'.' is not recognized as an internal or external command, operable program or batch file.

$ cmd /c "$(cygpath -w ./scripts/a00.output.cmd)"
Hello
```

[`cygwin-run.sh`](cygwin-run.sh) resolves the script path via `cygpath -w` before invoking the real `cmd.exe`/`cscript.exe`, the same fix shown above. Copy it to `/usr/local/bin/cmd` and `/usr/local/bin/cscript` the same way as WSL1's `wsl1-run.sh`, so `Script.rb`'s `CygwinShellScript` can find them on PATH.

## Windows NoDefaultCurrentDirectoryInExePath

If the environment variable `NoDefaultCurrentDirectoryInExePath` is set, you will not be able to execute scripts in your current working directory, unless you prefix the variable with a path such as `.\` in Windows PowerShell or Command Shell (cmd.exe), and `./` for any POSIX system running on Windows, like Cygwin, MSYS2, or WSLv1.

To set or unset `NoDefaultCurrentDirectoryInExePath` (which prevents Windows from implicitly searching the current working directory for executables), use environment variable commands across PowerShell, CMD, or POSIX-compatible translation layers:

### **PowerShell**
  * **Set (Session)**: 
    ```pwsh
    $env:NoDefaultCurrentDirectoryInExePath = '1'
    ```
  * **Unset (Session)**:
    ```pwsh
    Remove-Item Env:\NoDefaultCurrentDirectoryInExePath
    ```
  * **Set (Persistent User)**: 
    ```pwsh
    [Environment]::SetEnvironmentVariable('NoDefaultCurrentDirectoryInExePath', '1', 'User')
    ```
  * **Unset (Persistent User)**:
    ```pwsh
    [Environment]::SetEnvironmentVariable('NoDefaultCurrentDirectoryInExePath, $null, 'User')
    ```

### ***Command Shell (cmd.exe)*** 

  * **Set (Session)**: 
    ```dos
    set NoDefaultCurrentDirectoryInExePath=1
    ```
  * **Unset (Session)**:
    ```dos
    set NoDefaultCurrentDirectoryInExePath=
    ```
  * **Set (Persistent User)**: 
    ```dos
    setx NoDefaultCurrentDirectoryInExePath 1
    ```
  * **Unset (Persistent User)**:
    ```dos
    reg delete "HKCU\Environment" /v NoDefaultCurrentDirectoryInExePath /f
    ```

### ***POSIX (WSL1, Cygwin, MSYS2)*** 

  * **Set (Session)**: 
    ```sh
    export NoDefaultCurrentDirectoryInExePath=1
    ```
  * **Unset (Session)**:
    ```sh
    unset NoDefaultCurrentDirectoryInExePath
    ```
  * **Set (Persistent via `~/.bashrc` or `~/.profile`)**:
    ```sh
    echo "export NoDefaultCurrentDirectoryInExePath=1" >> ~/.profile
    ```