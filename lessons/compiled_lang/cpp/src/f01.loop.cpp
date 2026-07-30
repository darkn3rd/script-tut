// testbox: title="std::for_each() with lambda"
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

    // std::for_each() with a lambda
    std::for_each(items.begin(), items.end(), [](const std::string& item) {
        if (fs::is_directory("dirtest/" + item))
            std::cout << item << " is a directory" << std::endl;
        else
            std::cout << item << " is not a directory" << std::endl;
    });

    return 0;
}
