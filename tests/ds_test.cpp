#define BOOST_TEST_MODULE DS_Test
#include <boost/test/included/unit_test.hpp>
#include <vector>
#include <string>
#include "list.hpp"
#include "tree.hpp"

BOOST_AUTO_TEST_SUITE(list)

BOOST_AUTO_TEST_CASE(palindrome) {
  BOOST_TEST(is_palindrome("Racecar"));
  BOOST_TEST(is_palindrome("A man, a plan, a canal - Panama"));
  BOOST_TEST(is_palindrome("Was it a car or a cat I saw?"));
  BOOST_TEST(is_palindrome("Racecar is racecar!") == false);
  BOOST_TEST(is_palindrome("Racecar's is racecar!"));
}

BOOST_AUTO_TEST_CASE(brackets) {
  BOOST_TEST(is_balanced(""));
  BOOST_TEST(is_balanced("{[()]}"));
  BOOST_TEST(is_balanced("(({}[]()){}[]())"));
  BOOST_TEST(is_balanced("(this({is}[](a)){}[]test())"));
  BOOST_TEST(is_balanced("(({}[]()]{}[]())") == false);
  BOOST_TEST(is_balanced("(this({is}[](a)]{}[]test())") == false);
}
BOOST_AUTO_TEST_SUITE_END()


BOOST_AUTO_TEST_SUITE(tree)

BOOST_AUTO_TEST_CASE(insert) {
  auto m = tree::Map<char, int>{};
  std::string keys = "ACEHLMPRSX";
  std::vector<int> values{8,4,12,5,11,9,10,3,0,7};
  for (int i = 0; i < 10; i++) {
    m.put(keys[i], values[i]);
  }
  BOOST_TEST(m.size() == 10);
  BOOST_TEST(!m.isEmpty());
  BOOST_TEST(m.get('A') == 8);
  BOOST_TEST(m.get('X') == 7);
  BOOST_TEST(m.contains('H'));
  BOOST_TEST(!m.contains('T'));
  m.put('T', 1);
  BOOST_TEST(m.contains('T'));
  BOOST_TEST(m.size() == 11);
  BOOST_TEST(m.get('T') == 1);
  m.put('T', 2);
  BOOST_TEST(m.get('T') == 2);
}
BOOST_AUTO_TEST_SUITE_END()

