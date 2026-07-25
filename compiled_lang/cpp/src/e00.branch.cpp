#include <iostream>
#include <string>

int main() {
    std::cout << "Would you like a toast? [Yes/No]: ";
    std::string response;
    std::getline(std::cin, response);

    std::string message;
    if (response == "Yes")
        message = "That's great!";
    else
        message = "How about a muffin?";

    std::cout << message << std::endl;

    return 0;
}
