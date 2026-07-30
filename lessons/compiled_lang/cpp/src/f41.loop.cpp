// testbox: title="for (;;) with continue"
#include <iostream>
#include <string>

// true if s is empty or contains only whitespace
bool is_blank(const std::string& s) {
    return s.find_first_not_of(" \t\r\n") == std::string::npos;
}

int main() {
    for (;;) {
        std::cout << "Enter your name (quit to exit): ";
        std::string answer;
        std::getline(std::cin, answer);

        if (is_blank(answer))
            continue;

        if (answer == "quit")
            break;

        std::cout << "Hello " << answer << "!" << std::endl;
    }

    return 0;
}
