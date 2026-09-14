#include <stdio.h>

int main(void) {
    const char *nicknames[] = {"bob", "ed", "steve", "ralph", "joe", "deb", "kate"};
    int total = (int)(sizeof(nicknames) / sizeof(nicknames[0]));

    printf("The names are: \n");
    for (int i = 0; i < total; i++) {
        printf("  %s\n", nicknames[i]);
    }

    return 0;
}
