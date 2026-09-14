#include <stdio.h>
#include <string.h>

int main(void) {
    printf("Would you like a toast? [Yes/No]: ");
    fflush(stdout);

    char response[256];
    if (fgets(response, sizeof(response), stdin) == NULL) response[0] = '\0';
    response[strcspn(response, "\r\n")] = '\0';

    /* C's ternary operator */
    const char *message = (strcmp(response, "Yes") == 0) ? "That's great!" : "How about a muffin?";

    printf("%s\n", message);

    return 0;
}
