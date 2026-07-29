// testbox: title="manual iterator (begin()/end(), ++it, *it)"
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

    // manual iterator loop - what a range-based for desugars to
    for (auto it = items.begin(); it != items.end(); ++it) {
        const std::string& item = *it;
        if (fs::is_directory("dirtest/" + item))
            std::cout << item << " is a directory" << std::endl;
        else
            std::cout << item << " is not a directory" << std::endl;
    }

    return 0;
}
