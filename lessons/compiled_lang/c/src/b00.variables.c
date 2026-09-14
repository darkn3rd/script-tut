#include <stdio.h>
#include <string.h>

int main(void) {
    int number = 5;
    char character = 'a';
    const char *text = "This is a string";

    /* C has no string '+' operator - snprintf/strcat is how pieces get
     * concatenated into one buffer. */
    char num_str[16];
    snprintf(num_str, sizeof(num_str), "%d", number);
    char char_str[2] = { character, '\0' };

    char output[256] = "";
    strcat(output, "Number is ");
    strcat(output, num_str);
    strcat(output, ".\nCharacter is '");
    strcat(output, char_str);
    strcat(output, "'.\nString is \"");
    strcat(output, text);
    strcat(output, "\".\n");

    printf("%s", output);

    return 0;
}
