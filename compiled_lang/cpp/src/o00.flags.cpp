#include <iostream>
#include <ostream>
#include <string>

// usage() prints to whichever stream the caller passes - std::cout for an
//  explicit -h/-?, std::cerr for a usage error - matching the bash
//  reference's single usage() body, invoked either bare or with ">&2".
void usage(std::ostream& os, const char* cmd) {
    os << std::endl;
    os << "Usage: " << cmd << " [-c|-e|-l|-k|-p|-m|-t] [-h|-?]" << std::endl;
    os << std::endl;
    os << "  -c  Coffee" << std::endl;
    os << "  -e  Espresso" << std::endl;
    os << "  -l  Latte" << std::endl;
    os << "  -k  Machiato" << std::endl;
    os << "  -p  Capucino" << std::endl;
    os << "  -m  Mocha" << std::endl;
    os << "  -t  Tea" << std::endl;
    os << "  -h  Display this help message" << std::endl;
    os << "  -?  Display this help message" << std::endl;
    os << std::endl;
}

int main(int argc, char* argv[]) {
    if (argc < 2) {
        usage(std::cerr, argv[0]);
        return 1;
    }

    std::string flag = argv[1];
    if (flag == "-c") { std::cout << "You ordered a Coffee." << std::endl; return 0; }
    if (flag == "-e") { std::cout << "You ordered an Espresso." << std::endl; return 0; }
    if (flag == "-l") { std::cout << "You ordered a Latte." << std::endl; return 0; }
    if (flag == "-k") { std::cout << "You ordered a Machiato." << std::endl; return 0; }
    if (flag == "-p") { std::cout << "You ordered a Capucino." << std::endl; return 0; }
    if (flag == "-m") { std::cout << "You ordered a Mocha." << std::endl; return 0; }
    if (flag == "-t") { std::cout << "You ordered a Tea." << std::endl; return 0; }
    if (flag == "-h" || flag == "-?") {
        usage(std::cout, argv[0]);
        return 0;
    }

    usage(std::cerr, argv[0]);
    return 1;
}
