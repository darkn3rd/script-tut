# Shell Scripting Area

These languages cover Unix/Linux shell scripting languages.

## Shell on Windows

Windows does not come shell scripting environment, but you can get this with either MSYS2, Cygwin, WSLv1.

### 🌐 Cygwin

Cygwin is a compatibility layer and a ocllection of tools that provide a full POSIX emulation layer to run Linux applications natively on Windows. This allows developers to compile and run many Unix-based applications and use stanard POSIX command line tools (like bash, grep, awk) directly in Windows.

Under the hood, is the Cygwin `cgwin1.dll` library that translates  POSIX (Portable Operating System Interface) system calls from Linux/Unix applications into structions that the Windows operating system can understand.

You can install this with Chocolatey

```pwsh
gsudo choco install -y cygwin
```

### ⚙️ MSYS2

MSYS2 is a software building and management platform for Windows that provides a Unix-likee environment, and command-line shell (Bash), and a Arch Linux pacman package manager. It lets developers install toolchains and build native Windows software like GCC, CMake, and Python. 

Instead of translating Unix system calls at runtime, the MinGW compilers configure the software to use direct antive Windows APIs from the start. The result is that programs will run as pure native Windows appplications.

For a few scenarios, where there is no direct equivelent in Windows, like `fork()` or symbolic links, a translation layer (`msys-2.0.dll`) will need to be used. 

You can install this with Chocolatey:

```pwsh
gsudo choco install -y msys2
```

### 🐧 WSL1 (Windows Subsystem for Linux, Version 1)

WSL1 is a Microsoft-developed compatibility layer that allows running native Linux binary executables directly on Windows without a virtual machine. It utilizes a translation layer to convert Linux system calls into Windows NT kernel calls on the fly, enabling the use of unmodified Linux distributions and binaries.

> NOTE: You need to first enable Windows features like `Microsoft-Windows-Subsystem-Linux`. See [Enable WSL Features](/./cibox/README.md#enable-wsl-features).

Here's an example of how you can install Ubuntu 26.04 as WSLv1:

```pwsh
# Find Distros Online
wsl --list --online

MY_DISTRO_SELCTION="Ubuntu-26.04"
MY_INSTALL_NAME="Ubuntu26-WSL1"

# Install WSLv1 vrsion of Ubuntu
wsl --install $MY_DISTRO_SELCTION --name $MY_INSTALL_NAME --version 1

# Check Installed Versions
wsl --list --verbose

# Launch Target Distro
wsl -d $MY_INSTALL_NAME
```

### Cygwin vs MSYS


| **Feature / Behavior** | **`cygwin1.dll`** **(Cygwin)** | **`msys-2.0.dll`** **(MSYS2)** |
| :--- | :--- | :--- |
| **Primary Goal** | Turn Windows into a full Unix-like environment. | Act as a CLI build environment for native Windows apps. |
| **Path Formats** | Strictly Unix paths (e.g., /cygdrive/c/). | Automatically mangles paths on-the-fly to standard Windows form. |
| **Symbolic Links** | Emulates POSIX symlinks using custom system files. | Replaces symlinks with absolute file copies to avoid breaking native apps. |
| **File Permissions** | Translates Unix standard permissions to complex NTFS ACLs. | Defaults to noacl to ensure native Windows tools don't error out. |
| **Library Prefix** | Prefixes compiled shared libraries with cyg. | Prefixes compiled shared libraries with msys2-. |
| **Line Endings** | Retains standard POSIX \n line endings. | Automatically removes \r from native tool outputs. |


## Directory Structure

Each language directory (`bash/`, `csh/`, `ksh/`, `posix/`) follows the same shape:

* `scripts/` - every lesson file (`a00.output.bash`, `f00.loop.bash`, ...) plus `dirtest/`, the fixture directory the F0 (Collection Loop) lesson reads. This is what actually changes between languages.
* `Rakefile` - a one-liner that imports the shared [testbox](../testbox/README.md) harness, same as every other lesson directory in this project.
* `README.md` - install instructions for that specific language.

`rake` changes into `scripts/` before running anything, so a lesson can be invoked as a bare filename and any self-name introspection it does (`$0`, ...) still reports just that bare filename - moving the lesson files here doesn't change what any lesson actually outputs.

## Installing Package Managers

## Windows 11

```powershell
# Install Chocolatey on Windows 11
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = 
    [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
$WebClient = New-Object System.Net.WebClient
$ScriptUrl = 'https://community.chocolatey.org/install.ps1'
Invoke-Expression ($WebClient.DownloadString($ScriptUrl))
```

## macOS

```bash
# Install Homebrew
script_url="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"
/bin/bash -c "$(curl -fsSL "$script_url")"
```

## Elevated Privileges

Some commands may require elevated privileges.  You can launch a Windows console in ***Administrator*** mode, or can use a tool like `gsudo`.

You can install **gsudo** with one of the following methods using a terminal in Administrator mode: 

* Chocolatey
  ```pwsh
  choco install -y gsudo
  ```
* WinGet
  ```pwsh
  winget install -e --id gerardog.gsudo
  ```

Afterward, you can configured **gusdo**:

```pwsh
# First elevation triggers a UAC popup. 
#  Subsequent commands will not prompt you for UAC
gsudo config CacheMode Auto
# Change cache duration to 15 minutes
gsudo config CacheDuration "00:15:00"
```

You can integrate gusdo with Cygwin or MSYS2

```bash
alias sudo='/c/tools/gsudo/Current/gsudo.exe'
```

> IMPORTANT: Running **gsudo** in MinTTY (`mintty.exe`) will cause MinTTY to freeze.  Only use this in Command Prompt (`cmd.exe`), Windows Terminal (`wt.exe`), PowerShell (`powershell.exe`), or PowerShell 7 (`pwsh.exe`) 

## Package Manifiests

There are some package manifests that you can use to install all the packages needed for this area.

### Windows 11: Chocolately

You can install the package manifest (`choco.config`) with the following command below:

```pwsh
gsudo choco install -y choco.config
```

### Windows 11: MSYS2

Once **[MSYS2](https://www.msys2.org/)** is installed, you can install the package manifests using this.

```bash
pacman -Syu --noconfirm
for PKG in $(cat msys2_pkgs.txt); do pacman -Sy --noconfirm $PKG; done
```

### Windows 11: Cygwin

Once **[MSYS2](https://www.msys2.org/)** is installed, you can install the package manifests using this.

```bash
apt-cyg update
for PKG in $(cat cygwin_pkgs.txt); do apt-cyg install $PKG; done
```

### macOS: Homebrew

You can install the package manifest (`Brewfile`) with the following command below:

```bash
brew bundle --verbose
```



## Cygwin Package Managers

* Current Package Manager Tools
  * [apt-cyg](https://github.com/transcode-open/apt-cyg) - use this to install package within Cygwin. 
    ```bash
    gsudo choco install -y apt-cyg
    ```
  * **cygwinsetup.exe** (`c:\tools\cygwin\cygwinsetup.exe`) - this is the same Cygwin setup tool as `setup-x86_64.exe` and comes with Cygwin installed by Chocolatey. Packages can be install with the `--packages` switch.
  * [cyg-get.ps1](https://community.chocolatey.org/packages/cyg-get) - a powershell script wrapper for `cygwinsetup.exe`.  This is run from within a PowerShell environment.
    ```pwsh
    gsudo choco install -y cyg-get
    ```
  * [choco](https://github.com/chocolatey/choco) - installed with Chocolatey, can install Cygwin packages with `--source=cygwin` option. This uses the `cygwinsetup.exe` command.
* Classic Installers
  * [cyg-get (bash)](https://gitlab.com/cogline.v3/cygwin) - small bash script wrapper for `setup-x86_64.exe` binary
  * [setup-x86_64.exe](https://cygwin.readthedocs.io/en/stable/install/) - Cygwin setup tool can install packages with the `--packages` switch
  [pac-cyg](https://github.com/10sr/pac-cyg) - archived installer, no longer maintained. 


Examples of installing packages from Powershell: 

Here are some examplpes of using these installs:

* Install from outside of Cygwin with Powershell
  ```pwsh
  # install using original Cygwin installer tool
  setup-x86_64.exe --quiet-mode --packages=wget
  # install using Chocolatey Cygwin installer tool
  c:\tools\cygwin\cygwinsetup.exe --quiet-mode --packages=wget
  # install using cyg-get.ps1 script (requires cygwinsetup.exe)
  cyg-get wget
  # use chocolatey itself (will bootstrap cygwinsetup.exe if missing)
  choco install -y --source=cygwin wget
  ```
* Install from within Cygwin environment using bash:
  ```sh
  # install using cyg-get bash script (requires setup-x86_64.exe in the path)
  cyg-get git
  # install using apt-cyg bash script
  apt-cyg install git
  ```

## Launching from within PowerShell

As MinTTY (`mintty.exe`) will crash if gsudo is launched, you can launch MSYS2 or Cygwin directly from Windows Terminal (`wt.exe`):

For Cygwin, you can run this. 

```pwsh
& "C:\cygwin64\bin\bash.exe" --login -i
```

For MSYS2, you can run this, depending on desired environment: 

* UCRT64 (recommended default for mondern C++):
  ```pwsh
  & "C:\msys64\msys2_shell.cmd" -ucrt64 -defterm -no-start -where .
  ```
* MINGW64 (older native environment):
  ```pwsh
  & "C:\msys64\msys2_shell.cmd" -mingw64 -defterm -no-start -where .
  ```
* MSYS (POSIX emualtion environment)
  ```pwsh
  & "C:\msys64\msys2_shell.cmd" -msys -defterm -no-start -where .
  ```

## NTFS Symbolic Links

Microsoft introduced symbolic links in NTFS 3.1 at the release of Windows Vista (WinNT 6.0) in 2006. This will require elevated privileges to create NTFS symbolic links.

Both Cygwin and MSYS2 will not use this by default and have alternative methods for `ln -s`: 

* Cygwin creates magic files that reference the target location.
* MSYS2 makes a deep copy (default), but can also be configured to use the magic file like Cygwin. 

You can use native NTFS symbolic links by this environment variable:

* Cygwin
  ```bash
  export CYGWIN="winsymlinks:nativestrict"
  ```
* MSYS2
  ```bash
  export MSYS=winsymlinks:nativestrict
  ```

Because NTFS symbolic links require elevated privileges, you will need to run the terminal application in Administrator mode, or use a tool like `gsudo`.  Here's an example of you linking your repos directory to the same directory name but in your Windows user profile.

```bash
# Translate to C:\Users\$USER\repos
#  MSYS=/c/Users/$USER/repos
#  CYGIN=/cygdrive/c/Users/$USER/repos
LINK_NAME=`cygpath -p "$(echo $USERPROFILE)"`/repos
# Source Directory
TARGET_NAME=$HOME/repos

alias sudo='/c/tools/gsudo/Current/gsudo.exe'
sudo ln -s $TARGET_NAME $LINK_NAME
```