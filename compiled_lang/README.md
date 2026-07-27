# Compiled Languages

© Joaquin Menchaca, 2026

## Overview

In DevOps roles<sup>†</sup>, in addition to scripting languages, compiled tools and services using langauges like Go or Rust have been growing in increasing popularity.  For this reason, I wanted to expand the tutorial library to include compiled languages.  The same general structure details in `lessons.yaml` will be followed as well.  To compile these tools to executable binaries, you can use a GNU Make automation to compile the binaries, and afterward clean up any of the compiled artifacts.

> † **DevOps roles** icnlude system engineer, operations engineer, devops engineer, site reliability enginer, platform engineer, etc. 

### Directory Structure

Each langauge area will have the following directories:

* **`src/`** - the source code 
* **`target`/** - build artifacts that are generated
* **`bin`** - a final executable artifact for each lesson, which will be the an executable binary or a wrapper script that executes the binary.

The following will also be included:

* **`Makefile`** - the script that will build the artifacts in a POSIX environment, such as bash or zsh running on MSYS2, CygWin, macOS, Linux environments.
* **`Makefile.win`** - a script that will build the artifacts on a Windows system in Powershell. 
* **`Rakefile`** - using the ruby test harness to test every lesson
* **`psakefile.ps1`** - uses a powershell baed test harness to test every lesson
* **`dirtest/`** - the fixture directory needed for some lessons

### Bytecode Challenges

Java and C# each need something extra beyond a plain compile-and-promote, for different reasons:

* **Java** - `javac` output is named after the *class* declared inside the file, not the source file, and there's no single-file "compile to a binary" option. Each lesson's class must **not** be `public` (a `public` class's file name is required to match the class name exactly, which would conflict with this project's dotted lesson-file naming) - see `java/src/a00.output.java` for the pattern. The Makefile compiles the `.class` file into `target/`, then generates a launcher in `bin/` (a POSIX shell script, or a `.bat` wrapper on Windows) that runs `java -cp <path-to-target> ClassName`.

* **C#** - there's no simple, version-independent way to drive `csc` directly for a single file (see `cs/README.md`), so its Makefile generates a minimal, throwaway `.csproj` per lesson into `target/` and publishes it with `dotnet publish` and Native AOT (ahead-of-time compilation straight to native machine code) - a plain console app needs no NuGet/network access to do this. Unlike a plain `dotnet build` apphost (a small stub that needs a same-named `.dll` sitting next to it to actually run), AOT output is a genuinely standalone native executable, same as the other four languages - the tradeoff is that it also needs a native linker (clang/gcc, or MSVC's Build Tools on Windows) on top of the SDK.

## Windows 11 Smart App Control (SAC)

The Smart App Control (SAC) will prevent your compiled application binaries from running.  You can disable SAC with these commands:

* Using **Command Shell** (`cmd.exe`)
  ```batch
  :: Add a registry key or modify an existing one
  reg add ^
    "HKLM\SYSTEM\CurrentControlSet\Control\CI\Policy" ^
    /v VerifiedAndReputablePolicyState ^
    /t REG_DWORD ^
    /d 0 ^
    /f

  :: Refresh the active system Code Integrity policies immediately
  CiTool.exe -r
  ```
* Using **PowerShell**
  ```powershell
  # Set or modify a property value inside the registry
  Set-ItemProperty `
    -Path "HKLM:\SYSTEM\CurrentControlSet\Control\CI\Policy" `
    -Name "VerifiedAndReputablePolicyState" `
    -Value 0

  # Refresh the active system Code Integrity policies immediately
  CiTool.exe -r
  ```
* Using a POSIX shell (`sh`, `dash`, `bash`, `zsh`) in MSYS2 
  ```bash
  # Define path conversion exclusion so MSYS2 does not alter the flags
  export MSYS2_ARG_CONV_EXCL="*"
  
  # Call the native Windows reg tool to modify the policy state to 0 (Off)
  reg.exe add \
    "HKLM\SYSTEM\CurrentControlSet\Control\CI\Policy" \
    /v VerifiedAndReputablePolicyState \
    /t REG_DWORD \
    /d 0 \
    /f

  # Force Windows Code Integrity to reload policies immediately
  CiTool.exe -r
  ```

## Building and testing

You don't need to run `make` yourself to run the tests, as `rake` or `Invoke-psake` does it automatically (once per run, and it fails loudly with a clear message if the compiler or `make` itself isn't on PATH, or if the build fails, rather than leaving you to puzzle out the same "not recognized" error on every single test). Just run `rake` in the language directory you want, same as any other lesson suite.


### Running by Hand

To build and run a single lesson by hand, e.g. to poke at it outside the test harness:

```bash
# navigate to language directory
MY_LANGUAGE="rust"
cd $MY_LANGUAGE

# build binaries
make

# run a single test 
./bin/a00.output

# cleanup
make clean
```

### Running all the Tests

You can run the tests using either the Rake or Psake test harness.

* Powershell (pwsh)
    ```bash
  MY_LANGUAGE="cs"
  cd $MY_LANGUAGE
  
  # build and run all tests 
  Invoke-psake -quiet

  # clean up all build artifacts
  make clean
  ```
* POSIX (`sh`, `bash`, `zsh`, `dash`) or PowerShell (pwsh)
  ```bash
  MY_LANGUAGE="java"
  cd $MY_LANGUAGE
  
  # build and run all tests 
  rake

  # clean up all build artifacts
  make clean
  ```


## Setup

See each language's own README for what to install:

* [C++](cpp/README.md)
* [C#](cs/README.md)
* [Go](go/README.md)
* [Java](java/README.md)
* [Rust](rust/README.md)

### Getting GNU Make

Every langauge area will need [GNU Make](https://www.gnu.org/software/make/) on PATH to run the tests.

* **MSYS2 (Windows)**
  ```bash
  pacman -S make
  ```
* **Windows: Chocolatey**
  ```pwsh
  choco install -y make
  ```
* **macOS: Homebrew**
  ```bash
  brew install make
  ```
* **macOS: XCode**
  ```bash
  xcode-select --install
  ```  
* Debian/Ubuntu Linux Distros
  ```bash
  apt install make
  ```
* RHEL/Fedora Linxu Distros
  ```bash
  dnf install make
  ```

## Package Managers

Package managers automate installing, updating, and configuring software and system utilities via the command line, handling all background dependencies automatically.

## Windows 11: Chocolatey

Chocolatey is a command-line package manager for Windows that automates software management. It downloads and updates applications directly from the Chocolatey Community Repository, eliminating the need to manually click through setup wizards or visit vendor websites.

```pwsh
# Install Chocolatey on Windows 11
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = `
  [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
$WebClient = New-Object System.Net.WebClient
$ScriptUrl = 'https://community.chocolatey.org/install.ps1'
Invoke-Expression ($WebClient.DownloadString($ScriptUrl))
```

You can install the language requirements on Windows with the following command.
```pwsh
# Install all general scripting language
choco install -y choco.config
```

## macOS: Homebrew

Homebrew is the primary package manager for macOS. It automates the installation, updating, and configuration of command-line tools, languages, and desktop applications that Apple doesn't include by default, installing everything cleanly into its own isolated directory.

```bash
# Install Homebrew
script_url="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"
/bin/bash -c "$(curl -fsSL "$script_url")"

# Install all general scripting languages and OpenJDK
brew bundle --verbose
```

## Version Managers

Version managers isolate tool runtimes, letting you switch between multiple versions of the same language (e.g., Java 11 vs. 17) on a single machine to prevent project conflicts.

### SDKMan 

**[SDKMAN!](https://sdkman.io/)** is a dedicated version manager for the JVM ecosystem. It simplifies installing, isolating, and switching between parallel versions of the JDK, Maven, Gradle, and Groovy.

* General POSIX 
  ```bash
  # Install SDKMan using online script
  curl -s "https://sdkman.io" | bash
  
  # Add the following to your shell profile e.g. ~/.profile or ~/.zshrc
  source "$HOME/.sdkman/bin/sdkman-init.sh"
  ```
* macOS + Homebrew
  ```bash
  # Install SDKMan using Homebrew
  brew tap sdkman/tap
  brew trust --formula sdkman/tap/sdkman-cli
  brew install sdkman-cli

  # Add the following to your shell profile e.g. ~/.profile or ~/.zshrc
  export SDKMAN_DIR=$(brew --prefix sdkman-cli)/libexec
  [[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ]] && source "${SDKMAN_DIR}/bin/sdkman-init.sh"
  ```

### ASDF

**[ASDF](https://asdf-vm.com/)** is a universal version manager. Using an extensible plugin system, it replaces language-specific managers (like nvm, pyenv, and rbenv) to control all your tools via a single interface and a local .tool-versions file.

* Debian/Ubuntu Linux
  ```bash
  sudo apt install curl git
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0
  ```
* macOS + Homebrew
  ```bash
  brew install asdf
  ```
