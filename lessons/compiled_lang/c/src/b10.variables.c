#include <stdio.h>

int main(void) {
    int number = 5;
    char character = 'a';
    const char *text = "This is a string";

    printf("Number is %d.\n", number);
    printf("Character is '%c'.\n", character);
    printf("String is \"%s\".\n", text);

    return 0;
}
