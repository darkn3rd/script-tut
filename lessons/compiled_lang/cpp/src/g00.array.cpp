#include <iostream>
#include <sstream>
#include <string>

int main() {
    // populate array one item at a time
    std::string nicknames[7];
    nicknames[0] = "bob";
    nicknames[1] = "ed";
    nicknames[2] = "steve";
    nicknames[3] = "ralph";
    nicknames[4] = "joe";
    nicknames[5] = "deb";
    nicknames[6] = "kate";

    int total = sizeof(nicknames) / sizeof(nicknames[0]);
    std::cout << "The total nicknames are: " << total << std::endl;

    std::ostringstream joined;
    for (int i = 0; i < total; i++) {
        if (i > 0) joined << ", ";
        joined << nicknames[i];
    }
    std::cout << "The nicknames are: " << joined.str() << std::endl;

    return 0;
}
