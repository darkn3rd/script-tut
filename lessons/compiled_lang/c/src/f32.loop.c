// testbox: title="for (;;) with break"
#include <stdio.h>
#include <string.h>

int main(void) {
    for (;;) {
        printf("Enter your name (quit to exit): ");
        fflush(stdout);
        char answer[256];
        if (fgets(answer, sizeof(answer), stdin) == NULL) break;
        answer[strcspn(answer, "\r\n")] = '\0';

        if (strcmp(answer, "quit") == 0)
            break;

        printf("Hello %s!\n", answer);
    }

    return 0;
}
