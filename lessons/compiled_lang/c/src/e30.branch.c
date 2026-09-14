#include <stdio.h>

int main(void) {
    printf(
        "Select an item from the menu.\n\n"
        "  1 - Coffee\n"
        "  2 - Espresso\n"
        "  3 - Latte\n"
        "  4 - Machiato\n"
        "  5 - Capucino\n"
        "  6 - Mocha\n"
        "  7 - Tea\n\n"
        "Make your selection: "
    );
    fflush(stdout);

    int keypress = getchar();
    int selection = keypress - '0';

    if (selection == 1)
        printf("You selected a Coffee\n");
    else if (selection == 2)
        printf("You selected an Espresso\n");
    else if (selection == 3)
        printf("You selected a Latte\n");
    else if (selection == 4)
        printf("You selected a Machiato\n");
    else if (selection == 5)
        printf("You selected a Capucino\n");
    else if (selection == 6)
        printf("You selected a Mocha\n");
    else if (selection == 7)
        printf("You selected a Tea\n");
    else
        printf("You have not entered a valid selection\n");

    return 0;
}
