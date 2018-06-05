cmake_minimum_required(VERSION 3.5)
project(cmake_example)

set(CMAKE_CXX_STANDARD 11)

set(THIRD_PARTY "thirdparty" CACHE STRING "Path to third-party libraries")

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

find_package(Blosc)

add_executable(cmake_example main.cpp)
target_link_libraries(cmake_example Blosc::Blosc)
