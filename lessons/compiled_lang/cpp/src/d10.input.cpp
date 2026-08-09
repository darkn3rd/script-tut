#include <iostream>

int main() {
    std::cout << "Input a character: " << std::flush;
    char character = std::cin.get();
    std::cout << "You entered: >>|" << character << "|<<." << std::endl;

    return 0;
}
