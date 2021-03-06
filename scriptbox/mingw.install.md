# Scripting Box: MinGW Installation Guide (32-bit)

© Joaquin Menchaca, 2015

## Overview

This installation guide covers installing components to create a ScriptBox for ***Windows Command Shell*** environment, using tools that were compiled using MinGW or Microsoft C Runtime.  These scripts should be able to run correctly within a ***Windows Command Shell*** `cmd.exe`.

## Notes

*To Choco or Not to Choco? That is the question.*  This install guide should be divided into a non-Choco guide, and a pure Choco-only guide.  The problem with the pure Choco, is that the Choco package may not exist, so we'll default to manual download until I contribute a choco package.

## Testing

Valid as of Jan 13, 2015.  After that, the Internet may change.

## 1. Configure PowerShell

Allow PowerShell to run scripts.  Like Duh?!?

```PowerShell
Set-ExecutionPolicy RemoteSigned
```

## 2. Install Package Management: Chocolately

As of January 2015, you can install Chocolately using this command.

### Using Command Shell
```Batch
@powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin

```

### Using PowerShell

```PowerShell
iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
```

## 3. Install WinSSHD

This piece is useful if installing ScriptBox into a Vagrant environment.  This will allow you to remote into Vagrant through `vagrant ssh` command after it is installed.

## 4. Install Core Utilities: GNUWin32

```Batch
C:\> cd %USERPROFILE%\Downloads\GetGnuWin32
C:\Users\Vagrant\Downloads\GetGnuWin32> download
C:\Users\Vagrant\Downloads\GetGnuWin32> install
C:\Users\Vagrant\Downloads\GetGnuWin32> cd C:\gnuwin32
C:\gnuwin32> update-links.bat
C:\gnuwin32> PATH=%PATH%;C:\gnuwin32
SETX PATH "%PATH%"
```

## 5. Install Scripting Langauges

### ActiveTCL

### PHP

Verification:

```batch
C:\Users\Vagrant>which php
C:\PHP\php.EXE
C:\Users\Vagrant>php --version | head -1
PHP 5.3.29 (cli) (built: Aug 15 2014 19:17:16)
```

### Python

Verification

```Batch
C:\Users\Vagrant> which python
C:\Python27\python.EXE
C:\Users\Vagrant> python --version
Python 2.7.9
```

### Ruby

```
C:\Users\Vagrant> which ruby                                                                                                    C:\Ruby21\bin\ruby.EXE
C:\Users\Vagrant> ruby --version
ruby 2.1.5p273 (2014-11-13 revision 48405) [i386-mingw32]
```

### Strawberry Perl


Verification:

```Batch
C:\Users\Vagrant> which perl
C:\Strawberry\perl\bin\perl.EXE
C:\Users\Vagrant> perl --version | grep -o "perl 5.*$"
perl 5, version 20, subversion 1 (v5.20.1) built for MSWin32-x86-multi-thread-64int
```

## 6. Install Bash (Bourne Again Shell) with MSYS-Git

The MSYS environment comes with GNU Bourne Again Shell `bash`.

## 7. Install Korn Shell (Ksh) with UWIN

The UWIN environment comes with a Korn Shell `ksh`, and also comes with POSIX shell `sh` and C-Shell `csh`.

## 8. Final Configurations

### Windows Command Shell Paths

The `%PATH%` environment variable is completely unique to your environment.  Thus this will need some customization for your particular environment.  

It is **important** to have GNUWin32 `%PATH_GNU%` before Bash `%PATH_BASH%` and Ksh `%PATH_KSH%`

```Batch
:: Example Paths of Popular Tools
SET PATH_CHOCO=%ALLUSERSPROFILE%\chocolatey\bin
SET PATH_PUPPET=C:\Program Files\Puppet Labs\Puppet\bin
SET PATH_TOOLS=%PATH_CHOCO%;%PATH_PUPPET%

:: Common Windows Directories (32-bit)
SET SYSDIR=%WINDIR%\system32
SET PATH_WINDOWS=%SYSDIR%;%WINDIR%;%SYSDIR%\Wbem;%SYSDIR%\WindowsPowerShell\v1.0\

:: Scriptng Languages
SET PATH_PYTHON=C:\Python27\;C:\Python27\Scripts
SET PATH_PHP=C:\PHP\
SET PATH_PERL=C:\Strawberry\perl\site\bin;C:\Strawberry\perl\bin;C:\Strawberry\c\binC:\Strawberry\c\bin
SET PATH_RUBY=C:\Ruby21\bin
SET PATH_SCRIPTING=%PATH_RUBY%;%PATH_PYTHON%;%PATH_PHP%;%PATH_PERL%

:: Bash Shell
SET MSYS_HOME=C:\Git
SET PATH_BASH=%MSYS_HOME%\cmd;C:\Git\bin

:: Ksh Shell
SET UWIN_HOME=C:\UWIN
SET PATH_KSH=%UWIN_HOME%\usr\bin

:: GNUWin32 Tools (Must Go Before Bash and Ksh)
SET GNUWIN_HOME=C:\gnuwin32
SET PATH_GNU=%GNUWIN_HOME%\bin



:: Configure Current Path
SET PATH=%PATH_GNU%;%PATH_TOOLS%;%PATH_SCRIPTING%;%PATH_WINDOWS%;%PATH_BASH%;%PATH_KSH%
SETX PATH "%PATH%"
```

## MSYS Shell Paths

In the MSYS environment, which is the GNU Bash shell, you want tools from the MSYS environment to be referenced first, as these tools support Unix-like paths that Bash needs.  You may want throw away the inherited PATH environment and manually manage the path.

```Bash
# Example Paths of Popular Tools
PATH_PUPPET=/c/Program Files/Puppet Labs/Puppet/bin
PATH_CHOCO=$(echo $ALLUSERSPROFILE | sed -r 's#([A-Z]):\\#/\L\1/#i')/chocolatey/bin
PATH_TOOLS=${PATH_CHOCO}:${PATH_PUPPET}

# Common Windows Directories (32-bit)
WIN=/c/Windows/
SYS=${WIN}/system32
PATH_WINDOWS=${SYS}:${WIN}:${SYS}/Wbem:${SYS}/WindowsPowerShell/v1.0/

# Scripting Languages
PATH_PYTHON=/c/Python27/:/c/Python27/Scripts
PATH_PHP=/c/PHP/
PATH_PERL=/c/Strawberry/c/bin:/c/Strawberry/perl/site/bin:/c/Strawberry/perl/bin
PATH_RUBY=/c/Ruby21/bin
PATH_SCRIPTING=${PATH_RUBY}:${PATH_PYTHON}:${PATH_PHP}:${PATH_PERL}

# GNUWin32 Tools (should go after Bash and Ksh)
PATH_GNU=/c/gnuwin32/bin

# Ksh Shell
PATH_KSH=/c/UWIN/usr/bin

# Local Binary Reference (MUST GO FIRST)
USERBIN=/usr/bin:/usr/bin

# Configure Current Path
INHERITED_PATH=${PATH}
SET PATH=${USERBIN}:${PATH_BASH}:${PATH_KSH}:${PATH_TOOLS}:${PATH_SCRIPTING}:${PATH_WINDOWS}:${PATH_GNU}
export ${INHERITED_PATH}  # preserve for reference
export ${PATH}            # use the new path
```

## UWIN Shell Paths

```Bash
# Example Paths of Popular Tools
PATH_PUPPET="/C/Program Files/Puppet Labs/Puppet/bin"
PATH_CHOCO=$(echo $ALLUSERSPROFILE | sed -r 's#([a-zA-Z]):\\#/\U\1/#')/chocolatey/bin
PATH_TOOLS=${PATH_CHOCO}:${PATH_PUPPET}

# Common Windows Directories (32-bit)
PATH_WINDOWS=/sys:/win:/sys/Wbem:/sys/WindowsPowerShell/v1.0/

# Scripting Languages
PATH_PYTHON=/C/Python27/:/C/Python27/Scripts
PATH_PHP=/C/PHP/
PATH_PERL=/C/Strawberry/C/bin:/C/Strawberry/perl/site/bin:/C/Strawberry/perl/bin
PATH_RUBY=/C/Ruby21/bin
PATH_SCRIPTING=${PATH_RUBY}:${PATH_PYTHON}:${PATH_PHP}:${PATH_PERL}

# GNUWin32 Tools (should go after Bash and Ksh)
PATH_GNU=/C/gnuwin32/bin

# Bash Shell (Should go before GNUWin32)
MSYS_HOME=/C/Git
PATH_BASH=${MSYS_HOME}/cmd:${MSYS_HOME}/bin

# Local Binary Reference
USERBIN=/usr/bin

# Configure Current Path
INHERITED_PATH=${PATH}
SET PATH=${USERBIN}:${PATH_BASH}:${PATH_TOOLS}:${PATH_SCRIPTING}:${PATH_WINDOWS}:${PATH_GNU}
export ${INHERITED_PATH}  # preserve for reference
export ${PATH}            # use the new path
```
