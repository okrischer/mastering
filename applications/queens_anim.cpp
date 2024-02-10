#include <SFML/Graphics.hpp>
#include <iostream>
#include <vector>
#include "list.hpp"
using namespace list;

auto* steps = new List<std::vector<int>>;
std::vector<int> board;
int tests = 0;

bool isSafe(std::vector<int> const& board, int n) {
  for (int i = 0; i < n; i++) {
    if (board[i] == board[n]) return false;       // same column
    if (board[i] - board[n] == n-i) return false; // same major diagonal
    if (board[n] - board[i] == n-i) return false; // same minor diagonal
  }
  return true;
}

void placeQueen(std::vector<int>& board) {
  int n = board.size();
  int row = 0;
  int col = 0;
  auto* last_col = new List<int>;
  bool found = false;

  while (row < n) {
    while (col < n && !found) {
      board[row] = col;
      tests++;
      if (isSafe(board, row)) {
        found = true;
        break;
      }
      col++;
    }
    if (found) {
      steps->push_back(board);
      last_col->push_front(col);
      col = 0;
      row++;
    } else {
      board[row] = -1;
      row--;
      board[row] = -1;
      auto lc = last_col->pop();
      while (lc > n-2) {
        row--;
        board[row] = -1;
        lc = last_col->pop();
      }
      col = lc+1;
    }
    found = false;
  }
}

int main(int argc, char* argv[]) {
  if (argc < 2) {
    std::cout << "usage: Queens <number of queens>\n";
    return 1;
  }

  int n = std::stoi(argv[1]);
  if (n < 4 || n > 8) {
    std::cout << "number of queens should be between 4 and 8\n";
    return 1;
  }

  // solve for n queens
  board = std::vector<int>(n, -1);
  placeQueen(board);
  std::cout << "generated " << steps->size() << " steps for " << n << "x" << n << " board";
  std::cout << ", with " << tests << " tests performed.\n";

  sf::ContextSettings settings;
  settings.antialiasingLevel = 8;
  auto window = sf::RenderWindow{ {640u, 640u}, "n-Queens", sf::Style::Default, settings };
  window.setFramerateLimit(1);
  bool paused = false;

  sf::Texture board_img;
  if (!board_img.loadFromFile("../img/chessboard.jpg")) std::cout << "cannot load board\n";
  sf::Sprite board;
  board.setTexture(board_img);
  board.scale(sf::Vector2f(1.22f, 1.21f));

  sf::Texture queen_img;
  if (!queen_img.loadFromFile("../img/queen.png")) std::cout << "cannot load queen\n";
  sf::Sprite queen;
  queen.setTexture(queen_img);
  std::vector<sf::Sprite> queens(n, queen);

  sf::RectangleShape rm(sf::Vector2f(80.f, 80.f));
  rm.setFillColor(sf::Color::Black);
  rm.scale((8-n)*1.f, 8.f);
  rm.setPosition(n*80.f, 0.f);
  sf::RectangleShape bm(sf::Vector2f(80.f, 80.f));
  bm.setFillColor(sf::Color::Black);
  bm.scale(8.f, (8-n)*1.f);
  bm.setPosition(0.f, n*80.f);


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
      window.draw(board);
      window.draw(rm);
      window.draw(bm);

      // set back queens positions
      for (int q = 0; q < n; q++) queens[q].setPosition(10.f, 10.f + q*80.f);

      // draw next step
      try {
        auto s = steps->pop();
        for (int q = 0; q < n; q++) {
          if (s[q] >= 0) { // only draw qeens which have been placed safely
            queens[q].move(s[q]*80.f, 0.f);
            window.draw(queens[q]);
          }
        }
      } catch (std::out_of_range& e) {
        std::cout << "displayed all steps.\n";
        window.close();
        return 0;
      }
    }
    window.display();
  } // end of animation
}
