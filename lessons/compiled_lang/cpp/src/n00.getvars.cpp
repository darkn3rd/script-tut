// gethostname()/getlogin() are POSIX.1-2001 XSI extensions - hidden by
//  Cygwin's (and glibc's) <unistd.h> under -std=c++17's strict-ANSI mode
//  unless a feature-test macro opts back in (confirmed directly on
//  Cygwin; MSYS2/MinGW never hits this path at all - see currentUser()
//  below). Must come before ANY include, not just <unistd.h> itself:
//  <filesystem> below already pulls in <unistd.h> transitively, and its
//  include guard would otherwise lock out the declaration before this
//  macro ever took effect (confirmed directly - defining it immediately
//  above the local #include <unistd.h> was not sufficient).
#ifndef _WIN32
#define _POSIX_C_SOURCE 200112L
#endif

#include <cstdlib>
#include <filesystem>
#include <iostream>
#include <string>
#ifdef _WIN32
#include <windows.h>
#else
#include <unistd.h>
#endif

// Enumerate a fixed set of well-known environment variables, printing
//  "NAME=value" for each. USER, TMPDIR, and HOSTNAME aren't reliably
//  set as actual environment entries on every POSIX host (confirmed
//  directly: missing on GitHub Actions' ubuntu-latest runners) - fall
//  back to each one's portable equivalent so this stays reliable
//  anywhere, matching lessons/shell_scripts/bash/scripts/n00.getvars.bash's own
//  fallback approach. USERNAME/USERPROFILE/TEMP/COMPUTERNAME are
//  Windows-only concepts with no POSIX equivalent - printed only when
//  actually present.
//
// getlogin()/gethostname() (POSIX, <unistd.h>) aren't declared at all
//  on MinGW-w64's UCRT-based g++ (confirmed directly) - same reason
//  n20.setvars.cpp's setenv() needed a _putenv_s fallback there -
//  GetUserNameA/GetComputerNameA (<windows.h>) are what's actually
//  available on Windows instead.
static std::string currentUser() {
#ifdef _WIN32
    char buf[256];
    DWORD size = sizeof(buf);
    return GetUserNameA(buf, &size) ? std::string(buf) : "";
#else
    const char* login = getlogin();
    return login ? std::string(login) : "";
#endif
}

static std::string currentHostname() {
#ifdef _WIN32
    char buf[256];
    DWORD size = sizeof(buf);
    return GetComputerNameA(buf, &size) ? std::string(buf) : "";
#else
    char buf[256];
    return gethostname(buf, sizeof(buf)) == 0 ? std::string(buf) : "";
#endif
}

int main() {
    const char* userEnv = std::getenv("USER");
    std::string user = userEnv ? userEnv : currentUser();

    const char* tmpdirEnv = std::getenv("TMPDIR");
    std::string tmpdir = tmpdirEnv ? tmpdirEnv : std::filesystem::temp_directory_path().string();

    const char* hostnameEnv = std::getenv("HOSTNAME");
    std::string hostname = hostnameEnv ? hostnameEnv : currentHostname();

    std::cout << "USER=" << user << "\n";
    std::cout << "HOME=" << (std::getenv("HOME") ? std::getenv("HOME") : "") << "\n";
    std::cout << "TMPDIR=" << tmpdir << "\n";
    std::cout << "HOSTNAME=" << hostname << "\n";

    if (const char* v = std::getenv("USERNAME"))     std::cout << "USERNAME=" << v << "\n";
    if (const char* v = std::getenv("USERPROFILE"))  std::cout << "USERPROFILE=" << v << "\n";
    if (const char* v = std::getenv("TEMP"))         std::cout << "TEMP=" << v << "\n";
    if (const char* v = std::getenv("COMPUTERNAME")) std::cout << "COMPUTERNAME=" << v << "\n";

    return 0;
}
