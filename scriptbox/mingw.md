# MinGW Installation Path

@2014 Joaquin Menchaca

## Overview

This installation path will provide a set of tools and scripting environments that can be executed from the **Windows Command Shell** `cmd.exe`.  

Many of these tools have been ported to Windows through [MinGW (Minimalist GNU for Windows)](http://www.mingw.org/), which offers tools and libraries that are commonly available in Unix and Linux, but not available in Windows.

Additional utilities will be installed using [GNUWin32](http://gnuwin32.sourceforge.net/).  These utilities have been directly ported to Windows using Microsoft C-runtime libraries.

The installations will organized into the following groups:

1. Baseline Utilities
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

```Batch
C:\> cd %USERPROFILE%\Downloads\GetGnuWin32
C:\Users\Vagrant\Downloads\GetGnuWin32> download
C:\Users\Vagrant\Downloads\GetGnuWin32> install
C:\Users\Vagrant\Downloads\GetGnuWin32> cd C:\gnuwin32
C:\gnuwin32> update-links.bat
C:\gnuwin32> PATH=%PATH%;C:\gnuwin32
```

This installs the following tools (amongst others):

* :package: GNU Awk 3.1.6
* :package: bc 1.06
* :package: cut (GNU coreutils) 5.3.0
* :package: date (GNU coreutils) 5.3.0
* :package: env (GNU coreutils) 5.3.0
* :package: expr (GNU coreutils) 5.3.0
* :package: GNU grep 2.5.4
* :package: printf (GNU coreutils) 5.3.0
* :package: GNU sed version 4.2.1
* :package: seq (GNU coreutils) 5.3.0
* :package: tr (GNU coreutils) 5.3.0  
* :package: wc (GNU coreutils) 5.3.0
* :package: GNU which v2.20

## General Scripting Languages

### Perl (Strawberry)

Strawberry is an open source Perl distribution that includes C/C++ compilers (GCC from MinGW) and tools that are useful in building Perl libraries.

* [Strawberry Perl](www.strawberryperl.com) - Main website
  * [Strawberry Perl 5.20.1.1 (32-bit)](http://strawberryperl.com/download/5.20.1.1/strawberry-perl-5.20.1.1-32bit.msi)
  * [Strawberry Perl 5.20.1.1 (64-bit)](http://strawberryperl.com/download/5.20.1.1/strawberry-perl-5.20.1.1-64bit.msi)
* [Wikipedia: Strawberry Perl Entry](https://en.wikipedia.org/wiki/Strawberry_Perl)

```Batch
C:\Users\Vagrant> which perl
C:\Strawberry\perl\bin\perl.EXE
C:\Users\Vagrant> perl --version | grep -o "perl 5.*$"
perl 5, version 20, subversion 1 (v5.20.1) built for MSWin32-x86-multi-thread-64int
```

### PHP

* [PHP Downloads](http://windows.php.net/download/) - General download area
  * [PHP 5.3.29 Installer (multithreaded)](http://windows.php.net/downloads/releases/php-5.3.29-Win32-VC9-x86.msi) - This is the latest release that has an installer (built using Visual C++ 9 runtime), which will automate numerous configurations, such as file associations.

```batch
C:\Users\Vagrant>which php
C:\PHP\php.EXE
C:\Users\Vagrant>php --version | head -1
PHP 5.3.29 (cli) (built: Aug 15 2014 19:17:16)
```

### Python

* [Python Downloads](https://www.python.org/downloads/windows/) - general download area
  * [Python 2.7.9 (32-bit)] - (https://www.python.org/ftp/python/2.7.9/python-2.7.9.msi)
  * [Python 2.7.9 (64-bit)] - (https://www.python.org/ftp/python/2.7.9/python-2.7.9.amd64.msi)

```Batch
C:\Users\Vagrant> which python
C:\Python27\python.EXE
C:\Users\Vagrant> python --version
Python 2.7.9
```

### Ruby (Ruby Installer)

* [Ruby Installer](http://rubyinstaller.org/) - RubyInstaller website
  * [Ruby Installer Downloads](http://rubyinstaller.org/downloads/)

```
C:\Users\Vagrant> which ruby                                                                                                    C:\Ruby21\bin\ruby.EXE
C:\Users\Vagrant> ruby --version
ruby 2.1.5p273 (2014-11-13 revision 48405) [i386-mingw32]
```

## GNU Shell Environment (Git-Bash)

This utility installs a GNU Bash shell using [MSYS](http://mingw.org/wiki/msys) environment as well as the Git utility needed to download Scripting-Tutorial code. It also bundles a few Unix-like utilities that were ported using [MinGW](http://www.mingw.org/).

This can be downloaded from one of these sites:

* [Git Download Site](http://www.git-scm.com/) - general Git download site that auto-detects the current running operating system.
* [Git for Windows](https://msysgit.github.io/) - website organized specifically for installing Git on Windows using [MSYS](http://mingw.org/wiki/msys) environment.

```batch
C:\Users\Vagrant> which bash
C:\Git\bin\bash.EXE
C:\Users\Vagrant> bash --version | head -1
GNU bash, version 3.1.20(4)-release (i686-pc-msys)
```

The Git Bash ([MSYS-Git](https://msysgit.github.io/)) environment comes with the following tools:

* :package: awk 3.0.4 (GNU awk)
* :package: cut (GNU text utilities 2.0)
* :package: date (GNU text utilities 2.0)
* :package: expr (GNU text utilities 2.0)
* :package: grep 2.4.2 (GNU grep)
* :package: printf
* :package: sed 4.2.1 (GNU sed)
* :package: tr 2.0 (GNU text utilities 2.0)
* :package: wc 2.0 (GNU text utilities 2.0)

The MSYS-GIT environment also somes with the following scripting languages:

* :package: perl 5.8.8
* :package: PHP 5.5.13
* :package: TCL 8.5

## POSIX Shell Environment (UWIN)

The UWIN environment provides that Korn shell, which also doubles as a POSIX shell when scripts source `sh`.

* [AT&T UWIN Overview](http://www2.research.att.com/~astopen/download/uwin/uwin.html)
  * [AST (AT&T Software Technology) Download Site](http://www2.research.att.com/~astopen/download/)
* [Wikipedia: UWIN](https://en.wikipedia.org/wiki/UWIN)

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

## Post Installations

When configuration the `PATH` environment variable you may want to have GNUWin32 before or after Windows paths, depending on whether you want Windows versions of `date`, `sort`, `find` to take precedence. You could create Batch files for `wdate`, `wsort`, `wfind`, `gdate`, `gsort`, `gfind` to access the full absolute path and distinguish between two when needed.

```batch
C:\Users\Vagrant> echo %PATH% | tr ';' '\n'
C:\Python27\
C:\Python27\Scripts
C:\PHP\
C:\Windows\system32
C:\Windows
C:\Windows\System32\Wbem
C:\Windows\System32\WindowsPowerShell\v1.0\
C:\Program Files\Puppet Labs\Puppet\bin
C:\gnuwin32\bin
C:\Strawberry\c\bin
C:\Strawberry\perl\site\bin
C:\Strawberry\perl\bin
C:\Git\cmd
C:\Git\bin
C:\Ruby21\bin
```

In Git-Bash, the same environment will look like this:

```bash
bash-3.1$ echo $PATH | tr ':' '\n'
/c/Python27/
/c/Python27/Scripts
/c/PHP/
/c/Windows/system32
/c/Windows
/c/Windows/System32/Wbem
/c/Windows/System32/WindowsPowerShell/v1.0/
/c/Program Files/Puppet Labs/Puppet/bin
/c/gnuwin32/bin
/c/Strawberry/c/bin
/c/Strawberry/perl/site/bin
/c/Strawberry/perl/bin
/usr/cmd
/usr/bin
/c/Ruby21/bin
```

Note that in Git-Bash, `/usr` is the same as `/c/Git`.  

In the Git-Bash, you may want to put `/usr/bin` up front, as the both Windows and GNUWin32 tools will report incompatible Windows paths. For example:

```bash
bash-3.1$ /c/gnuwin32/bin/which ruby
c:\Ruby21\bin\ruby.EXE
bash-3.1$ /usr/bin/which ruby
/c/Ruby21/bin/ruby
```
