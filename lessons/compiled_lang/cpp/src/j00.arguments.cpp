#include <cstdlib>
#include <iostream>

int main(int argc, char* argv[]) {
    int argCount = argc - 1;

    if (argCount != 2) {
        std::cerr << std::endl;
        std::cerr << "You need to enter two numbers:" << std::endl;
        std::cerr << std::endl;
        std::cerr << "   Usage: " << argv[0] << " [num1] [num2]" << std::endl;
        std::cerr << std::endl;
    } else {
        int sum = std::atoi(argv[1]) + std::atoi(argv[2]);
        std::cout << "The sum of " << argv[1] << " and " << argv[2] << " is: " << sum << "." << std::endl;
    }

    return 0;
}
