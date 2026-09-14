#include <stdio.h>
#include <string.h>

int main(void) {
    printf("Enter your name: ");
    fflush(stdout);

    char name[256];
    if (fgets(name, sizeof(name), stdin) == NULL) name[0] = '\0';
    name[strcspn(name, "\r\n")] = '\0';

    printf("Hello %s!\n", name);

    return 0;
}
