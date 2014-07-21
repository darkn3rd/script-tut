# Scripting Tutorial: Bash (Bourne Again Shell)

© Joaquin Menchaca, 2014

## Overview

*Bourne Again Shell* (bash) written by Brian Fox and releated in 1989 as a dropp in replacement for the original shell *Bourne Shell* (sh).  Bash extends the shell with new features, mixing in ideas borrowed from C Shell (csh) and Korn Shell (ksh).

Bash is compatible as a POSIX shell and will run in strict POSIX mode when accessed as ```sh```.  There may have been non-portable features that still work in this mode; such features are called bashisms.

Bash 4 adds a number of features, such as associative arrays and new parameter expansions to do uppercase and lowercase on variables.

## Getting Bash on Mac OS X

Mac OS X 10.8.5 comes with GNU Bash 3.2.48.

### Homebrew

Homebrew [http://brew.sh/] is a popular single-user package management system that can install a variety of scripting languages and tools, which includes Bash 4.

Homebrew and Bash 4 can be installed with these commands (Tested on Mac OS X 10.8.5):

```bash
ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
brew update
brew doctor
echo export PATH='/usr/local/bin:$PATH' >> ~/.bash_profile
echo export BASH_VERSION=$(/usr/local/bin/bash -version | head -1 | cut -d' ' -f4)
. ~/.bash_profile
brew install bash
```

## Getting Bash on Windows

### GitBash (MSYS)

An easy way to get Bash on Windows is to use Git Bash from msysgit from http://msysgit.github.io/.  This installs a set of Mingw GNU tools.  Currently, Mingw has an earlier version of GNU bash 3.1.0.

When running Git Bash on Windows, you might notice that some paths in the ```$PATH``` still have Windows path names.  This happens when the Windows ```%PATH%``` includes other variables, such as ```%JAVA_HOME%```.  

To fix this, you can source this script to fix that situation if this occurs:

```bash
#!/bin/sh
# convert DOS style %varibles% to UNIX style ${variables}
NEWPATH=$(echo "$PATH" | sed 's/%\([^%]*\)%/${\1}/g')
 
# resolve all variables in $PATH
eval NEWPATH=\"${NEWPATH}\"
 
# convert DOS paths (C:\path\) to UNIX paths (/c/path/)
PATH="$(echo "${NEWPATH}" | sed \
   -e 's@^\([a-zA-Z]\):\\@/\L\1/@g' \
   -e 's@:\([a-zA-Z]\):\\@:/\L\1/@g' \
   -e 's@\\@/@g')"
 
export PATH
```
Reference: https://github.com/darkn3rd/opscripts/blob/master/windows/git_bash_path_fix.windows.sh



## Testing

* Mac OS X 10.8.5

```bash
$ /bin/bash -version | head -1
GNU bash, version 3.2.48(1)-release (x86_64-apple-darwin12)
$ /usr/local/bin/bash -version | head -1
GNU bash, version 4.3.18(1)-release (x86_64-apple-darwin12.5.0)
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