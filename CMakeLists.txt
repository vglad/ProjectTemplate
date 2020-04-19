cmake_minimum_required (VERSION 3.17)
project(Project LANGUAGES CXX)

option(SKIP_TESTS "Do not build unit tests" OFF)

list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake)
add_subdirectory(src/lib)
add_subdirectory(src)

if (NOT SKIP_TESTS)
  add_subdirectory(test)
  set(targets tests)
endif()

set(targets lib main ${targets})
set_target_properties(${targets} PROPERTIES
    CXX_STANDARD 17
    CXX_STANDARD_REQUIRED ON
    CXX_EXTENSIONS OFF
    )
