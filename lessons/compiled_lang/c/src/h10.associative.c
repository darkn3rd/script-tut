#include <stdio.h>

struct entry { const char *key; int value; };

int main(void) {
    /* initialize with key/value pairs */
    struct entry ages[6] = {
        {"bob", 34}, {"ed", 58}, {"steve", 32}, {"ralph", 23}
    };
    int count = 4;

    /* append another set of key/value pairs */
    struct entry more[2] = {{"deb", 46}, {"kate", 19}};
    for (int i = 0; i < 2; i++) ages[count++] = more[i];

    printf("The ages are: \n");
    for (int i = 0; i < count; i++) {
        printf(" ages[%s]=%d\n", ages[i].key, ages[i].value);
    }

    return 0;
}
