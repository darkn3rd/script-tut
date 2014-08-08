#!/usr/bin/env pash
# build a menu string to output to user
$menu = @"
Select an item from the menu.

  1 - Coffee
  2 - Espresso
  3 - Latte
  4 - Machiato
  5 - Capucino
  6 - Mocha
  7 - Tea

Make your selection
"@
 
# get user input 
$selection = Read-Host $menu

# multiway test on selection to matching number using numerical comparison
switch ($selection) {
    "1" { "You selected a Coffee"    }    
    "2" { "You selected an Espresso" } 
    "3" { "You selected a Latte"     }     
    "4" { "You selected a Machiato"  }  
    "5" { "You selected a Capucino"  }  
    "6" { "You selected a Mocha"     }     
    "7" { "You selected a Tea"       }       
    default {"You have not entered a valid selection" }
}