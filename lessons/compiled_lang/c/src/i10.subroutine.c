#include <stdio.h>

/* file-scope globals are directly visible and mutable from any function
 * here - no "global" keyword needed like Python. */
int pond = 500;
int captured = 0;

void fish(void) {
    pond -= 150;
    captured += 150;
}

int main(void) {
    printf("We have %d in this pond.\n", pond);

    fish();
    printf("Fishing from the main pond... We now have %d in the main pond.\n", pond);

    fish();
    printf("Fishing from the main pond... We now have %d in the main pond.\n", pond);

    fish();
    printf("Fishing from the main pond... We now have %d in the main pond.\n", pond);

    printf("We now have a total of %d fish captured\n", captured);

    return 0;
}
