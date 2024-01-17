cmake_minimum_required(VERSION 3.11)

project(Mastering VERSION 0.1)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_subdirectory(datastructures)
add_executable(Test_DS tests/list_test.cpp)
target_link_libraries(Test_DS PUBLIC datastructures)
target_include_directories(Test_DS PUBLIC datastructures/include)

enable_testing()

# tests for lists
function(palindrome target arg result)
  add_test(NAME Palindrome:${arg} COMMAND ${target} ${arg})
  set_tests_properties(Palindrome:${arg} PROPERTIES PASS_REGULAR_EXPRESSION ${result})
endfunction()

palindrome(Test_DS Racecar palindrome)
palindrome(Test_DS Rotator palindrome)
palindrome(Test_DS Palindrome nope)
