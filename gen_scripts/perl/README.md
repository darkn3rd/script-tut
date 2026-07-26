# Scripting Tutorial: Perl

Version 1.1

© Joaquin Menchaca, 2014-2026

## Getting Perl

### macOS: HomeBrew

**[Homebrew](https://brew.sh/)** is a command-line package manager for **macOS** that simplifies software installation by letting you download, update, and manage applications and tools using quick, automated commands.

```bash
# Install Homebrew on macOS
script_url="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"
/bin/bash -c "$(curl -fsSL "$script_url")"

# Install Perl
brew install perl
```

### Windows: Chocolatey

**[Chocolatey](https://chocolatey.org)** is a command-line package manager for Windows, built on top of the NuGet infrastructure, that lets you install, update, and manage software using simple, automated commands instead of clicking through setup wizards.

```powershell
# Install Chocolatey on Windows 11
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = 
    [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
$WebClient = New-Object System.Net.WebClient
$ScriptUrl = 'https://community.chocolatey.org/install.ps1'
Invoke-Expression ($WebClient.DownloadString($ScriptUrl))

# Install Perl
choco install -y strawberryperl
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

> **IMPORTANT**: Do not install the UCRT (Universal C Runtime) Perl, as this is not compatible with a POSIX environment, as it uses CRLF.

If you run into problems, you can use `ldd` to check for compatibility.  The POSIX compatible binaries will link to `msys-2.0.dll`, while Windows binaries link to `win32u.dll`.  Here's how you can check:

```bash
# Check default Perl
ldd  /c/tools/msys64/usr/bin/perl | grep -E 'msys|win32' | sed 's/^[[:space:]]*//'
# msys-2.0.dll => /usr/bin/msys-2.0.dll (0x180040000)

# Check UCRT64 Perl
ldd  /c/tools/msys64/ucrt64/bin/perl | grep -E 'msys|win32' | sed 's/^[[:space:]]*//'
# win32u.dll => /c/Windows/System32/win32u.dll (0x7ff875590000)
```

If you have Windows binary in your PATH (on that is linked to `win32u.dll`), either remove it from the PATH or uninstall it. For example, here's how you can uninstall UCRT64 Perl. 

```bash
pacman -R mingw-w64-ucrt-x86_64-perl
```

## Perl Modules (CPAN)

One lesson ([e41.branch.pl](scripts/e41.branch.pl)) needs a module beyond Perl's core - **[CPAN](https://www.cpan.org/)** (Comprehensive Perl Archive Network) is Perl's package repository. `cpan` (bundled with every Perl) and `cpanm`/**[App::cpanminus](https://metacpan.org/pod/App::cpanminus)** (a separate, modern, dependency-light client) are the two ways to install from it - prefer `cpanm` where you can get it.

### macOS: Homebrew Perl

If `perl` resolves to macOS's own **system** Perl (`/usr/bin/perl`) rather than Homebrew's, installing modules needs `sudo` - the system Perl's library directories are root-owned. That's why `sudo cpan -f Switch` was necessary. Switching to the Homebrew Perl from [Getting Perl](#macos-homebrew) sidesteps this, since it's entirely user-owned:

```bash
# Put Homebrew's perl first on PATH, now and in future shells
export PATH="$(brew --prefix)/opt/perl/bin:$PATH"
echo "export PATH=\"$(brew --prefix)/opt/perl/bin:\$PATH\"" >> ~/.zshrc

# Bootstrap cpanm - no sudo needed, this installs into Homebrew's own perl
cpan App::cpanminus

# local::lib keeps everything cpanm installs afterward in a per-user
#  directory instead of writing into Homebrew's perl tree directly -
#  eval'ing its output wires up PATH/PERL5LIB for it
eval "$(perl -Mlocal::lib)"
echo 'eval "$(perl -Mlocal::lib)"' >> ~/.zshrc
```

Then install a module directly, no `sudo`:

```bash
cpanm Switch
```

### Windows

Both Perl distributions under [Getting Perl](#getting-perl) are already entirely user-owned installs, so none of the `sudo`/`local::lib` dance above is needed here - `cpanm` just writes straight into them. (`local::lib`'s shell-activation output is also POSIX-shell syntax - `eval "$(perl -Mlocal::lib)"` doesn't translate cleanly to PowerShell or cmd.exe, which is one more reason to skip it on Windows entirely.)

* **Strawberry Perl** already bundles `cpanm` - just run `cpanm Switch`.
* **MSYS2 (UCRT64)** doesn't bundle `cpanm`, but Strawberry's copy of it can be run directly against UCRT64's `perl` (no need to actually use Strawberry's perl for anything else):
  ```bash
  perl /c/Strawberry/perl/bin/cpanm Switch
  ```

### Linux

Distro-packaged Perl is typically root-owned, same as macOS's system Perl above - the same pattern applies:

```bash
cpan App::cpanminus
eval "$(perl -Mlocal::lib)"
echo 'eval "$(perl -Mlocal::lib)"' >> ~/.bashrc
```

## Testing
* 📀 *__macOS 26.5 (Tahoe)__*
  * 📦 `perl v5.34.1 built for darwin-thread-multi-2level`
* 📀 *__Windows 11 Home__* (`Microsoft Windows NT [Version 10.0.26200.8875]`)
  * **Shell**: PowerShell 5.1.26100.8875
    * 📦 Strawberry Perl - `perl v5.42.0 built for MSWin32-x64-multi-thread`
  * **Shell**: Command Shell (C:\Windows\System32\cmd.exe)
    * 📦 Strawberry Perl - `perl v5.42.0 built for MSWin32-x64-multi-thread`
  * **Shell**: MSYS2 UCRT64 20260611.0.0 bash
    * 📦 UCRT64 Perl - `perl v5.42.2 built for MSWin32-x64-multi-thread`
