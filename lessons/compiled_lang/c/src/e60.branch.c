// testbox: requires="posix"
// POSIX <regex.h> (regcomp/regexec) has no equivalent in the plain C
// standard library and isn't available on native Windows/MinGW - see
// e50.branch.c for a portable classification of the same three cases.
#include <regex.h>
#include <stdio.h>

static int matches(const char *pattern, const char *s) {
    regex_t re;
    if (regcomp(&re, pattern, REG_EXTENDED | REG_NOSUB) != 0) return 0;
    int result = regexec(&re, s, 0, NULL, 0) == 0;
    regfree(&re);
    return result;
}

int main(void) {
    printf("Input a character: ");
    fflush(stdout);
    char keypress = (char)getchar();
    char s[2] = { keypress, '\0' };

    if (matches("[A-Z]", s))
        printf("Uppercase letter\n");
    else if (matches("[a-z]", s))
        printf("Lowercase letter\n");
    else if (matches("[0-9]", s))
        printf("Digit\n");
    else
        printf("Punctuation, whitespace, or other\n");

    return 0;
}
