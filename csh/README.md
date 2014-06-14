

# Rants From Author

This language has been frustrating to document, as a quite a bit of documentation out there is incorrect.  This has caused me more motivation to document C Shell.  

The language itself has posed some quirks that are not some randomly discovered bug, but are the actual behavior.  Two that I found quite profound.  Any reserved word that terminates a block, absolutely must be followed by a newline.  If it is not, weird stuff happens.  Spaces followed by one of these block terminators, such as ```endif``` or ```end```, will also cause the block to fail.

Beyond these quirks, the language is extremely limited.  Here are a few of the limitations I have found:

  * cannot store any type of float, even as a string.  Thus "3.14" can never be saved into any variable, even if used as a string.
  * there are not functions or subroutines
  * arrays items cannot be inserted by index, they must be concatenated into an existing array.

Lastly, besides BATCH programming, this language has the least capabilities of any scripting language.  There are reasons many a system administrator are saying "don't use it". Unless job security is needed, such as C Shell that spawns Awk scripts that subshell perl one-liners that may call C Shell again, I don't see the utility... :)

And anyone documenting C Shell, it seems it is traditional to reference this document:

  * **Top Ten Reasons not to use the C shell** by Bruce Barnett: http://www.grymoire.com/unix/CshTop10.txt