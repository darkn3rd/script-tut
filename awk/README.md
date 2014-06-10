# Scripting Tutorial: AWK

© Joaquin Menchaca, 2014

## Overview

The AWK tool was introducted in Version 7 Unix and named afer the authors: Aho, Weinberger, and Kernighan.  AWK was a away to add computational features to the Unix pipeline, and at the time was the only other scripting language available besides Bourne Shell.  

AWK was updated in the late 1980s with the release of nawk (New AWK) and gawk (GNU AWK).  In the 1990s, the popularity of Perl caused AWK to be used less for text-processing chores.

## Issues

For systems that do not have ```/bin/awk```, such as Mac OS X, you can create a symbolic link to create a ```/bin/awk```.  AWK is such an essential and core tool for any UNIX-like system.  It is a part of the POSIX 
UNIX toolset and also apart of the GNU Core-Utils.  There for it should be placed in the ```/bin``` directory.  

On Mac OS X 10.8.5, you can do this:

```
sudo ln -s `which awk` /bin/awk
```

## Testing

* Windows 7, Gawk 3.0.4 (msysgit 1.9.2-preview20140411)
  * Issues:
    * ```length()``` only works on string, will not work on array
* Mac OS X 10.8.5, Awk 20070501
  * Issues:
    * awk not in ```/bin/awk```, but found in ```/usr/bin/awk```

## Topics with Details 

This covers notes regarding each section.

1. **Output**
2. **Variables**
3. **Arithmetic**
4. **Input**
5. **Branch**
   * select on number using ```if```
   * select on character using ```switch```
     * **NOTE** *This is not supported by POSIX awk or Gawk 3.x.  This functionality is available in Gawk 4.x*
   * select on character using ```if```
6. **Looping**
   * iterative (count) loop
   * conditional loop
   * collection loop
7. **Arrays**
   * populate array using index
   * popular array using list of items
     * enumerate array using collection loop
     * enumerate array using iterative loop
8. **Associative Arrays**
   * Create Associative Array using key value
   * Create Associative Array using supplied list
9. **Subroutines** 
   * utilize subroutine that prints the current date in "Month Day, Year" format
10. Arguments (TBA)
    * demonstrate testing for two arguments
    * print list of all arguments with count
    * print list of all arguments in reverse with count
11. Parameters (TBA)
   * demonstrate passing 1 parameter
     * utilize subroutine that prints celsius temperature when supplied fahrenheit temperature
   * demonstrate passing unlimited parameters
     * *Note* VBscript does not support unlimited parameters.  Alternative is to create an temporary ```Array``` and pass the array.
     * utilize subroutine prints sum of all numbers passed into it.
12. **Functions**
    * demonstrate returning integer (TBA)
      * returns summation of all numbers passed into function 
    * demonstrate returning string
      * returns capitalized string from lower case string 
