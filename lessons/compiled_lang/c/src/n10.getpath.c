#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(void) {
    const char *path = getenv("PATH");
    if (path == NULL) {
        return 0;
    }

    /* A given PATH value never mixes both delimiters, so checking for a
     * semicolon first is enough to tell which one actually applies. */
    char sep = strchr(path, ';') != NULL ? ';' : ':';

    const char *start = path;
    const char *pos;
    while ((pos = strchr(start, sep)) != NULL) {
        printf("%.*s\n", (int)(pos - start), start);
        start = pos + 1;
    }
    printf("%s\n", start);

    return 0;
}
