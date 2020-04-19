message(STATUS "Checking Trompeloeil dependency ...")

if (NOT SKIP_TROMPELOEIL_DOWNLOAD)
  set(trompeloeil_headers
      "${CMAKE_CURRENT_SOURCE_DIR}/../ext/trompeloeil.hpp"
      "${CMAKE_CURRENT_SOURCE_DIR}/../ext/catch2/trompeloeil.hpp"
  )
  set(trompeloeil_headers_urls
      "https://raw.githubusercontent.com/rollbear/trompeloeil/master/include/trompeloeil.hpp"
      "https://raw.githubusercontent.com/rollbear/trompeloeil/master/include/catch2/trompeloeil.hpp"
  )
  set(trompeloeil_include_dir ${CMAKE_CURRENT_SOURCE_DIR}/../ext)
  set(download_msg TRUE)

  foreach(file url IN ZIP_LISTS trompeloeil_headers trompeloeil_headers_urls)
    if (NOT EXISTS ${file})

      if(${download_msg})
        message(STATUS "  Downloading Trompeloeil ...")
        set(download_msg FALSE)
      endif()

      file(DOWNLOAD ${url} ${file} INACTIVITY_TIMEOUT 10 STATUS status LOG log)
      list(GET status 0 status_code)
      list(GET status 1 status_string)
      if(NOT status_code EQUAL 0)
        message(FATAL_ERROR "ERROR: downloading ${url} failed
          status_code: ${status_code}
          status_string: ${status_string}
          log: ${log}"
        )
      endif()

    endif()
  endforeach()

  # Prepare "Trompeloeil" library
  add_library(Trompeloeil INTERFACE)
  target_include_directories(Trompeloeil INTERFACE ${trompeloeil_include_dir})
  set(trompeloeil Trompeloeil)

endif ()
message(STATUS "Trompeloeil dependency prepared")
