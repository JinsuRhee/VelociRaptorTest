gfortran -fopenmp -fPIC -c hilbert3d.f90 -o hilbert3d.o
gcc -fopenmp -fPIC -c hilbert3d_c2f.c -o hilbert3d_c2f.o
gcc -shared -fopenmp hilbert3d.o hilbert3d_c2f.o -o hilbert3d.so

