#!/bin/bash

# Enable GCC 9.1.1
source scl_source enable gcc-toolset-9

RELEASE_BUILD_DIR=/root/build/release

if [ ! -d "$RELEASE_BUILD_DIR" ]; then
  mkdir -p $RELEASE_BUILD_DIR
fi

cd $RELEASE_BUILD_DIR || exit
cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release ../..
make

$RELEASE_BUILD_DIR/tests/allTests
