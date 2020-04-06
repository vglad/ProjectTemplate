#!/bin/bash

print_help()
{
  echo "Help:"
  echo "  Usage: `basename $0` [[[--build_type [debug|release]] [--compiler [gcc|clang-8]] [--skip_tests] | [-h]]"
  echo
  echo "  -h, --help       Show help"
  echo "  --build_type     Can be one of [debug|release], default=release"
  echo "  --compiler       Can be one of [gcc|clang-8], default=gcc"
  echo "  --skip_tests     Do not build tests"
  exit 1
}

if [[ ( "$1" == "-h" ) || ( "$1" == "--help" ) ]]; then
  print_help
fi

# Set default build variables
BUILD_TYPE="release"
SKIP_TESTS=OFF
# Variables for tests dependencies
#SKIP_CATCH2_DOWNLOAD=OFF
#SKIP_TROMPELOEIL_DOWNLOAD=OFF

# Check build parameters
while [ "$1" != "" ]; do
    case $1 in
        --build_type  ) shift; BUILD_TYPE=$1;;
        --compiler    ) shift; COMPILER=$1;;
        --skip_tests  ) SKIP_TESTS=ON;;
                    * ) echo "Unknown parameter '$1'"; print_help; exit 1;;
    esac
    shift
done

case ${BUILD_TYPE} in
  debug | release ) ;;
                * ) echo "Unknown --build_type '${BUILD_TYPE}'"; print_help;
                    exit 1;;
esac

# Set project directories
PROJECT_DIR=/opt/dev/ProjectTemplate
BUILD_DIR=${PROJECT_DIR}/build/cmake-build-${BUILD_TYPE}
[[ ! -d "${BUILD_DIR}" ]] && ( mkdir -p ${BUILD_DIR} || return 1 )

# Set default compiler if not specified by build parameters.
[ ! "${COMPILER}" ] && COMPILER="gcc"
case ${COMPILER} in
  gcc     ) export CC='gcc'; export CXX='g++';;
  clang-8 ) export CC='clang-8'; export CXX='clang++-8';;
        * ) echo -e "Unknown compiler '${COMPILER}'"; print_help; exit 1;;
esac

# Set compiler flags
COMPILER_FLAGS="-Wall -Wextra -Wpedantic -Werror"

cd ${BUILD_DIR} || return 1
cmake -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
      -DCMAKE_CXX_COMPILER=${CXX} -DCMAKE_C_COMPILER=${CC} \
      -DCMAKE_CXX_FLAGS:STRING="${COMPILER_FLAGS}" \
      -DSKIP_TESTS=${SKIP_TESTS} ../..
cmake --build . -- -j "$(nproc)"


# Run tests if they built
[[ ${SKIP_TESTS} == OFF ]] && ${BUILD_DIR}/test/tests