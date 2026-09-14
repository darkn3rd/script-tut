// testbox: title="while (1) with continue"
#include <stdio.h>
#include <string.h>

/* true if s is empty or contains only whitespace */
static int is_blank(const char *s) {
    return s[strspn(s, " \t\r\n")] == '\0';
}

int main(void) {
    while (1) {
        printf("Enter your name (quit to exit): ");
        fflush(stdout);
        char answer[256];
        if (fgets(answer, sizeof(answer), stdin) == NULL) break;
        answer[strcspn(answer, "\r\n")] = '\0';

        if (is_blank(answer))
            continue;

        if (strcmp(answer, "quit") == 0)
            break;

        printf("Hello %s!\n", answer);
    }

    return 0;
}
