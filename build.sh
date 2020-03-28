#!/bin/bash

if [[ ( "$1" == "-h" ) || ( "$1" == "--help" ) ]]; then
    echo "Usage: `basename $0` [-h]"
    echo "  Build the project"
    echo
    echo "  -h, --help           Show this help text"
    echo "  --build_type         Can be one of [debug, release], default=debug"
    echo "  --build_tests        Can be one of [OFF, ON], default=OFF"
    exit 0
fi

# Set variables
PROJECT_DIR=/opt/dev/ProjectTemplate
BUILD_TYPE=release
BUILD_DIR=${PROJECT_DIR}/build/cmake-build-${BUILD_TYPE}
BUILD_TESTS=ON
#COMPILER="g++"

# Variables for tests dependencies
#NO_CATCH2_DOWNLOAD=OFF
#NO_TROMPELOEIL_DOWNLOAD=OFF

[[ ! -d "${BUILD_DIR}" ]] && ( mkdir -p ${BUILD_DIR} || return 1 )

case ${COMPILER} in
  g++) export CC='gcc'; export CXX='g++';;
  clang++-8) export CC='clang-8'; export CXX='clang++-8';;
  *) echo "Error! Undefined compiler [${COMPILER}]"; exit 1;;
esac

# Set compiler flags
COMPILER_FLAGS="-Wall -Wextra -Wpedantic -Werror"

cd ${BUILD_DIR} || return 1
cmake -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
      -DCMAKE_CXX_COMPILER=${CXX} -DCMAKE_C_COMPILER=${CC} \
      -DCMAKE_CXX_FLAGS:STRING="${COMPILER_FLAGS}" \
      -DBUILD_TESTS=${BUILD_TESTS} ../..
cmake --build . -- -j "$(nproc)"

# Run tests if they built
[[ ${BUILD_TESTS} == ON ]] && ${BUILD_DIR}/test/tests