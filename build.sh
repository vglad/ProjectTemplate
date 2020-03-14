#!/bin/bash

cd ${PROJECT_DIR} || return 1
BUILD_DIR=${PROJECT_DIR}/build/release

if [ ! -d "${BUILD_DIR}" ]; then
  mkdir -p ${BUILD_DIR}
fi

cd ${BUILD_DIR} || return 1

if [[ ${DOCKER} -eq 1 ]] && [[ "${COMPILER}" == "gcc" ]]; then
  export CC='gcc'
  export CXX='g++'
elif [[ ${DOCKER} -eq 1 ]] && [[ "${COMPILER}" == "clang" ]]; then
  export CC='clang'
  export CXX='clang++'
fi

cmake -DCMAKE_BUILD_TYPE=Release ../.. -DCMAKE_C_COMPILER=${CC} -DCMAKE_CXX_COMPILER=${CXX} -DCMAKE_CXX_STANDARD=17 -DCMAKE_CXX_STANDARD_REQUIRED=ON -DCMAKE_CXX_EXTENSIONS=OFF
make

${BUILD_DIR}/tests/allTests
