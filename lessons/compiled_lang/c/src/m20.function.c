#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define COUNT 7

static int cmp_str(const void *a, const void *b) {
    return strcmp(*(const char *const *)a, *(const char *const *)b);
}

/* C can't return an array by value - the idiomatic way to "return" one
 * is an out-parameter the caller already owns, written into here. */
void sort_array(const char *in[COUNT], const char *out[COUNT]) {
    memcpy(out, in, COUNT * sizeof(const char *));
    qsort(out, COUNT, sizeof(const char *), cmp_str);
}

void join(const char *items[COUNT], char *out, size_t out_size) {
    out[0] = '\0';
    for (int i = 0; i < COUNT; i++) {
        if (i > 0) strncat(out, ", ", out_size - strlen(out) - 1);
        strncat(out, items[i], out_size - strlen(out) - 1);
    }
}

int main(void) {
    const char *array[COUNT] = {"bob", "ed", "steve", "ralph", "joe", "deb", "kate"};
    char buf[256];

    join(array, buf, sizeof(buf));
    printf("Current names are: %s\n", buf);

    const char *result[COUNT];
    sort_array(array, result);
    join(result, buf, sizeof(buf));
    printf("Sorted names are: %s\n", buf);

    return 0;
}
