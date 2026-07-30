#include <iostream>

int main() {
    bool result = (true && false) || true;

    std::cout << "The statement (true AND false OR true) is: " << std::boolalpha << result << std::endl;

    return 0;
}
