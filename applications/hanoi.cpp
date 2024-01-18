#include "list.hpp"
#include <cmath>
#include <iostream>

auto moves = Queue<std::pair<char, char>>{};

void solve(int n, char s, char t, char g) {
  if (n == 0) return;                 // base case: do nothing for zero disks
  solve(n-1, s, g, t);                // move n-1 disks from start to temp
  moves.enqueue(std::make_pair(s,g)); // move a single disk from start to goal
  solve(n-1, t, s, g);                // move n-1 disks from temp to goal
}

int main(int argc, char* argv[]) {
  if (argc < 2) {
    std::cout << "Please provide the number of disks.\n";
    return 1;
  }
  int n = std::stoi(argv[1]);
  solve(n, 's', 't', 'g');
  int sz = moves.size();
  std::cout << "Move the disks in the following order:\n";
  for (int i = 0; i < sz; i++) {
    auto move = moves.dequeue();
    std::cout << move.first << " -> " << move.second << "\n";
  }
  std::cout << "This are " << sz << " moves, which corresponds to the number of disks("
            << n << "): 2^n - 1 = " << std::pow(2, n) - 1 << ".\n";
  std::cout << "Printing the moves consumes the underlying queue, "
            << "thus it should be empty: " << moves.size() << "\n";
}
