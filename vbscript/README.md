# Scripting Tutorial: VBScript (WSH)

© Joaquin Menchaca, 2014

## Overview

VBScript is a language running on the platform Active Scripting. The WSH (Windows Script Host) is a software applications that use Active Scripting and provide functions to allow scripts to interact with the shell command and Windows graphical environment. VBScript in WSH enviroment supports a feature called "OLE Automation" which provides access to libraries many software available for Windows.

## Notes 

This covers notes regarding each section.

1. Output
2. Variables
3. Arithmetic
4. Input
5. Branch
   * if on number
   * case on single character
     * **OMITTED**: *Python 2.x does not have switch/case construction* 
   * if on single character
     * *used* ```python re.compile(pattern).match(string)``` to simulate ```=~``` 
6. Looping
   * iterative loop 
      * example: 10 to 1
        * *while loop used for count down loop* 
   * conditional loops
   * collection loop
      * iterate through set of items 
      * example: directory listing
7. Arrays
   * Array Initialization
      * initialize array by index
        * *couldn't set element to string, used array of chars* 
      * array length
      * enumerate all elements
   * Array Enumeration 
      * declare and initialize array
      * enumerate array by collection loop
8. Associative Arrays
   * Associative Array Initialization
      * initialize associative array by key
      * enumerate all keys
      * enumerate all values
   * Associative Array Enumeration
      * declare and initialize associative array
      * merge two associative arrays
      * enumerate associative array by key
9. Subroutines
   * demonstrate declaring and calling subroutine
10. Arguments
    * demonstrate processing 2 arguments
      * **Note:** *Python includes scriptname as first argument in ```sys.argv```*
    * demonstrate printing all arguments
      * **Note:** *Did not use shift as not available in Python 2.x, and impossible to shift elements when 1st is the script name* 
    * demonstrate printing arguments in reverse order
11. Parameters
    * demonstrate passing unlimited arguments
12. Functions
    * demonstrate function with return int
    * demonstrate function with return string

