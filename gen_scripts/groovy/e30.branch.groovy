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

// test selection to matching number using numerical comparison
if (selection == 1) {
  println "You selected a Coffee"
} else if (selection == 2) {
  println "You selected an Espresso"
} else if (selection == 3) {
  println "You selected a Latte"
} else if (selection == 4) {
  println "You selected a Machiato"
} else if (selection == 5) {
  println "You selected a Capucino"
} else if (selection == 6) {
  println "You selected a Mocha"
} else if (selection == 7) {
  println "You selected a Tea"
} else {
  println "You have not entered a valid selection"
}
