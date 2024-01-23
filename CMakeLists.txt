cmake_minimum_required(VERSION 3.16)

project(Mastering VERSION 0.1 LANGUAGES CXX)
option(BUILD_SHARED_LIBS "Build shared libraries" OFF)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

include(FetchContent)
FetchContent_Declare(SFML
  GIT_REPOSITORY https://github.com/SFML/SFML.git
  GIT_TAG 2.6.x)
FetchContent_MakeAvailable(SFML)

add_subdirectory(datastructures)

add_executable(DS_Test tests/ds_test.cpp)
target_link_libraries(DS_Test PUBLIC datastructures)
target_include_directories(DS_Test PUBLIC datastructures/include)

add_executable(Hanoi applications/hanoi.cpp)
target_link_libraries(Hanoi PUBLIC datastructures)
target_link_libraries(Hanoi PRIVATE sfml-graphics)
target_include_directories(Hanoi PUBLIC datastructures/include)

enable_testing()
add_test(NAME Test_DS COMMAND DS_Test --log_level=unit_scope)
