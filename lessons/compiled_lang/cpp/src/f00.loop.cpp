// testbox: title="range-based for over std::filesystem::directory_iterator"
#include <algorithm>
#include <filesystem>
#include <iostream>
#include <string>
#include <vector>

namespace fs = std::filesystem;

int main() {
    // directory_iterator's order isn't guaranteed by the filesystem, so
    //  collect names into a vector and sort first
    std::vector<std::string> items;
    for (const auto& entry : fs::directory_iterator("dirtest"))
        items.push_back(entry.path().filename().string());
    std::sort(items.begin(), items.end());

    // range-based for loop (C++11)
    for (const auto& item : items) {
        if (fs::is_directory("dirtest/" + item))
            std::cout << item << " is a directory" << std::endl;
        else
            std::cout << item << " is not a directory" << std::endl;
    }

    return 0;
}
