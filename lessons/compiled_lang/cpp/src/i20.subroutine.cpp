#include <iostream>

int pond = 500; // never mutated - fish() only touches its own local copy
int captured = 0;

void fish() {
    int pond = 500; // shadows the global pond for the rest of this function
    pond -= 150;
    captured += 150;
}

int main() {
    std::cout << "We have " << pond << " in this pond.\n";

    fish();
    std::cout << "Fishing from a local pond... We now have " << pond << " in the main pond.\n";

    fish();
    std::cout << "Fishing from a local pond... We now have " << pond << " in the main pond.\n";

    fish();
    std::cout << "Fishing from a local pond... We now have " << pond << " in the main pond.\n";

    std::cout << "We now have a total of " << captured << " fish captured\n";

    return 0;
}
