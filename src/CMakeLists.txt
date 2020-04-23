cmake_minimum_required (VERSION 3.17)
project(Main)

set(source_files main.cpp)

add_executable(main ${source_files})

target_link_libraries(main PRIVATE lib)
target_include_directories(main PRIVATE
    ../ext
    ../include/detail
    ../include/lib
)
