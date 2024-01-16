cmake_minimum_required(VERSION 3.11)

project(Mastering VERSION 0.1)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_subdirectory(datastructures)
add_executable(Test_DS tests/ds_test.cpp)
target_link_libraries(Test_DS PUBLIC datastructures)
target_include_directories(Test_DS PUBLIC datastructures/include)

enable_testing()

# tests for DSList
function(test_list target arg result)
  add_test(NAME DSList${arg} COMMAND ${target} ${arg})
  set_tests_properties(DSList${arg} PROPERTIES PASS_REGULAR_EXPRESSION ${result})
endfunction()

# run tests for DSList
test_list(Test_DS 1 "2 -> 1")
test_list(Test_DS 2 "2 -> 3")