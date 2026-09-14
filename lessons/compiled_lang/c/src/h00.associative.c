#include <stdio.h>

/* Plain C has no built-in map type - a small fixed-size array of
 * key/value pairs, searched linearly, is the idiomatic stand-in for
 * this many entries (see ../README.md). */
struct entry { const char *key; int value; };

int main(void) {
    struct entry ages[6];
    int count = 0;

    /* insert one element at a time */
    ages[count++] = (struct entry){"bob", 34};
    ages[count++] = (struct entry){"ed", 58};
    ages[count++] = (struct entry){"steve", 32};
    ages[count++] = (struct entry){"ralph", 23};
    ages[count++] = (struct entry){"deb", 46};
    ages[count++] = (struct entry){"kate", 19};

    printf("Keys (names):  ");
    for (int i = 0; i < count; i++) {
        if (i > 0) printf(", ");
        printf("%s", ages[i].key);
    }
    printf("\n");

    printf("Values (ages): ");
    for (int i = 0; i < count; i++) {
        if (i > 0) printf(", ");
        printf("%d", ages[i].value);
    }
    printf("\n");

    return 0;
}
