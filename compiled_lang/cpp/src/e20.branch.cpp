#include <iostream>
#include <string>

int main() {
    std::cout << "Input a number: ";
    std::string line;
    std::getline(std::cin, line);
    int number = std::stoi(line);

    if (number > 0)
        std::cout << "Number is greater than 0" << std::endl;
    else if (number < 0)
        std::cout << "Number is less than 0" << std::endl;
    else
        std::cout << "Number is 0" << std::endl;

    return 0;
}
