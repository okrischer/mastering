cmake_minimum_required(VERSION 3.11)

project(Mastering VERSION 0.1)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_subdirectory(datastructures)
add_executable(DS_test tests/ds.cpp)
target_link_libraries(DS_test PUBLIC datastructures)
target_include_directories(DS_test PUBLIC datastructures/include)

