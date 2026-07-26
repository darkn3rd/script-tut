#include <iostream>

// file-scope globals are directly visible and mutable from any function
//  here - no "global" keyword needed like Python.
int pond = 500;
int captured = 0;

void fish() {
    pond -= 150;
    captured += 150;
}

int main() {
    std::cout << "We have " << pond << " in this pond.\n";

    fish();
    std::cout << "Fishing from the main pond... We now have " << pond << " in the main pond.\n";

    fish();
    std::cout << "Fishing from the main pond... We now have " << pond << " in the main pond.\n";

    fish();
    std::cout << "Fishing from the main pond... We now have " << pond << " in the main pond.\n";

    std::cout << "We now have a total of " << captured << " fish captured\n";

    return 0;
}
