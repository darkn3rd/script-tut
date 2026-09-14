#ifndef _WIN32
#define _POSIX_C_SOURCE 200112L
#endif

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#ifndef _WIN32
extern char **environ;
#endif

struct drink { const char *name; int qty; };

int main(int argc, char *argv[]) {
    /* Already alphabetically ordered, matching the bash/cpp reference's
     * sorted key list - no separate sort step needed for a literal. */
    struct drink drinks[] = {
        {"Capucino", 0}, {"Coffee", 0}, {"Espresso", 0}, {"Latte", 0},
        {"Machiato", 0}, {"Mocha", 0}, {"Tea", 0}
    };
    int count = (int)(sizeof(drinks) / sizeof(drinks[0]));

    if (argc == 1) {
        srand((unsigned int)time(NULL));
        for (int i = 0; i < count; i++) {
            drinks[i].qty = rand() % 3;
        }
    } else {
        for (int a = 1; a < argc; a++) {
            char *colon = strchr(argv[a], ':');
            if (colon == NULL) continue;
            int key_len = (int)(colon - argv[a]);
            for (int i = 0; i < count; i++) {
                if ((int)strlen(drinks[i].name) == key_len &&
                    strncmp(drinks[i].name, argv[a], (size_t)key_len) == 0) {
                    drinks[i].qty = atoi(colon + 1);
                    break;
                }
            }
        }
    }

    char order[256] = "";
    for (int i = 0; i < count; i++) {
        if (drinks[i].qty != 0) {
            char piece[64];
            if (order[0] != '\0') strcat(order, ",");
            snprintf(piece, sizeof(piece), "%s:%d", drinks[i].name, drinks[i].qty);
            strcat(order, piece);
        }
    }

#ifdef _WIN32
    _putenv_s("MY_ORDERS", order);
#else
    setenv("MY_ORDERS", order, 1);
#endif

    /* Plain "KEY=value" lines - same convention every language's
     * n20.setvars.* lesson follows. */
    FILE *dump = fopen("dump_env.out", "w");
    if (dump != NULL) {
#ifdef _WIN32
        fprintf(dump, "MY_ORDERS=%s\n", order);
#else
        for (char **env = environ; *env != NULL; env++) {
            fprintf(dump, "%s\n", *env);
        }
#endif
        fclose(dump);
    }

    /* Explicit flush - stdout isn't a real terminal when the test
     * harness pipes it, so this line would otherwise sit buffered. */
    printf("MY_ORDERS set, Hit Return to continue\n");
    fflush(stdout);

    char discard[256];
    if (fgets(discard, sizeof(discard), stdin) == NULL) { /* ignore */ }

    remove("dump_env.out");

    return 0;
}
