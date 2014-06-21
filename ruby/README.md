# Scripting Tutorial: Ruby

© Joaquin Menchaca, 2014

## Getting Ruby

### Getting Ruby on Mac

Before taking full advantage of Ruby or using some of the package managers mentioned in this ReadMe, you will need to get Xcode Developer Tools from Apple and also install the Xcode command line tools.  This process unfortunately differs from OS version to OS version.  There are some decent instructions at: http://guide.macports.org/#installing.xcode.

Here's how you can get latest tools

#### Default

A vanilla Mac OS X 10.8.5 will come with a 6-year old Ruby 1.8.7.  Most likely, you'll want something more modern.

```bash
ruby -v
ruby 1.8.7 (2012-02-08 patchlevel 358) [universal-darwin12.0]
```

#### Homebrew

Homebrew [http://brew.sh/] is a popular single-user package management system that can install newer versions of Ruby and as well as other popular packages.  It uses existing Macintosh libraries and tools, and is by far the path of least resistance to get packages.  Homebrew and Ruby can be installed with these commands (Tested on Mac OS X 10.8.5):

```bash
ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
brew update
brew doctor
echo export PATH='/usr/local/bin:$PATH' >> ~/.bash_profile
. ~/.bash_profile
brew install ruby
```

#### MacPorts

Mac Ports is a package management solution inspired from BSD ports.  MacPorts has the largest library of packages to date.  MacPorts works for all users, not just for only one developer on the system, and as such, making this more ideal if multiple users use the same system.  MacPorts installs latest tools and libraries as needed for the packages it installs.  This may be a good thing as Apple Mac OS X has extremely old versions of many tools that may have numerous bugs and security problems.

The disadvantage these days, is that most of the Ruby developer community uses Homebrew (along with RVM) to install and manage Ruby.  Some gems (ruby packages), are in particular engineered to only work with Homebrew (such as hard coded absolute paths), and thus will fail with MacPorts.

For MacPorts, you can install MacPorts on the desired target Mac OS X.  For example, for Mac OS X 10.8.5, you can do this:

```bash
curl -O https://distfiles.macports.org/MacPorts/MacPorts-2.3.0-10.8-MountainLion.pkg
sudo -S installer -verbose -pkg MacPorts-2.3.0-10.8-MountainLion.pkg -target /
```

After, you can update and install Ruby using something like this:

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
   * collection loop
      * iterate through set of items 
      * example: directory listing
      * syntax examples
        * ```for...do...end```
        * each iterator
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
