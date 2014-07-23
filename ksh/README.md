# Scripting Tutorial: Ksh (Korn Shell)

© Joaquin Menchaca, 2014

Version 1.5

## Overview

OVERVIEW

## Gettting Korn Shell on Mac OS X

Mac OS X 10.8.5 comes with Ksh '93 93u (2011-02-08).

### Homebrew

Homebrew [http://brew.sh/] is a popular single-user package management system that can install a variety of scripting languages and tools, which includes a newer version of Korn Shell.

Homebrew and Ksh 93u+ can be installed with these commands (Tested on Mac OS X 10.8.5 on July 2014):

```bash
# Installation of HomeBrew
ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
brew update
brew doctor
echo export PATH='/usr/local/bin:$PATH' >> ~/.bash_profile
. ~/.bash_profile
# installation of Korn Shell
brew install ksh
# idea borrowed from bash
echo export KSH_VERSION=$(ksh --version 2>&1 | cut -d' ' -f15-16) >> ~/.bash_profile
. ~/.bash_profile
```

## Getting Korn Shell on Windows

Korn shell is available directly from AT&T Research Labs: http://www2.research.att.com/sw/download/.

The site is really confusing to navigate, and I could not recall how I eventually found binary installers.  At some point I stumbled upon two installers that will ksh 93u+:

* uwin-base.2012-08-06.win32.i386.exe
* uwin-base.2012-08-06.win32.i386-64.exe

After installation, ```ksh.exe``` will be installed into ```C:\Program Files\UWIN\usr\bin\``` along with other tools. 

## Testing

* Mac OS X 10.8.5

```bash
$ /bin/ksh --version
  version         sh (AT&T Research) 93u 2011-02-08
$ /usr/local/bin/ksh --version
  version         sh (AT&T Research) 93u+ 2012-08-01
```

## Topics with Details 

This covers notes regarding each section.

1. **Output**
2. **Variables**
3. **Arithmetic**
4. **Input**
5. **Branch**
6. **Looping**
7. **Arrays**
8. **Associative Arrays**
9. **Subroutines** 
10. **Arguments**
11. **Parameters**
12. **Functions**