#include <SFML/Graphics.hpp>
#include <iostream>
#include "list.hpp"

auto* moves = new list::Queue<std::pair<char, char>>;
auto* start = new list::Queue<int>;
auto* temp = new list::Queue<int>;
auto* goal = new list::Queue<int>;

// solve the towers of hanoi puzzle with recursion
void solve(int n, char s, char t, char g) {
  if (n == 0) return;                     // base case: do nothing for zero disks
  solve(n-1, s, g, t);                    // move n-1 disks from start to temp
  moves->push_back(std::make_pair(s,g));  // move a single disk from start to goal
  solve(n-1, t, s, g);                    // move n-1 disks from temp to goal
}

// get the towers for making a move
list::Queue<int>* getTower(char t) {
  switch (t) {
  case 's':
    return start;
  case 't':
    return temp;
  case 'g':
    return goal;
  default:
    return start;
  }
}

// make a move from first to second tower
void makeMove(std::pair<char, char> move) {
  auto from = getTower(move.first);
  auto to = getTower(move.second);
  to->push_front(from->pop());
}

// set the color of the given shape
void setColor(int d, sf::RectangleShape& disk) {
  switch (d) {
    case 1:
      disk.setFillColor(sf::Color(0x00, 0x5f, 0x73));
      break;
    case 2:
      disk.setFillColor(sf::Color(0x0a, 0x93, 0x96));
      break;
    case 3:
      disk.setFillColor(sf::Color(0x94, 0xd2, 0xbd));
      break;
    case 4:
      disk.setFillColor(sf::Color(0xe9, 0xd8, 0xa6));
      break;
    case 5:
      disk.setFillColor(sf::Color(0xee, 0x9b, 0x00));
      break;
    case 6:
      disk.setFillColor(sf::Color(0xca, 0x67, 0x02));
      break;
    case 7:
      disk.setFillColor(sf::Color(0xbb, 0x3e, 0x03));
      break;
    case 8:
      disk.setFillColor(sf::Color(0xae, 0x20, 0x12));
      break;
    default:
      disk.setFillColor(sf::Color::Black);
  }
}


int main(int argc, char* argv[]) {
  sf::ContextSettings settings;
  settings.antialiasingLevel = 8;
  auto window = sf::RenderWindow{ {300u, 100u}, "Towers of Hanoi", sf::Style::Default, settings };
  auto wsz = window.getSize();

  if (argc < 3) {
    std::cout << "usage: Hanoi <number of disks> <speed of animation>\n";
    window.close();
    return 1;
  }

  int disks = std::stoi(argv[1]);
  int limit = std::stoi(argv[2]);
  if (disks < 2 || disks > 8) {
    std::cout << "won't create animation for less than 2 or more than 8 disks.\n";
    window.close();
    return 1;
  }
  if (limit < 1 || limit > 10) {
    std::cout << "choose a value for animation speed between 1 and 10.\n";
    window.close();
    return 1;
  }

  window.setFramerateLimit(limit);

  // solve the puzzle and capture all moves
  solve(disks, 's', 't', 'g');
  std::cout << "solved with " << moves->size() << " moves.\n";

  // push initial disks to start tower
  for (int d = disks; d; d--) {
    start->push_front(d);
  }
  std::cout << "filled start tower with " << start->size() << " disks.\n";

  // create peg to put disks on
  sf::RectangleShape peg(sf::Vector2f(6.f, wsz.y - 20));
  peg.setFillColor(sf::Color::Black);

  // create disk
  sf::RectangleShape disk(sf::Vector2f(10.f, 10.f));


  while (window.isOpen()) {
    for (auto event = sf::Event{}; window.pollEvent(event);) {
      if (event.type == sf::Event::Closed) {
        window.close();
      }
    }

    // start of new frame
    window.clear(sf::Color::White);

    // draw pegs
    peg.setPosition(47.f, 20.f);
    window.draw(peg);
    peg.move(100.f, 0.f);
    window.draw(peg);
    peg.move(100.f, 0.f);
    window.draw(peg);

    // draw start tower
    int ssz = start->size();
    for (int i = 1; i <= ssz; i++) {
      int d = start->peek(i);
      setColor(d, disk);
      disk.setScale(d, 1);
      disk.setPosition(50.f - d * 5.f, wsz.y - ((ssz+1) * 10.f) + (i * 10.f));
      window.draw(disk);
    }

    // draw temp tower
    int tsz = temp->size();
    for (int i = 1; i <= tsz; i++) {
      int d = temp->peek(i);
      setColor(d, disk);
      disk.setScale(d, 1);
      disk.setPosition(150.f - d * 5.f, wsz.y - ((tsz+1) * 10.f) + (i * 10.f));
      window.draw(disk);
    }

    // draw goal tower
    int gsz = goal->size();
    for (int i = 1; i <= gsz; i++) {
      int d = goal->peek(i);
      setColor(d, disk);
      disk.setScale(d, 1);
      disk.setPosition(250.f - d * 5.f, wsz.y - ((gsz+1) * 10.f) + (i * 10.f));
      window.draw(disk);
    }

    // display frame
    window.display();

    // make next move
    try {
      auto move = moves->pop();
      makeMove(move);
    } catch (std::out_of_range& e) {
      std::cout << "successfully displayed animation.\n";
      window.close();
      return 0;
    }
  }

  delete moves;
  delete start;
  delete temp;
  delete goal;
}
