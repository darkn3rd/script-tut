#include <stdbool.h>
#include <stdio.h>

int main(void) {
    bool result = (true && false) || true;

    printf("The statement (true AND false OR true) is: %s\n", result ? "true" : "false");

    return 0;
}
