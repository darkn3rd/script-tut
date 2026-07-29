#include <algorithm>
#include <iostream>
#include <string>

std::string capitalize(std::string s) {
    std::transform(s.begin(), s.end(), s.begin(), ::toupper);
    return s;
}

int main() {
    std::string s = "ibm";
    std::cout << "The current string is: \"" << s << "\"." << std::endl;

    std::string result = capitalize(s);
    std::cout << "The capitalized string is: \"" << result << "\"." << std::endl;

    return 0;
}
