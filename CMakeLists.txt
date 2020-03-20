cmake_minimum_required (VERSION 3.12)
project(Project)

set_property(GLOBAL PROPERTY
    CXX_STANDARD 17
    CXX_STANDARD_REQUIRED ON
    CXX_EXTENSIONS OFF)

set (msvc_flags /W4 /WX)
set (gnu_clang_flags -Wall -Wextra -pedantic -Werror)

add_compile_options(
    "$<$<CXX_COMPILER_ID:MSVC>:${msvc_flags}>"
    "$<$<CXX_COMPILER_ID:GNU,Clang>:${gnu_clang_flags}>"
)

add_subdirectory(thirdparty/catch2)
add_subdirectory(src/lib)
add_subdirectory(src)
add_subdirectory(tests)