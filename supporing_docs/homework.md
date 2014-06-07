# Topics as Assignments

© 2014, Joaquin Menchaca

I have sometimes packaged up these tutorials in the form of homework assignments.  If you would like to do this as well, or use this material as a form of a quiz to certify basic understanding of any given scripting language, then here you go.

# Basic Scripting

This basics cover input, output, creating and using variables, creating and using arrays (including associative arrays), and using branching and looping constructs.

## Output

1. Write a program that outputs textual information to the command line console.

## Variables

The purpose of this exercise is to use variables and output their results to the command-line console.  Secondary lessons are to learn how to escape characters, as well know the differences of variable interpolation and string concatenation.

1. Write a program that declares some variables (string, integer, a single character) and outputs the variable.  
2. If the variable represents a string, then output its result surrounded by double-quote ```"``` characters, and if the output is a single character, output the result surrounded by single-quote ```'``` characters.
3. Utilize string concatenation to show the values.  Thus the string will be built by merge the variables with a string components.
4. If the scripting language supports this, utilize varable interpolation, that is, the variable is embedded within the string.  


## Arithmetic

The purposes of these exercises is to gain exposure to using mathematical operators and mathematical functions.  This exercise is by no means to be a robust overview.

1. Write a script that uses basic mathematical operations, such as add, multiply, addition, and subtraction.
2. Write a script that uses boolean logic, and outputs the truth of any statement.
3. Write a script that uses floating point values and performs operations on the values without losing percision.  In otherwords, if you divide 3 by 2, the value should be 1.5, not 1.
4. Write a script that can square a value.  Scripting languages vary in this, such as having operators that do this, or having some Mathematical library functions that do this operation.
5. Write a script that uses some advanced mathemetical operation, such as calculating cosine.  This will undoubtedly utilize some form of mathematical library.

## Input (Interactive)

The goal of this area is to interactively process input from the user and also to print out short prompts to the user asking for such input.  More advance usage of standard input requires knowledge of looping constructs, so this is avoided for now.

1. Write a script that prompts a user for input.  Capture the input and output the result of that input. 

## Branching

This topic area covering branching on a single variable of input.  It has some subcategories.

### Selecting on an Integer

1. Write a script that test the value of an integer, and outputs a result.
2. The test should evaulate one of three different states.

### Selecting on a Character

1. Write a script that test the contents of a character, and outputs a result.
2. As a bonus, the contents are matched against a pattern, which determines the result.

### Multi-Select on an Integer

1. Write a script that in one block, evaluates a state of a single integer, and upon determining that state, branches to the appropriate block.  (Note: Some scripting languages do not have this capability.)

### Multi-Select on a Character

1. Write a script that in one block, evaluates a state of a single character, and upon determining that state, branches to the appropriate block.  (Note: Some scripting languages do not have this capability.)
2. As a bonus, the contents are matched against a pattern. (Note: For scripting languages that can evaluate multiple states on a single character, do not have a native ability to test a pattern match on that single character.  Thus some creativity is needed to achieve the same results.)

## Looping

This topic covers looping, which varies greatly amongst scripting languages.  Looping constructs can be categorized into sub-categories.

### Interative (Count) Loop

1. Write a script that counts downward from two sets of numbers, such as 10 down to 1.
2. Utilize alternative looping constructs provided by the scriptping langauge to acheive the same results.

### Conditional Loop

1. Write a script that processes input from a user, and outputs the results.
2. The user can specify some way to quit the program.
3. Utilize various looping constructs afforded in the scripting language to acheive the same results.
4. As a bonus, create a spin loop that breaks out of loop upon the user requests.


### Collection Loop

1. Write a script that can process a list of items, such as a directory listing, a space delmited string, or an array.
2. This should use the scripting languages native collection loop, such as ```for ... in``` or ```for each```.  Note that some scripting languages may not have this functionality, so an interative loop (above) must be used.

## Arrays

Note: Some scripting languages, such as shell, TCL, and JScript, so not have native support for Arrays. Thus some creativity will need to be utilized.  If associative arrays (hashes) are supported, the keys will contain numerical values, and if these are not supported, space delimited strings can be used.

1. Create a script that assigns items to an array one by one through an index, and then prints the number of items as well as their values.
2. Create a script that creates an array by using a supplied list of items in one single line, and then outputs the results.
3. Create a script that creates an array by using a supplied list of items in one single line, and then outputs the results with corresponding index number.

## Associative Arrays

Associative Arrays are Arrays whose index is a string rather than a numerical value.  These are often called hashes, dicitonaries, or collections.  Some scripting languages may not have native support for this, but can use libraries to get some similar results.  For a programming language without any support for this (which is unusual), one can use parallel arrays, that is, two arrays whose ordered sequence matches. 

1. Create a script that assigns items into an associative array using a specified key, one by one; then print all of the keys and values.
2. Create a sciptt that creats an associative array by using a supplied list of key/value pairs, then prints the key and value pairs.
3. Create a script that merges two associative arrays together, and then prints the key and value pairs.

# Intermediate Scripting

The intermediate section covers processing basic command-line arguments, organizing or packaging code into subroutines, using functions, and passing parameters to subroutines or functions.

## Subroutine (Procedure)

Note that the term subroutine is a bundling of code that does not return a value.  These are sometimes just functions that do not return anything.  The goal here is just to run a block of code packaged some grouping.  Processing return values from a function is covered later.

1. Create a script that declares and calls a subroutine.  The subroutine must do something, such as print out a formatted date.

## Arguments, Command-Line

1. Create a script that tests number of arguments, prints a usage statement if that test fails, and processing arguments if the test succeeds.
2. Create a script that prints out all the arguments passed into the script.
3. Create a script that prints out all the arguemnts passed to the script, in reverse order.

## Parameters

1. Create a script that passes explicit number of parameters to a subroutine.
2. Create a script that passes a variable number of parameters to a subroutine.  Note that some scripting languages may not have this capability, so as an alternative, an single array can be passed into the subroutine.

## Function

1. Create a script that returns a numerical value.
2. Create a script that returns a string.  Note that for a scripting langauge, this may be trivial, but in contrast to compiled langauges, this could normally require returning references or pointers to a heap allocated array of characters. This shows the simplicity of such an operation that is cumbersome in other languages.
3. Create a script that returns an array, such as a sorted list.