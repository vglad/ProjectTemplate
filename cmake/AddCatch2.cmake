message(STATUS "Checking Catch2 dependency ...")

set(catch2_include_dir ${CMAKE_CURRENT_SOURCE_DIR}/../ext/catch2)

if (NOT SKIP_CATCH2_DOWNLOAD)
  set(catch2_version "v2.13.10")
  set(catch2_header "${CMAKE_CURRENT_SOURCE_DIR}/../ext/catch2/catch.hpp")

  if (NOT EXISTS ${catch2_header})
    message(STATUS "  Downloading Catch2 ...")


    set(catch2_header_url https://github.com/catchorg/Catch2/releases/download/${catch2_version}/catch.hpp)
    file(DOWNLOAD ${catch2_header_url} ${catch2_header}
        INACTIVITY_TIMEOUT 10 STATUS status LOG log
        )
    list(GET status 0 status_code)
    list(GET status 1 status_string)
    if(NOT status_code EQUAL 0)
      message(FATAL_ERROR "ERROR: downloading ${catch2_header_url} failed
        status_code: ${status_code}
        status_string: ${status_string}
        log: ${log}"
          )
    endif()
  endif ()
endif ()

# Prepare "Catch2" library
add_library(Catch2 INTERFACE)
target_include_directories(Catch2 INTERFACE ${catch2_include_dir})
set(catch2 Catch2)

message(STATUS "Catch2 dependency prepared")