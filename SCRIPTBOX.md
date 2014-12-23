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
 * using `which` or `command` (Unix/Linux)

## Tested Operating Systems

These scripts should work on any Unix, Linux, or Windows systems provided the required tools, shells, application virtual machines, and scripting environments are available.  Unix is inclusive of SVR4 Unixes (Solaris), BSD Unixes (FreeBSD), and Mac OS X (which bundles BSD flavored tools and partial BSD flavored configuration environemnt).

These scripts have been specifically ad-hoc tested:
* **Mac OS X 10.8.5 (*Snow Leopard*)**
* **Cent OS 6.5**
* **Windows 7 (*Windows NT 6.1*)**.  

Some limited testing has been done on
* **Fedora 20 (*Heisenbug*)**
* **Ubuntu 12.04 LTS (*Precise Pangolin*)**.

## Required Packages

On any system, these are the needed tools:

* **Application Virtual Machine**: Java SE Runtime Environment (`java`)
* **Command Line Tools**: `awk`, `bc`, `command` `cut`, `data`, `env`, `expr`, `grep`, `printf`, `sed`, `seq`, `tr`, `which`, `wc`
* **Shell Environments**: `dash`, `bash`, `ksh`, `tcsh`
* **Scripting Languages**: `awk`, `groovy`, `perl`, `php`, `python`, `ruby`, `tclsh`

Most Linux and Unix systems will come bundled with most of these tools, or have package management or ports systems that allow for easy access.  For Mac OS X and Windows, there can be some challenges, so the guidelines below may help get the needed packages.

# Installation Notes

## Mac OS X 10.8.5 (Snow Leopard)

Mac OS X 10.8.5 comes with basics shells (ksh, csh, bash) and Unix tools required for most of these tutorials.  For GNU versions of some of the tools, and for updated versions of shells or scripting environments, you can use package managers, such as:

* [Homebrew](http://brew.sh/)
* [MacPorts](https://www.macports.org/)
* [Rudix](http://rudix.org/)

Before getting package managers, you'll want to install [XCode](https://developer.apple.com/xcode/), XCode command line tools, and [Java for OS X](http://support.apple.com/kb/DL1572)

Note that Groovy requires that the Java environment is installed in order to function. Groovy 2.3 works best with Oracle JDK 7 and above, as JDK 6 will output error messages that NIO is not available.

* [Oracle JDK (Java)](http://www.oracle.com/technetwork/java/javase/downloads/index.html)
  * [JDK 7](http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html)
  * [JDK 8](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)

Mac OS X 10.8.5 Snow Leopard comes with the following scripting tools:

* Awk 20070501 (BSD)
* Perl 5.12.4
* PHP 5.3.28
* Python 2.7.2
* Ruby 1.8.7
* Shells
  * bash 3.2.48
  * csh (tcsh) 6.17
  * ksh 93u 20011-02-08
* TCL (tclsh) 8.5

Beyond AWK, the following tools required for these shell scripting tutorials are included:

* bc 1.06 (GNU)
* cut (BSD)
* date (BSD)
* expr (BSD)
* grep 2.5.1 (BSD)
* printf (BSD)
* sed (BSD)
* seq (BSD)
* tr (BSD)
* wc (BSD)

### Homebrew

With Homebrew installed, you can install updated versions of some of these tools:

#### Scripting Languages

Note, these are versions as of Dec 21, 2014.

* Awk 4.1.1 (GNU) `brew install gawk`
* Groovy 2.3.7 `brew install groovy`
* Perl 5.20.1 `brew install perl`
* Python 2.7.9 `brew install python`
* Ruby 2.1.5 `brew install ruby`

### Shells

* Bash 4.3.30 `brew install bash`
* Dash 0.5.7 `brew install dash`
* Korn Shell ksh-93u+ (AT&T) `brew install ksh`
* C Shell 6.18.01 `brew install tcsh`

### Utilities

* sed 4.2.2 (GNU) `brew install gnu-sed`

## Windows 7 (Windows NT 6.1)

Some of these command may require running either PowerShell console or Command Shell (cmd.exe) in privileged mode: right click on `cmd.exe` or `powershell.exe` and select `Run as administrator`.

### Environments and Packages

Windows has at least four environments to get shell and shell utilities:

 * [Cygnus Windows (CygWin)](https://www.cygwin.com/) - a simulated Unix environment and can call DOS commands in addition to tools built under CygWin.  Combined with package installer cyg-apt, you can install any missing components.
 * [MSYS-Git](https://msysgit.github.io/) (GitBash) - Git, Bash, and a minimal set of GNU tools ported to Windows using MinGW.
 * [UWIN](http://www2.research.att.com/~astopen/download/uwin/uwin.html) - Korn shell and official AT&T Unix Korn utilities, along with some open source utilities bundled up into this environment.
 * [GNUWin32](http://gnuwin32.sourceforge.net/) - GNU utilities ported directly to Windows and can run under Windows command shell (`cmd.exe`)

Outside of these shell environments, packages can be downloaded individually, or installed through a package management like [Chocolately](https://chocolatey.org/):


### Scripting Languages (All Environments)

These are individual packages that can be installed independently of any environment.

#### AWK

[GnuWin32 Gawk](http://gnuwin32.sourceforge.net/packages/gawk.htm) will work in all environments:

 * http://gnuwin32.sourceforge.net/packages/gawk.htm

As an alternative to installing these types of tools in the default location of `C:\Program Files (x86)\GnuWin32`, you can do a silent background install using this, in a privileged command prompt:

```Batch
C:\> cd %USERPROFILE%\Downloads
C:\Users\riker\Downloads> gawk-3.1.6-1-setup.exe /dir=C:\GnuWin32 /verysilent
C:\Users\riker\Downloads> setx /M PATH "%PATH%;C:\GnuWin32"
```

#### Groovy

Groovy can be installed from the source:

* http://groovy.codehaus.org/Download

Groovy can also be installed with [Chocolately](https://chocolatey.org/):

```Batch
C:\> choco install groovy
```

Note that Groovy requires that Java SE Runtime Environment is available.  This can be downloaded from Sun:

* Oracle Java SE Homepage: http://www.oracle.com/technetwork/java/javase/overview/index.html

#### Perl

There are two popular packages for installing Perl on Windows:

 * **ActivePerl** - http://www.activestate.com/activeperl/downloads
 * **Starberry Perl** - http://strawberryperl.com/

ActivePerl can be installed through [Chocolately](https://chocolatey.org/):

```Batch
C:\> choco install activeperl
```

StrawberryPerl can be installed through [Chocolately](https://chocolatey.org/):

```Batch
C:\> choco install strawberryperl
```

#### PHP

PHP can be unzipped and manually copied to a location to a desired location:

   * PHP on Windows - http://windows.php.net/

PHP can be installed through [Chocolately](https://chocolatey.org/):

```Batch
C:\> choco install php
```

#### Python

Python is available from the the Python website or as ActivePython:

 * Python - https://www.python.org/downloads/windows/
 * ActivePython - http://www.activestate.com/activepython

The Python from the source can be through [Chocolately](https://chocolatey.org/):

```Batch
C:\> choco install python2
```

#### Ruby

Ruby can be installed through Ruby Installer or PIK.  

 * Ruby Installer - http://rubyinstaller.org/
 * PIK - https://github.com/vertiginous/pik

These can be installed through [Chocolately](https://chocolatey.org/):

```Batch
choco install ruby
choco install pik
```

#### TCL (Tool Command Language) or *Tickle*

ActiveTCL is available from ActiveState:

* ActiveTCL - http://www.activestate.com/activetcl

This can alternatively be installed using [Chocolately](https://chocolatey.org/):

```Batch
C:\> choco install activetcl
```

### MSYS-Git Environment

The Git Bash ([MSYS-Git](https://msysgit.github.io/)) environment comes with the following tools:

* :package: awk 3.0.4 (GNU awk)
* :package: cut 2.0 (GNU text utilities)
* :package: date 2.0 (GNU shell utilities)
* :package: expr 2.0 (GNU shell utilities)
* :package: grep 2.4.2 (GNU grep)
* :package: printf
* :package: sed 4.2.1 (GNU sed)
* :package: tr 2.0 (GNU text utilities)
* :package: wc 2.0 (GNU text utilities)

The MSYS-GIT environment also somes with the following environments:

* :package: perl 5.8.8
* :package: PHP 5.5.13
* :package: TCL 8.5

#### Shells

For the missing shell tools, you'll need to download them and make sure that they are in the path:

* bc (download from http://gnuwin32.sourceforge.net/packages/bc.htm)
* seq (download from http://gnuwin32.sourceforge.net/packages/coreutils.htm) `choco install gnuwin`

### UWIN Environment

The UWIN environment comes with the tools:

* :package: awk
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

The UWIN also comes with these environments:

 * :package: csh

### CygWin Environment

Download and install the appropriate CygWin environment.  These instructions are for 64-bit version: `setup-x86_64.exe`.  Run through the setup and select the defaults. Assuming that the setup program was installed in your Downloads folder, run CygWin64 Terminal from Start menu and then run these commands to get `apt-cyg` wrapper:

```bash
$ cd $USERPROFILE/Downloads
$ ./setup-x86_64.exe -q -P wget
$ wget http://apt-cyg.googlecode.com/svn/trunk/apt-cyg
$ chmod +x apt-cyg
$ mv apt-cyg /usr/local/bin/
```

The default CygWin 1.7.33 environment has the following tools:

* :package: awk 4.1.1 (GNU)
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

Also, CygWin 1.7.33 has the following scripting environments:

  * :package: dash
  * :package: bash 4.1.17

#### Shells

* :package: bc 1.06.95: `apt-cyg install bc`
* :package: C Shell 6.18.01 (Astron) `apt-cyg install tcsh`

#### Scripting Languages

* :package: Perl 5.14.4 `apt-cyg install perl`
* :package: PHP 5.5.19 `apt-cyg install php`
* :package: Python 2.7.8 `apt-cyg install python`
* :package: Ruby 2.0.0p598 (2014-11-13) `apt-cyg install ruby`
* :package: TCL 8.5.11 `apt-cyg install tcl`

##### Ruby Version Manager (RVM)

Alternatively, Ruby can be compiled and installed using RVM, which has been successfully used with CygWin.

* [RVM](https://rvm.io/)
* [How to install RVM on Windows using cygwin](http://www.tiplite.com/how-to-install-rvm-on-windows-using-cygwin/)

### PowerShell Environment

PowerShell is bundled with Windows 7, and PowerShell 3.0 comes with Windows 7 SP 1.  From the command-shell `CMD.EXE`, you can run PowerShell scripts using this command:

```Batch
C:\> powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File myscript.ps1
```

### Windows Scripting Host Environment

WSH 5.8 is bundled with Windows 7 and comes with JScript and VBScirpt.  From the command-shell `CMD.EXE`, you can run such scripts like this:

```Batch
C:\> cscript //NoLogo myscript.js
C:\> cscript //NoLogo myscript.vbs
```
