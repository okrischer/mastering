cmake_minimum_required(VERSION 3.11)

project(Mastering VERSION 0.1)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_subdirectory(datastructures)
add_executable(Test_DS tests/list_test.cpp)
target_link_libraries(Test_DS PUBLIC datastructures)
target_include_directories(Test_DS PUBLIC datastructures/include)

