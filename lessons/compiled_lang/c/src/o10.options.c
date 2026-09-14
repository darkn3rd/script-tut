#include <stdio.h>
#include <string.h>

void usage(FILE *os, const char *cmd) {
    fprintf(os, "\n");
    fprintf(os, "Usage: %s [-c] [-e] [-l] [-k] [-p] [-m] [-t] [-h|-?]\n", cmd);
    fprintf(os, "\n");
    fprintf(os, "  -c  Coffee\n");
    fprintf(os, "  -e  Espresso\n");
    fprintf(os, "  -l  Latte\n");
    fprintf(os, "  -k  Machiato\n");
    fprintf(os, "  -p  Capucino\n");
    fprintf(os, "  -m  Mocha\n");
    fprintf(os, "  -t  Tea\n");
    fprintf(os, "  -h  Display this help message\n");
    fprintf(os, "  -?  Display this help message\n");
    fprintf(os, "\n");
}

int main(int argc, char *argv[]) {
    const char *orders[16];
    int count = 0;

    for (int i = 1; i < argc; i++) {
        const char *flag = argv[i];
        if (strcmp(flag, "-c") == 0) { orders[count++] = "coffee"; }
        else if (strcmp(flag, "-e") == 0) { orders[count++] = "espresso"; }
        else if (strcmp(flag, "-l") == 0) { orders[count++] = "latte"; }
        else if (strcmp(flag, "-k") == 0) { orders[count++] = "macchiato"; }
        else if (strcmp(flag, "-p") == 0) { orders[count++] = "capucino"; }
        else if (strcmp(flag, "-m") == 0) { orders[count++] = "mocha"; }
        else if (strcmp(flag, "-t") == 0) { orders[count++] = "tea"; }
        else if (strcmp(flag, "-h") == 0 || strcmp(flag, "-?") == 0) {
            usage(stdout, argv[0]);
            return 0;
        } else {
            usage(stderr, argv[0]);
            return 1;
        }
    }

    if (count == 0) {
        usage(stderr, argv[0]);
        return 1;
    }

    printf("\n");
    printf("You ordered: \n");
    for (int i = 0; i < count; i++) {
        printf("* %s\n", orders[i]);
    }

    return 0;
}
