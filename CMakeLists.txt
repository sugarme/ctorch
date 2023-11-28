cmake_minimum_required(VERSION 3.0)

set(CTORCH_PROJECT_VERSION 0.0.1)
project(ctorch
  HOMEPAGE_URL https://github.com/sugarme/ztorch/ctorch
  DESCRIPTION "C binding for Pytorch C++"
  VERSION ${CTORCH_PROJECT_VERSION}
)

# flag whether to build dynamic or static ctorch
option(CTORCH_BUILD_SHARED "Builds a shared library" ON)
option(CTORCH_USE_CUDA "Builds with libtorch CUDA support" ON)

# header files
file(GLOB_RECURSE CTORCH_HEADER_FILES "include/*.h*")

# source files
set(CTORCH_SRCS 
  src/torch_api.cpp
  # add more as needed with a space apart or in a new line
  # e.g. src/torch_api_generated.cpp
)

# setup library to build
if (CTORCH_BUILD_SHARED)
  add_library(ctorch SHARED ${CTORCH_SRCS})
else()
  add_library(ctorch STATIC ${CTORCH_SRCS})
endif()

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
# target_compile_features(ctorch PRIVATE cxx_standard_17)

set(TORCH_ROOT_DIR /usr/local/lib/libtorch)
set(CUDA_ROOT_DIR /usr/local/cuda)

set(TORCH_INCLUDE_DIRS PUBLIC
 ${TORCH_ROOT_DIR}/csrc
 ${TORCH_ROOT_DIR}/include
 ${TORCH_ROOT_DIR}/include/TH
 ${TORCH_ROOT_DIR}/include/THC
 ${TORCH_ROOT_DIR}/include/torch/csrc/api/include
 ${CUDA_ROOT_DIR}/include
)

target_include_directories(ctorch PUBLIC
  include
  ${TORCH_INCLUDE_DIRS}
  # $<BUILD_INTERFACE:include ${TORCH_INCLUDE_DIRS}>
  # $<INSTALL_INTERFACE:include/ctorch>
)

# Library to link in ctorch
if (CTORCH_USE_CUDA)
  set(CTORCH_LIBS
    torch
    torch_cpu
    torch_cuda
    c10
  )

else()
  set(CTORCH_LIBS
    torch
    torch_cpu
    c10
  )
endif()

target_link_libraries(ctorch PUBLIC ${CTORCH_LIBS})

set_target_properties(ctorch PROPERTIES PUBLIC_HEADER "${CTORCH_HEADER_FILES}")

set_target_properties(ctorch PROPERTIES VERSION ${CTORCH_PROJECT_VERSION})

install(TARGETS ctorch
  ARCHIVE DESTINATION ${CMAKE_CURRENT_LIST_DIR}/cmake-output/lib
  LIBRARY DESTINATION ${CMAKE_CURRENT_LIST_DIR}/cmake-output/lib
  PUBLIC_HEADER DESTINATION ${CMAKE_CURRENT_LIST_DIR}/cmake-output/include
)


