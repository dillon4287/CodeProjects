# Dist library CMakeList.txt
cmake_minimum_required(VERSION 2.8.9)
project(libDist)
cmake_policy(SET CMP0042 NEW)

set(CMAKE_CXX_STANDARD 11)
set( CMAKE_EXPORT_COMPILE_COMMANDS ON )
set( CMAKE_BUILD_TYPE Release )
set(EIGEN "/usr/local/include/eigen3")
set(CMAKE_CXX_FLAGS "-O3")

include_directories(${CMAKE_SOURCE_DIR}/include ${EIGEN})

add_library(Dist STATIC ${CMAKE_SOURCE_DIR}/src/Dist.cpp)
install(TARGETS Dist DESTINATION ${CMAKE_SOURCE_DIR}/bin)
install(FILES ${CMAKE_SOURCE_DIR}/include/Dist.hpp DESTINATION ${CMAKE_SOURCE_DIR}/include)





