#include <stdio.h>

int main(int argc, char *argv[]) {
    printf("The arguments passed are:\n");
    for (int i = 1; i < argc; i++) {
        printf(" item %d: %s\n", i, argv[i]);
    }

    return 0;
}
