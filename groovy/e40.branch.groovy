#!/usr/bin/env groovy

// build a menu string to output to user
menu = """\
Select an item from the menu.

  1 - Coffee
  2 - Espresso
  3 - Latte
  4 - Machiato
  5 - Capucino
  6 - Mocha
  7 - Tea

Make your selection : """
 
// get user output 
print menu                   // output menu and prompt
selection = System.in.read() // get input of one character as integer ordinal
selection -= 48              // convert ascii ordinal position to real integer

// multiway test on selection to matching number using numerical comparison
switch (selection) {
    case 1:  println "You selected a Coffee";    break
    case 2:  println "You selected an Espresso"; break
    case 3:  println "You selected a Latte";     break
    case 4:  println "You selected a Machiato";  break
    case 5:  println "You selected a Capucino";  break
    case 6:  println "You selected a Mocha";     break
    case 7:  println "You selected a Tea";       break
    default: println "You have not entered a valid selection"
}
