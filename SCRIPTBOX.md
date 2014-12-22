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
   * exporting environment variables
   * adjusting `PATH`
 * creating symbolic links
 * using `which` or `command` (Unix/Linux)

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

* BSD Awk 20070501
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

Windows has at least four environments to get shell and shell utilities:

 * [Cygnus Windows (CygWin)](https://www.cygwin.com/) - a simulated Unix environment and can call DOS commands in addition to tools built under CygWin.  Combined with package installer cyg-apt, you can install any missing components.
 * [MSYS-Git](https://msysgit.github.io/) (GitBash) - Git, Bash, and a minimal set of GNU tools ported to Windows using MinGW.
 * [UWIN](http://www2.research.att.com/~astopen/download/uwin/uwin.html) - Korn shell and official AT&T Unix Korn utilities, along with some open source utilities bundled up into this environment.
 * [GNUWin32](http://gnuwin32.sourceforge.net/) - GNU utilities ported directly to Windows and can run under Windows command shell.  These can be added to the path of either UWIN (ksh) or MSYS (bash) to get access to these tools.

For other scripting environments, you can grab installers or zipped binaries from these sources:

 * Groovy
   * http://groovy.codehaus.org/Download
   * GVM: http://gvmtool.net/ (CygWin only)
 * Perl
   * https://www.perl.org/get.html
   * http://www.activestate.com/activeperl/downloads
   * http://strawberryperl.com/
 * PHP
   * http://windows.php.net/
 * Python
   * https://www.python.org/downloads/windows/
   * http://www.activestate.com/activepython
 * Ruby
   * http://rubyinstaller.org/
   * RVM: https://rvm.io/ (CygWin only)
     * [How to install RVM on Windows using cygwin](http://www.tiplite.com/how-to-install-rvm-on-windows-using-cygwin/)
   * PIK: https://github.com/vertiginous/pik
 * TCL
   * http://www.activestate.com/activetcl

Note that Groovy requires that the Java environment is installed in order to function. Groovy 2.3 works best with Oracle JDK 7 and above, as JDK 6 will output error messages that NIO is not available.

* [Oracle JDK (Java)](http://www.oracle.com/technetwork/java/javase/downloads/index.html)
  * [JDK 7](http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html)
  * [JDK 8](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)

### MSYS-Git Environment

The Git Bash (MSYS) environment comes with the following tools:

* awk 3.0.4 (GNU awk)
* cut 2.0 (GNU text utilities)
* date 2.0 (GNU shell utilities)
* expr 2.0 (GNU shell utilities)
* grep 2.4.2 (GNU grep)
* printf
* sed 4.2.1 (GNU sed)
* tr 2.0 (GNU text utilities)
* wc 2.0 (GNU text utilities)

The MSYS-GIT environment also somes with the following environments:

* perl 5.8.8
* PHP 5.5.13
* TCL 8.5

#### Shells

For the missing shell tools, you'll need to download them and make sure that they are in the path:

* bc (download from http://gnuwin32.sourceforge.net/packages/bc.htm)
* seq (download from http://gnuwin32.sourceforge.net/packages/coreutils.htm)

### UWIN Environment

The UWIN environment comes with the tools:

* awk
* bc 1.0.4 (FSF)
* cut (AT&T Research) 2010-08-11
* date (AT&T Research) 2011-01-27
* expr (AT&T Research) 2010-08-11
* grep (AT&T Research) 2012-05-07
* printf (AT&T Research) 2009-02-02 `/usr/bin/printf`
* sed (AT&T Research) 2012-03-28
* seq (AT&T Labs Research) 2012-04-14
* tr (AT&T Labs Research) 2012-05-31
* wc (AT&T Research) 2009-11-28

The UWIN also comes with these environments:

 * csh

### CygWin Environment

Download and install the appropriate CygWin environment.  These instructions are for 64-bit version: `setup-x86_64.exe`.  Run through the setup and select the defaults. Assuming that the setup program was installed in your Downloads folder, run CygWin64 Terminal from Start menu and then run these commands:

```bash
$ cd $USERPROFILE/Downloads
./setup-x86_64.exe -q -P wget
wget http://apt-cyg.googlecode.com/svn/trunk/apt-cyg
chmod +x apt-cyg
mv apt-cyg /usr/local/bin/
```

The default CygWin 1.7.33 environment has the following tools:

* awk 4.1.1 (GNU)
* bc
* cut 8.23 (GNU Core Utils)
* date 8.23 (GNU Core Utils)
* expr 8.23 (GNU Core Utils)
* grep 2.21 (GNU)
* printf 8.23 (GNU Core Utils) `usr/bin/printf`
* sed 4.2.2 (GNU)
* seq 8.23 (GNU Core Utils)
* tr 8.23 (GNU Core Utils)
* wc 8.23 (GNU Core Utils)

Also, CygWin 1.7.33 has the following scripting environments:

  * dash
  * bash 4.1.17

#### PowerShell

PowerShell is bundled with Windows 7, and PowerShell 3.0 comes with Windows 7 SP 1.  From the command-shell `CMD.EXE`, you can run PowerShell scripts using this command:

```Batch
  C:\> powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File myscript.ps1
```

#### Shells

* bc 1.06.95: `apt-cyg install bc`
* C Shell 6.18.01 (Astron) `apt-cyg install tcsh`

#### Scripting Languages

* Perl 5.14.4 `apt-cyg install perl`
* PHP 5.5.19 `apt-cyg install php`
* Python 2.7.8 `apt-cyg install python`
* Ruby 2.0.0p598 (2014-11-13) `apt-cyg install ruby`
* TCL 8.5.11 `apt-cyg install tcl`

#### Windows Scripting Host

WSH 5.8 is bundled with Windows 7 and comes with JScript and VBScirpt.  From the command-shell `CMD.EXE`, you can run such scripts like this:

```Batch
C:\> cscript //NoLogo myscript.js
C:\> cscript //NoLogo myscript.vbs
```
