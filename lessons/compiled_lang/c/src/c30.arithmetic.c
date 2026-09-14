#include <math.h>
#include <stdio.h>

int main(void) {
    const double pi = acos(-1.0);
    double result = cos(pi / 4);

    printf("The cosine of pi/4 is: %.15g\n", result);

    return 0;
}
