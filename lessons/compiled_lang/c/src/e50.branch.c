#include <ctype.h>
#include <stdio.h>

int main(void) {
    printf("Input a character: ");
    fflush(stdout);
    int keypress = getchar();

    /* switch requires a single comparable value, not a pattern, so
     * classify first and switch on the result */
    int kind;
    if (isupper(keypress))
        kind = 0;
    else if (islower(keypress))
        kind = 1;
    else if (isdigit(keypress))
        kind = 2;
    else
        kind = 3;

    switch (kind) {
        case 0: printf("Uppercase letter\n"); break;
        case 1: printf("Lowercase letter\n"); break;
        case 2: printf("Digit\n"); break;
        default: printf("Punctuation, whitespace, or other\n");
    }

    return 0;
}
