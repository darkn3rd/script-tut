#include <iostream>
#include <regex>
#include <string>

int main() {
    std::cout << "Input a character: ";
    char keypress;
    std::cin.get(keypress);
    std::string s(1, keypress);

    if (std::regex_search(s, std::regex("[A-Z]")))
        std::cout << "Uppercase letter" << std::endl;
    else if (std::regex_search(s, std::regex("[a-z]")))
        std::cout << "Lowercase letter" << std::endl;
    else if (std::regex_search(s, std::regex("[0-9]")))
        std::cout << "Digit" << std::endl;
    else
        std::cout << "Punctuation, whitespace, or other" << std::endl;

    return 0;
}
