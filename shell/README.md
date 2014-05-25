# Scripting Tutorial: Shell (POSIX)

© Joaquin Menchaca, 2014

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
      * example: directoy listing
7. Arrays
   * **OMITTED** * Arrays are not available with Bourne shell or POSIX shell. * Alternatives offered:
     * Using space delimited strings
8. Associative Arrays
   * **OMITTED**: *POSIX Shell does not support associative arrays.*
9. Subroutines
   * Subroutine (Function in POSIX Shell) that prints out the date in friendly format *.
10. Arguments
   * Exact Arguments (2):
     * Add two numbers
       * Demonstrates, ```$#````, positional parameters, arithmetic using ```$(( expr ))``` 
   * Unlimited Arguments (n):
     * Print numbered list of arguments
       * Demonstrates ```shift```, posiitonal parameters, iterative loop  
   * Unlimited Arguments (n): 
     * Print all arguments in reverse order
       * Demonstrates ```eval```, positional parameters, iterative loop
11. Parameters
   * Subroutine that accepts numbers and prints out their summation.
