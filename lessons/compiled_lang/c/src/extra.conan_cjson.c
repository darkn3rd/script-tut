// Bonus lesson, not part of the a00-o20 sequence and not glob-matched
// by testbox's per-category discovery (see Script.rb's
// find_implementations) - so it's never required by `rake`, and isn't
// part of `make`'s default build either (see ../Makefile's own
// exclusion comment). Build it explicitly with `make conan` once
// `conan install` has generated conandeps.mk - see ../README.md's
// "Package Management (Conan)" section.
//
// Same behavior as h00.associative.c (the "Associative Arrays" lesson),
// built with cJSON (installed via Conan) instead of a hand-rolled
// key/value array.
#include <cjson/cJSON.h>
#include <stdio.h>

int main(void) {
    cJSON *ages = cJSON_CreateObject();
    cJSON_AddNumberToObject(ages, "bob", 34);
    cJSON_AddNumberToObject(ages, "ed", 58);
    cJSON_AddNumberToObject(ages, "steve", 32);
    cJSON_AddNumberToObject(ages, "ralph", 23);
    cJSON_AddNumberToObject(ages, "deb", 46);
    cJSON_AddNumberToObject(ages, "kate", 19);

    printf("Keys (names):  ");
    int first = 1;
    cJSON *item = NULL;
    cJSON_ArrayForEach(item, ages) {
        if (!first) printf(", ");
        printf("%s", item->string);
        first = 0;
    }
    printf("\n");

    printf("Values (ages): ");
    first = 1;
    cJSON_ArrayForEach(item, ages) {
        if (!first) printf(", ");
        printf("%d", item->valueint);
        first = 0;
    }
    printf("\n");

    cJSON_Delete(ages);
    return 0;
}
