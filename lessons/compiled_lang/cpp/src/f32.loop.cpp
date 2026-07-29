// testbox: title="for (;;) with break"
#include <iostream>
#include <string>

int main() {
    for (;;) {
        std::cout << "Enter your name (quit to exit): ";
        std::string answer;
        std::getline(std::cin, answer);

        if (answer == "quit")
            break;

        std::cout << "Hello " << answer << "!" << std::endl;
    }

    return 0;
}
