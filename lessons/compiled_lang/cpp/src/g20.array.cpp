#include <iostream>
#include <string>

int main() {
    std::string nicknames[] = {"bob", "ed", "steve", "ralph", "joe", "deb", "kate"};
    int total = sizeof(nicknames) / sizeof(nicknames[0]);

    std::cout << "The names are: " << std::endl;
    for (int i = 0; i < total; i++) {
        std::cout << " nicknames[" << i << "]=" << nicknames[i] << std::endl;
    }

    return 0;
}
