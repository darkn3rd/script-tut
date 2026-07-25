#include <cmath>
#include <iostream>

int main() {
    const double pi = std::acos(-1.0);
    double result = std::cos(pi / 4);

    std::cout << "The cosine of pi/4 is: " << result << std::endl;

    return 0;
}
