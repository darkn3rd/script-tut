// testbox: title="while loop"
#include <iostream>
#include <string>

int main() {
    std::string answer = "";
    while (answer != "quit") {
        std::cout << "Enter your name (quit to Exit): ";
        std::getline(std::cin, answer);

        if (answer != "quit")
            std::cout << "Hello " << answer << "!" << std::endl;
    }

    return 0;
}
