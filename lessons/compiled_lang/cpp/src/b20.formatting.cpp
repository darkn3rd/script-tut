#include <cstdio>
#include <string>

int main() {
    int number = 5;
    char character = 'a';
    std::string text = "This is a string";

    std::printf("Number is %d.\nCharacter is '%c'.\nString is \"%s\".\n",
        number, character, text.c_str());

    return 0;
}
