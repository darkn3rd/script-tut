#include <cstdlib>
#include <iostream>
#include <string>

int main() {
    const char* path = std::getenv("PATH");
    if (path == nullptr) {
        return 0;
    }

    std::string pathStr = path;
    // A given PATH value never mixes both delimiters, so checking for a
    //  semicolon first is enough to tell which one actually applies -
    //  splitting a Windows-style "C:\Windows;C:\Users" on ':' would
    //  otherwise cut every entry in half at its own drive letter.
    char sep = (pathStr.find(';') != std::string::npos) ? ';' : ':';

    std::size_t start = 0;
    std::size_t pos;
    while ((pos = pathStr.find(sep, start)) != std::string::npos) {
        std::cout << pathStr.substr(start, pos - start) << std::endl;
        start = pos + 1;
    }
    std::cout << pathStr.substr(start) << std::endl;

    return 0;
}
