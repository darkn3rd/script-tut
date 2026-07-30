#include <cstdlib>
#include <iostream>
#include <ostream>
#include <string>
#include <vector>

// No argv library here has any built-in notion of a long-form flag that
//  also takes a following value, so - like the bash reference - this is
//  parsed entirely by hand: each argv entry is checked against both its
//  long and short spelling, and the next entry is consumed as that
//  flag's quantity.
void usage(std::ostream& os, const char* cmd) {
    os << std::endl;
    os << "Usage: " << cmd << " [--coffee|-c N] [--espresso|-e N] [--latte|-l N] [--macchiato|-k N] [--capucino|-p N] [--mocha|-m N] [--tea|-t N] [--help|-h|-?]" << std::endl;
    os << std::endl;
    os << "  --coffee,    -c N  Coffee" << std::endl;
    os << "  --espresso,  -e N  Espresso" << std::endl;
    os << "  --latte,     -l N  Latte" << std::endl;
    os << "  --macchiato, -k N  Machiato" << std::endl;
    os << "  --capucino,  -p N  Capucino" << std::endl;
    os << "  --mocha,     -m N  Mocha" << std::endl;
    os << "  --tea,       -t N  Tea" << std::endl;
    os << "  --help,      -h    Display this help message" << std::endl;
    os << "  -?                 Display this help message" << std::endl;
    os << std::endl;
}

int main(int argc, char* argv[]) {
    std::vector<std::string> names;
    std::vector<int> counts;

    int i = 1;
    while (i < argc) {
        std::string flag = argv[i];
        if (flag == "--coffee" || flag == "-c") { names.push_back("coffee"); counts.push_back(std::atoi(argv[i + 1])); i += 2; }
        else if (flag == "--espresso" || flag == "-e") { names.push_back("espresso"); counts.push_back(std::atoi(argv[i + 1])); i += 2; }
        else if (flag == "--latte" || flag == "-l") { names.push_back("latte"); counts.push_back(std::atoi(argv[i + 1])); i += 2; }
        else if (flag == "--macchiato" || flag == "-k") { names.push_back("macchiato"); counts.push_back(std::atoi(argv[i + 1])); i += 2; }
        else if (flag == "--capucino" || flag == "-p") { names.push_back("capucino"); counts.push_back(std::atoi(argv[i + 1])); i += 2; }
        else if (flag == "--mocha" || flag == "-m") { names.push_back("mocha"); counts.push_back(std::atoi(argv[i + 1])); i += 2; }
        else if (flag == "--tea" || flag == "-t") { names.push_back("tea"); counts.push_back(std::atoi(argv[i + 1])); i += 2; }
        else if (flag == "--help" || flag == "-h" || flag == "-?") { usage(std::cout, argv[0]); return 0; }
        else { usage(std::cerr, argv[0]); return 1; }
    }

    if (names.empty()) {
        usage(std::cerr, argv[0]);
        return 1;
    }

    std::cout << std::endl;
    std::cout << "You ordered: " << std::endl;
    for (std::size_t j = 0; j < names.size(); j++) {
        int n = counts[j];
        std::string suffix = (n != 1) ? "s" : "";
        std::cout << "* " << n << " " << names[j] << suffix << std::endl;
    }

    return 0;
}
