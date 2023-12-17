from libc.stdlib cimport malloc, free
from libc.stdio cimport printf

cdef int cython_function(int x):
    printf("cython_function: got value %d\n", x)
    return 2*x
