# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.10

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
CMAKE_SOURCE_DIR = /home/jinsu/Work_Fornax/VR/YZiCS

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/jinsu/Work_Fornax/VR/YZiCS/build

# Include any dependencies generated for this target.
include NBodylib/src/Analysis/CMakeFiles/Analysis.dir/depend.make

# Include the progress variables for this target.
include NBodylib/src/Analysis/CMakeFiles/Analysis.dir/progress.make

# Include the compile flags for this target's objects.
include NBodylib/src/Analysis/CMakeFiles/Analysis.dir/flags.make

NBodylib/src/Analysis/CMakeFiles/Analysis.dir/Density.cxx.o: NBodylib/src/Analysis/CMakeFiles/Analysis.dir/flags.make
NBodylib/src/Analysis/CMakeFiles/Analysis.dir/Density.cxx.o: ../NBodylib/src/Analysis/Density.cxx
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/jinsu/Work_Fornax/VR/YZiCS/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object NBodylib/src/Analysis/CMakeFiles/Analysis.dir/Density.cxx.o"
	cd /home/jinsu/Work_Fornax/VR/YZiCS/build/NBodylib/src/Analysis && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/Analysis.dir/Density.cxx.o -c /home/jinsu/Work_Fornax/VR/YZiCS/NBodylib/src/Analysis/Density.cxx

NBodylib/src/Analysis/CMakeFiles/Analysis.dir/Density.cxx.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/Analysis.dir/Density.cxx.i"
	cd /home/jinsu/Work_Fornax/VR/YZiCS/build/NBodylib/src/Analysis && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/jinsu/Work_Fornax/VR/YZiCS/NBodylib/src/Analysis/Density.cxx > CMakeFiles/Analysis.dir/Density.cxx.i

NBodylib/src/Analysis/CMakeFiles/Analysis.dir/Density.cxx.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/Analysis.dir/Density.cxx.s"
	cd /home/jinsu/Work_Fornax/VR/YZiCS/build/NBodylib/src/Analysis && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/jinsu/Work_Fornax/VR/YZiCS/NBodylib/src/Analysis/Density.cxx -o CMakeFiles/Analysis.dir/Density.cxx.s

NBodylib/src/Analysis/CMakeFiles/Analysis.dir/Density.cxx.o.requires:

.PHONY : NBodylib/src/Analysis/CMakeFiles/Analysis.dir/Density.cxx.o.requires

NBodylib/src/Analysis/CMakeFiles/Analysis.dir/Density.cxx.o.provides: NBodylib/src/Analysis/CMakeFiles/Analysis.dir/Density.cxx.o.requires
	$(MAKE) -f NBodylib/src/Analysis/CMakeFiles/Analysis.dir/build.make NBodylib/src/Analysis/CMakeFiles/Analysis.dir/Density.cxx.o.provides.build
.PHONY : NBodylib/src/Analysis/CMakeFiles/Analysis.dir/Density.cxx.o.provides

NBodylib/src/Analysis/CMakeFiles/Analysis.dir/Density.cxx.o.provides.build: NBodylib/src/Analysis/CMakeFiles/Analysis.dir/Density.cxx.o


NBodylib/src/Analysis/CMakeFiles/Analysis.dir/Morphology.cxx.o: NBodylib/src/Analysis/CMakeFiles/Analysis.dir/flags.make
NBodylib/src/Analysis/CMakeFiles/Analysis.dir/Morphology.cxx.o: ../NBodylib/src/Analysis/Morphology.cxx
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/jinsu/Work_Fornax/VR/YZiCS/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building CXX object NBodylib/src/Analysis/CMakeFiles/Analysis.dir/Morphology.cxx.o"
	cd /home/jinsu/Work_Fornax/VR/YZiCS/build/NBodylib/src/Analysis && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/Analysis.dir/Morphology.cxx.o -c /home/jinsu/Work_Fornax/VR/YZiCS/NBodylib/src/Analysis/Morphology.cxx

NBodylib/src/Analysis/CMakeFiles/Analysis.dir/Morphology.cxx.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/Analysis.dir/Morphology.cxx.i"
	cd /home/jinsu/Work_Fornax/VR/YZiCS/build/NBodylib/src/Analysis && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/jinsu/Work_Fornax/VR/YZiCS/NBodylib/src/Analysis/Morphology.cxx > CMakeFiles/Analysis.dir/Morphology.cxx.i

NBodylib/src/Analysis/CMakeFiles/Analysis.dir/Morphology.cxx.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/Analysis.dir/Morphology.cxx.s"
	cd /home/jinsu/Work_Fornax/VR/YZiCS/build/NBodylib/src/Analysis && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/jinsu/Work_Fornax/VR/YZiCS/NBodylib/src/Analysis/Morphology.cxx -o CMakeFiles/Analysis.dir/Morphology.cxx.s

NBodylib/src/Analysis/CMakeFiles/Analysis.dir/Morphology.cxx.o.requires:

.PHONY : NBodylib/src/Analysis/CMakeFiles/Analysis.dir/Morphology.cxx.o.requires

NBodylib/src/Analysis/CMakeFiles/Analysis.dir/Morphology.cxx.o.provides: NBodylib/src/Analysis/CMakeFiles/Analysis.dir/Morphology.cxx.o.requires
	$(MAKE) -f NBodylib/src/Analysis/CMakeFiles/Analysis.dir/build.make NBodylib/src/Analysis/CMakeFiles/Analysis.dir/Morphology.cxx.o.provides.build
.PHONY : NBodylib/src/Analysis/CMakeFiles/Analysis.dir/Morphology.cxx.o.provides

NBodylib/src/Analysis/CMakeFiles/Analysis.dir/Morphology.cxx.o.provides.build: NBodylib/src/Analysis/CMakeFiles/Analysis.dir/Morphology.cxx.o


NBodylib/src/Analysis/CMakeFiles/Analysis.dir/Power.cxx.o: NBodylib/src/Analysis/CMakeFiles/Analysis.dir/flags.make
NBodylib/src/Analysis/CMakeFiles/Analysis.dir/Power.cxx.o: ../NBodylib/src/Analysis/Power.cxx
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/jinsu/Work_Fornax/VR/YZiCS/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Building CXX object NBodylib/src/Analysis/CMakeFiles/Analysis.dir/Power.cxx.o"
	cd /home/jinsu/Work_Fornax/VR/YZiCS/build/NBodylib/src/Analysis && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/Analysis.dir/Power.cxx.o -c /home/jinsu/Work_Fornax/VR/YZiCS/NBodylib/src/Analysis/Power.cxx

NBodylib/src/Analysis/CMakeFiles/Analysis.dir/Power.cxx.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/Analysis.dir/Power.cxx.i"
	cd /home/jinsu/Work_Fornax/VR/YZiCS/build/NBodylib/src/Analysis && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/jinsu/Work_Fornax/VR/YZiCS/NBodylib/src/Analysis/Power.cxx > CMakeFiles/Analysis.dir/Power.cxx.i

NBodylib/src/Analysis/CMakeFiles/Analysis.dir/Power.cxx.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/Analysis.dir/Power.cxx.s"
	cd /home/jinsu/Work_Fornax/VR/YZiCS/build/NBodylib/src/Analysis && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/jinsu/Work_Fornax/VR/YZiCS/NBodylib/src/Analysis/Power.cxx -o CMakeFiles/Analysis.dir/Power.cxx.s

NBodylib/src/Analysis/CMakeFiles/Analysis.dir/Power.cxx.o.requires:

.PHONY : NBodylib/src/Analysis/CMakeFiles/Analysis.dir/Power.cxx.o.requires

NBodylib/src/Analysis/CMakeFiles/Analysis.dir/Power.cxx.o.provides: NBodylib/src/Analysis/CMakeFiles/Analysis.dir/Power.cxx.o.requires
	$(MAKE) -f NBodylib/src/Analysis/CMakeFiles/Analysis.dir/build.make NBodylib/src/Analysis/CMakeFiles/Analysis.dir/Power.cxx.o.provides.build
.PHONY : NBodylib/src/Analysis/CMakeFiles/Analysis.dir/Power.cxx.o.provides

NBodylib/src/Analysis/CMakeFiles/Analysis.dir/Power.cxx.o.provides.build: NBodylib/src/Analysis/CMakeFiles/Analysis.dir/Power.cxx.o


Analysis: NBodylib/src/Analysis/CMakeFiles/Analysis.dir/Density.cxx.o
Analysis: NBodylib/src/Analysis/CMakeFiles/Analysis.dir/Morphology.cxx.o
Analysis: NBodylib/src/Analysis/CMakeFiles/Analysis.dir/Power.cxx.o
Analysis: NBodylib/src/Analysis/CMakeFiles/Analysis.dir/build.make

.PHONY : Analysis

# Rule to build all files generated by this target.
NBodylib/src/Analysis/CMakeFiles/Analysis.dir/build: Analysis

.PHONY : NBodylib/src/Analysis/CMakeFiles/Analysis.dir/build

NBodylib/src/Analysis/CMakeFiles/Analysis.dir/requires: NBodylib/src/Analysis/CMakeFiles/Analysis.dir/Density.cxx.o.requires
NBodylib/src/Analysis/CMakeFiles/Analysis.dir/requires: NBodylib/src/Analysis/CMakeFiles/Analysis.dir/Morphology.cxx.o.requires
NBodylib/src/Analysis/CMakeFiles/Analysis.dir/requires: NBodylib/src/Analysis/CMakeFiles/Analysis.dir/Power.cxx.o.requires

.PHONY : NBodylib/src/Analysis/CMakeFiles/Analysis.dir/requires

NBodylib/src/Analysis/CMakeFiles/Analysis.dir/clean:
	cd /home/jinsu/Work_Fornax/VR/YZiCS/build/NBodylib/src/Analysis && $(CMAKE_COMMAND) -P CMakeFiles/Analysis.dir/cmake_clean.cmake
.PHONY : NBodylib/src/Analysis/CMakeFiles/Analysis.dir/clean

NBodylib/src/Analysis/CMakeFiles/Analysis.dir/depend:
	cd /home/jinsu/Work_Fornax/VR/YZiCS/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/jinsu/Work_Fornax/VR/YZiCS /home/jinsu/Work_Fornax/VR/YZiCS/NBodylib/src/Analysis /home/jinsu/Work_Fornax/VR/YZiCS/build /home/jinsu/Work_Fornax/VR/YZiCS/build/NBodylib/src/Analysis /home/jinsu/Work_Fornax/VR/YZiCS/build/NBodylib/src/Analysis/CMakeFiles/Analysis.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : NBodylib/src/Analysis/CMakeFiles/Analysis.dir/depend

