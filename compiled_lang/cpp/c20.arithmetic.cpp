#include <cmath>
#include <iostream>

int main() {
    // acos(-1.0), not the M_PI macro - M_PI isn't standard C++ and needs
    //  _USE_MATH_DEFINES before <cmath> on MSVC, so this stays portable
    const double pi = std::acos(-1.0);
    int radius = 3;
    double area = pi * std::pow(radius, 2);

    std::cout << "The area of a circle (radius=" << radius << ") is: " << area << "." << std::endl;

    return 0;
}
