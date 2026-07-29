# General Scripting

These languages cover general scripting languages that now include

* 📜 [AWK (Aho, Weinberger, and Kernighan)](awk/README.md)
* ☕ [Groovy](groovy/README.md) (requires [Java](../compiled_lang/java/README.md))
* 🐫 [Perl (Practical Extraction and Report Language)](perl/README.md)
* 🐘 [PHP (PHP Hypertext Preprocessor)](php/README.md)
* 🐍 [Python2](python2/README.md) (deprecated)
* 🐍 [Python3](python3/README.md)
* 💎 [Ruby](ruby/README.md)
* ⚙️ [TCL (Tool Command Language)](tcl/README.md)

## Directory Structure

Each language directory will have the following items

* **`scripts/`** - the source code files
* **`Rakefile`** - test script taht is luanched through Rake based test harness with: `rake`
* **`psakefile.ps1`** - test script that is launched through Psake based test harness with: `Invoke-psake -Quiet`
* **`README.md`** - docs for installing the language, package managers, and other info about the language

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
```

## macOS: Homebrew

Homebrew is the primary package manager for macOS. It automates the installation, updating, and configuration of command-line tools, languages, and desktop applications that Apple doesn't include by default, installing everything cleanly into its own isolated directory.

```bash
# Install Homebrew
script_url="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"
/bin/bash -c "$(curl -fsSL "$script_url")"
```

## Version Managers

Version managers isolate tool runtimes, letting you switch between multiple versions of the same language (e.g., Java 11 vs. 17) on a single machine to prevent project conflicts.

### SDKMAN!: Java and Groovy Version Manager

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

### ASDF: Version Manager Manager

**[ASDF](https://asdf-vm.com/)** is a universal version manager. Using an extensible plugin system, it replaces language-specific managers (like `nvm`, `pyenv`, and `rbenv`) to control all your tools via a single interface and a local .tool-versions file.

* Debian/Ubuntu Linux
  ```bash
  sudo apt install curl git
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0
  ```
* macOS + Homebrew
  ```bash
  brew install asdf
  ```

### pyenv: python version management

**[pyenv](https://github.com/pyenv/pyenv)** is a version manager for python and python related languages like `jython` (java python), `anaconda`, `graalpy`, `ironpythnon` (dotnet), etc. 

* **[Ubuntu 22.04 (Jammmy Jellyfish)](https://releases.ubuntu.com/jammy/)**
  ```bash
  # install tools + libs
  sudo apt update && sudo apt install -y \
    build-essential \
    curl \
    git \
    libbz2-dev \
    libffi-dev \
    liblzma-dev \
    libncursesw5-dev \
    libreadline-dev \
    libsqlite3-dev \
    libssl-dev \
    libxml2-dev \
    libxmlsec1-dev \
    llvm \
    make \
    tk-dev \
    wget \
    xz-utils \
    zlib1g-dev

  # Install Pyenv
  curl https://pyenv.run | bash

  # Profile Setup Example - ~/.bashrc, ~/.zshrc
  echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
  echo 'command -v pyenv >/dev/null || export PATH="$PATH:$PYENV_ROOT/bin"' >> ~/.bashrc
  echo 'eval "$(pyenv init -)"' >> ~/.bashrc
  source ~/.bashrc

  # update python listings
  pyenv update

  # get list of installable pythons
  pyenv install --list

  # list current installed python versions
  #  locked globally and per virtuenvs
  pyenv versions
  ```

### rbenv: ruby version management

**[rbenv](https://github.com/rbenv/rbenv)** is a version manager for ruby and ruby related languages `jruby` (java) and `truffleruby` (graal), except `ironruby` (dotnet).

* **[Ubuntu 22.04 (Jammmy Jellyfish)](https://releases.ubuntu.com/jammy/)**
  ```bash
  # install tools + libs
  sudo apt update && sudo apt install -y \
    git \
    curl \
    autoconf \
    bison \
    build-essential \
    libssl-dev \
    libyaml-dev \
    libreadline6-dev \
    zlib1g-dev \
    libncurses5-dev \
    libffi-dev \
    libgdbm6 \
    libgdbm-dev \
    libdb-dev

  # install rbenv
  sudo apt install rbenv
  
  # profile setup example, e.g. .bashrc, .zshrc
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
  echo 'eval "$(rbenv init -)"' >> ~/.bashrc
  source ~/.bashrc
  
  # update ruby listings 
  pushd ~/.rbenv/plugins/ruby-build  && git pull && popd

  # get list of installable rubies
  rbenv install --list

  # list current installed rubies
  rbenv versions
  ```

## Package Manifests

There are package manifests with list to packages that you can install

### macOS "Tahoe" 26.5

```bash
# Prompted Sudo login for Casks
brew bundle --verbose
```

### Windows 11

> **NOTE**: **[gsudo](https://github.com/gerardog/gsudo)** must be install before running these commands.<br>
>   See [Windows 11: Elevated Privileges with gsudo](../cibox/README.md#windows-11-elevated-privileges-with-gsudo) for more information.

```pwsh
# Install desired Java JDK
gsudo choco install -y corretto17jdk
# Install all general scripting language
gsudo choco install -y choco.config
```

### Cygwin (Windows 11)

```bash
# Launch Cygwin from Windows Terminal
& "C:\cygwin64\bin\bash.exe" --login -i
# Bash Shell: Install Packages
apt-cyg update
for PKG in $(cat cygwin_pkgs.txt); do apt-cyg install $PKG; done
```

### MSYS2 (Windows 11)

```bash
# Launch MSYS2 from Windows Terminal
& "C:\msys64\msys2_shell.cmd" -ucrt64 -defterm -no-start -where .
# Bash Shell: Install Packages
pacman -Syu --noconfirm
for PKG in $(cat msys2_pkgs.txt); do pacman -Sy --noconfirm $PKG; done
```

### Ubuntu 22.04

```bash
sudo apt update
while read -r LINE || [[ -n "$LINE" ]]; do
  # Remove leading/trailing spaces
  PKG=$(echo "$LINE" | xargs)
  # Skip empty lines, skip lines starting with #
  [[ -z "$PKG" || "$PKG" =~ ^# ]] && continue

  # Install the valid package name
  sudo apt install -y "$PKG"
done < ubuntu2204_pkgs.txt
```