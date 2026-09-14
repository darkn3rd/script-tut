#include <stdarg.h>
#include <stdio.h>

/* C's own variable-argument mechanism (the same one printf itself is
 * built on) - count tells the function how many ints follow, since
 * va_arg has no way to know that on its own. */
void add_nums(int count, ...) {
    va_list args;
    va_start(args, count);

    int sum = 0;
    for (int i = 0; i < count; i++) {
        sum += va_arg(args, int);
    }
    va_end(args);

    printf("The summation is: %d.\n", sum);
}

int main(void) {
    printf("Sending: 5, 2, 4, 3, 6\n");
    add_nums(5, 5, 2, 4, 3, 6);

    return 0;
}
