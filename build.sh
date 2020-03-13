#!/bin/bash

cd ${PROJECT_DIR} || return 1
BUILD_DIR=./build/release
#BUILD_DIR=/opt/${PROJECT_DIR}/build/release

if [ ! -d "$BUILD_DIR" ]; then
  mkdir -p $BUILD_DIR
fi

cd $BUILD_DIR || return 1
cmake -DCMAKE_BUILD_TYPE=Release ../..
make

$BUILD_DIR/tests/allTests
