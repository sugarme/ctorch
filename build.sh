#!/bin/bash -x
BUILD_LIB="-lstdc++ -ltorch -lc10 -ltorch_cpu -ltorch_cuda"

BUILD_OPTS="-std=c++17 -g -O3 -Wall -Wno-unused-variable -Wno-deprecated-declarations -Wno-c++11-narrowing -g -Wno-sign-compare -Wno-unused-function -D_GLIBCXX_USE_CXX11_ABI=0"

BUILD_I="-I/usr/local/lib/libtorch/lib -I/usr/local/lib/libtorch/include -I/usr/local/lib/libtorch/include/torch/csrc/api/include -I/usr/local/cuda/include"
BUILD_L="-L/usr/local/lib/libtorch/lib -L/usr/local/cuda/lib64"

gcc ${BUILD_I} ${BUILD_L} ${BUILD_LIB} ${BUILD_OPTS} -c torch_api.cpp -o torch_api.o
