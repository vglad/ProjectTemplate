#!/bin/bash

# Enable GCC 9.1.1
source scl_source enable gcc-toolset-9

[ ! -d "/root/build" ] && mkdir /root/build
cd /root/build || exit
cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release ..
make

/root/build/tests/allTests
