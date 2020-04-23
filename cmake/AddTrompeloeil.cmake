message(STATUS "Checking Trompeloeil dependency ...")

set(trompeloeil_include_dir ${CMAKE_CURRENT_SOURCE_DIR}/../ext)

if (NOT SKIP_TROMPELOEIL_DOWNLOAD)
  set(trompeloeil_version "37")
  set(trompeloeil_headers "${trompeloeil_include_dir}/trompeloeil.hpp"
      "${trompeloeil_include_dir}/catch2/trompeloeil.hpp"
      )

  set(download_msg FALSE)
  foreach(header IN LISTS trompeloeil_headers)
    if (NOT EXISTS ${header})
      set(download_msg TRUE)
    endif ()
  endforeach()

  if(${download_msg})
    message(STATUS "  Downloading Trompeloeil ...")
    set(trompeloeil_temp_dir ${trompeloeil_include_dir}/trompeloeil_tar_temp)
    set(tar_url https://github.com/rollbear/trompeloeil/archive/${trompeloeil_version}.tar.gz)
    set(tar_file ${trompeloeil_temp_dir}/trompeloeil-${trompeloeil_version}.tar.gz)

    file(DOWNLOAD ${tar_url} ${tar_file} INACTIVITY_TIMEOUT 10 STATUS status LOG log)
    list(GET status 0 status_code)
    list(GET status 1 status_string)
    if(NOT status_code EQUAL 0)
      message(FATAL_ERROR "ERROR: downloading ${tar_url} failed
          status_code: ${status_code}
          status_string: ${status_string}
          log: ${log}"
          )
    endif()

    message(STATUS "  Extracting trompeloeil-${trompeloeil_version}.tar.gz ...")
    execute_process(COMMAND ${CMAKE_COMMAND} -E tar -xzf ${tar_file} trompeloeil-${trompeloeil_version}/include
        WORKING_DIRECTORY ${trompeloeil_temp_dir})
    execute_process(COMMAND ${CMAKE_COMMAND} -E make_directory ${trompeloeil_temp_dir}/../catch2
        WORKING_DIRECTORY ${trompeloeil_temp_dir})

    set(trompeloeil_temp_headers ${trompeloeil_temp_dir}/trompeloeil-${trompeloeil_version}/include/trompeloeil.hpp
        ${trompeloeil_temp_dir}/trompeloeil-${trompeloeil_version}/include/catch2/trompeloeil.hpp
        )
    foreach(temp_header header IN ZIP_LISTS trompeloeil_temp_headers trompeloeil_headers)
      execute_process(COMMAND ${CMAKE_COMMAND} -E copy ${temp_header} ${header}
          WORKING_DIRECTORY ${trompeloeil_temp_dir})
    endforeach()

    execute_process(COMMAND ${CMAKE_COMMAND} -E rm -rf ${trompeloeil_temp_dir}
        WORKING_DIRECTORY ${trompeloeil_temp_dir}/..)
  endif()
endif ()

# Prepare "Trompeloeil" library
add_library(Trompeloeil INTERFACE)
target_include_directories(Trompeloeil INTERFACE ${trompeloeil_include_dir})
set(trompeloeil Trompeloeil)

message(STATUS "Trompeloeil dependency prepared")
