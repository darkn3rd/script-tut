#include <initializer_list>
#include <iostream>

int addNums(std::initializer_list<int> numbers) {
    int sum = 0;
    for (int num : numbers) {
        sum += num;
    }
    return sum;
}

int main() {
    std::cout << "The numbers to be added are 5, 2, 4, 3, 6." << std::endl;

    int result = addNums({5, 2, 4, 3, 6});
    std::cout << "The result of their summation is: " << result << "." << std::endl;

    return 0;
}
