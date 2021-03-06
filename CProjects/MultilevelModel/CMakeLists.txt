# Top level cmake 
cmake_minimum_required(VERSION 2.8 FATAL_ERROR)
project(multilevel)

set(CMAKE_BUILD_TYPE DEBUG)
set(CMAKE_CXX_FLAGS_REALEASE "-O3 -march=native -mfpmath=sse -funroll-loops")
# message(STATUS ${CMAKE_CXX_FLAGS_REALEASE})
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/modules/")

find_package(Eigen3)
if (${EIGEN3_FOUND})
  include_directories(${EIGEN3_INCLUDE_DIR})
else()
  message(STATUS "Eigen3 not found")
endif()
find_package(Python3 COMPONENTS Interpreter Development)
if (${Python3_FOUND})
  include_directories(${Python3_INCLUDE_DIRS})
else()
  message(FATAL_ERROR "Python3 not found, please install it.")
endif()

# include_directories(/usr/local/lib/python3.8/dist-packages/numpy/core/include)


include_directories(include)
add_library(mylib src/Distributions.cpp src/MultilevelModel.cpp src/seed_settings.cpp src/Optimization.cpp)



add_executable(ml src/Test_MultilevelModel.cpp )
target_link_libraries(ml PUBLIC mylib) 
