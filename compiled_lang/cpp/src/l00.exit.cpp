#include <cstdlib>
#include <iostream>

const int EX_USAGE = 64;
const int EX_OK = 0;

void usageMessage(const char* scriptName) {
    std::cerr << std::endl;
    std::cerr << "You need to enter one or more numbers:" << std::endl;
    std::cerr << std::endl;
    std::cerr << "   Usage: " << scriptName << " [num1] [num2] [num3]..." << std::endl;
    std::cerr << std::endl;
    std::exit(EX_USAGE);
}

void addNums(int argc, char* argv[]) {
    int sum = 0;
    for (int i = 1; i < argc; i++) {
        sum += std::atoi(argv[i]);
    }
    std::cout << "The summation is: " << sum << "." << std::endl;
    std::exit(EX_OK);
}

int main(int argc, char* argv[]) {
    if (argc - 1 < 1) {
        usageMessage(argv[0]);
    } else {
        addNums(argc, argv);
    }

    return 0;
}
