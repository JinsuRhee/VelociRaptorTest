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
CMAKE_SOURCE_DIR = /home/jinsu/Work_Fornax/VR/NH

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/jinsu/Work_Fornax/VR/NH/build

# Include any dependencies generated for this target.
include src/CMakeFiles/stf.dir/depend.make

# Include the progress variables for this target.
include src/CMakeFiles/stf.dir/progress.make

# Include the compile flags for this target's objects.
include src/CMakeFiles/stf.dir/flags.make

src/CMakeFiles/stf.dir/main.cxx.o: src/CMakeFiles/stf.dir/flags.make
src/CMakeFiles/stf.dir/main.cxx.o: ../src/main.cxx
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/jinsu/Work_Fornax/VR/NH/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object src/CMakeFiles/stf.dir/main.cxx.o"
	cd /home/jinsu/Work_Fornax/VR/NH/build/src && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/stf.dir/main.cxx.o -c /home/jinsu/Work_Fornax/VR/NH/src/main.cxx

src/CMakeFiles/stf.dir/main.cxx.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/stf.dir/main.cxx.i"
	cd /home/jinsu/Work_Fornax/VR/NH/build/src && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/jinsu/Work_Fornax/VR/NH/src/main.cxx > CMakeFiles/stf.dir/main.cxx.i

src/CMakeFiles/stf.dir/main.cxx.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/stf.dir/main.cxx.s"
	cd /home/jinsu/Work_Fornax/VR/NH/build/src && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/jinsu/Work_Fornax/VR/NH/src/main.cxx -o CMakeFiles/stf.dir/main.cxx.s

# Object files for target stf
stf_OBJECTS = \
"CMakeFiles/stf.dir/main.cxx.o"

# External object files for target stf
stf_EXTERNAL_OBJECTS = \
"/home/jinsu/Work_Fornax/VR/NH/build/NBodylib/src/Analysis/CMakeFiles/Analysis.dir/Density.cxx.o" \
"/home/jinsu/Work_Fornax/VR/NH/build/NBodylib/src/Analysis/CMakeFiles/Analysis.dir/Morphology.cxx.o" \
"/home/jinsu/Work_Fornax/VR/NH/build/NBodylib/src/Analysis/CMakeFiles/Analysis.dir/Power.cxx.o" \
"/home/jinsu/Work_Fornax/VR/NH/build/NBodylib/src/Cosmology/CMakeFiles/Cosmology.dir/Cosmology.cxx.o" \
"/home/jinsu/Work_Fornax/VR/NH/build/NBodylib/src/InitCond/CMakeFiles/InitCond.dir/InitCond.cxx.o" \
"/home/jinsu/Work_Fornax/VR/NH/build/NBodylib/src/KDTree/CMakeFiles/KDTree.dir/KDCalcSmoothQuantities.cxx.o" \
"/home/jinsu/Work_Fornax/VR/NH/build/NBodylib/src/KDTree/CMakeFiles/KDTree.dir/KDFindNearest.cxx.o" \
"/home/jinsu/Work_Fornax/VR/NH/build/NBodylib/src/KDTree/CMakeFiles/KDTree.dir/KDFOF.cxx.o" \
"/home/jinsu/Work_Fornax/VR/NH/build/NBodylib/src/KDTree/CMakeFiles/KDTree.dir/KDLeafNode.cxx.o" \
"/home/jinsu/Work_Fornax/VR/NH/build/NBodylib/src/KDTree/CMakeFiles/KDTree.dir/KDSplitNode.cxx.o" \
"/home/jinsu/Work_Fornax/VR/NH/build/NBodylib/src/KDTree/CMakeFiles/KDTree.dir/KDTree.cxx.o" \
"/home/jinsu/Work_Fornax/VR/NH/build/NBodylib/src/Math/CMakeFiles/Math.dir/Coordinate2D.cxx.o" \
"/home/jinsu/Work_Fornax/VR/NH/build/NBodylib/src/Math/CMakeFiles/Math.dir/Coordinate.cxx.o" \
"/home/jinsu/Work_Fornax/VR/NH/build/NBodylib/src/Math/CMakeFiles/Math.dir/Fitting.cxx.o" \
"/home/jinsu/Work_Fornax/VR/NH/build/NBodylib/src/Math/CMakeFiles/Math.dir/GMatrix.cxx.o" \
"/home/jinsu/Work_Fornax/VR/NH/build/NBodylib/src/Math/CMakeFiles/Math.dir/Integrate.cxx.o" \
"/home/jinsu/Work_Fornax/VR/NH/build/NBodylib/src/Math/CMakeFiles/Math.dir/Interpolate.cxx.o" \
"/home/jinsu/Work_Fornax/VR/NH/build/NBodylib/src/Math/CMakeFiles/Math.dir/Matrix2D.cxx.o" \
"/home/jinsu/Work_Fornax/VR/NH/build/NBodylib/src/Math/CMakeFiles/Math.dir/Matrix.cxx.o" \
"/home/jinsu/Work_Fornax/VR/NH/build/NBodylib/src/Math/CMakeFiles/Math.dir/Random.cxx.o" \
"/home/jinsu/Work_Fornax/VR/NH/build/NBodylib/src/Math/CMakeFiles/Math.dir/SpecialFunctions.cxx.o" \
"/home/jinsu/Work_Fornax/VR/NH/build/NBodylib/src/Math/CMakeFiles/Math.dir/Statistics.cxx.o" \
"/home/jinsu/Work_Fornax/VR/NH/build/NBodylib/src/NBody/CMakeFiles/NBody.dir/Particle.cxx.o" \
"/home/jinsu/Work_Fornax/VR/NH/build/NBodylib/src/NBody/CMakeFiles/NBody.dir/System.cxx.o"

stf: src/CMakeFiles/stf.dir/main.cxx.o
stf: NBodylib/src/Analysis/CMakeFiles/Analysis.dir/Density.cxx.o
stf: NBodylib/src/Analysis/CMakeFiles/Analysis.dir/Morphology.cxx.o
stf: NBodylib/src/Analysis/CMakeFiles/Analysis.dir/Power.cxx.o
stf: NBodylib/src/Cosmology/CMakeFiles/Cosmology.dir/Cosmology.cxx.o
stf: NBodylib/src/InitCond/CMakeFiles/InitCond.dir/InitCond.cxx.o
stf: NBodylib/src/KDTree/CMakeFiles/KDTree.dir/KDCalcSmoothQuantities.cxx.o
stf: NBodylib/src/KDTree/CMakeFiles/KDTree.dir/KDFindNearest.cxx.o
stf: NBodylib/src/KDTree/CMakeFiles/KDTree.dir/KDFOF.cxx.o
stf: NBodylib/src/KDTree/CMakeFiles/KDTree.dir/KDLeafNode.cxx.o
stf: NBodylib/src/KDTree/CMakeFiles/KDTree.dir/KDSplitNode.cxx.o
stf: NBodylib/src/KDTree/CMakeFiles/KDTree.dir/KDTree.cxx.o
stf: NBodylib/src/Math/CMakeFiles/Math.dir/Coordinate2D.cxx.o
stf: NBodylib/src/Math/CMakeFiles/Math.dir/Coordinate.cxx.o
stf: NBodylib/src/Math/CMakeFiles/Math.dir/Fitting.cxx.o
stf: NBodylib/src/Math/CMakeFiles/Math.dir/GMatrix.cxx.o
stf: NBodylib/src/Math/CMakeFiles/Math.dir/Integrate.cxx.o
stf: NBodylib/src/Math/CMakeFiles/Math.dir/Interpolate.cxx.o
stf: NBodylib/src/Math/CMakeFiles/Math.dir/Matrix2D.cxx.o
stf: NBodylib/src/Math/CMakeFiles/Math.dir/Matrix.cxx.o
stf: NBodylib/src/Math/CMakeFiles/Math.dir/Random.cxx.o
stf: NBodylib/src/Math/CMakeFiles/Math.dir/SpecialFunctions.cxx.o
stf: NBodylib/src/Math/CMakeFiles/Math.dir/Statistics.cxx.o
stf: NBodylib/src/NBody/CMakeFiles/NBody.dir/Particle.cxx.o
stf: NBodylib/src/NBody/CMakeFiles/NBody.dir/System.cxx.o
stf: src/CMakeFiles/stf.dir/build.make
stf: src/libvelociraptor.a
stf: /home/jinsu/gsl/lib/libgsl.so
stf: /home/jinsu/gsl/lib/libgslcblas.so
stf: /usr/local/intel/compilers_and_libraries_2018.3.222/linux/mpi/intel64/lib/libmpicxx.so
stf: /usr/local/intel/compilers_and_libraries_2018.3.222/linux/mpi/intel64/lib/release_mt/libmpi.so
stf: /usr/local/intel/compilers_and_libraries_2018.3.222/linux/mpi/intel64/lib/libmpigi.a
stf: /usr/lib/x86_64-linux-gnu/libdl.so
stf: /usr/lib/x86_64-linux-gnu/librt.so
stf: /usr/lib/x86_64-linux-gnu/libpthread.so
stf: /home/jinsu/gsl/lib/libgsl.so
stf: /home/jinsu/gsl/lib/libgslcblas.so
stf: /usr/local/intel/compilers_and_libraries_2018.3.222/linux/mpi/intel64/lib/libmpicxx.so
stf: /usr/local/intel/compilers_and_libraries_2018.3.222/linux/mpi/intel64/lib/release_mt/libmpi.so
stf: /usr/local/intel/compilers_and_libraries_2018.3.222/linux/mpi/intel64/lib/libmpigi.a
stf: /usr/lib/x86_64-linux-gnu/libdl.so
stf: /usr/lib/x86_64-linux-gnu/librt.so
stf: /usr/lib/x86_64-linux-gnu/libpthread.so
stf: src/CMakeFiles/stf.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/jinsu/Work_Fornax/VR/NH/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable ../stf"
	cd /home/jinsu/Work_Fornax/VR/NH/build/src && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/stf.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
src/CMakeFiles/stf.dir/build: stf

.PHONY : src/CMakeFiles/stf.dir/build

src/CMakeFiles/stf.dir/clean:
	cd /home/jinsu/Work_Fornax/VR/NH/build/src && $(CMAKE_COMMAND) -P CMakeFiles/stf.dir/cmake_clean.cmake
.PHONY : src/CMakeFiles/stf.dir/clean

src/CMakeFiles/stf.dir/depend:
	cd /home/jinsu/Work_Fornax/VR/NH/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/jinsu/Work_Fornax/VR/NH /home/jinsu/Work_Fornax/VR/NH/src /home/jinsu/Work_Fornax/VR/NH/build /home/jinsu/Work_Fornax/VR/NH/build/src /home/jinsu/Work_Fornax/VR/NH/build/src/CMakeFiles/stf.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : src/CMakeFiles/stf.dir/depend

