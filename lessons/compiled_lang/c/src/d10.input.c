#include <stdio.h>

int main(void) {
    printf("Input a character: ");
    fflush(stdout);
    char character = (char)getchar();
    printf("You entered: >>|%c|<<.\n", character);

    return 0;
}
