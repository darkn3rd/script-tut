#include <algorithm>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>

std::vector<std::string> sortArray(std::vector<std::string> array) {
    std::sort(array.begin(), array.end());
    return array;
}

std::string join(const std::vector<std::string>& items) {
    std::ostringstream joined;
    for (size_t i = 0; i < items.size(); i++) {
        if (i > 0) joined << ", ";
        joined << items[i];
    }
    return joined.str();
}

int main() {
    std::vector<std::string> array = {"bob", "ed", "steve", "ralph", "joe", "deb", "kate"};
    std::cout << "Current names are: " << join(array) << std::endl;

    std::vector<std::string> result = sortArray(array);
    std::cout << "Sorted names are: " << join(result) << std::endl;

    return 0;
}
