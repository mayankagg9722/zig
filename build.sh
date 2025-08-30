#!/bin/bash

apt update 
apt install -y cmake
mkdir build
cd build
cmake ..
make install
