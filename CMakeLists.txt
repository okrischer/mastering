cmake_minimum_required(VERSION 3.11)

project(Mastering VERSION 0.1)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_subdirectory(datastructures)
add_executable(DS_Test tests/ds_test.cpp)
target_link_libraries(DS_Test PUBLIC datastructures)
target_include_directories(DS_Test PUBLIC datastructures/include)

enable_testing()
add_test(NAME Palindrome COMMAND DS_Test)