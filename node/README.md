# Scripting Tutorial: JavaScript (Node.js)

© Joaquin Menchaca, 2014

## Overview

OVERVIEW

**NOTE** Currently, as of v0.10.29, Node.js is broken for synchronous interactive input on Mac OS X. Thus development of these scripts is sort of on the back burner for now, as they are not all that reliable.  It makes sense, one useing sychronous input goes against the platform, and also on a Mac OS X, which is typically client development, not a web server platform.

## Getting Node.js

The Node.js inerpreter can be downloaded from http://nodejs.org/download/.  

### Getting Node.js on Mac OS X

For Mac OS X, there's an installable package, thus for version v0.10.29, you can get this by:

```bash
curl -O http://nodejs.org/dist/v0.10.29/node-v0.10.29.pkg
```

Install the package, which should put this ```npm``` and ```node``` in ```/usr/local/bin```.  

For convenience, I like to source my scripts with a *shebang* pointing to /usr/bin, thus I do the following:

```bash
sudo ln -s /usr/local/bin/node /usr/bin/node
sudo ln -s /usr/local/bin/npm /usr/bin/npm
```

### Getting Node.js on Windows 7

Windows process of getting the interperter is quite simple, as there's an MSI in 32-bit and 64-bit versions for version v0.10.29:

* 32-bit: http://nodejs.org/dist/v0.10.29/node-v0.10.29-x86.msi
* 64-bit: http://nodejs.org/dist/v0.10.29/x64/node-v0.10.29-x64.msi

You can associate an extension with Node, so that scripts are automatically executed with Node.js interpreter when rand.  I chose to use the .njs extension, as Windows already has an associate of .js to match the WSH (Windows Script Host) JScript language.

```batch
assoc .njs=JavaScript
ftype JavaScript="C:\Program Files\nodejs\node.exe" %1 %*
```

Lastly, if you are using Mingw GNU tools, such as those that comes with Git Bash (msysgit from http://msysgit.github.io/), you can do these, so that scripts use Node.js interpreter in that environment:

```bash
ln -s "/c/Program Files/nodejs/node.exe" /usr/bin/node
ln -s "/c/Program Files/nodejs/npm.cmd" /usr/bin/npm
````



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