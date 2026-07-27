#include <iostream>

// No standard C++ container exposes the process's environment - environ
//  (POSIX, and also provided by MinGW-w64's g++ on Windows) is a plain
//  NULL-terminated array of "KEY=value" C strings.
extern char** environ;

int main() {
    for (char** env = environ; *env != nullptr; env++) {
        std::cout << *env << std::endl;
    }

    return 0;
}
