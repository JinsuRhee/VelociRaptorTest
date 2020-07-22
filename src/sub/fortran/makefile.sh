h5fc -fopenmp -fPIC -c f_rdgal.f90 -o f_rdgal.o
h5cc -fopenmp -fPIC -c f_rdgal_c2f.c -o f_rdgal_c2f.o
h5cc -shared -fopenmp f_rdgal.o f_rdgal_c2f.o -o f_rdgal.so -lgfortran
