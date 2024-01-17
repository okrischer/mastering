#include "list.hpp"
#include <cctype>

bool is_palindrome(std::string s) {
  auto stack = Stack<char>{};
  auto queue = Queue<char>{};
  
  for (auto c : s) {
    if (isalpha(c)) {
      char l = tolower(c);
      stack.push(l);
      queue.enqueue(l);
    }
  }

  bool isPalindrome = true;

  for (int i = 0; i < stack.size()/2; i++) {
    if (stack.pop() != queue.dequeue()) {
      isPalindrome = false;
      break;
    }
  }
  return isPalindrome;
}
