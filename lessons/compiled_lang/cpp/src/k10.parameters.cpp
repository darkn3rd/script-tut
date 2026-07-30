#include <initializer_list>
#include <iostream>

void addNums(std::initializer_list<int> numbers) {
    int sum = 0;
    for (int num : numbers) {
        sum += num;
    }
    std::cout << "The summation is: " << sum << "." << std::endl;
}

int main() {
    std::cout << "Sending: 5, 2, 4, 3, 6" << std::endl;
    addNums({5, 2, 4, 3, 6});

    return 0;
}
