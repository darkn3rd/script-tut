#include <iostream>
#include <string>

int main() {
    int number = 5;
    char character = 'a';
    std::string text = "This is a string";

    std::string output = "Number is " + std::to_string(number) + ".\n"
        + "Character is '" + character + "'.\n"
        + "String is \"" + text + "\".\n";

    std::cout << output;

    return 0;
}
