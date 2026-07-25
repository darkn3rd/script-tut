// testbox: title="for loop as conditional loop"
#include <iostream>
#include <string>

int main() {
    // the for statement's own increment clause is left empty - answer is
    //  reassigned in the body instead, so the loop's only real job here
    //  is testing the condition before each pass
    for (std::string answer = ""; answer != "quit"; ) {
        std::cout << "Enter your name (quit to Exit): ";
        std::getline(std::cin, answer);

        if (answer != "quit")
            std::cout << "Hello " << answer << "!" << std::endl;
    }

    return 0;
}
