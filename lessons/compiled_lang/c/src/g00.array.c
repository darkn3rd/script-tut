#include <stdio.h>
#include <string.h>

int main(void) {
    /* populate array one item at a time */
    const char *nicknames[7];
    nicknames[0] = "bob";
    nicknames[1] = "ed";
    nicknames[2] = "steve";
    nicknames[3] = "ralph";
    nicknames[4] = "joe";
    nicknames[5] = "deb";
    nicknames[6] = "kate";

    int total = (int)(sizeof(nicknames) / sizeof(nicknames[0]));
    printf("The total nicknames are: %d\n", total);

    char joined[256] = "";
    for (int i = 0; i < total; i++) {
        if (i > 0) strcat(joined, ", ");
        strcat(joined, nicknames[i]);
    }
    printf("The nicknames are: %s\n", joined);

    return 0;
}
