#include "list.hpp"
#include <iostream>

void test_stack() {
  std::cout << "Testing the stack interface...\n";
  auto stack = Stack<int>();
  stack.push(3);
  stack.push(2);
  stack.push(1);
  stack.print();
  std::cout << "top element: " << stack.peek() << "\n";
  std::cout << "stack size: " << stack.size() << "\n";
  std::cout << "popped " << stack.pop() << "\n";
  std::cout << "popped " << stack.pop() << "\n";
  std::cout << "popped " << stack.pop() << "\n";
  stack.print();
  std::cout << "stack size: " << stack.size() << "\n";
  try {
    auto top = stack.peek();
  } catch (std::out_of_range& err) {
    std::cerr << err.what() << "\n";
  }
}

void test_queue() {
  std::cout << "Testing the queue interface...\n";
  auto queue = Queue<int>();
  queue.enqueue(1);
  queue.enqueue(2);
  queue.enqueue(3);
  queue.print();
  std::cout << "next element: " << queue.peek() << "\n";
  std::cout << "queue size: " << queue.size() << "\n";
  std::cout << "dequeued " << queue.dequeue() << "\n";
  std::cout << "dequeued " << queue.dequeue() << "\n";
  std::cout << "dequeued " << queue.dequeue() << "\n";
  queue.print();
  std::cout << "queue size: " << queue.size() << "\n";
  try {
    auto next = queue.peek();
  } catch (std::out_of_range& err) {
    std::cerr << err.what() << "\n";
  }
}
