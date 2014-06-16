# Scripting Tutorial

© Joaquin Menchaca, 2014

## Overview
This is a general tutorial of scripting modeled after typical tasks one would do with shell programming.  Thus it is oriented toward common tasks in system administration.  As this is a tutorial that demonstrates basic features of a given language, and it doubles as a handy reference.

## Languages

The current languages are supported:
  - Awk*
  - BATCH (Command Shell) [Windows] †
  - Shell (POSIX) ††
  - Bourne Again Shell ††
  - Korn Shell ††
  - JScript (WSH) [Windows]
  - Perl
  - PHP
  - PowerShell [Windows]
  - Python
  - Ruby
  - TCL
  - VBScript (WSH) [Windows]
  
† Common consistent utilities on Windows NT family††† of OSes may be utilized.

†† Utilities available with either POSIX Utilities [http://pubs.opengroup.org/onlinepubs/009696699/utilities/contents.html] or GNU Core-Utils [http://www.gnu.org/software/coreutils/] may be used.

††† Windows NT family of OSes include Windows 2000, Windows XP, Windows 2003, Windows 2008, Windows 2012, Windows 7, Windows 8.1, and so forth.  Essentially, desktop or server OSes that use the WindowsNT kernel, but may be marketed something else.

In the future, I could expand to other languages such as LUA, JavaScript (Node.js).  If I am really bored I could even do REXX, but I'll probably likely more onto advanced topics in the given languages, as this is more bang for buck in audience, knowledge growth, and job skills.

## Content 

Not all of the content can adequately be covered for every language.  The scripts attempt to cover the following topics:

1. Output
   * simple output to stdout
2. Variables
   * declaration of number, characters, strings
     * example: shows how to escape quote characters
   * use string interpolation
   * use string concatenation
3. Arithmetic
   * basic integer arithmetic
   * floating point arithmetic
   * math functions
4. Input
   * simple input from stdin
     * show using short prompt
5. Branch
   * select on a number
   * select on a single character
6. Looping
   * iterative loop 
      * example: count from 10 to 1
   * conditional loops
   * collection loop
      * iterate through list of items 
        * example: directory listing, and test if directory
7. Arrays
   * Array assignment by key
      * initialize array using index
        * show array length
        * enumerate all elements
   * Array assignment by list
      * declare and initialize entire array
      * enumerate array by collection loop
      * enumerate array by index
8. Associative Arrays
   * Associative Array assignment by key
      * initialize associative array using key
      * enumerate all keys 
      * enumerate all values
   * Associative Array assignment by list
      * declare and initialize associative array
      * merge two associative arrays
      * enumerate associative array by key
9. Subroutine
   * Demonstrate Subroutine (no return value)
     * example: using formatted date 
10. Arguments (Command Line)
   * Process 2 Arguments & Print Usage
     * example: shows how to reference running file name 
   * Enumerate All Arguments
     * print all arguments in order
     * print all arguments in reverse order
11. Parameters (Function and Subroutines)
   * explicit number of parameters (1 integer)
     * example: shows controlling decimal precision
   * explicit number of parameters (2 arrays) [TBA]
     * example: shows sorting an array
   * variable number of parameters (integers)
   * variable number of parameters (associative arrays) [TBA]
12. Function
   * return integer
   * return string
   * return array [TBA]
   * return hash [TBA]

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

## Terminology 

It is unfortunate that there are a variety of terms, sometimes conflicting, used to describe consistent and common concepts found throughout many of these scripting languages.  Here is a list of terms used within this tutorial:

* **array** - *collection of elements (values or variables), each selected by one or more indices* [http://en.wikipedia.org/wiki/Array_data_type].  A real array has its elements (items) ordered in a sequence that can be accessed by an integer index.  Some languages, e.g. JavaScript, TCL, and AWK, mimic arrays where the indexes are actually strings, and are thus not organized in any sequential order.

* **argument** - *item of information provided to a program when it is started. A program can have many command-line arguments that identify sources or destinations of information, or that alter the operation of the program* [http://en.wikipedia.org/wiki/Command-line_argument#Arguments].  The term arguments used here is an abbreviated name of command-line arguments, and thus explicitly refers to arguments that are passed in from the command-line.

* **associative array** is a *composed of a collection of (key, value) pairs, such that each possible key appears at most once in the collection* [http://en.wikipedia.org/wiki/Associative_array].  These are sometimes called hash, hash table, map, collection, or dictionary.  Some languages, such as JavaScript, TCL, and AWK simply call them arrays.

* **flag** - special type of **option** (and thus a special type of **argument**) that is not proceeded or coupled with other data.  The **flag** (also called a **switch**) represents binary state, on or off, or true or false, and its existence on the command line signifies an *on* or *true* state.

* **function** - *a relation between a set of inputs and a set of permissible outputs with the property that each input is related to exactly one output* [http://en.wikipedia.org/wiki/Mathematical_functions]. A function could be thought of as a subroutine that explicitly returns a value.

* **option** - special type of argument that is prepended by a dash ```-``` character.  This signifies that the operation of a command will be modified.

* **parameter** - *special kind of variable, used in a subroutine to refer to one of the pieces of data provided as input to the subroutine* [http://en.wikipedia.org/wiki/Parameter_(computer_programming)].

* **scalar** - see **variable**.

* **subroutine** -  *sequence of program instructions that perform a specific task, packaged as a unit. This unit can then be used in programs wherever that particular task should be performed. Subprograms may be defined within programs, or separately in libraries that can be used by multiple programs* [http://en.wikipedia.org/wiki/Subroutine].  A **subroutine** can be used for code organization, where function could be considered to perform an operation that returns a value.  Many scripting languages do not distinguish the two, so a subroutine would be a **function** that does not explicitly return a value in this case.

* **switch** - see **flag**.


* **variable** - *storage location and an associated symbolic name (an identifier) which contains some known or unknown quantity or information, a value* [http://en.wikipedia.org/wiki/Variable_(computer_science)].

## Project Changes

* 2014-06-15: Finished PHP section (docs including complex Windows configuration)
* 2014-06-14: Finished (torture) C Shell.
* 2014-06-12: Initial CShell (tcsh) - yeah, yeah, I know...
* 2014-06-11: Exhaustive review/updates of Awk
* 2014-06-10: Testing Awk (OS X 10.8.5, msysgit 1.9.2 on Win7)
* 2014-06-08: Added initial Bash, Ksh, Perl, PHP
* 2014-06-07: Added initial Awk and TCL
* 2014-06-06: Finished JScript (WSH) addition, reflected findings back.
* 2014-06-02: Python - Functions, Parameters, Subroutine
* 2014-06-02: Ruby - Functions, Parameters.
* 2014-06-02: Finished VBScript (WSH) section.
* 2014-06-02: Finished PowerShell section.
* 2014-05-26: Ruby - subroutine, arguments
* 2014-05-26: Python - arguments, function
* 2014-05-23: Ruby, Python - finish sections up to associative arrays

