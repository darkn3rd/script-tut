#include <iostream>

int main(int argc, char* argv[]) {
    std::cout << "The arguments passed are (reverse order):" << std::endl;
    for (int i = argc - 1; i >= 1; i--) {
        std::cout << " item " << i << ": " << argv[i] << std::endl;
    }

    return 0;
}
