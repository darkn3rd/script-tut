# Scripting Box: MinGW Installation Guide

© Joaquin Menchaca, 2014

## Overview

This installation guide covers installing components to create a ScriptBox for Windows Command Shell environment, using tools that were compiled using MinGW or Microsoft C Runtime.  These scripts should be able to run correctly within a Windows Command Shell `cmd.exe`.

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



### Strawberry Perl


Verification:

```Batch
C:\Users\Vagrant> which perl
C:\Strawberry\perl\bin\perl.EXE
C:\Users\Vagrant> perl --version | grep -o "perl 5.*$"
perl 5, version 20, subversion 1 (v5.20.1) built for MSWin32-x86-multi-thread-64int
```



```batch
C:\Users\Vagrant> echo %PATH% | tr ';' '\n'



```


## 6. Install Bash (Bourne Again Shell) with MSYS-Git

The MSYS environment comes with GNU Bourne Again Shell `bash`.

## 7. Install Korn Shell (Ksh) with UWIN

The UWIN environment comes with a Korn Shell `ksh`, and also comes with POSIX shell `sh` and C-Shell `csh`.

## 8. Final Configurations

### Windows Command Shell Paths

### Final Configurations

The `%PATH%` environment variable is completely unique to your environment.  Thus this will need some customization for your particular environment.  Important it to have GNUWin32 path up front.

```Batch
SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin
SET PATH_WINDOWS=C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\

SET PATH_PYTHON=C:\Python27\;C:\Python27\Scripts
SET PATH_PHP=C:\PHP\
SET PATH_STRAWBERRY=C:\Strawberry\perl\site\bin;C:\Strawberry\perl\bin
SET PATH_RUBY=C:\Ruby21\bin

SET PATH_SCRIPTING=%PATH_RUBY%;%PATH_PYTHON%;%PATH_PHP%;%PATH_STRAWBERRY%

SET PATH_GNU=C:\gnuwin32\bin
SET PATH_BASH=C:\Git\cmd;C:\Git\bin


SET PATH=%PATH_GNU%;%PATH_SCRIPTING%;%PATH_WINDOWS%;%PATH_BATH%
```
