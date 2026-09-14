// testbox: title="while loop"
#include <stdio.h>
#include <string.h>

int main(void) {
    char answer[256] = "";
    while (strcmp(answer, "quit") != 0) {
        printf("Enter your name (quit to Exit): ");
        fflush(stdout);
        if (fgets(answer, sizeof(answer), stdin) == NULL) { answer[0] = '\0'; break; }
        answer[strcspn(answer, "\r\n")] = '\0';

        if (strcmp(answer, "quit") != 0)
            printf("Hello %s!\n", answer);
    }

    return 0;
}
