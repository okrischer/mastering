#define BOOST_TEST_MODULE DS_Test
#include <boost/test/included/unit_test.hpp>
#include "list.hpp"

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