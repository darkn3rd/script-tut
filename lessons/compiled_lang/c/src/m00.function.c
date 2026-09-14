#include <stdarg.h>
#include <stdio.h>

int add_nums(int count, ...) {
    va_list args;
    va_start(args, count);

    int sum = 0;
    for (int i = 0; i < count; i++) {
        sum += va_arg(args, int);
    }
    va_end(args);

    return sum;
}

int main(void) {
    printf("The numbers to be added are 5, 2, 4, 3, 6.\n");

    int result = add_nums(5, 5, 2, 4, 3, 6);
    printf("The result of their summation is: %d.\n", result);

    return 0;
}
