// testbox: title="std::for_each() with reverse_iterator"
#include <algorithm>
#include <iostream>
#include <vector>

int main() {
    std::vector<int> nums = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};

    // std::for_each() driven by reverse iterators, so it walks the
    //  vector back to front without reversing the data itself
    std::for_each(nums.rbegin(), nums.rend(), [](int count) {
        std::cout << "Count is " << count << std::endl;
    });

    return 0;
}
