#include "list.hpp"
#include <cctype>

// Checks wether a given string is a palindrome.
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

  for (int i = 0; i < stack.size(); i++) {
    if (stack.pop() != queue.dequeue()) {
      isPalindrome = false;
      break;
    }
  }
  return isPalindrome;
}
