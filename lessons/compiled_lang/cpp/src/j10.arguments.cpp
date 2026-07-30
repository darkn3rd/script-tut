#include <iostream>

int main(int argc, char* argv[]) {
    std::cout << "The arguments passed are:" << std::endl;
    for (int i = 1; i < argc; i++) {
        std::cout << " item " << i << ": " << argv[i] << std::endl;
    }

    return 0;
}
