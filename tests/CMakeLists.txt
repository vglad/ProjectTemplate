cmake_minimum_required (VERSION 3.9)
project(AllTests)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(SOURCE_FILES testMain.cpp
                 lib_Tests.cpp
)

add_executable (allTests ${SOURCE_FILES})
target_link_libraries(allTests PRIVATE catch2 lib)
target_include_directories(allTests PRIVATE
    ../thirdparty/trompeloeil
    ../include/lib
    ../include/detail
)
