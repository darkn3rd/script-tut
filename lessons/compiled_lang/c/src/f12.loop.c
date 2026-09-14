// testbox: title="do-while loop"
#include <stdio.h>

int main(void) {
    int count = 10;
    do {
        printf("Count is %d\n", count);
        count--;
    } while (count > 0);

    return 0;
}
