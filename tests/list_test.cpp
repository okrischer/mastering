#include "list.hpp"
#include <iostream>
#include <string>

void test_stack() {
  auto stack = Stack<int>();
  stack.push(1);
  stack.push(2);
  stack.push(3);
  stack.pop();
  stack.print(); // expect 2 -> 1
}

void test_queue() {
  auto queue = Queue<int>();
  queue.enqueue(1);
  queue.enqueue(2);
  queue.enqueue(3);
  queue.dequeue();
  queue.print(); // expect 2 -> 3
}

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
      std::cout << "not a valid option for testing\n";
      return 1;
  }
}
