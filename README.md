# Scripting Tutorial

© Joaquin Menchaca, 2014

## Overview
This is a general tutorial of scripting modeled after typical tasks one would do with shell programming.  Thus it is oriented toward common tasks in system administration.  As this is a tutorial that demonstrates basic features of a given language, and it doubles as a handy reference.

## Languages

The current languages are supported:
  - Awk
  - BATCH (Command Shell) [Windows]
  - Bourne Shell (POSIX)
  - Bourne Again Shell
  - Korn Shell
  - Perl
  - PHP
  - PowerShell [Windows]
  - Python
  - Ruby
  - VBScript (WSH) [Windows]
  
In the future, I could expand to other languages such as LUA, JavaScript (Node.js), and JScript (WSH).  If I am really bored I could even do REXX, but I'll probably likely moe onto advanced topics in the given languages, as this is more bang for buck in audience, knowledge growth, and job skills.

## Content 

Not all of the content can adequately be covered for every language.  The scripts attempt to cover the following topics:

1. Output
   * simple output to stdout
2. Variables
   * array declaration of number, characters, strings
3. Arithmetic
   * basic integer arithmetic
   * floating point arithmetic
   * math functions
4. Input
   * simple input from stdin
5. Branch
   * if on number
   * case on single character
   * if on single character
6. Looping
   * iterative loop 
      * example: 10 to 1
   * conditional loops
   * collection loop
      * iterate through set of items 
      * example: directory listing
7. Arrays
   * Array Initialization
      * initialize array by index
      * array length
      * enumerate all elements
   * Array Enumeration 
      * declare and initialize array
      * enumerate array by collection loop
   * Array Enumeration
      * declare and initialize array
      * enumerate array by index
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
   * Demonstrate Subroutine (no return value)
10. Arguments (Command Line)
   * Process 2 Arguments & Print Summation
   * Enumerate All Arguments & Print In Order with Count
   * Enumerate All Arguments & Print Reverse Order with Count
11. Parameters
   * Pass a single parameter & Print Celius from Fahrenheit
   * Pass n number of parameters & Print summation of all arguments
12. Function
   * Varies: Each language has different features in returning arrays, strings, value, references.
13. Options (Advanced Command Line Arguments)
   * Varies: Each language has their own system for this, little overlap

## Key to Naming Convention

The scripts are named with a prefix that follows this pattern:

* [A-Z] - Alphabet letter of category (max of 26 categories)
* [0-9] - Each number represents an example sub-category (max of 10 sub-categories)
* (0|[1-9]) 
  * 0 - represents main category. If absent, then language does not support that feature syntactically.
  * [1-0] - represents an alternative, as language has multiple ways to do the same thing. Or this represents alternative way to simulate an absent category.

## Future Content (General) 

For future topics that I would like to cover (language set might vary) are below.  Target languages would include Perl, Python, Ruby, Shell, Awk, and Powershell.  Given free time, I might try to expand this to PHP, TCL, VBScript.

1. Processing Options
1. String Operations
2. Array Operations
3. Text Processing
   * matching patterns
   * translation
   * substitution
4. Record Processing
   * column separated records
   * field separated records
   * multi-line records
   * stanzas (if plausible)
5. File Input/Output
   * Text Files
   * Binary Files
   
## Future Content (Specialized)

This is some future content that I thought of developing with PHP, Perl, Python, Ruby, and PowerShell. Languages may vary depending on topic, so Bash with Curl could perhaps be used.  Also, each language can have contending libraries that vary in popularity.  I hope to have some material that does transactions in the raw, then shows a more simplified way of doing things with a library.

1. Web Data (YAML, XML, JSON)
2. Web Consumption (RESTful)
   * Pre-Req is HTTP understanding
   * Simple pulls simple web resource and grabs the data
3. Web Processing (HTTP)
   * Pre-Req requires CGI and HTTP understanding
   * Wanted to Create Mini-Web Series using Micro-Framework and use data from SQL course
     * Dancer, Slim, Sinatra, Flask, etc.
4. Sockets
5. Database (SQL)
   * Wanted to Develop Mini-SQL Series using EMP, DEPT style demo tables
   * Pre-Req will require SQL obviously
6. Interprocess Communication
7. Directory (LDAP, DNS)
8. E-Mail (SMTP, IMAP, POP)
9. Multi-Processing (Fork, Threads)
10. Serialization
