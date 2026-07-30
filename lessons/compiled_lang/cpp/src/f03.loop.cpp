// testbox: title="indexed for loop over std::vector"
#include <algorithm>
#include <filesystem>
#include <iostream>
#include <string>
#include <vector>

namespace fs = std::filesystem;

int main() {
    std::vector<std::string> items;
    for (const auto& entry : fs::directory_iterator("dirtest"))
        items.push_back(entry.path().filename().string());
    std::sort(items.begin(), items.end());

    // indexed for loop
    for (std::size_t i = 0; i < items.size(); ++i) {
        const std::string& item = items[i];
        if (fs::is_directory("dirtest/" + item))
            std::cout << item << " is a directory" << std::endl;
        else
            std::cout << item << " is not a directory" << std::endl;
    }

    return 0;
}
