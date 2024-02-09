#include <cstddef>
#include <iostream>
#include <vector>
#include <string>

int solutionCount = 0;
std::vector<int> board;

void printBoard(std::vector<int>& board) {
  int sz = board.size();
  for (int row = 0; row < sz; row++) {
    std::string rank = "";
    for (int col = 0; col < sz; col++) {
      if (board[row] == col) rank += "Q ";
      else rank += ". ";
    }
    std::cout << rank << "\n";
  }
  std::cout << "\n";
}

bool isSafe(std::vector<int> const& board, int row) {
  for (int col = 0; col < row; col++) {
    if (board[col] == board[row]) return false; // same column
    if (abs(board[row] - board[col]) == row - col) return false; // same diagonal
  }
  return true;
}

void placeQueen(std::vector<int>& board, int row) {
  int sz = board.size();
  if (row == sz) {                        // base case: all rows filled
    printBoard(board);
    solutionCount++;
  } else {
    for (int col = 0; col < sz; col++) {
      board[row] = col;
      if (isSafe(board, row)) placeQueen(board, row + 1);
    }
  }
}

int main(int argc, char* argv[]) {
  if (argc < 2) {
    std::cout << "usage: Queens <board size>\n";
    return 1;
  }
  int sz = std::stoi(argv[1]);
  if (sz < 4 || sz > 8) {
    std::cout << "please enter a board size between 4 and 8\n";
    return 1;
  }
  
  board = std::vector<int>(sz, 0);
  placeQueen(board, 0);
  std::cout << "Number of solutions for " << sz << " queens: " << solutionCount << "\n";
}
