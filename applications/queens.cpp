#include <SFML/Graphics.hpp>
#include <iostream>
#include <vector>
#include "list.hpp"
using namespace list;

auto* solutions = new List<std::vector<int>>;
std::vector<int> board(8, 0);

bool isSafe(std::vector<int> const& board, int row) {
  for (int col = 0; col < row; col++) {
    if (board[col] == board[row]) return false; // same column
    if (abs(board[row] - board[col]) == row - col) return false; // same diagonal
  }
  return true;
}

void placeQueen(std::vector<int>& board, int row) {
  int sz = board.size();
  if (row == sz) {
    solutions->push_back(board);
  } else {
    for (int col = 0; col < sz; col++) {
      board[row] = col;
      if (isSafe(board, row)) placeQueen(board, row + 1);
    }
  }
}

int main() {
  // solve for 8 queens
  placeQueen(board, 0);
  std::cout << "solved for 8 queens with " << solutions->size() << " solutions\n";

  sf::ContextSettings settings;
  settings.antialiasingLevel = 8;
  auto window = sf::RenderWindow{ {640u, 640u}, "n-Queens", sf::Style::Default, settings };
  window.setFramerateLimit(1);
  bool paused = false;

  sf::Texture board_img;
  if (!board_img.loadFromFile("../img/chessboard.jpg")) std::cout << "cannot load board\n";
  sf::Sprite board;
  board.setTexture(board_img);
  board.scale(sf::Vector2f(1.22f, 1.22f));

  sf::Texture queen_img;
  if (!queen_img.loadFromFile("../img/queen.png")) std::cout << "cannot load queen\n";
  sf::Sprite queen;
  queen.setTexture(queen_img);
  std::vector<sf::Sprite> queens(8, queen);

  // begin animation
  while (window.isOpen()) {
    for (auto event = sf::Event{}; window.pollEvent(event);) {
      if (event.type == sf::Event::Closed) {
        window.close();
      }
      if (event.type == sf::Event::KeyPressed && event.key.code == sf::Keyboard::P) {
        paused = !paused;
      }
    }
    // start of new frame
    if (!paused) {
      window.clear(sf::Color::Black);
      window.draw(board);

      // set back queens positions
      for (int q = 0; q < 8; q++) queens[q].setPosition(10.f + q*80.f, 10.f);

      // draw next solution
      try {
        auto solution = solutions->pop();
        for (int q = 0; q < 8; q++) queens[q].move(0.f, solution[q]*80.f);
        for (int q = 0; q < 8; q++) window.draw(queens[q]);
      } catch (std::out_of_range& e) {
        std::cout << "successfully displayed all solutions.\n";
        window.close();
        return 0;
      }
    } // end paused

    // display frame
    window.display();
  } // end of animation

}
