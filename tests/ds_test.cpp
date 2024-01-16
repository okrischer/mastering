#include "list.hpp"
#include <iostream>
#include <string>

int main(int argc, const char* argv[]) {
  if (argc < 2) {
    std::cout << "provide a function to test\n";
    return 1;
  }
  int t = std::stoi(argv[1]);
  switch (t) {
    case 1:
      test_stack();
      break;
    case 2:
      test_queue();
      break;
    default:
      return 1;
  }
}
