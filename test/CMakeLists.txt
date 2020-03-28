cmake_minimum_required (VERSION 3.14)
project(tests LANGUAGES CXX)

option(NO_CATCH2_DOWNLOAD "Do not download Catch2" OFF)
option(NO_TROMPELOEIL_DOWNLOAD "Do not download Trompeloeil" OFF)

if (NOT NO_CATCH2_DOWNLOAD)
  # Download "Catch2" dependency
  message(STATUS "Downloading Catch2 ...")
  set(catch_header "${CMAKE_CURRENT_SOURCE_DIR}/third_party/catch2/catch.hpp")
  if (NOT EXISTS ${catch_header})

    file(DOWNLOAD "https://raw.githubusercontent.com/catchorg/Catch2/master/single_include/catch2/catch.hpp"
        ${catch_header}
        INACTIVITY_TIMEOUT 10
        STATUS status
        LOG log
        )

    list(GET status 0 status_code)
    list(GET status 1 status_string)
    if(NOT status_code EQUAL 0)
      message(FATAL_ERROR "ERROR: downloading
      'https://raw.githubusercontent.com/catchorg/Catch2/master/single_include/catch2/catch.hpp' failed
      status_code: ${status_code}
      status_string: ${status_string}
      log: ${log}"
          )
    endif()
  endif ()

  # Prepare "Catch2" library
  set(catch_include_dir ${CMAKE_CURRENT_SOURCE_DIR}/third_party/catch2)
  add_library(Catch2 INTERFACE)
  target_include_directories(Catch2 INTERFACE ${catch_include_dir})
  set(catch2 Catch2)
endif ()

if (NOT NO_TROMPELOEIL_DOWNLOAD)
  # Download "Trompeloeil" dependency
  message(STATUS "Downloading Trompeloeil ...")
  set(trompeloeil_files
      "${CMAKE_CURRENT_SOURCE_DIR}/third_party/trompeloeil.hpp"
      "${CMAKE_CURRENT_SOURCE_DIR}/third_party/catch2/trompeloeil.hpp")
  set(trompeloeil_source_urls
      "https://raw.githubusercontent.com/rollbear/trompeloeil/master/include/trompeloeil.hpp"
      "https://raw.githubusercontent.com/rollbear/trompeloeil/master/include/catch2/trompeloeil.hpp")
  foreach(file url IN ZIP_LISTS trompeloeil_files trompeloeil_source_urls)
    if (NOT EXISTS ${file})
      file(DOWNLOAD ${url}
          ${file}
          INACTIVITY_TIMEOUT 10
          STATUS status
          LOG log
          )

      list(GET status 0 status_code)
      list(GET status 1 status_string)

      if(NOT status_code EQUAL 0)
        message(FATAL_ERROR "ERROR: downloading
                '${url}' failed
                status_code: ${status_code}
                status_string: ${status_string}
                log: ${log}"
                )
      endif()
    endif()
  endforeach()

  # Prepare "Trompeloeil" library
  set(trompeloeil_include_dir ${CMAKE_CURRENT_SOURCE_DIR}/third_party)
  add_library(Trompeloeil INTERFACE)
  target_include_directories(Trompeloeil INTERFACE ${trompeloeil_include_dir})
  set(trompeloeil Trompeloeil)
endif ()

 # Make tests executable
set(source_files catch_main.cpp lib_Tests.cpp)
add_executable (tests ${source_files})
target_link_libraries(tests PRIVATE ${catch2} ${trompeloeil} lib)
target_include_directories(tests PRIVATE
    third_party
    ../include/lib
)

