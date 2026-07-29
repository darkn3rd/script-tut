#include <iostream>
#include <ostream>
#include <string>
#include <vector>

void usage(std::ostream& os, const char* cmd) {
    os << std::endl;
    os << "Usage: " << cmd << " [-c] [-e] [-l] [-k] [-p] [-m] [-t] [-h|-?]" << std::endl;
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
    std::vector<std::string> orders;

    for (int i = 1; i < argc; i++) {
        std::string flag = argv[i];
        if (flag == "-c") { orders.push_back("coffee"); }
        else if (flag == "-e") { orders.push_back("espresso"); }
        else if (flag == "-l") { orders.push_back("latte"); }
        else if (flag == "-k") { orders.push_back("macchiato"); }
        else if (flag == "-p") { orders.push_back("capucino"); }
        else if (flag == "-m") { orders.push_back("mocha"); }
        else if (flag == "-t") { orders.push_back("tea"); }
        else if (flag == "-h" || flag == "-?") {
            usage(std::cout, argv[0]);
            return 0;
        } else {
            usage(std::cerr, argv[0]);
            return 1;
        }
    }

    if (orders.empty()) {
        usage(std::cerr, argv[0]);
        return 1;
    }

    std::cout << std::endl;
    std::cout << "You ordered: " << std::endl;
    for (const auto& drink : orders) {
        std::cout << "* " << drink << std::endl;
    }

    return 0;
}
