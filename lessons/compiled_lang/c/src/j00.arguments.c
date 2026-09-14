#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    int arg_count = argc - 1;

    if (arg_count != 2) {
        fprintf(stderr, "\n");
        fprintf(stderr, "You need to enter two numbers:\n");
        fprintf(stderr, "\n");
        fprintf(stderr, "   Usage: %s [num1] [num2]\n", argv[0]);
        fprintf(stderr, "\n");
    } else {
        int sum = atoi(argv[1]) + atoi(argv[2]);
        printf("The sum of %s and %s is: %d.\n", argv[1], argv[2], sum);
    }

    return 0;
}
