#!/bin/bash

BUILD_DIR=/opt/${PROJECT_DIR}/build/release

if [ ! -d "$BUILD_DIR" ]; then
  mkdir -p $BUILD_DIR
fi

cd $BUILD_DIR || exit
cmake -DCMAKE_BUILD_TYPE=Release ../..
make

$BUILD_DIR/tests/allTests
