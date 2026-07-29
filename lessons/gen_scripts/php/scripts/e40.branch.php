#!/usr/bin/env php
<?php
// PHP heredoc strips exactly the trailing newline right before the
//  closing marker, so this ends in "...Make your selection: " with no
//  linebreak before the answer is typed - no extra trim needed.
$menu = <<<EOT
Select an item from the menu.

  1 - Coffee
  2 - Espresso
  3 - Latte
  4 - Machiato
  5 - Capucino
  6 - Mocha
  7 - Tea

Make your selection: 
EOT;
echo $menu;
$selection = trim(fgets(STDIN));

switch ($selection) {
  case 1:
    echo "You selected a Coffee\n";
    break;
  case 2:
    echo "You selected an Espresso\n";
    break;
  case 3:
    echo "You selected a Latte\n";
    break;
  case 4:
    echo "You selected a Machiato\n";
    break;
  case 5:
    echo "You selected a Capucino\n";
    break;
  case 6:
    echo "You selected a Mocha\n";
    break;
  case 7:
    echo "You selected a Tea\n";
    break;
  default:
    echo "You have not entered a valid selection\n";
}
?>
