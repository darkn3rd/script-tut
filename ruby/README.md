# Scripting Tutorial: Ruby

© Joaquin Menchaca, 2014

## Getting Ruby

### Getting Ruby on Mac

#### Default


#### Brew


#### MacPorts

#### RVM



## Notes 

This covers notes regarding each section.

1. Output
2. Variables
3. Arithmetic
4. Input
5. Branch
   * if on number
   * case on single character
   * if on single character - using match operator ```=~```  
6. Looping
   * iterative loop 
      * example: 10 to 1
        * ```while...end```
        * ```for...downto...do...end```
        * ```downto...do...end```
        * Range operator with each iterator
          * Range operator ```..``` can only increment, not decrement
        * ```10.times do...end```
   * conditional loops
      * ```begin...end while```
      * ```while...do...end```
      * ```begin...end until```
      * ```until...do...end```
      * ```loop do...end```
        * spin loop example  
   * collection loop
      * iterate through set of items 
      * example: directory listing
      * syntax examples
        * ```for...do...end```
        * each iterator
7. Arrays
   * Array Initialization
      * initialize array by index
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
9. Subroutine
   * Subroutine that prints out formatted date
10. Arguments
    * Process 2 arguments
      * test number of arguments
      * usage-like output on correct # of arguments
      * Ruby: need to convert default string to perform math
    * Print all arguments
      * ```for...in``` to loop until length of ```ARGV``` array
      * demonstrate ```Array.shift``` method
    * Print all arguments in reverse order
      * use ```downto``` to decrement through ```ARGV``` array
11. Parameters
	* Process n number of parameters
	  * print summation of all parameters added up
	  * ```each``` iterator method
12. Function
    * Return integer
      * demonstrates by summing up all integers and returning sum
    * Return string
      * demonstrates by capitalize (upper case) a string
