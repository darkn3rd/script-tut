#include <cctype>
#include <iostream>

int main() {
    std::cout << "Input a character: ";
    char keypress;
    std::cin.get(keypress);

    // switch requires a single comparable value, not a pattern, so
    //  classify first and switch on the result
    int kind;
    if (std::isupper(static_cast<unsigned char>(keypress)))
        kind = 0;
    else if (std::islower(static_cast<unsigned char>(keypress)))
        kind = 1;
    else if (std::isdigit(static_cast<unsigned char>(keypress)))
        kind = 2;
    else
        kind = 3;

    switch (kind) {
        case 0: std::cout << "Uppercase letter" << std::endl; break;
        case 1: std::cout << "Lowercase letter" << std::endl; break;
        case 2: std::cout << "Digit" << std::endl; break;
        default: std::cout << "Punctuation, whitespace, or other" << std::endl;
    }

    return 0;
}
