#include <cstdio>

void celsius(double fahrenheit) {
    double temperature = (fahrenheit - 32.0) * 5 / 9;
    printf("The Celsius temperature is %.1f degrees.\n", temperature);
}

int main() {
    double temperature = 73;
    celsius(temperature);

    return 0;
}
