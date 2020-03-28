cmake_minimum_required (VERSION 3.17)
project(Project LANGUAGES CXX)

option(BUILD_TESTS "Build the unit tests" ON)


set_property(GLOBAL PROPERTY
    CXX_STANDARD 17
    CXX_STANDARD_REQUIRED ON
    CXX_EXTENSIONS OFF)

add_subdirectory(src/lib)
add_subdirectory(src)

if (BUILD_TESTS)
  add_subdirectory(test)
endif()
