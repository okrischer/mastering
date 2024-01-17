#include "list.hpp"

int main(int argc, const char* argv[]) {
  if (argc < 2) {
    std::cout << "provide an argument to test\n";
    return 1;
  }

  if (is_palindrome(argv[1]))
      std::cout << "palindrome\n";
  else
      std::cout << "nope\n";
}
