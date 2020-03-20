#!/bin/bash

# Set project directory if building without Docker
if [[ ${DOCKER} -eq 0 ]]; then
  PROJECT_DIR=/opt/dev/ProjectTemplate
fi

cd ${PROJECT_DIR} || return 1
BUILD_DIR=${PROJECT_DIR}/build/cmake-build-release

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

# Set compiler if building without Docker
if [[ ${DOCKER} -eq 0 ]]; then
  export CC='gcc'
  export CXX='g++'
fi

cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_COMPILER=${CXX} -DCMAKE_C_COMPILER=${CC} ../..
make

# Run tests
${BUILD_DIR}/tests/allTests
