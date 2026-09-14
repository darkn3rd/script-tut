#include <ctype.h>
#include <stdio.h>
#include <string.h>

/* Returns a pointer into its own static buffer - fine for a one-shot
 * tutorial program (not thread-safe/re-entrant, which is exactly why
 * the standard library's own strtok has the same limitation). */
const char *capitalize(const char *s) {
    static char buf[256];
    size_t i;
    for (i = 0; s[i] != '\0' && i < sizeof(buf) - 1; i++) {
        buf[i] = (char)toupper((unsigned char)s[i]);
    }
    buf[i] = '\0';
    return buf;
}

int main(void) {
    const char *s = "ibm";
    printf("The current string is: \"%s\".\n", s);

    const char *result = capitalize(s);
    printf("The capitalized string is: \"%s\".\n", result);

    return 0;
}
