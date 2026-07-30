#include <iostream>
#include <string>

int main() {
    std::string nicknames[] = {"bob", "ed", "steve", "ralph", "joe", "deb", "kate"};

    std::cout << "The names are: " << std::endl;
    for (const auto& name : nicknames) {
        std::cout << "  " << name << std::endl;
    }

    return 0;
}
