cmake_minimum_required(VERSION 3.16)

project(Mastering VERSION 0.1 LANGUAGES CXX)
option(BUILD_SHARED_LIBS "Build shared libraries" OFF)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED True)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Debug)
endif()

set(CMAKE_CXX_FLAGS "-Wall -Wextra")
set(CMAKE_CXX_FLAGS_DEBUG "-g")
set(CMAKE_CXX_FLAGS_RELEASE "-O3")


include(FetchContent)
FetchContent_Declare(SFML
  GIT_REPOSITORY https://github.com/SFML/SFML.git
  GIT_TAG 2.6.x)
FetchContent_MakeAvailable(SFML)

add_subdirectory(datastructures)

add_executable(DS_Test tests/ds_test.cpp)
target_link_libraries(DS_Test PUBLIC datastructures)
target_include_directories(DS_Test PUBLIC datastructures/include
                          #/opt/homebrew/Cellar/boost/1.84.0/include
                          )

add_executable(Hanoi applications/hanoi.cpp)
target_link_libraries(Hanoi PUBLIC datastructures)
target_link_libraries(Hanoi PRIVATE sfml-graphics)
target_include_directories(Hanoi PUBLIC datastructures/include
                          #/opt/homebrew/Cellar/sfml/2.6.1/include
                          )

enable_testing()
add_test(NAME Test_DS COMMAND DS_Test --log_level=unit_scope)
