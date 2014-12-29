# Scripting Box

© Joaquin Menchaca, 2014

## Overview

This is my cumulative installation guide to getting scripting languages for your platform.

### Required Knowledge

You'll need to be confortable using the shell environment, whether on Windows or Linux/Unix environment.  You should be able to do typical tasks like:

 * interacting with shell environment
   * sourcing shell scripts (Unix/Linux)
   * configure shell environment: `.profile`, `.bashrc`
 * configuring environment variables
   * user and system environment (Windows)
   * exporting environment variables (Unix/Linux)
   * adjusting `PATH`
 * creating symbolic links
 * using `which` or `command` or `env` (Unix/Linux)
 * escalating privileges
   * `sudo`  (Unix/Linux)
   * `Run as Administrator` (Windows)

## Tested Operating Systems

These scripts should work on Unix, Linux, and Windows.

* Linux
  * :dvd: **Cent OS 6.5**
  * :dvd: **Fedora 20 (*Heisenbug*)**
  * :dvd: **Ubuntu 12.04 LTS (*Precise Pangolin*)**
* Mac OS X
  * :dvd: **Mac OS X 10.8.5 (*Snow Leopard*)** with XCode 5.1.1
    * :package: Homebrew
  * :dvd: **Mac OS X 10.9.5 (*Maverick*)** with XCode 6.1
    * :package: Homebrew
* Windows
  * :dvd: **Windows 7 (*Windows NT 6.1*)**
    * :package: CygWin
  * :dvd: **Windows 7 (*Windows NT 6.1*)**
    * :package: MSYS
    * :package: GNUWin32 tools


## Required Packages

On any system, these are the needed tools:

* **Application Virtual Machine**: Java SE Runtime Environment (`java`)
* **Command Line Tools**: `awk`, `bc`, `command` `cut`, `data`, `env`, `expr`, `grep`, `printf`, `sed`, `seq`, `tr`, `which`, `wc`
* **Shell Environments**: `dash`, `bash`, `ksh`, `tcsh`
* **Scripting Languages**: `awk`, `groovy`, `perl`, `php`, `python`, `ruby`, `tclsh`

Most Linux and Unix systems will come bundled with most of these tools, or have package management or ports systems that allow for ease to download and install these tools and environments.  

For Mac OS X and Windows, there can be some challenges, so the guidelines below may help get the needed packages.

# Installation Notes

## Mac OS X 10.8.5 (Mountain Lion) Notes

*Mountain Lion* includes GNU bc 1.06 and BSD flavors of cut, date, expr, grep 2.5.1, printf, sed, seq, tr, and wc.  *Mountain Lion* includes includes the following scripting languages:

* :package: Awk 20070501 (BSD)
* :package: Perl 5.12.4
* :package: PHP 5.3.28
* :package: Python 2.7.2
* :package: Ruby 1.8.7
* :shell: Shells
  * :package: bash 3.2.48
  * :package: csh (tcsh) 6.17
  * :package: ksh 93u 2011-02-08
* :package: (tclsh) 8.5

## Mac OS X 10.9.5 (Maverick) Notes

*Maverick* has some of the basic packages required (similar to *Mountain Lion*) with some newer versions:

* :package: Perl 5.16.2
* :package: PHP 5.4.24
* :package: Python 2.7.5
* :package: Ruby 2.0.0p247
* :shell: Shells
  * :package: bash 3.2.51

## Mac OS X Packages

There are a few package managers, but these few have capture my interest to document:

### Homebrew

[Homebrew](http://brew.sh/) - single-user package manager with rich community support.

### MacPorts

[MacPorts](https://www.macports.org/) - system wide package manager with large robust repository of packages.

### Rudix

[Rudix](http://rudix.org/) is a relatively new comer and supports Mac OS X native package format for installing applications.

## Windows Environments

These are environments provide popular shells available on Linux and UNIX (SVR4 or BSD) on Windows.

### Cygnus Windows (CygWin)

[CygWin](https://www.cygwin.com/) simulates a Unix-like environment with popular UNIX tools that were ported to Windows using the CygWin library. Within the CygWin environment, all the needed tools and scripting languages can be installed easily.

The default CygWin 1.7.33 environment has the following tools:

* Tools:
  * :package: bc
  * :package: cut (GNU Core Utils 8.23)
  * :package: date (GNU Core Utils 8.23)
  * :package: expr (GNU Core Utils 8.23)
  * :package: grep 2.21 (GNU)
  * :package: printf (GNU Core Utils 8.23) `usr/bin/printf`
  * :package: sed 4.2.2 (GNU)
  * :package: seq (GNU Core Utils 8.23)
  * :package: tr (GNU Core Utils 8.23)
  * :package: wc (GNU Core Utils 8.23)
* Scripting Languages:
  * :package: AWK 4.1.1 (GNU)
  * :package: dash
  * :package: bash 4.1.17

### MSYS

MSYS, which is bundled with  [MSYS-Git](https://msysgit.github.io/) (GitBash), provides Bash and some popular GNU tools.

The Git Bash ([MSYS-Git](https://msysgit.github.io/)) comes bundled with the following:

* Tools:
  * :package: cut (GNU text utilities 2.0)
  * :package: date (GNU text utilities 2.0)
  * :package: expr (GNU text utilities 2.0)
  * :package: grep 2.4.2 (GNU grep)
  * :package: printf
  * :package: sed 4.2.1 (GNU sed)
  * :package: tr 2.0 (GNU text utilities 2.0)
  * :package: wc 2.0 (GNU text utilities 2.0)
* Scripting Languages:
  * :package: awk 3.0.4 (GNU awk)
  * :package: perl 5.8.8
  * :package: PHP 5.5.13
  * :package: TCL 8.5

### UWIN

[UWIN](http://www2.research.att.com/~astopen/download/uwin/uwin.html) provides a Korn shell environment with some popular Unix tools.The [UWIN](http://www2.research.att.com/~astopen/download/uwin/uwin.html) environment comes with the tools:

* Tools:
  * :package: bc 1.0.4 (FSF)
  * :package: cut (AT&T Research) 2010-08-11
  * :package: date (AT&T Research) 2011-01-27
  * :package: expr (AT&T Research) 2010-08-11
  * :package: grep (AT&T Research) 2012-05-07
  * :package: printf (AT&T Research) 2009-02-02 `/usr/bin/printf`
  * :package: sed (AT&T Research) 2012-03-28
  * :package: seq (AT&T Labs Research) 2012-04-14
  * :package: tr (AT&T Labs Research) 2012-05-31
  * :package: wc (AT&T Research) 2009-11-28
* Scripting Languages:
  * :package: awk
  * :package: csh

### GNUWin32

[GNUWin32](http://gnuwin32.sourceforge.net/) are popular GNU utilities that are ported directly to Windows.  They can run under the Windows Command Shell (`cmd.exe`).

## Windows Packages

### Apt-Cyg

Apt-Cyg is a simple wrapper script that uses the existing CygWin environment to install packages.  Within CygWin environment, you can acquire apt-cyg using something like this:

```Bash
$ cd $USERPROFILE/Downloads
$ ./setup-x86_64.exe -q -P wget
$ wget http://apt-cyg.googlecode.com/svn/trunk/apt-cyg
$ chmod +x apt-cyg
$ mv apt-cyg /usr/local/bin/
```

Note that the above example uses 64-bit version of the CygWin setup program.

### Chocolately

[Chocolately](https://chocolatey.org/) are scripts that pull software down from the Internet and install them locally within the [Chocolately](https://chocolatey.org/) system.  [Chocolately](https://chocolatey.org/) requires [PowerShell](http://technet.microsoft.com/en-us/scriptcenter/powershell.aspx) and [NuGet](https://www.nuget.org/).  The current instructions (as of December 2014) for installing [Chocolately](https://chocolatey.org/) are:

```Batch
@powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin
```

# Installation Guides

## Linux

* [Ubuntu](ubuntu.md) - *Precise Pangolin*

## Mac OS X

* [OS X with Homebrew](homebrew.md) - should work for *Mountain Lion* and *Maverick*

## Windows

* [Windows 7](windows7.md)
