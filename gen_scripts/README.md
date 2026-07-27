# General Scripting

These languages cover general scripting languages.

## Directory Structure

Each language directory (`python3/`, `ruby/`, `perl/`, ...) follows the same shape:

* `scripts/` - every lesson file (`a00.output.py`, `f00.loop.py`, ...) plus `dirtest/`, the fixture directory the F0 (Collection Loop) lesson reads. This is what actually changes between languages.
* `Rakefile` / `psakefile.ps1` + `psake.cmd` - one-liners that import the shared [testbox](../testbox/README.md) harness, same as every other lesson directory in this project.
* `README.md` - install instructions for that specific language.

`rake`/`psake` change into `scripts/` before running anything, so a lesson can be invoked as a bare filename and any self-name introspection it does (Python's `sys.argv[0]`, Ruby's `$0`, ...) still reports just that bare filename - moving the lesson files here doesn't change what any lesson actually outputs.

## Package Managers

Package managers automate installing, updating, and configuring software and system utilities via the command line, handling all background dependencies automatically.

## Windows 11: Chocolatey

Chocolatey is a command-line package manager for Windows that automates software management. It downloads and updates applications directly from the Chocolatey Community Repository, eliminating the need to manually click through setup wizards or visit vendor websites.

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

### SDKMAN!

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
