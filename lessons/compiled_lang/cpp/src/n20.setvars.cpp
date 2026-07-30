// setenv (POSIX) is hidden by Cygwin's (and glibc's) <cstdlib> under
//  -std=c++17's strict-ANSI mode unless a feature-test macro opts back
//  in (confirmed directly on Cygwin - see the same issue and fix in
//  n00.getvars.cpp). Must precede every include, since whichever header
//  first transitively pulls in <stdlib.h> locks in the guard.
#ifndef _WIN32
#define _POSIX_C_SOURCE 200112L
#endif

#include <cstdio>
#include <cstdlib>
#include <ctime>
#include <iostream>
#include <map>
#include <string>

extern char** environ;

int main(int argc, char* argv[]) {
    // std::map keeps its keys sorted, so simply iterating it below already
    //  matches the bash reference's explicit `sort` over the key list.
    std::map<std::string, int> drinks = {
        {"Capucino", 0}, {"Coffee", 0}, {"Espresso", 0}, {"Latte", 0},
        {"Machiato", 0}, {"Mocha", 0}, {"Tea", 0}
    };

    if (argc == 1) {
        std::srand(static_cast<unsigned int>(std::time(nullptr)));
        for (auto& entry : drinks) {
            entry.second = std::rand() % 3;
        }
    } else {
        for (int i = 1; i < argc; i++) {
            std::string pairStr = argv[i];
            std::size_t colon = pairStr.find(':');
            std::string key = pairStr.substr(0, colon);
            int qty = std::atoi(pairStr.substr(colon + 1).c_str());
            drinks[key] = qty;
        }
    }

    std::string order;
    for (const auto& entry : drinks) {
        if (entry.second != 0) {
            if (!order.empty()) order += ",";
            order += entry.first + ":" + std::to_string(entry.second);
        }
    }

    // setenv (POSIX) has no equivalent in MinGW-w64's UCRT-based g++ -
    //  _putenv_s is what's actually available there instead, and (unlike
    //  the older _putenv) reports failures via a return code rather than
    //  ever executing arbitrary environment-string content.
#ifdef _WIN32
    _putenv_s("MY_ORDERS", order.c_str());
#else
    setenv("MY_ORDERS", order.c_str(), 1);
#endif

    // Plain "KEY=value" lines - not some C++-specific serialization - so
    //  an external observer can read this the same way regardless of
    //  platform, same convention every language's n20.setvars.* lesson
    //  follows.
    FILE* dump = std::fopen("dump_env.out", "w");
    if (dump != nullptr) {
        for (char** env = environ; *env != nullptr; env++) {
            std::fprintf(dump, "%s\n", *env);
        }
        std::fclose(dump);
    }

    // std::endl (not "\n") flushes explicitly - stdout isn't a real
    //  terminal when the test harness pipes it, so this line would
    //  otherwise sit buffered and never reach the harness while it's
    //  waiting to read it, before it goes on to inspect dump_env.out.
    std::cout << "MY_ORDERS set, Hit Return to continue" << std::endl;

    std::string discard;
    std::getline(std::cin, discard);

    std::remove("dump_env.out");

    return 0;
}
