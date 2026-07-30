#include <iostream>

int main() {
    std::cout <<
        "Select an item from the menu.\n\n"
        "  1 - Coffee\n"
        "  2 - Espresso\n"
        "  3 - Latte\n"
        "  4 - Machiato\n"
        "  5 - Capucino\n"
        "  6 - Mocha\n"
        "  7 - Tea\n\n"
        "Make your selection: ";

    char keypress;
    std::cin.get(keypress);
    int selection = keypress - '0';

    if (selection == 1)
        std::cout << "You selected a Coffee" << std::endl;
    else if (selection == 2)
        std::cout << "You selected an Espresso" << std::endl;
    else if (selection == 3)
        std::cout << "You selected a Latte" << std::endl;
    else if (selection == 4)
        std::cout << "You selected a Machiato" << std::endl;
    else if (selection == 5)
        std::cout << "You selected a Capucino" << std::endl;
    else if (selection == 6)
        std::cout << "You selected a Mocha" << std::endl;
    else if (selection == 7)
        std::cout << "You selected a Tea" << std::endl;
    else
        std::cout << "You have not entered a valid selection" << std::endl;

    return 0;
}
