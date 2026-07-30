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

    switch (selection) {
        case 1: std::cout << "You selected a Coffee" << std::endl; break;
        case 2: std::cout << "You selected an Espresso" << std::endl; break;
        case 3: std::cout << "You selected a Latte" << std::endl; break;
        case 4: std::cout << "You selected a Machiato" << std::endl; break;
        case 5: std::cout << "You selected a Capucino" << std::endl; break;
        case 6: std::cout << "You selected a Mocha" << std::endl; break;
        case 7: std::cout << "You selected a Tea" << std::endl; break;
        default: std::cout << "You have not entered a valid selection" << std::endl;
    }

    return 0;
}
