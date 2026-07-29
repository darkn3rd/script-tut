# Scripting Tutorial: PowerShell

© Joaquin Menchaca, 2014

Version 1.5

## Overview

Powershell is Microsoft's new platform for scripting and automating Windows system.  It's an environment that runs on top of the **.NET platform**, and has access to the wealth of .NET libraries.  There's a built-in mechanism to access OLE libraries as well, so in that sense it can easily replace the limited **WSH** (**Windows Script Host**) environment that hosted **JScript** and **VBScript** amongst other languages for scripting chores.

### PowerShell Versions


| Edition | PowerShell Version | Release Year | Native OS / Companion               | Kernel | Underlying .NET Engine | Type   |
| :--------------------- | :------ | :--- | :-------------------------------------- | :----- | :--------------------- | :----  |
| **Windows PowerShell** | **1.0** | 2006 | Windows XP SP2<br>Windows Server 2003   | NT 5.2 | .NET Framework 2.0     | Legacy |
|                        | **2.0** | 2009 | Windows 7 <br>Windows Server 2008 R2    | NT 6.1 | .NET Framework 2.0 / 3.5 | Legacy |
|                        | **3.0** | 2012 | Windows 8 <br>Windows Server 2012       | 6.2<sup>1</sup> | .NET Framework 4.0 | Legacy |
|                        | **4.0** | 2013 | Windows 8.1<br>Windows Server 2012 R2   | 6.3<sup>1</sup> | .NET Framework 4.5 | Legacy |
|                        | **5.0** | 2015 | Windows 10 (1507)                       |  10<sup>2</sup> | .NET Framework 4.5.2 | Legacy |
|                        | **5.1** | 2016 | Windows 10 (1607), Windows 11 (All)<br>Windows Server 2016 / 2019 / 2022 / 2025 | 10<sup>2</sup> | .NET Framework 4.6+ | Legacy |
| **PowerShell Core**    | **6.0** | 2018 | Cross-platform | - | .NET Core 2.0 | Modern (EOL)  |
|                        | **7.0** | 2020 | Cross-platform | - | .NET Core 3.1 | Modern (EOL)  |
|                        | **7.2** | 2021 | Cross-platform | - | .NET 6.0 | Modern (EOL) |
|                        | **7.4** | 2023 | Cross-platform | - | .NET 8.0 | Modern (LTS) |
|                        | **7.5** | 2025 | Cross-platform | - | .NET 9.0 | Modern |
|                        | **7.6** | 2026 | Cross-platform | - | .NET 10.0 | Modern (LTS) |

**NOTES**
1. Microsoft removed using NT in internal version names.  As earlier DOS-based Windows operating systems were discontinued, there should be no more confusion between older Windows that runs on top of DOS, and Windows that run on the Windows NT kernel.
2. For marketing reasons, Microsoft changed the internal version to match the customer facing name of **Windows 10**.  With **Windows 11**, the internal version was left 10 to avoid breaking older installers. 

### Pash (deprecated)

Before the release of PowerShell Core, there was an Open Source reimplementation of Windows PowerShell for [Mono](http://www.mono-project.com/) dotnet implemenation.

* Pash (2019): https://github.com/Pash-Project/Pash

## Getting PowerShell

Powershell 7.x requires the dotnet CLR Runtime to operate as it is compiled bytecode.  There are two methods to install Powershell (`pwsh`):

* **Self-Contained Packages**: Installs a completely independent copy of PowerShell that embeds its own private, isolated version of the modern .NET runtime directly inside the application folder (`$PSHOME`). This means you can run the newest versions of PowerShell immediately without manually updating or installing any external .NET frameworks on your machine.

* **Framework-Dependent Packages**: Installs PowerShell as a global app managed directly by an existing .NET SDK on your system using the `dotnet tool install --global PowerShell` command. This method drastically minimizes the installation download size, but it will fail or crash if you do not have the matching global version of the modern .NET runtime pre-installed on the host machine.

These instructions will cover the self-container package.

### Windows 11: Chocolatey

PowerShell 5.1 (`powershell.exe`) is bundled into Windows 11.  You can get the latest PowerShell 7.x (`pwsh.exe`) with **Chocolatey**.

```pwsh
# Install PowerShell 7.x (pwsh.exe)
gsudo choco install -y powershell-core
```

### macOS: HomeBrew

You can install the latest PowerShell 7.x (`pwsh`) with **Homebrew**.

```bash
# Install PowerShell 7.x (pwsh)
brew install powershell
```

### Ubuntu 22.04 Jammy Jellyfish

You can install the latest PowerShell 7.x (`pwsh`) using Microsoft's Debian repository. 

```bash
# Configure Microsoft Third-Party Debian Repository
# Debian Package (packages-microsoft-prod.deb) installs:
# * Remote Package Repo Config: /etc/apt/sources.list.d/microsoft-prod.list
# * Package Trusted Signing Key: /etc/apt/trusted.gpg.d/microsoft-prod.gpg
wget -q https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb \
  -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb

# Add Microsoft packages list
sudo apt-get update

# Install PowerShell 7.x (pwsh)
sudo apt-get install -y powershell
```

## Getting PowerShell on Mac OS X, Linux, and Unix

There is an open source equivalent to PowerShell called Pash.  The prerequisite for this is an installation of Mono, as Mono provides the virtual machine (JIT compiler) and library support to run .NET applications.

* Mono: http://www.mono-project.com/



## Testing

* 📀 *__Windows 7 Home__* (`Microsoft Windows NT [Version 6.1]`)
  * 🐚 PowerShell 2.0 (DotNet 2.0)
* 📀 * Mac OS X "Mountain Lion" 10.8.5
  * 🐚 Pash (Mono 3.4.0 MDK)
* 📀 *__Windows 11 Home__* (`Microsoft Windows NT [Version 10.0.26200.8875]`)
  * 🐚 PowerShell 5.1.26100.8875 (DotNet 4.0.30319.42000)
  * 🐚 Command Shell (cmd.exe)

## Retreiving the Version

* Command Shell
  ```batch
  REM Print Powershell Version
  for /f "delims=" %a in ( ^
    'powershell "get-host | select Version | ft -hide"' ^
  ) do @echo %a

  REM Print DotNet Version
  for /f "tokens=2" %a in ( ^
    'powershell "$PSVersionTable" ^| findstr CLRVersion' ^
  ) do @echo %a
  ```

## Topics with Details 

This covers notes regarding each section.

1. Output
   * output text to standard out
     * ```Write-Host```
     * ```Write-Output```
     * naked string (last string is always ends up in standard output)
   * output text to standard error
     * ```[Console]::Error.WriteLine()```
2. Variables
   * output variables using string interpolation
     * demonstrate using ```Set-Variable```
     * demonstrate using ```=``` operator
3. Arithmetic
   * show basic integer arithmetic
   * show basic boolean evaluation
   * show basic floating math with exponential
   * show basic math function like cosine
4. Input
   * input a string
     * demonstrate using ```Read-Host```
5. Branch
   * test a string using ```if```
   * test a string using ```if``` to determine slice on anonymous list
   * test a number range
   * test a number for menu selection
     * demonstrate numerical comparison
     * demonstrate string comparison
   * multi-way test on a number for menu selection
     * demonstrate numerical comparison
     * demonstrate string comparison   
   * multi-way test on single character with pattern matching 
   * test on single character with pattern matching
6. Looping
   * collection loops on directory listing and ```PsIsContainer``` to test for a directory
     * demonstrate using ```foreach()``` collection loop
     * demonstrate piping into ```ForEach-Object``` collection loop
     * demonstrate using ```switch``` to process the collection
   * count style loop
     * demonstrate using range operation ```..``` piped into ```foreach``` 
     * demonstrate using ```foreach``` with a range operation ```..```
     * demonstrate using general ```for``` looping construct 
     * demonstrate using ```while``` looping construct
   * conditional loop
     * demonstrate using ```do...while()``` loop construct
     * demonstrate using ```do...until()``` loop construct
     * demonstrate using ```while()``` loop construct
   * spin loop
     * demonstrate using ```do...while(1)``` with ```break``` to exit loop
   * spin loop with ability to skip invalid input
     * demonstrate using ```do...while(1)``` with ```continue``` to skip to next iteration
7. Arrays
   * Array Initialization
      * initialize array one element at a time
        * demonstrate using concatenation operator ```+``` to append an element to an array
      * array length with ```length`` property
      * enumerate all elements
   * Array Enumeration 
      * declare and initialize array
      * enumerate array one element at a time
        *  demonstrate using collection loop with ```foreach```
      * enumerate array with an index
        *  demonstrate using general ```for``` to increment the index
8. Associative Arrays
   * Associative Array Initialization
      * initialize associative array by key
      * enumerate all keys
      * enumerate all values
   * Associative Array Enumeration
      * declare and initialize associative array
      * merge two associative arrays
      * enumerate associative array by key
        *  demonstrate using collection loop with ```foreach```
9. Subroutines
   * demonstrate declaring and calling subroutine
     *  demonstrate showing formatted date with ```Get-Date -UFormat```
   * demonstrate subroutine referencing global variables
     *  this shows using ```$global:variable```
   * demonstrate subroutine explicitly using local variables
     *  this shows using ```$global:variable```
10. Arguments
    * demonstrate processing 2 arguments
      * **NOTES:** Retrieving the script name can be done using ```$MyInvocation.MyCommand.Name```
    * demonstrate printing all arguments
      * use collection loop ```foreach```
      * use count style loop with ```for``` and a range built using ```..```
    * demonstrate printing arguments in reverse order
      * use count style loop with ```for``` and a range built using ```..```
11. Parameters
    * demonstrate passing a single parameter
      * demonstrate controlling degrees of significance with decimal numbers 
    * demonstrate passing unlimited parameters
12. Exiting
    * demonstrate exiting with error code to communicate status
13. Functions
    * demonstrate function that returns an int
    * demonstrate function that returns a string
      * string is capitalized using ```ToUpper()``` method
    * demonstrate function that returns an array


## Further Reading

* [Install PowerShell 7 on Ubuntu](https://learn.microsoft.com/powershell/scripting/install/install-ubuntu?view=powershell-7.6)
* [Understanding The Way Windows Versions Its Operating Systems](https://learn.microsoft.com/answers/questions/5521945/understanding-the-way-windows-versions-its-operati)