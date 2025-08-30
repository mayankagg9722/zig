#!/bin/bash

apt update 
apt install -y cmake llvm llvm-dev llvm-runtime
mkdir build
cd build
cmake ..
make install
