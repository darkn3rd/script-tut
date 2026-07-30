# Scripting Tutorial: Perl

Version 1.2

© Joaquin Menchaca, 2014-2026

## Overview

Perl is a high-level, general-purpose, interpreted programming language originally developed by Larry Wall in 1987

Key Characteristics

* **Text Processing Power**: Renowned for its unmatched built-in regular expression (regex) engine, making it a premier tool for log analysis, data extraction, and report generation.
* **The "Glue Language"**: Widely used for system administration, scripting, and connecting disparate software systems or databases together.
* **TMTOWTDI Philosophy**: Operates on the core principle: "There's more than one way to do it," giving developers massive stylistic freedom.
* **CPAN Ecosystem**: Backed by the Comprehensive Perl Archive Network, a massive, mature repository containing tens of thousands of open-source modules.

### Why was Perl Made? 

Perl was created in 1987 by Larry Wall to solve a practical problem: he needed to generate complex, automated text reports on a Unix system, but found existing tools too limited or frustrating.

At the time, Wall was working as a system administrator and linguist. He felt trapped between two extremes in the Unix ecosystem:

* **Too low-level**: Languages like C were powerful, but required long compilation times and verbose code just to handle simple text.
* **Too limited**: High-level scripting tools like `awk`, `sed`, and shell scripts were great for small tasks, but became brittle, unreadable, and hard to maintain when scaled up to handle complex data manipulation.

### The Solution: A "Glue Language"

Wall built Perl to explicitly bridge the gap between C and shell scripting. His goal was to merge the absolute best features of `awk`, `sed`, and C into a single, unified tool.

Because it excelled at scanning arbitrary files, finding patterns via regular expressions, and printing data, it earned the backronym "***Practical Extraction and Report Language***". It became known as the "Swiss army chainsaw" of the internet because it could easily "glue" incompatible systems and data structures together.

## Getting Perl

### macOS: System Perl

**macOS** (previously **Mac OS X**) is bundled with **Perl 5** (`/usr/bin/perl`).  **Tahoe** (macOS 26.5) comes with Perl 5.34.1.  

Installing Perl Modules **[CPAN](https://www.cpan.org/)** (Comprehensive Perl Archive Network) using system Perl will require `sudo` access. You can install the Switch module with the following:

```bash
sudo cpan -f Switch
```

### macOS: HomeBrew

You can use **[Homebrew](https://brew.sh/)** to install the latest version of Perl.  As of July, 2026, this is Perl 5.43.2.

```bash
# Install Perl
brew install perl

# Put Homebrew's perl first on PATH, now and in future shells
# Add this line to your shell profile, e.g. .zshrc, .bashrc
export PATH="$(brew --prefix)/opt/perl/bin:$PATH"
```

**OPTIONAL**: You can optionally manage modules locally across different versions of Perl with the following below.  Otherwise, your modules will be destroyed with each upgrade of Perl. 

```bash
PERL_MM_OPT="INSTALL_BASE=$HOME/perl5" cpan local::lib
eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib=$HOME/perl5)"
```

Install **[App::cpanminus](https://metacpan.org/pod/App::cpanminus)** and the Switch Module with the following:

```bash
# Bootstrap cpanm - no sudo needed, this installs into Homebrew's own perl
cpan App::cpanminus

# Install Switch Module
cpanm Switch
```

### Windows: Chocolatey

**[Chocolatey](https://chocolatey.org)** is a command-line package manager for Windows, built on top of the NuGet infrastructure, that lets you install, update, and manage software using simple, automated commands instead of clicking through setup wizards.

You can use **[Chocolatey](https://chocolatey.org)** to install **[Strawberry Perl](https://strawberryperl.com/)**.  This distribution of Perl comes bundled with CPANminus and required compiler tools. 

```powershell
# Install Perl
choco install -y strawberryperl
# Install Switch module
cpanm Switch
```

### Windows: MSYS2

#### Getting MSYS2

**[MSYS2](https://www.msys2.org/)** is a software building and distribution platform for Windows that provides a Unix-like environment (including a Bash shell and the [pacman package manager](https://www.msys2.org/docs/package-management/) from Arch Linux). It allows you to compile, install, and run native Windows software using tools like GCC, MinGW-w64, and CMake. 

**UCRT64** is one of the specific environments (or subsystems) available within **[MSYS2](https://www.msys2.org/)** used to compile native 64-bit Windows software. It targets Microsoft's modern Universal C Runtime (UCRT), which comes pre-installed by default on all modern versions of Windows 10 and 11.

If you have **[Chocolatey](https://chocolatey.org)** setup, you can install MSYS2 with `choco install msys2`.

#### Perl in MSYS2

Perl is bundled with MSYS2, so no further installation is required.  If for some reason Perl is not installed, you can install it with:

```bash
pacman -S perl
```

> **IMPORTANT**: Do not install the UCRT (Universal C Runtime) Perl ([`mingw-w64-ucrt-x86_64-perl`](https://packages.msys2.org/packages/mingw-w64-ucrt-x86_64-perl)), as this is not compatible with a POSIX environment, as it uses CRLF.

If you run into problems, you can use `ldd` to check for compatibility.  The POSIX compatible binaries will link to `msys-2.0.dll`, while Windows binaries link to `win32u.dll`.  Here's how you can check:

```bash
# Check default Perl
ldd  /c/tools/msys64/usr/bin/perl | grep -E 'msys|win32' | sed 's/^[[:space:]]*//'
# msys-2.0.dll => /usr/bin/msys-2.0.dll (0x180040000)

# Check UCRT64 Perl
ldd  /c/tools/msys64/ucrt64/bin/perl | grep -E 'msys|win32' | sed 's/^[[:space:]]*//'
# win32u.dll => /c/Windows/System32/win32u.dll (0x7ff875590000)
```

If you have Windows binary in your PATH (on that is linked to `win32u.dll`), either remove it from the PATH or uninstall it. For example, here's how you can uninstall UCRT64 Perl  ([`mingw-w64-ucrt-x86_64-perl`](https://packages.msys2.org/packages/mingw-w64-ucrt-x86_64-perl)). 

```bash
# remove incompatible windows-only perl
pacman -R mingw-w64-ucrt-x86_64-perl
```

#### CPANminus in MSYS

Install **[App::cpanminus](https://metacpan.org/pod/App::cpanminus)** and the Switch perl module: 

```bash
# Base MSYS build system required for any modules that need compilers
pacman -S --needed base-devel
# Install APP::cpanminus
pacman -S mingw-w64-x86_64-cpanminus
# Install Switch module using cpanminus
cpanm Switch
```

#### Perl in Cygwin

```bash
apt-cyg install perl
```

#### CPANminus in Cygwin

```bash
# Install Development Tools
apt-cyg install gcc-core gcc-g++ make automake autoconf libtool binutils pkg-config git patch

# Install CPAN for local user 
PERL_MM_OPT="INSTALL_BASE=$HOME/perl5" cpan local::lib
eval "$(perl -Mlocal::lib)"

# Install CPANminus and Swtich.pm
cpan App::cpanminus
cpanm Switch
```

### Linux

Perl will be oftened bundled with the Linux distro and it is owned by root, requiring sudo to install modules. You can manage your Perl modules in your local user account with the following:

```bash
PERL_MM_OPT="INSTALL_BASE=$HOME/perl5" cpan local::lib
# add to your shell profile, .profile, .zprofile, .bash_profile
eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib)"

# install cpanminus
cpan App::cpanminus

# install Switch
cpanm Switch
```

### Other

On other environments, if there's no clear way to install CPANminus, you can use the online install script. 

```bash
# Install CPANMinus
curl -L https://cpanmin.us | /usr/bin/perl - App::cpanminus
# Install Switch
cpanm Switch
```


## Testing
* 📀 *__macOS 26.5 (Tahoe)__*
  * 📦 `perl v5.34.1 built for darwin-thread-multi-2level` (System)
  * 📦 `perl v5.42.2 built for darwin-thread-multi-2level` (Homebrew)
* 📀 *__Pop!_OS 22.04 (Ubuntu 22.04)__*
  * 📦 `perl v5.34.0 built built for x86_64-linux-gnu-thread-multi` (System)
* 📀 *__Windows 11 Home__* (`Microsoft Windows NT [Version 10.0.26200.8875]`)
  * 🐚 PowerShell 5.1.26100.8875
    * 📦 Strawberry Perl - `perl v5.42.0 built for MSWin32-x64-multi-thread`
  * 🐚 Command Shell (C:\Windows\System32\cmd.exe)
    * 📦 Strawberry Perl - `perl v5.42.0 built for MSWin32-x64-multi-thread`
  * 🐚 MSYS2 UCRT64 20260611.0.0 bash
    * 📦 UCRT64 Perl - `perl v5.42.2 built for MSWin32-x64-multi-thread`
  * 🐚 Cygwin 3.6.10-1
    * 📦 `perl v5.44.0 built for x86_64-cygwin-threads-multi`
