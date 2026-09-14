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

    switch (selection) {
        case 1: printf("You selected a Coffee\n"); break;
        case 2: printf("You selected an Espresso\n"); break;
        case 3: printf("You selected a Latte\n"); break;
        case 4: printf("You selected a Machiato\n"); break;
        case 5: printf("You selected a Capucino\n"); break;
        case 6: printf("You selected a Mocha\n"); break;
        case 7: printf("You selected a Tea\n"); break;
        default: printf("You have not entered a valid selection\n");
    }

    return 0;
}
