#include <ctime>
#include <iostream>

void showDate() {
    std::time_t t = std::time(nullptr);
    char buf[32];
    std::strftime(buf, sizeof(buf), "%B %d, %Y", std::localtime(&t));
    std::cout << "Today is " << buf << "." << std::endl;
}

int main() {
    showDate();
    return 0;
}
