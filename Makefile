
# Ref. adapted from https://github.com/TimDettmers/bitsandbytes/blob/main/Makefile

MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
ROOT_DIR := $(patsubst %/,%,$(dir $(MKFILE_PATH)))

GPP:= /usr/bin/g++


ifeq ($(CUDA_HOME),)
	CUDA_HOME:= $(shell which nvcc | rev | cut -d'/' -f3- | rev)
endif

ifndef CUDA_VERSION
$(warning WARNING: CUDA_VERSION not set. Call make with CUDA string, for example: make cuda11x CUDA_VERSION=115 or make cpuonly CUDA_VERSION=CPU)
CUDA_VERSION:=
endif

NVCC := $(CUDA_HOME)/bin/nvcc

###########################################

CSRC := $(ROOT_DIR)/src
BUILD_DIR:= $(ROOT_DIR)/build

FILES_CPP := $(CSRC)/torch_api.cpp 

LIBTORCH_DIR := /usr/local/lib/libtorch

INCLUDE :=  -I $(ROOT_DIR)/csrc \
						-I $(LIBTORCH_DIR)/include \
						-I $(LIBTORCH_DIR)/include/torch/csrc/api/include \
						-I $(LIBTORCH_DIR)/include/TH \
						-I $(LIBTORCH_DIR)/include/THC \
						-I $(CUDA_HOME)/include

LIB := -L $(CUDA_HOME)/lib64 -static-libstdc++ \
			 -L $(LIBTORCH_DIR)/lib \
			 -ltorch \
			 -ltorch_cpu \
			 -ltorch_cuda \
			 -lc10 

OPTS := -std=c++17 \
				-O3 \
				-g \
				-Wall \
				-Wno-unused-variable \
				-Wno-deprecated-declarations \
				-Wno-c++11-narrowing \
				-Wno-sign-compare \
				-Wno-unused-function \
				-D_GLIBCXX_USE_CXX11_ABI=0

TARGET_DIR := $(ROOT_DIR)/lib

all: $(BUILD_DIR) env
	$(GPP) -shared -fPIC \
		$(OPTS) \
		$(INCLUDE) \
		$(FILES_CPP) \
		$(LIB) \
		-o $(TARGET_DIR)/libctorch.so 


env:
	@echo "ENVIRONMENT"
	@echo "============================"
	@echo "CUDA_VERSION: $(CUDA_VERSION)"
	@echo "============================"
	@echo "NVCC path: $(NVCC)"
	@echo "GPP path: $(GPP) VERSION: `$(GPP) --version | head -n 1`"
	@echo "CUDA_HOME: $(CUDA_HOME)"
	@echo "PATH: $(PATH)"
	@echo "LD_LIBRARY_PATH: $(LD_LIBRARY_PATH)"
	@echo "============================"


$(BUILD_DIR):
	mkdir -p lib

clean:
	rm $(TARGET_DIR)/*

cleanlibs:
	rm $(TARGET_DIR)/ctorch*.so
