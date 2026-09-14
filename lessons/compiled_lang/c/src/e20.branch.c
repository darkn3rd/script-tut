#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(void) {
    printf("Input a number: ");
    fflush(stdout);

    char line[256];
    if (fgets(line, sizeof(line), stdin) == NULL) line[0] = '\0';
    line[strcspn(line, "\r\n")] = '\0';
    int number = atoi(line);

    if (number > 0)
        printf("Number is greater than 0\n");
    else if (number < 0)
        printf("Number is less than 0\n");
    else
        printf("Number is 0\n");

    return 0;
}
