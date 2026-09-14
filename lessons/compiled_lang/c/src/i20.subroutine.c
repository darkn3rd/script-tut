#include <stdio.h>

int pond = 500; /* never mutated - fish() only touches its own local copy */
int captured = 0;

void fish(void) {
    int pond = 500; /* shadows the global pond for the rest of this function */
    pond -= 150;
    (void)pond; /* the whole point of this lesson: this local mutation is thrown away */
    captured += 150;
}

int main(void) {
    printf("We have %d in this pond.\n", pond);

    fish();
    printf("Fishing from a local pond... We now have %d in the main pond.\n", pond);

    fish();
    printf("Fishing from a local pond... We now have %d in the main pond.\n", pond);

    fish();
    printf("Fishing from a local pond... We now have %d in the main pond.\n", pond);

    printf("We now have a total of %d fish captured\n", captured);

    return 0;
}
