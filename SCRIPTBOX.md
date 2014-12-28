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
  * :dvd: **Mac OS X 10.9.5 (*Maverick*)** with XCode 6.1
* Windows
  * :dvd: **Windows 7 (*Windows NT 6.1*)**

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
* :package: Shells
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
* :package: Shells
  * :package: bash 3.2.51

## Package Managemnt

Mac OS X has package managers like [Homebrew](http://brew.sh/), [MacPorts](https://www.macports.org/), [Rudix](http://rudix.org/). These instructions cover [Homebrew](http://brew.sh/) and were tested on *Maverick*.
