#include <math.h>
#include <stdio.h>

int main(void) {
    /* acos(-1.0), not the nonstandard M_PI macro - see cpp's own lesson
     * for why. */
    const double pi = acos(-1.0);
    int radius = 3;
    double area = pi * pow(radius, 2);

    printf("The area of a circle (radius=%d) is: %.15g.\n", radius, area);

    return 0;
}
