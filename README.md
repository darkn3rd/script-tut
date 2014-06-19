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
  
† Common consistent utilities on Windows NT family (Win 2K/2K3/2K8/2013, Win XP, Win 7, Win 8, etc) of OSes may be utilized.

†† Utilities available with either POSIX Utilities [http://pubs.opengroup.org/onlinepubs/009696699/utilities/contents.html] or GNU Core-Utils [http://www.gnu.org/software/coreutils/] may be used.

**BRAINSTORM** *I may add JavaScript using Node.js environment.  If there was enough interest I could add other languages like REXX, LUA, Haskell, Guile, etc.  At the moment, I am interested in developing OOP tutorials, as well as exploring intermediate (file, socket, arrays, text processing) and advanced (SQL DB, LDAP, Web).*

## Content 

Not all of the content can adequately be covered for every language.  The scripts attempt to cover the following topics:'

1. Output
2. Variables
3. Arithmetic
4. Input
5. Branch
6. Looping
7. Arrays
8. Associative Arrays
9. Subroutine
10. Arguments (Command Line)
11. Parameters (Function and Subroutines)
12. Function

### Output

Simple output to STDOUT (standard output)

### Variables

Demonstrate declaring numbers, characters, and strings.  Show how to use these with:

* String Interpolation
* String Concatenation

Additionally, show how to escape quote characters.

### Arithmetic

This shows how to use basic math in the scripting language, nothing too advanced.  This includes:

* basic integer math and boolean math
* declaring floating point variables
* calculating exponential
* using cosine math function

### Input

Demonstrate how to interactively get data from STDIN (Standard Input) and also show how to print a small prompt, that is print a string that does not automatically embed a newline character.

### Branching

Demonstrate how to select or test on a single number, character, or pattern.  Show do multiple tests on a single item (sort of a like a reverse select), which typically involves some switch or case facility in the language.

### Looping

This section will have the following sections:

1. **Collection-Controlled Loop**: demonstrates by testing elements extracted from list of files
2. **Count-Controlled Loop**: demonstrate counting from 10 to 1
3. **Conditional-Controlled Loop**: demonstrates by prompting for a name, and leaving loop on users request
4. **Spin Loop**: demonstrates prompting for a name, and breaking out of loop on users request
5. **Continuation**: demonstrates skipping to next iteration, when user enters a non-digit input.

**NOTES** There are explicitaly four types of looping constructs: *count*, *collection*, *general*, and *infinite* loops according to reasonable documentation on Wikipedia [http://en.m.wikipedia.org/wiki/Control_flow].  With the exception of *collection* contruction (whic most scripting languages support), these constructs can be manipulated to support the usage of *count*, *conditional*, and *spin* loops.  This will be presented in examples.


 contruction of loops can be made to fulfill typical usage of these loops.

### Arrays

This section demonstrates how to declare and initialize an array in one of two methods:

  * declare an empty array, and then assign individual items into array
  * declare and initialize an array through a supplied list or string.

Some other operations on arrays will be demonstrated:

  * show array length
  * listing the elements (in a easy way one-liner)
  * enumerate elements of an array by:
    * using a pure collection loop
    * using an iterative loop with an index
    
Note that arrays may be called other names, such as a list.  Awk, TCL, and JScript (JavaScript) do not have real arrays, and emulate array-like functionality in some way.    

### Associative Arrays

This demonstrates how to declare and utilize associative arrays, sometimes called hashes, collections, or dictionaries.  The associative array will be created and initialized in one of two ways:

  * declare empty associative array, and then assign each individual element with key and value.
  * declare and initialize associative array with supplied list or string containing key and value pairs.

This section will also demonstrate:

  * listing all keys of associative array (in easy one-liner)
  * listing all values of associative array (in easy one-liner)
  * concatenate or merge two associative arrays (in easy one-liner hopefully)
  * enumerate associative array by key

**NOTES** Here's a summary of which languages support this useful feature:

*TCL, AWK, and JScript (JavaScript) arrays are really associative arrays, but may have difficulty to enumerate arrays as there is no support for real arrays, so it'll be difficult to return a array containing keys or values.*  

*VBScript does not support associative arrays, but doesn't support real arrays (opposite of JScript), and has access to libraries that a class called Dictionary.  This is can be used, but is extremely limited.*

*Many scripting languages do not have associative arrays, or any indirect support (or even arrays for that matter).  This includes Command Shell (BATCH), C Shell, POSIX Shell, and earlier versions of Bourne Again Shell.*

*Korn Shell '93 has support for associative arrays.  Other scripting languages, e.g. Perl, PowerShell, Python, Ruby, have both arrays and associative arrays.*
    
### Subroutine

This demonstrates how to create and call a subroutine.  A subroutine can be called a procedure or function.  There will be no values returned, and no parameters passed to keep this simple.  

The demonstration subroutine shows how to use the date functionality to print out a friendly date.

**BRAINSTORMING**: *Considering demonstrating the concept of scope in showing global and local variables. The scripting languages vary greatly in this area.  This will be version 2.0 of the project.*

### Arguments

This section introducers how to process command line arguments.  The first demonstration shows how to get the quantity of arguments passed to the script, and then to print an usage statement should the quantity be incorrect.  The other demonstrations show how to print out all of the argument in order then in reverse order.  This exposes some challenges in various languages.

**NOTE**: *This section is in flux as the scripting languages differ quite a bit in this area.  Thus there are numerous considerations at to ways to process this.  This is probably the most complex section in that the scripting languages vary greatly in this area.*  

Currently, the methods in showing how to cycle through arguments (in forward order) are the following order or precedent:

 * *conditional* style loop shifting out elements (only if using positional parameters)
 * *collection* loop maintaining a separate counter.
 * *conditional* style loop shifting out values (unless position parameters)
 * *iterative* style loop using *collection* with a range.
 * *iterative* style loop using a counter

And the precedent of loops for reverse order are:

 * *iterative* style loop using a counter
 * *iterative* style loop using *collection* loop with a supplied range.
     
### Parameters

This section shows how to pass parameters to a subroutine (or function).  This section shows how to pass a single parameter, and also shows how to pass a variable number of parameters.

**Brainstorming**: *Considering expanding this to show how to pass two arrays, and languages vary in this regard.  This may cause the need to introduce the concept of pass-by-value and pass-by-reference, which is implicit in some languages.  This is tabled for version 2.0 of the project*

### Functions

This section covers creating functions, which essentially is a subroutine the returns something.  Currently this demonstrates returning an integer and a string.

**BRAINSTORMING**: *Considering expanding this section to demonstrate returning an array and returning an associative array (hash).  Some scripting languages, such as AWK, are incapable of returning an array, so an array in this case must be passed in by reference (which is done implicitly in AWK). May table this until version 2.0 of this project*


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

* **flag** - special type of **option** (and thus a special type of **argument**) that is not proceeded or coupled with other data.  The **flag** (also called a **switch**) represents binary state, on or off, or true or false. Its existence on the command line signifies an *on* or *true* state, while its absence signifies an *off* or *false* state.

* **function** - *a relation between a set of inputs and a set of permissible outputs with the property that each input is related to exactly one output* [http://en.wikipedia.org/wiki/Mathematical_functions]. A function could be thought of as a subroutine that explicitly returns a value.

* **index** - an integer that is used to retieve a value from an **array**.

* **iteration** - each cycle of a loop is called an iteration.

* **key** - is a string that is used to retreive a value from an **associative array**

* **option** - special type of argument that is prepended by a dash ```-``` character.  This signifies that the operation of a command will be modified.  And option will be followed by some data, which is the value of that option.  If there is not data following the option, then it is just a *flag* (see *flag*)

* **parameter** - *special kind of variable, used in a subroutine to refer to one of the pieces of data provided as input to the subroutine* [http://en.wikipedia.org/wiki/Parameter_(computer_programming)].

* **scalar** - see **variable**.

* **subroutine** -  *sequence of program instructions that perform a specific task, packaged as a unit. This unit can then be used in programs wherever that particular task should be performed. Subprograms may be defined within programs, or separately in libraries that can be used by multiple programs* [http://en.wikipedia.org/wiki/Subroutine].  A **subroutine** can be used for code organization, where function could be considered to perform an operation that returns a value.  Many scripting languages do not distinguish the two, so a subroutine would be a **function** that does not explicitly return a value in this case.

* **switch** - see **flag**.

* **value** - the actual data stored in a variable, element within an array, or element within an associative array.

* **variable** - *storage location and an associated symbolic name (an identifier) which contains some known or unknown quantity or information, a value* [http://en.wikipedia.org/wiki/Variable_(computer_science)].

## Project Changes

* 2014-06-17: Update arguments (all), identify new loop constructs, docs.
* 2014-06-16: Finished TCL section and Perl Section (sans Docs)
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

