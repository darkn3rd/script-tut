#include <stdio.h>

int main(int argc, char *argv[]) {
    printf("The arguments passed are (reverse order):\n");
    for (int i = argc - 1; i >= 1; i--) {
        printf(" item %d: %s\n", i, argv[i]);
    }

    return 0;
}
