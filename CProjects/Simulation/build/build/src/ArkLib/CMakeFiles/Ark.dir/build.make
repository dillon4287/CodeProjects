# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.9

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
CMAKE_COMMAND = /usr/local/bin/cmake

# The command to remove a file.
RM = /usr/local/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = "/Users/dillonflannery-valadez/Google Drive/CodeProjects/CProjects/Simulation"

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = "/Users/dillonflannery-valadez/Google Drive/CodeProjects/CProjects/Simulation/build"

# Include any dependencies generated for this target.
include build/src/ArkLib/CMakeFiles/Ark.dir/depend.make

# Include the progress variables for this target.
include build/src/ArkLib/CMakeFiles/Ark.dir/progress.make

# Include the compile flags for this target's objects.
include build/src/ArkLib/CMakeFiles/Ark.dir/flags.make

build/src/ArkLib/CMakeFiles/Ark.dir/__/__/__/src/ark.cpp.o: build/src/ArkLib/CMakeFiles/Ark.dir/flags.make
build/src/ArkLib/CMakeFiles/Ark.dir/__/__/__/src/ark.cpp.o: ../src/ark.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir="/Users/dillonflannery-valadez/Google Drive/CodeProjects/CProjects/Simulation/build/CMakeFiles" --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object build/src/ArkLib/CMakeFiles/Ark.dir/__/__/__/src/ark.cpp.o"
	cd "/Users/dillonflannery-valadez/Google Drive/CodeProjects/CProjects/Simulation/build/build/src/ArkLib" && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/Ark.dir/__/__/__/src/ark.cpp.o -c "/Users/dillonflannery-valadez/Google Drive/CodeProjects/CProjects/Simulation/src/ark.cpp"

build/src/ArkLib/CMakeFiles/Ark.dir/__/__/__/src/ark.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/Ark.dir/__/__/__/src/ark.cpp.i"
	cd "/Users/dillonflannery-valadez/Google Drive/CodeProjects/CProjects/Simulation/build/build/src/ArkLib" && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E "/Users/dillonflannery-valadez/Google Drive/CodeProjects/CProjects/Simulation/src/ark.cpp" > CMakeFiles/Ark.dir/__/__/__/src/ark.cpp.i

build/src/ArkLib/CMakeFiles/Ark.dir/__/__/__/src/ark.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/Ark.dir/__/__/__/src/ark.cpp.s"
	cd "/Users/dillonflannery-valadez/Google Drive/CodeProjects/CProjects/Simulation/build/build/src/ArkLib" && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S "/Users/dillonflannery-valadez/Google Drive/CodeProjects/CProjects/Simulation/src/ark.cpp" -o CMakeFiles/Ark.dir/__/__/__/src/ark.cpp.s

build/src/ArkLib/CMakeFiles/Ark.dir/__/__/__/src/ark.cpp.o.requires:

.PHONY : build/src/ArkLib/CMakeFiles/Ark.dir/__/__/__/src/ark.cpp.o.requires

build/src/ArkLib/CMakeFiles/Ark.dir/__/__/__/src/ark.cpp.o.provides: build/src/ArkLib/CMakeFiles/Ark.dir/__/__/__/src/ark.cpp.o.requires
	$(MAKE) -f build/src/ArkLib/CMakeFiles/Ark.dir/build.make build/src/ArkLib/CMakeFiles/Ark.dir/__/__/__/src/ark.cpp.o.provides.build
.PHONY : build/src/ArkLib/CMakeFiles/Ark.dir/__/__/__/src/ark.cpp.o.provides

build/src/ArkLib/CMakeFiles/Ark.dir/__/__/__/src/ark.cpp.o.provides.build: build/src/ArkLib/CMakeFiles/Ark.dir/__/__/__/src/ark.cpp.o


# Object files for target Ark
Ark_OBJECTS = \
"CMakeFiles/Ark.dir/__/__/__/src/ark.cpp.o"

# External object files for target Ark
Ark_EXTERNAL_OBJECTS =

build/src/ArkLib/libArk.a: build/src/ArkLib/CMakeFiles/Ark.dir/__/__/__/src/ark.cpp.o
build/src/ArkLib/libArk.a: build/src/ArkLib/CMakeFiles/Ark.dir/build.make
build/src/ArkLib/libArk.a: build/src/ArkLib/CMakeFiles/Ark.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir="/Users/dillonflannery-valadez/Google Drive/CodeProjects/CProjects/Simulation/build/CMakeFiles" --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX static library libArk.a"
	cd "/Users/dillonflannery-valadez/Google Drive/CodeProjects/CProjects/Simulation/build/build/src/ArkLib" && $(CMAKE_COMMAND) -P CMakeFiles/Ark.dir/cmake_clean_target.cmake
	cd "/Users/dillonflannery-valadez/Google Drive/CodeProjects/CProjects/Simulation/build/build/src/ArkLib" && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/Ark.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
build/src/ArkLib/CMakeFiles/Ark.dir/build: build/src/ArkLib/libArk.a

.PHONY : build/src/ArkLib/CMakeFiles/Ark.dir/build

build/src/ArkLib/CMakeFiles/Ark.dir/requires: build/src/ArkLib/CMakeFiles/Ark.dir/__/__/__/src/ark.cpp.o.requires

.PHONY : build/src/ArkLib/CMakeFiles/Ark.dir/requires

build/src/ArkLib/CMakeFiles/Ark.dir/clean:
	cd "/Users/dillonflannery-valadez/Google Drive/CodeProjects/CProjects/Simulation/build/build/src/ArkLib" && $(CMAKE_COMMAND) -P CMakeFiles/Ark.dir/cmake_clean.cmake
.PHONY : build/src/ArkLib/CMakeFiles/Ark.dir/clean

build/src/ArkLib/CMakeFiles/Ark.dir/depend:
	cd "/Users/dillonflannery-valadez/Google Drive/CodeProjects/CProjects/Simulation/build" && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" "/Users/dillonflannery-valadez/Google Drive/CodeProjects/CProjects/Simulation" "/Users/dillonflannery-valadez/Google Drive/CodeProjects/CProjects/Simulation/build/src/ArkLib" "/Users/dillonflannery-valadez/Google Drive/CodeProjects/CProjects/Simulation/build" "/Users/dillonflannery-valadez/Google Drive/CodeProjects/CProjects/Simulation/build/build/src/ArkLib" "/Users/dillonflannery-valadez/Google Drive/CodeProjects/CProjects/Simulation/build/build/src/ArkLib/CMakeFiles/Ark.dir/DependInfo.cmake" --color=$(COLOR)
.PHONY : build/src/ArkLib/CMakeFiles/Ark.dir/depend

