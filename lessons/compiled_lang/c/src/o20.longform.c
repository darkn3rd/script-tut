#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* No argv library here has any built-in notion of a long-form flag
 * that also takes a following value - like the bash reference, this is
 * parsed entirely by hand. */
void usage(FILE *os, const char *cmd) {
    fprintf(os, "\n");
    fprintf(os, "Usage: %s [--coffee|-c N] [--espresso|-e N] [--latte|-l N] [--macchiato|-k N] [--capucino|-p N] [--mocha|-m N] [--tea|-t N] [--help|-h|-?]\n", cmd);
    fprintf(os, "\n");
    fprintf(os, "  --coffee,    -c N  Coffee\n");
    fprintf(os, "  --espresso,  -e N  Espresso\n");
    fprintf(os, "  --latte,     -l N  Latte\n");
    fprintf(os, "  --macchiato, -k N  Machiato\n");
    fprintf(os, "  --capucino,  -p N  Capucino\n");
    fprintf(os, "  --mocha,     -m N  Mocha\n");
    fprintf(os, "  --tea,       -t N  Tea\n");
    fprintf(os, "  --help,      -h    Display this help message\n");
    fprintf(os, "  -?                 Display this help message\n");
    fprintf(os, "\n");
}

int main(int argc, char *argv[]) {
    const char *names[16];
    int counts[16];
    int total = 0;

    int i = 1;
    while (i < argc) {
        const char *flag = argv[i];
        if (strcmp(flag, "--coffee") == 0 || strcmp(flag, "-c") == 0) { names[total] = "coffee"; counts[total++] = atoi(argv[i + 1]); i += 2; }
        else if (strcmp(flag, "--espresso") == 0 || strcmp(flag, "-e") == 0) { names[total] = "espresso"; counts[total++] = atoi(argv[i + 1]); i += 2; }
        else if (strcmp(flag, "--latte") == 0 || strcmp(flag, "-l") == 0) { names[total] = "latte"; counts[total++] = atoi(argv[i + 1]); i += 2; }
        else if (strcmp(flag, "--macchiato") == 0 || strcmp(flag, "-k") == 0) { names[total] = "macchiato"; counts[total++] = atoi(argv[i + 1]); i += 2; }
        else if (strcmp(flag, "--capucino") == 0 || strcmp(flag, "-p") == 0) { names[total] = "capucino"; counts[total++] = atoi(argv[i + 1]); i += 2; }
        else if (strcmp(flag, "--mocha") == 0 || strcmp(flag, "-m") == 0) { names[total] = "mocha"; counts[total++] = atoi(argv[i + 1]); i += 2; }
        else if (strcmp(flag, "--tea") == 0 || strcmp(flag, "-t") == 0) { names[total] = "tea"; counts[total++] = atoi(argv[i + 1]); i += 2; }
        else if (strcmp(flag, "--help") == 0 || strcmp(flag, "-h") == 0 || strcmp(flag, "-?") == 0) { usage(stdout, argv[0]); return 0; }
        else { usage(stderr, argv[0]); return 1; }
    }

    if (total == 0) {
        usage(stderr, argv[0]);
        return 1;
    }

    printf("\n");
    printf("You ordered: \n");
    for (int j = 0; j < total; j++) {
        int n = counts[j];
        printf("* %d %s%s\n", n, names[j], n != 1 ? "s" : "");
    }

    return 0;
}
