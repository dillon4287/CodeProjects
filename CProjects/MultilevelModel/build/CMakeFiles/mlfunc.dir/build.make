# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.16

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/dillon/CodeProjects/CProjects/MultilevelModel

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/dillon/CodeProjects/CProjects/MultilevelModel/build

# Include any dependencies generated for this target.
include CMakeFiles/mlfunc.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/mlfunc.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/mlfunc.dir/flags.make

CMakeFiles/mlfunc.dir/src/MultilevelModelFunctions.cpp.o: CMakeFiles/mlfunc.dir/flags.make
CMakeFiles/mlfunc.dir/src/MultilevelModelFunctions.cpp.o: ../src/MultilevelModelFunctions.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/dillon/CodeProjects/CProjects/MultilevelModel/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/mlfunc.dir/src/MultilevelModelFunctions.cpp.o"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/mlfunc.dir/src/MultilevelModelFunctions.cpp.o -c /home/dillon/CodeProjects/CProjects/MultilevelModel/src/MultilevelModelFunctions.cpp

CMakeFiles/mlfunc.dir/src/MultilevelModelFunctions.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/mlfunc.dir/src/MultilevelModelFunctions.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/dillon/CodeProjects/CProjects/MultilevelModel/src/MultilevelModelFunctions.cpp > CMakeFiles/mlfunc.dir/src/MultilevelModelFunctions.cpp.i

CMakeFiles/mlfunc.dir/src/MultilevelModelFunctions.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/mlfunc.dir/src/MultilevelModelFunctions.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/dillon/CodeProjects/CProjects/MultilevelModel/src/MultilevelModelFunctions.cpp -o CMakeFiles/mlfunc.dir/src/MultilevelModelFunctions.cpp.s

# Object files for target mlfunc
mlfunc_OBJECTS = \
"CMakeFiles/mlfunc.dir/src/MultilevelModelFunctions.cpp.o"

# External object files for target mlfunc
mlfunc_EXTERNAL_OBJECTS =

libmlfunc.a: CMakeFiles/mlfunc.dir/src/MultilevelModelFunctions.cpp.o
libmlfunc.a: CMakeFiles/mlfunc.dir/build.make
libmlfunc.a: CMakeFiles/mlfunc.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/dillon/CodeProjects/CProjects/MultilevelModel/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX static library libmlfunc.a"
	$(CMAKE_COMMAND) -P CMakeFiles/mlfunc.dir/cmake_clean_target.cmake
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/mlfunc.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/mlfunc.dir/build: libmlfunc.a

.PHONY : CMakeFiles/mlfunc.dir/build

CMakeFiles/mlfunc.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/mlfunc.dir/cmake_clean.cmake
.PHONY : CMakeFiles/mlfunc.dir/clean

CMakeFiles/mlfunc.dir/depend:
	cd /home/dillon/CodeProjects/CProjects/MultilevelModel/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/dillon/CodeProjects/CProjects/MultilevelModel /home/dillon/CodeProjects/CProjects/MultilevelModel /home/dillon/CodeProjects/CProjects/MultilevelModel/build /home/dillon/CodeProjects/CProjects/MultilevelModel/build /home/dillon/CodeProjects/CProjects/MultilevelModel/build/CMakeFiles/mlfunc.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/mlfunc.dir/depend

