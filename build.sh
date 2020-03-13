#!/bin/bash


RELEASE_BUILD_DIR=/opt/${PROJECT_NAME}/build/release

if [ ! -d "$RELEASE_BUILD_DIR" ]; then
  mkdir -p $RELEASE_BUILD_DIR
fi

cd $RELEASE_BUILD_DIR || exit
cmake -DCMAKE_BUILD_TYPE=Release ../..
make

$RELEASE_BUILD_DIR/tests/allTests
