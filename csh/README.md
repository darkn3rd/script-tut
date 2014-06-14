# Scripting Tutorial: C Shell

© Joaquin Menchaca, 2014

## Overview

Welcome to C Shell tutorial.  This will teach the basics on how to get around in C Shell scripting.

## History

C Shell was created by Bill Joy in the 1970s and was distributed with BSD UNIX and went on to become the default shell for BSD UNIX flavors.  C Shell became popular both for its C language-like syntax, and rich and easy to use customization.  

C Shell is widely known to have problems and limitations, and does not have basic features like functions.  So many may have opted out from using C Shell for any professional scripting, but still used the shell environment to interface with UNIX and Linux systems.  Today, C Shell has not fixed many of its issues (which probably requires a rewrite)
and it is unable to keep up with robust feature set afforded in other shells.

# Rants From Author

This language has been frustrating to document, as a quite a bit of documentation out there is incorrect.  This has caused me more motivation to document C Shell.  

The language itself has posed some quirks that are not some randomly discovered bug, but are the actual behavior.  Two that I found quite profound.  Any reserved word that terminates a block, absolutely must be followed by a newline.  If it is not, weird stuff happens.  Spaces followed by one of these block terminators, such as ```endif``` or ```end```, will also cause the block to fail.  Also, found out that when processing input, ```set variable=$<`, only the first word is captured, and a quoted string with spaces causes ```set: Syntax Error.```.

Beyond these quirks, the language is extremely limited.  Here are a few of the limitations I have found:

  * cannot store any type of float, even as a string.  Thus "3.14" can never be saved into any variable, even if used as a string.
  * there are not functions or subroutines
  * arrays items cannot be inserted by index, they must be concatenated into an existing array.

Lastly, besides BATCH programming, this language has the least capabilities of any scripting language.  There are reasons many a system administrator are saying "don't use it". Unless job security is needed, such as C Shell that spawns Awk scripts that subshell perl one-liners that may call C Shell again, I don't see the utility... :)

And anyone documenting C Shell, it seems it is traditional to reference this document:

  * **Top Ten Reasons not to use the C shell** by Bruce Barnett: http://www.grymoire.com/unix/CshTop10.txt

## Topics with Details 

This covers notes regarding each section.

1. Output
2. Variables
3. Arithmetic
   * **OMITTED** Any sections dealing with float
4. Input
5. Branch
   * select on number using ```if```
   * select on character using ```switch```
   * select on character using ```if```
     * used ```expr STRING : PATTERN```  
6. Looping
   * iterative (count) loop
   * conditional loop
   * collection loop
7. Arrays
   * populate array using index
   * popular array using list of items
     * enumerate array using collection loop
     * enumerate array using iterative loop
8. Associative Arrays
   *  **OMITTED** 
9. Subroutines
   *  **OMITTED** Not supported in C Shell
10. Arguments
    * demonstrate testing for two arguments
    * print list of all arguments with count
    * print list of all arguments in reverse with count
11. Parameters
    *  **OMITTED** Not supported in C Shell
12. Functions
    *  **OMITTED** Not supported in C Shell
