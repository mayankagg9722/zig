#!/bin/bash

apt update 
apt install -y cmake llvm-config
mkdir build
cd build
cmake ..
make install
