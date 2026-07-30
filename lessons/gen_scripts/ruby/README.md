# Scripting Tutorial: Ruby

© Joaquin Menchaca, 2014-2026

Version 1.5

## Getting Ruby

There are some excellent documentation on [Installing Ruby](https://www.ruby-lang.org/en/documentation/installation/) for a variety of environments. These are my notes on top of that. 

### macOS (default)

The macOS (Mac OS X) 26.5 "Tahoe" comes bundled with Ruby 2.6.10:

* `ruby 2.6.10p210 (2022-04-12 revision 67958) [unverisal.86_64-darwin25]`

Fore recent versions, you can use a package manager or a version manager:

* Package Manager
  * **[Homebrew](https://brew.sh/)**
  * **[MacPorts](https://www.macports.org/)**
  * **[Fink](https://www.finkproject.org/)**
* Version Managers
  * **[RVM](https://rvm.io/)**
  * **[rbenv](https://rbenv.org/)**
  * **[ASDF](https://asdf-vm.com/)** with **[asdf-ruby](https://github.com/asdf-vm/asdf-ruby)** plugin

### macOS: HomeBrew

**[Homebrew](https://brew.sh/)** is a command-line package manager for **macOS** that simplifies software installation by letting you download, update, and manage applications and tools using quick, automated commands.

```bash
# Install Homebrew on macOS
script_url="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"
/bin/bash -c "$(curl -fsSL "$script_url")"

# Install Ruby
brew install ruby
```

### Ubuntu: rbenv

You must install and setup `rbenv`, see [lessons/gen_scripts/README.md](../README.md#rbenv-ruby-version-management)

```bash
# update ruby listings 
pushd ~/.rbenv/plugins/ruby-build  && git pull && popd

# install ruby
rbenv install 4.0.6
rbenv global 4.0.6
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

# Install Ruby
choco install ruby
```

### Windows: MSYS2

**[MSYS2](https://www.msys2.org/)** is a software building and distribution platform for Windows that provides a Unix-like environment (including a Bash shell and the [pacman package manager](https://www.msys2.org/docs/package-management/) from Arch Linux). It allows you to compile, install, and run native Windows software using tools like GCC, MinGW-w64, and CMake. 

**UCRT64** is one of the specific environments (or subsystems) available within **[MSYS2](https://www.msys2.org/)** used to compile native 64-bit Windows software. It targets Microsoft's modern Universal C Runtime (UCRT), which comes pre-installed by default on all modern versions of Windows 10 and 11.

If you have **[Chocolatey](https://chocolatey.org)** setup, you can install MSYS2 with `choco install msys2`.

Once you launch the shell, you can install ruby using either UCRT64 environment or classic MINGW64 environment. 

```bash
# Update Packages
pacman -Syu
# UCRT64 Environment (Recommended)
pacman -S mingw-w64-ucrt-x86_64-ruby
# MINGW64 Environment (Classic)
pacman -S mingw-w64-x86_64-ruby
```

### Windows: Cygwin

```bash
apt-cyg install ruby rubygems
```



## Testing

* 📀 *__macOS 26.5 (Tahoe)__*
  * 📦 ruby 4.0.5 (2026-05-20 revision 64336ffd0e) +PRISM [x86_64-darwin23]
* 📀 Pop!_OS 22.04 (Ubuntu 22.04)
  * 📦 ruby 4.0.6 (2026-07-14 revision 03b6d3f889) +PRISM [x86_64-linux]
* 📀 *__Windows 11 Home__* (`Microsoft Windows NT [Version 10.0.26200.8875]`)
  * 🐚 PowerShell 5.1.26100.8875
    * 📦 ruby 3.4.9 (2026-03-11 revision 76cca827ab) +PRISM [x64-mingw-ucrt]
  * 🐚: Command Shell (C:\Windows\System32\cmd.exe)
    * 📦 ruby 3.4.9 (2026-03-11 revision 76cca827ab) +PRISM [x64-mingw-ucrt]
  * 🐚 MSYS2 UCRT64 20260611.0.0 bash
    * 📦 ruby 3.4.9 (2026-03-11 revision 76cca827ab) +PRISM [x64-mingw-ucrt]
  * 🐚 Cygwin 3.6.10-1
    * 📦 ruby 4.0.6 (2026-07-14 revision 03b6d3f889) +PRISM [x86_64-cygwin]

## Notes 

This covers notes regarding each section.

1. Output
2. Variables
3. Arithmetic
4. Input
5. Branch
   * if on number
   * case on single character
   * if on single character - using match operator ```=~```  
6. Looping
   * collection loop
      * iterate through set of items 
      * example: directory listing
      * syntax examples
        * ```for...do...end```
        * each iterator
   * iterative loop 
      * example: 10 to 1
        * ```while...end```
        * ```for...downto...do...end```
        * ```downto...do...end```
        * Range operator with each iterator
          * Range operator ```..``` can only increment, not decrement
        * ```10.times do...end```
   * conditional loops
      * ```begin...end while```
      * ```while...do...end```
      * ```begin...end until```
      * ```until...do...end```
      * ```loop do...end```
        * spin loop example  
7. Arrays
   * Array Initialization
      * initialize array by index
      * array length
      * enumerate all elements
   * Array Enumeration 
      * declare and initialize array
      * enumerate array by collection loop
8. Associative Arrays
   * Associative Array Initialization
      * initialize associative array by key
      * enumerate all keys
      * enumerate all values
   * Associative Array Enumeration
      * declare and initialize associative array
      * merge two associative arrays
      * enumerate associative array by key
9. Subroutine
   * Subroutine that prints out formatted date
10. Arguments
    * Process 2 arguments
      * test number of arguments
      * usage-like output on correct # of arguments
      * Ruby: need to convert default string to perform math
    * Print all arguments
      * ```for...in``` to loop until length of ```ARGV``` array
      * demonstrate ```Array.shift``` method
    * Print all arguments in reverse order
      * use ```downto``` to decrement through ```ARGV``` array
11. Parameters
	* Process n number of parameters
	  * print summation of all parameters added up
	  * ```each``` iterator method
12. Function
    * Return integer
      * demonstrates by summing up all integers and returning sum
    * Return string
      * demonstrates by capitalize (upper case) a string
