cmake_minimum_required (VERSION 3.17)
project(tests LANGUAGES CXX)

option(SKIP_CATCH2_DOWNLOAD "Do not download Catch2" OFF)
option(SKIP_TROMPELOEIL_DOWNLOAD "Do not download Trompeloeil" OFF)

include(AddCatch2)
include(AddTrompeloeil)

set(source_files catch_main.cpp lib_Tests.cpp)

add_executable (tests ${source_files})
target_link_libraries(tests PRIVATE ${catch2} ${trompeloeil} lib)
target_include_directories(tests PRIVATE
    ../ext
    ../include/detail
    ../include/lib
)

