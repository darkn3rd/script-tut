// testbox: title="do-while loop"
#include <iostream>

int main() {
    int count = 10;
    do {
        std::cout << "Count is " << count << std::endl;
        count--;
    } while (count > 0);

    return 0;
}
