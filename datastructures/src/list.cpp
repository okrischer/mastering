#include "list.hpp"

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
