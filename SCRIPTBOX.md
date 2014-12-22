# Scripting Box

© Joaquin Menchaca, 2014

## Overview

This is my cumulative installation guide to getting scripting languages for your platform.


### Required Knowledge

You should be familiar with how to configure and interact with the shell environment.  This includes configuring environment variables, like PATH.


## Installation Guide: Cent OS 6.5 (Red Hat Enterprise Linux)

### AWK
### Batch (Command Shell)
### Groovy
### Perl
### PHP
### PowerShell
### Python
### Ruby
### Shells
#### Bourne Again Shell (bash)
#### C Shell (csh)
#### Korn Shell (ksh)
#### POSIX Shell (sh)
### TCL (Tool Command Language)
### WSH (Windows Scripting Host)
#### JScript
#### VBScript

## Installation Guide: Ubuntu

### AWK
### Batch (Command Shell)
### Groovy
### Perl
### PHP
### PowerShell
### Python
### Ruby
### Shells
#### Bourne Again Shell (bash)
#### C Shell (csh)
#### Korn Shell (ksh)
#### POSIX Shell (sh)
### TCL (Tool Command Language)
### WSH (Windows Scripting Host)
#### JScript
#### VBScript

## Installation Guide: Mac OS X 10.8.5

OS X 10.8.5 SnowLeopard comes with support for popular scripting languages, shell environments, and BSD Unix tools.  These tools are adequate for running most of these scripts, but you might want to update or replace some tools.

There are some open source package managers that can be used to update some of these tools, such as:

* [Homebrew](http://brew.sh/)
* [MacPorts](https://www.macports.org/)
* [Rudix](http://rudix.org/)

[Homebrew](http://brew.sh/) and [MacPorts](https://www.macports.org/) require XCode and XCode command lines tools to be installed as a prerequisite.

### AWK

OS X 10.8.5 comes bundled with BSD Awk version 20070501.  Some awk tutorial scripts will not work well with BSD Awk, and so you will need to get Gawk (GNU AWK).

You can install Gawk 4.1.1 using Homebrew:

```bash
brew install gawk
```

### Groovy
### Perl
### PHP
### PowerShell
### Python
### Ruby
### Shells
#### Bourne Again Shell (bash)
#### C Shell (csh)
#### Korn Shell (ksh)
#### POSIX Shell (sh)
### TCL (Tool Command Language)

## Installation Guide: Windows 7 (Windows NT 6.1)

Numerous scripts will require some sort of Unix shell environment.  To get access to such tools for free, you can install Mingw compilers and MSYS tools.  An easy way to get access to these tools is to use GitBash tools, which can be downloaded from http://git-scm.com/downloads or https://msysgit.github.io/.  Either of these locations will come with an installer, e.g. `Git-1.9.2-preview20140411.exe`.

### AWK

You can get a basic version of Gawk with the GitBash which bundles the MSYS environment.  This comes with GNU Awk 3.0.4.

### Batch (Command Shell)

To no surprise, Windows comes bundled with the command shell, which you can run by going to the Start Menu and typing: `cmd`.

### Groovy

Groovy requires Java Virtual Machine.  Apple supplies Java 6, but it it recommended to use a later version, such as Java 7.

* Oracle JDK (Java) - http://www.oracle.com/technetwork/java/javase/downloads/index.html
  * JDK 7 - http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html
  * JDK 8 - http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html


### Perl
### PHP
### PowerShell

PowerShell 3.0 is integrated into Windows 7.  PowerShell scripts can be run using the command shell and typing something like:

```Batch
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File myscript.ps1
```

### Python

### Ruby

### Shells

The UNIX or Linux environments will bundle all of the required POSIX or GNU utilities needed for running these scripts.  On Windows, you will need to get environments to run these scripts.  Here are four sources (free) to get such environments and supplementary tools:

* [Cygnus Windows (CygWin)](https://www.cygwin.com/) - an environment that emulates a Unix-like environment on Windows.

* AT&T UWIN - provides Korn shell and corresponding POSIX toolset.  This is the best environment to test either pure POSIX shell or Korn shell scripts.
* GNUWin32 tools - GNU tools that work in Windows Command Shell environment
* [Minimalist GNU for Windows (MinGW) MSYS environment](http://www.mingw.org/wiki/MSYS) - a Bash shell and some GNU utilities.
* [MSYS-Git](https://msysgit.github.io/) - bundles Git tools and MSYS tools and is packaged is a simple easy installer.

The Shell Scripting Tutorials will need the following tools:

* awk
* bc
* cut
* date
* expr
* grep
* printf
* sed
* seq
* test
* tr
* wc
* [

The Git Bash (MSYS) environment comes with the following tools:

* awk 3.0.4 (GNU awk)
* cut 2.0 (GNU text utilities)
* date 2.0 (GNU shell utilities)
* expr 2.0 (GNU shell utilities)
* grep 2.4.2 (GNU grep)
* perl 5.8.8
* printf  (built into GNU Bash 3.1.0)
* sed 4.2.1 (GNU sed)
* test (built into GNU Bash 3.1.0)
* tr 2.0 (GNU text utilities)
* wc 2.0 (GNU text utilities)
* [ (built into GNU Bash 3.1.0)

The Git Bash environment is missing GNU bc and GNU seq.  These can be downloaded from:
* http://gnuwin32.sourceforge.net/packages/bc.htm
* GNU Core Utilities includes Seq - http://gnuwin32.sourceforge.net/packages/coreutils.htm


The UWIN environment comes with the tools:

* awk
* cut (AT&T Research) 2010-08-11
* date (AT&T Research) 2011-01-27
* expr (AT&T Research) 2010-08-11
* grep (AT&T Research) 2012-05-07
* printf
* sed (AT&T Research) 2012-03-28
* seq (AT&T Labs Research) 2012-04-14
* test (built into Korn shell)
* tr
* wc (AT&T Research) 2009-11-28
* [ (built into Korn shell)


#### Bourne Again Shell (bash)

You can get a basic version of Gawk with the GitBash which bundles the MSYS environment.  This comes with GNU bash, version 3.1.0(1)-release (i686-pc-msys).

The MSYS environment provides Bash 3.10, which is adequate for most of these tests.  The one notable exception is `bc`, which can be downloaded from GNUWin32 utilities.

* MSYS-Git - https://msysgit.github.io/
* GNU bc - http://gnuwin32.sourceforge.net/packages/bc.htm

#### C Shell (csh)
#### Korn Shell (ksh)

You can run Korn shell scripts using the UWIN environment.



#### POSIX Shell (sh)

The best environment for running POSIX Shell is the UWIN environment.

### TCL (Tool Command Language)
### WSH (Windows Scripting Host)

Windows Scripting Host 5.8 is integrated into Windows 7.

#### JScript

JScript is bundled with Windows Scripting Host.  JScripts can be run using the command shell and typing something like:

```Batch
cscript //NoLogo myscript.js
```

#### VBScript

VBScript is bundled with Windows Scripting Host. VBScripts can be run using the command shell and typing something like:
```Batch
cscript //NoLogo myscript.vbs
```
