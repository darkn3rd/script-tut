#include <stdio.h>
#include <stdlib.h>

#define EX_USAGE 64
#define EX_OK 0

void usage_message(const char *script_name) {
    fprintf(stderr, "\n");
    fprintf(stderr, "You need to enter one or more numbers:\n");
    fprintf(stderr, "\n");
    fprintf(stderr, "   Usage: %s [num1] [num2] [num3]...\n", script_name);
    fprintf(stderr, "\n");
    exit(EX_USAGE);
}

void add_nums(int argc, char *argv[]) {
    int sum = 0;
    for (int i = 1; i < argc; i++) {
        sum += atoi(argv[i]);
    }
    printf("The summation is: %d.\n", sum);
    exit(EX_OK);
}

int main(int argc, char *argv[]) {
    if (argc - 1 < 1) {
        usage_message(argv[0]);
    } else {
        add_nums(argc, argv);
    }

    return 0;
}
