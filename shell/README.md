# Scripting Tutorial: Shell (POSIX Shell)

© Joaquin Menchaca, 2014


## Overview

### Bourne Shell

The POSIX shell evolved from the original Bourne Shell, inved by Stephen Bourne, was released in UNIX Version 7 in 1977.  Bourne shell added scripting capabilities, and replaced the limited Thompson shell ```sh``` in earlier versions of Unix.

Newer shell environments extended the capabilities of Bourne shell and were released as drop in replacements for Bourne Shell.  Some of these are Bourne Again Shell (bash), Korn Shell (ksh), and Z Shell (zsh).  Almquist Shell (ash) and later Debian Almquist Shell (dash) maintain strict compabitity toward Bourne shell and are popular in low-memory situations.

### POSIX Shell

The basic Bourne shell scripting language has been updated by the POSIX (Portable Operating System Interfacee) standard, specifically  IEEE P1003.2.  This standard incorporated some features that were available in existing Korn Shell and Bourne Again Shell at the time.  Shells conforming to this specification when ran as ```sh``` are thus said to be POSIX Shell.

Many flavors of Unix released versions of ```sh``` that conformed to the shell, and in the open source community, shell environments that supported Bourne shell were updated to support the standard as well.  

## Getting POSIX Shell on Mac OS X

On Mac OS X 10.8.5, the best source of POSIX Shell is with the included ksh '93u.  You would have to make sure that ```/bin/sh``` is actually ```ksh```, and not the default.

The current default of ```/bin/sh``` is really GNU bash 3.2.48.  When ```sh``` is used, GNU bash does try its best to run in a POSIX mode, but may suffer from what is called *bashisms*, or in other words using bash features accidently when it should be using strict POSIX shell behavior.  For this reason, ksh would yield better results to achieve a real POSIX shell environment.

## Testing

* Mac OS X 10.8.5, Bash 3.2.48(1)-release (x86_64_appledarwin12) using ```/bin/sh```



## Notes 

This covers notes regarding each section.

1. Output
2. Variables
3. Arithmetic
4. Input
5. Branch (**Requires** understanding of ```test```)
   * if on number
   * case on single character
     * demonstrates case's glob pattern with POSIX selector
   * if on single character
     * demonstrates using POSIX selector with ```tr``` and sub-shell ```$( command )``` to capture result
6. Looping
   * iterative loop 
      * example: 10 to 1
        * ```while``` loop with counter
        * ```for...in``` loop using ```seq``` to generate range
   * conditional loops
        * both ```while``` and ```until``` loops demonstrated
        * spin loop demonstrated
   * collection loop
      * iterate through set of items 
      * example: directory listing
7. Arrays
   * **OMITTED** *POSIX Shell does not support arrays*
   * Alternatives offered:
     * Using space delimited strings
8. Associative Arrays
   * **OMITTED**: *POSIX Shell does not support associative arrays.*
9. Subroutines
   * Subroutine (Function in POSIX Shell) that prints out the date in friendly format *.
10. Arguments
    * Exact Arguments (2):
      * Add two numbers
        * Demonstrates, ```$#```, positional parameters, arithmetic using ```$(( expr ))``` 
    * Unlimited Arguments (n):
      * Print numbered list of arguments (varies methods)
        * conditional loop using ```while``` with ```shift``` to change positional parameters
        * collection loop on ```"$@"```
        * iterative style loop using ```while``` with ```eval```
        * iterative style loop uisng ```for``` with range from ```$(seq 1 $#)```
    * Unlimited Arguments (n): 
      * Print all arguments in reverse order
        * iterative style loop using ```while``` with ```eval```
        * iterative style loop using ```until``` with ```eval```
        * iterative style loop uisng ```for``` with range from ```$(seq 1 $#)```
11. Parameters
    * Subroutine that accepts numbers and prints out their summation.
12. Functions
    * **OMITTED**: *POSIX Shell does not have real functions.  They return an error code, but not a value.*
    * Alternatives (returning integer):
      * Capture Stdout from sub-shell, e.g. ```result=$(myfunction params)```
      * Use side-effect by setting outer scope variable, e.g. ```global_result_var=$return_value_in_function```
      * Use Error Code to contain resulting value, e.g. ```echo "result=$?"```
    * Alternatives (returning string)
      * demonstrate capitalize (uppercase) a string
        * using translate
        * using awk
        * using GNU sed
        * using perl
13. Extra
   * Test Review I
