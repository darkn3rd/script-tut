#include <stdio.h>
#include <string.h>

/* usage() prints to whichever stream the caller passes - stdout for an
 * explicit -h/-?, stderr for a usage error. */
void usage(FILE *os, const char *cmd) {
    fprintf(os, "\n");
    fprintf(os, "Usage: %s [-c|-e|-l|-k|-p|-m|-t] [-h|-?]\n", cmd);
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
    if (argc < 2) {
        usage(stderr, argv[0]);
        return 1;
    }

    const char *flag = argv[1];
    if (strcmp(flag, "-c") == 0) { printf("You ordered a Coffee.\n"); return 0; }
    if (strcmp(flag, "-e") == 0) { printf("You ordered an Espresso.\n"); return 0; }
    if (strcmp(flag, "-l") == 0) { printf("You ordered a Latte.\n"); return 0; }
    if (strcmp(flag, "-k") == 0) { printf("You ordered a Machiato.\n"); return 0; }
    if (strcmp(flag, "-p") == 0) { printf("You ordered a Capucino.\n"); return 0; }
    if (strcmp(flag, "-m") == 0) { printf("You ordered a Mocha.\n"); return 0; }
    if (strcmp(flag, "-t") == 0) { printf("You ordered a Tea.\n"); return 0; }
    if (strcmp(flag, "-h") == 0 || strcmp(flag, "-?") == 0) {
        usage(stdout, argv[0]);
        return 0;
    }

    usage(stderr, argv[0]);
    return 1;
}
