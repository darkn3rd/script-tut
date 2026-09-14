// testbox: title="qsort'd dirent listing, indexed for loop"
// C has no range-for/iterator/lambda distinctions to demonstrate the way
// cpp's f00-f03 do - dirent.h + stat() + a plain indexed for loop is the
// one idiomatic way to do this in C.
#include <dirent.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>

#ifndef S_ISDIR
#define S_ISDIR(mode) (((mode) & S_IFMT) == S_IFDIR)
#endif

static int cmp_name(const void *a, const void *b) {
    return strcmp(*(const char *const *)a, *(const char *const *)b);
}

int main(void) {
    DIR *dir = opendir("dirtest");
    if (dir == NULL) return 1;

    char *items[64];
    int count = 0;
    struct dirent *entry;
    while ((entry = readdir(dir)) != NULL) {
        if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0) continue;
        items[count++] = strdup(entry->d_name);
    }
    closedir(dir);

    qsort(items, (size_t)count, sizeof(char *), cmp_name);

    for (int i = 0; i < count; i++) {
        char path[512];
        snprintf(path, sizeof(path), "dirtest/%s", items[i]);
        struct stat st;
        int is_dir = (stat(path, &st) == 0) && S_ISDIR(st.st_mode);
        printf("%s is %sa directory\n", items[i], is_dir ? "" : "not ");
        free(items[i]);
    }

    return 0;
}
