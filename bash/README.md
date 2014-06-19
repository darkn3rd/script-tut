# Scripting Tutorial: Bash (Bourne Again Shell)

© Joaquin Menchaca, 2014

## Overview

OVERVIEW

## Getting Bash on Mac OS X

Mac OS X 10.8.5 comes with GNU Bash 3.2.48.

## Getting Bash on Windows

An easy way to get Bash on Windows is to use Git Bash from msysgit from http://msysgit.github.io/.  This installs a set of Mingw GNU tools.  Currently, Mingw has an earlier version of GNU bash 3.1.0.

When running Git Bash on Windows, you might notice that some variables in the ```$PATH``` still have Windows names.  This happens when the Windows ```%PATH%``` includes variables, such as ```%JAVA_HOME%```.  The bash will need to re-interpret.  You can source this script to fix that situation if this occurs:

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

TBU

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