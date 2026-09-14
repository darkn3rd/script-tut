#include <stdio.h>
#include <time.h>

void show_date(void) {
    time_t t = time(NULL);
    char buf[32];
    strftime(buf, sizeof(buf), "%B %d, %Y", localtime(&t));
    printf("Today is %s.\n", buf);
}

int main(void) {
    show_date();
    return 0;
}
