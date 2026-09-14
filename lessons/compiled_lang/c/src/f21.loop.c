// testbox: title="for loop as conditional loop"
#include <stdio.h>
#include <string.h>

int main(void) {
    /* the for statement's own increment clause is left empty - answer is
     * reassigned in the body instead. */
    char answer[256];
    for (strcpy(answer, ""); strcmp(answer, "quit") != 0; ) {
        printf("Enter your name (quit to Exit): ");
        fflush(stdout);
        if (fgets(answer, sizeof(answer), stdin) == NULL) { answer[0] = '\0'; break; }
        answer[strcspn(answer, "\r\n")] = '\0';

        if (strcmp(answer, "quit") != 0)
            printf("Hello %s!\n", answer);
    }

    return 0;
}
