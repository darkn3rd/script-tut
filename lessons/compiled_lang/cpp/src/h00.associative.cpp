#include <iostream>
#include <string>
#include <unordered_map>

int main() {
    // create empty map
    std::unordered_map<std::string, int> ages;
    // insert one element at a time
    ages["bob"] = 34;
    ages["ed"] = 58;
    ages["steve"] = 32;
    ages["ralph"] = 23;
    ages["deb"] = 46;
    ages["kate"] = 19;

    // enumerate and print keys
    std::cout << "Keys (names):  ";
    bool first = true;
    for (const auto& pair : ages) {
        if (!first) std::cout << ", ";
        std::cout << pair.first;
        first = false;
    }
    std::cout << std::endl;

    // enumerate and print values
    std::cout << "Values (ages): ";
    first = true;
    for (const auto& pair : ages) {
        if (!first) std::cout << ", ";
        std::cout << pair.second;
        first = false;
    }
    std::cout << std::endl;

    return 0;
}
