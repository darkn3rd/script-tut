#include <iostream>
#include <string>

int main() {
    std::cout << "Would you like a toast? [Yes/No]: ";
    std::string response;
    std::getline(std::cin, response);

    // C++'s ternary operator
    std::string message = (response == "Yes") ? "That's great!" : "How about a muffin?";

    std::cout << message << std::endl;

    return 0;
}
