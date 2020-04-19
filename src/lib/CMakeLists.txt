cmake_minimum_required(VERSION 3.17)
project(Lib)

set(source_files ../../include/lib/lib.hpp lib.cpp)

add_library(lib STATIC ${source_files})
target_include_directories(lib PRIVATE
    ../../ext
    ../../include/detail
    ../../include/lib
)
