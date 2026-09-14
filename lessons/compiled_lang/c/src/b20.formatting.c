#include <stdio.h>

int main(void) {
    int number = 5;
    char character = 'a';
    const char *text = "This is a string";

    printf("Number is %d.\nCharacter is '%c'.\nString is \"%s\".\n",
        number, character, text);

    return 0;
}
