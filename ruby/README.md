# Scripting Tutorial: Ruby

© Joaquin Menchaca, 2014

## Getting Ruby

### Getting Ruby on Mac

Before taking full advantage of Ruby or using some of the package managers mentioned in this article, you will need to get Xcode Developer Tools from Apple and also install the Xcode command line tools.  This process unfortunately differs.  There are some decent instructions at: http://guide.macports.org/#installing.xcode.


#### Default

A vanilla Mac OS X 10.8.5 will come with Ruby 1.8.7.

```bash
ruby -v
ruby 1.8.7 (2012-02-08 patchlevel 358) [universal-darwin12.0]
```

#### Homebrew

Homebrew [http://brew.sh/] is a popular single-user package management system that can install newer versions of Ruby and popular packages.  It uses existing Macintosh libraries and tools, and is by far the path of least resistance to get packages.  Homebrew and Ruby can be installed with these commands:

```bash
ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
brew update
brew doctor
brew install ruby
```

Afterward, Ruby can be installed through: ```brew install ruby```

#### MacPorts

Mac Ports

For MacPorts, you can install MacPorts on the desired target Mac OS X.

```bash
sudo port -v selfupdate
sudo port install ruby20
sudo port select --set ruby ruby20
sudo port select --list ruby

```

#### RVM

The most popular way to install Ruby and manage Ruby versions is to use RVM (Ruby Version Manager) [https://rvm.io/]: ```$ \curl -sSL https://get.rvm.io | bash -s stable```.  Afterwards, you can install something like Ruby 2.1.2 with ```rvm install ruby-2.1.2```.  

On Mac OS X, it seems that RVM now requires Homebrew [http://brew.sh/], and will install after any Ruby install.







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
