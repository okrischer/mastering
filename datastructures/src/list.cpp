#include "list.hpp"
#include <cctype>
#include <map>

// Checks wether a given string is a palindrome.
bool is_palindrome(std::string s) {
  auto stack = list::List<char>{};
  auto queue = list::List<char>{};
  bool palindrome = true;

  for (auto c : s) {
    if (isalpha(c)) {
      char l = tolower(c);
      stack.push_front(l);
      queue.push_back(l);
    }
  }

  for (int i = 0; i < stack.size(); i++) {
    if (stack.pop() != queue.pop()) {
      palindrome = false;
      break;
    }
  }
  return palindrome;
}

// Checks for balanced brackets
bool is_balanced(std::string s) {
  std::map<char, char> matcher{{'}', '{'}, {']', '['}, {')', '('}};
  auto stack = list::List<char>{};

  for (char c : s) {
    if (c == '{' || c == '[' || c == '(') stack.push_front(c);
    else if (c == '}' || c == ']' || c == ')') {
      if (stack.size() == 0) return false;
      if (matcher[c] != stack.pop()) return false;
    }
  }
  return stack.size() == 0;
}
