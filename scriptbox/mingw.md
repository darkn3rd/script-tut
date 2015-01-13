# MinGW Installation Path

@2014 Joaquin Menchaca

## Overview

This installation path will provide a set of tools and scripting environments that can be executed from the **Windows Command Shell** `cmd.exe`.  

Many of these tools have been ported to Windows through [MinGW (Minimalist GNU for Windows)](http://www.mingw.org/), which offers tools and libraries that are commonly available in Unix and Linux, but not available in Windows.

Additional utilities will be installed using [GNUWin32](http://gnuwin32.sourceforge.net/).  These utilities have been directly ported to Windows using Microsoft C-runtime libraries.

The installations will organized into the following groups:

* Baseline Utilities
* General Scripting Languages
* Shell Scripting Languages
  * POSIX Shell Environment
  * GNU Shell Environment
* Windows Scripting Languages
  * Windows Command Shell
  * PowerShell

With these, Windows will have four execution environments:

* [MSYS](http://mingw.org/wiki/msys) (GNU Bash)
* Windows Command Shell
* Windows PowerShell
* [AT&T UWIN Environment](http://www2.research.att.com/~astopen/download/uwin/uwin.html) (Korn Shell and POSIX Shell)

The installation has four components:

* Baseline Utilities
* Scripting Languages
* Shell Environments

# Installations

## Baseline Utilities

These utilities are useful for doing basic chores or providing essential utilities when they are not available from either [UWIN](http://www2.research.att.com/~astopen/download/uwin/uwin.html) or [GNU Bash](https://msysgit.github.io/). It also provides GNU Awk scripting language as well.

* [GNU Installer](http://sourceforge.net/projects/getgnuwin32/files/) - a set of scripts that facilitate downloading, installing, and updating packages.
* [GNU Packages](http://gnuwin32.sourceforge.net/packages.html) - individual components that are packaged as executable self-installers with both GUI and silent-install command line mode.
* [Wikipedia: GNUWin32](https://en.wikipedia.org/wiki/GnuWin32)


## General Scripting Languages

### Perl (Strawberry)

Strawberry is an open source Perl distribution that includes C/C++ compilers (GCC from MinGW) and tools that are useful in building Perl libraries.

* [Strawberry Perl](www.strawberryperl.com) - Main website
  * [Strawberry Perl 5.20.1.1 (32-bit)](http://strawberryperl.com/download/5.20.1.1/strawberry-perl-5.20.1.1-32bit.msi)
  * [Strawberry Perl 5.20.1.1 (64-bit)](http://strawberryperl.com/download/5.20.1.1/strawberry-perl-5.20.1.1-64bit.msi)
* [Wikipedia: Strawberry Perl Entry](https://en.wikipedia.org/wiki/Strawberry_Perl)

### PHP

* [PHP Downloads](http://windows.php.net/download/) - General download area
  * [PHP 5.3.29 Installer (multithreaded)](http://windows.php.net/downloads/releases/php-5.3.29-Win32-VC9-x86.msi) - This is the latest release that has an installer (built using Visual C++ 9 runtime), which will automate numerous configurations, such as file associations.

### Python

* [Python Downloads](https://www.python.org/downloads/windows/) - general download area
  * [Python 2.7.9 (32-bit)] - (https://www.python.org/ftp/python/2.7.9/python-2.7.9.msi)
  * [Python 2.7.9 (64-bit)] - (https://www.python.org/ftp/python/2.7.9/python-2.7.9.amd64.msi)

### Ruby (Ruby Installer)

* [Ruby Installer](http://rubyinstaller.org/) - RubyInstaller website
  * [Ruby Installer Downloads](http://rubyinstaller.org/downloads/)

## GNU Shell Environment (Git-Bash)

This utility installs a GNU Bash shell using [MSYS](http://mingw.org/wiki/msys) environment as well as the Git utility needed to download Scripting-Tutorial code. It also bundles a few Unix-like utilities that were ported using [MinGW](http://www.mingw.org/).

This can be downloaded from one of these sites:

* [Git Download Site](http://www.git-scm.com/) - general Git download site that auto-detects the current running operating system.
* [Git for Windows](https://msysgit.github.io/) - website organized specifically for installing Git on Windows using [MSYS](http://mingw.org/wiki/msys) environment.

## POSIX Shell Environment (UWIN)

The UWIN environment provides that Korn shell, which also doubles as a POSIX shell when scripts source `sh`.

* [AT&T UWIN Overview](http://www2.research.att.com/~astopen/download/uwin/uwin.html)
  * [AST (AT&T Software Technology) Download Site](http://www2.research.att.com/~astopen/download/)
* [Wikipedia: UWIN](https://en.wikipedia.org/wiki/UWIN)
