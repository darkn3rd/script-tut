#include <iostream>
#include <string>
#include <unordered_map>

int main() {
    // initialize map with key/value pairs
    std::unordered_map<std::string, int> ages = {
        {"bob", 34}, {"ed", 58}, {"steve", 32}, {"ralph", 23}
    };
    // append another set of key/value pairs into map
    std::unordered_map<std::string, int> more = {{"deb", 46}, {"kate", 19}};
    ages.insert(more.begin(), more.end());

    // iterate through map by keys, print key/value pairs
    std::cout << "The ages are: " << std::endl;
    for (const auto& pair : ages) {
        std::cout << " ages[" << pair.first << "]=" << pair.second << std::endl;
    }

    return 0;
}
