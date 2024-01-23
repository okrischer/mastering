#include "list.hpp"
#include <cctype>
#include <map>

// Checks wether a given string is a palindrome.
bool is_palindrome(std::string s) {
  auto stack = list::Stack<char>{};
  auto queue = list::Queue<char>{};
  bool palindrome = true;

  for (auto c : s) {
    if (isalpha(c)) {
      char l = tolower(c);
      stack.push(l);
      queue.enqueue(l);
    }
  }

  for (int i = 0; i < stack.size(); i++) {
    if (stack.pop() != queue.dequeue()) {
      palindrome = false;
      break;
    }
  }
  return palindrome;
}

// Checks for balanced brackets
bool is_balanced(std::string s) {
  std::map<char, char> matcher{{'}', '{'}, {']', '['}, {')', '('}};
  auto stack = list::Stack<char>{};

  for (char c : s) {
    if (c == '{' || c == '[' || c == '(') stack.push(c);
    else if (c == '}' || c == ']' || c == ')') {
      if (stack.size() == 0) return false;
      if (matcher[c] != stack.pop()) return false;
    }
  }

  return stack.size() == 0;
}
