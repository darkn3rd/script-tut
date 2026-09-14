// gethostname()/getlogin() are POSIX.1-2001 XSI extensions - hidden
// under strict-ANSI mode on some libcs unless a feature-test macro
// opts back in (see cpp's n00.getvars.cpp for the same issue). Must
// come before ANY include.
#ifndef _WIN32
#define _POSIX_C_SOURCE 200112L
#endif

#include <stdio.h>
#include <stdlib.h>
#ifdef _WIN32
#include <windows.h>
#else
#include <unistd.h>
#endif

// P_tmpdir (<stdio.h>) is the portable ISO C fallback for "where do
// temp files go" when TMPDIR isn't set - std::filesystem::temp_
// directory_path()'s C equivalent.
#ifndef P_tmpdir
#define P_tmpdir "/tmp"
#endif

static const char *current_user(void) {
#ifdef _WIN32
    static char buf[256];
    DWORD size = sizeof(buf);
    return GetUserNameA(buf, &size) ? buf : "";
#else
    const char *login = getlogin();
    return login ? login : "";
#endif
}

static const char *current_hostname(void) {
    static char buf[256];
#ifdef _WIN32
    DWORD size = sizeof(buf);
    return GetComputerNameA(buf, &size) ? buf : "";
#else
    return gethostname(buf, sizeof(buf)) == 0 ? buf : "";
#endif
}

int main(void) {
    const char *user_env = getenv("USER");
    const char *user = user_env ? user_env : current_user();

    const char *tmpdir_env = getenv("TMPDIR");
    const char *tmpdir = tmpdir_env ? tmpdir_env : P_tmpdir;

    const char *hostname_env = getenv("HOSTNAME");
    const char *hostname = hostname_env ? hostname_env : current_hostname();

    printf("USER=%s\n", user);
    printf("HOME=%s\n", getenv("HOME") ? getenv("HOME") : "");
    printf("TMPDIR=%s\n", tmpdir);
    printf("HOSTNAME=%s\n", hostname);

    const char *v;
    if ((v = getenv("USERNAME")))     printf("USERNAME=%s\n", v);
    if ((v = getenv("USERPROFILE")))  printf("USERPROFILE=%s\n", v);
    if ((v = getenv("TEMP")))         printf("TEMP=%s\n", v);
    if ((v = getenv("COMPUTERNAME"))) printf("COMPUTERNAME=%s\n", v);

    return 0;
}
